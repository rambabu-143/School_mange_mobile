import Toast from "react-native-toast-message";
import { useMutation, useQueryClient } from "@tanstack/react-query";

import type { StaffAttendanceParams } from "../types";
import type { StaffLeaveRequest } from "./useStaffLeaveRequestsQuery";

export type LeaveResponse = {
  status?: boolean | null;
  message?: string | null;
};

export const useDeleteLeaveRequestMutation = (params: StaffAttendanceParams | null | undefined) => {
  const queryClient = useQueryClient();

  const mutation = useMutation({
    mutationFn: async (variables: StaffLeaveRequest) => {
      const leaveRequestId = variables._id;
      if (!leaveRequestId) {
        return Promise.reject(new Error(`Leave Request Id is required!!!`));
      }
      const BASE_URI = "https://mountcarmelschool.com:4201";
      const LEAVE_URI = `${BASE_URI}/leave/application/${leaveRequestId}`;

      if (!params?.token) {
        return Promise.reject(new Error(`Authentication Token is required!!!`));
      }

      const response = await fetch(LEAVE_URI, {
        method: "DELETE",
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
      const { status, message } = result;

      if (!status) {
        return Promise.reject(new Error(message || "Unknown Error Occurred"));
      }
      return result;
    },
    networkMode: "online",
    onSettled: () => queryClient.invalidateQueries({ queryKey: ["leave-requests"] }),
    onSuccess(data) {
      console.log("Leave request deleted successfully", data);
      Toast.show({
        type: "success",
        text1: "Leave application deleted successfully",
        text2: "Your leave request has been deleted successfully.",
        topOffset: 100,
        position: "top",
      });
    },
    onError(error) {
      console.warn(error.cause);
      Toast.show({
        type: "error",
        text1: "Error occurred while deleting leave request",
        text2: `${error.name}: ${error.message}`,
        topOffset: 100,
        position: "top",
      });
    },
  });

  return mutation;
};
