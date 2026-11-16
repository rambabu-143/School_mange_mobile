import React from "react";
import { StyleSheet, Text, Image, View, SectionList } from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";

import { Question } from "../Question/Question";
import { surveyQuestions } from "../../constants/surveyQuestions";
import { useStudentRatingQuery } from "../../queries/useStudentRatingQuery";
import { QuestionValue } from "../QuestionValue/QuestionValue";
import type { TeacherEvaluationProgrammeParams } from "../../types";

export type SurveySubmittedProps = {
  title: string;
  params?: TeacherEvaluationProgrammeParams;
}

export const SurveySubmitted = ({ title, params }: SurveySubmittedProps) => {
  const { bottom: bottomInset } = useSafeAreaInsets();

  const teacher = params?.staff;
  const subjectLabel = params?.subjectLabel;

  const query = useStudentRatingQuery({
    staffId: params?.staff?.id,
    standardSectionId: params?.standardSectionId,
    studentId: params?.studentId,
    token: params?.token,
  });

  const data = query.data;

  return (
    <View style={{ flex: 1 }}>
      <SectionList
        style={{}}
        contentContainerStyle={{
          paddingHorizontal: 20,
          paddingBottom: bottomInset + 24,
        }}
        extraData={data}
        sections={surveyQuestions}
        renderItem={({ item }) => {
          return (
            <Question
              question={item}
              AnswerComponent={
                <QuestionValue
                  question={item}
                  value={data?.ratings?.[`question${item.pos}`]}
                />
              }
            />
          );
        }}
        renderSectionHeader={({ section: { title } }) => {
          return (
            <View
            style={{
              // backgroundColor: "violet",
              backgroundColor: "#ffffff",
            }}>
              <View
                style={{
                  paddingVertical: 8,
                  // backgroundColor: "violet",
                  backgroundColor: "#ffffff",
                }}
              >
                <Text
                  style={{
                    fontSize: 19,
                    lineHeight: 19 * 1.5,
                    fontFamily: "georgia-bold",
                    fontWeight: 'bold',
                    color: "#343434",
                  }}
                >
                  {title}
                </Text>
              </View>

              <View style={{ height: 1, width: '100%', backgroundColor: 'rgba(30, 30, 30, 0.5)' }} />
            </View>
          );
        }}
        stickySectionHeadersEnabled={true}
        keyExtractor={(data) => data.pos.toString()}
        ListHeaderComponent={
          <View style={{ gap: 8 }}>
            <Text
              style={{
                ...styles.h1,
                color: "#2658A5",
              }}
            >
              {title}
            </Text>

            <View
              style={{
                flexDirection: "row",
                gap: 12,
                alignItems: "center",
                marginBottom: 20
              }}
            >
              <Image
                src={teacher?.profilePic}
                style={{
                  width: 60,
                  height: 60,
                  resizeMode: "cover",
                  borderRadius: 30,
                  backgroundColor: "#efefef",
                }}
              />

              <View style={{ flex: 1 }}>
                <Text style={styles.p}>
                  {teacher?.name?.trim()?.replace(/\s+/g, " ")}
                </Text>
                <Text style={styles.subtitle}>{subjectLabel}</Text>
              </View>
            </View>
          </View>
        }
        ItemSeparatorComponent={() => <View style={{ height: 16, width: 1 }} />}
        SectionSeparatorComponent={() => (
          <View style={{ height: 12, width: 1 }} />
        )}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  h1: {
    fontSize: 24,
    lineHeight: 24 * 1.4,
    fontFamily: "georgia-bold",
    fontWeight: 'bold',
    marginTop: 12,
    color: '#343434',
  },
  p: {
    fontSize: 18,
    lineHeight: 18 * 1.5,
    color: '#343434',
  },
  subtitle: {
    fontSize: 16,
    lineHeight: 16 * 1.5,
    color: "#454545",
  },
  ctaButton: {
    backgroundColor: "#2658A5",
    borderRadius: 6,
    paddingHorizontal: 12,
    paddingTop: 8,
    paddingBottom: 10,
    alignItems: "center",
    justifyContent: "center",
  },
  ctaLabel: {
    fontSize: 18,
    lineHeight: 18 * 1.5,
    textAlign: "center",
    fontWeight: "bold",
    color: "#ffffff",
  },
});
