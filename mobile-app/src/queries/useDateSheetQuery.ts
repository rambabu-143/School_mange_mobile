import { useQuery } from '@tanstack/react-query';

import { apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type DateSheetItem = {
  id: string;
  title?: string | null;
  text?: string | null;
  createdAt?: string | null;
  attachment?: string | null;
  path?: string | null;
};

type ApiItem = { _id?: string | null; title?: string | null; text?: string | null; created_at?: string | null; attachments?: (string | null)[] | null };

/** Native: GET assignment/student/{student_id}/date-sheet (AssessmentFragment, "Date Sheet" mode). */
export const useDateSheetQuery = () => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['date-sheet', userId],
    queryFn: async (): Promise<DateSheetItem[]> => {
      const result = await orEmpty(apiClient.getEnvelope<ApiItem[]>(`assignment/student/${userId}/date-sheet`, token), { data: [] });
      const path = result.path as string | null;
      return (result.data ?? []).filter((i): i is ApiItem => !!i?._id).map((i) => ({
        id: i._id!,
        title: i.title,
        text: i.text,
        createdAt: i.created_at,
        attachment: i.attachments?.[0],
        path,
      }));
    },
  });
};
