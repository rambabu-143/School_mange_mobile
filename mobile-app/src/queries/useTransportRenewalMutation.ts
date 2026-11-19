import { useMutation, useQueryClient } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type SiblingLookupResult = {
  /** Sibling's own student _id — native sends this as `sibling_id`. */
  id?: string | null;
  admissionNo?: string | null;
  name?: string | null;
  schoolCode?: string | null;
  section?: string | null;
};

type ApiSibling = {
  _id?: string | null;
  admission_no?: string | null;
  name?: string | null;
  school_code?: string | null;
  standard_section_id?: { standard?: string | null; section?: string | null; _id?: string | null } | null;
};

/** Native: GET student/detail/admission/{admission_no} — used by the "Add Sibling" admission-no lookup. */
export const useSiblingLookup = () => {
  const token = useSessionStore((s) => s.session?.token);

  return useMutation({
    mutationFn: async (admissionNo: string): Promise<SiblingLookupResult> => {
      const result = await apiClient.getEnvelope<ApiSibling>(`student/detail/admission/${admissionNo}`, token);
      const data = result.data;
      return {
        id: data?._id,
        admissionNo: data?.admission_no,
        name: data?.name,
        schoolCode: data?.school_code,
        section: data?.standard_section_id?.section,
      };
    },
  });
};

export type TransportRenewalSubmit = {
  transportType: 'renew' | 'withdraw';
  siblings: Pick<SiblingLookupResult, 'id' | 'admissionNo' | 'name' | 'schoolCode' | 'section'>[];
};

/** Native: POST transport/renewal-form (TransportRenewalFragment's confirm dialog Save). */
export const useTransportRenewalMutation = () => {
  const { token, userId, admissionNo } = useSessionStore((s) => s.session) ?? {};
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (form: TransportRenewalSubmit) => {
      if (!token || !userId) throw new Error('Not signed in');
      // Native sends the *current* student's standard_section_id (+ class) on every sibling row, not the session's standard id.
      const me = (await apiClient.getEnvelope<ApiSibling>(`student/detail/${userId}`, token)).data?.standard_section_id;
      return apiClient.post<{ message?: string }>(
        'transport/renewal-form',
        {
          admission_no: admissionNo,
          student_id: userId,
          transport_type: form.transportType,
          sibling_details: form.siblings.map((s) => ({
            admission_no: s.admissionNo,
            class: me?.standard,
            name: s.name,
            school_code: s.schoolCode,
            section: s.section,
            sibling_id: s.id,
            standard_section_id: me?._id,
          })),
        },
        token
      );
    },
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['transport-renewal'] }),
  });
};
