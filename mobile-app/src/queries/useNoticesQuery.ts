import { useQuery } from '@tanstack/react-query';

import { apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type NoticeItem = {
  _id?: string | null;
  title?: string | null;
  text?: string | null;
  created_at?: string | null;
  attachments?: (string | null)[] | null;
};

type NoticesData = {
  data?: NoticeItem[] | null;
  path?: string | null;
};

/** Native: GET notice/staff/{id} (staff) or GET notice/student/{id} (student/parent) */
export const useNoticesQuery = () => {
  const { token, userId, isStaff } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['notices', isStaff ? 'staff' : 'student', userId],
    queryFn: () =>
      orEmpty(
        apiClient.getEnvelope<NoticeItem[]>(isStaff ? `notice/staff/${userId}` : `notice/student/${userId}`, token),
        { data: [] }
      ),
    select: (result): NoticesData => ({ data: result.data, path: result.path as string | null }),
  });
};
