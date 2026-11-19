import LottieView from 'lottie-react-native';
import * as React from 'react';
import { StyleSheet, TouchableOpacity, View } from 'react-native';

import type { SurveyQuestion } from './question';

const RATING_VALUES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

export type QuestionRatingInputProps = {
  question: SurveyQuestion;
  value: number | undefined;
  onAnswer?: (question: SurveyQuestion, value: number) => void;
  disabled?: boolean;
};

function QuestionRatingInputImpl({ disabled, question, value, onAnswer }: QuestionRatingInputProps) {
  return (
    <View style={styles.row}>
      {RATING_VALUES.map((val) => {
        const active = typeof value === 'number' && !isNaN(value) ? val <= value : false;
        return (
          <TouchableOpacity disabled={disabled} key={val} onPress={() => onAnswer?.(question, val)}>
            <LottieView
              source={require('@/assets/lottie/animated-star.lottie')}
              style={styles.star}
              autoPlay={active}
              loop={false}
              progress={active ? 1 : 0}
            />
          </TouchableOpacity>
        );
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  row: { flexDirection: 'row' },
  star: { width: 28, height: 28 },
});

export const QuestionRatingInput = React.memo(QuestionRatingInputImpl);
