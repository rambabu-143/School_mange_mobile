import Toast from "react-native-toast-message";
import { useMutation, useQueryClient } from "@tanstack/react-query";

import type { StaffAttendanceParams } from "../types";
import type { StaffLeaveApproval } from "./useStaffLeaveApprovalsQuery";

export type LeaveResponse = {
  status?: boolean | null;
  message?: string | null;
};

export const useUpdateLeaveRequestStatusMutation = (params: StaffAttendanceParams | null | undefined) => {
  const queryClient = useQueryClient();

  const mutation = useMutation({
    mutationFn: async (variables: {
      leave: StaffLeaveApproval;
      status: "APPROVED" | "REJECTED" | "Recommended" | "Not-Recommended";
      isSanction: boolean;
    }) => {
      const leaveRequestId = variables.leave._id;
      if (!leaveRequestId) {
        return Promise.reject(new Error(`Leave Request Id is required!!!`));
      }
      const BASE_URI = "https://mountcarmelschool.com:4201";
      const UPDATE_LEAVE_STATUS_URI = `${BASE_URI}/leave/application/update-status/${leaveRequestId}`;

      const staffId = params?.staffId;
      if (!staffId) {
        return Promise.reject(new Error(`Staff Id is required!!!`));
      }
      if (!params?.token) {
        return Promise.reject(new Error(`Authentication Token is required!!!`));
      }
      if (!Array.isArray(variables.leave.assessor) || variables.leave.assessor.length <= 0) {
        return Promise.reject(new Error(`Assessor details are required!!!`));
      }

      let isLastAssessor = false;
      const leaveAssessor = variables.leave.assessor.map((assessor, index, arr) => {
        const isLast = index === (arr.length - 1);
        if (!isLast) {
          return assessor;
        }
        if (typeof assessor.is_last_assessor === "boolean") {
          isLastAssessor = assessor.is_last_assessor;
        }
        return {
          ...assessor,
          status: variables.status,
        };
      });

      const payload = {
        assessor: leaveAssessor,
        updated_by: staffId,
        is_last_assessor: isLastAssessor,
        status: variables.status,
        is_sanction: variables.isSanction,
      };

      const response = await fetch(UPDATE_LEAVE_STATUS_URI, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${params.token.replace("Bearer ", "")}`,
        },
        body: JSON.stringify(payload),
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
    onSettled: () => queryClient.invalidateQueries({ queryKey: ["leave-approvals"] }),
    onSuccess(data, variables) {
      console.log("Leave request updated successfully", data);
      Toast.show({
        type: "success",
        text1: "Leave application updated successfully",
        text2: "You have set the leave request status to " + variables.status + "successfully.",
        topOffset: 100,
        position: "top",
      });
    },
    onError(error, variables) {
      console.warn(error.cause);
      Toast.show({
        type: "error",
        text1: "Error occurred while setting leave request status to " + variables.status,
        text2: `${error.name}: ${error.message}`,
        topOffset: 100,
        position: "top",
      });
    },
  });

  return mutation;
};
