import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type House = { id: string; houseNo: string };

type ApiHouse = { _id?: string | null; house_no?: string | null };

/** Native: GET school/house/all */
export const useHouseListDropdownQuery = () => {
  const token = useSessionStore((s) => s.session?.token);

  return useQuery({
    enabled: !!token,
    queryKey: ['house-dropdown'],
    queryFn: async (): Promise<House[]> => {
      const result = await apiClient.getEnvelope<ApiHouse[]>('school/house/all', token);
      return (result.data ?? [])
        .filter((h): h is ApiHouse => !!h?._id)
        .map((h) => ({ id: h._id!, houseNo: h.house_no ?? '' }));
    },
  });
};
