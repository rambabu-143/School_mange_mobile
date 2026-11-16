import type { UtilitySlice, SliceCreator } from '@/types/new-staff-application-store.types';

export const createUtilitySlice: SliceCreator<UtilitySlice> = (_set, get) => ({
  resetAllSlices: () => {
    get().resetCommonSlice();
    get().resetLeaveSlice();
    get().resetShortLeaveSlice();
    get().resetCOLeaveSlice();
  },
});
