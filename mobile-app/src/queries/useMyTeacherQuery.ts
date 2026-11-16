import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type MyTeacherEntry = { id?: string | null; name?: string | null; title: string; profilePic?: string | null };

type IdName = { _id?: string | null; name?: string | null; profile_pic?: string | null } | null;
type ApiResponse = {
  path?: string | null;
  class?: { class_teacher_id?: IdName; helper_teacher_id?: IdName } | null;
  house?: { house_incharge_id?: IdName[] | null } | null;
  subjects?:
    | ({ subject_name?: string | null; subject_teacher_id?: { staff_id?: IdName }[] | null } | null)[]
    | null;
};

/** Native: GET student/detail/my-teacher/{id} (MyTeacherFragment). Student/parent only. */
export const useMyTeacherQuery = () => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['my-teacher', userId],
    queryFn: async (): Promise<MyTeacherEntry[]> => {
      const result = await apiClient.getEnvelope<ApiResponse>(`student/detail/my-teacher/${userId}`, token);
      const data = result as unknown as ApiResponse;
      const path = data.path ?? '';
      const withPath = (pic?: string | null) => (pic ? `${path}/${pic}` : null);

      const entries: MyTeacherEntry[] = [];
      if (data.class?.class_teacher_id) {
        entries.push({
          id: data.class.class_teacher_id._id,
          name: data.class.class_teacher_id.name,
          title: 'Class Teacher',
          profilePic: withPath(data.class.class_teacher_id.profile_pic),
        });
      }
      if (data.class?.helper_teacher_id) {
        entries.push({
          id: data.class.helper_teacher_id._id,
          name: data.class.helper_teacher_id.name,
          title: 'Helper Teacher',
          profilePic: withPath(data.class.helper_teacher_id.profile_pic),
        });
      }
      for (const houseTeacher of data.house?.house_incharge_id ?? []) {
        if (!houseTeacher) continue;
        entries.push({ id: houseTeacher._id, name: houseTeacher.name, title: 'House Teacher', profilePic: withPath(houseTeacher.profile_pic) });
      }
      for (const subject of data.subjects ?? []) {
        const staff = subject?.subject_teacher_id?.[0]?.staff_id;
        if (!staff) continue;
        entries.push({ id: staff._id, name: staff.name, title: subject?.subject_name ?? '', profilePic: withPath(staff.profile_pic) });
      }
      return entries;
    },
  });
};
