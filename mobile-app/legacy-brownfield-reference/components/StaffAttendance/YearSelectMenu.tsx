import * as React from "react";
import { StyleSheet, TouchableOpacity, Text, Image } from "react-native";
import dayjs from "dayjs";

import { StaffAttendanceParams } from "../../types";
import { useAttendanceDateQuery } from "../../queries/useAttendanceDateQuery";
import {
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItemIndicator,
  DropdownMenuItemTitle,
  DropdownMenuLabel,
  DropdownMenuRoot,
  DropdownMenuTrigger
} from "../../design-system/dropdown-menu";

export type LeaveTypeMenuProps = {  
  onSelect?: (option: string) => void;
  selectedOption?: string | null;
  params: StaffAttendanceParams | undefined;
};

const _YearSelectMenu: React.FC<LeaveTypeMenuProps> = ({
  params,
  onSelect,
  selectedOption,
}) => {
  const attendanceDatesQuery = useAttendanceDateQuery({ token: params?.token });

  const yearsList: string[] = [];

  const yearSession = attendanceDatesQuery.data?.year_session;
  const years = yearSession ? yearSession.split('-') : null;

  const startYear = years?.[0];
  if (startYear) {
    yearsList.push(startYear);
  }
  const endYearShort = years?.[1];
  const endYear = dayjs(endYearShort, "YY").format("YYYY");
  if (endYear) {
    yearsList.push(endYear);
  }

  return (
    <DropdownMenuRoot>
      <DropdownMenuTrigger>
        <TouchableOpacity style={styles.triggerButton}>
          <Text style={[styles.text, selectedOption ? null : { color: "#565656" }]}>
            {selectedOption || "Select"}
          </Text>

          <Image
            source={require("../../assets/ic_chevron_up_chevron_down.png")}
            style={[{ width: 14, height: 14, resizeMode: "contain" }, selectedOption ? null : { tintColor: "#565656" }]}
          />
        </TouchableOpacity>
      </DropdownMenuTrigger>

      <DropdownMenuContent>
        <DropdownMenuGroup>
          <DropdownMenuLabel>Year Session: {attendanceDatesQuery.data?.year_session}</DropdownMenuLabel>

          {yearsList?.map((year, index) => {
            return (
              <DropdownMenuCheckboxItem
                key={year || index.toString()}
                value={selectedOption === year}
                onSelect={() => onSelect?.(year)}
              >
                {/* <DropdownMenuItemIndicator /> */}

                <DropdownMenuItemTitle>
                  {year}
                </DropdownMenuItemTitle>
              </DropdownMenuCheckboxItem>
            );
          })}
        </DropdownMenuGroup>
      </DropdownMenuContent>
    </DropdownMenuRoot>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
  },
  text: {
    fontSize: 17,
    lineHeight: 17 * 1.5,
    fontWeight: '400',
    fontFamily: "Georgia.ttf",
    color: "#343434",
  },
  smallText: {
    fontSize: 14,
    lineHeight: 14*1.5,
    fontFamily: "Georgia.ttf",
    color: "#343434",
  },
  triggerButton: {
    flexDirection: "row",
    gap: 8,
    alignItems: "center",
    justifyContent: "center",
    backgroundColor: "#eeeeef",
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 6,
  },
});

export const YearSelectMenu = React.memo(_YearSelectMenu);
