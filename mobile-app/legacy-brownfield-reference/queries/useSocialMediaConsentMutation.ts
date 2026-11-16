import Toast from "react-native-toast-message";
import { useMutation } from "@tanstack/react-query";

import { SocialMediaConsentFormParams } from "../types";

export type SocialMediaConsentRequest = {
  is_agree: true;
  parent_name: string;
};

export type SocialMediaConsentResponse = {
  status?: boolean | null;
  message?: string | null;
};

export const useSocialMediaConsentMutation = (
  params: SocialMediaConsentFormParams | null | undefined,
) => {
  const mutation = useMutation({
    mutationFn: async (variables: SocialMediaConsentRequest) => {
      const BASE_URI = "https://mountcarmelschool.com:4201";
      const SOCIAL_MEDIA_CONSENT_URI = `${BASE_URI}/student/social-media-consent`;
      if (!params?.token) {
        return Promise.reject(new Error(`Authentication Token is required!!!`));
      }
      if (!params?.admissionNumber) {
        return Promise.reject(new Error(`Admission number is required!!!`));
      }
      if (!params?.studentId) {
        return Promise.reject(new Error(`Student id is required!!!`));
      }
      const requestBody = {
        ...variables,
        student_id: params.studentId,
        admission_no: params.admissionNumber,
      };

      const response = await fetch(SOCIAL_MEDIA_CONSENT_URI, {
        body: JSON.stringify(requestBody),
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${params.token.replace("Bearer ", "")}`,
        },
      });
      // Check if the response status is not OK (2xx)
      if (!response.ok) {
        const errorData = await response.text();

        return Promise.reject(
          new Error(`${response.status} | ${response.statusText}`, {
            cause: errorData,
          }),
        );
      }
      const result = (await response.json()) as
        | SocialMediaConsentResponse
        | null
        | undefined;

      // Validate the response structure
      if (typeof result !== "object" || result === null) {
        return Promise.reject(new Error("Invalid response format"));
      }
      const { status, message } = result;

      if (!status) {
        return Promise.reject(new Error(message || "Unknown Error Occurred"));
      }
      return result;
    },
    networkMode: "online",
    onSuccess(data) {
      console.log("Social media consent submitted successfully", data);
      Toast.show({
        type: "success",
        text1: "Social media consent submitted successfully",
        text2: "Your social media consent has been saved successfully.",
        topOffset: 100,
        position: "top",
      });
    },
    onError(error) {
      console.warn(error.cause);
      Toast.show({
        type: "error",
        text1: "Error occurred while submitting social media consent",
        text2: `${error.name}: ${error.message}`,
        topOffset: 100,
        position: "top",
      });
    },
  });

  return mutation;
};
