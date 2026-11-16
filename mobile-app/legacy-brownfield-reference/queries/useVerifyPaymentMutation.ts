import { useMutation } from "@tanstack/react-query";
import { PayBillScreenParams } from "../types";

export type VerifyPaymentRequest = {
  razorpay_order_id: string;
  razorpay_payment_id: string;
  razorpay_signature: string;
  server_order_id: string;
};

export const useVerifyPaymentMutation = ({
  token,
  type,
  userType,
}: Pick<PayBillScreenParams, 'token' | 'type' | 'userType'>) => {
  const mutation = useMutation({
    mutationFn: async (variables: VerifyPaymentRequest) => {
      const BASE_URI = "https://mountcarmelschool.com:4201";
      const VERIFY_PAYMENT_URI = userType === "staff"
        ? `${BASE_URI}/${type === "school" ? "fee" : type}-payment-staff/verify-app-payment`
        : `${BASE_URI}/${type === "school" ? "fee" : type}-payment/verify-app-payment`;

      if (!token) {
        return Promise.reject(
          new Error(`Authentication Token is required!!!`)
        );
      }

      const requestBody: VerifyPaymentRequest = {...variables};

      // console.log(`$ Calling ${VERIFY_PAYMENT_URI} with ${JSON.stringify(requestBody, null, 2)}`);

      const response = await fetch(VERIFY_PAYMENT_URI, {
        body: JSON.stringify(requestBody),
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token.replace('Bearer ', '')}`,
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

      const result = await response.json();

      // console.log('$ VERIFY_PAYMENT_URI result -> ', JSON.stringify(result, null, 2));

      // Validate the response structure
      if (typeof result !== "object" || result === null) {
        return Promise.reject(new Error("Invalid response format"));
      }

      const { status, message } = result;
      if (!status) {
        return Promise.reject(new Error(message || 'Unknown Error Occurred'));
      }
      return status;
    },
    networkMode: "online",
    retry: 3,
  });

  return mutation;
};
