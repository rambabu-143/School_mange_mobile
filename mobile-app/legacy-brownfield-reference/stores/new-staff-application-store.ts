import { create } from "zustand";
import { createCommonSlice } from "../components/StaffAttendance/NewEventModalContent/common.slice";
import { createUtilitySlice } from "../components/StaffAttendance/NewEventModalContent/utility.slice";
import { createLeaveSlice } from "../components/StaffAttendance/NewEventModalContent/NewLeave/newLeave.slice";
import { createShortLeaveSlice } from "../components/StaffAttendance/NewEventModalContent/NewShortLeave/newShortLeave.slice";
import { createCOLeaveSlice } from "../components/StaffAttendance/NewEventModalContent/NewCOLeave/newCOLeave.slice";
import type { NewStaffApplicationStore } from "../types/new-staff-application-store.types";

export const useNewStaffApplicationStore = create<NewStaffApplicationStore>((...a) => ({
  ...createCommonSlice(...a),
  ...createLeaveSlice(...a),
  ...createShortLeaveSlice(...a),
  ...createCOLeaveSlice(...a),
  ...createUtilitySlice(...a),
}));
