import * as React from "react";
import { Timeline } from "react-native-calendars";
import type { TimelineProps } from "react-native-calendars";
import { useSafeAreaInsets } from "react-native-safe-area-context";

export type DayTimelineProps = Pick<TimelineProps, "events" | "date">;

export const _DayTimeline: React.FC<DayTimelineProps> = ({ events, date }) => {
  const { bottom: safeBottomInset } = useSafeAreaInsets();

  const _memoizedProps = React.useMemo(
    () => ({
      scrollIndicatorInsets: { bottom: safeBottomInset + 24 },
      theme: { extraCalendarHeight: 24 + safeBottomInset + 24 }, // my_extra + bottom_footer + bottom_extra
    }),
    [safeBottomInset]
  );

  return (
    <Timeline
      date={date}
      events={events}
      showNowIndicator
      scrollToFirst={true}
      timelineLeftInset={72}
      isCurrent={true}
      format24h={false}
      overlapEventsSpacing={4}
      rightEdgeSpacing={8}
      numberOfDays={1}
      start={5}
      end={18}
      scrollIndicatorInsets={_memoizedProps.scrollIndicatorInsets}
      theme={_memoizedProps.theme}
    />
  );
};

export const DayTimeline = React.memo(_DayTimeline);
