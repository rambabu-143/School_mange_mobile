import * as React from 'react';
import { LayoutAnimation, Pressable, StyleSheet, Text, TextInput, TouchableOpacity, View } from 'react-native';
import dayjs from 'dayjs';
import * as Haptics from 'expo-haptics';
import type { DateTimePickerEvent } from '@react-native-community/datetimepicker';

import RNDateTimePicker from '@/components/DateTimePicker';
import { LeaveTypeMenu } from '@/components/attendance/LeaveTypeMenu';
import { HalfDaySelectionMenu } from '@/components/attendance/HalfDaySelectionMenu';
import { HalfDayLeaveTypeMenu } from '@/components/attendance/HalfDayLeaveTypeMenu';
import { HalfDayLeaveDateMenu } from '@/components/attendance/HalfDayLeaveDateMenu';
import { useNewStaffApplicationStore } from '@/stores/new-staff-application-store';
import type { StaffLeaveDetails } from '@/queries/useStaffLeaveBalancesQuery';
import { useValidateFields } from '../hooks/useValidateFields';
import { CommonFields } from '../CommonFields';

const NewLeaveImpl: React.FC = () => {
  const selectedLeaveCategory = useNewStaffApplicationStore((state) => state.selectedLeaveCategory);
  const setSelectedLeaveCategory = useNewStaffApplicationStore.getState().setSelectedLeaveCategory;
  const leaveTypeError = useNewStaffApplicationStore((state) => state.leaveTypeError);
  const setLeaveTypeError = useNewStaffApplicationStore.getState().setLeaveTypeError;
  const numberOfHalfDays = useNewStaffApplicationStore((state) => state.numberOfHalfDays);
  const setNumberOfHalfDays = useNewStaffApplicationStore.getState().setNumberOfHalfDays;
  const numberOfDaysStr = useNewStaffApplicationStore((state) => state.numberOfDaysStr);
  const setNumberOfDaysStr = useNewStaffApplicationStore.getState().setNumberOfDaysStr;
  const to = useNewStaffApplicationStore((state) => state.to);
  const setTo = useNewStaffApplicationStore.getState().setTo;
  const from = useNewStaffApplicationStore((state) => state.from);
  const setFrom = useNewStaffApplicationStore.getState().setFrom;
  const dateTimeSelectionError = useNewStaffApplicationStore((state) => state.dateTimeSelectionError);
  const setDateTimeSelectionError = useNewStaffApplicationStore.getState().setDateTimeSelectionError;
  const singleHalfDayLeaveError = useNewStaffApplicationStore((state) => state.singleHalfDayLeaveError);
  const setSingleHalfDayLeaveError = useNewStaffApplicationStore.getState().setSingleHalfDayLeaveError;
  const singleHalfDayLeaveDetails = useNewStaffApplicationStore((state) => state.singleHalfDayLeaveDetails);
  const setSingleHalfDayLeaveDetails = useNewStaffApplicationStore.getState().setSingleHalfDayLeaveDetails;

  const { validateRegularLeaveFields } = useValidateFields();

  const computeToDate = (fromDate?: Date | null, halfDays?: number | null) => {
    const numOfDaysInt = parseInt(numberOfDaysStr.trim());
    const numOfFullDays = isNaN(numOfDaysInt) ? 0 : numOfDaysInt;
    const numOfHalfDays = halfDays ?? numberOfHalfDays ?? 0;

    const totalDays = numOfFullDays + numOfHalfDays - 1;

    const fromDateFinal = fromDate || from;
    let fromDayjs = dayjs(fromDateFinal);
    if (totalDays >= 1) {
      fromDayjs = fromDayjs.add(totalDays, 'days');
    }
    const toDateFinal = fromDayjs.toDate();
    setTo(toDateFinal);

    if (numOfFullDays > 0) {
      setSingleHalfDayLeaveDetails((prev) => {
        const leaveOn =
          prev.leaveOn === fromDateFinal || prev.leaveOn === toDateFinal ? prev.leaveOn : fromDateFinal;
        return {
          leaveIn: leaveOn === fromDateFinal ? 'Second-Half' : 'First-Half',
          leaveOn,
        };
      });
    } else {
      setSingleHalfDayLeaveDetails({ leaveIn: null, leaveOn: fromDateFinal });
    }
  };

  const handleLeaveTypeSelect = React.useCallback((option: StaffLeaveDetails) => {
    setSelectedLeaveCategory(option);
    setLeaveTypeError('');
    if (option.is_half_day_applicable === 'No') {
      setNumberOfHalfDays(0);
      setSingleHalfDayLeaveDetails({ leaveOn: from, leaveIn: null });
      computeToDate(null, 0);
    }
  }, []);

  const onNumberOfDaysBlur = () => {
    validateRegularLeaveFields();
    computeToDate();
  };

  return (
    <React.Fragment>
      {/* Leave Type Selection */}
      <View style={{ gap: 2 }}>
        <View style={{ backgroundColor: '#efefef', borderRadius: 8 }}>
          <View
            style={{
              flexDirection: 'row',
              gap: 24,
              padding: 16,
              alignItems: 'flex-start',
              justifyContent: 'space-between',
            }}
          >
            <Text style={{ flex: 1, fontSize: 15, lineHeight: 15 * 1.5, fontWeight: '500', color: '#343434' }}>
              Leave Type:
            </Text>

            <LeaveTypeMenu selectedOption={selectedLeaveCategory} onSelect={handleLeaveTypeSelect} />
          </View>
        </View>

        {leaveTypeError ? (
          <Text style={{ fontSize: 14, lineHeight: 14 * 1.5, color: 'tomato', fontWeight: '500', marginLeft: 4 }}>
            {leaveTypeError}
          </Text>
        ) : null}
      </View>

      {/* Date Selection */}
      <View style={{ gap: 2 }}>
        <View style={{ gap: 8, backgroundColor: '#efefef', borderRadius: 8, paddingVertical: 8 }}>
          {selectedLeaveCategory !== null && selectedLeaveCategory.is_half_day_applicable === 'Yes' ? (
            <>
              <View style={{ flexDirection: 'row', gap: 12, minHeight: 38, alignItems: 'center', paddingHorizontal: 16 }}>
                <Text style={{ flex: 1, fontSize: 15, lineHeight: 15 * 1.5, color: '#343434', fontWeight: '500' }}>
                  No. of half days:
                </Text>

                <HalfDaySelectionMenu
                  selectedOption={numberOfHalfDays}
                  onSelect={(value) => {
                    setNumberOfHalfDays(value);
                    if (value > 0) {
                      setNumberOfDaysStr((v) => (isNaN(parseInt(v)) ? '0' : v));
                    }
                    computeToDate(null, value);
                    setSingleHalfDayLeaveError('');
                    setDateTimeSelectionError('');
                    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
                    LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
                  }}
                  disabled={!selectedLeaveCategory}
                  onDisabledPress={() => {
                    if (!selectedLeaveCategory) {
                      setLeaveTypeError('Please select a leave type first!');
                    }
                  }}
                />
              </View>

              <View style={styles.cardItemDivider} />
            </>
          ) : null}

          <View style={{ flexDirection: 'row', gap: 12, alignItems: 'center', paddingHorizontal: 16, minHeight: 38 }}>
            <Text style={{ flex: 1, fontSize: 15, lineHeight: 15 * 1.5, color: '#343434', fontWeight: '500' }}>
              No. of full days:
            </Text>

            {selectedLeaveCategory ? (
              <TextInput
                style={{ paddingTop: 0, fontSize: 17, lineHeight: 17 * 1.5, height: 36, paddingVertical: 4 }}
                value={numberOfDaysStr}
                editable={!!selectedLeaveCategory}
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
            ) : (
              <TouchableOpacity
                disabled={!!selectedLeaveCategory}
                activeOpacity={1}
                onPress={() => {
                  if (!selectedLeaveCategory) {
                    setLeaveTypeError('Please select a leave type first!');
                  }
                }}
              >
                <Text style={{ fontSize: 17, lineHeight: 17 * 1.5, color: '#9a9a9a', textAlign: 'right' }} numberOfLines={1}>
                  # Days
                </Text>
              </TouchableOpacity>
            )}
          </View>

          <View style={styles.cardItemDivider} />

          <View style={{ flexDirection: 'row', gap: 12, alignItems: 'center', minHeight: 38, paddingLeft: 28, paddingRight: 16 }}>
            <Text style={{ flex: 1, fontSize: 16, lineHeight: 16 * 1.5, color: '#727272', fontWeight: '500' }}>
              Total no. of days:
            </Text>

            <Text style={{ fontSize: 17, lineHeight: 17 * 1.5, color: '#727272', fontWeight: '500', textAlign: 'right' }} numberOfLines={1}>
              {(numberOfDaysStr.trim().length > 0 ? parseInt(numberOfDaysStr.trim(), 10) : 0) +
                (numberOfHalfDays ? numberOfHalfDays / 2 : 0)}
            </Text>
          </View>

          <View style={styles.cardItemDivider} />

          <View style={{ flexDirection: 'row', gap: 12, alignItems: 'center', paddingHorizontal: 16 }}>
            <Text style={{ flex: 1, fontSize: 15, lineHeight: 15 * 1.5, color: '#343434', fontWeight: '500' }}>From:</Text>

            <Pressable
              onPress={() => {
                if (!selectedLeaveCategory) {
                  setLeaveTypeError('Please select a leave type first!');
                }
              }}
            >
              <RNDateTimePicker
                value={from}
                onChange={(_event: DateTimePickerEvent, date?: Date | undefined) => {
                  if (!date) return;
                  setFrom(date);
                  setSingleHalfDayLeaveDetails((prev) => ({ leaveOn: date, leaveIn: prev.leaveIn || null }));
                  validateRegularLeaveFields();
                  computeToDate(date);
                }}
                onError={(error) => setDateTimeSelectionError(error.message)}
                disabled={!selectedLeaveCategory}
                minimumDate={dayjs().startOf('month').toDate()}
                maximumDate={dayjs().endOf('year').toDate()}
                accentColor="#2658A5"
                mode={'date'}
                display="default"
              />
            </Pressable>
          </View>

          <View style={styles.cardItemDivider} />

          <View style={{ flexDirection: 'row', gap: 12, alignItems: 'center', paddingHorizontal: 16 }}>
            <Text style={{ flex: 1, fontSize: 15, lineHeight: 15 * 1.5, color: '#343434', fontWeight: '500' }}>To:</Text>

            <RNDateTimePicker
              value={to}
              onChange={(_event: DateTimePickerEvent, date?: Date | undefined) => {
                if (!date) return;
                setTo(date);
                validateRegularLeaveFields();
              }}
              onError={(error) => setDateTimeSelectionError(error.message)}
              disabled
              minimumDate={undefined}
              accentColor="#2658A5"
              mode={'date'}
              display="default"
              style={{ opacity: 0.5 }}
            />
          </View>
        </View>

        {dateTimeSelectionError ? (
          <Text style={{ fontSize: 14, lineHeight: 14 * 1.5, color: 'tomato', fontWeight: '500', marginLeft: 4 }}>
            {dateTimeSelectionError}
          </Text>
        ) : null}
      </View>

      {Array.from({ length: numberOfHalfDays ?? 0 }).map((_, index) => {
        return (
          <View style={{ gap: 2 }} key={index}>
            <Text style={{ fontSize: 14, lineHeight: 14 * 1.5, color: '#656565', fontWeight: '500', marginLeft: 4 }}>
              {index === 0 ? '1st' : '2nd'} Half day leave details
            </Text>

            <View style={{ gap: 8, backgroundColor: '#efefef', borderRadius: 8, paddingVertical: 8 }}>
              <View style={{ flexDirection: 'row', gap: 12, alignItems: 'center', paddingHorizontal: 16 }}>
                <Text style={{ flex: 1, fontSize: 15, lineHeight: 15 * 1.5, color: '#343434', fontWeight: '500' }}>
                  Leave on:
                </Text>

                <HalfDayLeaveDateMenu
                  dates={
                    numberOfHalfDays === 1 && !(parseInt(numberOfDaysStr.trim()) > 0) ? [from] : [from, to]
                  }
                  disabled={numberOfHalfDays === 2 || !selectedLeaveCategory}
                  onDisabledPress={() => {
                    if (!selectedLeaveCategory) {
                      setLeaveTypeError('Please select a leave type first!');
                    }
                  }}
                  onSelect={(date: Date) => {
                    setSingleHalfDayLeaveDetails((prev) => ({
                      leaveOn: date,
                      leaveIn:
                        parseInt(numberOfDaysStr.trim()) > 0
                          ? date === from
                            ? 'Second-Half'
                            : 'First-Half'
                          : prev.leaveIn || null,
                    }));
                    validateRegularLeaveFields();
                  }}
                  selectedOption={
                    numberOfHalfDays === 2 ? (index === 0 ? from : to) : singleHalfDayLeaveDetails.leaveOn
                  }
                />
              </View>

              <View style={styles.cardItemDivider} />

              <View style={{ flexDirection: 'row', gap: 12, alignItems: 'center', paddingHorizontal: 16, minHeight: 38 }}>
                <Text style={{ flex: 1, fontSize: 15, lineHeight: 15 * 1.5, color: '#343434', fontWeight: '500' }}>
                  Leave in:
                </Text>

                <HalfDayLeaveTypeMenu
                  disabled={numberOfHalfDays === 2 || parseInt(numberOfDaysStr.trim()) > 0}
                  onSelect={(leaveIn) => {
                    setSingleHalfDayLeaveDetails((prev) => ({ leaveOn: prev.leaveOn, leaveIn }));
                    setSingleHalfDayLeaveError('');
                  }}
                  selectedOption={
                    numberOfHalfDays === 2
                      ? index === 0
                        ? 'Second-Half'
                        : 'First-Half'
                      : singleHalfDayLeaveDetails.leaveIn
                  }
                />
              </View>
            </View>

            {singleHalfDayLeaveError || numberOfHalfDays === 2 ? (
              <Text
                style={{
                  fontSize: numberOfHalfDays === 2 ? 12 : 14,
                  lineHeight: 14 * 1.5,
                  color: singleHalfDayLeaveError ? 'tomato' : '#565656',
                  fontWeight: '500',
                  marginLeft: 4,
                }}
              >
                {singleHalfDayLeaveError || '* fields auto-filled based on given half days count'}
              </Text>
            ) : null}
          </View>
        );
      })}

      <CommonFields />
    </React.Fragment>
  );
};

const styles = StyleSheet.create({
  cardItemDivider: { height: StyleSheet.hairlineWidth, marginLeft: 16, backgroundColor: '#343434' },
});

export const NewLeave = React.memo(NewLeaveImpl);
