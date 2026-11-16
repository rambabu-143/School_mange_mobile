import { useQuery } from '@tanstack/react-query';

import { apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type HolidayHomeworkItem = {
  id: string;
  title?: string | null;
  text?: string | null;
  startDate?: string | null;
  endDate?: string | null;
  attachment?: string | null;
  path?: string | null;
};

type ApiItem = {
  _id?: string | null;
  title?: string | null;
  text?: string | null;
  start_date?: string | null;
  end_date?: string | null;
  attachments?: (string | null)[] | null;
};

/** Native: GET assignment/student/{id}/homework (HolidayHomeWorkFragment, despite the "getStudentHomeWork" method name). */
export const useHolidayHomeworkQuery = () => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['holiday-homework', userId],
    queryFn: async (): Promise<HolidayHomeworkItem[]> => {
      const result = await orEmpty(apiClient.getEnvelope<ApiItem[]>(`assignment/student/${userId}/homework`, token), { data: [] });
      const path = result.path as string | null;
      return (result.data ?? []).filter((i): i is ApiItem => !!i?._id).map((i) => ({
        id: i._id!,
        title: i.title,
        text: i.text,
        startDate: i.start_date,
        endDate: i.end_date,
        attachment: i.attachments?.[0],
        path,
      }));
    },
  });
};
