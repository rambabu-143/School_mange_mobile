import { useMutation } from '@tanstack/react-query';

import { apiClient, ApiError } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type HouseListStudent = {
  id: string;
  name?: string | null;
  admissionNo?: string | null;
  profilePic?: string | null;
  houseNo?: string | null;
  className?: string | null;
};

type ApiStudent = {
  _id?: string | null;
  name?: string | null;
  admission_no?: string | null;
  profile_pic?: string | null;
  house_id?: { house_no?: string | null } | null;
  standard_section_id?: { standard?: string | null; section?: string | null } | null;
};

/** Native: POST report/student/house-list (HouseListFragment) — filters students by class section + house. */
export const useHouseListMutation = () => {
  const token = useSessionStore((s) => s.session?.token);

  return useMutation({
    mutationFn: async (variables: { standardSections: string[]; houses: string[] }): Promise<HouseListStudent[]> => {
      if (!token) throw new ApiError('Not signed in');

      const result = await apiClient.postEnvelopeRaw<ApiStudent[]>(
        'report/student/house-list',
        { standard_sections: variables.standardSections, houses: variables.houses },
        token
      );
      if (!result.status) {
        if (/not found/i.test(result.message ?? '')) return [];
        throw new ApiError(result.message || 'Unknown error occurred!');
      }
      return (result.data ?? []).filter((s): s is ApiStudent => !!s?._id).map((s) => ({
        id: s._id!,
        name: s.name,
        admissionNo: s.admission_no,
        profilePic: s.profile_pic ? `${result.path ?? ''}${s.profile_pic}` : null,
        houseNo: s.house_id?.house_no,
        className: [s.standard_section_id?.standard, s.standard_section_id?.section].filter(Boolean).join(' '),
      }));
    },
  });
};
