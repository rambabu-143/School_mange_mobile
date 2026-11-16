import { useQuery } from '@tanstack/react-query';
import dayjs from 'dayjs';
import type { Event } from 'react-native-calendars/src/timeline/EventBlock';

import { apiClient, orEmpty } from '@/lib/api-client';

type DateAttendance = {
  _id?: string | null;
  date?: string | null;
  status?: string | null; // WEEKLY-OFF | HOLIDAY | WORKING
  remark?: string | null;
  in_time?: string | null;
  out_time?: string | null;
  is_holiday?: boolean | null;
  is_leave?: boolean | null;
};

export const useMyAttendanceQuery = ({
  token,
  startDate,
  endDate,
}: {
  token: string | undefined | null;
  /** DD-MM-YYYY */
  startDate?: string;
  /** DD-MM-YYYY */
  endDate?: string;
}) => {
  return useQuery({
    enabled: !!startDate && !!endDate && !!token,
    queryKey: ['staff', 'details', 'attendance', startDate, endDate],
    queryFn: () =>
      orEmpty(
        apiClient.get<Array<DateAttendance>>(`hr/staff-attendance/my-attendance/${startDate}/${endDate}`, token),
        []
      ),
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
          (['WEEKLY-OFF', 'HOLIDAY'].includes(status) &&
            ['Saturday', 'Sunday'].includes(day.remark || '')) ||
          (status === 'WORKING' && !day.in_time && !day.out_time && !day.remark)
        );
      });

      weekdays.forEach((weekday) => {
        if (!weekday.date) return;

        const eventsList: Event[] = [];
        const formattedDate = dayjs(weekday.date).format('YYYY-MM-DD');

        events[formattedDate] = { events: eventsList };

        if (weekday.is_holiday && weekday.status) {
          eventsList.push({
            id: weekday._id || formattedDate,
            start: `${formattedDate} 05:00:00`,
            end: `${formattedDate} 18:00:00`,
            title: weekday.status,
            color: '#8B4A12',
            summary: weekday.remark
              ? weekday.remark.replace(/\b(saturday|sunday)\b\s*|\s*\/\s*/gi, '').trim()
              : weekday.status,
          });
        } else if (weekday.is_leave && weekday.status) {
          eventsList.push({
            id: weekday._id || formattedDate,
            start: `${formattedDate} ${weekday.in_time || '05:00'}:00`,
            end: `${formattedDate} ${weekday.out_time || '18:00'}:00`,
            title: weekday.remark || weekday.status,
            color: '#922727',
            summary: 'Leave',
          });
        } else {
          if (weekday.in_time) {
            const timeWithTime = `${formattedDate} ${weekday.in_time.length === 5 ? weekday.in_time + ':00' : weekday.in_time}`;
            const day = dayjs(timeWithTime);
            eventsList.push({
              start: timeWithTime,
              end: timeWithTime,
              title: `Punch-In at ${day.format('hh:mm a')}`,
              color: '#145A32',
              id: `${weekday._id}-punch-in`,
              summary: day.format('h:mm a'),
            });
          }
          if (weekday.out_time) {
            const timeWithTime = `${formattedDate} ${weekday.out_time.length === 5 ? weekday.out_time + ':00' : weekday.out_time}`;
            const day = dayjs(timeWithTime);
            eventsList.push({
              start: timeWithTime,
              end: timeWithTime,
              title: `Punch-Out at ${day.format('hh:mm a')}`,
              color: '#0D47A1',
              id: `${weekday._id}-punch-out`,
              summary: day.format('h:mm a'),
            });
          }
        }
      });

      return events;
    },
  });
};
