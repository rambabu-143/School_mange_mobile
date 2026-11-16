import { useQuery } from '@tanstack/react-query';
import dayjs from 'dayjs';

import { apiClient } from '@/lib/api-client';

export type AttendanceDateData = {
  _id?: string | null;
  created_at?: string | null;
  end_date?: string | null;
  is_deleted?: boolean | null;
  start_date?: string | null;
  term_session?: string | null;
  updated_at?: string | null;
  year_session?: string | null;
};

export const useAttendanceDateQuery = ({ token }: { token: string | undefined | null }) => {
  return useQuery({
    enabled: !!token,
    queryKey: ['attendance-dates'],
    queryFn: () => apiClient.get<AttendanceDateData>('config/Attendance-dates', token),
    refetchOnMount: false,
    meta: { friendlyErrorMessage: 'Unable to fetch Attendance Dates' },
    select: (data) => ({
      ...data,
      start_date: data?.start_date ? dayjs(data.start_date).format('YYYY-MM-DD') : undefined,
      end_date: data?.end_date ? dayjs(data.end_date).format('YYYY-MM-DD') : undefined,
    }),
  });
};
