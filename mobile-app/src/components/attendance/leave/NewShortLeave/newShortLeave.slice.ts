import type { ShortLeaveSlice, SliceCreator } from '@/types/new-staff-application-store.types';
import type { OmitByValueType } from '@/utils/types';

type ShortLeaveSliceValues = OmitByValueType<ShortLeaveSlice, Function>;

const INITIAL_SHORT_LEAVE_STATE: ShortLeaveSliceValues = {
  shortLeaveDate: new Date(),
  shortLeaveFromTime: new Date(),
  shortLeaveToTime: new Date(),
  dateTimeSelectionError: '',
};

export const createShortLeaveSlice: SliceCreator<ShortLeaveSlice> = (set, get) => ({
  ...INITIAL_SHORT_LEAVE_STATE,
  setShortLeaveDate: (date) => set({ shortLeaveDate: date }),
  setShortLeaveFromTime: (time) => set({ shortLeaveFromTime: time }),
  setShortLeaveToTime: (time) => set({ shortLeaveToTime: time }),
  setDateTimeSelectionError: (errorText) => set({ dateTimeSelectionError: errorText }),
  resetShortLeaveSlice: () => {
    const date = new Date();
    set({
      ...INITIAL_SHORT_LEAVE_STATE,
      shortLeaveDate: date,
      shortLeaveFromTime: date,
      shortLeaveToTime: date,
    });
  },
  isShortLeaveStatesEmpty: () => {
    const { shortLeaveDate, shortLeaveFromTime, shortLeaveToTime } = get();
    return (
      shortLeaveDate.toDateString() === new Date().toDateString() &&
      shortLeaveFromTime.toDateString() === new Date().toDateString() &&
      shortLeaveToTime.toDateString() === new Date().toDateString()
    );
  },
});
