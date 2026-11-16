import * as React from 'react';
import { ActivityIndicator, FlatList, Linking, StyleSheet, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import dayjs from 'dayjs';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useSyllabusQuery } from '@/queries/useSyllabusQuery';

export default function SyllabusScreen() {
  const syllabusQuery = useSyllabusQuery();
  const theme = useTheme();

  if (syllabusQuery.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <FlatList
        data={syllabusQuery.data ?? []}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.listContent}
        renderItem={({ item }) => (
          <TouchableOpacity
            style={[styles.card, { backgroundColor: theme.backgroundElement }]}
            disabled={!item.attachment}
            onPress={() => item.attachment && Linking.openURL(`${item.path ?? ''}/${item.attachment}`)}>
            <ThemedText style={styles.title}>{item.title}</ThemedText>
            {item.createdAt ? (
              <ThemedText themeColor="textSecondary" style={styles.date}>{dayjs(item.createdAt).format('DD-MM-YYYY')}</ThemedText>
            ) : null}
          </TouchableOpacity>
        )}
        ListEmptyComponent={
          <ThemedView style={styles.centered}>
            <ThemedText themeColor="textSecondary" style={styles.text}>
              {syllabusQuery.isError ? syllabusQuery.error.message : 'No syllabus found.'}
            </ThemedText>
          </ThemedView>
        }
        refreshing={syllabusQuery.isRefetching}
        onRefresh={() => syllabusQuery.refetch()}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  listContent: { gap: 12, padding: 12 },
  card: { gap: 6, padding: 12, borderRadius: 8 },
  title: { fontSize: 16, fontWeight: '600' },
  text: { fontSize: 14 },
  date: { fontSize: 12 },
});
