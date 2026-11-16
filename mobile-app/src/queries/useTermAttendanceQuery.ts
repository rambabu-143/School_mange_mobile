import { useQuery } from '@tanstack/react-query';

import { ApiError, apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type TermAttendanceStudent = {
  id: string;
  name?: string | null;
  admissionNo?: string | null;
  profilePic?: string | null;
  dateOfWithdrawal?: string | null;
  totalDays?: number | null;
  totalPresent?: number | null;
};

type ApiStudent = {
  _id?: string | null;
  name?: string | null;
  admission_no?: string | null;
  profile_pic?: string | null;
  date_of_withdrawal?: string | null;
  attendance_data?: { total_days?: number | null; total_present?: number | null } | null;
};

/** Native: GET /attendance/term-attendance/{standard_id}/{standard_section_id}/{term} (AttendanceDayEntryFragment). */
export const useTermAttendanceQuery = (standardId: string | null, standardSectionId: string | null, term: string) => {
  const token = useSessionStore((s) => s.session?.token);

  return useQuery({
    enabled: !!token && !!standardId && !!standardSectionId,
    queryKey: ['term-attendance', standardId, standardSectionId, term],
    queryFn: async (): Promise<TermAttendanceStudent[]> => {
      // Backend route now requires a 4th `till_current_date` segment; the old 3-segment URL 404s (which
      // orEmpty then hid as "no students"). Try the new route, fall back to the legacy one on a 404.
      const base = `attendance/term-attendance/${standardId}/${standardSectionId}/${term}`;
      const result = await orEmpty(
        apiClient.getEnvelope<ApiStudent[]>(`${base}/false`, token).catch((e) => {
          if (e instanceof ApiError && e.status === 404) return apiClient.getEnvelope<ApiStudent[]>(base, token);
          throw e;
        }),
        { data: [] }
      );
      return (result.data ?? []).filter((s): s is ApiStudent => !!s?._id).map((s) => ({
        id: s._id!,
        name: s.name,
        admissionNo: s.admission_no,
        profilePic: s.profile_pic ? `${result.path ?? ''}${s.profile_pic}` : null,
        dateOfWithdrawal: s.date_of_withdrawal,
        totalDays: s.attendance_data?.total_days,
        totalPresent: s.attendance_data?.total_present,
      }));
    },
  });
};
