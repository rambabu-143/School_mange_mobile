import * as React from 'react';
import { StyleSheet, Text, View } from 'react-native';

export type SurveyQuestion = { text: string; pos: number; answerType: 'rating' | 'input' };

export type QuestionProps = {
  question: SurveyQuestion;
  AnswerComponent: React.ReactElement | null;
};

function _Question({ question, AnswerComponent }: QuestionProps) {
  return (
    <View>
      <Text style={styles.questionText}>
        <Text style={{ fontWeight: 'bold' }}>Q{question.pos}:</Text> {question.text}
      </Text>
      <View style={{ flexDirection: 'row', marginTop: 6 }}>{AnswerComponent}</View>
    </View>
  );
}

const styles = StyleSheet.create({
  questionText: { fontSize: 18, lineHeight: 18 * 1.5, color: '#343434' },
});

export const Question = React.memo(_Question);
