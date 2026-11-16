import { useQuery } from "@tanstack/react-query";
import dayjs from "dayjs";
import type { Event } from "react-native-calendars/src/timeline/EventBlock";

type DateString = string;

type DateAttendance = {
  _id?: string | null;
  date?: DateString | null;
  status?: string | null; // WEEKLY-OFF | HOLIDAY | WORKING;
  remark?: string | null; // Reason for Holiday or Weekly-Off (Saturday | Sunday | <name_of_holiday> | string)
  in_time?: DateString | null;
  out_time?: DateString | null;
  is_holiday?: boolean | null;
  is_leave?: boolean | null;
};

export type MyAttendanceResponse = {
  status?: boolean | null;
  message?: string | null;
  data?: Array<DateAttendance> | null;
};

export const useMyAttendanceQuery = ({
  token,
  startDate,
  endDate,
}: {
  token?: string;
  /**
   * Attendance for date, in DD-MM-YYYY format
   */
  startDate?: string;
    /**
   * Attendance for date, in DD-MM-YYYY format
   */
  endDate?: string;
}) => {
  const query = useQuery({
    enabled: !!startDate && !!endDate && !!token,
    queryKey: ["staff", "details", "attendance", startDate, endDate],
    queryFn: async ({ signal, queryKey }) => {
      const [_k1, _k2, _k3, startDate, endDate] = queryKey;

      const BASE_URI = "https://mountcarmelschool.com:4201/";
      const MY_ATTENDANCE_URI = `${BASE_URI}hr/staff-attendance/my-attendance/${startDate}/${endDate}`;

      const response = await fetch(MY_ATTENDANCE_URI, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token?.replace("Bearer ", "")}`,
        },
        signal,
      });

      // Check if the response status is not OK (2xx)
      if (!response.ok) {
        return Promise.reject(
          new Error(`HTTP error! Status: ${response.status}`)
        );
      }
      const result = await response.json() as MyAttendanceResponse | undefined | null;

      // Validate the response structure
      if (typeof result !== "object" || result === null) {
        return Promise.reject(new Error("Invalid response format"));
      }

      const { status, message, data } = result;

      if (!status) {
        return Promise.reject(new Error(message || 'Unknown error occurred!'));
      }
      return data;
    },
    refetchOnMount: false,
    meta: {
      friendlyErrorMessage: `Unable to fetch Attendance for date range from ${startDate} to ${endDate}!`,
    },
    select: (data) => {
      const events: Record<string, { events: Event[] }> = {};
      if (!data) return events;

      const weekdays = data.filter((day) => {
        const status = day.status;
        return !(
          !day.date ||
          !status ||
          (["WEEKLY-OFF", "HOLIDAY"].includes(status) && ["Saturday", "Sunday"].includes(day.remark || "")) ||
          (status === "WORKING" && !day.in_time && !day.out_time && !day.remark)
        );
      });

      weekdays.forEach((weekday) => {
        if (!weekday.date) return;

        const eventsList: Event[] = [];
        const formattedDate = dayjs(weekday.date).format('YYYY-MM-DD');
        
        events[formattedDate] = {
          events: eventsList,
        };

        if (!!weekday.is_holiday && !!weekday.status) {
          eventsList.push({
            id: weekday._id || formattedDate,
            start: `${formattedDate} 05:00:00`,
            end: `${formattedDate} 18:00:00`,
            title: weekday.status,
            color: '#8B4A12',
            backgroundColor: '#FFE7C2',
            summary: weekday.remark ? weekday.remark.replace(/\b(saturday|sunday)\b\s*|\s*\/\s*/gi, "").trim() : weekday.status,
          });
        } else if (!!weekday.is_leave && weekday.status) {
          eventsList.push({
            id: weekday._id || formattedDate,
            start: `${formattedDate} ${weekday.in_time || "05:00"}:00`,
            end: `${formattedDate} ${weekday.out_time || "18:00"}:00`,
            title: weekday.remark || weekday.status,
            color: '#922727',
            backgroundColor: '#FFF0F0',
            summary: "Leave",
          });
        } else {
          if (!!weekday.in_time) {
            const timeWithTime = `${formattedDate} ${weekday.in_time.length === 5 ? weekday.in_time + ':00' : weekday.in_time}`;
            const day = dayjs(timeWithTime);

            eventsList.push({
              start: timeWithTime,
              end: timeWithTime,
              title: `Punch-In at ${day.format('hh:mm a')}`,
              color: '#145A32',
              backgroundColor: '#EBF4EB',
              id: `${weekday._id}-punch-in`,
              summary: day.format('h:mm a'),
            });
          }
          if (!!weekday.out_time) {
            const timeWithTime = `${formattedDate} ${weekday.out_time.length === 5 ? weekday.out_time + ':00' : weekday.out_time}`;
            const day = dayjs(timeWithTime);

            eventsList.push({
              start: timeWithTime,
              end: timeWithTime,
              title: `Punch-Out at ${day.format('hh:mm a')}`,
              color: '#0D47A1',
              backgroundColor: '#E0ECFF',
              id: `${weekday._id}-punch-out`,
              summary: day.format('h:mm a'),
            });
          }
        }
      });

      return events;
    },
  });

  return query;
};
