import * as React from "react";
import { StyleSheet, TouchableOpacity, Text, Image, View } from "react-native";

import {
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuItemIndicator,
  DropdownMenuItemTitle,
  DropdownMenuRoot,
  DropdownMenuTrigger
} from "../../design-system/dropdown-menu";

export type HalfDaySelectionMenuProps = {  
  onSelect?: (option: 0 | 1 | 2) => void;
  onDisabledPress: () => void;
  selectedOption: 0 | 1 | 2;
  disabled?: boolean;
};

const _HalfDaySelectionMenu: React.FC<HalfDaySelectionMenuProps> = ({
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
            {typeof selectedOption === "number" ? selectedOption : "Select"}
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
      <DropdownMenuTrigger about="Select number of half day leaves">
        <TouchableOpacity style={styles.triggerButton}>
          <View>
            <Text style={[styles.text, selectedOption ? null : { color: "#565656" }]}>
              {typeof selectedOption === "number" ? selectedOption : "Select"}
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

          {[0 as const, 1 as const, 2 as const].map((halfDayLeave, index) => {
            return (
              <DropdownMenuCheckboxItem
                key={(halfDayLeave || index).toString()}
                value={selectedOption === halfDayLeave}
                onSelect={() => onSelect?.(halfDayLeave)}
              >
                {/* <DropdownMenuItemIndicator /> */}

                <DropdownMenuItemTitle>
                  {`${halfDayLeave}`}
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

export const HalfDaySelectionMenu = React.memo(_HalfDaySelectionMenu);
