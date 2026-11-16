import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

type Address = { local_address?: string | null; city?: string | null; pincode?: unknown };

export type ProfileDetail = {
  name?: string | null;
  email?: string | null;
  mobile?: string | null;
  profilePic?: string | null;
  path?: string | null;
  // student/parent only
  admissionNo?: string | null;
  dateOfAdmission?: string | null;
  standardSectionId?: string | null;
  gender?: string | null;
  dateOfBirth?: string | null;
  nationality?: string | null;
  aadharCard?: string | null;
  smsMobile?: string | null;
  house?: string | null;
  subjects?: string | null;
  scholastic?: string | null;
  address?: { localAddress?: string | null; city?: string | null; state?: string | null; country?: string | null; pincode?: string | null } | null;
  // staff only
  employeeCode?: string | null;
  departmentName?: string | null;
  qualification?: string | null;
  dateOfJoining?: string | null;
  dateOfAnniversary?: string | null;
  spouseName?: string | null;
  emergencyMobile?: string | null;
  emergencyName?: string | null;
  children?: { standardName?: string | null; admissionNo?: string | null }[] | null;
  // student only
  medical?: {
    bloodGroup?: string | null;
    allergies?: string | null;
    height?: string | null;
    weight?: string | null;
    visionLeft?: string | null;
    visionRight?: string | null;
    hygiene?: string | null;
    bmi?: string | null;
    hearing?: string | null;
    lips?: string | null;
    teeth?: string | null;
    plaque?: string | null;
    gums?: string | null;
    breath?: string | null;
    dentalConcerns?: string | null;
    generalObservation?: string | null;
    otherObservation?: string | null;
    specificAilment?: string | null;
  } | null;
  siblings?: { name?: string | null; admissionNo?: string | null; standardName?: string | null; sectionName?: string | null; profilePic?: string | null }[] | null;
  relations?: {
    relation?: string | null;
    name?: string | null;
    qualification?: string | null;
    occupation?: string | null;
    organization?: string | null;
    designation?: string | null;
    officeAddress?: string | null;
    officePhone?: string | null;
    email?: string | null;
    mobile?: string | null;
    pan?: string | null;
  }[] | null;
  // student/parent and staff — shape from student's last transportAry entry or staff's current route
  transport?: { morning?: string | null; evening?: string | null; pickup?: string | null; dropoff?: string | null; fromMonth?: string | null; toMonth?: string | null } | null;
  // student only — used by the Homework subject picker
  subjectOptions?: { id: string; label: string }[] | null;
  // staff only — classes assigned to this staff member (native: staffDetail.schools[0].access_standard_section), used by staff Timetable
  accessStandardSection?: { id: string; standardId: string; label: string }[] | null;
  // staff only — branches this staff member has access to (native: BRANCH_DATA_FOR_STAFF, staffDetail.schools filtered by is_access), used by Settings' branch switcher
  branches?: { branchCode: string; schoolCode: string }[] | null;
};

type StudentDetailData = {
  name?: string | null;
  email?: string | null;
  mobile?: string | null;
  profile_pic?: string | null;
  admission_no?: string | null;
  date_of_admission?: string | null;
  standard_section_id?: { _id?: string | null } | null;
  gender?: string | null;
  date_of_birth?: string | null;
  nationality?: string | null;
  aadhar_card?: string | null;
  sms_mobile?: string | null;
  house_id?: { house_no?: string | null } | null;
  combo_id?: { subjects?: { _id?: string | null; subject_name?: string | null }[] | null } | null;
  achievement?: { scholastic?: { name?: string | null } | null } | null;
  address?:
    | ({
        local_address?: string | null;
        city?: string | null;
        pincode?: unknown;
        state_id?: { state_name?: string | null } | null;
        country_id?: { country_name?: string | null } | null;
      } | null)[]
    | null;
  medical?: {
    bloodgroup?: string | null;
    allergies?: string | null;
    height?: string | null;
    weight?: string | null;
    vision_left?: string | null;
    vision_right?: string | null;
    hygiene?: string | null;
    bmi?: string | null;
    hearing?: string | null;
    lips?: string | null;
    teeth?: string | null;
    plaque?: string | null;
    gums?: string | null;
    breath?: string | null;
    dental_concerns?: string | null;
    general_observation?: string | null;
    other_observation?: string | null;
    specificailment?: string | null;
  } | null;
  siblings?:
    | ({
        sibling_id?: {
          name?: string | null;
          admission_no?: string | null;
          profile_pic?: string | null;
          standard_id?: { name?: string | null } | null;
          section_id?: { name?: string | null } | null;
        } | null;
      } | null)[]
    | null;
  relation?:
    | ({
        relation?: string | null;
        name?: string | null;
        mobile?: string | null;
        email?: string | null;
        organization?: string | null;
        designation?: string | null;
        office_address?: string | null;
        office_phone?: string | null;
        pancard?: string | null;
        other_occupation?: string | null;
        qualification_id?: { qualification?: string | null } | null;
        occupation_id?: { occupation_name?: string | null } | null;
        occupation_child_id?: { occupation_child_name?: string | null } | null;
      } | null)[]
    | null;
  transport_bill_id?: {
    transportAry?: ({ morningroute?: string | null; eveningroute?: string | null; morningstop?: string | null; eveningstop?: string | null } | null)[] | null;
  } | null;
};

type StaffDetailData = {
  name?: string | null;
  email?: string | null;
  mobile?: string | null;
  profile_pic?: string | null;
  employee_code?: string | null;
  qualification?: string | null;
  department_id?: { name?: string | null } | null;
  date_of_birth?: string | null;
  date_of_joining?: string | null;
  date_of_anniversary?: string | null;
  spouse_name?: string | null;
  emergency_mobile?: string | null;
  emergency_name?: string | null;
  address?: Address | null;
  students?: ({ student_id?: { name?: string | null } | null; admission_no?: string | null } | null)[] | null;
  transport_id?: {
    routes_details?:
      | ({
          m_route_id?: { route_name?: string | null } | null;
          e_route_id?: { route_name?: string | null } | null;
          m_transport_route_stop_id?: { stop_name?: string | null } | null;
          e_transport_route_stop_id?: { stop_name?: string | null } | null;
          e_month_from?: number | null;
          m_month_to?: number | null;
        } | null)[]
      | null;
  } | null;
  schools?:
    | ({
        branch_code?: number | null;
        school_code?: string | null;
        is_access?: boolean | null;
        access_standard_section?:
          | ({ _id?: string | null; standard?: string | null; section?: string | null; standard_id?: string | null } | null)[]
          | null;
      } | null)[]
    | null;
};

const MONTH_NAMES = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/** Native: GET student/detail/{id} (student/parent) or GET staff/{id} (staff) — fetched post-login for profile fields the login response doesn't carry. */
export const useProfileDetailQuery = () => {
  const { token, userId, isStaff } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!userId,
    queryKey: ['profile-detail', userId],
    queryFn: async (): Promise<ProfileDetail> => {
      if (isStaff) {
        const result = await apiClient.getEnvelope<StaffDetailData>(`staff/${userId}`, token);
        const data = result.data;
        return {
          name: data?.name,
          email: data?.email,
          mobile: data?.mobile,
          profilePic: data?.profile_pic,
          path: result.path as string | null,
          employeeCode: data?.employee_code,
          departmentName: data?.department_id?.name,
          qualification: data?.qualification,
          dateOfBirth: data?.date_of_birth,
          dateOfJoining: data?.date_of_joining,
          dateOfAnniversary: data?.date_of_anniversary,
          spouseName: data?.spouse_name,
          emergencyMobile: data?.emergency_mobile,
          emergencyName: data?.emergency_name,
          address: data?.address
            ? { localAddress: data.address.local_address, city: data.address.city, pincode: String(data.address.pincode ?? '') }
            : null,
          children: data?.students?.filter(Boolean).map((s) => ({
            standardName: s?.student_id?.name,
            admissionNo: s?.admission_no,
          })),
          transport: data?.transport_id?.routes_details?.[0]
            ? {
                morning: data.transport_id.routes_details[0]?.m_route_id?.route_name,
                evening: data.transport_id.routes_details[0]?.e_route_id?.route_name,
                pickup: data.transport_id.routes_details[0]?.m_transport_route_stop_id?.stop_name,
                dropoff: data.transport_id.routes_details[0]?.e_transport_route_stop_id?.stop_name,
                // Mirrors native TransportFragment field-for-field (fromValue reads e_month_from, toValue reads m_month_to) — looks
                // like a native labeling quirk, kept as-is for parity rather than silently "fixing" it.
                fromMonth: MONTH_NAMES[(data.transport_id.routes_details[0]?.e_month_from ?? 1) - 1],
                toMonth: MONTH_NAMES[(data.transport_id.routes_details[0]?.m_month_to ?? 1) - 1],
              }
            : null,
          accessStandardSection: data?.schools?.[0]?.access_standard_section?.filter(Boolean).map((s) => ({
            id: s!._id ?? '',
            standardId: s!.standard_id ?? '',
            label: [s!.standard, s!.section].filter(Boolean).join(' '),
          })),
          branches: data?.schools
            ?.filter((s) => s?.is_access)
            .map((s) => ({ branchCode: String(s!.branch_code ?? ''), schoolCode: s!.school_code ?? '' })),
        };
      }

      const result = await apiClient.getEnvelope<StudentDetailData>(`student/detail/${userId}`, token);
      const data = result.data;
      const lastAddress = data?.address?.filter(Boolean).at(-1);
      return {
        name: data?.name,
        email: data?.email,
        mobile: data?.mobile,
        profilePic: data?.profile_pic,
        path: result.path as string | null,
        admissionNo: data?.admission_no,
        dateOfAdmission: data?.date_of_admission,
        standardSectionId: data?.standard_section_id?._id,
        gender: data?.gender,
        dateOfBirth: data?.date_of_birth,
        nationality: data?.nationality,
        aadharCard: data?.aadhar_card,
        smsMobile: data?.sms_mobile,
        house: data?.house_id?.house_no,
        subjects: data?.combo_id?.subjects
          ?.filter(Boolean)
          .map((s) => s?.subject_name)
          .join(', '),
        subjectOptions: data?.combo_id?.subjects?.filter(Boolean).map((s) => ({ id: s!._id ?? '', label: s!.subject_name ?? '' })),
        scholastic: data?.achievement?.scholastic?.name,
        address: lastAddress
          ? {
              localAddress: lastAddress.local_address,
              city: lastAddress.city,
              state: lastAddress.state_id?.state_name,
              country: lastAddress.country_id?.country_name,
              pincode: String(lastAddress.pincode ?? ''),
            }
          : null,
        medical: data?.medical
          ? {
              bloodGroup: data.medical.bloodgroup,
              allergies: data.medical.allergies,
              height: data.medical.height,
              weight: data.medical.weight,
              visionLeft: data.medical.vision_left,
              visionRight: data.medical.vision_right,
              hygiene: data.medical.hygiene,
              bmi: data.medical.bmi,
              hearing: data.medical.hearing,
              lips: data.medical.lips,
              teeth: data.medical.teeth,
              plaque: data.medical.plaque,
              gums: data.medical.gums,
              breath: data.medical.breath,
              dentalConcerns: data.medical.dental_concerns,
              generalObservation: data.medical.general_observation,
              otherObservation: data.medical.other_observation,
              specificAilment: data.medical.specificailment,
            }
          : null,
        siblings: data?.siblings?.filter(Boolean).map((s) => ({
          name: s?.sibling_id?.name,
          admissionNo: s?.sibling_id?.admission_no,
          standardName: s?.sibling_id?.standard_id?.name,
          sectionName: s?.sibling_id?.section_id?.name,
          profilePic: s?.sibling_id?.profile_pic,
        })),
        relations: data?.relation?.filter(Boolean).map((r) => {
          const occupationName = r?.occupation_id?.occupation_name;
          const childName = r?.occupation_child_id?.occupation_child_name;
          const isOther = (name?: string | null) => (name ?? '').toLowerCase().startsWith('other');
          const occupation = isOther(occupationName)
            ? r?.other_occupation
            : childName
              ? `${occupationName}, ${isOther(childName) ? r?.other_occupation : childName}`
              : occupationName;
          return {
            relation: r?.relation,
            name: r?.name,
            qualification: r?.qualification_id?.qualification,
            occupation,
            organization: r?.organization,
            designation: r?.designation,
            officeAddress: r?.office_address,
            officePhone: r?.office_phone,
            email: r?.email,
            mobile: r?.mobile,
            pan: r?.pancard,
          };
        }),
        transport: data?.transport_bill_id?.transportAry?.filter(Boolean).at(-1)
          ? (() => {
              const last = data.transport_bill_id!.transportAry!.filter(Boolean).at(-1)!;
              return { morning: last.morningroute, evening: last.eveningroute, pickup: last.morningstop, dropoff: last.eveningstop };
            })()
          : null,
      };
    },
  });
};
