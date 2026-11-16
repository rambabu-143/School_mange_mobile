import Toast from 'react-native-toast-message';
import { useMutation } from "@tanstack/react-query";

export type UpdateBillTypeRequest = {
  admission_no?: string | null;
  fee_type: 12,
  year_session?: string | null;
};

export const useUpdateBillTypeMutation = ({
  token,
}: {
  token?: string | null;
}) => {
  const mutation = useMutation({
    mutationFn: async (variables: UpdateBillTypeRequest) => {
      const BASE_URI = "https://mountcarmelschool.com:4201/";
      const STUDENT_RATING_URI = `${BASE_URI}student/detail/update-bill-type`;

      if (!token) {
        return Promise.reject(
          new Error(`Authentication Token is required!!!`)
        );
      }
      if (!variables.admission_no) {
        return Promise.reject(
          new Error(`Admission Number is required!!!`)
        );
      }
      if (!variables.year_session) {
        return Promise.reject(
          new Error(`Year Session is required!!!`)
        );
      }

      const requestBody: UpdateBillTypeRequest = {...variables};

      const response = await fetch(STUDENT_RATING_URI, {
        body: JSON.stringify(requestBody),
        method: "PUT",
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
    onSuccess() {
      Toast.show({
        type: 'success',
        text1: "Monthly payment option selected successfully ✅",
        position: 'top',
        topOffset: 60,
      });
    },
    onError(error) {
      console.warn(error.cause);
      Toast.show({
        type: 'error',
        text1: "Error occurred while trying to opt for montly payment option",
        text2: `${error.name}: ${error.message}`,
        topOffset: 100,
        position: 'top',
      });
    },
  });

  return mutation;
};
