import { useQuery } from "@tanstack/react-query";

export type DateString = string;

export type LeaveAssessor = {
  status?: string | null;
  is_last_assessor?: boolean | null;
  _id?: string | null;
  assessor_id?: {
    _id?: string | null;
    name?: string | null;
  };
  role_id?: {
    _id?: string | null;
    short_name?: string | null;
  };
  date?: DateString | null;
};

export type StaffLeaveRequest = {
  is_sanction?: boolean | null;
  status?: "Not-Approved"| "PENDING" | "APPROVED" | "REJECTED" | null;
  is_counted?: boolean | null;
  is_deleted?: boolean | null;
  _id?: string | null;
  staff_id?: string | null;
  leave_type?: "LEAVE" | "SHORT-LEAVE" | "CO" | "OD" | null;
  reason?: string | null;
  prior_sanction?: "YES" | "NO" | null;
  prior_sanction_from_whom?: string | null;
  prior_sanction_why_not?: string | null;
  branch_code?: number | null;
  year?: string | null; // YYYY
  year_session?: string | null; // YYYY-YY
  no_of_half_days?: number | null;
  no_of_full_days?: number | null;
  no_of_days?: number | null;
  first_half_day_on?: DateString | null;
  first_half_day_in?: "FIRST-HALF" | "SECOND-HALF" | null;
  second_half_day_in?: "FIRST-HALF" | "SECOND-HALF" | null;
  second_half_day_on?: DateString | null;
  duration?: string | null; // HH:mm
  from_time?: string | null; // HH:mm
  to_time?: string | null; // HH:mm
  from_date?: DateString | null;
  to_date?: DateString | null;
  created_at?: DateString | null;
  updated_at?: DateString | null;
  __v?: number | null;
  leave_id?: {
    _id?: string | null;
    leave_name?: string | null;
    leave_code?: string | null;
  } | null;
  assessor?: Array<LeaveAssessor> | null;
};

export type StaffLeaveRequestsResponse = {
  status?: boolean | null;
  message?: string | null;
  data?: null | Array<StaffLeaveRequest>;
  path?: "https://mountcarmelschool.com:4201/uploads/staff-profile" | null;    
};

export const useStaffLeaveRequestsQuery = (
  leaveCategory: "SHORT-LEAVE" | "LEAVE" | "CO" | "OD",
  year: string, // YYYY
  config:
    | {
        token?: string | null;
        staffId?: string | null;
      }
    | undefined
    | null
) => {
  const { token, staffId } = config || {};

  const query = useQuery({
    queryKey: ["leave-requests", leaveCategory, year],
    queryFn: async ({ signal, queryKey }) => {
      const [_uniqueKey, leaveCategory, year] = queryKey;

      const BASE_URI = "https://mountcarmelschool.com:4201";
      const ATTENDANCE_DATES_URI = `${BASE_URI}/leave/application/status/${staffId}/${leaveCategory}/${year}`;

      const response = await fetch(ATTENDANCE_DATES_URI, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token?.replace("Bearer ", "")}`,
        },
        signal,
      });

      // Check if the response status is not OK (2xx)
      if (!response.ok) {
        const result = await response.text();

        return Promise.reject(
          new Error(`HTTP error! Status: ${response.status}`, {
            cause: result,
          })
        );
      }
      const result = (await response.json()) as
        | StaffLeaveRequestsResponse
        | null
        | undefined;

      // Validate the response structure
      if (typeof result !== "object" || result === null) {
        return Promise.reject(new Error("Invalid response format"));
      }
      const { status, message } = result;

      if (!status && !!message) {
        return Promise.reject(new Error(`Error: ${message}`));
      }
      return result;
    },
  });

  return query;
};
