import * as React from "react";
import dayjs from "dayjs";
import { StyleSheet, Text, TextInput, View } from "react-native";
import { DateTimePickerEvent } from "@react-native-community/datetimepicker";

import RNDateTimePicker from "../../../DateTimePicker/DateTimePicker";
import type { StaffAttendanceParams } from "../../../../types";
import { CommonFields } from "../CommonFields";
import { useNewStaffApplicationStore } from "../../../../stores/new-staff-application-store";
import { useValidateFields } from "../hooks/useValidateFields";

export type NewODLeaveProps = { params?: StaffAttendanceParams };

const _NewODLeave: React.FC<NewODLeaveProps> = ({ params }) => {
  const numberOfDaysStr = useNewStaffApplicationStore(
    (state) => state.numberOfDaysStr
  );
  const setNumberOfDaysStr =
    useNewStaffApplicationStore.getState().setNumberOfDaysStr;
  const to = useNewStaffApplicationStore((state) => state.to);
  const setTo = useNewStaffApplicationStore.getState().setTo;
  const from = useNewStaffApplicationStore((state) => state.from);
  const setFrom = useNewStaffApplicationStore.getState().setFrom;
  const dateTimeSelectionError = useNewStaffApplicationStore(
    (state) => state.dateTimeSelectionError
  );
  const setDateTimeSelectionError =
    useNewStaffApplicationStore.getState().setDateTimeSelectionError;

  const { validateODLeaveFields } = useValidateFields();

  const computeToDate = (fromDate?: Date | null) => {
    const numOfDaysInt = parseInt(numberOfDaysStr.trim());
    const numOfFullDays = isNaN(numOfDaysInt) ? 0 : numOfDaysInt;

    const fromDateFinal = fromDate || from;
    let fromDayjs = dayjs(fromDateFinal);

    if (numOfFullDays >= 1) {
      fromDayjs = fromDayjs.add(numOfFullDays - 1, "days");
    }
    const toDateFinal = fromDayjs.toDate();
    setTo(toDateFinal);
  };

  const onNumberOfDaysBlur = () => {
    validateODLeaveFields();
    computeToDate();
  };

  return (
    <React.Fragment>
      {/* Date Selection */}
      <View style={styles.cardContainer}>
        <View style={styles.card}>
          {/* Number of days leave selector */}
          <View
            style={{
              ...styles.cardItem,
              minHeight: 38,
            }}
          >
            <Text style={styles.label}>No. of days:</Text>

            <TextInput
              style={styles.fullDaysInput}
              value={numberOfDaysStr}
              placeholderTextColor={"#9a9a9a"}
              placeholder="# Days"
              onChangeText={(text) => {
                setNumberOfDaysStr(text.replace(/[^0-9]/g, ""));
                setDateTimeSelectionError("");
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
              selectTextOnFocus={true}
              textAlign="right"
            />
          </View>

          <View style={styles.cardItemDivider} />

          {/* From Date/Time Selector */}
          <View style={styles.cardItem}>
            <Text style={styles.label}>From:</Text>

            <RNDateTimePicker
              value={from}
              onChange={(
                _event: DateTimePickerEvent,
                date?: Date | undefined
              ) => {
                if (!date) {
                  return;
                }
                setFrom(date);
                validateODLeaveFields();
                // set to date as per number of days and from date
                computeToDate(date);
              }}
              onError={(error) => setDateTimeSelectionError(error.message)}
              minimumDate={dayjs().startOf("month").toDate()}
              maximumDate={dayjs().endOf("year").toDate()}
              accentColor="#2658A5"
              mode={"date"}
              display="default"
            />
          </View>

          <View style={styles.cardItemDivider} />

          {/* To Date/Time Selector */}
          <View style={styles.cardItem}>
            <Text style={styles.label}>To:</Text>

            <RNDateTimePicker
              value={to}
              // onChange={(
              //   _event: DateTimePickerEvent,
              //   date?: Date | undefined
              // ) => {
              //   if (!date) {
              //     return;
              //   }
              //   setTo(date);
              //   validateODLeaveFields();
              // }}
              onError={(error) => setDateTimeSelectionError(error.message)}
              disabled={true}
              minimumDate={undefined}
              accentColor="#2658A5"
              mode={"date"}
              display="default"
              style={styles.disabledTextInput}
            />
          </View>
        </View>

        {dateTimeSelectionError ? (
          <Text style={styles.errorText}>{dateTimeSelectionError}</Text>
        ) : null}
      </View>

      <CommonFields params={params} />
    </React.Fragment>
  );
};

const styles = StyleSheet.create({
  cardContainer: {
    gap: 2,
  },
  card: {
    gap: 8,
    backgroundColor: "#efefef",
    borderRadius: 8,
    paddingVertical: 8,
  },
  cardItem: {
    flexDirection: "row",
    gap: 12,
    alignItems: "center",
    paddingHorizontal: 16,
  },
  fullDaysInput: {
    paddingTop: 0,
    fontSize: 17,
    lineHeight: 17 * 1.5,
    fontFamily: "Georgia.ttf",
    height: 36,
    paddingVertical: 4,
  },
  label: {
    flex: 1,
    fontSize: 15,
    lineHeight: 15 * 1.5,
    color: "#343434",
    fontWeight: "500",
    fontFamily: "Georgia.ttf",
  },
  cardItemDivider: {
    height: StyleSheet.hairlineWidth,
    // flexBasis: "100%",
    marginLeft: 16,
    backgroundColor: "#343434",
  },
  errorText: {
    fontSize: 14,
    lineHeight: 14 * 1.5,
    color: "tomato",
    fontWeight: "500",
    marginLeft: 4,
    fontFamily: "Georgia.ttf",
  },
  disabledTextInput: {
    opacity: 0.5,
  },
});

export const NewODLeave = React.memo(_NewODLeave);
