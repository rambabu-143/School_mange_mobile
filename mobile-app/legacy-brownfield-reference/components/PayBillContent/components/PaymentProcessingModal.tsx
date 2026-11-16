import * as React from "react";
import {
  ActivityIndicator,
  Image,
  Modal,
  StyleSheet,
  Text,
  TouchableHighlight,
  TouchableOpacity,
  View,
} from "react-native";
import { trigger } from "react-native-haptic-feedback";
import LottieView from "lottie-react-native";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";

import { ThemedText } from "../../ThemedText";
import type { PayBillScreenParams } from "../../../types";
import { backToNativeApp } from "../../../utils/backToNativeApp";
import { useGlobalStore } from "../../../stores/global-store";
import { indianNumberFormatter } from "../../../utils/indianNumberFormatter";
import { useVerifyPaymentMutation } from "../../../queries/useVerifyPaymentMutation";

export type PaymentProcessingModalProps = {
  params?: PayBillScreenParams;
};

const _PaymentProcessingModal: React.FC<PaymentProcessingModalProps> = ({
  params,
}) => {
  const paymentSuccessData = useGlobalStore(
    (state) => state.paymentSuccessData
  );
  const orderId = useGlobalStore((state) => state.orderDetails?.orderId);
  const [retryDone, setRetryDone] = React.useState(false);

  const verifyPaymentMutation = useVerifyPaymentMutation({
    token: params?.token,
    type: params?.type,
    userType: params?.userType,
  });

  const verifyPayment = React.useCallback(() => {
    if (paymentSuccessData === null || !orderId) {
      return;
    }
    verifyPaymentMutation.mutate({
      razorpay_order_id: paymentSuccessData.razorpay_order_id,
      razorpay_payment_id: paymentSuccessData.razorpay_payment_id,
      razorpay_signature: paymentSuccessData.razorpay_signature,
      server_order_id: orderId,
    });
  }, [paymentSuccessData, orderId]);

  const reverifyPayment = React.useCallback(() => {
    setRetryDone(true);
    verifyPayment();
  }, [verifyPayment]);

  React.useEffect(() => {
    verifyPayment();
  }, [verifyPayment]);

  return (
    <Modal
      animationType="none"
      transparent={false}
      visible={paymentSuccessData !== null}
      statusBarTranslucent={false}
    >
      <SafeAreaProvider>
        <View
          style={{
            flex: 1,
            backgroundColor: "#efefef",
            justifyContent: "center",
          }}
        >
          {verifyPaymentMutation.isPending ? <VerifyingState /> : null}

          {verifyPaymentMutation.isSuccess ? <SuccessState /> : null}

          {verifyPaymentMutation.isError ? (
            <FailedState
              retryDone={retryDone}
              error={verifyPaymentMutation.error}
              onRetryPress={reverifyPayment}
            />
          ) : null}
        </View>
      </SafeAreaProvider>
    </Modal>
  );
};

const styles = StyleSheet.create({
  successState: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    gap: 40,
  },
  successLottieView: {},
  payButton: {
    paddingVertical: 12,
    paddingHorizontal: 24,
    borderRadius: 6,
    backgroundColor: "#3774d1",
  },
  payButtonText: {
    fontSize: 17,
    lineHeight: 17 * 1.5,
    fontWeight: "bold",
    color: "#ffffff",
  },
  activeColor: {
    color: "#0545a7",
  },
  leftIconImage: {
    width: 16,
    height: 16,
    resizeMode: "contain",
    tintColor: "#ffffff",
    transform: [{ rotateZ: "180 deg" }],
  },
  //
  verifyingState: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    gap: 16,
    paddingHorizontal: 24,
    position: "relative",
  },
  verifyingText: {
    fontSize: 17,
    lineHeight: 17 * 1.5,
    color: "#000000",
    fontWeight: "500",
  },
  stayOnPageText: {
    position: "absolute",
    bottom: 60,
    fontSize: 16,
    lineHeight: 16 * 1.5,
    color: "#000000",
    fontWeight: "400",
    fontStyle: "italic",
    textAlign: "center",
  },
  //
  closeButton: {
    paddingVertical: 8,
    paddingHorizontal: 28,
    borderRadius: 4,
    borderColor: "#343434",
    borderWidth: 1,
    alignItems: "center",
    justifyContent: "center",
  },
  closeButtonText: {
    fontSize: 16,
    lineHeight: 16 * 1.5,
    fontWeight: "500",
    color: "#000000",
  },
});

export const PaymentProcessingModal = React.memo(_PaymentProcessingModal);

const SuccessState = () => {
  const orderDetails = useGlobalStore((state) => state.orderDetails);
  const paymentSuccessData = useGlobalStore((state) => state.paymentSuccessData);

  React.useEffect(() => {
    const timeoutId = setTimeout(() => {
      trigger("notificationSuccess", {
        enableVibrateFallback: true,
        ignoreAndroidSystemSettings: false,
      });
    }, 800);

    return () => clearTimeout(timeoutId);
  }, []);

  return (
    <SafeAreaView style={styles.successState} mode="margin">
      <TouchableOpacity
        style={{ position: "absolute", top: 12, left: 20 }}
        onPress={backToNativeApp}
      >
        <Image
          source={require("../../../assets/ic_close.png")}
          style={{ width: 24, height: 24, resizeMode: "contain" }}
        />
      </TouchableOpacity>

      <View style={{ alignItems: "center" }}>
        <LottieView
          source={require("../../../assets/success-check.lottie")}
          loop={false}
          autoPlay={true}
          enableSafeModeAndroid={true}
          resizeMode="contain"
          style={{
            width: 120,
            height: 120,
          }}
        />

        <ThemedText type="title">
          {indianNumberFormatter(orderDetails?.amount || 0)}
        </ThemedText>

        <ThemedText type="defaultSemiBold">Payment successful!</ThemedText>
      </View>

      <ThemedText>
        Txn Id: <Text>{paymentSuccessData?.razorpay_payment_id}</Text>
      </ThemedText>

      {orderDetails?.userIdLabel ? (
        <ThemedText>
          {orderDetails?.userIdLabel}: <Text>{orderDetails?.userId}</Text>
        </ThemedText>
      ) : null}

      <TouchableHighlight
        style={styles.payButton}
        underlayColor={styles.activeColor.color}
        onPress={backToNativeApp}
      >
        <Text style={styles.payButtonText} maxFontSizeMultiplier={1.2}>
          Continue
        </Text>
      </TouchableHighlight>
    </SafeAreaView>
  );
};

const VerifyingState = () => {
  return (
    <View style={styles.verifyingState}>
      <ActivityIndicator size={"large"} color={"#007AFF"} />

      <Text style={styles.verifyingText}>Verifying payment... Please wait</Text>

      <Text style={styles.stayOnPageText}>
        Please stay on this screen while we process your payment!
      </Text>
    </View>
  );
};

const FailedState = ({ retryDone, onRetryPress, error }) => {
  const orderDetails = useGlobalStore((state) => state.orderDetails);
  const paymentSuccessData = useGlobalStore((state) => state.paymentSuccessData);

  React.useEffect(() => {
    const timeoutId = setTimeout(() => {
      trigger("notificationError", {
        enableVibrateFallback: true,
        ignoreAndroidSystemSettings: false,
      });
    }, 800);

    return () => clearTimeout(timeoutId);
  }, []);

  console.warn(error);

  return (
    <SafeAreaView style={styles.successState} mode="margin">
      <View style={{ alignItems: "center", gap: 8 }}>
        <LottieView
          source={require("../../../assets/failure-cross.lottie")}
          loop={false}
          autoPlay={true}
          enableSafeModeAndroid={true}
          resizeMode="contain"
          style={{
            width: 120,
            height: 120,
          }}
        />

        <ThemedText type="title">
          {indianNumberFormatter(orderDetails?.amount || 0)}
        </ThemedText>

        <ThemedText
          type="defaultSemiBold"
          numberOfLines={3}
          style={{ textAlign: "center", fontSize: 17 }}
        >
          Payment verification failed.{"\n"}
          <Text
            style={{ fontStyle: "italic", fontWeight: "500", color: "#FF3B30" }}
          >
            {error?.message}
          </Text>
        </ThemedText>
      </View>

      <ThemedText>
        Txn Id: <Text>{paymentSuccessData?.razorpay_payment_id}</Text>
      </ThemedText>

      {orderDetails?.userIdLabel ? (
        <ThemedText>
          {orderDetails?.userIdLabel}: {orderDetails?.userId}
        </ThemedText>
      ) : null}

      <View style={{ gap: 20 }}>
        <TouchableHighlight
          style={styles.payButton}
          underlayColor={styles.activeColor.color}
          onPress={retryDone ? backToNativeApp : onRetryPress}
        >
          <Text style={styles.payButtonText} maxFontSizeMultiplier={1.2}>
            {retryDone ? "Close" : "Retry Verification"}
          </Text>
        </TouchableHighlight>

        {retryDone ? null : (
          <TouchableOpacity
            style={styles.closeButton}
            onPress={backToNativeApp}
          >
            <Text style={styles.closeButtonText}>Close</Text>
          </TouchableOpacity>
        )}
      </View>
    </SafeAreaView>
  );
};
