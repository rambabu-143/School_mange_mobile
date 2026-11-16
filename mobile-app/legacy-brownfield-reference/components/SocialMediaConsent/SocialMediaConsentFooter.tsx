import * as React from "react";
import {
  ActivityIndicator,
  AlertButton,
  Image,
  Platform,
  StyleSheet,
  Text,
  TouchableHighlight,
  TouchableOpacity,
  View,
} from "react-native";
import Alert from "@blazejkustra/react-native-alert";
import { trigger } from "react-native-haptic-feedback";
import { SafeAreaView } from "react-native-safe-area-context";
import Toast from "react-native-toast-message";

import { useSocialMediaConsentMutation } from "../../queries/useSocialMediaConsentMutation";
import { SocialMediaConsentFormParams } from "../../types";
import NativeMountCarmelUtils from "../../../specs/NativeMountCarmelUtils";

export type SocialMediaConsentFooterProps = {
  params?: SocialMediaConsentFormParams;
  /**
   *
   * @returns boolean allows toggling checkbox state if true is returned
   */
  onCheckboxPress?: () => boolean | null;
  onSubmitPress?: (agree: boolean, name: string | null) => void;
};

const nameRegex = /^[a-zA-Z\s\-\']+$/;

const _SocialMediaConsentFooter: React.FC<SocialMediaConsentFooterProps> = ({
  params,
  onCheckboxPress,
  onSubmitPress,
}) => {
  const [agree, setAgree] = React.useState(false);
  const [errorVisible, setErrorVisible] = React.useState(false);

  const socialMediaConsentMutation = useSocialMediaConsentMutation(params);

  const submitLoading = socialMediaConsentMutation.isPending;

  const handleSubmitPress = () => {
    // show error when checkbox not active
    if (!agree) {
      setErrorVisible(true);
      onSubmitPress?.(agree, null);
      return;
    }
    const submitCallback: AlertButton["onPress"] = async (
      name: string | undefined,
    ) => {
      if (name && name.trim().length > 3 && nameRegex.test(name)) {
        onSubmitPress?.(agree, name);
        const result = await socialMediaConsentMutation.mutateAsync({
          is_agree: agree,
          parent_name: name.trim(),
        });
        if (result.status) {
          NativeMountCarmelUtils?.dismissSocialMediaConsentModal(true);
        }
      } else {
        Toast.show({
          type: "error",
          text1: "Please enter valid full name!",
          topOffset: 100,
          position: "top",
        });
        onSubmitPress?.(agree, name || null);
      }
    };
    // show name prompt
    Alert.prompt(
      "Almost done!",
      "To confirm your participation, please type your full name below",
      [
        {
          isPreferred: true,
          onPress: submitCallback,
          style: "default",
          text: "Confirm",
        },
      ],
      "plain-text",
    );
  };

  const consentCheckboxPress = () => {
    setErrorVisible(false);
    let canToggle = true;
    if (typeof onCheckboxPress === "function") {
      canToggle = onCheckboxPress() ?? canToggle;
    }
    if (canToggle) {
      setAgree((value) => !value);
      trigger(Platform.select({ ios: "selection", default: "impactLight" }), {
        enableVibrateFallback: true,
        ignoreAndroidSystemSettings: false,
      });
    }
  };

  return (
    <SafeAreaView style={styles.content} edges={["right", "bottom", "left"]}>
      <TouchableOpacity
        disabled={submitLoading}
        style={styles.checkboxContainer}
        onPress={consentCheckboxPress}
      >
        <Image
          source={
            agree
              ? require("../../assets/ic_checkbox_active.png")
              : require("../../assets/ic_checkbox_inactive.png")
          }
          style={[
            styles.checkboxImage,
            {
              tintColor: agree ? undefined : "#676767",
            },
          ]}
        />

        <Text maxFontSizeMultiplier={1.1} style={styles.describe}>
          I agree to follow and support the "OffLine till Nine" policy at home.
        </Text>
      </TouchableOpacity>

      {errorVisible ? (
        <Text maxFontSizeMultiplier={1.1} style={styles.error}>
          Please review the full policy to the end to continue.
        </Text>
      ) : null}

      <TouchableHighlight
        style={styles.payButton}
        disabled={submitLoading}
        underlayColor={styles.activeColor.color}
        onPress={handleSubmitPress}
      >
        <View style={styles.payButtonTextWrapper}>
          <Text
            style={[styles.payButtonText, { opacity: submitLoading ? 0 : 1 }]}
            maxFontSizeMultiplier={1.2}
          >
            Submit & view AR
          </Text>

          {submitLoading ? (
            <ActivityIndicator
              size={"small"}
              color={"#ffffff"}
              style={styles.loader}
            />
          ) : null}
        </View>
      </TouchableHighlight>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  content: {
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderTopColor: "#000000",
    borderTopWidth: StyleSheet.hairlineWidth,
    backgroundColor: "#F5F5F5",
    gap: 12,
  },
  describe: {
    flexShrink: 1,
    fontSize: 15,
    lineHeight: 15 * 1.5,
    color: "#000000",
  },
  error: {
    flexShrink: 1,
    fontSize: 14,
    lineHeight: 14 * 1.5,
    color: "red",
  },
  checkboxContainer: {
    flexDirection: "row",
    gap: 12,
  },
  checkboxImage: {
    width: 24,
    height: 24,
    resizeMode: "contain",
  },
  loader: {
    flex: 1,
    position: "absolute",
    alignSelf: "center",
  },
  payButtonTextWrapper: {
    position: "relative",
    alignItems: "center",
  },
  payButtonText: {
    fontSize: 17,
    lineHeight: 26,
    fontWeight: "bold",
    color: "#ffffff",
  },
  payButton: {
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 4,
    backgroundColor: "#2658A5",
  },
  activeColor: {
    color: "#043683",
  },
});

export const SocialMediaConsentFooter = React.memo(_SocialMediaConsentFooter);
