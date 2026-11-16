import Toast from 'react-native-toast-message';
import { useMutation, useQueryClient } from "@tanstack/react-query";

export type StudentRatingVarRequest = {
  is_final_submit: boolean;
  ratings: {
    question1: number | string;
    question2: number | string;
    question3: number | string;
    question4: number | string;
    question5: number | string;
    question6: number | string;
    question7: number | string;
    question8: number | string;
    question9: number | string;
    question10: number | string;
    question11: number | string;
    question12: number | string;
    question13: number | string;
    question14: number | string;
    question15: number | string;
    question16: number | string;
    question17: number | string;
    question18: number | string;
    question19: number | string;
    question20: number | string;
    question21: number | string;
    question22: number | string;
  };
};

export type StudentRatingFixRequest = {
  staff_id: string;
  standard_section_id: string;
  student_id: string;
  rating_by: string; // STUDENT
};

export type StudentRatingRequest = StudentRatingVarRequest &
  StudentRatingFixRequest;

export const useStudentRatingMutation = ({
  staffId,
  standardSectionId,
  studentId,
  ratingBy,
  token,
}: {
  staffId?: string;
  standardSectionId?: string;
  studentId?: string;
  ratingBy: "STUDENT";
  token?: string;
}) => {
  const queryClient = useQueryClient();

  const mutation = useMutation({
    // queryKey: ["student-rating", staffId, standardSectionId, studentId],
    mutationFn: async (variables: StudentRatingVarRequest) => {
      const BASE_URI = "https://mountcarmelschool.com:4201/";
      const STUDENT_RATING_URI = `${BASE_URI}staff-aar/rating`;

      if (!staffId || !studentId || !standardSectionId || !token) {
        return Promise.reject(
          new Error(`StaffId, StudentId, StandardSectionId and Token are required!!!`)
        );
      }

      const requestBody: StudentRatingRequest = {
        staff_id: staffId,
        student_id: studentId,
        standard_section_id: standardSectionId,
        rating_by: ratingBy,
        ...variables,
      };

      const response = await fetch(STUDENT_RATING_URI, {
        body: JSON.stringify(requestBody),
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token.replace('Bearer ', '')}`,
        },
      });

      // Check if the response status is not OK (2xx)
      if (!response.ok) {
        return Promise.reject(
          new Error(`HTTP error! Status: ${response.status}`)
        );
      }
      const result = await response.json();

      // Validate the response structure
      if (typeof result !== "object" || result === null) {
        return Promise.reject(new Error("Invalid response format"));
      }

      const { status, message } = result;
      if (!status) {
        return Promise.reject(new Error(`Error: ${message}`));
      }
      return null;
    },
    networkMode: "online",
    onSuccess(data, variables, context) {
      if (variables.is_final_submit) {
        queryClient.invalidateQueries({
          queryKey: ["student-rating"],
        });
      } else {
        Toast.show({
          type: 'success',
          text1: "Saved to draft successfully ✅",
          position: 'top',
          topOffset: 60,
        });
      }
    },
    onError(error, variables, context) {
      console.warn(error);
      Toast.show({
        type: 'error',
        text1: variables.is_final_submit
          ? "Error occurred while trying to save your answers!"
          : "Error occurred while trying to save your answers to draft!",
        text2: `${error.name}: ${error.message}`,
        topOffset: 100,
        position: 'top',
      });
    },
  });

  return mutation;
};
