import * as React from 'react';
import dayjs from 'dayjs';

import { useMyAttendanceQuery } from '@/queries/useMyAttendanceQuery';
import { useAttendanceEventsData } from './useAttendanceEventsData';

export const useAttendanceEvents = ({ token }: { token: string | undefined | null }) => {
  const [currentDate, setCurrentDate] = React.useState<string>();

  const day = dayjs(currentDate, 'DD-MM-YYYY');
  const startDate = day.startOf('month').format('DD-MM-YYYY');
  const endDate = day.endOf('month').format('DD-MM-YYYY');

  const myAttendanceQuery = useMyAttendanceQuery({ token, startDate, endDate });
  const events = useAttendanceEventsData(myAttendanceQuery.data);

  /** @param date new date string in "YYYY-MM-DD" format */
  const handleDateChange = React.useCallback((date: string) => {
    setCurrentDate(dayjs(date, 'YYYY-MM-DD').format('DD-MM-YYYY'));
  }, []);

  return {
    events,
    isLoading: myAttendanceQuery.isLoading,
    handleDateChange,
  };
};
