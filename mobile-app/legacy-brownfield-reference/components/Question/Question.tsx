import React from "react";
import { StyleSheet, Text, View } from "react-native";

type Question = {
  text: string;
  pos: number;
  answerType: "rating" | "input";
};

export type QuestionProps = {
  question: Question;
  AnswerComponent: React.ReactElement | null;
};

const _Question = ({ question, AnswerComponent }: QuestionProps) => {
  return (
    <View>
      <Text style={styles.questionText}>
        <Text style={{ fontFamily: "georgia-bold", fontWeight: 'bold', }}>Q{question.pos}:</Text> {question.text}
      </Text>

      <View
        style={{
          flexDirection: "row",
          marginTop: 6,
        }}
      >
        {AnswerComponent}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  questionText: {
    fontSize: 18,
    lineHeight: 18 * 1.5,
    fontFamily: "georgia",
    color: '#343434',
  },
});

export const Question = React.memo(_Question);
