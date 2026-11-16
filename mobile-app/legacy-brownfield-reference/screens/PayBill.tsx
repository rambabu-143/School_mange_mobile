import * as React from "react";
import { ActivityIndicator, StatusBar, StyleSheet, View } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";

import { Header } from "../components/Header/Header";
import type { PayBillScreenParams } from "../types";
import { useBillQuery } from "../queries/useBillQuery";
import { PayBillContent } from "../components/PayBillContent/PayBillContent";
import { useGlobalStore } from "../stores/global-store";

export type PayBillScreenProps = {
  params?: PayBillScreenParams;
};

export const PayBillScreen = ({ params }: PayBillScreenProps) => {
  const isDarkMode = false;
  const backgroundStyle = {
    backgroundColor: isDarkMode ? "#000000" : "#ffffff",
  };
  const resetPayBillSlice = useGlobalStore.getState().resetPayBillSlice;

  const billQuery = useBillQuery({
    token: params?.token,
    type: params?.type,
    studentOrStaffId:
      params?.userType === "member" ? params?.studentId : params?.staffId,
    userType: params?.userType === "member" ? "student" : "staff",
    refetchOnMount: true,
  });

  const headerTitle = params?.type ? `${params?.type} Fee` : "Pay Bill";

  React.useEffect(() => {
    return () => {
      resetPayBillSlice();
    };
  }, []);

  return (
    <SafeAreaView style={styles.container} edges={["top", "left", "right"]}>
      <StatusBar
        barStyle={isDarkMode ? "light-content" : "dark-content"}
        backgroundColor={backgroundStyle.backgroundColor}
      />

      <Header title={headerTitle} />

      <View style={styles.content}>
        {billQuery.isLoading ? (
          <View style={styles.loader}>
            <ActivityIndicator size={"large"} color={"#000000"} />
          </View>
        ) : billQuery.isSuccess ? (
          <PayBillContent
            params={params}
            onRefresh={billQuery.refetch}
            refreshing={billQuery.isRefetching}
          />
        ) : null}
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
    backgroundColor: "#f7f8f9",
    overflow: "hidden",
    position: "relative",
  },
  loader: { flex: 1, alignItems: "center", justifyContent: "center" },
});
