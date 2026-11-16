import * as React from 'react';
import { ActivityIndicator, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useProfileDetailQuery } from '@/queries/useProfileDetailQuery';
import { useSessionStore } from '@/lib/session-store';

function Row({ label, value }: { label: string; value?: string | null }) {
  if (!value) return null;
  return (
    <View style={styles.row}>
      <ThemedText themeColor="textSecondary" style={styles.label}>{label}</ThemedText>
      <ThemedText style={styles.value}>{value}</ThemedText>
    </View>
  );
}

/** Native: TransportFragment — staff's current route (transportId) or student/parent's latest transportAry entry. */
export default function TransportScreen() {
  const session = useSessionStore((s) => s.session);
  const profileDetailQuery = useProfileDetailQuery();
  const transport = profileDetailQuery.data?.transport;
  const theme = useTheme();

  if (profileDetailQuery.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  if (!transport) {
    return (
      <ThemedView style={styles.centered}>
        <ThemedText themeColor="textSecondary" style={styles.text}>No transport assigned.</ThemedText>
      </ThemedView>
    );
  }

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <View style={styles.content}>
        <ThemedView type="backgroundElement" style={styles.card}>
          <Row label="Morning route" value={transport.morning} />
          <Row label="Evening route" value={transport.evening} />
          <Row label="Pick-up stop" value={transport.pickup} />
          <Row label="Drop-off stop" value={transport.dropoff} />
          {session?.isStaff && (
            <>
              <Row label="From" value={transport.fromMonth} />
              <Row label="To" value={transport.toMonth} />
            </>
          )}
        </ThemedView>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  content: { padding: 16 },
  card: { gap: 12, padding: 16, borderRadius: 8 },
  row: { gap: 2 },
  label: { fontSize: 12, textTransform: 'uppercase', letterSpacing: 0.5 },
  value: { fontSize: 15 },
  text: { fontSize: 14 },
});
