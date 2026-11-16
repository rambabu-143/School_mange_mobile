import { useQuery } from "@tanstack/react-query";

type NumberString = string;

type ClubbedCheck = "Yes" | "No";

export type StaffLeaveDetails = {
  is_july_credit?: boolean | null;
  _id?: string | null;
  leave_name?: string | null;
  leave_code?: string | null;
  max_in_row?: NumberString | null;
  max_in_month?: NumberString | null;
  is_half_day_applicable: ClubbedCheck | null;
  clubbed_with_weekly_off?: ClubbedCheck | null;
  clubbed_with_holiday?: ClubbedCheck | null;
  clubbed_with_leave?: ClubbedCheck | null;
  carry_forward?: number | null;
  credit_in_jan?: number | null;
  credit_in_july?: number | null;
  leaves_taken_in_month?: number | null;
  total?: number | null;
  used?: number | null;
  balance?: number | null;
};

export type StaffLeaveBalancesResponse = {
  status?: boolean | null;
  message?: string | null;
  data?: null | Array<StaffLeaveDetails>;
};

export const useStaffLeaveBalancesQuery = ({
  token,
  staffId,
  year, // YYYY format
}) => {
  const query = useQuery({
    queryKey: ["staff", "leaves"],
    queryFn: async ({ signal, queryKey }) => {
      const [_uniqueKey] = queryKey;

      const BASE_URI = "https://mountcarmelschool.com:4201";
      const ATTENDANCE_DATES_URI = `${BASE_URI}/hr/staff/leaves/all/${staffId}/${year}`;

      const response = await fetch(ATTENDANCE_DATES_URI, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token.replace('Bearer ', '')}`,
        },
        signal,
      });

      // Check if the response status is not OK (2xx)
      if (!response.ok) {
        const errorText = await response.text();
        return Promise.reject(
          new Error(errorText || `HTTP error! Status: ${response.status}`)
        );
      }
      const result = await response.json() as StaffLeaveBalancesResponse | null | undefined;

      // Validate the response structure
      if (typeof result !== "object" || result === null) {
        return Promise.reject(new Error("Invalid response format"));
      }
      const { data, status, message } = result;

      if (!status && !!message) {
        return Promise.reject(new Error(`Error: ${message}`));
      }
      return data;
    },
  });

  return query;
};
