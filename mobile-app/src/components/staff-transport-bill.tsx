import * as React from 'react';
import { ActivityIndicator, Linking, Pressable, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useQueryClient } from '@tanstack/react-query';
import * as WebBrowser from 'expo-web-browser';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { Card } from '@/design-system/card';
import { useTheme } from '@/hooks/use-theme';
import { useSessionStore } from '@/lib/session-store';
import { useStaffTransportBillQuery } from '@/queries/useStaffTransportBillQuery';
import { indianNumberFormatter } from '@/utils/indianNumberFormatter';

/** Staff variant of the Fee screen — a single transport-bill card (native FeeFragment.updateViewForStaff). */
export function StaffTransportBill() {
  const userId = useSessionStore((s) => s.session?.userId);
  const query = useStaffTransportBillQuery();
  const queryClient = useQueryClient();
  const theme = useTheme();
  const [paying, setPaying] = React.useState(false);

  if (query.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  const bill = query.data;
  if (!bill) {
    return (
      <ThemedView style={styles.centered}>
        <ThemedText themeColor="textSecondary">
          {query.isError ? query.error.message : 'No transport bill found.'}
        </ThemedText>
      </ThemedView>
    );
  }

  const pay = async () => {
    setPaying(true);
    try {
      await WebBrowser.openAuthSessionAsync(
        `https://www.mountcarmelschool.com/parent/payment/staff-transport-bill-app/${userId}`
      );
    } finally {
      setPaying(false);
      await queryClient.invalidateQueries({ queryKey: ['staff-transport-bill'] });
    }
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <View style={styles.content}>
        <ThemedText style={styles.title}>Transport Fee</ThemedText>
        <Card style={styles.card}>
          <Text style={styles.inst}>{bill.instNo ?? 'Current installment'}</Text>
          <View style={styles.row}>
            <Text style={styles.text}>Amount</Text>
            <Text style={styles.text}>{indianNumberFormatter(bill.amount)}</Text>
          </View>
          <View style={styles.row}>
            <Text style={styles.text}>Due</Text>
            <Text style={[styles.text, bill.due > 0 && styles.due]}>{indianNumberFormatter(bill.due)}</Text>
          </View>
          <View style={styles.actions}>
            {bill.filepath ? (
              <Pressable onPress={() => Linking.openURL(bill.filepath!)}>
                <Text style={styles.link}>View Bill</Text>
              </Pressable>
            ) : (
              <View />
            )}
            {bill.paid ? (
              <Text style={styles.paid}>Paid</Text>
            ) : bill.due > 0 ? (
              <Pressable style={[styles.payButton, paying && styles.payDisabled]} disabled={paying} onPress={pay}>
                {paying ? <ActivityIndicator color="#ffffff" /> : <Text style={styles.payLabel}>Pay Bill</Text>}
              </Pressable>
            ) : null}
          </View>
        </Card>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  content: { gap: 12, padding: 16 },
  title: { fontSize: 16, fontWeight: '600', marginLeft: 4 },
  card: { gap: 10 },
  inst: { fontSize: 16, fontWeight: '600', textTransform: 'capitalize' },
  row: { flexDirection: 'row', justifyContent: 'space-between' },
  text: { fontSize: 15 },
  due: { color: '#FF3B30', fontWeight: '600' },
  actions: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginTop: 4 },
  link: { color: '#2658A5', fontWeight: '600' },
  paid: { color: '#D32F2F', fontWeight: '700' },
  payButton: { paddingHorizontal: 20, paddingVertical: 10, borderRadius: 8, backgroundColor: '#3c87f7', minWidth: 96, alignItems: 'center' },
  payDisabled: { opacity: 0.5 },
  payLabel: { color: '#ffffff', fontWeight: '700' },
});
