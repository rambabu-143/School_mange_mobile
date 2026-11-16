import React from "react";
import Toast from "react-native-toast-message";
import { SafeAreaProvider } from "react-native-safe-area-context";
import { QueryCache, QueryClient, QueryClientProvider } from "@tanstack/react-query";

import { NotFound } from "./screens/NotFound";
import { PayBillScreen } from "./screens/PayBill";
import { TeacherEvaluationProgramme } from "./screens/TeacherEvaluationProgramme";
import { StaffAttendance } from "./screens/StaffAttendance";
import { SocialMediaConsentForm } from "./screens/SocialMediaConsentForm";

const queryClient = new QueryClient({
  queryCache: new QueryCache({
    onError: (error, query) => {
      const friendlyErrorMessage = query.meta?.friendlyErrorMessage as string || "Something went wrong!";
      const techyErrorMessage = error.message;

      Toast.show({
        type: "error",
        text1: friendlyErrorMessage || techyErrorMessage,
        text2: friendlyErrorMessage ? techyErrorMessage : undefined,
        position: "bottom",
        bottomOffset: 100,
      });
    },
  }),
});

function App({ params, uri }) {
  return (
    <SafeAreaProvider>
      <QueryClientProvider client={queryClient}>
        {uri === "/rating" ? (
          <TeacherEvaluationProgramme params={params} />
        ) : uri === "/pay-bill" ? (
          <PayBillScreen params={params} />
        ) : uri === "/my-attendance" ? (
          <StaffAttendance params={params} />
        ) : uri === "/social-media-consent-form" ? (
          <SocialMediaConsentForm params={params} />
        ) : (
          <NotFound />
        )}
        <Toast />
      </QueryClientProvider>
    </SafeAreaProvider>
  );
}

export default App;
