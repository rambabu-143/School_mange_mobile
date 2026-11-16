import { useMutation, useQueryClient } from '@tanstack/react-query';

import { apiClient, ApiError } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';
import { ApiHomework, mapHomework } from '@/queries/useAssignedHomeworkListQuery';

/** Native: DELETE homework/{homework_id}/{start_date}/{end_date} — response is the refreshed list for that same date range. */
export const useDeleteAssignedHomeworkMutation = (startDate: string, endDate: string) => {
  const token = useSessionStore((s) => s.session?.token);
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (homeworkId: string) => {
      if (!token) throw new ApiError('Not signed in');
      const data = await apiClient.delete<ApiHomework[]>(`homework/${homeworkId}/${startDate}/${endDate}`, token);
      return (data ?? []).map(mapHomework);
    },
    onSuccess: (data) => {
      queryClient.setQueryData(['assigned-homework', startDate, endDate], data);
    },
  });
};
