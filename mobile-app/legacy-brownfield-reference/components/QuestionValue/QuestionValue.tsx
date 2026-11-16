import LottieView from "lottie-react-native";
import React from "react";
import { StyleSheet, Text, View } from "react-native";
import { useSafeAreaFrame } from "react-native-safe-area-context";

type Question = {
  text: string;
  pos: number;
  answerType: "rating" | "input";
};

export type QuestionValueProps = {
  question: Question;
  value: number | string | undefined;
};

const _QuestionValue = ({ question, value }: QuestionValueProps) => {
  const { width: safeWidth } = useSafeAreaFrame();

  if (question.answerType === "rating" && typeof value !== "string") {
    return (
      <>
        {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((val) => {
          const containerWidth = safeWidth - 40;
          const showActive = !!value && val <= value;
          return (
            <LottieView
              key={val}
              source={require("../../assets/animated-star.lottie")}
              style={{
                maxWidth: 40,
                maxHeight: 40,
                width: containerWidth / 10,
                height: containerWidth / 10,
              }}
              progress={showActive ? 1 : 0}
            />
          );
        })}
      </>
    );
  }
  if (question.answerType === "input" && typeof value !== "number") {
    return (
      <View style={{ flexGrow: 1 }}>
        <Text style={styles.answerText}>
          Ans: {value}
        </Text>
      </View>
    );
  }
  return null;
};

const styles = StyleSheet.create({
  answerText: {
    fontSize: 17,
    lineHeight: 17 * 1.4,
    fontFamily: "georgia",
    color: '#454545'
  },
});

export const QuestionValue = React.memo(_QuestionValue);
