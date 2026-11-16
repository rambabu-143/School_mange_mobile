import * as React from "react";
import { Event } from "react-native-calendars/src/timeline/EventBlock";

export const useAttendanceEventsData = (
  events: Record<string, {events: Event[]}> | null | undefined
) => {
  const prevDataRef = React.useRef({});

  const attendanceEvents: Record<string, {events: Event[]}> = React.useMemo(() => {
    if (!!events) {
      return {
        ...prevDataRef.current,
        ...events,
      };
    }
    return prevDataRef.current;
  }, [events]);

  prevDataRef.current = attendanceEvents;

  return attendanceEvents;
};
