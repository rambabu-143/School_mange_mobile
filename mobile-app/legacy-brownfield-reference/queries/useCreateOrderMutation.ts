import Toast from "react-native-toast-message";
import { useMutation, useQueryClient } from "@tanstack/react-query";

import { PayBillScreenParams } from "../types";

type FeePaymentOrderRequest = {
  admission_no: string;
};

type TransportPaymentOrderRequest = {
  admission_no: string;
};

type HostelPaymentOrderRequest = {
  admission_no: string;
  pocket_money: number;
};

type StaffTransportPaymentOrderRequest = {
  staff_id: string;
  transport_id: string;
};

export type CreateOrderRequest = {
  installment_no: string;
  pay_by: "app";
  amount: number;
} & (
  | FeePaymentOrderRequest
  | TransportPaymentOrderRequest
  | HostelPaymentOrderRequest
  | StaffTransportPaymentOrderRequest
);

export type CreateOrderData = {
  amount?: null | number; // 1613700;
  amount_due?: null | number; // 1613700;
  amount_paid?: null | number; // 0;
  attempts?: null | number; // 0;
  created_at?: null | number; // 1742941240;
  currency?: null | string; // "INR";
  entity?: null | string; // "order";
  id?: null | string; // "order_QBBbBAjgg1D2QA";
  notes?: null | Array<any>; // [];
  offer_id?: null | null | string;
  receipt?: null | string; // "11153425~2025-26~FEE";
  status?: null | string; // "created" | "attempted" | "paid"
  key?: null | string; // "rzp_test_9Jrn6h3W1STJFl";
};

export type CreateOrderResponse = {
  status?: boolean | null;
  message?: string | null;
  data?: null | CreateOrderData;
};

export const useCreateOrderMutation = ({
  token,
  type,
  userType,
}: Pick<PayBillScreenParams, "token" | "type" | "userType">) => {
  const queryClient = useQueryClient();

  const mutation = useMutation({
    mutationFn: async (variables: CreateOrderRequest) => {
      const BASE_URI = "https://mountcarmelschool.com:4201";

      const CREATE_ORDER_URI =
        userType === "staff"
          ? `${BASE_URI}/transport-payment-staff/create-order`
          : `${BASE_URI}/${
              type === "school" ? "fee" : type
            }-payment/create-order`;

      if (!token) {
        return Promise.reject(new Error(`Authentication Token is required!!!`));
      }
      const requestBody: CreateOrderRequest = { ...variables };

      // console.log(`$ Calling ${CREATE_ORDER_URI} with ${JSON.stringify(requestBody, null, 2)}`);

      const response = await fetch(CREATE_ORDER_URI, {
        body: JSON.stringify(requestBody),
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token.replace("Bearer ", "")}`,
        },
      });
      // Check if the response status is not OK (2xx)
      if (!response.ok) {
        const errorData = await response.text();

        return Promise.reject(
          new Error(`${response.status} | ${response.statusText}`, {
            cause: errorData,
          })
        );
      }
      const result = (await response.json()) as
        | CreateOrderResponse
        | null
        | undefined;

      // console.log('$ CREATE_ORDER_URI result -> ', JSON.stringify(result, null, 2));

      // Validate the response structure
      if (typeof result !== "object" || result === null) {
        return Promise.reject(new Error("Invalid response format"));
      }
      const { status, message, data } = result;

      if (!status) {
        return Promise.reject(new Error(message || "Unknown Error Occurred"));
      }
      return data;
    },
    networkMode: "online",
    onError(error) {
      console.warn(error.cause);
      Toast.show({
        type: "error",
        text1: "Error occurred while creating order",
        text2: `${error.name}: ${error.message}`,
        topOffset: 100,
        position: "top",
      });
    },
  });

  return mutation;
};
