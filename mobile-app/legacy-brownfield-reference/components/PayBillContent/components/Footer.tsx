import { BlurView } from "@react-native-community/blur";
import * as React from "react";
import {
  ActivityIndicator,
  Alert,
  Animated,
  Image,
  Platform,
  StyleSheet,
  Text,
  TextInput,
  TouchableHighlight,
  TouchableOpacity,
  useAnimatedValue,
  View,
} from "react-native";
import RazorpayCheckout from "react-native-razorpay";
import Toast from "react-native-toast-message";
import { SafeAreaView } from "react-native-safe-area-context";

import type { PayBillScreenParams } from "../../../types";
import type { InstallmentData } from "../../../queries/useBillQuery";
import { useBillQuery } from "../../../queries/useBillQuery";
import { indianNumberFormatter } from "../../../utils/indianNumberFormatter";
import { useGlobalStore } from "../../../stores/global-store";
import { useCreateOrderMutation } from "../../../queries/useCreateOrderMutation";
import type { CreateOrderData } from "../../../queries/useCreateOrderMutation";

export type FooterProps = {
  params?: PayBillScreenParams;
};

const _Footer: React.FC<FooterProps> = ({ params }) => {
  const shakeAnimatedValue = useAnimatedValue(0);
  const userSelectedInstallmentTypes = useGlobalStore(
    (state) => state.selectedInstallments
  );
  const [personalExpAmount, setPersonalExpAmount] = React.useState("");
  const deffPersonalExpAmount = React.useDeferredValue(personalExpAmount);
  const [allowPersonalExp, setAllowPersonalExp] = React.useState(false);
  const billQuery = useBillQuery({
    token: params?.token,
    type: params?.type,
    studentOrStaffId:
      params?.userType === "member" ? params?.studentId : params?.staffId,
    userType: params?.userType === "member" ? "student" : "staff",
  });
  const createOrderMutation = useCreateOrderMutation({
    token: params?.token,
    type: params?.type,
    userType: params?.userType,
  });
  const setPaymentSuccessData = useGlobalStore.getState().setPaymentSuccessData;
  const setOrderDetails = useGlobalStore.getState().setOrderDetails;

  const isTransportBill = params?.type === "transport";

  const billData =
    params?.type === "transport"
      ? billQuery.data?.data?.transport_bill_id
      : params?.type === "hostel"
      ? billQuery.data?.data?.hostel_bill_id
      : billQuery.data?.data?.fee_bill_id;

  const installments = billData?.installment;

  //#region side-effect for amount updation
  const startShake = () => {
    shakeAnimatedValue.resetAnimation();
    Animated.sequence([
      Animated.timing(shakeAnimatedValue, {
        toValue: -4,
        duration: 8,
        useNativeDriver: true,
      }),
      Animated.timing(shakeAnimatedValue, {
        toValue: 4,
        duration: 8,
        useNativeDriver: true,
      }),
      Animated.timing(shakeAnimatedValue, {
        toValue: -4,
        duration: 8,
        useNativeDriver: true,
      }),
      Animated.timing(shakeAnimatedValue, {
        toValue: 0,
        duration: 8,
        useNativeDriver: true,
      }),
    ]).start();
  };

  const pocketMoney =
    params?.type === "hostel" && allowPersonalExp && deffPersonalExpAmount
      ? parseFloat(deffPersonalExpAmount)
      : undefined;

  const additionalAmt = pocketMoney;

  const prevAmountRef = React.useRef<number | null>(null);

  const amount = React.useMemo(() => {
    if (!Array.isArray(installments)) return 0;

    const selectedInstallments = installments.filter((installment) => {
      return (
        (!!installment.installment_type &&
          installment.installment_type === "CURRENT") ||
        (!!installment.inst_no &&
          userSelectedInstallmentTypes[installment.inst_no])
      );
    });

    if (isTransportBill) {
      // For transport bill, only the amount payable of the last installment is considered as it contains the total amount including previous dues.
      const lastSelectedInstallment =
        getLastSelectedInstallment(selectedInstallments);
      return (
        (additionalAmt || 0) + (lastSelectedInstallment?.amount_payble || 0)
      );
    }

    return (
      (additionalAmt || 0) +
      selectedInstallments.reduce(
        (acc, curr) => acc + (curr?.amount_payble || 0),
        0
      )
    );
  }, [
    additionalAmt,
    installments,
    userSelectedInstallmentTypes,
    isTransportBill,
  ]);

  if (prevAmountRef.current !== null && prevAmountRef.current !== amount) {
    startShake();
  }
  prevAmountRef.current = amount;
  //#endregion side-effect for amount updation

  const submitLoading = createOrderMutation.isPending;

  const handleSubmitPress = async () => {
    try {
      const admissionNo = billQuery?.data?.data?.admission_no;
      if (params?.userType === "member" && !admissionNo) {
        return Toast.show({
          type: "error",
          text1: "Admission number is invalid!",
          position: "bottom",
        });
      }
      const installmentNo = installments?.find(
        (installment) => installment.installment_type === "CURRENT"
      )?.inst_no;
      if (!installmentNo) {
        return Toast.show({
          type: "error",
          text1: "Installment number is invalid!",
          position: "bottom",
        });
      }
      const data = await createOrderMutation.mutateAsync({
        admission_no: admissionNo,
        pocket_money: pocketMoney,
        //@ts-ignore
        staff_id: params?.staffId,
        //@ts-ignore
        transport_id: billQuery.data?.data?.transport_id,
        installment_no: installmentNo,
        pay_by: "app",
        amount,
      });
      const description = `${branchNameFromSchoolCode(
        billData?.school_code || ""
      )} ${
        params?.type
          ? params.type.charAt(0).toUpperCase() + params.type.slice(1)
          : ""
      } Fee`;

      if (data) {
        setOrderDetails({
          amount: data.amount_due ? data.amount_due / 100 : amount,
          description,
          orderId: data.id || "",
          userId: admissionNo,
          userIdLabel: admissionNo ? "Admission No." : undefined,
        });
        razorpayCheckout(data, {
          description,
          prefill: {
            email: params?.userEmail,
            contact:
              billData?.mobile_no || billQuery.data?.data?.mobile || undefined,
            name: billData?.name || billQuery.data?.data?.name || undefined,
          },
        });
      }
    } catch (error) {
      console.warn(error);
    }
  };

  const razorpayCheckout = async (
    createOrderData: CreateOrderData,
    options?: {
      description?: string;
      prefill?: {
        email?: string;
        contact?: string;
        name?: string;
      };
    }
  ) => {
    try {
      const checkoutOptions = {
        description: options?.description || "",
        image:
          "https://mountcarmelschool.com/wp-content/uploads/2020/02/Logo-MCS-24-April-2024.png",
        currency: createOrderData.currency || "INR",
        key: createOrderData.key,
        amount: createOrderData.amount_due || createOrderData.amount, // This is in currency subunits. 100 = 100 paise= INR 1.
        name: "Mount Carmel School",
        order_id: createOrderData.id,
        prefill: options?.prefill,
        theme: { color: "#2658A5" },
        modal: {
          confirm_close: true,
        },
      };
      // console.log(
      //   "$ Open Razorpay Checkout with data -> ",
      //   JSON.stringify(checkoutOptions, null, 2)
      // );
      const data = await RazorpayCheckout.open(checkoutOptions);
      // console.log("Checkout success data -> ", JSON.stringify(data, null, 2));
      setPaymentSuccessData(data);
    } catch (error) {
      // console.log(error);
      const codeDescription = getErrorCodeDescription(error.code);
      let description = error.description;
      if (Platform.OS === "android") {
        try {
          const data = JSON.parse(description);
          const errorDescription =
            data?.error?.description === "undefined" ||
            !data?.error?.description
              ? data?.error?.code || data?.error?.reason
              : data?.error?.description;
          if (errorDescription) {
            description = errorDescription;
          }
        } catch (error) {}
      }
      Alert.alert(codeDescription, description);
      Toast.show({
        type: "error",
        text1: codeDescription,
        text2: description,
        topOffset: 100,
        position: "top",
      });
    }
  };

  const payableAmount = React.useMemo(() => {
    if (!amount) return null;
    return indianNumberFormatter(amount);
  }, [amount]);

  const isPaid = amount <= 0;

  const checkoutDisabled = payableAmount === null || false;

  return (
    <View style={styles.container}>
      {params?.type === "hostel" ? (
        <View
          style={{
            padding: 16,
            backgroundColor: "#f0f0f0",
            borderTopColor: "#000000",
            borderTopWidth: StyleSheet.hairlineWidth,

            flexDirection: "row",
            gap: 16,
            alignItems: "center",
            justifyContent: "space-between",
          }}
        >
          <TouchableOpacity
            style={{ flexDirection: "row", gap: 12 }}
            onPress={() => setAllowPersonalExp((value) => !value)}
          >
            <Image
              source={
                allowPersonalExp
                  ? require("../../../assets/ic_checkbox_active.png")
                  : require("../../../assets/ic_checkbox_inactive.png")
              }
              style={[
                styles.checkboxImage,
                {
                  tintColor: allowPersonalExp ? undefined : "#676767",
                },
              ]}
            />

            <Text maxFontSizeMultiplier={1} style={styles.installment}>
              Personal{"\n"}Expenses
            </Text>
          </TouchableOpacity>

          <View
            style={{
              flex: 1,
              flexDirection: "row",
              gap: 12,
              alignItems: "center",
            }}
          >
            <Text
              maxFontSizeMultiplier={1}
              style={[
                styles.amountText,
                { opacity: allowPersonalExp ? 1 : 0.5 },
              ]}
            >
              Amount
            </Text>

            <Text
              style={[
                styles.amountText,
                { opacity: allowPersonalExp ? 1 : 0.5 },
              ]}
              maxFontSizeMultiplier={1}
            >
              =
            </Text>

            <TextInput
              maxFontSizeMultiplier={1.1}
              value={personalExpAmount}
              placeholder="Enter Amount"
              keyboardType="numeric"
              clearTextOnFocus={true}
              editable={allowPersonalExp}
              returnKeyType="done"
              onChangeText={(value) => {
                if (/^\d{0,9}(\.\d{0,2})?$/.test(value) || value === "") {
                  setPersonalExpAmount(value);
                }
              }}
              style={[
                styles.amountText,
                {
                  flex: 1,
                  borderBottomColor: allowPersonalExp ? "#343434" : "#676767",
                  borderBottomWidth: 1,
                  paddingVertical: 12,
                  paddingHorizontal: 4,
                  textAlign: "right",
                  opacity: allowPersonalExp ? 1 : 0.5,
                },
              ]}
            />
          </View>
        </View>
      ) : null}

      {/* Footer */}
      <BlurView style={{ flex: 1 }} blurType="light">
        <SafeAreaView
          style={styles.content}
          edges={["right", "bottom", "left"]}
        >
          {isPaid ? (
            <Text maxFontSizeMultiplier={1.1} style={styles.paid}>
              Your dues are paid ✅
            </Text>
          ) : (
            <>
              <Text
                style={styles.describe}
                maxFontSizeMultiplier={1.1}
                numberOfLines={2}
              >
                Total Payable{"\n"}Amount
              </Text>

              <Animated.View
                style={[
                  {
                    transform: [{ translateX: shakeAnimatedValue }],
                  },
                ]}
              >
                <TouchableHighlight
                  style={[
                    styles.payButton,
                    {
                      backgroundColor: checkoutDisabled ? "#6A9CE9" : "#2658A5",
                    },
                  ]}
                  disabled={checkoutDisabled}
                  underlayColor={styles.activeColor.color}
                  onPress={handleSubmitPress}
                >
                  <View style={styles.payButtonTextWrapper}>
                    {payableAmount ? (
                      <View
                        style={{
                          flexDirection: "row",
                          gap: 12,
                          alignItems: "center",
                          opacity: submitLoading ? 0 : 1,
                        }}
                      >
                        <Text
                          style={[styles.payButtonText, { fontWeight: "400" }]}
                          maxFontSizeMultiplier={1.1}
                        >
                          Pay
                        </Text>

                        <Text
                          style={styles.payButtonText}
                          maxFontSizeMultiplier={1.1}
                        >
                          {payableAmount}
                        </Text>

                        <Image src="back" style={styles.leftIconImage} />
                      </View>
                    ) : (
                      <Text
                        style={[
                          styles.payButtonText,
                          { opacity: submitLoading ? 0 : 1 },
                        ]}
                        maxFontSizeMultiplier={1.2}
                      >
                        Select Installment
                      </Text>
                    )}

                    {submitLoading ? (
                      <ActivityIndicator
                        size={"small"}
                        color={"#ffffff"}
                        style={styles.loader}
                      />
                    ) : null}
                  </View>
                </TouchableHighlight>
              </Animated.View>
            </>
          )}
        </SafeAreaView>
      </BlurView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    position: "absolute",
    width: "100%",
    bottom: 0,
  },
  checkboxImage: {
    width: 24,
    height: 24,
    resizeMode: "contain",
  },
  amountText: {
    fontSize: 16,
    fontWeight: "400",
    lineHeight: 16 * 1.5,
    color: "#000000",
  },
  installment: {
    fontSize: 16,
    fontWeight: "600",
    lineHeight: 16 * 1.5,
    color: "#000000",
    textTransform: "capitalize",
  },
  content: {
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderTopColor: "#000000",
    borderTopWidth: StyleSheet.hairlineWidth,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    gap: 12,
  },
  describe: {
    fontSize: 15,
    lineHeight: 15 * 1.5,
    color: "#000000",
  },
  paid: {
    flex: 1,
    fontSize: 17,
    lineHeight: 17 * 1.5,
    fontWeight: "bold",
    color: "#308234",
    textAlign: "center",
  },
  leftIconImage: {
    width: 16,
    height: 16,
    resizeMode: "contain",
    tintColor: "#ffffff",
    transform: [{ rotateZ: "180deg" }],
  },
  loader: {
    flex: 1,
    position: "absolute",
    alignSelf: "center",
  },
  payButton: {
    alignSelf: "flex-end",
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 4,
  },
  payButtonTextWrapper: {
    position: "relative",
    alignItems: "center",
  },
  payButtonText: {
    fontSize: 17,
    lineHeight: 17 * 1.5,
    fontWeight: "bold",
    color: "#ffffff",
  },
  activeColor: {
    color: "#043683",
  },
});

export const Footer = React.memo(_Footer);

function getErrorCodeDescription(code: number | string) {
  switch (code) {
    case 0:
    case "0":
      return "Error!";
    case 1:
    case "1":
      return "Invalid Options passed to Payment Gateway!";
    case 2:
    case "2":
      return "Payment Cancelled!";
    case 3:
    case "3":
      return "Unsupported TLS used!";

    default:
      return "Unexpected Error!";
  }
}

function branchNameFromSchoolCode(schoolCode: string): string {
  switch (schoolCode) {
    case "ANSR":
    case "ANJR":
      return "Anand Niketan";

    case "DWSR":
    case "DWJR":
      return "Dwarka";

    case "GMSR":
    case "GMJR":
      return "Gurugram";

    default:
      return "";
  }
}

function getLastSelectedInstallment(
  selectedInstallments: InstallmentData[]
): InstallmentData | undefined {
  let lastInstallmentIndex = 0;
  let lastInstallmentNo: string | null = null;

  selectedInstallments.forEach((installment, index) => {
    if (!installment.inst_no) return;
    if (lastInstallmentNo === null) {
      lastInstallmentNo = installment.inst_no;
      lastInstallmentIndex = index;
      return;
    }
    if (greaterThan(installment.inst_no, lastInstallmentNo)) {
      lastInstallmentIndex = index;
      lastInstallmentNo = installment.inst_no;
    }
  });

  return selectedInstallments[lastInstallmentIndex];
}

function greaterThan(instNo1: string, instNo2: string) {
  const installmentNumberMapping = {
    FIRST: 1,
    SECOND: 2,
    THIRD: 3,
    FOURTH: 4,
    FIFTH: 5,
    SIXTH: 6,
    SEVENTH: 7,
    EIGHTH: 8,
    NINTH: 9,
    TENTH: 10,
    ELEVENTH: 11,
    TWELFTH: 12,
  };
  return installmentNumberMapping[instNo1] > installmentNumberMapping[instNo2];
}
