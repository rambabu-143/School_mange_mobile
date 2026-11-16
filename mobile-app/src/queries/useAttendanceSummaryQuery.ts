import { useQuery } from '@tanstack/react-query';

import { apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type AttendanceSummaryStudent = {
  id: string;
  name?: string | null;
  admissionNo?: string | null;
  isHalfDay: boolean;
  reason?: string | null;
  details?: string | null;
};

export type AttendanceSummarySection = {
  id: string;
  standard?: string | null;
  section?: string | null;
  isAttendanceMarked: boolean;
  attendanceMarkedAt?: string | null;
  totalStudent?: number | null;
  students: AttendanceSummaryStudent[];
};

type ApiData = {
  _id?: string | null;
  standard?: string | null;
  section?: string | null;
  total_student?: number | null;
  is_attendance_marked?: boolean | null;
  attendance_marked_at?: string | null;
  students?:
    | ({
        student_id?: { _id?: string | null; admission_no?: string | null; name?: string | null } | null;
        value?: number | null;
        reason?: string | null;
        details?: string | null;
      } | null)[]
    | null;
};

/** Native: GET /attendance/attendance-summary/{date} (AttendanceSummaryFragment). Date format dd-MM-yyyy. */
export const useAttendanceSummaryQuery = (date: string) => {
  const token = useSessionStore((s) => s.session?.token);

  return useQuery({
    enabled: !!token && !!date,
    queryKey: ['attendance-summary', date],
    queryFn: async (): Promise<AttendanceSummarySection[]> => {
      const result = await orEmpty(apiClient.getEnvelope<ApiData[]>(`attendance/attendance-summary/${date}`, token), { data: [] });
      return (result.data ?? []).filter((d): d is ApiData => !!d?._id).map((d) => ({
        id: d._id!,
        standard: d.standard,
        section: d.section,
        isAttendanceMarked: !!d.is_attendance_marked,
        attendanceMarkedAt: d.attendance_marked_at,
        totalStudent: d.total_student,
        students: (d.students ?? []).filter(Boolean).map((s) => ({
          id: s!.student_id?._id ?? '',
          name: s!.student_id?.name,
          admissionNo: s!.student_id?.admission_no,
          isHalfDay: s!.value === 0.5,
          reason: s!.reason,
          details: s!.details,
        })),
      }));
    },
  });
};
