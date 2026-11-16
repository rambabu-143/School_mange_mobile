import * as React from "react";
import { StyleSheet, TouchableOpacity, View } from "react-native";
import type { TouchableOpacityProps, ViewProps } from "react-native";

export type CardProps =
  | ({
      touchable: true;
    } & TouchableOpacityProps)
  | ViewProps;

export const Card: React.FC<CardProps> = ({ style, ...restProps }) => {
  if ("touchable" in restProps) {
    return (
      <TouchableOpacity
        style={StyleSheet.flatten([styles.container, style])}
        {...restProps}
      />
    );
  }

  return (
    <View
      style={StyleSheet.flatten([styles.container, style])}
      {...restProps}
    />
  );
};

const styles = StyleSheet.create({
  container: {
    flexGrow: 1,
    padding: 12,
    borderRadius: 8,
    backgroundColor: "#ffffff",

    shadowColor: "#000000",
    shadowRadius: 2,
    shadowOffset: { height: 0.7, width: 0 },
    shadowOpacity: 0.07,
    elevation: 2,
  },
});
