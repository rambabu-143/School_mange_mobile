import * as React from 'react';
import { StyleSheet, Text, TextInput, View } from 'react-native';

import type { SurveyQuestion } from './question';

export type QuestionTextInputProps = {
  question: SurveyQuestion;
  value: string | undefined;
  onAnswer: (question: SurveyQuestion, value: string) => void;
  disabled?: boolean;
};

function QuestionTextInputBase({ question, value, onAnswer, disabled }: QuestionTextInputProps) {
  const [answerLength, setAnswerLength] = React.useState(typeof value === 'string' ? value.length : 0);

  return (
    <View style={{ flexGrow: 1, gap: 4 }}>
      <View style={styles.box}>
        <TextInput
          maxLength={100}
          numberOfLines={5}
          multiline
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
      <Text style={{ alignSelf: 'flex-end' }}>{answerLength}/100</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  box: {
    maxHeight: 17 * 1.5 * 5,
    flexGrow: 1,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#767676',
    overflow: 'hidden',
    padding: 4,
  },
  input: {
    fontSize: 17,
    lineHeight: 17 * 1.5,
    minHeight: 17 * 1.5 * 2,
    textAlignVertical: 'center',
    color: '#454545',
  },
});

export const QuestionTextInput = React.memo(QuestionTextInputBase);
