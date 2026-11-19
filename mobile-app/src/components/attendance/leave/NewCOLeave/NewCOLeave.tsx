import * as React from 'react';
import dayjs from 'dayjs';
import { StyleSheet, View, Text } from 'react-native';
import { DateTimePickerEvent } from '@react-native-community/datetimepicker';

import { CommonFields } from '../CommonFields';
import RNDateTimePicker from '@/components/DateTimePicker';
import { HalfDayLeaveTypeMenu } from '@/components/attendance/HalfDayLeaveTypeMenu';
import { LeaveDayTypeMenu } from '@/components/attendance/LeaveDayTypeMenu';
import { useNewStaffApplicationStore } from '@/stores/new-staff-application-store';

const NewCOLeaveImpl: React.FC = () => {
  const coLeaveDate = useNewStaffApplicationStore((state) => state.coLeaveDate);
  const setCoLeaveDate = useNewStaffApplicationStore.getState().setCoLeaveDate;

  const coAvailDate = useNewStaffApplicationStore((state) => state.coAvailDate);
  const setCoAvailDate = useNewStaffApplicationStore.getState().setCoAvailDate;

  const coLeaveDayType = useNewStaffApplicationStore((state) => state.coLeaveDayType);
  const setCoLeaveDayType = useNewStaffApplicationStore.getState().setCoLeaveDayType;

  const coHalfDayLeavePeriod = useNewStaffApplicationStore((state) => state.coHalfDayLeavePeriod);
  const setCoHalfDayLeavePeriod = useNewStaffApplicationStore.getState().setCoHalfDayLeavePeriod;

  const coDateTimeSelectionError = useNewStaffApplicationStore((state) => state.coDateTimeSelectionError);
  const setCoDateTimeSelectionError = useNewStaffApplicationStore.getState().setCoDateTimeSelectionError;

  return (
    <React.Fragment>
      <View style={styles.cardContainer}>
        <View style={styles.card}>
          <View style={styles.cardItem}>
            <Text style={styles.label}>Leave Date:</Text>

            <RNDateTimePicker
              value={coLeaveDate}
              onChange={(_event: DateTimePickerEvent, date?: Date | undefined) => {
                if (!date) return;
                setCoLeaveDate(date);
              }}
              onError={(error) => setCoDateTimeSelectionError(error.message)}
              minimumDate={dayjs().startOf('month').toDate()}
              maximumDate={dayjs().endOf('year').toDate()}
              accentColor="#2658A5"
              mode={'date'}
              display="default"
            />
          </View>

          <View style={styles.cardItemDivider} />

          <View style={styles.cardItem}>
            <Text style={styles.label}>Avail Date:</Text>

            <RNDateTimePicker
              value={coAvailDate}
              onChange={(_event: DateTimePickerEvent, date?: Date | undefined) => {
                if (!date) return;
                setCoAvailDate(date);
              }}
              onError={(error) => setCoDateTimeSelectionError(error.message)}
              minimumDate={dayjs().startOf('month').toDate()}
              maximumDate={dayjs().endOf('year').toDate()}
              accentColor="#2658A5"
              mode={'date'}
              display="default"
            />
          </View>

          <View style={styles.cardItemDivider} />

          <View style={styles.cardItem}>
            <Text style={styles.label}>Leave Day Type:</Text>

            <LeaveDayTypeMenu
              disabled={false}
              onSelect={(leaveDayType) => {
                setCoLeaveDayType(leaveDayType);
                setCoDateTimeSelectionError('');
              }}
              selectedOption={coLeaveDayType || null}
            />
          </View>

          {coLeaveDayType === 'Half Day' ? (
            <>
              <View style={styles.cardItemDivider} />

              <View style={styles.cardItem}>
                <Text style={styles.label}>Period:</Text>

                <HalfDayLeaveTypeMenu
                  onSelect={(halfDayPeriod) => {
                    setCoHalfDayLeavePeriod(halfDayPeriod);
                    setCoDateTimeSelectionError('');
                  }}
                  selectedOption={coHalfDayLeavePeriod || null}
                />
              </View>
            </>
          ) : null}
        </View>

        {coDateTimeSelectionError ? <Text style={styles.errorText}>{coDateTimeSelectionError}</Text> : null}
      </View>

      <CommonFields />
    </React.Fragment>
  );
};

const styles = StyleSheet.create({
  cardContainer: { gap: 2 },
  card: { gap: 8, backgroundColor: '#efefef', borderRadius: 8, paddingVertical: 8 },
  cardItem: { flexDirection: 'row', gap: 12, alignItems: 'center', paddingHorizontal: 16 },
  label: { flex: 1, fontSize: 15, lineHeight: 15 * 1.5, color: '#343434', fontWeight: '500' },
  cardItemDivider: { height: StyleSheet.hairlineWidth, marginLeft: 16, backgroundColor: '#343434' },
  errorText: { fontSize: 14, lineHeight: 14 * 1.5, color: 'tomato', fontWeight: '500', marginLeft: 4 },
});

export const NewCOLeave = React.memo(NewCOLeaveImpl);
