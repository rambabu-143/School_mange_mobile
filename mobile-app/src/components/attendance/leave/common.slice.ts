import { leaveTypes } from './constants';
import type { CommonSlice, SliceCreator } from '@/types/new-staff-application-store.types';
import type { OmitByValueType } from '@/utils/types';

type CommonSliceValues = OmitByValueType<CommonSlice, Function>;

const INITIAL_STATE: CommonSliceValues = {
  selectedLeaveType: leaveTypes.find((leaveType) => leaveType.id === 'regular-leave')!,
  leaveReasonText: '',
  leaveReasonError: '',
  isPriorApprovalTaken: null,
  priorApprovalTakenFrom: null,
  noPriorApprovalReasonText: '',
  priorApprovalError: '',
};

export const createCommonSlice: SliceCreator<CommonSlice> = (set, get) => ({
  ...INITIAL_STATE,
  setSelectedLeaveType: (leaveType) => {
    get().resetAllSlices();
    set({ selectedLeaveType: leaveType });
  },
  setLeaveReasonText: (text) => set({ leaveReasonText: text }),
  setLeaveReasonError: (errorText) => set({ leaveReasonError: errorText }),
  setIsPriorApprovalTaken: (isTaken) => set({ isPriorApprovalTaken: isTaken }),
  setPriorApprovalTakenFrom: (role) => set({ priorApprovalTakenFrom: role }),
  setNoPriorApprovalReasonText: (text) => set({ noPriorApprovalReasonText: text }),
  setPriorApprovalError: (errorText) => set({ priorApprovalError: errorText }),
  resetCommonSlice: () => set({ ...INITIAL_STATE }),
  isCommonStatesEmpty: () => {
    const { leaveReasonText, isPriorApprovalTaken, priorApprovalTakenFrom, noPriorApprovalReasonText } =
      get();
    return (
      leaveReasonText === INITIAL_STATE.leaveReasonText &&
      isPriorApprovalTaken === INITIAL_STATE.isPriorApprovalTaken &&
      priorApprovalTakenFrom === INITIAL_STATE.priorApprovalTakenFrom &&
      noPriorApprovalReasonText === INITIAL_STATE.noPriorApprovalReasonText
    );
  },
});
