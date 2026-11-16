import * as React from 'react';
import { ActivityIndicator, FlatList, Linking, Pressable, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import dayjs from 'dayjs';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { SelectModal, SelectModalOption } from '@/components/select-modal';
import { useAssignmentListQuery } from '@/queries/useAssignmentListQuery';
import { useProfileDetailQuery } from '@/queries/useProfileDetailQuery';
import { useSessionStore } from '@/lib/session-store';

// Native: month spinner spans the whole academic session (mSessionStartDate..mSessionEndDate),
// not just the current month. Session dates aren't in our session yet, so this approximates the
// Indian academic year (April-March) from yearSession ("2025-26") instead of the real session bounds.
function monthOptionsFor(yearSession?: string | null): SelectModalOption[] {
  const [startYearStr] = (yearSession ?? '').split('-');
  const startYear = Number(startYearStr) || dayjs().year();
  const months: SelectModalOption[] = [];
  for (let i = 0; i < 12; i++) {
    const date = dayjs(`${startYear}-04-01`).add(i, 'month');
    months.push({ id: date.format('YYYY-MM'), label: date.format('MMM YYYY') });
  }
  return months;
}

/** Native: AssignmentUpdatedFragment. Requires an explicit subject + month selection ("Select"
 * placeholders) and a "Go" tap before fetching - no auto-fetch/default like Homework. */
export default function AssignmentListScreen() {
  const theme = useTheme();
  const session = useSessionStore((s) => s.session);
  const profileDetailQuery = useProfileDetailQuery();
  const subjectOptions = profileDetailQuery.data?.subjectOptions ?? [];
  const monthOptions = React.useMemo(() => monthOptionsFor(session?.yearSession), [session?.yearSession]);

  const [subjectId, setSubjectId] = React.useState<string | null>(null);
  const [monthId, setMonthId] = React.useState<string | null>(null);
  const [subjectPickerVisible, setSubjectPickerVisible] = React.useState(false);
  const [monthPickerVisible, setMonthPickerVisible] = React.useState(false);
  const [queryParams, setQueryParams] = React.useState<{ subjectId: string; startDate: string; endDate: string } | null>(null);
  const [validationError, setValidationError] = React.useState<string | null>(null);

  const selectedSubject = subjectOptions.find((s) => s.id === subjectId);
  const selectedMonth = monthOptions.find((m) => m.id === monthId);

  const listQuery = useAssignmentListQuery(queryParams?.subjectId ?? null, queryParams?.startDate ?? null, queryParams?.endDate ?? null);

  const go = () => {
    if (!subjectId) return setValidationError('Please select subject');
    if (!monthId) return setValidationError('Please select month');
    setValidationError(null);
    const monthStart = dayjs(`${monthId}-01`);
    setQueryParams({
      subjectId,
      startDate: monthStart.startOf('month').format('DD-MM-YYYY'),
      endDate: monthStart.endOf('month').format('DD-MM-YYYY'),
    });
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <View style={styles.filters}>
        <Pressable style={[styles.picker, { backgroundColor: theme.backgroundElement }]} onPress={() => setSubjectPickerVisible(true)}>
          <ThemedText style={styles.pickerLabel}>{selectedSubject?.label ?? 'Select subject'}</ThemedText>
        </Pressable>
        <Pressable style={[styles.picker, { backgroundColor: theme.backgroundElement }]} onPress={() => setMonthPickerVisible(true)}>
          <ThemedText style={styles.pickerLabel}>{selectedMonth?.label ?? 'Select month'}</ThemedText>
        </Pressable>
        {validationError ? <Text style={styles.errorText}>{validationError}</Text> : null}
        <Pressable style={styles.goButton} onPress={go}>
          <Text style={styles.goLabel}>Go</Text>
        </Pressable>
      </View>

      {listQuery.isLoading ? (
        <ThemedView style={styles.centered}>
          <ActivityIndicator size="large" color="#2658A5" />
        </ThemedView>
      ) : (
        <FlatList
          data={listQuery.data ?? []}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.listContent}
          renderItem={({ item }) => (
            <Pressable
              style={[styles.card, { backgroundColor: theme.backgroundElement }]}
              disabled={!item.attachment}
              onPress={() => item.attachment && Linking.openURL(`${item.path ?? ''}/${item.attachment}`)}>
              <ThemedText style={styles.title}>{item.title}</ThemedText>
              {item.text ? <ThemedText themeColor="textSecondary" style={styles.text}>{item.text}</ThemedText> : null}
              {item.createdAt ? <ThemedText themeColor="textSecondary" style={styles.date}>{dayjs(item.createdAt).format('DD-MM-YYYY')}</ThemedText> : null}
            </Pressable>
          )}
          ListEmptyComponent={
            queryParams ? (
              <ThemedView style={styles.centered}>
                <ThemedText themeColor="textSecondary" style={styles.text}>{listQuery.isError ? listQuery.error.message : 'No assignments found.'}</ThemedText>
              </ThemedView>
            ) : null
          }
        />
      )}

      <SelectModal
        visible={subjectPickerVisible}
        title="Select subject"
        options={subjectOptions}
        selectedIds={subjectId ? [subjectId] : []}
        onClose={() => setSubjectPickerVisible(false)}
        onChange={([id]) => setSubjectId(id)}
      />
      <SelectModal
        visible={monthPickerVisible}
        title="Select month"
        options={monthOptions}
        selectedIds={monthId ? [monthId] : []}
        onClose={() => setMonthPickerVisible(false)}
        onChange={([id]) => setMonthId(id)}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 200, alignItems: 'center', justifyContent: 'center' },
  filters: { padding: 12, gap: 8 },
  picker: { padding: 12, borderRadius: 8 },
  pickerLabel: { fontSize: 15 },
  errorText: { color: '#c0392b', fontSize: 12 },
  goButton: { alignItems: 'center', paddingVertical: 10, borderRadius: 8, backgroundColor: '#2658A5' },
  goLabel: { color: '#ffffff', fontWeight: '700' },
  listContent: { gap: 12, padding: 12, paddingTop: 0 },
  card: { gap: 6, padding: 12, borderRadius: 8 },
  title: { fontSize: 16, fontWeight: '600' },
  text: { fontSize: 14 },
  date: { fontSize: 12 },
});
