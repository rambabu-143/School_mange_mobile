import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

type DateTimeString = string;

export type SeniorRole = {
  _id: string;
  staff_id: {
    _id: string;
    name: string;
  };
  role_id: string;
  short_name: string; // HoD
  order: number;
  updated_on: DateTimeString;
};

export type GetStaffSeniorData = {
  _id: string;
  roles: SeniorRole[];
};

export const useGetStaffSeniorsQuery = (year: string) => {
  const { token, staffId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!staffId,
    queryKey: ['staff', 'seniors'],
    queryFn: () =>
      apiClient.get<GetStaffSeniorData>(`hr/role-management/get-my-seniors/${staffId}/${year}`, token),
  });
};
