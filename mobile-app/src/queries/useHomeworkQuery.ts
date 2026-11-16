import { useQuery } from '@tanstack/react-query';

import { apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type HomeworkItem = {
  id: string;
  text?: string | null;
  date?: string | null;
  attachment?: string | null;
  googleDriveLink?: string | null;
  teacherName?: string | null;
  path?: string | null;
};

type ApiHomework = {
  _id?: string | null;
  text?: string | null;
  date?: string | null;
  attachment?: string | null;
  google_drive_link?: string | null;
  sent_by_staff?: { name?: string | null } | null;
};

/** Native: GET homework/student/{student_id}/{subject_id}/{start_date}/{end_date} (HomeworkFragment). Dates DD-MM-YYYY. */
export const useHomeworkQuery = (subjectId: string | null, startDate: string, endDate: string) => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId && !!subjectId,
    queryKey: ['homework', userId, subjectId, startDate, endDate],
    queryFn: async (): Promise<HomeworkItem[]> => {
      const result = await orEmpty(
        apiClient.getEnvelope<ApiHomework[]>(`homework/student/${userId}/${subjectId}/${startDate}/${endDate}`, token),
        { data: [] }
      );
      const path = result.path as string | null;
      return (result.data ?? []).filter((h): h is ApiHomework => !!h?._id).map((h) => ({
        id: h._id!,
        text: h.text,
        date: h.date,
        attachment: h.attachment,
        googleDriveLink: h.google_drive_link,
        teacherName: h.sent_by_staff?.name,
        path,
      }));
    },
  });
};
