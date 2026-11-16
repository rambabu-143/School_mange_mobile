import Toast from "react-native-toast-message";
import { useMutation } from "@tanstack/react-query";

import { StaffAttendanceParams } from "../types";

export type LeaveRequest = {
  leave_id: string;
  no_of_half_days: number; // 1 | 2;
  no_of_full_days: string; // "1";
  no_of_days: number; // total_days(no_of_half_days/2 + no_of_full_days)
  from_date: string; // "dd/mm/yyy";
  to_date: string; // "dd/mm/yyy";
  first_half_day_on: string | null; // "dd/mm/yyy";
	second_half_day_on: string | null; // "dd/mm/yyy";
	first_half_day_in: "FIRST-HALF" | "SECOND-HALF" | null;
	second_half_day_in: "FIRST-HALF" | "SECOND-HALF" | null;
  year: string; // YYYY
  reason: string; // "reason for leave";
  prior_sanction: "YES" | "NO";
  prior_sanction_from_whom: string; // staff_name
  prior_sanction_why_not: string; // "reason for not taking prior sanction";
  deduct: number; // no_of_days + no_of_holidays
  no_of_holidays?: number;
};

export type LeaveResponse = {
  status?: boolean | null;
  message?: string | null;
  is_dialog?: boolean | null;
  no_of_holidays?: number | null;
};

export const useRegularLeaveMutation = (params: StaffAttendanceParams | null | undefined) => {
  const mutation = useMutation({
    mutationFn: async (variables: LeaveRequest) => {
      const BASE_URI = "https://mountcarmelschool.com:4201";

      const LEAVE_URI = `${BASE_URI}/leave/application`;

      if (!params?.token) {
        return Promise.reject(new Error(`Authentication Token is required!!!`));
      }
      if (!params?.staffId) {
        return Promise.reject(new Error(`Staff ID is required!!!`));
      }
      const requestBody = { ...variables, staff_id: params.staffId, leave_type: "LEAVE" as const };

      const response = await fetch(LEAVE_URI, {
        body: JSON.stringify(requestBody),
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${params.token.replace("Bearer ", "")}`,
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
        | LeaveResponse
        | null
        | undefined;

      // Validate the response structure
      if (typeof result !== "object" || result === null) {
        return Promise.reject(new Error("Invalid response format"));
      }
      const { status, message, is_dialog } = result;

      if (status === true) {
        // Successful submission
        return result;
      }
      if (is_dialog === true && typeof requestBody.no_of_holidays !== "number") {
        return Promise.reject(new Error(message || "Confirmation Required", { cause: { ...result } }));
      }
      return Promise.reject(new Error(message || "Unknown Error Occurred"));
    },
    networkMode: "online",
    onSuccess(data) {
      console.log("Leave application submitted successfully", data);
      Toast.show({
        type: "success",
        text1: "Leave application submitted successfully",
        text2: "Your leave application has been submitted successfully.",
        topOffset: 100,
        position: "top",
      });
    },
    onError(error) {
      console.warn(error.cause);
      Toast.show({
        type: "error",
        text1: "Error occurred while submitting leave application",
        text2: `${error.name}: ${error.message}`,
        topOffset: 100,
        position: "top",
      });
    },
  });

  return mutation;
};
