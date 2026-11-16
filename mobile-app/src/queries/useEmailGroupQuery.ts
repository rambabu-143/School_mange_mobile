import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

type ApiData = { email_group_file?: string | null };

/** Native: GET config/dashboard, data.email_group_file (staff drawer's "Email Group"). */
export const useEmailGroupQuery = () => {
  const token = useSessionStore((s) => s.session?.token);

  return useQuery({
    enabled: !!token,
    queryKey: ['email-group'],
    queryFn: async () => {
      const result = await apiClient.getEnvelope<ApiData>('config/dashboard', token);
      return result.data?.email_group_file ?? null;
    },
  });
};
