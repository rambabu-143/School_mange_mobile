import * as React from "react";
import { ExpandableCalendar } from "react-native-calendars";
import type { ExpandableCalendarProps } from "react-native-calendars";
import type { Theme } from "react-native-calendars/src/types";

import { Arrow } from "./Arrow";
import { useAttendanceDateQuery } from "../../queries/useAttendanceDateQuery";

export type CustomExpandableCalendarProps = {
  isLoading: boolean;
  params?: {
    token?: string;
  };
};

export const CustomExpandableCalendar: React.FC<
  CustomExpandableCalendarProps
> = ({ isLoading, params }) => {
  const _renderArrow = React.useCallback(
    (
      ...params: Parameters<
        Exclude<ExpandableCalendarProps["renderArrow"], null | undefined>
      >
    ) => {
      const [direction, { disable } = {}] = params;
      return <Arrow direction={direction} disable={disable} />;
    },
    []
  );

  const _disabledByWeekDays = React.useMemo(() => [0, 6], []);

  const attendanceDatesQuery = useAttendanceDateQuery({ token: params?.token });

  return (
    <ExpandableCalendar
      allowShadow={true}
      theme={theme}
      disabledByWeekDays={_disabledByWeekDays}
      displayLoadingIndicator={isLoading}
      futureScrollRange={0}
      minDate={attendanceDatesQuery.data?.start_date}
      maxDate={attendanceDatesQuery.data?.end_date}
      renderArrow={_renderArrow}
      // disableAllTouchEventsForDisabledDays={true}
      // disableAllTouchEventsForInactiveDays={true}
      allowSelectionOutOfRange={false}
      // pastScrollRange={0}

      // // CalendarList props
      // pastScrollRange
      // futureScrollRange
      // calendarStyle
      // calendarHeight
      // calendarWidth
      // staticHeader
      // showScrollIndicator

      // // ExpandableCalendar props
      // initialPosition
      // onCalendarToggled
      // disablePan
      // hideKnob
      // leftArrowImageSource
      // rightArrowImageSource

      // disableWeekScroll
      // openThreshold
      // closeThreshold
      // closeOnDayPress // false

      // firstDay={1}
      // horizontal={false}
      // hideArrows
      // disablePan
      // hideKnob
      // initialPosition={ExpandableCalendar.positions.OPEN}
      // calendarStyle={styles.calendar}
      // headerStyle={styles.header} // for horizontal only
      // disableWeekScroll
      // theme={theme.current}
      // disableAllTouchEventsForDisabledDays
      // firstDay={1}
      // markedDates={marked.current}
      // leftArrowImageSource={leftArrowIcon}
      // rightArrowImageSource={rightArrowIcon}
      // animateScroll
    />
  );
};

const theme: Theme = {
  textDayFontWeight: "normal",
  textMonthFontWeight: "500",

  textSectionTitleColor: "#657795",
  textDayHeaderFontWeight: "500",

  textDisabledColor: "#A1ADC4",
  dayTextColor: "#000000",
  // @ts-ignore
  "stylesheet.calendar.header": {
    dayTextAtIndex0: {
      color: "#7D93A6",
    },
    dayTextAtIndex6: {
      color: "#7D93A6",
    },
  },
  arrowStyle: {
    padding: 4,
  },
  "stylesheet.day.basic": {
    todayText: {
      color: "#5589d8",
      fontWeight: "bold",
    },
    selectedToday: {
      backgroundColor: "#5589d8",
      borderRadius: 16,
    },
  },
  expandableKnobColor: "#a1adc4",
  todayTextColor: "#5589d8",
  selectedDayBackgroundColor: "#2b2b2b",
};
