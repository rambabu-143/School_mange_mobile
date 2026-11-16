import { StateCreator } from "zustand";

export type PaymentSuccessResponse = {
  razorpay_order_id: string;
  razorpay_signature: string;
  razorpay_payment_id: string;
};

export type OrderDetails = {
  description: string;
  userId?: string | null;
  userIdLabel?: string | null;
  amount: number;
  orderId: string;
};

export interface PayBillSlice {
  selectedInstallments: Record<string, boolean>;
  paymentSuccessData: PaymentSuccessResponse | null;
  orderDetails: OrderDetails | null;
  selectInstallments: (installmentSelector: (selectedInstallments: PayBillSlice['selectedInstallments']) => PayBillSlice['selectedInstallments']) => void;
  toggleInstallmentsSelection: (installmentId: string) => void;
  setPaymentSuccessData: (data: PaymentSuccessResponse) => void;
  setOrderDetails: (data: OrderDetails) => void;
  resetPayBillSlice: () => void;
}

export interface UtilitySlice {}

export type GlobalStore = PayBillSlice & UtilitySlice;

export type SliceCreator<T> = StateCreator<GlobalStore, [], [], T>;
