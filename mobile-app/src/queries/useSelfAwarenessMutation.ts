import { useMutation, useQueryClient } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type SelfAwarenessSubmit = {
  myGoal: string;
  myStrength: string;
  myInterestHobbies: string;
  responsibilities: string;
  isSubmit: boolean;
};

/** Native: POST self-awareness (SelfAwarenessFragment's Save as Draft / Submit). */
export const useSelfAwarenessMutation = () => {
  const { token, userId, standardId } = useSessionStore((s) => s.session) ?? {};
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (form: SelfAwarenessSubmit) => {
      if (!token || !userId) throw new Error('Not signed in');
      return apiClient.post<{ message?: string }>(
        'self-awareness',
        {
          student_id: userId,
          standard_section_id: standardId,
          my_goal: form.myGoal,
          my_strength: form.myStrength,
          my_interest_hobbies: form.myInterestHobbies,
          responsibilities: form.responsibilities,
          is_submit: form.isSubmit,
        },
        token
      );
    },
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['self-awareness'] }),
  });
};
