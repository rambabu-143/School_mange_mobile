import Toast from 'react-native-toast-message';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import { apiClient, ApiError } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';
import type { StaffLeaveApproval } from './useStaffLeaveApprovalsQuery';

export const useUpdateLeaveRequestStatusMutation = () => {
  const { token, staffId } = useSessionStore((s) => s.session) ?? {};
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (variables: {
      leave: StaffLeaveApproval;
      status: 'APPROVED' | 'REJECTED' | 'Recommended' | 'Not-Recommended';
      isSanction: boolean;
    }) => {
      const leaveRequestId = variables.leave._id;
      if (!leaveRequestId) throw new ApiError('Leave Request Id is required!!!');
      if (!staffId) throw new ApiError('Staff Id is required!!!');
      if (!token) throw new ApiError('Authentication Token is required!!!');
      if (!Array.isArray(variables.leave.assessor) || variables.leave.assessor.length <= 0) {
        throw new ApiError('Assessor details are required!!!');
      }

      let isLastAssessor = false;
      const leaveAssessor = variables.leave.assessor.map((assessor, index, arr) => {
        const isLast = index === arr.length - 1;
        if (!isLast) return assessor;
        if (typeof assessor.is_last_assessor === 'boolean') {
          isLastAssessor = assessor.is_last_assessor;
        }
        return { ...assessor, status: variables.status };
      });

      const payload = {
        assessor: leaveAssessor,
        updated_by: staffId,
        is_last_assessor: isLastAssessor,
        status: variables.status,
        is_sanction: variables.isSanction,
      };

      return apiClient.put(`leave/application/update-status/${leaveRequestId}`, payload, token);
    },
    networkMode: 'online',
    onSettled: () => queryClient.invalidateQueries({ queryKey: ['leave-approvals'] }),
    onSuccess(_data, variables) {
      Toast.show({
        type: 'success',
        text1: 'Leave application updated successfully',
        text2: 'You have set the leave request status to ' + variables.status + 'successfully.',
        topOffset: 100,
        position: 'top',
      });
    },
    onError(error, variables) {
      Toast.show({
        type: 'error',
        text1: 'Error occurred while setting leave request status to ' + variables.status,
        text2: `${error.name}: ${error.message}`,
        topOffset: 100,
        position: 'top',
      });
    },
  });
};
