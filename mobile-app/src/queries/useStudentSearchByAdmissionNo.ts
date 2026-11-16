import { useMutation } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type ScannedStudent = {
  id: string;
  admissionNo: string;
  name?: string | null;
  profilePic?: string | null;
  standardName?: string | null;
  sectionName?: string | null;
};

type ApiStudent = {
  _id?: string | null;
  name?: string | null;
  profile_pic?: string | null;
  standard_id?: { name?: string | null } | null;
  section_id?: { name?: string | null } | null;
};

/**
 * Native: POST student/detail/search {admission_no, search_type: "min-search"} — shared by
 * DiscplinaryCardStaffViewController's and Wise's StudentViewController QR-scan flows to resolve
 * the admission_no encoded in a student's ID card QR to a student record. Response rows don't
 * include admission_no (native's own select projection omits it) — carry the scanned value forward
 * instead of trusting the response for it.
 */
export const useStudentSearchByAdmissionNo = () => {
  const token = useSessionStore((s) => s.session?.token);

  return useMutation({
    mutationFn: async (admissionNo: string): Promise<ScannedStudent> => {
      const students = await apiClient.post<ApiStudent[]>(
        'student/detail/search',
        { admission_no: admissionNo, search_type: 'min-search' },
        token
      );
      const student = students?.[0];
      if (!student?._id) throw new Error(`No student found for admission no. ${admissionNo}`);
      return {
        id: student._id,
        admissionNo,
        name: student.name,
        profilePic: student.profile_pic,
        standardName: student.standard_id?.name,
        sectionName: student.section_id?.name,
      };
    },
  });
};
