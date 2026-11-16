import { useQuery } from "@tanstack/react-query";

export type SavedStudentRating = {
  _id?: string;
  student_id?: string;
  is_final_submit?: Boolean;
  ratings?: {
    question1?: number | string;
    question2?: number | string;
    question3?: number | string;
    question4?: number | string;
    question5?: number | string;
    question6?: number | string;
    question7?: number | string;
    question8?: number | string;
    question9?: number | string;
    question10?: number | string;
    question11?: number | string;
    question12?: number | string;
    question13?: number | string;
    question14?: number | string;
    question15?: number | string;
    question16?: number | string;
    question17?: number | string;
    question18?: number | string;
    question19?: number | string;
    question20?: number | string;
    question21?: number | string;
    question22?: number | string;
  };
};

export const useStudentRatingQuery = ({
  staffId,
  standardSectionId,
  studentId,
  token,
}) => {
  const query = useQuery({
    queryKey: ["student-rating", staffId, standardSectionId, studentId],
    queryFn: async ({ signal, queryKey }) => {
      const [_uniqueKey, staffId, standardSectionId, studentId] = queryKey;

      const BASE_URI = "https://mountcarmelschool.com:4201/";
      const STUDENT_RATING_URI = `${BASE_URI}staff-aar/rating/student-rating/${staffId}/${standardSectionId}/${studentId}`;

      const response = await fetch(STUDENT_RATING_URI, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token.replace('Bearer ', '')}`,
        },
        signal,
      });

      // Check if the response status is not OK (2xx)
      if (!response.ok) {
        return Promise.reject(
          new Error(`HTTP error! Status: ${response.status}`)
        );
      }
      const result:
        | { status?: boolean; message?: string; data?: SavedStudentRating }
        | undefined
        | null = await response.json();

      // Validate the response structure
      if (typeof result !== "object" || result === null) {
        return Promise.reject(new Error("Invalid response format"));
      }
      const { data, status, message } = result;

      if (!status && !!message && message.toLowerCase() !== 'data not found') {
        return Promise.reject(new Error(`Error: ${message}`));
      }
      return data || null;
    },
    refetchOnMount: false,
    meta: {
      friendlyErrorMessage: "Unable to fetch Survey data!",
    },
  });

  return query;
};
