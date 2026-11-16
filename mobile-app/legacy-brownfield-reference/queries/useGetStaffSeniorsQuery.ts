import { useQuery } from "@tanstack/react-query";

type DateTimeString = string;

export type SeniorRole = {
  _id: string;
  staff_id: {
    _id: string;
    name: string;
  },
  role_id: string;
  short_name: string; // HoD
  order: number;
  updated_on: DateTimeString;
};

export type GetStaffSeniorResponse = {
  status?: boolean | null;
  message?: string | null;
  data?: null | {
    _id: string;
    roles: Array<SeniorRole>;
  };
  path?: string | null;
};

export const useGetStaffSeniorsQuery = ({
  token,
  staffId,
  year, // YYYY format
}) => {
  const query = useQuery({
    queryKey: ["staff", "seniors"],
    queryFn: async ({ signal, queryKey }) => {
      const [_uniqueKey] = queryKey;

      const BASE_URI = "https://mountcarmelschool.com:4201";
      const ATTENDANCE_DATES_URI = `${BASE_URI}/hr/role-management/get-my-seniors/${staffId}/${year}`;

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
      const result = await response.json() as GetStaffSeniorResponse | null | undefined;

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
