import * as React from "react";
import dayjs from "dayjs";
import { CalendarList, DateData } from "react-native-calendars";
import { StyleSheet, useWindowDimensions } from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import type { Event } from "react-native-calendars/src/timeline/EventBlock";

import { useAttendanceEvents } from "../../hooks/useAttendanceEvents";
import { StaffAttendanceParams } from "../../types";
import { useAttendanceDateQuery } from "../../queries/useAttendanceDateQuery";

export type CalendarListWrapperProps = {
  params?: StaffAttendanceParams;
  onDayPress: (date: string, events: Event[]) => void;
};

const _CalendarListWrapper = ({ params, onDayPress }) => {
  const { height: windowHeight } = useWindowDimensions();
  const { top: topSafeInset } = useSafeAreaInsets();
  const CALENDAR_HEIGHT = windowHeight - topSafeInset - 44;

  const { events, handleDateChange, isLoading } = useAttendanceEvents({
    token: params?.token,
  });
  const attendanceDatesQuery = useAttendanceDateQuery({ token: params?.token });

  const [pastScrollRange, futureScrollRange] = React.useMemo(
    () => ranges[dayjs().get("month")],
    []
  );

  const monthChangeHandler = React.useCallback(
    (month: DateData) => {
      const date = month.dateString; // format = YYYY-MM-DD
      handleDateChange(date);
    },
    [handleDateChange]
  );

  const dayPressHandler = React.useCallback(
    (day: DateData) => {
      const date = day.dateString; // format = YYYY-MM-DD
      const { events: _events } = events[date] || {};

      if (Array.isArray(_events)) {
        onDayPress(date, _events);
      }
    },
    [events]
  );

  return (
    <CalendarList
      markingType="custom"
      calendarHeight={CALENDAR_HEIGHT}
      pagingEnabled={true}
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
      disableAllTouchEventsForDisabledDays={true}
      onMonthChange={monthChangeHandler}
      onDayPress={dayPressHandler}
      markedDates={events}
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

const theme: React.ComponentProps<typeof CalendarList>["theme"] = {
  // @ts-ignore-nextline below is valid property
  "stylesheet.calendar.main": {
    monthView: {
      flex: 1,
    },
    week: {
      flex: 1,
      marginVertical: 0,
      marginTop: 4,
      marginBottom: 4,
      flexDirection: "row",
      justifyContent: "space-around",
    },
  },
  "stylesheet.day.basic": {
    base: {
      flex: 1,
      width: "100%",
      alignItems: "stretch",
    },
    //===
    todayText: {
      color: "#5589d8",
      fontWeight: "bold",
    },
    selectedToday: {
      backgroundColor: "#5589d8",
      borderRadius: 16,
    },
  },
  textDayStyle: {
    alignSelf: "center",
  },

  // ====
  textDayFontWeight: "normal",
  textMonthFontWeight: "500",

  textSectionTitleColor: "#657795",
  textDayHeaderFontWeight: "500",

  textDisabledColor: "#A1ADC4",
  dayTextColor: "#000000",

  "stylesheet.calendar.header": {
    dayTextAtIndex0: {
      color: "#7D93A6",
    },
    dayTextAtIndex6: {
      color: "#7D93A6",
    },
  },

  todayTextColor: "#5589d8",
  selectedDayBackgroundColor: "#2b2b2b",
};

const styles = StyleSheet.create({
  calendarStyle: {
    paddingLeft: 0,
    paddingRight: 0,
  },
});

export const CalendarListWrapper = React.memo(_CalendarListWrapper);
