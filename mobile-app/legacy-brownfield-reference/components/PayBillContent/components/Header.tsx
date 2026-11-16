import * as React from "react";
import { Image, StyleSheet, Text, View } from "react-native";

import { ThemedText } from "../../ThemedText";
import { Card } from "../../Card";
import type { PayBillScreenParams } from "../../../types";
import { useBillQuery } from "../../../queries/useBillQuery";

export type HeaderProps = {
  params?: PayBillScreenParams;
};

const _Header: React.FC<HeaderProps> = ({ params }) => {
  const billQuery = useBillQuery({
    token: params?.token,
    type: params?.type,
    studentOrStaffId:
      params?.userType === "member" ? params?.studentId : params?.staffId,
    userType: params?.userType === "member" ? "student" : "staff",
  });

  const data = billQuery.data?.data;

  const billData =
    params?.type === "transport"
      ? data?.transport_bill_id
      : params?.type === "hostel"
      ? data?.hostel_bill_id
      : data?.fee_bill_id;

  return (
    <Card style={styles.profileCard}>
      <View style={styles.flexView}>
        <ThemedText
          maxFontSizeMultiplier={1.2}
          type="default"
          style={[styles.name, styles.label]}
        >
          Name:{"  "}
          <Text style={{ color: "#000000" }}>{billData?.name}</Text>
        </ThemedText>

        {params?.userType === "member" ? (
          <ThemedText
            maxFontSizeMultiplier={1.2}
            type="default"
            style={styles.label}
          >
            Admission No.:{"  "}
            <Text style={{ color: "#000000" }}>
              {billData?.admission_no || data?.admission_no}
            </Text>
          </ThemedText>
        ) : null}

        {params?.userType === "member" ? (
          <ThemedText
            maxFontSizeMultiplier={1.2}
            type="default"
            style={styles.label}
          >
            Class:{"  "}
            <Text style={{ color: "#000000" }}>
              {billData?.class} - {billData?.section}
            </Text>
          </ThemedText>
        ) : null}

        <ThemedText
          maxFontSizeMultiplier={1.2}
          type="default"
          style={styles.label}
        >
          Email:{"  "}
          <Text style={{ color: "#000000" }}>
            {params?.userEmail?.split("@").join("\n@")}
          </Text>
        </ThemedText>
      </View>

      {params?.userImageUri ? (
        <Image
          source={{
            uri: params?.userImageUri,
          }}
          style={styles.avatar}
          resizeMode="cover"
        />
      ) : null}
    </Card>
  );
};

const styles = StyleSheet.create({
  profileCard: {
    flexDirection: "row",
    gap: 16,
    alignItems: "flex-start",
    justifyContent: "space-between",

    padding: 20,
    borderRadius: 0,
    shadowColor: undefined,
    shadowOpacity: undefined,
    shadowOffset: undefined,
    shadowRadius: undefined,
    elevation: undefined,
  },
  avatar: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: "silver",
  },
  flexView: { flex: 1 },
  name: { textTransform: "capitalize" },
  label: { color: "#545454", gap: 8 },
});

export const Header = React.memo(_Header);
