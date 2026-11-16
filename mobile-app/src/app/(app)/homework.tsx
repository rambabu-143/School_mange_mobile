import * as React from 'react';
import { ActivityIndicator, FlatList, Linking, Pressable, StyleSheet, TextInput, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import dayjs from 'dayjs';

import { SelectModal, SelectModalOption } from '@/components/select-modal';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useSessionStore } from '@/lib/session-store';
import { useHomeworkQuery } from '@/queries/useHomeworkQuery';
import { useProfileDetailQuery } from '@/queries/useProfileDetailQuery';

// Native: month spinner spans the whole academic session, defaulting to the current month - same
// approximation used by assignment-list.tsx (Indian academic year from yearSession).
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

export default function HomeworkScreen() {
  const theme = useTheme();
  const session = useSessionStore((s) => s.session);
  const [subjectPickerVisible, setSubjectPickerVisible] = React.useState(false);
  const [monthPickerVisible, setMonthPickerVisible] = React.useState(false);
  const [subjectId, setSubjectId] = React.useState<string | null>(null);
  const [monthId, setMonthId] = React.useState(() => dayjs().format('YYYY-MM'));
  const [search, setSearch] = React.useState('');

  const profileDetailQuery = useProfileDetailQuery();
  const subjectOptions = profileDetailQuery.data?.subjectOptions ?? [];
  const selectedSubject = subjectOptions.find((s) => s.id === subjectId) ?? subjectOptions[0];
  const monthOptions = React.useMemo(() => monthOptionsFor(session?.yearSession), [session?.yearSession]);
  const selectedMonth = monthOptions.find((m) => m.id === monthId);

  const monthStart = dayjs(`${monthId}-01`);
  const homeworkQuery = useHomeworkQuery(
    selectedSubject?.id ?? null,
    monthStart.startOf('month').format('DD-MM-YYYY'),
    monthStart.endOf('month').format('DD-MM-YYYY')
  );

  // Native: live client-side filter over text/teacher name/attachment as you type.
  const filtered = (homeworkQuery.data ?? []).filter(
    (item) =>
      !search ||
      item.text?.toLowerCase().includes(search.toLowerCase()) ||
      item.teacherName?.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <View style={styles.filters}>
        <Pressable style={[styles.picker, { backgroundColor: theme.backgroundElement }]} onPress={() => setSubjectPickerVisible(true)} disabled={subjectOptions.length === 0}>
          <ThemedText style={styles.pickerLabel}>{selectedSubject?.label ?? 'Select subject'}</ThemedText>
        </Pressable>
        <Pressable style={[styles.picker, { backgroundColor: theme.backgroundElement }]} onPress={() => setMonthPickerVisible(true)}>
          <ThemedText style={styles.pickerLabel}>{selectedMonth?.label ?? 'Select month'}</ThemedText>
        </Pressable>
        <TextInput
          style={[styles.searchInput, { color: theme.text }]}
          placeholder="Search"
          placeholderTextColor={theme.textSecondary}
          value={search}
          onChangeText={setSearch}
        />
      </View>

      {profileDetailQuery.isLoading || homeworkQuery.isLoading ? (
        <ThemedView style={styles.centered}>
          <ActivityIndicator size="large" color="#2658A5" />
        </ThemedView>
      ) : (
        <FlatList
          data={filtered}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.listContent}
          renderItem={({ item }) => (
            <Pressable
              style={[styles.card, { backgroundColor: theme.backgroundElement }]}
              disabled={!item.attachment && !item.googleDriveLink}
              onPress={() =>
                item.googleDriveLink
                  ? Linking.openURL(item.googleDriveLink)
                  : item.attachment && Linking.openURL(`${item.path ?? ''}/${item.attachment}`)
              }>
              {item.text ? <ThemedText style={styles.text}>{item.text}</ThemedText> : null}
              <View style={styles.metaRow}>
                {item.date ? <ThemedText themeColor="textSecondary" style={styles.date}>Assigned on: {dayjs(item.date).isValid() ? dayjs(item.date).format('DD-MM-YYYY') : item.date}</ThemedText> : null}
                {item.teacherName ? <ThemedText themeColor="textSecondary" style={styles.date}>Assigned by: {item.teacherName}</ThemedText> : null}
              </View>
            </Pressable>
          )}
          ListEmptyComponent={
            <ThemedView style={styles.centered}>
              <ThemedText themeColor="textSecondary" style={styles.text}>
                {homeworkQuery.isError
                  ? homeworkQuery.error.message
                  : subjectOptions.length === 0
                    ? 'No subjects found.'
                    : 'No homework found for this month.'}
              </ThemedText>
            </ThemedView>
          }
          refreshing={homeworkQuery.isRefetching}
          onRefresh={() => homeworkQuery.refetch()}
        />
      )}

      <SelectModal
        visible={subjectPickerVisible}
        title="Select subject"
        options={subjectOptions}
        selectedIds={selectedSubject ? [selectedSubject.id] : []}
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
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  filters: { padding: 12, paddingBottom: 0, gap: 8 },
  picker: { padding: 12, borderRadius: 8 },
  pickerLabel: { fontSize: 15 },
  searchInput: { borderWidth: 1, borderColor: '#8884', borderRadius: 8, paddingHorizontal: 12, paddingVertical: 8, fontSize: 14 },
  listContent: { gap: 12, padding: 12 },
  card: { gap: 6, padding: 12, borderRadius: 8 },
  text: { fontSize: 14 },
  metaRow: { gap: 2 },
  date: { fontSize: 12 },
});
