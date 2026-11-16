import * as React from "react";
import { Modal } from "react-native";
import { trigger } from "react-native-haptic-feedback";
import { useQueryClient } from "@tanstack/react-query";

import type { PayBillScreenParams } from "../../../types";
import { PaymentOptionModalContent } from "./PaymentOptionModalContent";
import { useUpdateBillTypeMutation } from "../../../queries/useUpdateBillTypeMutation";
import { useBillQuery } from "../../../queries/useBillQuery";

export type _PaymentOptionModalProps = {
  params?: PayBillScreenParams;
};

const _PaymentOptionModal: React.FC<_PaymentOptionModalProps> = ({
  params,
}) => {
  const userType = params?.userType === "member" ? "student" : "staff";

  const queryClient = useQueryClient();

  const updateBillTypeMutation = useUpdateBillTypeMutation({
    token: params?.token,
  });
  const isMutationPending = updateBillTypeMutation.isPending;

  const billQuery = useBillQuery({
    token: params?.token,
    type: params?.type,
    studentOrStaffId:
      params?.userType === "member" ? params?.studentId : params?.staffId,
    userType,
  });

  const billData =
    params?.type === "transport"
      ? billQuery.data?.data?.transport_bill_id
      : params?.type === "hostel"
      ? billQuery.data?.data?.hostel_bill_id
      : billQuery.data?.data?.fee_bill_id;

  const [paymentOptionModalVisible, setPaymentOptionModalVisible] =
    React.useState(
      (params?.billTypeUpdated === false &&
        params.studentType === "OLD" &&
        params.type === "school" &&
        ["ANSR", "ANJR", "DWSR", "DWJR"].includes(
          billData?.school_code?.toUpperCase?.() || ""
        )) ||
        false
    );
  const [showBillGenerateMessage, setShowBillGenerateMessage] =
    React.useState(false);

  const billGenerateTimeoutIdRef = React.useRef<NodeJS.Timeout | null>(null);

  React.useEffect(() => {
    return () => {
      if (billGenerateTimeoutIdRef.current !== null) {
        clearTimeout(billGenerateTimeoutIdRef.current);
        billGenerateTimeoutIdRef.current = null;
      }
    };
  }, []);

  const dismissPaymentOptionModal = React.useCallback(() => {
    setPaymentOptionModalVisible(false);
  }, []);

  const invalidateQueryAndCloseModal = React.useCallback(() => {
    queryClient.invalidateQueries({
      queryKey:
        !!params?.type && !!params?.studentId && !!userType
          ? ["bill", params.type, userType, params.studentId]
          : ["bill"],
    });

    dismissPaymentOptionModal();
  }, [params, queryClient, dismissPaymentOptionModal]);

  const billTypeUpdatedHandler = React.useCallback(() => {
    setShowBillGenerateMessage(true);
    // setting timer to wait for backend to generate new bill
    billGenerateTimeoutIdRef.current = setTimeout(invalidateQueryAndCloseModal, 5000);
  }, [invalidateQueryAndCloseModal]);

  const handleConfirmPress = React.useCallback(async () => {
    try {
      await updateBillTypeMutation.mutateAsync({
        admission_no: billQuery.data?.data?.admission_no,
        fee_type: 12,
        year_session: billQuery.data?.data?.fee_bill_id?.year_session,
      });
      billTypeUpdatedHandler();
    } catch (error) {}
  }, [billTypeUpdatedHandler]);

  const modalDismissDisabledHaptic = React.useCallback(() => {
    trigger("notificationError", {
      enableVibrateFallback: true,
      ignoreAndroidSystemSettings: false,
    });
  }, []);

  return (
    <Modal
      animationType="fade"
      transparent={true}
      visible={paymentOptionModalVisible}
      onRequestClose={
        isMutationPending
          ? modalDismissDisabledHaptic
          : dismissPaymentOptionModal
      }
      statusBarTranslucent={false}
    >
      <PaymentOptionModalContent
        closeModal={isMutationPending ? undefined : dismissPaymentOptionModal}
        isLoading={isMutationPending}
        showBillGenerateMessage={showBillGenerateMessage}
        onConfirmPress={handleConfirmPress}
      />
    </Modal>
  );
};

export const PaymentOptionModal = React.memo(_PaymentOptionModal);
