import { useMutation, useQueryClient } from '@tanstack/react-query';
import Toast from 'react-native-toast-message';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type RatingAnswers = Record<string, number | string>;

/** Native/legacy: POST staff-aar/rating — requires an open WISE round for this staff+section (issued by staff/admin first). */
export const useStudentRatingMutation = (staffId?: string | null, standardSectionId?: string | null) => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ ratings, isFinalSubmit }: { ratings: RatingAnswers; isFinalSubmit: boolean }) => {
      if (!token || !userId || !staffId || !standardSectionId) {
        throw new Error('Missing staff, student, or class information');
      }
      return apiClient.post(
        'staff-aar/rating',
        {
          staff_id: staffId,
          student_id: userId,
          standard_section_id: standardSectionId,
          rating_by: 'STUDENT',
          ratings,
          is_final_submit: isFinalSubmit,
        },
        token
      );
    },
    onSuccess: (_data, variables) => {
      if (variables.isFinalSubmit) {
        queryClient.invalidateQueries({ queryKey: ['student-rating'] });
      } else {
        Toast.show({ type: 'success', text1: 'Saved to draft successfully ✅', position: 'top', topOffset: 100 });
      }
    },
    onError: (error, variables) => {
      Toast.show({
        type: 'error',
        text1: variables.isFinalSubmit
          ? 'Error occurred while trying to save your answers!'
          : 'Error occurred while trying to save your answers to draft!',
        text2: error instanceof Error ? error.message : undefined,
        topOffset: 100,
        position: 'top',
      });
    },
  });
};
