import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type TimetablePeriod = { subject?: string | null; startTime?: string | null; endTime?: string | null };
export type TimetableByDay = Record<'monday' | 'tuesday' | 'wednesday' | 'thursday' | 'friday', TimetablePeriod[]>;

type ApiPeriod = { subject?: string | null; start_time?: string | null; end_time?: string | null } | null;
type ApiResponse = {
  resource?:
    | ({
        Monday?: ApiPeriod[] | null;
        Tuesday?: ApiPeriod[] | null;
        Wednesday?: ApiPeriod[] | null;
        Thursday?: ApiPeriod[] | null;
        Friday?: ApiPeriod[] | null;
      } | null)[]
    | null;
};

function mapDay(periods?: ApiPeriod[] | null): TimetablePeriod[] {
  return (periods ?? []).filter((p): p is NonNullable<ApiPeriod> => !!p).map((p) => ({
    subject: p.subject,
    startTime: p.start_time,
    endTime: p.end_time,
  }));
}

/**
 * Native: GET time-table/student/{id} (student/parent) or GET time-table/standard/{standard_id} (staff, after
 * picking a class from staffDetail.schools[0].access_standard_section). Only Mon-Fri are shown, matching native's
 * `dayArray` (native's response also carries Saturday/Sunday, always empty for this school).
 */
export const useTimetableQuery = (standardId?: string | null) => {
  const { token, userId, isStaff } = useSessionStore((s) => s.session) ?? {};
  const path = isStaff ? (standardId ? `time-table/standard/${standardId}` : null) : userId ? `time-table/student/${userId}` : null;

  return useQuery({
    enabled: !!token && !!path,
    queryKey: ['timetable', path],
    queryFn: async (): Promise<TimetableByDay> => {
      const result = await apiClient.getEnvelope<ApiResponse>(path!, token);
      const resource = result.data?.resource?.[0];
      return {
        monday: mapDay(resource?.Monday),
        tuesday: mapDay(resource?.Tuesday),
        wednesday: mapDay(resource?.Wednesday),
        thursday: mapDay(resource?.Thursday),
        friday: mapDay(resource?.Friday),
      };
    },
  });
};
