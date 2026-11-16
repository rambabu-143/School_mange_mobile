import { useMutation } from '@tanstack/react-query';

import { apiClient, ApiError } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type MarkAttendanceStudent = {
  id: string;
  name?: string | null;
  admissionNo?: string | null;
  profilePic?: string | null;
  isSectionChanged: boolean;
  isWithdrawnSection: boolean;
  first: boolean;
  second: boolean;
  reason: string;
  information: string;
  others: string;
};

type ApiStudent = {
  _id?: string | null;
  name?: string | null;
  admission_no?: string | null;
  profile_pic?: string | null;
  is_section_changed?: boolean | null;
  standard_section_id?: { section?: string | null } | null;
  attendance?: { type?: string | null; reason?: string | null; details?: string | null; information?: string | null } | null;
};

/** Native: GET /attendance/mark-attendance/{standard_id}/{standard_section_id}/{date} (roster + any existing marks for that date). Used both for the initial "Go" fetch and for "carry forward" (re-fetched with an earlier date, then merged onto the current roster). */
export const useMarkAttendanceRosterMutation = () => {
  const token = useSessionStore((s) => s.session?.token);

  return useMutation({
    mutationFn: async (variables: { standardId: string; sectionId: string; date: string }): Promise<MarkAttendanceStudent[]> => {
      if (!token) throw new ApiError('Not signed in');

      const result = await apiClient.getEnvelope<ApiStudent[]>(
        `attendance/mark-attendance/${variables.standardId}/${variables.sectionId}/${variables.date}`,
        token
      );
      return (result.data ?? []).filter((s): s is ApiStudent => !!s?._id).map((s) => {
        const type = s.attendance?.type;
        return {
          id: s._id!,
          name: s.name,
          admissionNo: s.admission_no,
          profilePic: s.profile_pic,
          isSectionChanged: !!s.is_section_changed,
          isWithdrawnSection: s.standard_section_id?.section === 'W',
          first: type === 'first' || type === 'full',
          second: type === 'second' || type === 'full',
          reason: s.attendance?.reason ?? '',
          information: s.attendance?.information ?? '',
          others: s.attendance?.details ?? '',
        };
      });
    },
  });
};
