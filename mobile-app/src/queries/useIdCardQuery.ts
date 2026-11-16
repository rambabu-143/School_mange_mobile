import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

type ApiAddress = { local_address?: string | null; city?: string | null; pincode?: unknown };
type ApiData = {
  name?: string | null;
  admission_no?: string | null;
  profile_pic?: string | null;
  class_section?: string | null;
  date_of_birth?: string | null;
  bloodgroup?: string | null;
  allergies?: string | null;
  fathers_name?: string | null;
  address?: ApiAddress | null;
  sms_mobile?: string | null;
  transport_type?: string | null;
  morning_route?: string | null;
  evening_route?: string | null;
  session?: string | null;
};
type ApiResponse = {
  data?: ApiData | null;
  path?: string | null;
  is_form_submitted?: boolean | null;
  is_change_request?: boolean | null;
  change_message?: string | null;
};

export type IdCardDetail = {
  name?: string | null;
  admissionNo?: string | null;
  profilePic?: string | null;
  classSection?: string | null;
  dateOfBirth?: string | null;
  bloodGroup?: string | null;
  allergies?: string | null;
  fathersName?: string | null;
  address?: string | null;
  mobile?: string | null;
  transport?: string | null;
  session?: string | null;
  formSubmitted?: boolean;
  changeMessage?: string | null;
};

/** Native: GET/PUT student/id-card/{student_id} (IdCardFragment). Student/parent only. */
export const useIdCardQuery = () => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['id-card', userId],
    queryFn: async (): Promise<IdCardDetail> => {
      const result = await apiClient.getEnvelope<ApiData>(`student/id-card/${userId}`, token);
      const full = result as unknown as ApiResponse;
      const data = full.data;
      const transport =
        data?.morning_route || data?.evening_route
          ? `M: ${data.morning_route ?? ''} E: ${data.evening_route ?? ''}`
          : (data?.transport_type ?? '').toUpperCase();
      return {
        name: data?.name,
        admissionNo: data?.admission_no,
        profilePic: data?.profile_pic ? `${full.path ?? ''}${data.profile_pic}` : null,
        classSection: data?.class_section,
        dateOfBirth: data?.date_of_birth,
        bloodGroup: data?.bloodgroup,
        allergies: data?.allergies,
        fathersName: data?.fathers_name,
        address: data?.address ? `${data.address.local_address ?? ''}, ${data.address.city ?? ''}-${data.address.pincode ?? ''}` : null,
        mobile: data?.sms_mobile,
        transport,
        session: data?.session,
        formSubmitted: !!full.is_form_submitted,
        changeMessage: full.change_message,
      };
    },
  });
};
