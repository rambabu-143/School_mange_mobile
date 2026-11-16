import type { StaffAttendanceParams } from "../../../types";

export type LeaveType = "regular-leave" | "short-leave";

export type HalfDayLeaveDetail = { leaveOn: Date; leaveIn: "First-Half" | "Second-Half" | null };

export type ModalUtilityProps = {
  closeModal: () => void;
  params?: StaffAttendanceParams;
};
