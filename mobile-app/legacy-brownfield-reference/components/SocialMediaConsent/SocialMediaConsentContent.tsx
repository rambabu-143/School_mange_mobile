import * as React from "react";
import { Animated, Linking, StyleSheet, Text, View } from "react-native";
import Pdf, { Source } from "react-native-pdf";
import Toast from "react-native-toast-message";

export type SocialMediaConsentContentProps = {
  source: Source;
  onEndReached?: () => void;
};

const _SocialMediaConsentContent: React.FC<SocialMediaConsentContentProps> = ({
  source,
  onEndReached,
}) => {
  const [isLoading, setIsLoading] = React.useState(true);
  const progressAnimRef = React.useRef(new Animated.Value(0));

  const handleLinkPress = React.useCallback(async (url: string) => {
    if (await Linking.canOpenURL(url)) {
      Linking.openURL(url);
    }
  }, []);

  const handlePDFError = React.useCallback((error: any) => {
    setIsLoading(false);

    let errorTitle = null;
    let errorDescription = null;

    if (error?.message?.includes?.("404")) {
      errorTitle = "Not Found";
      errorDescription = "PDF file not found";
    } else if (error?.message?.includes?.("password")) {
      errorTitle = "Password Required";
      errorDescription = "This PDF is password-protected";
    } else {
      errorTitle = "Error";
      errorDescription = `Failed to load PDF: ${error?.message}`;
    }

    if (errorTitle !== null) {
      Toast.show({
        type: "error",
        text1: errorTitle,
        text2: errorDescription,
        topOffset: 100,
        position: "top",
      });
    }
  }, []);

  const handlePageChanged = React.useCallback(
    (page: number, numberOfPages: number) => {
      if (page + 1 === numberOfPages) {
        onEndReached?.();
      }
    },
    [onEndReached],
  );

  const handleLoadProgress = React.useCallback((percent: number) => {
    Animated.timing(progressAnimRef.current, {
      toValue: percent,
      duration: 250, // Smooths the jumps between progress callbacks
      useNativeDriver: true, // Offloads to UI thread
    }).start();
  }, []);

  const handleLoadComplete = React.useCallback((numberOfPages: number) => {
    setIsLoading(false);
  }, []);

  const translateX = progressAnimRef.current.interpolate({
    inputRange: [0, 1],
    outputRange: ["-100%", "0%"],
  });

  return (
    <View style={styles.container}>
      {isLoading && (
        <View style={styles.loadingOverlay}>
          <Text style={styles.loadingText}>Loading Document...</Text>

          <View style={styles.progressBarBackground}>
            <Animated.View
              style={[styles.progressBarFill, { transform: [{ translateX }] }]}
            />
          </View>
        </View>
      )}

      <Pdf
        source={source}
        style={styles.pdf}
        enableAntialiasing={true}
        fitPolicy={0} // Fit to width
        enablePaging={false} // Allow continuous scroll
        onLoadProgress={handleLoadProgress}
        onLoadComplete={handleLoadComplete}
        onPageChanged={handlePageChanged}
        onError={handlePDFError}
        onPressLink={handleLinkPress}
        trustAllCerts={false}
      />
    </View>
  );
};

export const SocialMediaConsentContent = React.memo(_SocialMediaConsentContent);

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  pdf: {
    flex: 1,
  },
  loadingOverlay: {
    ...StyleSheet.absoluteFillObject,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "rgba(255, 255, 255, 0.95)",
    zIndex: 10,
  },
  loadingText: {
    marginBottom: 12,
    fontSize: 14,
    fontWeight: "600",
    color: "#333",
  },
  progressBarBackground: {
    width: "60%",
    height: 8,
    backgroundColor: "#E5E5EA",
    borderRadius: 4,
    overflow: "hidden", // Crucial: hides the translated bar outside the container
  },
  progressBarFill: {
    ...StyleSheet.absoluteFillObject, // Fills parent, position handled by translate
    backgroundColor: "#007AFF",
    borderRadius: 4,
  },
});
