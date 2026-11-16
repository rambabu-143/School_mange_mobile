import Toast from 'react-native-toast-message';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import { apiClient, ApiError } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';
import type { StaffLeaveRequest } from './useStaffLeaveRequestsQuery';

export const useDeleteLeaveRequestMutation = () => {
  const token = useSessionStore((s) => s.session?.token);
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (variables: StaffLeaveRequest) => {
      const leaveRequestId = variables._id;
      if (!leaveRequestId) throw new ApiError('Leave Request Id is required!!!');
      if (!token) throw new ApiError('Authentication Token is required!!!');

      return apiClient.delete(`leave/application/${leaveRequestId}`, token);
    },
    networkMode: 'online',
    onSettled: () => queryClient.invalidateQueries({ queryKey: ['leave-requests'] }),
    onSuccess() {
      Toast.show({
        type: 'success',
        text1: 'Leave application deleted successfully',
        text2: 'Your leave request has been deleted successfully.',
        topOffset: 100,
        position: 'top',
      });
    },
    onError(error) {
      Toast.show({
        type: 'error',
        text1: 'Error occurred while deleting leave request',
        text2: `${error.name}: ${error.message}`,
        topOffset: 100,
        position: 'top',
      });
    },
  });
};
