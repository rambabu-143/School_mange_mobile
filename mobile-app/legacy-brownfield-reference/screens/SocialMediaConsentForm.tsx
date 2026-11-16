import * as React from "react";
import { StatusBar, StyleSheet, View } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import Toast from "react-native-toast-message";

import type { SocialMediaConsentFormParams } from "../types";
import { SocialMediaConsentFooter } from "../components/SocialMediaConsent/SocialMediaConsentFooter";
import { SocialMediaConsentContent } from "../components/SocialMediaConsent/SocialMediaConsentContent";
import { SocialMediaConsentHeader } from "../components/SocialMediaConsent/SocialMediaConsentHeader";

export type SocialMediaConsentFormProps = {
  params?: SocialMediaConsentFormParams;
};

export const SocialMediaConsentForm = ({
  params,
}: SocialMediaConsentFormProps) => {
  const isDarkMode = false;
  const backgroundStyle = {
    backgroundColor: isDarkMode ? "#000000" : "#ffffff",
  };
  const userHasReadPolicyRef = React.useRef(false);

  const handleConsentCheckboxPress = React.useCallback(() => {
    if (userHasReadPolicyRef.current) {
      return true;
    }
    Toast.show({
      type: "error",
      text1: "Please read the policy till the last page before accepting it.",
      topOffset: 100,
      position: "top",
    });
    return false;
  }, []);

  const handleEndReached = React.useCallback(() => {
    userHasReadPolicyRef.current = true;
  }, []);

  if (!params || !params.uri) {
    return null;
  }

  return (
    <SafeAreaView style={styles.container} edges={["top", "left", "right"]}>
      <StatusBar
        barStyle={isDarkMode ? "light-content" : "dark-content"}
        backgroundColor={backgroundStyle.backgroundColor}
      />

      <SocialMediaConsentHeader title={"Social Media Consent"} downloadSource={params} />

      <View style={styles.content}>
        <SocialMediaConsentContent
          source={params}
          onEndReached={handleEndReached}
        />

        <SocialMediaConsentFooter
          params={params}
          onCheckboxPress={handleConsentCheckboxPress}
        />
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
    backgroundColor: "#F8F9FA",
    overflow: "hidden",
    position: "relative",
    // marginTop: Platform.select({ ios: 12 }),
  },
  markdownContainer: {
    marginHorizontal: 20,
  },
});
