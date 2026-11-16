import * as React from "react";
import {
  ActivityIndicator,
  Image,
  StyleSheet,
  Text,
  TouchableOpacity,
  TouchableWithoutFeedback,
  View,
} from "react-native";

export type PaymentOptionModalContentProps = {
  closeModal: (() => void) | undefined;
  showBillGenerateMessage?: boolean;
  isLoading: boolean;
  onConfirmPress: () => void;
};

const _PaymentOptionModalContent: React.FC<PaymentOptionModalContentProps> = ({
  closeModal,
  isLoading,
  onConfirmPress,
  showBillGenerateMessage,
}) => {
  const [monthlyOption, setMonthlyOption] = React.useState(false);

  return (
    <TouchableWithoutFeedback onPress={closeModal}>
      <View style={styles.backdrop}>
        <TouchableWithoutFeedback>
          {showBillGenerateMessage ? (
            <View style={styles.content}>
              <View style={styles.generatingBill}>
                <ActivityIndicator size={"small"} color={"#2658A5"} />

                <Text style={[styles.headerText, { flex: undefined }]}>
                  Generating Monthly Bill
                </Text>
              </View>
            </View>
          ) : (
            <View style={styles.content}>
              <View style={styles.header}>
                <Text style={styles.headerText}>Confirm Payment Option</Text>

                <TouchableOpacity
                  onPress={closeModal}
                  disabled={isLoading}
                  style={[
                    styles.closeButton,
                    isLoading ? { opacity: 0.2 } : null,
                  ]}
                >
                  <Image
                    source={require("../../../assets/ic_close.png")}
                    style={{ height: 24, width: 24, resizeMode: "contain" }}
                  />
                </TouchableOpacity>
              </View>

              <View style={styles.divider} />

              <View style={{ padding: 12 }}>
                <Text style={styles.optionText}>
                  Do you want to select payment option as:
                </Text>

                <TouchableOpacity
                  style={[
                    {
                      flexDirection: "row",
                      alignItems: "center",
                      gap: 8,
                      alignSelf: "flex-start",
                      paddingRight: 40,
                      paddingVertical: 8,
                    },
                    isLoading ? { opacity: 0.5 } : null,
                  ]}
                  disabled={isLoading}
                  onPress={() => setMonthlyOption((value) => !value)}
                >
                  <Image
                    source={
                      monthlyOption
                        ? require("../../../assets/ic_checkbox_active.png")
                        : require("../../../assets/ic_checkbox_inactive.png")
                    }
                    style={{ height: 24, width: 24, resizeMode: "contain" }}
                  />

                  <Text style={styles.optionText}>Monthly</Text>
                </TouchableOpacity>

                <View
                  style={{
                    flexDirection: "row",
                    alignItems: "stretch",
                    justifyContent: "flex-end",
                    marginTop: 24,
                    gap: 12,
                  }}
                >
                  <TouchableOpacity
                    style={[
                      styles.cancelButton,
                      isLoading ? { opacity: 0.4 } : null,
                    ]}
                    onPress={closeModal}
                    disabled={isLoading}
                  >
                    <Text
                      style={styles.cancelButtonText}
                      maxFontSizeMultiplier={1.2}
                    >
                      Cancel
                    </Text>
                  </TouchableOpacity>

                  <TouchableOpacity
                    style={styles.confirmButton}
                    disabled={!monthlyOption || isLoading}
                    onPress={onConfirmPress}
                  >
                    <View style={styles.confirmButtonTextWrapper}>
                      <Text
                        style={[
                          styles.confirmButtonText,
                          { opacity: isLoading ? 0 : 1 },
                          { color: monthlyOption ? "#2658A5" : "#6A9CE9" },
                        ]}
                        maxFontSizeMultiplier={1.2}
                      >
                        Confirm
                      </Text>

                      {isLoading ? (
                        <ActivityIndicator
                          size={"small"}
                          color={"#2658A5"}
                          style={styles.loader}
                        />
                      ) : null}
                    </View>
                  </TouchableOpacity>
                </View>
              </View>
            </View>
          )}
        </TouchableWithoutFeedback>
      </View>
    </TouchableWithoutFeedback>
  );
};

const styles = StyleSheet.create({
  backdrop: {
    flex: 1,
    backgroundColor: "rgba(0, 0, 0, 0.3)", // dimming background
    justifyContent: "center",
  },
  content: {
    margin: 16,
    borderRadius: 8,
    overflow: "hidden",
    backgroundColor: "#ffffff",
  },
  generatingBill: {
    alignItems: "center",
    padding: 28,
    gap: 16,
  },
  header: {
    flexDirection: "row",
    paddingHorizontal: 16,
    paddingVertical: 12,
    alignItems: "center",
    justifyContent: "space-between",
  },
  headerText: {
    flex: 1,
    fontSize: 17,
    lineHeight: 17 * 1.5,
    fontWeight: "500",
    color: "#323232",
    fontFamily: "Georgia.ttf",
  },
  optionText: {
    fontSize: 16,
    lineHeight: 16 * 1.5,
    color: "#323232",
    fontFamily: "Georgia.ttf",
  },
  closeButton: {
    alignItems: "center",
    justifyContent: "center",
    width: 28,
    height: 28,
  },
  closeBottonText: {
    fontSize: 16,
    lineHeight: 16 * 1.5,
    fontWeight: "600",
    color: "#007AFF",
    fontFamily: "Georgia.ttf",
  },
  divider: {
    height: StyleSheet.hairlineWidth,
    width: "100%",
    backgroundColor: "#343434",
  },
  activeColor: {
    color: "#043683",
  },
  cancelButton: {
    paddingVertical: 8,
    paddingHorizontal: 12,
    borderRadius: 4,
    borderColor: "#343434",
    borderWidth: 1,
    alignItems: "center",
    justifyContent: "center",
  },
  cancelButtonText: {
    fontSize: 16,
    lineHeight: 16 * 1.5,
    fontWeight: "500",
    color: "#000000",
  },
  confirmButton: {
    paddingVertical: 8,
    paddingHorizontal: 12,
    borderRadius: 4,
  },
  confirmButtonTextWrapper: {
    position: "relative",
    // flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
  },
  confirmButtonText: {
    fontSize: 16,
    lineHeight: 16 * 1.5,
    fontWeight: "500",
    color: "#ffffff",
  },
  loader: {
    flex: 1,
    position: "absolute",
    alignSelf: "center",
  },
});

export const PaymentOptionModalContent = React.memo(_PaymentOptionModalContent);
