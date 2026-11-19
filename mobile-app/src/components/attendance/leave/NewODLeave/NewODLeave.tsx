import * as React from 'react';
import dayjs from 'dayjs';
import { StyleSheet, Text, TextInput, View } from 'react-native';
import { DateTimePickerEvent } from '@react-native-community/datetimepicker';

import RNDateTimePicker from '@/components/DateTimePicker';
import { CommonFields } from '../CommonFields';
import { useNewStaffApplicationStore } from '@/stores/new-staff-application-store';
import { useValidateFields } from '../hooks/useValidateFields';

const NewODLeaveImpl: React.FC = () => {
  const numberOfDaysStr = useNewStaffApplicationStore((state) => state.numberOfDaysStr);
  const setNumberOfDaysStr = useNewStaffApplicationStore.getState().setNumberOfDaysStr;
  const to = useNewStaffApplicationStore((state) => state.to);
  const setTo = useNewStaffApplicationStore.getState().setTo;
  const from = useNewStaffApplicationStore((state) => state.from);
  const setFrom = useNewStaffApplicationStore.getState().setFrom;
  const dateTimeSelectionError = useNewStaffApplicationStore((state) => state.dateTimeSelectionError);
  const setDateTimeSelectionError = useNewStaffApplicationStore.getState().setDateTimeSelectionError;

  const { validateODLeaveFields } = useValidateFields();

  const computeToDate = (fromDate?: Date | null) => {
    const numOfDaysInt = parseInt(numberOfDaysStr.trim());
    const numOfFullDays = isNaN(numOfDaysInt) ? 0 : numOfDaysInt;

    const fromDateFinal = fromDate || from;
    let fromDayjs = dayjs(fromDateFinal);

    if (numOfFullDays >= 1) {
      fromDayjs = fromDayjs.add(numOfFullDays - 1, 'days');
    }
    setTo(fromDayjs.toDate());
  };

  const onNumberOfDaysBlur = () => {
    validateODLeaveFields();
    computeToDate();
  };

  return (
    <React.Fragment>
      <View style={styles.cardContainer}>
        <View style={styles.card}>
          <View style={{ ...styles.cardItem, minHeight: 38 }}>
            <Text style={styles.label}>No. of days:</Text>

            <TextInput
              style={styles.fullDaysInput}
              value={numberOfDaysStr}
              placeholderTextColor={'#9a9a9a'}
              placeholder="# Days"
              onChangeText={(text) => {
                setNumberOfDaysStr(text.replace(/[^0-9]/g, ''));
                setDateTimeSelectionError('');
              }}
              onBlur={onNumberOfDaysBlur}
              numberOfLines={1}
              maxLength={3}
              multiline={false}
              autoCorrect={false}
              enterKeyHint="enter"
              inputMode="numeric"
              keyboardType="number-pad"
              returnKeyType="done"
              selectTextOnFocus
              textAlign="right"
            />
          </View>

          <View style={styles.cardItemDivider} />

          <View style={styles.cardItem}>
            <Text style={styles.label}>From:</Text>

            <RNDateTimePicker
              value={from}
              onChange={(_event: DateTimePickerEvent, date?: Date | undefined) => {
                if (!date) return;
                setFrom(date);
                validateODLeaveFields();
                computeToDate(date);
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

          <View style={styles.cardItem}>
            <Text style={styles.label}>To:</Text>

            <RNDateTimePicker
              value={to}
              onError={(error) => setDateTimeSelectionError(error.message)}
              disabled
              minimumDate={undefined}
              accentColor="#2658A5"
              mode={'date'}
              display="default"
              style={styles.disabledTextInput}
            />
          </View>
        </View>

        {dateTimeSelectionError ? <Text style={styles.errorText}>{dateTimeSelectionError}</Text> : null}
      </View>

      <CommonFields />
    </React.Fragment>
  );
};

const styles = StyleSheet.create({
  cardContainer: { gap: 2 },
  card: { gap: 8, backgroundColor: '#efefef', borderRadius: 8, paddingVertical: 8 },
  cardItem: { flexDirection: 'row', gap: 12, alignItems: 'center', paddingHorizontal: 16 },
  fullDaysInput: { paddingTop: 0, fontSize: 17, lineHeight: 17 * 1.5, height: 36, paddingVertical: 4 },
  label: { flex: 1, fontSize: 15, lineHeight: 15 * 1.5, color: '#343434', fontWeight: '500' },
  cardItemDivider: { height: StyleSheet.hairlineWidth, marginLeft: 16, backgroundColor: '#343434' },
  errorText: { fontSize: 14, lineHeight: 14 * 1.5, color: 'tomato', fontWeight: '500', marginLeft: 4 },
  disabledTextInput: { opacity: 0.5 },
});

export const NewODLeave = React.memo(NewODLeaveImpl);
