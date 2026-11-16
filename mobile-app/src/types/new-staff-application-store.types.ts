import { StateCreator } from 'zustand';
import type { SeniorRole } from '@/queries/useGetStaffSeniorsQuery';
import { StaffLeaveDetails } from '@/queries/useStaffLeaveBalancesQuery';

export type LeaveTypeIds = 'regular-leave' | 'short-leave' | 'co' | 'od';

export type LeaveType = {
  id: LeaveTypeIds;
  label: string;
};

export type HalfDayLeaveDetail = { leaveOn: Date; leaveIn: 'First-Half' | 'Second-Half' | null };

export interface CommonSlice {
  selectedLeaveType: LeaveType;
  setSelectedLeaveType: (leaveType: LeaveType) => void;

  leaveReasonText: string;
  setLeaveReasonText: (text: string) => void;
  leaveReasonError: string;
  setLeaveReasonError: (error: string) => void;

  isPriorApprovalTaken: boolean | null;
  setIsPriorApprovalTaken: (isTaken: boolean | null) => void;
  priorApprovalTakenFrom: SeniorRole | null;
  setPriorApprovalTakenFrom: (role: SeniorRole | null) => void;
  noPriorApprovalReasonText: string;
  setNoPriorApprovalReasonText: (text: string) => void;
  priorApprovalError: string;
  setPriorApprovalError: (error: string) => void;

  resetCommonSlice: () => void;
  isCommonStatesEmpty: () => boolean;
}

export interface LeaveSlice {
  selectedLeaveCategory: StaffLeaveDetails | null;
  setSelectedLeaveCategory: (category: StaffLeaveDetails | null) => void;
  leaveTypeError: string;
  setLeaveTypeError: (error: string) => void;

  numberOfHalfDays: 0 | 1 | 2;
  setNumberOfHalfDays: (count: 0 | 1 | 2) => void;

  numberOfDaysStr: string;
  setNumberOfDaysStr: (str: string | ((prevState: string) => string)) => void;

  from: Date;
  setFrom: (date: Date) => void;

  to: Date;
  setTo: (date: Date) => void;

  dateTimeSelectionError: string;
  setDateTimeSelectionError: (error: string) => void;

  singleHalfDayLeaveDetails: HalfDayLeaveDetail;
  setSingleHalfDayLeaveDetails: (
    details: HalfDayLeaveDetail | ((prevState: HalfDayLeaveDetail) => HalfDayLeaveDetail)
  ) => void;
  singleHalfDayLeaveError: string;
  setSingleHalfDayLeaveError: (error: string) => void;

  resetLeaveSlice: () => void;
  isLeaveStatesEmpty: () => boolean;
}

export interface ShortLeaveSlice {
  shortLeaveDate: Date;
  setShortLeaveDate: (date: Date) => void;

  shortLeaveFromTime: Date;
  setShortLeaveFromTime: (time: Date) => void;

  shortLeaveToTime: Date;
  setShortLeaveToTime: (time: Date) => void;

  dateTimeSelectionError: string;
  setDateTimeSelectionError: (error: string) => void;

  resetShortLeaveSlice: () => void;
  isShortLeaveStatesEmpty: () => boolean;
}

export interface COLeaveSlice {
  coLeaveDate: Date;
  setCoLeaveDate: (date: Date) => void;

  coAvailDate: Date;
  setCoAvailDate: (date: Date) => void;

  coLeaveDayType: 'Full Day' | 'Half Day' | '';
  setCoLeaveDayType: (type: 'Full Day' | 'Half Day') => void;

  coHalfDayLeavePeriod: 'First-Half' | 'Second-Half' | '';
  setCoHalfDayLeavePeriod: (period: 'First-Half' | 'Second-Half') => void;

  coDateTimeSelectionError: string;
  setCoDateTimeSelectionError: (error: string) => void;

  resetCOLeaveSlice: () => void;
  isCOLeaveStatesEmpty: () => boolean;
}

export interface UtilitySlice {
  resetAllSlices: () => void;
}

export type NewStaffApplicationStore = CommonSlice &
  LeaveSlice &
  ShortLeaveSlice &
  COLeaveSlice &
  UtilitySlice;

export type SliceCreator<T> = StateCreator<NewStaffApplicationStore, [], [], T>;
