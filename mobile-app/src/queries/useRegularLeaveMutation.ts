import Toast from 'react-native-toast-message';
import { useMutation } from '@tanstack/react-query';

import { apiClient, ApiError } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type LeaveRequest = {
  leave_id: string;
  no_of_half_days: number;
  no_of_full_days: string;
  no_of_days: number;
  from_date: string;
  to_date: string;
  first_half_day_on: string | null;
  second_half_day_on: string | null;
  first_half_day_in: 'FIRST-HALF' | 'SECOND-HALF' | null;
  second_half_day_in: 'FIRST-HALF' | 'SECOND-HALF' | null;
  year: string;
  reason: string;
  prior_sanction: 'YES' | 'NO';
  prior_sanction_from_whom: string;
  prior_sanction_why_not: string;
  deduct: number;
  no_of_holidays?: number;
};

export type LeaveResponse = {
  message?: string | null;
  is_dialog?: boolean | null;
  no_of_holidays?: number | null;
};

export const useRegularLeaveMutation = () => {
  const { token, staffId } = useSessionStore((s) => s.session) ?? {};

  return useMutation({
    mutationFn: async (variables: LeaveRequest) => {
      if (!token) throw new ApiError('Authentication Token is required!!!');
      if (!staffId) throw new ApiError('Staff ID is required!!!');

      const body = { ...variables, staff_id: staffId, leave_type: 'LEAVE' as const };
      const result = await apiClient.postEnvelopeRaw<LeaveResponse>('leave/application', body, token);

      if (result.status === true) {
        return result;
      }
      if (result.is_dialog === true && typeof body.no_of_holidays !== 'number') {
        throw new ApiError(result.message || 'Confirmation Required', { cause: result });
      }
      throw new ApiError(result.message || 'Unknown Error Occurred');
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
        text1: 'Error occurred while submitting leave application',
        text2: `${error.name}: ${error.message}`,
        topOffset: 100,
        position: 'top',
      });
    },
  });
};
