import { BlurView } from "@react-native-community/blur";
import React, { memo, useCallback, useRef, useState } from "react";
import {
  ActivityIndicator,
  Animated,
  ScrollView,
  StyleSheet,
  Text,
  TouchableHighlight,
  TouchableOpacity,
  useWindowDimensions,
  View,
} from "react-native";
import {
  SafeAreaView,
  useSafeAreaInsets,
} from "react-native-safe-area-context";
import Toast from "react-native-toast-message";

import { Question } from "../Question/Question";
import { surveyQuestions } from "../../constants/surveyQuestions";
import { useStudentRatingQuery } from "../../queries/useStudentRatingQuery";
import {
  QuestionRatingInput,
  QuestionRatingInputProps,
} from "../QuestionRatingInput/QuestionRatingInput";
import {
  QuestionTextInput,
  QuestionTextInputProps,
} from "../QuestionTextInput/QuestionTextInput";
import { useStudentRatingMutation } from "../../queries/useStudentRatingMutation";
import type { TeacherEvaluationProgrammeParams } from "../../types";

export type TeacherSurveyProps = {
  onCancel?: () => void;
  params?: TeacherEvaluationProgrammeParams;
};

const _TeacherSurvey = ({ onCancel, params }: TeacherSurveyProps) => {
  const { bottom: bottomInset } = useSafeAreaInsets();
  const scrollViewRef = useRef<React.ElementRef<typeof ScrollView> | null>(
    null
  );
  const scrollAnimatedValueRef = useRef(new Animated.Value(0));
  const { fontScale } = useWindowDimensions();

  const query = useStudentRatingQuery({
    staffId: params?.staff?.id,
    standardSectionId: params?.standardSectionId,
    studentId: params?.studentId,
    token: params?.token,
  });

  const mutation = useStudentRatingMutation({
    staffId: params?.staff?.id,
    standardSectionId: params?.standardSectionId,
    studentId: params?.studentId,
    token: params?.token,
    ratingBy: "STUDENT",
  });

  const [step, setStep] = useState(0);
  const [answers, setAnswers] = useState<Record<string, string | number>>(
    () => {
      const savedAnswers = query.data?.ratings;
      return surveyQuestions.reduce((acc, curr) => {
        curr.data.forEach((question) => {
          const currentSavedAns = savedAnswers?.[`question${question.pos}`];
          if (
            typeof currentSavedAns ===
            (question.answerType === "input" ? "string" : "number")
          ) {
            acc[question.pos.toString()] = currentSavedAns;
          } else {
            acc[question.pos.toString()] =
              question.answerType === "input" ? "" : 0;
          }
        });
        return acc;
      }, {});
    }
  );

  const steps = surveyQuestions.length;

  const currentSection = surveyQuestions[step];

  const onRatingInputAnswer: QuestionRatingInputProps["onAnswer"] = useCallback(
    (question, value) => {
      setAnswers((prevAnswers) => {
        const questionId = question.pos.toString();
        const prevAnswer = prevAnswers[questionId];
        if (
          question.answerType === "rating" &&
          typeof prevAnswer === "number"
        ) {
          return {
            ...prevAnswers,
            [questionId]: value === prevAnswer ? value - 1 : value,
          };
        }
        return prevAnswers;
      });
    },
    []
  );

  const onTextInputAnswer: QuestionTextInputProps["onAnswer"] = useCallback(
    (question, value) => {
      setAnswers((prevAnswers) => {
        const questionId = question.pos.toString();
        if (question.answerType === "input") {
          return {
            ...prevAnswers,
            [questionId]: value,
          };
        }
        return prevAnswers;
      });
    },
    []
  );

  const getRatings = () => ({
    question1: answers["1"],
    question2: answers["2"],
    question3: answers["3"],
    question4: answers["4"],
    question5: answers["5"],
    question6: answers["6"],
    question7: answers["7"],
    question8: answers["8"],
    question9: answers["9"],
    question10: answers["10"],
    question11: answers["11"],
    question12: answers["12"],
    question13: answers["13"],
    question14: answers["14"],
    question15: answers["15"],
    question16: answers["16"],
    question17: answers["17"],
    question18: answers["18"],
    question19: answers["19"],
    question20: answers["20"],
    question21: answers["21"],
    question22: answers["22"],
  });

  const handleSaveAsDraft = () => {
    mutation.mutate({
      is_final_submit: false,
      ratings: getRatings(),
    });
  };

  const handleSubmitPress = () => {
    mutation.mutate({
      is_final_submit: true,
      ratings: getRatings(),
    });
  };

  const handleNextPress = () => {
    // save current progress
    setStep((prev) => Math.min(surveyQuestions.length - 1, prev + 1));
    // scroll to top without animation
    scrollViewRef.current?.scrollTo({
      x: 0,
      y: 0,
      animated: false,
    });
  };

  const handlePreviousPress = () => {
    setStep((prev) => Math.max(0, prev - 1));
    // scroll to top without animation
    scrollViewRef.current?.scrollTo({
      x: 0,
      y: 0,
      animated: false,
    });
  };

  const handleCancelPress = () => {
    onCancel?.();
  };

  const surveySubmitted =
    mutation.isSuccess && mutation.variables.is_final_submit;
  const mutationCTADisabled = mutation.isPending || surveySubmitted;

  const HEADER_HEIGHT = 20 * 1.5 * 2 * Math.min(1.3, fontScale) + 12;

  return (
    <View style={{ flex: 1, position: "relative" }}>
      <Animated.ScrollView
        ref={scrollViewRef}
        style={{
          paddingHorizontal: 20,
          backgroundColor: "#ffffff",
        }}
        contentContainerStyle={{
          paddingTop: HEADER_HEIGHT,
          paddingBottom: bottomInset + 83.5 + 32 + 32,
        }}
        bounces={false}
        onScroll={Animated.event(
          [
            {
              nativeEvent: {
                contentOffset: { y: scrollAnimatedValueRef.current },
              },
            },
          ],
          { useNativeDriver: true }
        )}
        scrollEventThrottle={16}
      >
        <View style={{ gap: 32 }}>
          {currentSection.data.map((question) => {
            const questionId = question.pos.toString();
            const questionAnswer = answers[questionId];
            return (
              <Question
                key={questionId}
                question={question}
                AnswerComponent={
                  question.answerType === "rating" &&
                  typeof questionAnswer !== "string" ? (
                    <QuestionRatingInput
                      onAnswer={onRatingInputAnswer}
                      question={question}
                      value={questionAnswer}
                      disabled={
                        mutation.isSuccess && mutation.variables.is_final_submit
                      }
                    />
                  ) : question.answerType === "input" &&
                    typeof questionAnswer !== "number" ? (
                    <QuestionTextInput
                      onAnswer={onTextInputAnswer}
                      question={question}
                      value={questionAnswer}
                      disabled={
                        mutation.isSuccess && mutation.variables.is_final_submit
                      }
                    />
                  ) : null
                }
              />
            );
          })}
        </View>
      </Animated.ScrollView>

      {/* Header */}
      <Animated.View
        style={{
          position: "absolute",
          top: 0,
          width: "100%",
          backgroundColor: "#ffffff",
          transform: [
            {
              translateY: Animated.diffClamp(
                scrollAnimatedValueRef.current,
                0,
                HEADER_HEIGHT
              ).interpolate({
                inputRange: [0, HEADER_HEIGHT],
                outputRange: [0, -HEADER_HEIGHT],
                extrapolate: "clamp",
              }),
            },
          ],
        }}
      >
        <Text style={styles.title} maxFontSizeMultiplier={1.3}>
          {currentSection.title}
        </Text>
      </Animated.View>

      {/* Footer */}
      <BlurView
        style={{
          position: "absolute",
          width: "100%",
          bottom: 0,
        }}
        blurType="light"
      >
        <SafeAreaView
          style={{
            paddingHorizontal: 20,
            paddingVertical: 12,
          }}
          edges={["right", "bottom", "left"]}
        >
          <View
            style={{
              // backgroundColor: "green",
              gap: 8,
              flexDirection: "row",
              // marginTop: 12,
              marginBottom: 12,
            }}
          >
            {Array.from({ length: steps }).map((_, index) => {
              const isActive = index === step;
              const isCompleted = index < step;
              return (
                <View
                  key={index}
                  style={{
                    flexGrow: 1,
                    backgroundColor:
                      isActive || isCompleted ? "#2658A5" : "silver",
                    height: 4,
                    borderRadius: 8,
                  }}
                />
              );
            })}
          </View>

          <View
            style={{
              flexDirection: "row",
              // backgroundColor: "red",
              justifyContent: "space-between",
            }}
          >
            {step === 0 ? (
              <TouchableHighlight
                style={{
                  // flex: 1,
                  alignSelf: "flex-end",
                  paddingTop: 8,
                  paddingBottom: 10,
                  paddingHorizontal: 12,
                  borderRadius: 4,
                  backgroundColor: "#dedede",
                }}
                onPress={handleCancelPress}
                underlayColor={"#bcbcbc"}
              >
                <Text
                  style={{
                    fontSize: 17,
                    lineHeight: 17 * 1.5,
                    fontWeight: "bold",
                    color: "#000000",
                  }}
                  maxFontSizeMultiplier={1.2}
                >
                  Cancel
                </Text>
              </TouchableHighlight>
            ) : (
              <TouchableHighlight
                style={{
                  alignSelf: "flex-end",
                  paddingTop: 8,
                  paddingBottom: 10,
                  paddingHorizontal: 12,
                  borderRadius: 4,
                  backgroundColor: step <= 0 ? "#efefef" : "#dedede",
                  opacity: mutationCTADisabled ? 0 : 1,
                }}
                disabled={step <= 0 || mutationCTADisabled}
                onPress={handlePreviousPress}
                underlayColor={"#bcbcbc"}
              >
                <Text
                  style={{
                    fontSize: 17,
                    lineHeight: 17 * 1.5,
                    fontWeight: "bold",
                    color: step <= 0 ? "#dedede" : "#000000",
                  }}
                  maxFontSizeMultiplier={1.2}
                >
                  Previous
                </Text>
              </TouchableHighlight>
            )}

            {/* Save in Draft CTA */}
            <TouchableOpacity
              style={{
                flex: 1,
                paddingVertical: 8,
                alignItems: "center",
                justifyContent: "center",
              }}
              disabled={mutationCTADisabled}
              onPress={handleSaveAsDraft}
            >
              <Text
                style={{
                  fontSize: 17,
                  lineHeight: 17 * 1.5,
                  fontWeight: "bold",
                  color: mutationCTADisabled ? "#6A9CE9" : "#2658DF",
                }}
                ellipsizeMode="middle"
                maxFontSizeMultiplier={1.2}
              >
                {mutation.isPending && !mutation.variables.is_final_submit
                  ? "Saving..."
                  : "Save as Draft"}
              </Text>
            </TouchableOpacity>

            {step === surveyQuestions.length - 1 ? (
              <TouchableHighlight
                style={{
                  alignSelf: "flex-end",
                  paddingTop: 8,
                  paddingBottom: 8,
                  paddingHorizontal: 12,
                  borderRadius: 4,
                  backgroundColor: mutationCTADisabled ? "#6A9CE9" : "#2658A5",
                }}
                disabled={mutationCTADisabled}
                underlayColor={"#043683"}
                onPress={handleSubmitPress}
              >
                <View style={{ position: "relative" }}>
                  <Text
                    style={{
                      fontSize: 17,
                      lineHeight: 17 * 1.5,
                      fontWeight: "bold",
                      color: "#ffffff",
                      opacity:
                        mutation.isPending &&
                        mutation.variables?.is_final_submit
                          ? 0
                          : 1,
                    }}
                    maxFontSizeMultiplier={1.2}
                  >
                    Submit
                  </Text>

                  {mutation.isPending && mutation.variables?.is_final_submit ? (
                    <ActivityIndicator
                      size={"small"}
                      color={"#000000"}
                      style={{
                        flex: 1,
                        position: "absolute",
                        alignSelf: "center",
                      }}
                    />
                  ) : null}
                </View>
              </TouchableHighlight>
            ) : (
              <TouchableHighlight
                style={{
                  // flex: 1,
                  alignSelf: "flex-end",
                  paddingTop: 8,
                  paddingBottom: 10,
                  paddingHorizontal: 12,
                  borderRadius: 4,
                  backgroundColor:
                    step === surveyQuestions.length - 1 ? "#6A9CE9" : "#2658A5",
                }}
                disabled={step === surveyQuestions.length - 1}
                underlayColor={"#043683"}
                onPress={handleNextPress}
              >
                <Text
                  style={{
                    fontSize: 17,
                    lineHeight: 17 * 1.5,
                    fontWeight: "bold",
                    color: "#ffffff",
                  }}
                  maxFontSizeMultiplier={1.2}
                >
                  Next
                </Text>
              </TouchableHighlight>
            )}
          </View>
        </SafeAreaView>
      </BlurView>
    </View>
  );
};

const styles = StyleSheet.create({
  title: {
    fontSize: 20,
    lineHeight: 20 * 1.5,
    fontFamily: "georgia-bold",
    fontWeight: "bold",
    color: "#2658A5",
    marginHorizontal: 20,
    marginTop: 12,
  },
  questionText: {
    fontSize: 18,
    lineHeight: 18 * 1.5,
    fontFamily: "georgia",
  },
});

export const TeacherSurvey = memo(_TeacherSurvey);
