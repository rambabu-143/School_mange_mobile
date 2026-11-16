import React, { memo } from "react";
import {
  Image,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  ViewStyle,
} from "react-native";

import { backToNativeApp } from "../../utils/backToNativeApp";

export type HeaderProps = {
  title: string;
  onBackPress?: () => void;
  style?: ViewStyle;
  rightComponent?: React.ReactNode;
};

const _Header = ({ title, onBackPress, style, rightComponent }: HeaderProps) => {
  return (
    <View style={[styles.container, style]}>
      <TouchableOpacity
        style={styles.leftIcon}
        onPress={() =>
          typeof onBackPress === "function" ? onBackPress() : backToNativeApp()
        }
      >
        <Image src="back" style={styles.leftIconImage} />
      </TouchableOpacity>

      <View style={styles.flexOne}>
        <Text style={styles.title} numberOfLines={1} allowFontScaling={true} maxFontSizeMultiplier={1.2}>{title}</Text>
      </View>

      {rightComponent}
    </View>
  );
};

export const HEADER_HEIGHT = 44;

const styles = StyleSheet.create({
  container: {
    flexDirection: "row",
    height: HEADER_HEIGHT,
    alignItems: "center",
    paddingHorizontal: 16,
    backgroundColor: "#ffffff",
    borderBottomColor: "#323232",
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  flexOne: { flex: 1 },
  leftIcon: {
    marginRight: 12,
  },
  leftIconImage: { width: 28, height: 28, resizeMode: "contain" },
  title: {
    fontSize: 18,
    lineHeight: 29,
    color: "#343434",
    fontFamily: "Georgia.ttf",
    textTransform: "capitalize",
    textAlignVertical: "center",
  },
});

export const Header = memo(_Header);
