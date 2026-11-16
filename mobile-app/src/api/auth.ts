import { Platform } from 'react-native';

import { apiClient } from '@/lib/api-client';
import type { Session } from '@/lib/session-store';

// Backend enum only accepts 'android' | 'ios' (confirmed in native LoginViewController.swift / OtpActivity.kt) — 'app' 404s validation.
const PLATFORM = Platform.OS === 'ios' ? 'ios' : 'android';

type StudentEntry = {
  student_id?: {
    _id?: string | null;
    name?: string | null;
    email?: string | null;
    admission_no?: string | null;
    profile_pic?: string | null;
    standard_id?: { _id?: string | null; name?: string | null } | null;
  } | null;
};

// Mirrors android/app/.../di/data/login/LoginResponseFromApi.kt — only the fields we need for session state.
export type LoginResponse = {
  path?: string | null;
  parent_path?: string | null;
  meta_data?: {
    token?: string | null;
    is_staff?: boolean | null;
    branch_code?: string | null;
    school_code?: string | null;
    year_session?: string | null;
  } | null;
  user?: {
    _id?: string | null;
    name?: string | null;
    email?: string | null;
    mobile?: string | null;
    is_staff?: boolean | null;
    profile_pic?: string | null;
    staff_id?: { _id?: string | null } | null;
    // student/parent only — a plain student login has exactly one entry (themselves), a parent has one per child.
    students?: (StudentEntry | null)[] | null;
  } | null;
};

/** Staff / student Google sign-in. Native: POST user/googlelogin with the Google ID token as `token`. */
export const googleLogin = (email: string, idToken: string) =>
  apiClient.post<LoginResponse>('user/googlelogin', { email, token: idToken, platform: PLATFORM });

/** Step 1 of parent login. Native: POST user/generate-otp */
export const generateOtp = (mobile: string) =>
  apiClient.post<{ message?: string }>('user/generate-otp', { mobileno: mobile });

/** Step 2 of parent login. Native: POST user/parent-login */
export const verifyOtp = (mobile: string, otp: string) =>
  apiClient.post<LoginResponse>('user/parent-login', { mobileno: mobile, otp, platform: PLATFORM });

/**
 * Native: POST user/switch-student (DashboardActivity's child-switch dialog). Re-issues a full
 * login response for the same parent account — client picks which `students[]` entry is now
 * "current" by matching admission_no, same as buildSessionFromLogin below.
 */
export const switchStudent = (token: string, email: string, admissionNo: string) =>
  apiClient.post<LoginResponse>('user/switch-student', { email, platform: PLATFORM, admission_no: admissionNo }, token);

/**
 * Native: POST user/switch-school (SettingFragment's branch dropdown, staff only). Re-issues a
 * full login response for the new branch — same buildSessionFromLogin path as login/switchStudent.
 */
export const switchBranch = (token: string, branchCode: string) =>
  apiClient.post<LoginResponse>('user/switch-school', { branch_code: branchCode, platform: PLATFORM }, token);

/**
 * Native: USER_ID is the STAFF id for staff (`user.staff_id._id`), or the active STUDENT's own id for
 * student/parent (`user.students[N].student_id._id`) — never the top-level `user._id` (that's the
 * login account document, which for a parent covers multiple children). `targetAdmissionNo` selects
 * which child is active; omitted, defaults to the first (login) or re-matches current (switch).
 */
export function buildSessionFromLogin(
  res: LoginResponse,
  opts: { isParent: boolean; targetAdmissionNo?: string | null }
): Session {
  if (!res.meta_data?.token || !res.user) {
    throw new Error('Login response missing token or user');
  }

  const students = res.user.students?.filter((s): s is StudentEntry => !!s?.student_id) ?? [];
  const active =
    (opts.targetAdmissionNo ? students.find((s) => s.student_id?.admission_no === opts.targetAdmissionNo) : students[0]) ??
    students[0];

  const isStaff = !!res.meta_data.is_staff;

  return {
    token: res.meta_data.token,
    userId: isStaff ? res.user.staff_id?._id ?? res.user._id ?? '' : active?.student_id?._id ?? res.user._id ?? '',
    staffId: res.user.staff_id?._id ?? res.user._id ?? '',
    standardId: active?.student_id?.standard_id?._id ?? null,
    standardName: active?.student_id?.standard_id?.name ?? null,
    admissionNo: active?.student_id?.admission_no ?? null,
    name: (isStaff ? res.user.name : active?.student_id?.name) ?? res.user.name ?? '',
    isStaff,
    isParent: opts.isParent,
    branchCode: res.meta_data.branch_code ?? null,
    yearSession: res.meta_data.year_session ?? null,
    schoolCode: res.meta_data.school_code ?? null,
    imagePath: res.path ?? res.parent_path ?? null,
    children: students.map((s) => ({
      admissionNo: s.student_id?.admission_no ?? '',
      name: s.student_id?.name,
      standardName: s.student_id?.standard_id?.name,
      profilePic: s.student_id?.profile_pic,
      email: s.student_id?.email,
    })),
  };
}
