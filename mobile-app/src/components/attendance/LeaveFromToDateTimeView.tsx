import dayjs from 'dayjs';
import * as React from 'react';
import { Image, StyleSheet, Text, View } from 'react-native';
import type { StaffLeaveRequest } from '@/queries/useStaffLeaveRequestsQuery';

export type LeaveFromToDateTimeViewProps = {
  data: Omit<StaffLeaveRequest, 'staff_id'>;
};

const LeaveFromToDateTimeViewImpl: React.FC<LeaveFromToDateTimeViewProps> = ({ data }) => {
  return (
    <View style={styles.container}>
      <View style={styles.content}>
        {data.leave_type === 'SHORT-LEAVE' ? (
          <Text style={[styles.text, styles.semiBold, styles.textAlignVertical]}>
            <Text style={[styles.smallText]}>Date:</Text> {dayjs(data.from_date).format('DD MMM YYYY')}
          </Text>
        ) : null}

        <View style={styles.fromToDateTimeContainer}>
          <View style={styles.dateTimeContainer}>
            <Text style={styles.smallText}>From</Text>
            <Text style={[styles.text, styles.semiBold]}>
              {data.leave_type === 'SHORT-LEAVE'
                ? dayjs(data.from_time, 'HH:mm').format('h:mm a')
                : dayjs(data.from_date).format('DD MMM YYYY')}
            </Text>
          </View>

          <Image source={require('@/assets/icons/ic_arrow_right.png')} style={styles.arrowIcon} />

          <View style={styles.dateTimeContainer}>
            <Text style={styles.smallText}>To</Text>
            <Text style={[styles.text, styles.semiBold]}>
              {data.leave_type === 'SHORT-LEAVE'
                ? dayjs(data.to_time, 'HH:mm').format('h:mm a')
                : dayjs(data.to_date).format('DD MMM YYYY')}
            </Text>
          </View>
        </View>

        {data.first_half_day_on && data.first_half_day_in ? (
          <Text style={[styles.smallText, styles.textAlignVertical]}>
            {data.second_half_day_on ? '1st ' : ''}Half-Leave on {dayjs(data.first_half_day_on).format('DD MMM')} in{' '}
            {data.first_half_day_in.toLowerCase()}
          </Text>
        ) : null}

        {data.second_half_day_on && data.second_half_day_in ? (
          <Text style={[styles.smallText, styles.textAlignVertical]}>
            2nd Half-Leave on {dayjs(data.second_half_day_on).format('DD MMM')} in{' '}
            {data.second_half_day_in.toLowerCase()}
          </Text>
        ) : null}
      </View>

      <View style={styles.durationDays}>
        <Text style={styles.durationText}>
          {data.leave_type === 'SHORT-LEAVE'
            ? `${dayjs(data.duration, 'HH:mm').format('HH:mm')}`
            : `${data.no_of_days} ${data.no_of_days && data.no_of_days <= 1 ? 'day' : 'days'}`}
        </Text>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flexDirection: 'row', padding: 12, borderRadius: 8, alignItems: 'center', backgroundColor: '#eeeeef' },
  content: { flex: 1, gap: 4 },
  fromToDateTimeContainer: { flex: 1, gap: 12, flexDirection: 'row', alignItems: 'center' },
  dateTimeContainer: { flexShrink: 1 },
  arrowIcon: { width: 12, height: 12, resizeMode: 'contain', tintColor: '#555556' },
  text: { fontSize: 16, lineHeight: 16 * 1.5, fontWeight: '400', color: '#323232' },
  smallText: { fontSize: 14, lineHeight: 14 * 1.5, fontWeight: '400', color: '#323232' },
  durationDays: { paddingVertical: 4, paddingHorizontal: 10, borderRadius: 54, backgroundColor: '#ffffff' },
  durationText: { fontSize: 14, lineHeight: 14 * 1.5, fontWeight: '500', color: '#343434' },
  semiBold: { fontWeight: '500' },
  textAlignVertical: { textAlignVertical: 'center' },
});

export const LeaveFromToDateTimeView = React.memo(LeaveFromToDateTimeViewImpl);
