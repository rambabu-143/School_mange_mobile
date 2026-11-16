import {
  OrderDetails,
  PayBillSlice,
  PaymentSuccessResponse,
  SliceCreator,
} from "../../../types/global-store.types";

const INITIAL_STATE = {
  selectedInstallments: {},
  paymentSuccessData: null,
  orderDetails: null,
};

export const createPayBillSlice: SliceCreator<PayBillSlice> = (set) => ({
  ...INITIAL_STATE,
  toggleInstallmentsSelection: (installmentId: string) => {
    return set((state) => ({
      selectedInstallments: {
        ...state.selectedInstallments,
        [installmentId]: !state.selectedInstallments[installmentId],
      },
    }));
  },
  selectInstallments: (installmentSelector: (selectedInstallments: PayBillSlice['selectedInstallments']) => PayBillSlice['selectedInstallments']) => {
    return set((state) => ({
      selectedInstallments: {
        ...state.selectedInstallments,
        ...installmentSelector(state.selectedInstallments),
      },
    }));
  },
  setOrderDetails: (data: OrderDetails) => set({ orderDetails: data }),
  setPaymentSuccessData: (data: PaymentSuccessResponse) =>
    set({ paymentSuccessData: data }),
  resetPayBillSlice: () => set({ ...INITIAL_STATE }),
});
