import * as React from "react";
import {
  View,
  Text,
  StyleSheet,
  ActivityIndicator,
  ViewStyle,
} from "react-native";
import dayjs from "dayjs";

import {
  StaffLeaveDetails,
  useStaffLeaveBalancesQuery,
} from "../../queries/useStaffLeaveBalancesQuery";
import { StaffAttendanceParams } from "../../types";

export type LeaveBalancesTableProps = {
  params: StaffAttendanceParams | undefined;
};

const _LeaveBalancesTable: React.FC<LeaveBalancesTableProps> = ({ params }) => {
  const staffLeaveBalancesQuery = useStaffLeaveBalancesQuery({
    token: params?.token,
    staffId: params?.staffId,
    year: dayjs().format("YYYY"),
  });

  const staffLeaveBalancesData = React.useMemo(
    () => getTableFormatLeaveData(staffLeaveBalancesQuery.data),
    [staffLeaveBalancesQuery.data]
  );

  return (
    <View style={{ gap: 8, marginTop: 8 }}>
      <Text style={{ fontSize: 16, fontWeight: "500" }}>Leave Balances:</Text>

      {!staffLeaveBalancesData ? (
        <View style={[styles.tableContainer, styles.noDataTableContainer]}>
          {staffLeaveBalancesQuery.isLoading ? (
            <ActivityIndicator size={"small"} color={"#000000"} />
          ) : (
            <Text style={styles.noDataLabel}>
              Leave balances data not available!
            </Text>
          )}
        </View>
      ) : (
        <View style={styles.tableContainer}>
          {staffLeaveBalancesData.map((item, index, arr) => {
            const isLastItem = index === arr.length - 1;
            return (
              <View
                key={item.id}
                style={[
                  item.style,
                  {
                    borderColor: "#ababab",
                    borderTopWidth: 1,
                    borderBottomWidth: 1,
                    borderRightWidth: isLastItem ? 1 : 0,
                    borderLeftWidth: 1,

                    borderTopRightRadius: isLastItem ? 6 : 0,
                    borderBottomRightRadius: isLastItem ? 6 : 0,

                    borderTopLeftRadius: index === 0 ? 6 : 0,
                    borderBottomLeftRadius: index === 0 ? 6 : 0,
                  },
                ]}
              >
                <View
                  style={{
                    paddingVertical: 8,
                    alignItems: "center",
                    justifyContent: "center",
                  }}
                >
                  <Text
                    maxFontSizeMultiplier={1}
                    style={{
                      fontSize: 16,
                      lineHeight: 16 * 1.5,
                      fontWeight: "500",
                      fontFamily: "Georgia.ttf",
                      color: "#343434",
                    }}
                  >
                    {item.label}
                  </Text>
                </View>

                {item.data.map((dataItem, dataIndex) => {
                  return (
                    <View
                      key={dataItem + dataIndex.toString()}
                      style={{
                        borderTopWidth: 1,
                        borderColor: "#ababab",
                        paddingVertical: 4,
                        alignItems: "center",
                        justifyContent: "center",
                      }}
                    >
                      <Text
                        maxFontSizeMultiplier={1}
                        style={{
                          fontSize: 16,
                          lineHeight: 16 * 1.5,
                          fontWeight: "400",
                          fontFamily: "Georgia.ttf",
                          color: "#343434",
                        }}
                      >
                        {dataItem}
                      </Text>
                    </View>
                  );
                })}
              </View>
            );
          })}
        </View>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  tableContainer: {
    flexDirection: "row",
    backgroundColor: "#f5f5f5",
  },
  noDataTableContainer: {
    borderColor: "#ababab",
    borderWidth: 1,
    borderRadius: 6,
    alignItems: "center",
    justifyContent: "center",
    padding: 16,
  },
  noDataLabel: {
    fontSize: 16,
    lineHeight: 16 * 1.5,
    fontWeight: "400",
    color: "#343434",
    fontFamily: "Georgia.ttf",
  },
});

export const LeaveBalancesTable = React.memo(_LeaveBalancesTable);

type TableFormatData = Array<{
  id: string;
  label: string;
  data: (string | number)[];
  style: ViewStyle;
}>;

function getTableFormatLeaveData(
  data?: Array<StaffLeaveDetails> | null
): TableFormatData | null | undefined {
  if (!data) {
    return data;
  }
  const particulars: TableFormatData[number] = {
    id: "particulars",
    label: "Particulars",
    data: [],
    style: { flex: 2 },
  };
  const total: TableFormatData[number] = {
    id: "total",
    label: "Total",
    data: [],
    style: { flex: 1 },
  };
  const used: TableFormatData[number] = {
    id: "used",
    label: "Used",
    data: [],
    style: { flex: 1 },
  };
  const balance: TableFormatData[number] = {
    id: "balance",
    label: "Balance",
    data: [],
    style: { flex: 1 },
  };

  data.forEach((leaveDetails) => {
    if (leaveDetails.leave_name && leaveDetails.total && leaveDetails.total > 0) {
      particulars.data.push(leaveDetails.leave_name);
      total.data.push(leaveDetails.total ?? "-");
      used.data.push(leaveDetails.used ?? "-");
      balance.data.push(leaveDetails.balance ?? "-");
    }
  });

  return [particulars, total, used, balance];
}
