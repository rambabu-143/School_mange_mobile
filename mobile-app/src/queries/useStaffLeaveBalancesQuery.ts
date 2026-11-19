import { useQuery } from '@tanstack/react-query';

import { apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

type ClubbedCheck = 'Yes' | 'No';

export type StaffLeaveDetails = {
  is_july_credit?: boolean | null;
  _id?: string | null;
  leave_name?: string | null;
  leave_code?: string | null;
  max_in_row?: string | null;
  max_in_month?: string | null;
  is_half_day_applicable: ClubbedCheck | null;
  clubbed_with_weekly_off?: ClubbedCheck | null;
  clubbed_with_holiday?: ClubbedCheck | null;
  clubbed_with_leave?: ClubbedCheck | null;
  carry_forward?: number | null;
  credit_in_jan?: number | null;
  credit_in_july?: number | null;
  leaves_taken_in_month?: number | null;
  total?: number | null;
  used?: number | null;
  balance?: number | null;
};

export const useStaffLeaveBalancesQuery = (year: string) => {
  const { token, staffId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!staffId,
    queryKey: ['staff', 'leaves'],
    queryFn: () =>
      orEmpty(apiClient.get<StaffLeaveDetails[]>(`hr/staff/leaves/all/${staffId}/${year}`, token), []),
  });
};
