import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

type ApiEvent = {
  _id?: string | null;
  title?: string | null;
  start_date?: string | null;
  location?: string | null;
  remark?: string | null;
};

type ApiHoliday = {
  _id?: string | null;
  date?: string | null;
  status?: string | null;
  remark?: string | null;
};

export type CalendarEntry = {
  id: string;
  date: string;
  title: string;
  kind: 'event' | 'holiday';
};

/**
 * Native: GET school/school-calendar/student/{standardId} (SchoolCalendarFragment). Student/parent
 * only — staff's "Calendar" home tile opens Attendance Summary instead (DashboardActivity.onSchoolCalendar
 * branches on userType == staff), so staff sessions have no standardId and this stays disabled for them.
 * Response has status/events/holidays at the top level, no `data` wrapper.
 */
export const useSchoolCalendarQuery = () => {
  const { token, standardId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!standardId,
    queryKey: ['school-calendar', standardId],
    queryFn: async (): Promise<CalendarEntry[]> => {
      const result = await apiClient.getEnvelope(`school/school-calendar/student/${standardId}`, token);
      const events = (result.events as ApiEvent[] | null | undefined) ?? [];
      const holidays = (result.holidays as ApiHoliday[] | null | undefined) ?? [];

      const entries: CalendarEntry[] = [
        ...events
          .filter((e): e is ApiEvent & { start_date: string } => !!e.start_date)
          .map((e) => ({
            id: e._id ?? e.start_date,
            date: e.start_date,
            title: [e.title, e.location, e.remark].filter(Boolean).join(' · '),
            kind: 'event' as const,
          })),
        ...holidays
          .filter((h): h is ApiHoliday & { date: string } => h.status === 'HOLIDAY' && !!h.date)
          .map((h) => ({
            id: h._id ?? h.date,
            date: h.date,
            title: h.remark || 'Holiday',
            kind: 'holiday' as const,
          })),
      ].sort((a, b) => a.date.localeCompare(b.date));

      return entries;
    },
  });
};
