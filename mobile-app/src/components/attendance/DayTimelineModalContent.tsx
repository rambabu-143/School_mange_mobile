import * as React from 'react';
import { Platform, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import dayjs from 'dayjs';
import type { TimelineProps } from 'react-native-calendars';

import { DayTimeline } from './DayTimeline';

export type DayTimelineModalContentProps = Pick<TimelineProps, 'events'> & {
  date: string;
  closeModal: () => void;
};

const _DayTimelineModalContent: React.FC<DayTimelineModalContentProps> = ({
  events,
  date,
  closeModal,
}) => {
  return (
    <View style={[{ flex: 1 }, Platform.OS === 'android' && styles.backdrop]}>
      <View style={[{ flex: 1 }, Platform.OS === 'android' && styles.content]}>
        <View style={styles.header}>
          <Text style={styles.headerText}>{date ? dayjs(date).format('DD MMMM YYYY') : null}</Text>

          <TouchableOpacity onPress={closeModal} style={styles.closeButton}>
            <Text style={styles.closeBottonText}>{Platform.OS === 'ios' ? 'Done' : 'Close'}</Text>
          </TouchableOpacity>
        </View>

        <View style={styles.divider} />

        <DayTimeline events={events} date={date} />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  backdrop: {
    paddingTop: 8,
    backgroundColor: 'rgba(0, 0, 0, 0.2)',
    justifyContent: 'flex-end',
  },
  content: {
    borderTopRightRadius: 16,
    borderTopLeftRadius: 16,
    overflow: 'hidden',
  },
  header: {
    backgroundColor: '#ffffff',
    flexDirection: 'row',
    height: 44,
    alignItems: 'center',
    justifyContent: 'center',
    position: 'relative',
  },
  headerText: {
    flex: 1,
    fontSize: 15,
    lineHeight: 15 * 1.5,
    fontWeight: '500',
    color: '#323232',
    textAlign: 'center',
  },
  closeButton: {
    position: 'absolute',
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 12,
    height: 32,
    right: 0,
  },
  closeBottonText: {
    fontSize: 16,
    lineHeight: 16 * 1.5,
    fontWeight: '600',
    color: '#007AFF',
  },
  divider: {
    height: StyleSheet.hairlineWidth,
    width: '100%',
    backgroundColor: '#343434',
  },
});

export const DayTimelineModalContent = React.memo(_DayTimelineModalContent);
