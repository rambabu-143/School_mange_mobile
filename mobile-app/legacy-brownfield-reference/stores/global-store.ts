import { create } from "zustand";
import { GlobalStore } from "../types/global-store.types";
import { createPayBillSlice } from "../components/PayBillContent/slice/payBillSlice";

export const useGlobalStore = create<GlobalStore>((...a) => ({
  ...createPayBillSlice(...a),
}));
