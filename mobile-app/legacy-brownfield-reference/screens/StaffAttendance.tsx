import React from "react";
import dayjs from "dayjs";
import customParseFormat from "dayjs/plugin/customParseFormat";
import {
  Image,
  Modal,
  Platform,
  StatusBar,
  StyleSheet,
  TouchableOpacity,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import type { Theme } from "react-native-calendars/src/types";

import type { StaffAttendanceParams } from "../types";
import { Header } from "../components/Header/Header";
import { CalendarListWrapper } from "../components/StaffAttendance/CalendarListWrapper";
import { DayTimelineModalContent } from "../components/StaffAttendance/DayTimelineModalContent";
import { NewEventModalContent } from "../components/StaffAttendance/NewEventModalContent/NewEventModalContent";
import type { Event } from "react-native-calendars/src/timeline/EventBlock";
import { LeaveRequestsModalContent } from "../components/StaffAttendance/LeaveRequestsModalContent";
import { LeaveApprovalModalContent } from "../components/StaffAttendance/LeaveApprovalModalContent";
import { useNewStaffApplicationStore } from "../stores/new-staff-application-store";

dayjs.extend(customParseFormat);

export type StaffAttendanceProps = {
  params?: StaffAttendanceParams;
};

const _StaffAttendance = ({ params }: StaffAttendanceProps) => {
  const isDarkMode = false;
  const backgroundStyle = {
    backgroundColor: isDarkMode ? "#000000" : "#ffffff",
  };

  const [newEventModalVisible, setNewEventModalVisible] = React.useState(false);
  const [modalVisible, setModalVisible] = React.useState(false);
  const [leaveRequestsModalVisible, setLeaveRequestsModalVisible] = React.useState(false);
  const [leaveApprovalModalVisible, setLeaveApprovalModalVisible] = React.useState(false);
  const [modalData, setModalData] = React.useState<{
    date: string; // format = YYYY-MM-DD
    events: Event[];
  } | null>(null);

  const resetNewEventStore = useNewStaffApplicationStore.getState().resetAllSlices;

  const modalDismissedHandler = React.useCallback(() => setModalData(null), []);

  const closeModal = React.useCallback(() => setModalVisible(false), []);

  const closeNewEventModal = React.useCallback(() => {
    setNewEventModalVisible(false);
    resetNewEventStore();
  }, []);

  const closeLeaveRequestsModal = React.useCallback(() => {
    setLeaveRequestsModalVisible(false);
  }, []);

  const closeLeaveApprovalModal = React.useCallback(() => {
    setLeaveApprovalModalVisible(false);
  }, []);

  const dayPressHandler = React.useCallback((date: string, events: Event[]) => {
    setModalVisible(true);
    setModalData({ date, events });
  }, []);

  return (
    <SafeAreaView style={styles.container} edges={["top", "left", "right"]}>
      <StatusBar
        barStyle={isDarkMode ? "light-content" : "dark-content"}
        backgroundColor={backgroundStyle.backgroundColor}
      />

      <Header
        title={"My Attendance"}
        rightComponent={
          <View
            style={{
              flex: 1,
              gap: 16,
              flexDirection: "row",
              alignItems: "center",
              justifyContent: "flex-end",
            }}
          >
            <TouchableOpacity
              onPress={() => {
                setNewEventModalVisible(true);
              }}
            >
              <Image
                source={require("../assets/ic_plus.png")}
                style={{ width: 26, height: 26, resizeMode: "contain" }}
              />
            </TouchableOpacity>

            <TouchableOpacity
              onPress={() => {
                setLeaveRequestsModalVisible(true);
              }}
            >
              <Image
                source={require("../assets/ic_list_bullet.png")}
                style={{ width: 22, height: 22, resizeMode: "contain" }}
              />
            </TouchableOpacity>

            <TouchableOpacity
              onPress={() => {
                setLeaveApprovalModalVisible(true);
              }}
            >
              <Image
                source={require("../assets/ic_person_circle_checkmark.png")}
                style={{ width: 30, height: 30, resizeMode: "contain" }}
              />
            </TouchableOpacity>
          </View>
        }
      />

      <View style={styles.content}>
        <CalendarListWrapper params={params} onDayPress={dayPressHandler} />

        <Modal
          animationType="slide"
          transparent={Platform.OS !== "ios"}
          visible={modalVisible}
          presentationStyle={Platform.OS === "ios" ? "pageSheet" : undefined}
          onDismiss={modalDismissedHandler}
          onRequestClose={closeModal}
          statusBarTranslucent={false}
        >
          {modalData ? (
            <DayTimelineModalContent
              date={modalData.date}
              events={modalData.events}
              closeModal={closeModal}
            />
          ) : null}
        </Modal>

        <Modal
          animationType="slide"
          transparent={Platform.OS !== "ios"}
          visible={newEventModalVisible}
          presentationStyle={Platform.OS === "ios" ? "pageSheet" : undefined}
          onRequestClose={closeNewEventModal}
          statusBarTranslucent={false}
        >
          <NewEventModalContent closeModal={closeNewEventModal} params={params} />
        </Modal>

        <Modal
          animationType="slide"
          transparent={Platform.OS !== "ios"}
          visible={leaveRequestsModalVisible}
          presentationStyle={Platform.OS === "ios" ? "pageSheet" : undefined}
          onRequestClose={closeLeaveRequestsModal}
          statusBarTranslucent={false}
        >
          <LeaveRequestsModalContent closeModal={closeLeaveRequestsModal} params={params} />
        </Modal>

        <Modal
          animationType="slide"
          transparent={Platform.OS !== "ios"}
          visible={leaveApprovalModalVisible}
          presentationStyle={Platform.OS === "ios" ? "pageSheet" : undefined}
          onRequestClose={closeLeaveApprovalModal}
          statusBarTranslucent={false}
        >
          <LeaveApprovalModalContent closeModal={closeLeaveApprovalModal} params={params} />
        </Modal>
      </View>
    </SafeAreaView>
  );
};

export const StaffAttendance = React.memo(_StaffAttendance);

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#ffffff",
  },
  content: {
    flex: 1,
    backgroundColor: "#efefef",
  },
});

const calendarProviderTheme: Theme = {
  todayButtonTextColor: "#5589d8",
};
