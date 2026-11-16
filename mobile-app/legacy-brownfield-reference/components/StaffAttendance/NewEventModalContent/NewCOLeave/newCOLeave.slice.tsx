import type { COLeaveSlice, ShortLeaveSlice, SliceCreator } from "../../../../types/new-staff-application-store.types";
import type { OmitByValueType } from "../../../../utils/types";

type COLeaveSliceValues = OmitByValueType<COLeaveSlice, Function>;

const INITIAL_CO_LEAVE_STATE: COLeaveSliceValues = {
  coLeaveDate: new Date(),
  coAvailDate: new Date(),
  coLeaveDayType: "",
  coHalfDayLeavePeriod: "",
  coDateTimeSelectionError: "",
};

export const createCOLeaveSlice: SliceCreator<COLeaveSlice> = (set, get) => ({
  ...INITIAL_CO_LEAVE_STATE,
  setCoLeaveDate: (date) => set({ coLeaveDate: date }),
  setCoAvailDate: (date) => set({ coAvailDate: date }),
  setCoLeaveDayType: (type) => set({ coLeaveDayType: type }),
  setCoHalfDayLeavePeriod: (period) => set({ coHalfDayLeavePeriod: period }),
  setCoDateTimeSelectionError: (errorText) => set({ coDateTimeSelectionError: errorText }),
  resetCOLeaveSlice: () => {
    const date = new Date();
    set({ ...INITIAL_CO_LEAVE_STATE, coLeaveDate: date, coAvailDate: date });
  },
  isCOLeaveStatesEmpty: () => {
    const { coLeaveDate, coAvailDate } = get();
    return (
      coLeaveDate.toDateString() === new Date().toDateString() &&
      coAvailDate.toDateString() === new Date().toDateString()
    );
  },
});
