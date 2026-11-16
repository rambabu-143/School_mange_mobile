import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

import { apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type MessageItem = {
  _id?: string | null;
  sms_text?: string | null;
  created_at?: string | null;
  mobiles?: Array<{ read_flag?: boolean | null }> | null;
};

/** Native: GET sms/staff/SMS/{id} (staff) or GET sms/student/SMS/{id} (student/parent) */
export const useMessagesQuery = () => {
  const { token, userId, isStaff } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['messages', isStaff ? 'staff' : 'student', userId],
    queryFn: () =>
      orEmpty(
        apiClient.get<MessageItem[]>(isStaff ? `sms/staff/SMS/${userId}` : `sms/student/SMS/${userId}`, token),
        []
      ),
  });
};

/** Native: PUT sms/read/staff/SMS/{id}/{staff_id} or PUT sms/read/student/SMS/{id}/{student_id} */
export const useMarkMessageReadMutation = () => {
  const { token, userId, isStaff } = useSessionStore((s) => s.session) ?? {};
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (messageId: string) =>
      apiClient.put(
        isStaff ? `sms/read/staff/SMS/${messageId}/${userId}` : `sms/read/student/SMS/${messageId}/${userId}`,
        { read_flag: true },
        token
      ),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['messages'] }),
  });
};
