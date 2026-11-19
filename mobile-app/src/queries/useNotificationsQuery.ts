import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

import { apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type NotificationItem = {
  _id?: string | null;
  sms_text?: string | null;
  created_at?: string | null;
  notifications?: { read_flag?: boolean | null }[] | null;
};

/** Native: GET sms/staff/APP/{id} (staff) or GET sms/student/APP/{id} (student/parent) */
export const useNotificationsQuery = () => {
  const { token, userId, isStaff } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['notifications', isStaff ? 'staff' : 'student', userId],
    queryFn: () =>
      orEmpty(
        apiClient.get<NotificationItem[]>(isStaff ? `sms/staff/APP/${userId}` : `sms/student/APP/${userId}`, token),
        []
      ),
  });
};

/** Native: PUT sms/read/staff/APP/{id}/{staff_id} or PUT sms/read/student/APP/{id}/{student_id} */
export const useMarkNotificationReadMutation = () => {
  const { token, userId, isStaff } = useSessionStore((s) => s.session) ?? {};
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (notificationId: string) =>
      apiClient.put(
        isStaff
          ? `sms/read/staff/APP/${notificationId}/${userId}`
          : `sms/read/student/APP/${notificationId}/${userId}`,
        { read_flag: true },
        token
      ),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['notifications'] }),
  });
};
