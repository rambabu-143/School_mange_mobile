import { leaveTypes } from "./constants";
import type { UtilitySlice, SliceCreator } from "../../../types/new-staff-application-store.types";
import type { OmitByValueType } from "../../../utils/types";

type UtilitySliceValues = OmitByValueType<UtilitySlice, Function>;

const INITIAL_STATE: UtilitySliceValues = {};

export const createUtilitySlice: SliceCreator<UtilitySlice> = (set, get) => ({
  ...INITIAL_STATE,
  resetAllSlices: () => {
    get().resetCommonSlice();
    get().resetLeaveSlice();
    get().resetShortLeaveSlice();
    get().resetCOLeaveSlice();
  },
});
