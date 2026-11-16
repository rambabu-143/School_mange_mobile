import * as React from 'react';
import { ActivityIndicator, FlatList, Linking, StyleSheet, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import dayjs from 'dayjs';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { NoticeItem, useNoticesQuery } from '@/queries/useNoticesQuery';

export default function NoticesScreen() {
  const noticesQuery = useNoticesQuery();
  const theme = useTheme();

  const openAttachment = (item: NoticeItem) => {
    const attachment = item.attachments?.[0];
    if (!attachment) return;
    Linking.openURL(`${noticesQuery.data?.path ?? ''}/${attachment}`);
  };

  if (noticesQuery.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <FlatList
        data={noticesQuery.data?.data ?? []}
        keyExtractor={(item, index) => item._id ?? index.toString()}
        contentContainerStyle={styles.listContent}
        renderItem={({ item }) => (
          <TouchableOpacity
            style={[styles.card, { backgroundColor: theme.backgroundElement }]}
            disabled={!item.attachments?.[0]}
            onPress={() => openAttachment(item)}
          >
            <ThemedText style={styles.title}>{item.title}</ThemedText>
            {item.text ? <ThemedText themeColor="textSecondary" style={styles.text}>{item.text}</ThemedText> : null}
            <ThemedText themeColor="textSecondary" style={styles.date}>{dayjs(item.created_at).format('DD-MM-YYYY | hh:mm a')}</ThemedText>
          </TouchableOpacity>
        )}
        ListEmptyComponent={
          <ThemedView style={styles.centered}>
            <ThemedText themeColor="textSecondary" style={styles.text}>
              {noticesQuery.isError ? noticesQuery.error.message : 'No notices found!'}
            </ThemedText>
          </ThemedView>
        }
        refreshing={noticesQuery.isRefetching}
        onRefresh={() => noticesQuery.refetch()}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  listContent: { gap: 12, padding: 12 },
  card: {
    gap: 6,
    padding: 12,
    borderRadius: 8,
  },
  title: { fontSize: 16, fontWeight: '600' },
  text: { fontSize: 14 },
  date: { fontSize: 12 },
});
