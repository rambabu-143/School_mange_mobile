import * as React from "react";
import { StyleSheet, TouchableOpacity, Text, Image, Platform } from "react-native";
import dayjs from "dayjs";

import type { SeniorRole } from "../../queries/useGetStaffSeniorsQuery";
import { useGetStaffSeniorsQuery } from "../../queries/useGetStaffSeniorsQuery";
import { StaffAttendanceParams } from "../../types";
import {
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuItemTitle,
  DropdownMenuRoot,
  DropdownMenuTrigger,
  DropdownMenuGroup,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuItemSubtitle,
  DropdownMenuItemIndicator,
} from "../../design-system/dropdown-menu";

export type StaffSeniorMenuProps = {
  onSelect?: (option: SeniorRole) => void;
  onNoPriorApprovalSelect?: () => void;
  noPriorApprovalSelected?: boolean;
  params: StaffAttendanceParams | undefined;
  selectedOption?: SeniorRole | null;
  noOptionLabel?: string;
};

const _StaffSeniorMenu: React.FC<StaffSeniorMenuProps> = ({
  params,
  onSelect,
  noPriorApprovalSelected,
  onNoPriorApprovalSelect,
  selectedOption,
  noOptionLabel,
}) => {
  const getStaffSeniorsQuery = useGetStaffSeniorsQuery({
    staffId: params?.staffId,
    year: dayjs().format("YYYY"),
    token: params?.token,
  });

  const isValidLabel = Boolean(selectedOption || noOptionLabel);

  return (
    <DropdownMenuRoot>
      <DropdownMenuTrigger>
        <TouchableOpacity style={styles.triggerButton}>
          <Text
            maxFontSizeMultiplier={1.1}
            style={[styles.text, isValidLabel ? null : { color: "#565656" }]}
          >
            {selectedOption
              ? selectedOption.staff_id.name
              : noOptionLabel || "Select"}
          </Text>

          <Image
            source={require("../../assets/ic_chevron_up_chevron_down.png")}
            style={[
              { width: 14, height: 14, resizeMode: "contain" },
              isValidLabel ? null : { tintColor: "#565656" },
            ]}
          />
        </TouchableOpacity>
      </DropdownMenuTrigger>

      <DropdownMenuContent>
        {/* <DropdownMenu.Group> */}
        <DropdownMenuCheckboxItem
          key={"no-prior-approval"}
          value={noPriorApprovalSelected || false}
          onSelect={() => onNoPriorApprovalSelect?.()}
        >
          {/* <DropdownMenuItemIndicator /> */}

          <DropdownMenuItemTitle>{"No Prior Approval"}</DropdownMenuItemTitle>
        </DropdownMenuCheckboxItem>
        {/* </DropdownMenu.Group> */}

        <DropdownMenuSeparator />

        <DropdownMenuGroup>
          <DropdownMenuLabel>Your Seniors</DropdownMenuLabel>

          {getStaffSeniorsQuery.data?.data?.roles.map((seniorRole) => {
            return (
              <DropdownMenuCheckboxItem
                key={seniorRole._id}
                value={selectedOption?._id === seniorRole._id}
                onSelect={() => onSelect?.(seniorRole)}
              >
                {/* <DropdownMenuItemIndicator /> */}

                <DropdownMenuItemTitle>
                  {`${seniorRole.staff_id.name}${Platform.OS === "ios" ? "" : ` (${seniorRole.short_name})`}`}
                </DropdownMenuItemTitle>

                <DropdownMenuItemSubtitle>
                  {`(${seniorRole.short_name})`}
                </DropdownMenuItemSubtitle>
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
    fontSize: 16,
    lineHeight: 16 * 1.5,
    fontFamily: "Georgia.ttf",
    color: "#000000",
  },
  triggerButton: {
    flexDirection: "row",
    gap: 8,
    alignItems: "center",
    justifyContent: "center",
    // padding: 10,
    // backgroundColor: "#007AFF",
    // borderRadius: 5,
  },
});

export const StaffSeniorMenu = React.memo(_StaffSeniorMenu);
