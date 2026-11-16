import React from "react";
import {
  StatusBar,
  StyleSheet,
  Text,
  View,
  Button,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";

import { Header } from "../components/Header/Header";
import { backToNativeApp } from "../utils/backToNativeApp";

export const NotFound = () => {
  const isDarkMode = false;
  const backgroundStyle = {
    backgroundColor: isDarkMode ? "#000000" : "#ffffff",
  };

  return (
    <SafeAreaView style={styles.container} edges={["top", "left", "right"]}>
      <StatusBar
        barStyle={isDarkMode ? "light-content" : "dark-content"}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <Header title={"Page Not Found"} />

      <View style={styles.content}>
        <Text style={styles.heading}>404</Text>

        <Text style={styles.subtitle}>Page Not Found!</Text>

        <Button title="Go back" onPress={() => backToNativeApp()} />
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
    alignItems: "center",
    justifyContent: "center",
    backgroundColor: "#efefef",
  },
  heading: {
    fontSize: 32,
    fontWeight: "bold",
    marginBottom: 12,
  },
  subtitle: {
    fontSize: 20,
    marginBottom: 24,
  },
});
