import React, { useState } from "react";
import { StyleSheet, Text, TextInput, View } from "react-native";

type Question = {
  text: string;
  pos: number;
  answerType: "rating" | "input";
};

export type QuestionTextInputProps = {
  question: Question;
  value: string | undefined;
  onAnswer: (question: Question, value: string) => void;
  disabled?: boolean;
};

const _QuestionTextInput = ({
  question,
  value,
  onAnswer,
  disabled,
}: QuestionTextInputProps) => {
  const [answerLength, setAnswerLength] = useState(
    typeof value === "string" ? value.length : 0
  );

  return (
    <View style={{ flexGrow: 1, gap: 4 }}>
      <View
        style={{
          maxHeight: 17 * 1.5 * 5,
          flexGrow: 1,
          borderRadius: 8,
          borderWidth: 1,
          borderColor: "#767676",
          overflow: "hidden",
          padding: 4,
        }}
      >
        <TextInput
          maxLength={100}
          numberOfLines={5}
          multiline={true}
          placeholder="Enter your answer here"
          defaultValue={value}
          onChangeText={(text) => {
            onAnswer?.(question, text);
            setAnswerLength(text.length);
          }}
          style={styles.input}
          editable={!disabled}
        />
      </View>

      <View style={{}}>
        <Text style={{ alignSelf: "flex-end" }}>{answerLength}/100</Text>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  input: {
    fontSize: 17,
    lineHeight: 17 * 1.5,
    minHeight: 17 * 1.5 * 2,
    textAlignVertical: "center",
    color: '#454545',
  },
});

export const QuestionTextInput = React.memo(_QuestionTextInput);
