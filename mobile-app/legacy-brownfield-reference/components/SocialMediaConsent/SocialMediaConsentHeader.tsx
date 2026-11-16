import * as React from "react";
import {
  Image,
  Platform,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  ViewStyle,
} from "react-native";
import type { Source } from "react-native-pdf";
import ReactNativeBlobUtil from "react-native-blob-util";

import { Header } from "../Header/Header";
import Toast from "react-native-toast-message";
import RNHapticFeedback from "react-native-haptic-feedback";

export type SocialMediaConsentHeaderProps = {
  title: string;
  onBackPress?: () => void;
  style?: ViewStyle;
  downloadSource?: Source;
};

const _SocialMediaConsentHeader = ({
  title,
  onBackPress,
  style,
  downloadSource,
}: SocialMediaConsentHeaderProps) => {
  const timeoutRef = React.useRef<NodeJS.Timeout | null>(null);
  const [loading, setLoading] = React.useState(false);

  // Clear any pending timeouts when the component unmounts to prevent memory leaks
  React.useEffect(() => {
    return () => {
      if (timeoutRef.current !== null) {
        clearTimeout(timeoutRef.current);
      }
    };
  }, []);

  const dowloadPolicyFile = React.useCallback(async () => {
    const downloadUri = downloadSource?.uri;
    if (!downloadUri) {
      Toast.show({
        type: "error",
        text1: "Document Unavailable",
        text2: "File URI not available",
        topOffset: 100,
        position: "top",
      });
      return;
    }
    const { dirs } = ReactNativeBlobUtil.fs;
    const dirToSave = dirs.DocumentDir;
    const filePath = `${dirToSave}/mount-carmel-offline-till-nine-policy.pdf`;
    const configOptions = {
      fileCache: true,
      path: filePath,
      appendExt: "pdf",
      notification: true,
      IOSDownloadTask: true,
    };
    try {
      setLoading(true);
      const task = ReactNativeBlobUtil.config(configOptions!).fetch(
        "GET",
        downloadUri,
      );
      const res = await task;
      const downloadedPath = res.path();
      if (downloadedPath) {
        timeoutRef.current = setTimeout(() => {
          if (Platform.OS === "ios") {
            ReactNativeBlobUtil.ios.presentPreview(downloadedPath);
          } else {
            ReactNativeBlobUtil.android.actionViewIntent(
              downloadedPath,
              "application/pdf",
            );
          }
        }, 500);
        RNHapticFeedback.trigger("notificationSuccess");
        Toast.show({
          type: "success",
          text1: "Download Complete",
          text2: `PDF has been saved ${Platform.OS === "ios" ? "under Mount Carmel" : "to document"} folder on your device`,
          topOffset: 100,
          position: "top",
        });
      }
    } catch (error) {
      Toast.show({
        type: "error",
        text1: "Download Interrupted",
        text2:
          error?.message ||
          "We couldn't finish downloading the file and try again",
        topOffset: 100,
        position: "top",
      });
    } finally {
      setLoading(false);
    }
  }, [downloadSource]);

  const renderDownload = () => (
    <View style={[styles.container, style]}>
      <TouchableOpacity disabled={loading} onPress={dowloadPolicyFile}>
        <View style={styles.downloadButtonWrapper}>
          <Image
            source={require("../../assets/ic_square_arrow_down.png")}
            style={[
              styles.downloadIcon,
              loading ? styles.downloadLabelInactive : null,
            ]}
          />

          <Text
            style={[
              styles.downloadLabel,
              loading ? styles.downloadLabelInactive : null,
            ]}
            maxFontSizeMultiplier={1.2}
          >
            Download
          </Text>
        </View>
      </TouchableOpacity>
    </View>
  );

  if (Platform.OS === "android") {
    return (
      <Header
        title={title}
        onBackPress={onBackPress}
        rightComponent={downloadSource?.uri ? renderDownload() : null}
      />
    );
  }

  if (downloadSource?.uri) {
    return renderDownload();
  }

  return null;
};

export const HEADER_HEIGHT = 44;

const styles = StyleSheet.create({
  container: {
    flexDirection: "row",
    height: HEADER_HEIGHT,
    alignItems: "center",
    justifyContent: "flex-end",
    paddingHorizontal: Platform.select({ ios: 16, android: 0 }),
    paddingLeft: Platform.select({ android: 4 }),
    borderBottomColor: "#c6c6c6",
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  downloadButtonWrapper: {
    alignItems: "center",
    justifyContent: "center",
    paddingHorizontal: Platform.select({ ios: 12, android: 4 }),
    flexDirection: "row",
    gap: 4,
  },
  downloadIcon: {
    width: 20,
    height: 20,
    resizeMode: "contain",
    tintColor: "#007AFF",
  },
  downloadLabel: {
    fontSize: 16,
    lineHeight: 24,
    color: "#007AFF",
    fontFamily: "Georgia.ttf",
    textTransform: "capitalize",
    textAlignVertical: "center",
  },
  downloadLabelInactive: {
    color: "gray",
    tintColor: "gray",
  },
});

export const SocialMediaConsentHeader = React.memo(_SocialMediaConsentHeader);
