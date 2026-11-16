import { useMutation, useQueryClient } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type SiblingLookupResult = {
  admissionNo?: string | null;
  name?: string | null;
  schoolCode?: string | null;
  section?: string | null;
  standardSectionId?: string | null;
};

type ApiSibling = {
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
        admissionNo: data?.admission_no,
        name: data?.name,
        schoolCode: data?.school_code,
        section: data?.standard_section_id?.section,
        standardSectionId: data?.standard_section_id?._id,
      };
    },
  });
};

export type TransportRenewalSubmit = {
  transportType: 'renew' | 'withdraw';
  siblings: { admissionNo?: string | null; name?: string | null; schoolCode?: string | null; standardSectionId?: string | null }[];
};

/** Native: POST transport/renewal-form (TransportRenewalFragment's confirm dialog Save). */
export const useTransportRenewalMutation = () => {
  const { token, userId, admissionNo, standardId } = useSessionStore((s) => s.session) ?? {};
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (form: TransportRenewalSubmit) => {
      if (!token || !userId) throw new Error('Not signed in');
      return apiClient.post<{ message?: string }>(
        'transport/renewal-form',
        {
          admission_no: admissionNo,
          student_id: userId,
          transport_type: form.transportType,
          sibling_details: form.siblings.map((s) => ({
            admission_no: s.admissionNo,
            name: s.name,
            school_code: s.schoolCode,
            sibling_id: s.standardSectionId,
            standard_section_id: standardId,
          })),
        },
        token
      );
    },
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['transport-renewal'] }),
  });
};
