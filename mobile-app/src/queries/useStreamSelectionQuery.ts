import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type StreamSubjectOption = { id: string; label: string };
export type StreamCombination = {
  id: string;
  combinationName: string;
  isAdditionalSubject: boolean;
  subject1: StreamSubjectOption[];
  subject2: StreamSubjectOption[];
  subject3: StreamSubjectOption[];
  subject4: StreamSubjectOption[];
  subject5: StreamSubjectOption[];
  subject6: StreamSubjectOption[];
};

type ApiSubject = { _id?: string | null; subject_name?: string | null };
type ApiCombination = {
  _id?: string | null;
  combination_name?: string | null;
  is_additional_subject?: boolean | null;
  subject1?: (ApiSubject | null)[] | null;
  subject2?: (ApiSubject | null)[] | null;
  subject3?: (ApiSubject | null)[] | null;
  subject4?: (ApiSubject | null)[] | null;
  subject5?: (ApiSubject | null)[] | null;
  subject6?: (ApiSubject | null)[] | null;
};
type ApiResponse = { data?: (ApiCombination | null)[] | null; eligibility_criteria?: string | null };

const toOptions = (list?: (ApiSubject | null)[] | null): StreamSubjectOption[] =>
  (list ?? []).filter((s): s is ApiSubject => !!s?._id).map((s) => ({ id: s._id!, label: s.subject_name ?? '' }));

/** Native: GET stream-selection/combination/all/{branch_code}/{year_session} (StreamSelectionFragment). */
export const useStreamSelectionQuery = () => {
  const { token, branchCode, yearSession } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!branchCode && !!yearSession,
    queryKey: ['stream-selection-combinations', branchCode, yearSession],
    queryFn: async (): Promise<{ combinations: StreamCombination[]; eligibilityCriteria: string | null }> => {
      const result = await apiClient.getEnvelope<ApiCombination[]>(`stream-selection/combination/all/${branchCode}/${yearSession}`, token);
      const full = result as unknown as ApiResponse;
      const combinations = (full.data ?? []).filter((c): c is ApiCombination => !!c?._id).map((c) => ({
        id: c._id!,
        combinationName: c.combination_name ?? '',
        isAdditionalSubject: !!c.is_additional_subject,
        subject1: toOptions(c.subject1),
        subject2: toOptions(c.subject2),
        subject3: toOptions(c.subject3),
        subject4: toOptions(c.subject4),
        subject5: toOptions(c.subject5),
        subject6: toOptions(c.subject6),
      }));
      return { combinations, eligibilityCriteria: full.eligibility_criteria ?? null };
    },
  });
};
