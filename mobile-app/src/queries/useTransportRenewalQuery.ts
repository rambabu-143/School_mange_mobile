import { useQuery } from '@tanstack/react-query';

import { apiClient, ApiError } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

type ApiRelation = { relation?: string | null; mobile?: string | null };
type ApiAddress = { local_address?: string | null; city?: string | null; pincode?: unknown; state_id?: { state_name?: string | null } | null; country_id?: { country_name?: string | null } | null };
type ApiRoute = { morningroute?: string | null; morningstop?: string | null; eveningroute?: string | null; eveningstop?: string | null };
type ApiData = {
  admission_no?: string | null;
  name?: string | null;
  sms_mobile?: string | null;
  relation?: (ApiRelation | null)[] | null;
  address?: (ApiAddress | null)[] | null;
  standard_section_id?: { section?: string | null } | null;
  transport_id?: { routeData?: (ApiRoute | null)[] | null } | null;
};
type ApiResponse = {
  status?: boolean | null;
  message?: string | null;
  data?: ApiData | null;
  branch_details?: { branch_address?: string | null } | null;
  promoted_class?: string | null;
  next_year_session?: string | null;
};

export type TransportRenewalForm = {
  admissionNo?: string | null;
  studentName?: string | null;
  address?: string | null;
  smsMobile?: string | null;
  fatherMobile?: string | null;
  motherMobile?: string | null;
  currentMorningRoute?: string | null;
  currentPickupStop?: string | null;
  currentEveningRoute?: string | null;
  currentDropStop?: string | null;
  branchAddress?: string | null;
  promotedClass?: string | null;
  nextYearSession?: string | null;
};

/** Native: GET transport/renewal-form/{student_id} (TransportRenewalFragment). A "Transport
 * Renewal Form already filled!" or "closed" response is a normal state, not a hard error. */
export const useTransportRenewalQuery = () => {
  const { token, userId } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['transport-renewal', userId],
    queryFn: async (): Promise<{ form: TransportRenewalForm | null; message: string | null }> => {
      try {
        const result = await apiClient.getEnvelope<ApiData>(`transport/renewal-form/${userId}`, token);
        const full = result as unknown as ApiResponse;
        const data = full.data;
        const address = data?.address?.at(-1);
        const route = data?.transport_id?.routeData?.at(-1);
        const father = data?.relation?.find((r) => (r?.relation ?? '').toUpperCase() === 'FATHER');
        const mother = data?.relation?.find((r) => (r?.relation ?? '').toUpperCase() !== 'FATHER');
        return {
          form: {
            admissionNo: data?.admission_no,
            studentName: data?.name,
            address: address ? `${address.local_address ?? ''}, ${address.city ?? ''}, ${address.state_id?.state_name ?? ''}, ${address.country_id?.country_name ?? ''}, ${address.pincode ?? ''}` : null,
            smsMobile: data?.sms_mobile,
            fatherMobile: father?.mobile,
            motherMobile: mother?.mobile,
            currentMorningRoute: route?.morningroute,
            currentPickupStop: route?.morningstop,
            currentEveningRoute: route?.eveningroute,
            currentDropStop: route?.eveningstop,
            branchAddress: full.branch_details?.branch_address,
            promotedClass: full.promoted_class ? `${full.promoted_class} ${data?.standard_section_id?.section ?? ''}` : null,
            nextYearSession: full.next_year_session,
          },
          message: null,
        };
      } catch (e) {
        // "already filled" / "form closed" come back as status:false with a message - a normal
        // state to display, not an error to throw.
        if (e instanceof ApiError) return { form: null, message: e.message };
        throw e;
      }
    },
  });
};
