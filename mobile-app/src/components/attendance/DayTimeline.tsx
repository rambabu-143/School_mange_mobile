import * as React from 'react';
import { Timeline } from 'react-native-calendars';
import type { TimelineProps } from 'react-native-calendars';

export type DayTimelineProps = Pick<TimelineProps, 'events' | 'date'>;

const _DayTimeline: React.FC<DayTimelineProps> = ({ events, date }) => {
  return (
    <Timeline
      date={date}
      events={events}
      showNowIndicator
      scrollToFirst
      timelineLeftInset={72}
      format24h={false}
      overlapEventsSpacing={4}
      rightEdgeSpacing={8}
      numberOfDays={1}
      start={5}
      end={18}
    />
  );
};

export const DayTimeline = React.memo(_DayTimeline);
