import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

/** `id` is the standard_section id (used by Class List / House List); `standardId` is the bare standard id (used by Term Attendance). */
export type ClassSection = { id: string; standardId: string; label: string };

type DropDownData = { _id?: string | null; standard?: string | null; section?: string | null; standard_id?: { _id?: string | null } | null };

/** Native: GET setting/standard-section/assigned/class-list — shared dropdown for Class List, House List, and Term Attendance. */
export const useClassSectionDropdownQuery = ({ enabled = true }: { enabled?: boolean } = {}) => {
  const token = useSessionStore((s) => s.session?.token);

  return useQuery({
    enabled: !!token && enabled,
    queryKey: ['class-section-dropdown'],
    queryFn: async (): Promise<ClassSection[]> => {
      const result = await apiClient.getEnvelope<DropDownData[]>('setting/standard-section/assigned/class-list', token);
      return (result.data ?? []).filter((d): d is DropDownData => !!d?._id).map((d) => ({
        id: d._id!,
        standardId: d.standard_id?._id ?? '',
        label: [d.standard, d.section].filter(Boolean).join(' '),
      }));
    },
  });
};
