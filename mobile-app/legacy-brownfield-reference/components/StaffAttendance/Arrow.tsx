import * as React from "react";
import { Image, StyleSheet } from "react-native";

export type ArrowProps = {
  direction: "left" | "right";
  disable?: boolean;
};

const _Arrow: React.FC<ArrowProps> = ({ direction, disable }) => {
  return (
    <Image
      src="back"
      style={[
        styles.icon,
        direction === "right" ? styles.rightArrow : null,
        disable ? styles.disabled : null,
      ]}
    />
  );
};

const styles = StyleSheet.create({
  icon: { width: 20, height: 20, resizeMode: "cover" },
  rightArrow: {
    transform: [{ rotateZ: "180deg" }],
  },
  disabled: {
    tintColor: "red",
  },
});

export const Arrow = React.memo(_Arrow);
