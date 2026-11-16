import Toast from 'react-native-toast-message';
import { useMutation } from '@tanstack/react-query';

import { apiClient, ApiError } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type LeaveRequest = {
  no_of_days: number;
  from_date: string;
  to_date: string;
  year: string;
  reason: string;
  prior_sanction: 'YES' | 'NO';
  prior_sanction_from_whom: string;
  prior_sanction_why_not: string;
  deduct: number;
};

export const useODLeaveMutation = () => {
  const { token, staffId } = useSessionStore((s) => s.session) ?? {};

  return useMutation({
    mutationFn: async (variables: LeaveRequest) => {
      if (!token) throw new ApiError('Authentication Token is required!!!');
      if (!staffId) throw new ApiError('Staff ID is required!!!');

      const body = { ...variables, staff_id: staffId, leave_type: 'OD' as const };
      return apiClient.post('leave/application', body, token);
    },
    networkMode: 'online',
    onSuccess() {
      Toast.show({
        type: 'success',
        text1: 'Leave application submitted successfully',
        text2: 'Your leave application has been submitted successfully.',
        topOffset: 100,
        position: 'top',
      });
    },
    onError(error) {
      Toast.show({
        type: 'error',
        text1: 'Error occurred while submitting OD leave application',
        text2: `${error.name}: ${error.message}`,
        topOffset: 100,
        position: 'top',
      });
    },
  });
};
