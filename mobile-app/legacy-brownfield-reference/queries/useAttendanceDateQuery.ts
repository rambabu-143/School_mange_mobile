import { useQuery } from "@tanstack/react-query";
import dayjs from "dayjs";

export type AttendanceDateResponse = {
  status?: boolean | null;
  message?: string | null;
  data?: null | {
    _id?: string | null;
    created_at?: string | null;
    end_date?: string | null;
    is_deleted?: boolean | null;
    start_date?: string | null;
    term_session?: string | null;
    updated_at?: string | null;
    year_session?: string | null;
  }
};

export const useAttendanceDateQuery = ({
  token,
}) => {
  const query = useQuery({
    queryKey: ["attendance-dates"],
    queryFn: async ({ signal, queryKey }) => {
      const [_uniqueKey] = queryKey;

      const BASE_URI = "https://mountcarmelschool.com:4201/";
      const ATTENDANCE_DATES_URI = `${BASE_URI}config/Attendance-dates`;

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
        return Promise.reject(
          new Error(`HTTP error! Status: ${response.status}`)
        );
      }
      const result = await response.json() as AttendanceDateResponse | null | undefined;

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
    refetchOnMount: false,
    meta: {
      friendlyErrorMessage: "Unable to fetch Attendance Dates",
    },
    select: (data) => {
      return {
        ...data,
        start_date: data?.start_date ? dayjs(data?.start_date).format("YYYY-MM-DD") : undefined,
        end_date: data?.end_date ? dayjs(data?.end_date).format("YYYY-MM-DD") : undefined,
      };
    }
  });

  return query;
};
