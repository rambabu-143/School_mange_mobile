import { useMutation } from '@tanstack/react-query';
import Toast from 'react-native-toast-message';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type SocialMediaConsentVariables = {
  is_agree: true;
  parent_name: string;
};

/** Native/legacy: POST student/social-media-consent — one-time submission, admission_no must be unique. */
export const useSocialMediaConsentMutation = () => {
  const session = useSessionStore((s) => s.session);

  return useMutation({
    mutationFn: async (variables: SocialMediaConsentVariables) => {
      if (!session?.token) throw new Error('Not signed in');
      if (!session?.userId) throw new Error('Missing student id');
      if (!session?.admissionNo) throw new Error('Missing admission number');

      return apiClient.post<{ status?: boolean; message?: string }>(
        'student/social-media-consent',
        { ...variables, student_id: session.userId, admission_no: session.admissionNo },
        session.token
      );
    },
    onSuccess: () => {
      Toast.show({
        type: 'success',
        text1: 'Social media consent submitted successfully',
        topOffset: 100,
        position: 'top',
      });
    },
    onError: (error) => {
      Toast.show({
        type: 'error',
        text1: 'Error occurred while submitting social media consent',
        text2: error instanceof Error ? error.message : undefined,
        topOffset: 100,
        position: 'top',
      });
    },
  });
};
