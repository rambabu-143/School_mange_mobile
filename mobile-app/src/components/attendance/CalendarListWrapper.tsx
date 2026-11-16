import * as React from 'react';
import dayjs from 'dayjs';
import { CalendarList, DateData } from 'react-native-calendars';
import { StyleSheet, useWindowDimensions } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import type { Event } from 'react-native-calendars/src/timeline/EventBlock';
import type { MarkedDates } from 'react-native-calendars/src/types';

import { useAttendanceEvents } from '@/hooks/useAttendanceEvents';
import { useAttendanceDateQuery } from '@/queries/useAttendanceDateQuery';
import { useSessionStore } from '@/lib/session-store';

export type CalendarListWrapperProps = {
  onDayPress: (date: string, events: Event[]) => void;
};

const _CalendarListWrapper = ({ onDayPress }: CalendarListWrapperProps) => {
  const token = useSessionStore((s) => s.session?.token);
  const { height: windowHeight } = useWindowDimensions();
  const { top: topSafeInset } = useSafeAreaInsets();
  const CALENDAR_HEIGHT = windowHeight - topSafeInset - 44;

  const { events, handleDateChange, isLoading } = useAttendanceEvents({ token });
  const attendanceDatesQuery = useAttendanceDateQuery({ token });

  const [pastScrollRange, futureScrollRange] = React.useMemo(
    () => ranges[dayjs().get('month')],
    []
  );

  const monthChangeHandler = React.useCallback(
    (month: DateData) => handleDateChange(month.dateString),
    [handleDateChange]
  );

  const dayPressHandler = React.useCallback(
    (day: DateData) => {
      const { events: dayEvents } = events[day.dateString] || {};
      if (Array.isArray(dayEvents)) {
        onDayPress(day.dateString, dayEvents);
      }
    },
    [events, onDayPress]
  );

  // ponytail: plain dot marking for now — the old "custom" marking type needs a
  // custom day-cell renderer we haven't ported; upgrade if per-day color coding matters.
  const markedDates: MarkedDates = React.useMemo(() => {
    const marks: MarkedDates = {};
    for (const [date, { events: dayEvents }] of Object.entries(events)) {
      if (dayEvents.length > 0) {
        marks[date] = { marked: true, dotColor: dayEvents[0].color };
      }
    }
    return marks;
  }, [events]);

  return (
    <CalendarList
      calendarHeight={CALENDAR_HEIGHT}
      pagingEnabled
      disabledByWeekDays={[0, 6]}
      minDate={attendanceDatesQuery.data?.start_date}
      maxDate={attendanceDatesQuery.data?.end_date}
      pastScrollRange={pastScrollRange}
      futureScrollRange={futureScrollRange}
      allowSelectionOutOfRange={false}
      enableSwipeMonths={false}
      displayLoadingIndicator={isLoading}
      theme={theme}
      calendarStyle={styles.calendarStyle}
      disableAllTouchEventsForDisabledDays
      onMonthChange={monthChangeHandler}
      onDayPress={dayPressHandler}
      markedDates={markedDates}
    />
  );
};

const ranges = [
  [9, 2],
  [10, 1],
  [11, 0],
  [0, 11],
  [1, 10],
  [2, 9],
  [3, 8],
  [4, 7],
  [5, 6],
  [6, 5],
  [7, 4],
  [8, 3],
];

const theme: React.ComponentProps<typeof CalendarList>['theme'] = {
  // @ts-ignore-nextline below is valid property
  'stylesheet.calendar.main': {
    monthView: { flex: 1 },
    week: {
      flex: 1,
      marginVertical: 0,
      marginTop: 4,
      marginBottom: 4,
      flexDirection: 'row',
      justifyContent: 'space-around',
    },
  },
  'stylesheet.day.basic': {
    base: { flex: 1, width: '100%', alignItems: 'stretch' },
    todayText: { color: '#5589d8', fontWeight: 'bold' },
    selectedToday: { backgroundColor: '#5589d8', borderRadius: 16 },
  },
  textDayStyle: { alignSelf: 'center' },
  textDayFontWeight: 'normal',
  textMonthFontWeight: '500',
  textSectionTitleColor: '#657795',
  textDayHeaderFontWeight: '500',
  textDisabledColor: '#A1ADC4',
  dayTextColor: '#000000',
  'stylesheet.calendar.header': {
    dayTextAtIndex0: { color: '#7D93A6' },
    dayTextAtIndex6: { color: '#7D93A6' },
  },
  todayTextColor: '#5589d8',
  selectedDayBackgroundColor: '#2b2b2b',
};

const styles = StyleSheet.create({
  calendarStyle: { paddingLeft: 0, paddingRight: 0 },
});

export const CalendarListWrapper = React.memo(_CalendarListWrapper);
