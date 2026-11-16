import dayjs from 'dayjs';
import * as React from 'react';
import { ActivityIndicator, FlatList, Image, Pressable, StyleSheet, Text, TextInput, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { SelectModal } from '@/components/select-modal';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useClassSectionDropdownQuery } from '@/queries/useClassSectionDropdownQuery';
import { TermAttendanceStudent, useTermAttendanceQuery } from '@/queries/useTermAttendanceQuery';

const TERMS = ['1', '2', '3'] as const;
const TERM_LABELS = { '1': 'Term 1', '2': 'Term 2', '3': 'Term 1 & 2' } as const;

function percentage(student: TermAttendanceStudent) {
  if (!student.totalDays) return '0%';
  const value = ((student.totalPresent ?? 0) * 100) / student.totalDays;
  return `${Number.isInteger(value) ? value : value.toFixed(2)}%`;
}

export default function TermAttendanceScreen() {
  const [pickerVisible, setPickerVisible] = React.useState(false);
  const [sectionId, setSectionId] = React.useState<string | null>(null);
  const [term, setTerm] = React.useState<(typeof TERMS)[number]>('1');
  const [search, setSearch] = React.useState('');

  const dropdownQuery = useClassSectionDropdownQuery();
  const section = dropdownQuery.data?.find((s) => s.id === sectionId);
  const termAttendanceQuery = useTermAttendanceQuery(section?.standardId ?? null, section?.id ?? null, term);
  const theme = useTheme();

  const filtered = (termAttendanceQuery.data ?? []).filter(
    (s) =>
      !search ||
      s.name?.toLowerCase().includes(search.toLowerCase()) ||
      s.admissionNo?.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <View style={styles.filters}>
        <Pressable style={[styles.picker, { backgroundColor: theme.backgroundElement }]} onPress={() => setPickerVisible(true)}>
          <ThemedText style={styles.pickerLabel}>{section?.label ?? 'Select class'}</ThemedText>
        </Pressable>
        <View style={styles.termRow}>
          {TERMS.map((t) => (
            <Pressable
              key={t}
              style={[styles.termButton, { backgroundColor: theme.backgroundElement }, term === t && styles.termButtonActive]}
              onPress={() => setTerm(t)}>
              <ThemedText style={[styles.termLabel, term === t && styles.termLabelActive]}>{TERM_LABELS[t]}</ThemedText>
            </Pressable>
          ))}
        </View>
        <TextInput
          placeholder="Search by name or admission no."
          placeholderTextColor={theme.textSecondary}
          value={search}
          onChangeText={setSearch}
          style={[styles.searchInput, { color: theme.text }]}
        />
        <ThemedText themeColor="textSecondary" style={styles.totalLabel}>Total: {filtered.length}</ThemedText>
      </View>

      {termAttendanceQuery.isLoading ? (
        <View style={styles.centered}>
          <ActivityIndicator size="large" color="#2658A5" />
        </View>
      ) : (
        <FlatList
          data={filtered}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.listContent}
          renderItem={({ item, index }) => (
            <ThemedView type="backgroundElement" style={styles.card}>
              {item.profilePic ? (
                <Image source={{ uri: item.profilePic }} style={styles.avatar} />
              ) : (
                <View style={[styles.avatar, styles.avatarPlaceholder]}>
                  <Text style={styles.avatarInitial}>{(item.name ?? '?').charAt(0).toUpperCase()}</Text>
                </View>
              )}
              <ThemedText themeColor="textSecondary" style={styles.serial}>{index + 1}</ThemedText>
              <View style={{ flex: 1 }}>
                <ThemedText style={[styles.name, item.dateOfWithdrawal && styles.withdrawn]}>
                  {item.name}
                  {item.dateOfWithdrawal ? `\n(DOW: ${dayjs(item.dateOfWithdrawal).format('DD-MM-YYYY')})` : ''}
                </ThemedText>
                <ThemedText themeColor="textSecondary" style={[styles.meta, item.dateOfWithdrawal && styles.withdrawn]}>
                  {item.admissionNo}
                </ThemedText>
              </View>
              <View style={styles.statsCol}>
                <ThemedText style={styles.stats}>
                  {item.totalDays}/{item.totalPresent}
                </ThemedText>
                <Text style={styles.percentage}>{percentage(item)}</Text>
              </View>
            </ThemedView>
          )}
          ListEmptyComponent={
            <View style={styles.centered}>
              <ThemedText themeColor="textSecondary" style={styles.text}>
                {termAttendanceQuery.isError ? termAttendanceQuery.error.message : sectionId ? 'No students found.' : 'Select a class to view attendance.'}
              </ThemedText>
            </View>
          }
        />
      )}

      <SelectModal
        visible={pickerVisible}
        title="Select class"
        options={dropdownQuery.data ?? []}
        selectedIds={sectionId ? [sectionId] : []}
        onClose={() => setPickerVisible(false)}
        onChange={([id]) => setSectionId(id)}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  filters: { padding: 12, gap: 8 },
  picker: { padding: 12, borderRadius: 8 },
  pickerLabel: { fontSize: 15 },
  termRow: { flexDirection: 'row', gap: 8 },
  termButton: { flex: 1, alignItems: 'center', paddingVertical: 8, borderRadius: 8 },
  termButtonActive: { backgroundColor: '#2658A5' },
  termLabel: { fontSize: 13 },
  termLabelActive: { color: '#fff', fontWeight: '700' },
  searchInput: { borderWidth: 1, borderColor: '#8884', borderRadius: 8, paddingHorizontal: 12, paddingVertical: 8, fontSize: 14 },
  totalLabel: { fontSize: 13 },
  listContent: { gap: 12, padding: 12, paddingTop: 0 },
  card: { flexDirection: 'row', alignItems: 'center', gap: 10, padding: 12, borderRadius: 8 },
  avatar: { width: 40, height: 40, borderRadius: 20 },
  avatarPlaceholder: { backgroundColor: '#2658A5', alignItems: 'center', justifyContent: 'center' },
  avatarInitial: { color: '#fff', fontSize: 16, fontWeight: '700' },
  serial: { fontSize: 12, width: 20, textAlign: 'center' },
  name: { fontSize: 14, fontWeight: '600' },
  meta: { fontSize: 12 },
  withdrawn: { color: '#c0392b' },
  statsCol: { alignItems: 'flex-end' },
  stats: { fontSize: 13 },
  percentage: { fontSize: 13, fontWeight: '600', color: '#2658A5' },
  text: { fontSize: 14, textAlign: 'center', paddingHorizontal: 24 },
});
