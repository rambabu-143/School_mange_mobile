import { googleSignOut } from '@/lib/google-signin';
import * as SecureStore from 'expo-secure-store';
import { create } from 'zustand';

// Mirrors the keys native stores in SharedPreferences("MyPreferences"): auth_token, usertype,
// isStaff/isParent, current_branch, year_session — kept minimal here, extend as screens need more.
export type Session = {
  token: string;
  userId: string;
  /** HR-side id used by attendance/leave endpoints — usually same as userId for staff, falls back to it. */
  staffId: string;
  /** Native `standardId` — student/parent only (their child's class), used by School Calendar. Staff never has one. */
  standardId?: string | null;
  /** Native `currentStandard` roman numeral (e.g. "IV", "X") — gates Self Awareness (IV-VIII) / Stream Selection (X) drawer tiles. Student/parent only. */
  standardName?: string | null;
  /** Native `STUDENT_ROLL_NO` — the currently-active child's admission no. Parent/student only, used to highlight the current child in the switcher. */
  admissionNo?: string | null;
  name: string;
  isStaff: boolean;
  isParent: boolean;
  /** Native `CURRENT_BRANCH` — used by Settings' branch switcher (staff) and session-scoped API calls. */
  branchCode?: string | null;
  /** Native `year_session`, e.g. "2025-26" — used for session-start/end date ranges (attendance, homework month range). */
  yearSession?: string | null;
  schoolCode?: string | null;
  imagePath?: string | null;
  /** Parent only — every child linked to this account (native `STUDENT_DATA_FOR_PARENT`), for the child-switcher. */
  children?: {
    admissionNo: string;
    name?: string | null;
    standardName?: string | null;
    profilePic?: string | null;
    /** Needed for the switch-student request, which identifies the target child by their own email. */
    email?: string | null;
  }[] | null;
};

const STORAGE_KEY = 'mcs_session';

type SessionState = {
  session: Session | null;
  isHydrated: boolean;
  hydrate: () => Promise<void>;
  setSession: (session: Session) => Promise<void>;
  clearSession: () => Promise<void>;
};

export const useSessionStore = create<SessionState>((set) => ({
  session: null,
  isHydrated: false,

  hydrate: async () => {
    const raw = await SecureStore.getItemAsync(STORAGE_KEY);
    set({ session: raw ? (JSON.parse(raw) as Session) : null, isHydrated: true });
  },

  setSession: async (session) => {
    await SecureStore.setItemAsync(STORAGE_KEY, JSON.stringify(session));
    set({ session });
  },

  clearSession: async () => {
    await googleSignOut();
    await SecureStore.deleteItemAsync(STORAGE_KEY);
    set({ session: null });
  },
}));
