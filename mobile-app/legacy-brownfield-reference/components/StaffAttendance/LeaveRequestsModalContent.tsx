import * as React from "react";
import {
  ActivityIndicator,
  Alert,
  FlatList,
  Image,
  ListRenderItem,
  Platform,
  RefreshControl,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import dayjs from "dayjs";
import duration from "dayjs/plugin/duration";
import SegmentedControl from "@react-native-segmented-control/segmented-control";

import { StaffAttendanceParams } from "../../types";
import {
  StaffLeaveRequest,
  useStaffLeaveRequestsQuery,
} from "../../queries/useStaffLeaveRequestsQuery";
import { LeaveRequestCard } from "./LeaveRequestCard";
import { YearSelectMenu } from "./YearSelectMenu";
import { useDeleteLeaveRequestMutation } from "../../queries/useDeleteLeaveRequestMutation";

dayjs.extend(duration);

export type NewEventModalContentProps = {
  closeModal: () => void;
  params?: StaffAttendanceParams;
};

const _LeaveRequestsModalContent: React.FC<NewEventModalContentProps> = ({
  params,
  closeModal,
}) => {
  const leaveTypes = [
    {
      id: "regular-leave",
      label: "Leave",
    },
    {
      id: "short-leave",
      label: "Short",
    },
    {
      id: "co",
      label: "CO",
    },
    {
      id: "od",
      label: "OD",
    },
  ];
  const [selectedLeaveType, setSelectedLeaveType] = React.useState(() =>
    leaveTypes.find((leaveType) => leaveType.id === "regular-leave")
  );
  const [selectedYear, setSelectedYear] = React.useState(
    dayjs().format("YYYY")
  );

  const selectedLeaveTypeId = selectedLeaveType?.id;

  const leaveCategory =
    selectedLeaveTypeId === "regular-leave"
      ? "LEAVE"
      : selectedLeaveTypeId === "short-leave"
      ? "SHORT-LEAVE"
      : selectedLeaveTypeId === "co"
      ? "CO"
      : "OD";

  const staffLeaveRequestsQuery = useStaffLeaveRequestsQuery(
    leaveCategory,
    selectedYear,
    params
  );
  const deleteLeaveRequestMutation = useDeleteLeaveRequestMutation(params);

  const requestBeingDeleted =
    deleteLeaveRequestMutation.isPending &&
    deleteLeaveRequestMutation.variables?._id;

  const handleLeaveRequestDelete = React.useCallback(
    async (request: StaffLeaveRequest) => {
      try {
        await deleteLeaveRequestMutation.mutateAsync(request);
        Alert.alert("Success", "Leave request has been deleted successfully!", [{ text: "dismiss", style: 'default' }]);
      } catch (error) {
        Alert.alert("Error", error?.message || 'An error occurred', [{ text: "dismiss", style: 'default' }]);
      }
    },
    [deleteLeaveRequestMutation]
  );

  const _renderItem: ListRenderItem<StaffLeaveRequest> = React.useCallback(
    ({ item }) => {
      return (
        <LeaveRequestCard
          data={item}
          onDeletePress={handleLeaveRequestDelete}
          style={{ opacity: requestBeingDeleted === item._id ? 0.3 : 1 }}
        />
      );
    },
    [requestBeingDeleted, handleLeaveRequestDelete]
  );

  const leaveRequests = staffLeaveRequestsQuery.data?.data;

  return (
    <View
      style={{
        flex: 1,
        ...Platform.select({
          android: styles.backdrop,
        }),
      }}
    >
      <View
        style={{
          flex: 1,
          backgroundColor: "#f8f8f8",
          ...Platform.select({
            android: styles.content,
          }),
        }}
      >
        <View style={{ backgroundColor: "#ffffff", gap: 8 }}>
          <View style={[styles.header]}>
            <Text style={[styles.headerText]}>My Leave Requests</Text>

            <YearSelectMenu
              params={params}
              onSelect={setSelectedYear}
              selectedOption={selectedYear}
            />

            <TouchableOpacity
              onPress={() => closeModal()}
              style={styles.closeButton}
            >
              <Image
                source={require("../../assets/ic_close.png")}
                style={{ width: 24, height: 24, resizeMode: "contain" }}
              />
            </TouchableOpacity>
          </View>

          <SegmentedControl
            style={{ marginHorizontal: 12, marginVertical: 8 }}
            values={leaveTypes.map((leaveType) => leaveType.label)}
            selectedIndex={leaveTypes.findIndex(
              (leaveType) => leaveType.id === selectedLeaveType?.id
            )}
            onChange={(event) => {
              const selectedIndex = event.nativeEvent.selectedSegmentIndex;
              const selectedLeaveType = leaveTypes[selectedIndex];
              setSelectedLeaveType(selectedLeaveType);
            }}
            appearance="light"
          />
        </View>

        {staffLeaveRequestsQuery.isLoading ? (
          <View style={styles.fullScreenLoader}>
            <ActivityIndicator size={"large"} color={"#2658A5"} />
          </View>
        ) : (
          <FlatList
            data={leaveRequests}
            renderItem={_renderItem}
            contentContainerStyle={{
              gap: 24,
              paddingHorizontal: 12,
              paddingTop: 16,
              paddingBottom: 48,
            }}
            ListEmptyComponent={
              <View style={styles.fullScreenLoader}>
                <Text style={styles.text}>
                  {staffLeaveRequestsQuery.isError
                    ? staffLeaveRequestsQuery.error.message
                    : "No leave requests found!"}
                </Text>
              </View>
            }
            refreshControl={
              <RefreshControl
                refreshing={staffLeaveRequestsQuery.isRefetching || false}
                tintColor={"#2658A5"}
                progressBackgroundColor={"#ffffff"}
                colors={["#2658A5"]}
                onRefresh={() => staffLeaveRequestsQuery.refetch()}
              />
            }
          />
        )}
      </View>
    </View>
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
  },
  header: {
    flexDirection: "row",
    height: 52,
    paddingTop: 12,
    paddingLeft: 12,
    alignItems: "center",
    gap: 8,
  },
  headerText: {
    flex: 1,
    fontSize: 18,
    lineHeight: 18 * 1.5,
    fontWeight: "600",
    color: "#323232",
    fontFamily: "Georgia.ttf",
  },
  text: {
    fontSize: 16,
    lineHeight: 15 * 1.5,
    fontWeight: "500",
    color: "#545454",
    fontFamily: "Georgia.ttf",
  },
  closeButton: {
    position: "relative",
    alignItems: "center",
    justifyContent: "center",
    paddingHorizontal: 12,
    height: 32,
  },
  fullScreenLoader: {
    flex: 1,
    minHeight: 400,
    alignItems: "center",
    justifyContent: "center",
  },
});

export const LeaveRequestsModalContent = React.memo(_LeaveRequestsModalContent);
