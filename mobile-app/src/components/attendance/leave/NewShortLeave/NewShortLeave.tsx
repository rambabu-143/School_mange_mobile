import * as React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import dayjs from 'dayjs';
import minMax from 'dayjs/plugin/minMax';
import type { DateTimePickerEvent } from '@react-native-community/datetimepicker';

import RNDateTimePicker from '@/components/DateTimePicker';
import { useNewStaffApplicationStore } from '@/stores/new-staff-application-store';
import { CommonFields } from '../CommonFields';

dayjs.extend(minMax);

const _NewShortLeave: React.FC = () => {
  const shortLeaveDate = useNewStaffApplicationStore((state) => state.shortLeaveDate);
  const setShortLeaveDate = useNewStaffApplicationStore.getState().setShortLeaveDate;

  const shortLeaveFromTime = useNewStaffApplicationStore((state) => state.shortLeaveFromTime);
  const setShortLeaveFromTime = useNewStaffApplicationStore.getState().setShortLeaveFromTime;

  const shortLeaveToTime = useNewStaffApplicationStore((state) => state.shortLeaveToTime);
  const setShortLeaveToTime = useNewStaffApplicationStore.getState().setShortLeaveToTime;

  const dateTimeSelectionError = useNewStaffApplicationStore((state) => state.dateTimeSelectionError);
  const setDateTimeSelectionError = useNewStaffApplicationStore.getState().setDateTimeSelectionError;

  const minShortLeaveFromTime = dayjs(new Date()).set('hour', 7).set('minute', 0).set('second', 0).toDate();

  return (
    <React.Fragment>
      <View style={{ gap: 2 }}>
        <View style={{ gap: 8, backgroundColor: '#efefef', borderRadius: 8, paddingVertical: 8 }}>
          <View style={{ flexDirection: 'row', gap: 12, alignItems: 'center', paddingHorizontal: 16 }}>
            <Text style={{ flex: 1, fontSize: 15, lineHeight: 15 * 1.5, color: '#343434', fontWeight: '500' }}>
              Date:
            </Text>

            <RNDateTimePicker
              value={shortLeaveDate}
              onChange={(_event: DateTimePickerEvent, date?: Date | undefined) => {
                if (date) {
                  setShortLeaveDate(date);
                  setDateTimeSelectionError('');
                }
              }}
              onError={(error) => setDateTimeSelectionError(error.message)}
              minimumDate={dayjs().startOf('month').toDate()}
              maximumDate={dayjs().endOf('year').toDate()}
              accentColor="#2658A5"
              mode={'date'}
              display="default"
            />
          </View>

          <View style={styles.cardItemDivider} />

          <View style={{ flexDirection: 'row', gap: 12, alignItems: 'center', paddingHorizontal: 16 }}>
            <Text style={{ flex: 1, fontSize: 15, lineHeight: 15 * 1.5, color: '#343434', fontWeight: '500' }}>
              From:
            </Text>

            <RNDateTimePicker
              value={shortLeaveFromTime}
              onChange={(_event: DateTimePickerEvent, date?: Date | undefined) => {
                if (!date) return;
                setShortLeaveFromTime(date);
                setDateTimeSelectionError('');
              }}
              onError={(error) => setDateTimeSelectionError(error.message)}
              disabled={false}
              minimumDate={minShortLeaveFromTime}
              maximumDate={undefined}
              accentColor="#2658A5"
              mode={'time'}
              display="default"
            />
          </View>

          <View style={styles.cardItemDivider} />

          <View style={{ flexDirection: 'row', gap: 12, alignItems: 'center', paddingHorizontal: 16 }}>
            <Text style={{ flex: 1, fontSize: 15, lineHeight: 15 * 1.5, color: '#343434', fontWeight: '500' }}>
              To:
            </Text>

            <RNDateTimePicker
              value={shortLeaveToTime}
              onChange={(_event: DateTimePickerEvent, date?: Date | undefined) => {
                if (!date) return;
                setShortLeaveToTime(date);
                setDateTimeSelectionError('');
              }}
              onError={(error) => setDateTimeSelectionError(error.message)}
              disabled={false}
              minimumDate={dayjs.max(dayjs(shortLeaveFromTime), dayjs(minShortLeaveFromTime)).toDate()}
              accentColor="#2658A5"
              mode={'time'}
              display="default"
            />
          </View>
        </View>

        {dateTimeSelectionError ? (
          <Text style={{ fontSize: 14, lineHeight: 14 * 1.5, color: 'tomato', fontWeight: '500', marginLeft: 4 }}>
            {dateTimeSelectionError}
          </Text>
        ) : null}
      </View>

      <CommonFields />
    </React.Fragment>
  );
};

const styles = StyleSheet.create({
  cardItemDivider: { height: StyleSheet.hairlineWidth, marginLeft: 16, backgroundColor: '#343434' },
});

export const NewShortLeave = React.memo(_NewShortLeave);
