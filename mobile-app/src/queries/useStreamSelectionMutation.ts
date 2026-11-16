import { useMutation } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type StreamSelectionSubmit = {
  combinationId: string;
  subject1: string;
  subject2: string;
  subject3: string;
  subject4: string;
  subject5: string;
  subject6?: string | null;
  isAdditionalSubject: boolean;
  remark: string;
};

/** Native: POST stream-selection/student (StreamSelectionFragment's "Update" button). */
export const useStreamSelectionMutation = () => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};

  return useMutation({
    mutationFn: async (form: StreamSelectionSubmit) => {
      if (!token || !userId) throw new Error('Not signed in');
      return apiClient.post<{ message?: string }>(
        'stream-selection/student',
        {
          student_id: userId,
          combination_id: form.combinationId,
          subject1: form.subject1,
          subject2: form.subject2,
          subject3: form.subject3,
          subject4: form.subject4,
          subject5: form.subject5,
          subject6: form.isAdditionalSubject ? form.subject6 : null,
          is_additional_subject: form.isAdditionalSubject,
          remark: form.remark,
        },
        token
      );
    },
  });
};
