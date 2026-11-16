import { useQuery } from '@tanstack/react-query';

import { apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type ClassListStudent = {
  id: string;
  name?: string | null;
  admissionNo?: string | null;
  gender?: string | null;
  profilePic?: string | null;
  smsMobile?: string | null;
  wiseTotal?: string | null;
  disciplinaryTotal?: string | null;
  todayAttendance?: string | null;
  totalPresent?: number | null;
  totalDays?: number | null;
};

type ApiStudent = {
  _id?: string | null;
  name?: string | null;
  admission_no?: string | null;
  gender?: string | null;
  profile_pic?: string | null;
  sms_mobile?: string | null;
  wise?: { total?: string | null } | null;
  disciplinary?: { total?: string | null } | null;
  attendance_data?: { today_attendance?: string | null; total_present?: number | null; total_days?: number | null } | null;
};

/** Native: GET report/student/class-list/section-wise/{section_id} (ClassListFragment). */
export const useClassListQuery = (sectionId: string | null) => {
  const token = useSessionStore((s) => s.session?.token);

  return useQuery({
    enabled: !!token && !!sectionId,
    queryKey: ['class-list', sectionId],
    queryFn: async (): Promise<ClassListStudent[]> => {
      const result = await orEmpty(apiClient.getEnvelope<ApiStudent[]>(`report/student/class-list/section-wise/${sectionId}`, token), { data: [] });
      return (result.data ?? []).filter((s): s is ApiStudent => !!s?._id).map((s) => ({
        id: s._id!,
        name: s.name,
        admissionNo: s.admission_no,
        gender: s.gender,
        profilePic: s.profile_pic ? `${result.path ?? ''}${s.profile_pic}` : null,
        smsMobile: s.sms_mobile,
        wiseTotal: s.wise?.total,
        disciplinaryTotal: s.disciplinary?.total,
        todayAttendance: s.attendance_data?.today_attendance,
        totalPresent: s.attendance_data?.total_present,
        totalDays: s.attendance_data?.total_days,
      }));
    },
  });
};
