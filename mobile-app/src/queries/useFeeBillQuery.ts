import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type Installment = {
  inst_no?: string | null;
  installment_type?: 'PAST' | 'CURRENT' | 'FUTURE' | null;
  amount?: number | null;
  amount_payble?: number | null;
  fine_installment?: number | null;
  recived?: string | number | null;
};

type FeeBillDetail = {
  admission_no?: string | null;
  fee_bill_id?: { installment?: (Installment | null)[] | null } | null;
};

/** Native: GET student/detail/school-bill/{id} — installment.installment_type (PAST/CURRENT/FUTURE) is precomputed server-side. */
export const useFeeBillQuery = () => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['fee-bill', userId],
    queryFn: async (): Promise<Installment[]> => {
      const result = await apiClient.getEnvelope<FeeBillDetail>(`student/detail/school-bill/${userId}`, token);
      return result.data?.fee_bill_id?.installment?.filter((inst): inst is Installment => !!inst) ?? [];
    },
    meta: {
      friendlyErrorMessage: 'Unable to fetch fee bill details',
    },
  });
};
