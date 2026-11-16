import { useQuery } from '@tanstack/react-query';

import { apiClient, orEmpty } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';
import { useProfileDetailQuery } from '@/queries/useProfileDetailQuery';

export type GalleryImage = {
  file_name?: string | null;
  is_thumbnail?: boolean | null;
  _id?: string | null;
};

export type GalleryEvent = {
  _id?: string | null;
  name?: string | null;
  event_date?: string | null;
  thumbnail?: string | null;
  description?: string | null;
  information?: string | null;
  images: GalleryImage[];
};

type GalleryData = {
  data?: GalleryEvent[] | null;
  path?: string | null;
};

// Native always reads this from a SharedPreferences key that's only ever populated by the
// student-detail fetch — staff/parent-without-a-student-record naturally get '' there too,
// so mirroring that exactly (not just for staff) matches native behavior.
export const useGalleryQuery = () => {
  const { token, isStaff } = useSessionStore((s) => s.session) ?? {};
  const profileDetailQuery = useProfileDetailQuery();
  const dateOfAdmission = (!isStaff && profileDetailQuery.data?.dateOfAdmission) || '';

  return useQuery({
    enabled: !!token && (isStaff || profileDetailQuery.isSuccess),
    queryKey: ['gallery', dateOfAdmission],
    queryFn: () => orEmpty(apiClient.getEnvelopeRaw<GalleryEvent[]>(`event-gallery/all/${dateOfAdmission}`, token), { data: [] }),
    select: (result): GalleryData => ({ data: result.data, path: result.path as string | null }),
  });
};
