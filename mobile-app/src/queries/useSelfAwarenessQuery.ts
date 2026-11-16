import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type SelfAwarenessForm = {
  myGoal?: string | null;
  myStrength?: string | null;
  myInterestHobbies?: string | null;
  responsibilities?: string | null;
  isSubmit?: boolean | null;
};

type ApiData = {
  my_goal?: string | null;
  my_strength?: string | null;
  my_interest_hobbies?: string | null;
  responsibilities?: string | null;
  is_submit?: boolean | null;
};

/** Native: GET self-awareness/{student_id} — requires a "golive" round opened for this student's
 * section server-side, same gating pattern as WISE. "Golive not found" means not yet opened. */
export const useSelfAwarenessQuery = () => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['self-awareness', userId],
    queryFn: async (): Promise<SelfAwarenessForm | null> => {
      const result = await apiClient.getEnvelope<ApiData>(`self-awareness/${userId}`, token);
      const data = result.data;
      if (!data || Object.keys(data).length === 0) return null;
      return {
        myGoal: data.my_goal,
        myStrength: data.my_strength,
        myInterestHobbies: data.my_interest_hobbies,
        responsibilities: data.responsibilities,
        isSubmit: data.is_submit,
      };
    },
  });
};
