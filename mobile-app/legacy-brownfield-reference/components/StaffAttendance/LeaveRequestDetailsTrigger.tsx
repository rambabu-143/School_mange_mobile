import * as React from "react";
import {
  Animated,
  LayoutAnimation,
  StyleSheet,
  Text,
  TouchableOpacity,
} from "react-native";
import RNHapticFeedback from "react-native-haptic-feedback";

export type LeaveRequestDetailsTrigger = {
  expandedValue: Animated.Value;
  triggerText?: string;
  onPress?: () => void;
};

const _LeaveRequestDetailsTrigger: React.FC<LeaveRequestDetailsTrigger> = ({
  expandedValue,
  onPress,
  triggerText,
}) => {
  return (
    <TouchableOpacity
      onPress={() => {
        onPress?.();
        RNHapticFeedback.trigger("impactLight");
        LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
      }}
      style={styles.pressable}
    >
      <Text style={[styles.smallText, styles.detailsLabel]}>{triggerText || "Details"}</Text>

      <Animated.Image
        source={require("../../assets/ic_chevron_down_circle_fill.png")}
        style={[
          styles.expandedStateIcon,
          {
            transform: [
              {
                rotateZ: expandedValue.interpolate({
                  inputRange: [0, 1],
                  outputRange: ["0deg", "-180deg"],
                  extrapolate: "clamp",
                }),
              },
            ],
          },
        ]}
      />
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  pressable: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "flex-end",
    gap: 6,
    padding: 4,
    // backgroundColor: 'red'
  },
  smallText: {
    fontSize: 14,
    lineHeight: 14 * 1.5,
    fontWeight: "400",
    color: "#323232",
    fontFamily: "Georgia.ttf",
  },
  detailsLabel: {
    textAlign: "right",
    textDecorationLine: "underline",
    textDecorationStyle: "dotted",
  },
  expandedStateIcon: {
    width: 20,
    height: 20,
    resizeMode: "contain",
    tintColor: "#99999a",
  },
});

export const LeaveRequestDetailsTrigger = React.memo(
  _LeaveRequestDetailsTrigger
);
