import LottieView from "lottie-react-native";
import React from "react";
import { StyleSheet, TouchableOpacity, View } from "react-native";
import { useSafeAreaFrame } from "react-native-safe-area-context";

type Question = {
  text: string;
  pos: number;
  answerType: "rating" | "input";
};

export type QuestionRatingInputProps = {
  question: Question;
  value: number | undefined;
  onAnswer: (question: Question, value: number) => void;
  disabled?: boolean;
};

const _QuestionRatingInput = ({
  disabled,
  question,
  value,
  onAnswer,
}: QuestionRatingInputProps) => {
  const { width: safeWidth } = useSafeAreaFrame();

  const containerWidth = safeWidth - 40;

  return (
    <View style={{ flexDirection: "row" }}>
      {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((val) => {
        const showActive =
          typeof value === "number" && !isNaN(value) ? val <= value : false;

        return (
          <TouchableOpacity disabled={disabled} key={val} onPress={() => onAnswer?.(question, val)}>
            <LottieView
              source={require("../../assets/animated-star.lottie")}
              style={{
                maxWidth: 40,
                maxHeight: 40,
                width: containerWidth / 10,
                height: containerWidth / 10,
              }}
              autoPlay={showActive}
              loop={false}
              progress={showActive ? 1 : 0}
            />
          </TouchableOpacity>
        );
      })}
    </View>
  );
};

const styles = StyleSheet.create({});

export const QuestionRatingInput = React.memo(_QuestionRatingInput);
