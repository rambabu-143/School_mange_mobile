import * as React from "react";
import dayjs from "dayjs";
import {
  Image,
  StyleProp,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  ViewStyle,
  Animated,
  useAnimatedValue,
  Easing,
  LayoutAnimation,
  Platform,
  ActionSheetIOS,
  Alert,
} from "react-native";
import RNHapticFeedback from "react-native-haptic-feedback";

import { Card } from "../Card";
import { LeaveAssessor } from "./LeaveAssessor";
import type { StaffLeaveRequest } from "../../queries/useStaffLeaveRequestsQuery";
import { LeaveFromToDateTimeView } from "./LeaveFromToDateTimeView";
import { LeaveRequestDetailsTrigger } from "./LeaveRequestDetailsTrigger";
import { LeaveRequestDetails } from "./LeaveRequestDetails";

export type LeaveRequestCardProps = {
  style?: StyleProp<ViewStyle>;
  data: StaffLeaveRequest;
  onDeletePress?: (leaveRequest: StaffLeaveRequest) => void;
};

const _LeaveRequestCard: React.FC<LeaveRequestCardProps> = ({
  style,
  data,
  onDeletePress,
}) => {
  const [expanded, setExpanded] = React.useState(false);
  const [assessorsViewExpanded, setAssessorsViewExpanded] =
    React.useState(false);
  const expandedValue = useAnimatedValue(0);

  const assessors = data.assessor;
  const currentAssessor = assessors?.find(
    (assessor) => {
      const assessorStatus = assessor.status?.toLowerCase?.() || "";
      return ["pending", "rejected"].includes(assessorStatus);
    }
  );
  const isRejected = ["rejected", "not-approved"].includes(data.status?.toLowerCase?.() || "");
  const isPending = data.status?.toLowerCase?.() === "pending";

  const deleteRequest = () => {
    onDeletePress?.(data);
  };

  const handleDeleteRequestPress = () => {
    const from =
      data.leave_type === "SHORT-LEAVE"
        ? dayjs(data.from_time, "HH:mm").format("h:mm a")
        : dayjs(data.from_date).format("DD MMM YYYY");

    const to =
      data.leave_type === "SHORT-LEAVE"
        ? dayjs(data.to_time, "HH:mm").format("h:mm a")
        : dayjs(data.to_date).format("DD MMM YYYY");

    const message = `Are you sure you want to delete your ${
      data.leave_type === "SHORT-LEAVE" ? "short" : data.leave_type === "CO" ? "CO" : data.leave_type === "OD" ? "OD" : ""
    } leave request from ${from} to ${to}${
      data.leave_type === "SHORT-LEAVE"
        ? " on " + dayjs(data.from_date).format("DD MMM YYYY")
        : ""
    }?`;

    if (Platform.OS === "ios") {
      ActionSheetIOS.showActionSheetWithOptions(
        {
          options: ["Cancel", "Delete"],
          cancelButtonIndex: 0,
          destructiveButtonIndex: 1,
          title: "Delete Confirmation!",
          message,
          userInterfaceStyle: "light",
          tintColor: "#787878",
        },
        (buttonIndex) => {
          if (buttonIndex === 1) {
            deleteRequest();
          }
          if (buttonIndex === 0) {
            // Do nothing
          }
        }
      );
    } else {
      Alert.alert(
        "Delete Confirmation!",
        message,
        [
          {
            text: "Cancel",
            style: "cancel",
          },
          {
            text: "Delete",
            style: "destructive",
            onPress: () => deleteRequest(),
          },
        ],
        {
          cancelable: true,
          userInterfaceStyle: "light",
        }
      );
    }
  };

  const handleDetailsPress = () => {
    expandedValue.stopAnimation();

    Animated.timing(expandedValue, {
      toValue: !expanded ? 1 : 0,
      useNativeDriver: true,
      duration: 300,
      isInteraction: true,
      easing: Easing.linear,
    }).start();

    setExpanded(!expanded);
  };

  return (
    <Card style={StyleSheet.flatten([styles.container, style])}>
      <View
        style={{
          flexDirection: "row",
          alignItems: "flex-start",
          justifyContent: "space-between",
        }}
      >
        <View style={{ gap: 8, flex: 1 }}>
          <View style={{ flexDirection: "row", alignItems: "center", gap: 4 }}>
            <Image
              source={require("../../assets/ic_calendar_clock.png")}
              style={{ width: 20, height: 20, resizeMode: "contain" }}
            />
            <Text style={styles.smallText}>
              Submitted on {dayjs(data.created_at).format("DD MMM YYYY")}
            </Text>
          </View>

          {data.leave_type === "LEAVE" ? (
            <Text style={styles.label}>
              Leave Type: <Text style={styles.text}>{data.leave_id?.leave_name}</Text>
            </Text>
          ) : null}
        </View>

        {isPending ? (
          <TouchableOpacity
            style={{
              height: 28,
              width: 28,
              alignItems: "center",
              justifyContent: "center",
            }}
            onPress={handleDeleteRequestPress}
          >
            <Image
              source={require("../../assets/ic_trash.png")}
              style={{ width: 22, height: 22, resizeMode: "contain" }}
            />
          </TouchableOpacity>
        ) : (
          <View
            style={[
              { paddingVertical: 2, paddingHorizontal: 6, borderRadius: 4 },
              { backgroundColor: isRejected ? "#FDECEA" : "#E6F4EA" },
            ]}
          >
            <Text
              style={[
                styles.smallText,
                {
                  fontWeight: "500",
                  color: isRejected ? "#D93025" : "#34A853",
                  textTransform: "capitalize",
                },
              ]}
            >
              {isRejected ? "Not Approved" : "Approved"}
            </Text>
          </View>
        )}
      </View>

      <LeaveFromToDateTimeView data={data} />

      <View
        style={{
          flex: 1,
          flexDirection: "row",
          alignItems: "flex-end",
          gap: 32,
        }}
      >
        {isPending || isRejected ? (
          <View style={{ flex: 1, gap: 2 }}>
            <Text style={styles.label}>Application at:</Text>

            <View style={{ flexDirection: "row" }}>
              <View
                style={{
                  width: 1.5,
                  backgroundColor: "#bababa",
                  marginBottom: 12,
                }}
              />

              <View
                style={{
                  flexDirection: "column",
                  flex: 1,
                }}
              >
                {assessorsViewExpanded ? (
                  <>
                    {assessors?.map((assessor) => {
                      return (
                        <LeaveAssessor
                          key={assessor._id}
                          data={assessor}
                        />
                      );
                    })}
                  </>
                ) : currentAssessor ? (
                  <LeaveAssessor
                    key={currentAssessor._id}
                    data={currentAssessor}
                  />
                ) : null}

                {Array.isArray(assessors) && assessors.length > 1 ? (
                  <TouchableOpacity
                    style={{
                      flexDirection: "row",
                      marginLeft: 8,
                      alignItems: "baseline",
                      gap: 4,
                    }}
                    onPress={() => {
                      LayoutAnimation.configureNext(
                        LayoutAnimation.Presets.easeInEaseOut
                      );
                      setAssessorsViewExpanded((state) => !state);
                      RNHapticFeedback.trigger("soft");
                    }}
                  >
                    <Text
                      style={[
                        styles.smallText,
                        {
                          textDecorationLine: "underline",
                          textDecorationStyle: "dotted",
                        },
                      ]}
                    >
                      view {assessorsViewExpanded ? "less" : "more"}
                    </Text>

                    <Image
                      source={require("../../assets/ic_chevron_down.png")}
                      style={{
                        width: 10,
                        height: 10,
                        resizeMode: "contain",
                        transform: [
                          {
                            rotateZ: assessorsViewExpanded ? "180deg" : "0deg",
                          },
                        ],
                      }}
                    />
                  </TouchableOpacity>
                ) : null}
              </View>
            </View>
          </View>
        ) : (
          <View style={{ flex: 1 }} />
        )}

        <LeaveRequestDetailsTrigger expandedValue={expandedValue} onPress={handleDetailsPress} />
      </View>

      {expanded ? (
        <>
          <View style={styles.divider} />

          <LeaveRequestDetails data={data} />
        </>
      ) : null}
    </Card>
  );
};

const styles = StyleSheet.create({
  container: {
    flexGrow: 1,
    padding: 12,
    gap: 12,
    borderRadius: 8,
    backgroundColor: "#ffffff",

    shadowColor: "#000000",
    shadowRadius: 2,
    shadowOffset: { height: 0.7, width: 0 },
    shadowOpacity: 0.07,
    elevation: 2,
  },
  smallText: {
    fontSize: 14,
    lineHeight: 14 * 1.5,
    fontWeight: "400",
    color: "#323232",
    fontFamily: "Georgia.ttf",
  },
  label: {
    fontSize: 15,
    lineHeight: 15 * 1.5,
    fontWeight: "500",
    color: "#767676",
    fontFamily: "Georgia.ttf",
  },
  text: {
    fontSize: 16,
    lineHeight: 16 * 1.5,
    fontWeight: "400",
    color: "#323232",
    fontFamily: "Georgia.ttf",
  },
  durationText: {
    fontSize: 14,
    lineHeight: 14 * 1.5,
    fontWeight: "500",
    color: "#343434",
    fontFamily: "Georgia.ttf",
  },
  semiBold: {
    fontWeight: "500",
  },
  durationDays: {
    paddingVertical: 4,
    paddingHorizontal: 10,
    borderRadius: 54,
    backgroundColor: "#ffffff",
  },
  divider: {
    flex: 1,
    height: StyleSheet.hairlineWidth,
    backgroundColor: "#343434",
  },
});

export const LeaveRequestCard = React.memo(_LeaveRequestCard);
