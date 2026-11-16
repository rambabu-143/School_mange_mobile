import { create } from 'zustand';

import { createCommonSlice } from '@/components/attendance/leave/common.slice';
import { createUtilitySlice } from '@/components/attendance/leave/utility.slice';
import { createLeaveSlice } from '@/components/attendance/leave/NewLeave/newLeave.slice';
import { createShortLeaveSlice } from '@/components/attendance/leave/NewShortLeave/newShortLeave.slice';
import { createCOLeaveSlice } from '@/components/attendance/leave/NewCOLeave/newCOLeave.slice';
import type { NewStaffApplicationStore } from '@/types/new-staff-application-store.types';

export const useNewStaffApplicationStore = create<NewStaffApplicationStore>((...a) => ({
  ...createCommonSlice(...a),
  ...createLeaveSlice(...a),
  ...createShortLeaveSlice(...a),
  ...createCOLeaveSlice(...a),
  ...createUtilitySlice(...a),
}));
