import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

/** Native: GET config/disciplinary-reason/{PINK|YELLOW|RED} — reasons offered per card colour. */
export const useDisciplinaryReasonsQuery = (cardKey: 'pink' | 'yellow' | 'red' | null) => {
  const token = useSessionStore((s) => s.session?.token);

  return useQuery({
    enabled: !!token && !!cardKey,
    queryKey: ['disciplinary-reasons', cardKey],
    queryFn: async () => {
      const rows = await apiClient.get<{ _id: string; reason?: string | null }[]>(
        `config/disciplinary-reason/${cardKey!.toUpperCase()}`,
        token
      );
      return (rows ?? []).filter((r) => !!r.reason).map((r) => ({ id: r._id, label: r.reason as string }));
    },
  });
};
