import { useMutation, useQueryClient } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type IdCardChangeFields = {
  profile_pic: boolean;
  name: boolean;
  date_of_birth: boolean;
  bloodgroup: boolean;
  allergies: boolean;
  fathers_name: boolean;
  address: boolean;
  sms_mobile: boolean;
  transport: boolean;
};

/** Native: PUT student/id-card/{student_id} — flags which fields need an admin-reviewed change, not new values. */
export const useIdCardChangeRequestMutation = () => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (fields: IdCardChangeFields) => {
      if (!token || !userId) throw new Error('Not signed in');
      return apiClient.put<{ message?: string }>(`student/id-card/${userId}`, fields, token);
    },
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['id-card'] }),
  });
};
