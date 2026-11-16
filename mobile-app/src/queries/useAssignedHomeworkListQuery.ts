import { useQuery } from '@tanstack/react-query';

import { apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type AssignedHomework = {
  id: string;
  text?: string | null;
  date?: string | null;
  attachment?: string | null;
  googleDriveLink?: string | null;
  className?: string | null;
  studentsLabel: string;
  subjectName?: string | null;
  teacherName?: string | null;
};

type ApiSection = { standard?: string | null; section?: string | null } | null;
type ApiHomework = {
  _id?: string | null;
  text?: string | null;
  date?: string | null;
  attachment?: string | null;
  google_drive_link?: string | null;
  selected_section?: ApiSection;
  standard_section?: ApiSection;
  students?: string[] | null;
  subject_id?: { subject_name?: string | null } | null;
  sent_by_staff?: { name?: string | null } | null;
};

function mapHomework(h: ApiHomework): AssignedHomework {
  const section = h.selected_section ?? h.standard_section;
  return {
    id: h._id ?? '',
    text: h.text,
    date: h.date,
    attachment: h.attachment,
    googleDriveLink: h.google_drive_link,
    className: [section?.standard, section?.section].filter(Boolean).join(' '),
    studentsLabel: h.students && h.students.length > 0 ? String(h.students.length) : 'All',
    subjectName: h.subject_id?.subject_name,
    teacherName: h.sent_by_staff?.name,
  };
}

/** Native: GET homework/all/{start_date}/{end_date} (AssignedHomeworkListFragment). Dates are DD-MM-YYYY. */
export const useAssignedHomeworkListQuery = (startDate: string, endDate: string) => {
  const token = useSessionStore((s) => s.session?.token);

  return useQuery({
    enabled: !!token && !!startDate && !!endDate,
    queryKey: ['assigned-homework', startDate, endDate],
    queryFn: async (): Promise<AssignedHomework[]> => {
      const result = await orEmpty(apiClient.getEnvelope<ApiHomework[]>(`homework/all/${startDate}/${endDate}`, token), { data: [] });
      return (result.data ?? []).map(mapHomework);
    },
  });
};

export { mapHomework };
export type { ApiHomework };
