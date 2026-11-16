import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type AttendanceDayEntry = {
  date?: string | null;
  isHalfDay: boolean;
  information?: string | null;
  reason?: string | null;
};

export type MyAttendanceCalendar = {
  total: number;
  present: number;
  absent: number;
  days: AttendanceDayEntry[];
};

type ApiAbsentItem = { student_id?: string | null; value?: number | null; information?: string | null; reason?: string | null };
type ApiAbsentDay = { date?: string | null; absent?: (ApiAbsentItem | null)[] | null };
type ApiResponse = { total?: number | null; present?: number | null; absent?: number | null; absent_data?: (ApiAbsentDay | null)[] | null };

/** Native: GET attendance/mark-attendance/student/{id}/{start}/{end} (studentattendance/
 * AttendanceFragment, non-staff branch) — a month-grid calendar with red/orange day dots in
 * native. Simplified to summary counts + a list of flagged days (same underlying data), same
 * trade-off already made for the School Calendar screen — avoids a calendar-grid dependency. */
export const useMyAttendanceCalendarQuery = (startDate: string, endDate: string) => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['my-attendance', userId, startDate, endDate],
    queryFn: async (): Promise<MyAttendanceCalendar> => {
      const result = await apiClient.getEnvelope<never>(`attendance/mark-attendance/student/${userId}/${startDate}/${endDate}`, token);
      const full = result as unknown as ApiResponse;
      const days: AttendanceDayEntry[] = (full.absent_data ?? [])
        .filter((d): d is ApiAbsentDay => !!d)
        .map((d) => {
          const entry = d.absent?.find((a) => a?.student_id === userId);
          return {
            date: d.date,
            isHalfDay: (entry?.value ?? 1) < 1,
            information: entry?.information,
            reason: entry?.reason,
          };
        });
      return { total: full.total ?? 0, present: full.present ?? 0, absent: full.absent ?? 0, days };
    },
  });
};
