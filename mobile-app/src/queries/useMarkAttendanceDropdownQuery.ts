import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';
import type { ClassSection } from '@/queries/useClassSectionDropdownQuery';

type DropDownData = { _id?: string | null; standard?: string | null; section?: string | null; standard_id?: { _id?: string | null } | null };

/** Native: GET setting/standard-section/assigned/mark-attendance — only classes this staff can mark (class/helper teacher), unlike the general class-section dropdown. */
export const useMarkAttendanceDropdownQuery = () => {
  const token = useSessionStore((s) => s.session?.token);

  return useQuery({
    enabled: !!token,
    queryKey: ['mark-attendance-dropdown'],
    queryFn: async (): Promise<ClassSection[]> => {
      const result = await apiClient.getEnvelope<DropDownData[]>('setting/standard-section/assigned/mark-attendance', token);
      return (result.data ?? []).filter((d): d is DropDownData => !!d?._id).map((d) => ({
        id: d._id!,
        standardId: d.standard_id?._id ?? '',
        label: [d.standard, d.section].filter(Boolean).join(' '),
      }));
    },
  });
};
