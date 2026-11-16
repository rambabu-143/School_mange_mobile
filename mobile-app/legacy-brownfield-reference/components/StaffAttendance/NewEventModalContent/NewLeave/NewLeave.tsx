import * as React from "react";
import {
  LayoutAnimation,
  Pressable,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import dayjs from "dayjs";
import { trigger } from "react-native-haptic-feedback";
import type { DateTimePickerEvent } from "@react-native-community/datetimepicker";

import RNDateTimePicker from "../../../DateTimePicker/DateTimePicker";
import { LeaveTypeMenu } from "../../LeaveTypeMenu";
import { HalfDaySelectionMenu } from "../../HalfDaySelectionMenu";
import { HalfDayLeaveTypeMenu } from "../../HalfDayLeaveTypeMenu";
import { HalfDayLeaveDateMenu } from "../../HalfDayLeaveDateMenu";
import { useNewStaffApplicationStore } from "../../../../stores/new-staff-application-store";
import type { StaffLeaveDetails } from "../../../../queries/useStaffLeaveBalancesQuery";
import type { StaffAttendanceParams } from "../../../../types";
import { useValidateFields } from "../hooks/useValidateFields";
import { CommonFields } from "../CommonFields";

export type NewLeaveProps = { params?: StaffAttendanceParams };

const _NewLeave: React.FC<NewLeaveProps> = ({ params }) => {
  const selectedLeaveCategory = useNewStaffApplicationStore(
    (state) => state.selectedLeaveCategory
  );
  const setSelectedLeaveCategory =
    useNewStaffApplicationStore.getState().setSelectedLeaveCategory;
  const leaveTypeError = useNewStaffApplicationStore(
    (state) => state.leaveTypeError
  );
  const setLeaveTypeError =
    useNewStaffApplicationStore.getState().setLeaveTypeError;
  const numberOfHalfDays = useNewStaffApplicationStore(
    (state) => state.numberOfHalfDays
  );
  const setNumberOfHalfDays =
    useNewStaffApplicationStore.getState().setNumberOfHalfDays;
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
  const singleHalfDayLeaveError = useNewStaffApplicationStore(
    (state) => state.singleHalfDayLeaveError
  );
  const setSingleHalfDayLeaveError =
    useNewStaffApplicationStore.getState().setSingleHalfDayLeaveError;
  const singleHalfDayLeaveDetails = useNewStaffApplicationStore(
    (state) => state.singleHalfDayLeaveDetails
  );
  const setSingleHalfDayLeaveDetails =
    useNewStaffApplicationStore.getState().setSingleHalfDayLeaveDetails;

  const { validateRegularLeaveFields } = useValidateFields();

  const handleLeaveTypeSelect = React.useCallback(
    (option: StaffLeaveDetails) => {
      setSelectedLeaveCategory(option);
      setLeaveTypeError("");
      if (option.is_half_day_applicable === "No") {
        setNumberOfHalfDays(0);
        setSingleHalfDayLeaveDetails({ leaveOn: from, leaveIn: null });
        computeToDate(null, 0);
      }
    },
    []
  );

  const computeToDate = (fromDate?: Date | null, halfDays?: number | null) => {
    const numOfDaysInt = parseInt(numberOfDaysStr.trim());
    const numOfFullDays = isNaN(numOfDaysInt) ? 0 : numOfDaysInt;
    const numOfHalfDays = halfDays ?? numberOfHalfDays ?? 0;

    const totalDays = numOfFullDays + numOfHalfDays - 1;

    const fromDateFinal = fromDate || from;
    let fromDayjs = dayjs(fromDateFinal);
    if (totalDays >= 1) {
      fromDayjs = fromDayjs.add(totalDays, "days");
    }
    const toDateFinal = fromDayjs.toDate();
    setTo(toDateFinal);

    if (numOfFullDays > 0) {
      setSingleHalfDayLeaveDetails((prev) => {
        const leaveOn =
          prev.leaveOn === fromDateFinal || prev.leaveOn === toDateFinal
            ? prev.leaveOn
            : fromDateFinal;
        return {
          leaveIn: leaveOn === fromDateFinal ? "Second-Half" : "First-Half",
          leaveOn,
        };
      });
    } else {
      setSingleHalfDayLeaveDetails({
        leaveIn: null,
        leaveOn: fromDateFinal,
      });
    }
  };

  const onNumberOfDaysBlur = () => {
    validateRegularLeaveFields();

    computeToDate();
  };

  return (
    <React.Fragment>
      {/* Leave Type Selection */}
      <View style={{ gap: 2 }}>
        <View style={{ backgroundColor: "#efefef", borderRadius: 8 }}>
          <View
            style={{
              flexDirection: "row",
              gap: 24,
              padding: 16,
              alignItems: "flex-start",
              justifyContent: "space-between",
            }}
          >
            <Text
              style={{
                flex: 1,
                fontSize: 15,
                lineHeight: 15 * 1.5,
                fontWeight: "500",
                fontFamily: "Georgia.ttf",
                color: "#343434",
              }}
            >
              Leave Type:
            </Text>

            <LeaveTypeMenu
              params={params}
              selectedOption={selectedLeaveCategory}
              onSelect={handleLeaveTypeSelect}
            />
          </View>
        </View>

        {leaveTypeError ? (
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
            {leaveTypeError}
          </Text>
        ) : null}
      </View>

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
          {/* Number of half days leave selector */}
          {selectedLeaveCategory !== null &&
          selectedLeaveCategory.is_half_day_applicable === "Yes" ? (
            <>
              <View
                style={{
                  flexDirection: "row",
                  gap: 12,
                  minHeight: 38,
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
                  No. of half days:
                </Text>

                <HalfDaySelectionMenu
                  selectedOption={numberOfHalfDays}
                  onSelect={(value) => {
                    setNumberOfHalfDays(value);
                    if (value > 0) {
                      setNumberOfDaysStr((value) =>
                        isNaN(parseInt(value)) ? "0" : value
                      );
                    }
                    computeToDate(null, value);
                    setSingleHalfDayLeaveError("");
                    setDateTimeSelectionError("");
                    trigger("impactLight");
                    LayoutAnimation.configureNext(
                      LayoutAnimation.Presets.easeInEaseOut
                    );
                  }}
                  disabled={!selectedLeaveCategory}
                  onDisabledPress={() => {
                    if (!selectedLeaveCategory) {
                      setLeaveTypeError("Please select a leave type first!");
                      return;
                    }
                  }}
                />
              </View>

              <View style={styles.cardItemDivider} />
            </>
          ) : null}

          {/* Number of full days leave selector */}
          <View
            style={{
              flexDirection: "row",
              gap: 12,
              alignItems: "center",
              paddingHorizontal: 16,
              minHeight: 38,
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
              No. of full days:
            </Text>

            {!!selectedLeaveCategory ? (
              <TextInput
                style={{
                  paddingTop: 0,
                  fontSize: 17,
                  lineHeight: 17 * 1.5,
                  fontFamily: "Georgia.ttf",
                  height: 36,
                  paddingVertical: 4,
                }}
                value={numberOfDaysStr}
                editable={!!selectedLeaveCategory}
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
            ) : (
              <TouchableOpacity
                disabled={!!selectedLeaveCategory}
                activeOpacity={1}
                onPress={() => {
                  if (!selectedLeaveCategory) {
                    setLeaveTypeError("Please select a leave type first!");
                    return;
                  }
                }}
              >
                <Text
                  style={{
                    // height: 36,
                    fontSize: 17,
                    lineHeight: 17 * 1.5,
                    color: "#9a9a9a",
                    fontFamily: "Georgia.ttf",
                    textAlign: "right",
                  }}
                  numberOfLines={1}
                >
                  # Days
                </Text>
              </TouchableOpacity>
            )}
          </View>

          <View style={styles.cardItemDivider} />

          {/* Total number of days selected leaves */}
          <View
            style={{
              flexDirection: "row",
              gap: 12,
              alignItems: "center",
              minHeight: 38,
              paddingLeft: 28,
              paddingRight: 16,
            }}
          >
            <Text
              style={{
                flex: 1,
                fontSize: 16,
                lineHeight: 16 * 1.5,
                color: "#727272",
                fontWeight: "500",
                fontFamily: "Georgia.ttf",
              }}
            >
              Total no. of days:
            </Text>

            <Text
              style={{
                fontSize: 17,
                lineHeight: 17 * 1.5,
                color: "#727272",
                fontWeight: "500",
                fontFamily: "Georgia.ttf",
                textAlign: "right",
              }}
              numberOfLines={1}
            >
              {(numberOfDaysStr.trim().length > 0
                ? parseInt(numberOfDaysStr.trim(), 10)
                : 0) + (numberOfHalfDays ? numberOfHalfDays / 2 : 0)}
            </Text>
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

            <Pressable
              onPress={() => {
                if (!selectedLeaveCategory) {
                  setLeaveTypeError("Please select a leave type first!");
                  return;
                }
              }}
            >
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
                  setSingleHalfDayLeaveDetails((prev) => ({
                    leaveOn: date,
                    leaveIn: prev.leaveIn || null,
                  }));
                  validateRegularLeaveFields();
                  // set to date as per number of days and from date
                  computeToDate(date);
                }}
                onError={(error) => setDateTimeSelectionError(error.message)}
                disabled={!selectedLeaveCategory}
                minimumDate={dayjs().startOf("month").toDate()}
                maximumDate={dayjs().endOf("year").toDate()}
                accentColor="#2658A5"
                mode={"date"}
                display="default"
              />
            </Pressable>
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
              value={to}
              onChange={(
                _event: DateTimePickerEvent,
                date?: Date | undefined
              ) => {
                if (!date) {
                  return;
                }
                setTo(date);
                validateRegularLeaveFields();
              }}
              onError={(error) => setDateTimeSelectionError(error.message)}
              disabled={true}
              minimumDate={undefined}
              accentColor="#2658A5"
              mode={"date"}
              display="default"
              style={{
                opacity: 0.5,
              }}
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

      {/* Half Days date selection */}
      {Array.from({ length: numberOfHalfDays ?? 0 }).map((_, index) => {
        return (
          <View style={{ gap: 2 }} key={index}>
            <Text
              style={{
                fontSize: 14,
                lineHeight: 14 * 1.5,
                color: "#656565",
                fontWeight: "500",
                marginLeft: 4,
                fontFamily: "Georgia.ttf",
              }}
            >
              {index === 0 ? "1st" : "2nd"} Half day leave details
            </Text>

            <View
              style={{
                gap: 8,
                backgroundColor: "#efefef",
                borderRadius: 8,
                paddingVertical: 8,
              }}
            >
              {/* Half day on Date Selector */}
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
                  Leave on:
                </Text>

                <HalfDayLeaveDateMenu
                  dates={
                    numberOfHalfDays === 1 &&
                    !(parseInt(numberOfDaysStr.trim()) > 0)
                      ? [from]
                      : [from, to]
                  }
                  disabled={numberOfHalfDays === 2 || !selectedLeaveCategory}
                  onDisabledPress={() => {
                    if (!selectedLeaveCategory) {
                      setLeaveTypeError("Please select a leave type first!");
                      return;
                    }
                  }}
                  onSelect={(date: Date) => {
                    setSingleHalfDayLeaveDetails((prev) => ({
                      leaveOn: date,
                      leaveIn:
                        parseInt(numberOfDaysStr.trim()) > 0
                          ? date === from
                            ? "Second-Half"
                            : "First-Half"
                          : prev.leaveIn || null,
                    }));
                    validateRegularLeaveFields();
                  }}
                  selectedOption={
                    numberOfHalfDays === 2
                      ? index === 0
                        ? from
                        : to
                      : singleHalfDayLeaveDetails.leaveOn
                  }
                />
              </View>

              <View style={styles.cardItemDivider} />

              {/* Half day type selector */}
              <View
                style={{
                  flexDirection: "row",
                  gap: 12,
                  alignItems: "center",
                  paddingHorizontal: 16,
                  minHeight: 38,
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
                  Leave in:
                </Text>

                <HalfDayLeaveTypeMenu
                  disabled={
                    numberOfHalfDays === 2 ||
                    parseInt(numberOfDaysStr.trim()) > 0
                  }
                  onSelect={(leaveIn) => {
                    setSingleHalfDayLeaveDetails((prev) => ({
                      leaveOn: prev.leaveOn,
                      leaveIn,
                    }));
                    setSingleHalfDayLeaveError("");
                  }}
                  selectedOption={
                    numberOfHalfDays === 2
                      ? index === 0
                        ? "Second-Half"
                        : "First-Half"
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
                  color: singleHalfDayLeaveError ? "tomato" : "#565656",
                  fontWeight: "500",
                  marginLeft: 4,
                  fontFamily: "Georgia.ttf",
                }}
              >
                {singleHalfDayLeaveError ||
                  "* fields auto-filled based on given half days count"}
              </Text>
            ) : null}
          </View>
        );
      })}

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

export const NewLeave = React.memo(_NewLeave);
