import { useQuery } from '@tanstack/react-query';

import { apiClient, ApiError } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type SavedStudentRating = {
  is_final_submit?: boolean;
  ratings?: Record<string, number | string> | null;
};

/** Native/legacy: GET staff-aar/rating/student-rating/{staffId}/{standardSectionId}/{studentId} — "Data not found" means not yet rated, not an error. */
export const useStudentRatingQuery = (staffId?: string | null, standardSectionId?: string | null) => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId && !!staffId && !!standardSectionId,
    queryKey: ['student-rating', staffId, standardSectionId, userId],
    queryFn: async (): Promise<SavedStudentRating | null> => {
      try {
        const result = await apiClient.getEnvelope<SavedStudentRating>(
          `staff-aar/rating/student-rating/${staffId}/${standardSectionId}/${userId}`,
          token
        );
        return result.data ?? null;
      } catch (e) {
        if (e instanceof ApiError && /data not found/i.test(e.message)) return null;
        throw e;
      }
    },
    meta: {
      friendlyErrorMessage: 'Unable to fetch your feedback',
    },
  });
};
