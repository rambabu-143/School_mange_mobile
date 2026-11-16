import { StateCreator } from "zustand";
import type { SeniorRole } from "../queries/useGetStaffSeniorsQuery";
import { StaffLeaveDetails } from "../queries/useStaffLeaveBalancesQuery";

export type LeaveTypeIds = "regular-leave" | "short-leave" | "co" | "od";

export type LeaveType = {
  id: LeaveTypeIds;
  label: string;
};

export type HalfDayLeaveDetail = { leaveOn: Date; leaveIn: "First-Half" | "Second-Half" | null };

export interface CommonSlice {
  selectedLeaveType: LeaveType;
  setSelectedLeaveType: (leaveType: LeaveType) => void;

  // Leave Reason
  leaveReasonText: string;
  setLeaveReasonText: (text: string) => void;
  leaveReasonError: string;
  setLeaveReasonError: (error: string) => void;

  // Prior Approval
  isPriorApprovalTaken: boolean | null;
  setIsPriorApprovalTaken: (isTaken: boolean | null) => void;
  priorApprovalTakenFrom: SeniorRole | null;
  setPriorApprovalTakenFrom: (role: SeniorRole | null) => void;
  noPriorApprovalReasonText: string;
  setNoPriorApprovalReasonText: (text: string) => void;
  priorApprovalError: string;
  setPriorApprovalError: (error: string) => void;

  // Utilities
  resetCommonSlice: () => void;
  isCommonStatesEmpty: () => boolean;
};

export interface LeaveSlice {
  // Leave Type
  selectedLeaveCategory: StaffLeaveDetails | null;
  setSelectedLeaveCategory: (category: StaffLeaveDetails | null) => void;
  leaveTypeError: string;
  setLeaveTypeError: (error: string) => void;

  // No. of half days
  numberOfHalfDays: 0 | 1 | 2;
  setNumberOfHalfDays: (count: 0 | 1 | 2) => void;

  // No. of full days
  numberOfDaysStr: string;
  setNumberOfDaysStr: (str: string | ((prevState: string) => string)) => void;

  // From
  from: Date;
  setFrom: (date: Date) => void;

  // To
  to: Date;
  setTo: (date: Date) => void;

  dateTimeSelectionError: string;
  setDateTimeSelectionError: (error: string) => void;

  // Single Half Day Leave
  singleHalfDayLeaveDetails: HalfDayLeaveDetail;
  setSingleHalfDayLeaveDetails: (details: HalfDayLeaveDetail | ((prevState: HalfDayLeaveDetail) => HalfDayLeaveDetail)) => void;
  singleHalfDayLeaveError: string;
  setSingleHalfDayLeaveError: (error: string) => void;

  // Utilities
  resetLeaveSlice: () => void;
  isLeaveStatesEmpty: () => boolean;
};

export interface ShortLeaveSlice {
  shortLeaveDate: Date;
  setShortLeaveDate: (date: Date) => void;

  shortLeaveFromTime: Date;
  setShortLeaveFromTime: (time: Date) => void;

  shortLeaveToTime: Date;
  setShortLeaveToTime: (time: Date) => void;

  dateTimeSelectionError: string;
  setDateTimeSelectionError: (error: string) => void;

  // Utilities
  resetShortLeaveSlice: () => void;
  isShortLeaveStatesEmpty: () => boolean;
};

export interface COLeaveSlice {
  coLeaveDate: Date;
  setCoLeaveDate: (date: Date) => void;

  coAvailDate: Date;
  setCoAvailDate: (date: Date) => void;

  coLeaveDayType: "Full Day" | "Half Day" | "";
  setCoLeaveDayType: (type: "Full Day" | "Half Day") => void;

  coHalfDayLeavePeriod: "First-Half" | "Second-Half" | "";
  setCoHalfDayLeavePeriod: (period: "First-Half" | "Second-Half") => void;

  coDateTimeSelectionError: string;

  setCoDateTimeSelectionError: (error: string) => void;

  // Utilities
  resetCOLeaveSlice: () => void;
  isCOLeaveStatesEmpty: () => boolean;
};

export interface UtilitySlice {
  resetAllSlices: () => void;
};

export type NewStaffApplicationStore = CommonSlice & LeaveSlice & ShortLeaveSlice & COLeaveSlice & UtilitySlice;

export type SliceCreator<T> = StateCreator<NewStaffApplicationStore, [], [], T>;
