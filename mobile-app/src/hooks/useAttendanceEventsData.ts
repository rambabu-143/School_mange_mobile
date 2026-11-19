import * as React from 'react';
import type { Event } from 'react-native-calendars/src/timeline/EventBlock';

export const useAttendanceEventsData = (
  events: Record<string, { events: Event[] }> | null | undefined
) => {
  const [attendanceEvents, setAttendanceEvents] = React.useState<Record<string, { events: Event[] }>>({});

  React.useEffect(() => {
    if (events) {
      // eslint-disable-next-line react-hooks/set-state-in-effect -- sync server data into editable local state
      setAttendanceEvents((prev) => ({ ...prev, ...events }));
    }
  }, [events]);

  return attendanceEvents;
};
