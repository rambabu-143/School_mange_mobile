import * as React from "react";
import { Platform, StyleSheet, Text, View } from "react-native";
import { trigger } from "react-native-haptic-feedback";

import { InstallmentCard } from "./InstallmentCard";
import type { PayBillScreenParams } from "../../../types";
import type { InstallmentData } from "../../../queries/useBillQuery";
import { useBillQuery } from "../../../queries/useBillQuery";
import { useGlobalStore } from "../../../stores/global-store";

export type InstallmentsProps = {
  params?: PayBillScreenParams;
};

const _Installments: React.FC<InstallmentsProps> = ({ params }) => {
  const billQuery = useBillQuery({
    token: params?.token,
    type: params?.type,
    studentOrStaffId:
      params?.userType === "member" ? params?.studentId : params?.staffId,
    userType: params?.userType === "member" ? "student" : "staff",
  });

  const billData =
    params?.type === "transport"
      ? billQuery.data?.data?.transport_bill_id
      : params?.type === "hostel"
      ? billQuery.data?.data?.hostel_bill_id
      : billQuery.data?.data?.fee_bill_id;

  const installments = billData?.installment;

  const selectInstallments = useGlobalStore.getState().selectInstallments;

  const selectFutureInstallment = React.useCallback(
    (installment: InstallmentData) => {
      if (
        !Array.isArray(installments) ||
        ["PAST", "CURRENT"].includes(installment.installment_type || "")
      ) {
        return;
      }
      const installmentNo = installment.inst_no;
      if (!installmentNo) return;

      const installmentIndex: number = installments.findIndex((instlmnt) => instlmnt.inst_no === installmentNo);
      const pastInstallments: Array<InstallmentData> = [];
      const futureInstallments: Array<InstallmentData> = [];

      installments.forEach((instlmnt, idx) => {
        if (["PAST", "CURRENT"].includes(instlmnt.installment_type || "")) {
          return;
        }
        if (idx < installmentIndex) {
          pastInstallments.push(instlmnt);
        }
        if (idx > installmentIndex) {
          futureInstallments.push(instlmnt);
        }
      });

      // Trigger haptic feedback
      trigger(Platform.select({ ios: "selection", default: "impactLight" }), {
        enableVibrateFallback: true,
        ignoreAndroidSystemSettings: false,
      });

      selectInstallments((selectedInstallments) => {
        const isSelected = selectedInstallments[installmentNo];
        if (isSelected) {
          return {
            [installmentNo]: false,
            ...futureInstallments.reduce<Record<string, boolean>>(
              (acc, curr) => {
                const currInstallmentNo = curr.inst_no;
                if (currInstallmentNo) {
                  acc[currInstallmentNo] = false;
                }
                return acc;
              },
              {}
            ),
          };
        }
        return {
          ...pastInstallments.reduce<Record<string, boolean>>((acc, curr) => {
            const currInstallmentNo = curr.inst_no;
            if (currInstallmentNo) {
              acc[currInstallmentNo] = true;
            }
            return acc;
          }, {}),
          [installmentNo]: true,
        };
      });
    },
    [installments]
  );

  return (
    <View style={styles.container}>
      <Text style={styles.title}>{installments?.[0]?.type} Installments</Text>

      {installments
        ?.filter((installment) =>
          ["CURRENT", "PAST", "FUTURE"].includes(
            installment.installment_type || ""
          )
        )
        .map((installment, index, list) => {
          const previousInstallementIndex = index === 0 ? null : index - 1;
          const previousInstallement =
            previousInstallementIndex !== null &&
            previousInstallementIndex < list.length
              ? list[previousInstallementIndex]
              : null;

          return (
            <InstallmentCard
              key={installment.inst_no || index}
              data={installment}
              previousDue={
                installment.installment_type &&
                ["CURRENT", "PAST"].includes(installment.installment_type)
                  ? previousInstallement?.amount_payble
                  : null
              }
              onPress={selectFutureInstallment}
            />
          );
        })}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    gap: 16,
    paddingHorizontal: 16,
  },
  title: {
    fontSize: 14,
    fontWeight: "400",
    lineHeight: 14 * 1.5,
    marginLeft: 4,
  },
});

export const Installments = React.memo(_Installments);
