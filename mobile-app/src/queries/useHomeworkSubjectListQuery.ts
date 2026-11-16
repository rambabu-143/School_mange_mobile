import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type Subject = { id: string; label: string };

type ApiSubject = { _id?: string | null; subject_name?: string | null };

/** Native: POST master/subject/for-assignment — subjects available for a given class + section. */
export const useHomeworkSubjectListQuery = (standardId: string | null, standardSectionId: string | null) => {
  const token = useSessionStore((s) => s.session?.token);

  return useQuery({
    enabled: !!token && !!standardId && !!standardSectionId,
    queryKey: ['homework-subjects', standardId, standardSectionId],
    queryFn: async (): Promise<Subject[]> => {
      const subjects = await apiClient.post<ApiSubject[]>(
        'master/subject/for-assignment',
        { standard_id: [standardId], standard_section_id: standardSectionId },
        token
      );
      return (subjects ?? []).filter((s): s is ApiSubject => !!s?._id).map((s) => ({ id: s._id!, label: s.subject_name ?? '' }));
    },
  });
};
