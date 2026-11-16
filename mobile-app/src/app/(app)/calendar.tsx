import * as React from 'react';
import { ActivityIndicator, FlatList, StyleSheet } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import dayjs from 'dayjs';
import { Calendar } from 'react-native-calendars';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { CalendarEntry, useSchoolCalendarQuery } from '@/queries/useSchoolCalendarQuery';

const KIND_COLOR: Record<CalendarEntry['kind'], string> = {
  event: '#2658A5',
  holiday: '#c99a00',
};

export default function SchoolCalendarScreen() {
  const calendarQuery = useSchoolCalendarQuery();
  const theme = useTheme();

  if (calendarQuery.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <FlatList
        data={calendarQuery.data ?? []}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.listContent}
        style={{ backgroundColor: theme.background }}
        ListHeaderComponent={
          <Calendar
            key={theme.background}
            markedDates={Object.fromEntries(
              (calendarQuery.data ?? []).map((e) => [dayjs(e.date).format('YYYY-MM-DD'), { marked: true, dotColor: KIND_COLOR[e.kind] }])
            )}
            theme={{ calendarBackground: theme.background, dayTextColor: theme.text, monthTextColor: theme.text, textDisabledColor: theme.textSecondary, arrowColor: '#2658A5' }}
          />
        }
        renderItem={({ item }) => (
          <ThemedView
            type="backgroundElement"
            style={[styles.card, { borderLeftColor: KIND_COLOR[item.kind] }]}>
            <ThemedText type="small" themeColor="textSecondary">
              {dayjs(item.date).format('DD-MM-YYYY (ddd)')}
            </ThemedText>
            <ThemedText type="smallBold">{item.title}</ThemedText>
          </ThemedView>
        )}
        ListEmptyComponent={
          <ThemedView style={styles.centered}>
            <ThemedText type="small" themeColor="textSecondary">
              {calendarQuery.isError ? calendarQuery.error.message : 'No calendar entries found!'}
            </ThemedText>
          </ThemedView>
        }
        refreshing={calendarQuery.isRefetching}
        onRefresh={() => calendarQuery.refetch()}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  listContent: { gap: 12, padding: 12 },
  card: {
    gap: 4,
    padding: 12,
    borderRadius: 8,
    borderLeftWidth: 4,
  },
});
