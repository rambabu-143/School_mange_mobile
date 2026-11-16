import React, { useState } from "react";
import { ActivityIndicator, StatusBar, StyleSheet, View } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";

import { Header } from "../components/Header/Header";
import { SurveyIntro } from "../components/SurveyIntro/SurveyIntro";
import { TeacherSurvey } from "../components/TeacherSurvey/TeacherSurvey";
import { SurveySubmitted } from "../components/SurveySubmitted/SurveySubmitted";
import { useStudentRatingQuery } from "../queries/useStudentRatingQuery";
import type { TeacherEvaluationProgrammeParams } from "../types";

export type TeacherEvaluationProgrammeProps = {
  params?: TeacherEvaluationProgrammeParams;
};

export const TeacherEvaluationProgramme = ({
  params,
}: TeacherEvaluationProgrammeProps) => {
  const isDarkMode = false;
  const backgroundStyle = {
    backgroundColor: isDarkMode ? "#000000" : "#ffffff",
  };
  const [surveyStarted, setSurveyStarted] = useState(false);

  const query = useStudentRatingQuery({
    staffId: params?.staff?.id,
    standardSectionId: params?.standardSectionId,
    studentId: params?.studentId,
    token: params?.token,
  });

  return (
    <SafeAreaView style={styles.container} edges={["top", "left", "right"]}>
      <StatusBar
        barStyle={isDarkMode ? "light-content" : "dark-content"}
        backgroundColor={backgroundStyle.backgroundColor}
      />

      <Header
        title={
          !query.isLoading && query.data?.is_final_submit
            ? "My Feedback"
            : "Feedback"
        }
      />

      <View style={styles.content}>
        {query.isLoading ? (
          <View
            style={{ flex: 1, alignItems: "center", justifyContent: "center" }}
          >
            <ActivityIndicator size={"large"} color={"#000000"} />
          </View>
        ) : query.data?.is_final_submit ? (
          <SurveySubmitted
            title={"Thank you for your feedback! 🎉"}
            params={params}
          />
        ) : surveyStarted ? (
          <TeacherSurvey
            params={params}
            onCancel={() => setSurveyStarted(false)}
          />
        ) : (
          <SurveyIntro
            title={""}
            teacher={params?.staff}
            subjectLabel={params?.subjectLabel}
            onStart={() => setSurveyStarted(true)}
          />
        )}
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#ffffff",
  },
  content: {
    flex: 1,
    backgroundColor: "#ffffff", // "#efefef",
    overflow: "hidden",
  },
});
