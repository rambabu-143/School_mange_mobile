import * as React from "react";
import {
  Image,
  StyleProp,
  StyleSheet,
  Text,
  View,
  ViewStyle,
} from "react-native";

import { Card } from "../../Card";
import type { InstallmentData } from "../../../queries/useBillQuery";
import { indianNumberFormatter } from "../../../utils/indianNumberFormatter";
import { useGlobalStore } from "../../../stores/global-store";

export type InstallmentCardProps = {
  data: InstallmentData;
  previousDue?: number | string | null;
  style?: StyleProp<ViewStyle>;
  onPress?: (installment: InstallmentData) => void;
};

const _InstallmentCard: React.FC<InstallmentCardProps> = ({
  data,
  style,
  previousDue,
  onPress,
}) => {
  const isUserSelected = useGlobalStore((state) =>
    data.inst_no ? state.selectedInstallments[data.inst_no] : false
  );

  const isSelected = data.installment_type === "CURRENT" || isUserSelected;

  const disabled =
    data.installment_type === "CURRENT" || data.installment_type === "PAST";

  const disabledUI =
    data.installment_type === "PAST" ||
    (data.installment_type === "CURRENT" &&
      (!data.amount_payble || data.amount_payble <= 0));

  const totalReceived = data.recived
    ? data.recived
        .toString()
        .split("\n")
        .filter((amt) => !!amt)
        .reduce((acc, curr) => acc + parseFloat(curr?.trim?.()), 0)
    : null;

  const totalFine =
    data.fine_installment ||
    (data.fine
      ? data.fine
          .toString()
          .split("\n")
          .filter((amt) => !!amt)
          .reduce((acc, curr) => acc + parseFloat(curr?.trim?.()), 0)
      : null);

  return (
    <Card
      touchable={true}
      activeOpacity={0.55}
      disabled={disabled}
      onPress={() => onPress?.(data)}
      style={StyleSheet.flatten([
        styles.container,
        disabledUI ? styles.disabled : null,
        style,
      ])}
    >
      <View
        style={{
          flexDirection: "row",
          gap: 12,
          alignItems: "flex-start",
          justifyContent: "space-between",
        }}
      >
        <View style={{ flexShrink: 1, flexDirection: "row", gap: 12 }}>
          <Image
            source={
              isSelected
                ? require("../../../assets/ic_checkbox_active.png")
                : data.installment_type === "PAST"
                ? require("../../../assets/ic_checkbox_indeterminate.png")
                : require("../../../assets/ic_checkbox_inactive.png")
            }
            style={[styles.checkboxImage, disabledUI ? { opacity: 0.5 } : null]}
          />

          <Text
            maxFontSizeMultiplier={1.1}
            style={[
              styles.installment,
              { flex: 1 },
              disabledUI ? { opacity: 0.7 } : null,
            ]}
          >
            {data.inst_no}
          </Text>
        </View>

        <View style={{ flexDirection: "row", gap: 12 }}>
          <View style={{ alignItems: "flex-end", gap: 2 }}>
            {previousDue ? (
              <Text
                maxFontSizeMultiplier={1.1}
                style={[styles.amountText, styles.previousDue]}
              >
                Previous Dues
              </Text>
            ) : null}
            <Text maxFontSizeMultiplier={1.1} style={styles.amountText}>
              Amount
            </Text>
            {totalFine ? (
              <Text maxFontSizeMultiplier={1.1} style={styles.amountText}>
                Fine
              </Text>
            ) : null}
            {totalReceived ? (
              <Text maxFontSizeMultiplier={1.1} style={styles.amountText}>
                Total Received
              </Text>
            ) : null}
            <Text maxFontSizeMultiplier={1.1} style={styles.amountText}>
              Amount Due
            </Text>
          </View>

          <View style={{ gap: 2 }}>
            {previousDue ? (
              <Text
                maxFontSizeMultiplier={1.1}
                style={[styles.amountText, styles.previousDue]}
              >
                =
              </Text>
            ) : null}
            <Text maxFontSizeMultiplier={1.1} style={styles.amountText}>
              =
            </Text>
            {totalReceived ? (
              <Text maxFontSizeMultiplier={1.1} style={styles.amountText}>
                =
              </Text>
            ) : null}
            {totalFine ? (
              <Text maxFontSizeMultiplier={1.1} style={styles.amountText}>
                =
              </Text>
            ) : null}
            <Text maxFontSizeMultiplier={1.1} style={styles.amountText}>
              =
            </Text>
          </View>

          <View style={{ alignItems: "flex-end", gap: 2 }}>
            {previousDue ? (
              <Text
                maxFontSizeMultiplier={1.1}
                style={[styles.amountText, styles.previousDue]}
              >
                {indianNumberFormatter(previousDue)}
              </Text>
            ) : null}

            <Text maxFontSizeMultiplier={1.1} style={styles.amountText}>
              {data.amount ? indianNumberFormatter(data.amount) : "-"}
            </Text>

            {totalFine ? (
              <Text
                maxFontSizeMultiplier={1.1}
                style={[styles.amountText, styles.fine]}
              >
                {indianNumberFormatter(totalFine)}
              </Text>
            ) : null}

            {totalReceived ? (
              <View
                style={{ height: 1, width: "100%", backgroundColor: "gray" }}
              />
            ) : null}

            {totalReceived ? (
              <Text
                maxFontSizeMultiplier={1.1}
                style={[styles.amountText, styles.received]}
              >
                {indianNumberFormatter(totalReceived)}
              </Text>
            ) : null}

            <View
              style={{ height: 1, width: "100%", backgroundColor: "gray" }}
            />

            <Text
              maxFontSizeMultiplier={1.1}
              style={[
                styles.amountText,
                data.amount_payble &&
                ["CURRENT", "PAST"].includes(data.installment_type || "")
                  ? styles.amountDue
                  : null,
              ]}
            >
              {indianNumberFormatter(data.amount_payble || 0)}
            </Text>
          </View>
        </View>
      </View>
    </Card>
  );
};

const styles = StyleSheet.create({
  container: {
    flexGrow: 1,
    padding: 12,
    borderRadius: 8,
    backgroundColor: "#ffffff",

    shadowColor: "#000000",
    shadowRadius: 2,
    shadowOffset: { height: 0.7, width: 0 },
    shadowOpacity: 0.07,
    elevation: 2,
  },
  disabled: {
    backgroundColor: "#ffffff",
    opacity: 0.6,
    shadowColor: undefined,
    shadowRadius: undefined,
    shadowOffset: undefined,
    shadowOpacity: undefined,
    elevation: undefined,
  },
  checkboxImage: {
    width: 24,
    height: 24,
    resizeMode: "contain",
  },
  installment: {
    fontSize: 16,
    fontWeight: "600",
    lineHeight: 16 * 1.5,
    color: "#000000",
    textTransform: "capitalize",
  },
  amountText: {
    fontSize: 16,
    fontWeight: "400",
    lineHeight: 16 * 1.5,
    color: "#000000",
  },
  received: {
    color: "#308234", // #2E7D32
  },
  previousDue: {
    color: "#FF9500", // #F57C00
  },
  fine: {
    color: "#D32F2F",
  },
  amountDue: {
    color: "#FF3B30",
  },
});

export const InstallmentCard = React.memo(_InstallmentCard);
