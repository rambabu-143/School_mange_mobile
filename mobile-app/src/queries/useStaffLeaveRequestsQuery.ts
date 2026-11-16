import { useQuery } from '@tanstack/react-query';

import { apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type DateString = string;

export type LeaveAssessor = {
  status?: string | null;
  is_last_assessor?: boolean | null;
  _id?: string | null;
  assessor_id?: {
    _id?: string | null;
    name?: string | null;
  };
  role_id?: {
    _id?: string | null;
    short_name?: string | null;
  };
  date?: DateString | null;
};

export type StaffLeaveRequest = {
  is_sanction?: boolean | null;
  status?: 'Not-Approved' | 'PENDING' | 'APPROVED' | 'REJECTED' | null;
  is_counted?: boolean | null;
  is_deleted?: boolean | null;
  _id?: string | null;
  staff_id?: string | null;
  leave_type?: 'LEAVE' | 'SHORT-LEAVE' | 'CO' | 'OD' | null;
  reason?: string | null;
  prior_sanction?: 'YES' | 'NO' | null;
  prior_sanction_from_whom?: string | null;
  prior_sanction_why_not?: string | null;
  branch_code?: number | null;
  year?: string | null; // YYYY
  year_session?: string | null; // YYYY-YY
  no_of_half_days?: number | null;
  no_of_full_days?: number | null;
  no_of_days?: number | null;
  first_half_day_on?: DateString | null;
  first_half_day_in?: 'FIRST-HALF' | 'SECOND-HALF' | null;
  second_half_day_in?: 'FIRST-HALF' | 'SECOND-HALF' | null;
  second_half_day_on?: DateString | null;
  duration?: string | null;
  from_time?: string | null;
  to_time?: string | null;
  from_date?: DateString | null;
  to_date?: DateString | null;
  created_at?: DateString | null;
  updated_at?: DateString | null;
  __v?: number | null;
  leave_id?: {
    _id?: string | null;
    leave_name?: string | null;
    leave_code?: string | null;
  } | null;
  assessor?: Array<LeaveAssessor> | null;
};

export const useStaffLeaveRequestsQuery = (
  leaveCategory: 'SHORT-LEAVE' | 'LEAVE' | 'CO' | 'OD',
  year: string
) => {
  const { token, staffId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!staffId,
    queryKey: ['leave-requests', leaveCategory, year],
    queryFn: () =>
      orEmpty(
        apiClient.getEnvelope<Array<StaffLeaveRequest>>(`leave/application/status/${staffId}/${leaveCategory}/${year}`, token),
        { data: [] }
      ),
  });
};
