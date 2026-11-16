import * as React from "react";
import { StyleSheet, TouchableOpacity, Text, Image, View } from "react-native";

import {
  DropdownMenuRoot,
  DropdownMenuTrigger,
  DropdownMenuContent,
  DropdownMenuCheckboxItem,
  DropdownMenuItemIndicator,
  DropdownMenuItemTitle,
} from "../../design-system/dropdown-menu";

export type LeaveDayTypeMenuProps = {  
  onSelect?: (option: "Full Day" | "Half Day") => void;
  onDisabledPress?: () => void;
  selectedOption?: "Full Day" | "Half Day" | null;
  disabled?: boolean;
};

const _LeaveDayTypeMenu: React.FC<LeaveDayTypeMenuProps> = ({
  onSelect,
  onDisabledPress,
  selectedOption,
  disabled,
}) => {
  if (disabled) {
    return (
      <TouchableOpacity style={styles.triggerButton} onPress={onDisabledPress}>
        <View>
          <Text style={[styles.text, selectedOption ? null : { color: "#565656" }]}>
            {selectedOption ?? "Select"}
          </Text>
        </View>

        <Image
          source={require("../../assets/ic_chevron_up_chevron_down.png")}
          style={[{ width: 14, height: 14, resizeMode: "contain" }, selectedOption ? null : { tintColor: "#565656" }]}
        />
      </TouchableOpacity>
    );
  }
  return (
    <DropdownMenuRoot>
      <DropdownMenuTrigger>
        <TouchableOpacity style={styles.triggerButton}>
          <View>
            <Text style={[styles.text, selectedOption ? null : { color: "#565656" }]}>
              {selectedOption ?? "Select"}
            </Text>
          </View>

          <Image
            source={require("../../assets/ic_chevron_up_chevron_down.png")}
            style={[{ width: 14, height: 14, resizeMode: "contain" }, selectedOption ? null : { tintColor: "#565656" }]}
          />
        </TouchableOpacity>
      </DropdownMenuTrigger>

      <DropdownMenuContent>
        {/* <DropdownMenu.Group> */}
          {/* <DropdownMenu.Label>Available</DropdownMenu.Label> */}

          {["Full Day" as const, "Half Day" as const].map((leaveDayType, index) => {
            return (
              <DropdownMenuCheckboxItem
                key={leaveDayType}
                value={selectedOption === leaveDayType}
                onSelect={() => onSelect?.(leaveDayType)}
              >
                {/* <DropdownMenuItemIndicator /> */}

                <DropdownMenuItemTitle>
                  {`${leaveDayType}`}
                </DropdownMenuItemTitle>
              </DropdownMenuCheckboxItem>
            );
          })}
        {/* </DropdownMenu.Group> */}
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
    lineHeight: 16*1.5,
    fontFamily: "Georgia.ttf",
    color: "#000000",
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
    // padding: 10,
    // backgroundColor: "#007AFF",
    // borderRadius: 5,
  },
});

export const LeaveDayTypeMenu = React.memo(_LeaveDayTypeMenu);
