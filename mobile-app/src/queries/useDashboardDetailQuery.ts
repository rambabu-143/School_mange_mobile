import { useQuery } from '@tanstack/react-query';
import dayjs from 'dayjs';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

type PdfRef = { data?: { file_name?: string | null } | null; path?: string | null };
type DashboardDetail = { newsletter?: PdfRef | null; chronicles?: PdfRef | null };

const toUrl = (ref?: PdfRef | null) => (ref?.data?.file_name ? `${ref.path ?? ''}${ref.data.file_name}` : null);

/**
 * Native: DashboardActivity's student-dashboard/staff-dashboard fetch — a large payload, we only
 * need the Chronicles/NewsLetter PDF URLs from it (mChronicles/mNewsletter). start_date/end_date
 * don't affect these two fields (unfiltered "latest" lookup server-side); today's date is passed
 * only because the endpoint requires the params.
 */
export const useDashboardDetailQuery = () => {
  const { token, userId, isStaff } = useSessionStore((s) => s.session) ?? {};
  const today = dayjs().format('DD-MM-YYYY');

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['dashboard-detail', userId, today],
    queryFn: async () => {
      const path = isStaff ? `dashboard/staff-dashboard/${userId}/${today}/${today}` : `dashboard/student-dashboard/${userId}/${today}/${today}`;
      const result = await apiClient.getEnvelope<unknown>(path, token);
      // newsletter/chronicles sit at the top level of the response (siblings of `status`), not under `data`.
      const detail = result as DashboardDetail;
      return {
        newsletterUrl: toUrl(detail.newsletter),
        chroniclesUrl: toUrl(detail.chronicles),
      };
    },
  });
};
