import { useMutation } from '@tanstack/react-query';

import { apiClient, ApiError } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';
import type { MarkAttendanceStudent } from '@/queries/useMarkAttendanceRosterMutation';

export type MarkAttendanceAbsentEntry = {
  studentId: string;
  type: 'first' | 'second' | 'full';
  value: 0.5 | 1;
  reason: string;
  details: string;
  information: string;
};

/** Native: POST attendance/mark-attendance (MarkAttendanceFragment). */
export const useMarkAttendanceMutation = () => {
  const token = useSessionStore((s) => s.session?.token);

  return useMutation({
    mutationFn: async (variables: {
      standardId: string;
      sectionId: string;
      date: string;
      absentStudents: MarkAttendanceAbsentEntry[];
      roster: MarkAttendanceStudent[];
    }) => {
      if (!token) throw new ApiError('Not signed in');

      const unchanged = variables.roster.filter((s) => !s.isSectionChanged);

      return apiClient.post<{ message?: string }>(
        'attendance/mark-attendance',
        {
          standard_id: variables.standardId,
          standard_section_id: variables.sectionId,
          date: variables.date,
          students: variables.absentStudents.map((s) => ({
            student_id: s.studentId,
            type: s.type,
            value: s.value,
            reason: s.reason,
            details: s.details,
            information: s.information,
          })),
          allstudent: unchanged.map((s) => ({ student_id: s.id })),
          no_of_student: unchanged.length,
        },
        token
      );
    },
  });
};
