import * as React from "react";
import { RefreshControl, ScrollView } from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";

import { Installments } from "./components/Installments";
import { Footer } from "./components/Footer";
import { Header } from "./components/Header";
import type { PayBillScreenParams } from "../../types";
import { PaymentOptionModal } from "./components/PaymentOptionModal";
import { PaymentProcessingModal } from "./components/PaymentProcessingModal";

export type PayBillContentProps = {
  params?: PayBillScreenParams;
  refreshing?: boolean;
  onRefresh?: () => void;
};

const _PayBillContent: React.FC<PayBillContentProps> = ({
  params,
  refreshing,
  onRefresh,
}) => {
  const { bottom: bottomSafeAreaInset } = useSafeAreaInsets();

  const personalExpSpace = params?.type === "hostel" ? 82 : 0;

  return (
    <>
      <ScrollView
        refreshControl={
          <RefreshControl
            refreshing={refreshing || false}
            tintColor={"#2658A5"}
            progressBackgroundColor={"#ffffff"}
            colors={["#2658A5"]}
            onRefresh={onRefresh}
          />
        }
        contentContainerStyle={{
          gap: 8,
          paddingBottom: 132 + personalExpSpace,
        }}
        scrollIndicatorInsets={{
          bottom: 108 - bottomSafeAreaInset + 8 + personalExpSpace,
        }}
      >
        <Header params={params} />

        <Installments params={params} />
      </ScrollView>

      <Footer params={params} />

      <PaymentOptionModal params={params} />

      <PaymentProcessingModal params={params} />
    </>
  );
};

export const PayBillContent = React.memo(_PayBillContent);
