import * as React from "react";
import { useWindowDimensions } from "react-native";
import { TimelineList } from "react-native-calendars";
import type { TimelineListProps } from "react-native-calendars";
import { useSafeAreaInsets } from "react-native-safe-area-context";

import { HEADER_HEIGHT } from "../Header/Header";

export type CustomTimelineListProps = Pick<TimelineListProps, 'events'>;

export const _CustomTimelineList: React.FC<CustomTimelineListProps> = ({
  events,
}) => {
  const { top: safeTopInset, bottom: safeBottomInset } = useSafeAreaInsets();
  const { height: windowHeight } = useWindowDimensions();

  const pageHeight =
    windowHeight - safeTopInset - HEADER_HEIGHT - CALENDAR_HEIGHT_APPROX;

  const _infiniteListProps: TimelineListProps["infiniteListProps"] =
    React.useMemo(
      () => ({
        pageHeight: pageHeight,
      }),
      [pageHeight]
    );

  const _timelineProps: TimelineListProps["timelineProps"] = React.useMemo(
    () => ({
      isCurrent: false,
      format24h: false,
      overlapEventsSpacing: 4,
      rightEdgeSpacing: 8,
      numberOfDays: 7,
      start: 5,
      end: 18,
      scrollIndicatorInsets: { bottom: safeBottomInset + 24 },
      theme: { extraCalendarHeight: 24 + safeBottomInset + 24 }, // my_extra + bottom_footer + bottom_extra
    }),
    [safeBottomInset]
  );

  return (
    <TimelineList
      events={events}
      showNowIndicator
      scrollToFirst={true}
      scrollToNow={true}
      infiniteListProps={_infiniteListProps}
      timelineProps={_timelineProps}
    />
  );
};

const CALENDAR_HEIGHT_APPROX = 147;

export const CustomTimelineList = React.memo(_CustomTimelineList);
