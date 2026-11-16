import { useQuery } from '@tanstack/react-query';

import { apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type SyllabusItem = { id: string; title?: string | null; createdAt?: string | null; attachment?: string | null; path?: string | null };
type ApiItem = { _id?: string | null; title?: string | null; created_at?: string | null; attachments?: (string | null)[] | null };

/** Native: GET assignment/student/{id}/syllabus (AssignmentFragment, "Syllabus" mode). */
export const useSyllabusQuery = () => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['syllabus', userId],
    queryFn: async (): Promise<SyllabusItem[]> => {
      const result = await orEmpty(apiClient.getEnvelope<ApiItem[]>(`assignment/student/${userId}/syllabus`, token), { data: [] });
      const path = result.path as string | null;
      return (result.data ?? []).filter((i): i is ApiItem => !!i?._id).map((i) => ({
        id: i._id!,
        title: i.title,
        createdAt: i.created_at,
        attachment: i.attachments?.[0],
        path,
      }));
    },
  });
};
