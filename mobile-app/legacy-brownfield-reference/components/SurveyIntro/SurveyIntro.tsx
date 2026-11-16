import React from "react";
import {
  StyleSheet,
  Text,
  Image,
  View,
  TouchableHighlight,
  ScrollView,
} from "react-native";
import dayjs from "dayjs";
import { SafeAreaView } from "react-native-safe-area-context";
import { TeacherEvaluationProgrammeParams } from "../../types";

export type SurveyIntroProps = {
  title: string;
  onStart: () => void;
  teacher: TeacherEvaluationProgrammeParams['staff'];
  subjectLabel: TeacherEvaluationProgrammeParams['subjectLabel'];
}

export const SurveyIntro = ({ title, onStart, teacher, subjectLabel }: SurveyIntroProps) => {
  return (
    <View style={{ flex: 1 }}>
      <ScrollView style={{ paddingHorizontal: 20 }}>
        {title.length > 0 ? <Text style={styles.h1}>{title}</Text> : null}

        <View style={{ flexDirection: "column", marginTop: 12 }}>
          {[
            {
              id: "date",
              label: "Date",
              value: dayjs().format("ddd, DD MMM, YYYY"),
            },
          ].map(({ id, label, value }) => {
            return (
              <Text key={id}>
                <Text style={styles.h2}>{label}:</Text>{" "}
                <Text
                  style={{
                    ...styles.p,
                    textDecorationStyle: "solid",
                    textDecorationLine: "underline",
                  }}
                >
                  {value}
                </Text>
              </Text>
            );
          })}

          <View
            style={{ flexDirection: "row", gap: 12, alignItems: "center", marginTop: 16 }}
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

            <View>
              <Text style={styles.p}>
                {teacher?.name?.trim()?.replace(/\s+/g, " ")}
              </Text>
              <Text style={styles.subtitle}>{subjectLabel}</Text>
            </View>
          </View>
        </View>

        <Text style={styles.h2}>Instructions:</Text>
        <Text style={styles.p}>
          Please take a few minutes to answer the following questions about your
          teacher.{"\n"}Your honest feedback will help improve teaching and
          learning in our school.{"\n"}Your answers are anonymous.
        </Text>

        <Text style={styles.h3}>Scale:</Text>
        <View style={{ flexDirection: "column" }}>
          {[
            ["10", "outstanding"],
            ["9-8", "excellent"],
            ["7-6", "good"],
            ["5-4", "average"],
            ["3-2", "poor"],
            ["1", "unacceptable"],
          ].map(([value, label]) => {
            return (
              <Text
                key={label}
                style={[styles.p, { textTransform: "capitalize" }]}
              >
                <Text style={{}}>{value}</Text> = {label}
              </Text>
            );
          })}
        </View>
      </ScrollView>

      <SafeAreaView
        mode="padding"
        edges={["right", "bottom", "left"]}
        style={{
          paddingHorizontal: 20,
          paddingVertical: 12,
        }}
      >
        <TouchableHighlight
          style={styles.ctaButton}
          underlayColor={"#043682"}
          onPress={() => onStart()}
        >
          <Text style={styles.ctaLabel}>Give Feedback</Text>
        </TouchableHighlight>
      </SafeAreaView>
    </View>
  );
};

const styles = StyleSheet.create({
  h1: {
    fontSize: 24,
    lineHeight: 24 * 1.4,
    fontFamily: "georgia-bold",
    fontWeight: 'bold',
    marginTop: 16,
    color: '#343434',
  },
  h2: {
    fontSize: 18,
    lineHeight: 18 * 1.6,
    fontFamily: "georgia-bold",
    fontWeight: 'bold',
    marginTop: 16,
    color: '#343434',
  },
  h3: {
    fontSize: 17,
    lineHeight: 17 * 1.5,
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
    color: "#323222",
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
