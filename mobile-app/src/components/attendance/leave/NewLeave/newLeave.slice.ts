import dayjs from 'dayjs';

import { OmitByValueType } from '@/utils/types';
import type { LeaveSlice, SliceCreator } from '@/types/new-staff-application-store.types';

type LeaveSliceValues = OmitByValueType<LeaveSlice, Function>;

const INITIAL_LEAVE_STATE: LeaveSliceValues = {
  selectedLeaveCategory: null,
  leaveTypeError: '',
  numberOfHalfDays: 0,
  numberOfDaysStr: '',
  from: new Date(),
  to: new Date(),
  dateTimeSelectionError: '',
  singleHalfDayLeaveDetails: { leaveOn: new Date(), leaveIn: null },
  singleHalfDayLeaveError: '',
};

export const createLeaveSlice: SliceCreator<LeaveSlice> = (set, get) => ({
  ...INITIAL_LEAVE_STATE,
  setSelectedLeaveCategory: (category) => set({ selectedLeaveCategory: category }),
  setLeaveTypeError: (errorText) => set({ leaveTypeError: errorText }),
  setNumberOfHalfDays: (count) => set({ numberOfHalfDays: count }),
  setNumberOfDaysStr: (str) => {
    if (typeof str === 'function') {
      set((state) => ({ numberOfDaysStr: str(state.numberOfDaysStr) }));
    } else {
      set({ numberOfDaysStr: str });
    }
  },
  setFrom: (date) => set({ from: date }),
  setTo: (date) => set({ to: date }),
  setDateTimeSelectionError: (errorText) => set({ dateTimeSelectionError: errorText }),
  setSingleHalfDayLeaveDetails: (details) => {
    if (typeof details === 'function') {
      set((state) => ({ singleHalfDayLeaveDetails: details(state.singleHalfDayLeaveDetails) }));
    } else {
      set({ singleHalfDayLeaveDetails: details });
    }
  },
  setSingleHalfDayLeaveError: (errorText) => set({ singleHalfDayLeaveError: errorText }),
  resetLeaveSlice: () => {
    const date = new Date();
    set((prevState) => ({
      ...INITIAL_LEAVE_STATE,
      from: date,
      to: date,
      singleHalfDayLeaveDetails: {
        leaveOn: prevState.singleHalfDayLeaveDetails.leaveOn,
        leaveIn: null,
      },
    }));
  },
  isLeaveStatesEmpty: () => {
    const { selectedLeaveCategory, numberOfDaysStr, from, to } = get();
    return (
      selectedLeaveCategory === null &&
      numberOfDaysStr.length === 0 &&
      dayjs(from).format('DD/MM/YYYY') === dayjs().format('DD/MM/YYYY') &&
      dayjs(to).format('DD/MM/YYYY') === dayjs().format('DD/MM/YYYY')
    );
  },
});
