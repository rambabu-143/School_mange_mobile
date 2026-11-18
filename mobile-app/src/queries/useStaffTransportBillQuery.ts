import { useQuery } from '@tanstack/react-query';

import { apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

type ApiInstallment = {
  inst_no?: string | null;
  installment_type?: string | null;
  amount?: number | null;
  amount_payble?: number | null;
} | null;

type StaffBillData = {
  transport_bill_id?: {
    installment?: ApiInstallment[] | null;
    filepath?: string | null;
    payable?: number | null;
    full_payment_received?: boolean | null;
  } | null;
};

export type StaffTransportBill = {
  instNo?: string | null;
  amount: number;
  due: number;
  paid: boolean;
  filepath?: string | null;
};

/** Native: FeeFragment.updateViewForStaff — reads staffDetail.transport_bill_id (GET staff/{id}); the card is
 * hidden when the staff member has no transport installments, so that is `null` here. */
export const useStaffTransportBillQuery = () => {
  const { token, userId, isStaff } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId && !!isStaff,
    queryKey: ['staff-transport-bill', userId],
    queryFn: async (): Promise<StaffTransportBill | null> => {
      const result = await orEmpty(apiClient.getEnvelope<StaffBillData>(`staff/${userId}`, token), { data: {} });
      const bill = result.data?.transport_bill_id;
      const installments = bill?.installment?.filter((i): i is NonNullable<ApiInstallment> => !!i) ?? [];
      if (!bill || installments.length === 0) return null;
      const current = installments.find((i) => i.installment_type?.toLowerCase() === 'current') ?? installments[0];
      return {
        instNo: current.inst_no,
        amount: current.amount ?? 0,
        due: current.amount_payble ?? 0,
        paid: bill.full_payment_received === true && (bill.payable ?? 0) <= 0,
        filepath: bill.filepath,
      };
    },
  });
};
