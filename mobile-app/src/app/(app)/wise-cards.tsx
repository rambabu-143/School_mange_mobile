import dayjs from 'dayjs';
import * as React from 'react';
import { ActivityIndicator, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { WiseCardKey, useWiseCardsQuery } from '@/queries/useWiseCardsQuery';

const TYPES: { key: WiseCardKey; label: string; color: string }[] = [
  { key: 'worthy', label: 'Worthy', color: '#f3a53a' },
  { key: 'intellect', label: 'Intellect', color: '#3b82d6' },
  { key: 'stature', label: 'Stature', color: '#3aa76d' },
  { key: 'emotion', label: 'Emotion', color: '#d6557a' },
];

/** Native: WiseFragment (student/parent) — counts of WISE cards received, with the reason/teacher/date list per type. */
export default function WiseCardsScreen() {
  const theme = useTheme();
  const query = useWiseCardsQuery();
  const [selected, setSelected] = React.useState<WiseCardKey>('worthy');

  if (query.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  const entries = query.data?.[selected].entries ?? [];

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <View style={styles.tiles}>
        {TYPES.map((t) => (
          <Pressable
            key={t.key}
            style={[styles.tile, { backgroundColor: t.color }, selected === t.key && styles.tileActive]}
            onPress={() => setSelected(t.key)}>
            <Text style={styles.count}>{query.data?.[t.key].count ?? 0}</Text>
            <Text style={styles.label}>{t.label}</Text>
          </Pressable>
        ))}
      </View>
      <ScrollView contentContainerStyle={styles.list}>
        {query.isError ? <ThemedText themeColor="textSecondary">{query.error.message}</ThemedText> : null}
        {entries.length === 0 && !query.isError ? (
          <ThemedText themeColor="textSecondary" style={styles.empty}>No cards yet.</ThemedText>
        ) : null}
        {entries.map((e) => (
          <ThemedView key={e.id} type="backgroundElement" style={styles.card}>
            <ThemedText style={styles.reason}>{e.reason || '—'}</ThemedText>
            <ThemedText themeColor="textSecondary" style={styles.meta}>
              {e.staffName || '—'} · {e.date ? dayjs(e.date).format('DD-MM-YYYY') : ''}
            </ThemedText>
          </ThemedView>
        ))}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  tiles: { flexDirection: 'row', gap: 8, padding: 12 },
  tile: { flex: 1, alignItems: 'center', paddingVertical: 14, borderRadius: 10, opacity: 0.6 },
  tileActive: { opacity: 1, borderWidth: 2, borderColor: '#323232' },
  count: { fontSize: 22, fontWeight: '800', color: '#ffffff' },
  label: { fontSize: 12, fontWeight: '700', color: '#ffffff' },
  list: { padding: 12, paddingTop: 0, gap: 10 },
  empty: { textAlign: 'center', marginTop: 40 },
  card: { padding: 14, borderRadius: 8, gap: 4 },
  reason: { fontSize: 14 },
  meta: { fontSize: 12 },
});
