import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

type ApiData = { assessment_record?: string | null };

/**
 * Native: GET student/detail/assesment-record/{id} (AssessmentFragment, default mode) — a single PDF URL. Native
 * renders it in an embedded PDF view (react-native-pdf, dev-client only); opened externally via Linking here
 * instead, matching how Notices/Gallery attachments are handled — avoids adding a new native dependency for one link.
 */
export const useAssessmentRecordQuery = () => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['assessment-record', userId],
    queryFn: async (): Promise<string | null> => {
      const result = await apiClient.getEnvelope<ApiData>(`student/detail/assesment-record/${userId}`, token);
      return result.data?.assessment_record ?? null;
    },
  });
};
