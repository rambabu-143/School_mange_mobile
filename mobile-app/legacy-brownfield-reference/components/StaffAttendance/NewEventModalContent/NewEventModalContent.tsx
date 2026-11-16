import * as React from "react";
import { Platform, ScrollView, StyleSheet, View } from "react-native";
import dayjs from "dayjs";
import duration from "dayjs/plugin/duration";
import minMax from "dayjs/plugin/minMax";
import { BlurView } from "@react-native-community/blur";

import { Header } from "./Header";
import { StaffAttendanceParams } from "../../../types";
import { LeaveBalancesTable } from "../LeaveBalancesTable";
import { LeaveSegmentedControl } from "./LeaveSegmentedControl";
import { LeaveScreens } from "./LeaveScreens";
import { useNewStaffApplicationStore } from "../../../stores/new-staff-application-store";

dayjs.extend(duration);
dayjs.extend(minMax);

export type NewEventModalContentProps = {
  closeModal: () => void;
  params?: StaffAttendanceParams;
};

const _NewEventModalContent: React.FC<NewEventModalContentProps> = ({
  params,
  closeModal,
}) => {
  const HeaderContainer = Platform.OS === "ios" ? BlurView : View;

  return (
    <View
      style={{
        flex: 1,
        ...(Platform.OS === "android" ? styles.backdrop : {}),
      }}
    >
      <View
        style={{
          flex: 1,
          ...(Platform.OS === "android" ? styles.content : {}),
        }}
      >
        <HeaderContainer
          style={Platform.OS === "ios" ? styles.iOSHeaderContainer : {}}
          blurType="regular"
        >
          <Header params={params} closeModal={closeModal} />
          <View collapsable={false}>
            <LeaveSegmentedControl />
          </View>
        </HeaderContainer>

        <ScrollView
          keyboardShouldPersistTaps="handled"
          scrollIndicatorInsets={styles.scrollIndicatorInsets}
          contentContainerStyle={styles.scrollContainer}
        >
          <LeaveScreens closeModal={closeModal} params={params} />

          <View style={styles.divider} />

          <LeaveBalancesTable params={params} />
        </ScrollView>
      </View>
    </View>
  );
};

const HEADER_OFFSET = Platform.OS === "ios" ? 92 : 0;

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
  iOSHeaderContainer: {
    position: "absolute",
    width: "100%",
    top: 0,
    zIndex: 100,
  },
  divider: {
    height: StyleSheet.hairlineWidth,
    width: "100%",
    backgroundColor: "#343434",
  },
  scrollIndicatorInsets: {
    top: HEADER_OFFSET + 4,
  },
  scrollContainer: {
    gap: 24,
    paddingHorizontal: 12,
    paddingTop: 16 + HEADER_OFFSET,
    paddingBottom: 48,
  },
});

export const NewEventModalContent = React.memo(_NewEventModalContent);
