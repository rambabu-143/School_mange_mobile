import * as React from 'react';
import { ActivityIndicator, FlatList, Linking, StyleSheet, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import dayjs from 'dayjs';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useDateSheetQuery } from '@/queries/useDateSheetQuery';

export default function DateSheetScreen() {
  const dateSheetQuery = useDateSheetQuery();
  const theme = useTheme();

  if (dateSheetQuery.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <FlatList
        data={dateSheetQuery.data ?? []}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.listContent}
        style={{ backgroundColor: theme.background }}
        renderItem={({ item }) => (
          <TouchableOpacity
            style={[styles.card, { backgroundColor: theme.backgroundElement }]}
            disabled={!item.attachment}
            onPress={() => item.attachment && Linking.openURL(`${item.path ?? ''}/${item.attachment}`)}>
            <ThemedText style={styles.title}>{item.title}</ThemedText>
            {item.text ? <ThemedText themeColor="textSecondary" style={styles.text}>{item.text}</ThemedText> : null}
            {item.createdAt ? (
              <ThemedText themeColor="textSecondary" style={styles.date}>
                {dayjs(item.createdAt).format('DD-MM-YYYY')}
              </ThemedText>
            ) : null}
          </TouchableOpacity>
        )}
        ListEmptyComponent={
          <ThemedView style={styles.centered}>
            <ThemedText themeColor="textSecondary" style={styles.text}>
              {dateSheetQuery.isError ? dateSheetQuery.error.message : 'No date sheet found.'}
            </ThemedText>
          </ThemedView>
        }
        refreshing={dateSheetQuery.isRefetching}
        onRefresh={() => dateSheetQuery.refetch()}
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
