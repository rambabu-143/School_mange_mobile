import * as React from "react";
import { StyleSheet, Text, View } from "react-native";
import dayjs from "dayjs";
import minMax from "dayjs/plugin/minMax";
import type { DateTimePickerEvent } from "@react-native-community/datetimepicker";

import RNDateTimePicker from "../../../DateTimePicker/DateTimePicker";
import { useNewStaffApplicationStore } from "../../../../stores/new-staff-application-store";
import type { StaffAttendanceParams } from "../../../../types";
import { CommonFields } from "../CommonFields";

dayjs.extend(minMax);

export type NewShortLeaveProps = { params?: StaffAttendanceParams };

const _NewShortLeave: React.FC<NewShortLeaveProps> = ({ params }) => {
  const shortLeaveDate = useNewStaffApplicationStore(
    (state) => state.shortLeaveDate
  );
  const setShortLeaveDate =
    useNewStaffApplicationStore.getState().setShortLeaveDate;

  const shortLeaveFromTime = useNewStaffApplicationStore(
    (state) => state.shortLeaveFromTime
  );
  const setShortLeaveFromTime =
    useNewStaffApplicationStore.getState().setShortLeaveFromTime;

  const shortLeaveToTime = useNewStaffApplicationStore(
    (state) => state.shortLeaveToTime
  );
  const setShortLeaveToTime =
    useNewStaffApplicationStore.getState().setShortLeaveToTime;

  const dateTimeSelectionError = useNewStaffApplicationStore(
    (state) => state.dateTimeSelectionError
  );
  const setDateTimeSelectionError =
    useNewStaffApplicationStore.getState().setDateTimeSelectionError;

  // Set minimum time for short leave from time to 7:00 AM
  // This is to ensure that short leave cannot be taken before 7:00 AM
  const minShortLeaveFromTime = dayjs(new Date())
    .set("hour", 7)
    .set("minute", 0)
    .set("second", 0)
    .toDate();

  return (
    <React.Fragment>
      {/* Date Selection */}
      <View style={{ gap: 2 }}>
        <View
          style={{
            gap: 8,
            backgroundColor: "#efefef",
            borderRadius: 8,
            paddingVertical: 8,
          }}
        >
          {/* Short leave date selector */}
          <View
            style={{
              flexDirection: "row",
              gap: 12,
              alignItems: "center",
              paddingHorizontal: 16,
            }}
          >
            <Text
              style={{
                flex: 1,
                fontSize: 15,
                lineHeight: 15 * 1.5,
                color: "#343434",
                fontWeight: "500",
                fontFamily: "Georgia.ttf",
              }}
            >
              Date:
            </Text>

            <RNDateTimePicker
              value={shortLeaveDate}
              onChange={(
                _event: DateTimePickerEvent,
                date?: Date | undefined
              ) => {
                if (date) {
                  setShortLeaveDate(date);
                  // TODO: validate date
                  setDateTimeSelectionError("");
                }
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

          {/* From Date/Time Selector */}
          <View
            style={{
              flexDirection: "row",
              gap: 12,
              alignItems: "center",
              paddingHorizontal: 16,
            }}
          >
            <Text
              style={{
                flex: 1,
                fontSize: 15,
                lineHeight: 15 * 1.5,
                color: "#343434",
                fontWeight: "500",
                fontFamily: "Georgia.ttf",
              }}
            >
              From:
            </Text>

            <RNDateTimePicker
              value={shortLeaveFromTime}
              onChange={(
                _event: DateTimePickerEvent,
                date?: Date | undefined
              ) => {
                if (!date) {
                  return;
                }
                setShortLeaveFromTime(date);
                setDateTimeSelectionError("");
              }}
              onError={(error) => setDateTimeSelectionError(error.message)}
              disabled={false}
              minimumDate={minShortLeaveFromTime}
              maximumDate={undefined}
              accentColor="#2658A5"
              mode={"time"}
              display="default"
            />
          </View>

          <View style={styles.cardItemDivider} />

          {/* To Date/Time Selector */}
          <View
            style={{
              flexDirection: "row",
              gap: 12,
              alignItems: "center",
              paddingHorizontal: 16,
            }}
          >
            <Text
              style={{
                flex: 1,
                fontSize: 15,
                lineHeight: 15 * 1.5,
                color: "#343434",
                fontWeight: "500",
                fontFamily: "Georgia.ttf",
              }}
            >
              To:
            </Text>

            <RNDateTimePicker
              value={shortLeaveToTime}
              onChange={(
                _event: DateTimePickerEvent,
                date?: Date | undefined
              ) => {
                if (!date) {
                  return;
                }
                setShortLeaveToTime(date);
                setDateTimeSelectionError("");
              }}
              onError={(error) => setDateTimeSelectionError(error.message)}
              disabled={false}
              minimumDate={dayjs
                .max(dayjs(shortLeaveFromTime), dayjs(minShortLeaveFromTime))
                .toDate()}
              accentColor="#2658A5"
              mode={"time"}
              display="default"
            />
          </View>
        </View>

        {dateTimeSelectionError ? (
          <Text
            style={{
              fontSize: 14,
              lineHeight: 14 * 1.5,
              color: "tomato",
              fontWeight: "500",
              marginLeft: 4,
              fontFamily: "Georgia.ttf",
            }}
          >
            {dateTimeSelectionError}
          </Text>
        ) : null}
      </View>

      <CommonFields params={params} />
    </React.Fragment>
  );
};

const styles = StyleSheet.create({
  backdrop: {
    paddingTop: 44,
    backgroundColor: "rgba(34, 34, 34, 0.6)", // dimming background
    justifyContent: "flex-end",
  },
  content: {
    borderTopRightRadius: 16,
    borderTopLeftRadius: 16,
    overflow: "hidden",
    backgroundColor: "#fff",
  },
  divider: {
    height: StyleSheet.hairlineWidth,
    width: "100%",
    backgroundColor: "#343434",
  },
  cardItemDivider: {
    height: StyleSheet.hairlineWidth,
    // flexBasis: "100%",
    marginLeft: 16,
    backgroundColor: "#343434",
  },
});

export const NewShortLeave = React.memo(_NewShortLeave);
