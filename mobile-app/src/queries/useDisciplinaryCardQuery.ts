import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type DisciplinaryEntry = {
  id: string;
  reason?: string | null;
  reasonOther?: string | null;
  actionTaken?: string | null;
  housePoint?: number | null;
  issueDate?: string | null;
  staffName?: string | null;
  houseNo?: string | null;
  issuedTo?: string | null;
};

export type DisciplinaryCategory = { count: number; entries: DisciplinaryEntry[] };
export type DisciplinaryCard = { pink: DisciplinaryCategory; yellow: DisciplinaryCategory; red: DisciplinaryCategory };

type ApiEntry = {
  _id?: string | null;
  reason?: string | null;
  reason_other?: string | null;
  action_taken?: string | null;
  house_point?: number | null;
  issue_date?: string | null;
  staff_id?: { name?: string | null } | null;
  student_id?: { house_id?: { house_no?: string | null } | null } | null;
};
type ApiCategory = { count?: number | null; data?: (ApiEntry | null)[] | null };
type ApiResponse = { pink?: ApiCategory | null; yellow?: ApiCategory | null; red?: ApiCategory | null };

type ApiStudent = { name?: string | null; admission_no?: string | null; standard_section_id?: { standard?: string | null; section?: string | null } | null };

const mapCategory = (cat?: ApiCategory | null, issuedTo?: string | null): DisciplinaryCategory => ({
  count: cat?.count ?? 0,
  entries: (cat?.data ?? []).filter((e): e is ApiEntry => !!e).map((e) => ({
    id: e._id ?? '',
    reason: e.reason,
    reasonOther: e.reason_other,
    actionTaken: e.action_taken,
    housePoint: e.house_point,
    issueDate: e.issue_date,
    staffName: e.staff_id?.name,
    houseNo: e.student_id?.house_id?.house_no,
    issuedTo,
  })),
});

/** Native: GET disciplinary/student-wise/{admission_no} (DisciplinaryCardFragment). Student/parent only. */
export const useDisciplinaryCardQuery = () => {
  const { token, admissionNo } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!admissionNo,
    queryKey: ['disciplinary-card', admissionNo],
    queryFn: async (): Promise<DisciplinaryCard> => {
      const result = await apiClient.getEnvelope<ApiResponse>(`disciplinary/student-wise/${admissionNo}`, token);
      // Native shows "Name (AdmNo) ClassSection" on each card; `student` sits beside `data` in the response.
      const st = result.student as ApiStudent | undefined;
      const issuedTo = st?.name
        ? `${st.name} (${st.admission_no ?? ''}) ${st.standard_section_id?.standard ?? ''}${st.standard_section_id?.section ?? ''}`.trim()
        : null;
      return {
        pink: mapCategory(result.data?.pink, issuedTo),
        yellow: mapCategory(result.data?.yellow, issuedTo),
        red: mapCategory(result.data?.red, issuedTo),
      };
    },
  });
};
