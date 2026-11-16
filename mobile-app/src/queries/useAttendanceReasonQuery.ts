import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

/** Native: GET /config/attendance-reason — dropdown options for marking a student absent. */
export const useAttendanceReasonQuery = () => {
  const token = useSessionStore((s) => s.session?.token);

  return useQuery({
    enabled: !!token,
    queryKey: ['attendance-reason'],
    queryFn: async (): Promise<string[]> => {
      const result = await apiClient.getEnvelope<{ reason?: string | null }[]>('config/attendance-reason', token);
      return (result.data ?? []).map((d) => d?.reason).filter((r): r is string => !!r);
    },
  });
};
