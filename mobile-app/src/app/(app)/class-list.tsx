import * as React from 'react';
import { ActivityIndicator, FlatList, Image, Modal, Pressable, StyleSheet, Text, TextInput, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { SelectModal } from '@/components/select-modal';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useClassListQuery, type ClassListStudent } from '@/queries/useClassListQuery';
import { useClassSectionDropdownQuery } from '@/queries/useClassSectionDropdownQuery';

const matches = (s: { name?: string | null; admissionNo?: string | null }, q: string) =>
  !q || (s.name ?? '').toLowerCase().includes(q.toLowerCase()) || (s.admissionNo ?? '').toLowerCase().includes(q.toLowerCase());

function attendancePercentage(student: ClassListStudent) {
  if (!student.totalDays) return null;
  return ((student.totalPresent ?? 0) * 100) / student.totalDays;
}

export default function ClassListScreen() {
  const theme = useTheme();
  const [pickerVisible, setPickerVisible] = React.useState(false);
  const [sectionId, setSectionId] = React.useState<string | null>(null);
  const [search, setSearch] = React.useState('');
  const [selected, setSelected] = React.useState<ClassListStudent | null>(null);

  const dropdownQuery = useClassSectionDropdownQuery();
  const classListQuery = useClassListQuery(sectionId);
  const sectionLabel = dropdownQuery.data?.find((s) => s.id === sectionId)?.label;

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <Pressable style={[styles.picker, { backgroundColor: theme.backgroundElement }]} onPress={() => setPickerVisible(true)}>
        <ThemedText style={styles.pickerLabel}>{sectionLabel ?? 'Select class'}</ThemedText>
        <ThemedText themeColor="textSecondary" style={styles.pickerChevron}>▾</ThemedText>
      </Pressable>

      <TextInput
        placeholder="Search by name or admission no."
        placeholderTextColor={theme.textSecondary}
        value={search}
        onChangeText={setSearch}
        style={[styles.searchInput, { color: theme.text }]}
      />

      {classListQuery.isLoading ? (
        <ThemedView style={styles.centered}>
          <ActivityIndicator size="large" color="#2658A5" />
        </ThemedView>
      ) : (
        <FlatList
          data={(classListQuery.data ?? []).filter((s) => matches(s, search))}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.listContent}
          renderItem={({ item }) => (
            <Pressable style={[styles.card, { backgroundColor: theme.backgroundElement }]} onPress={() => setSelected(item)}>
              {item.profilePic ? (
                <Image source={{ uri: item.profilePic }} style={styles.avatar} />
              ) : (
                <View style={[styles.avatar, styles.avatarPlaceholder]}>
                  <Text style={styles.avatarInitial}>{(item.name ?? '?').charAt(0).toUpperCase()}</Text>
                </View>
              )}
              <View style={{ flex: 1 }}>
                <ThemedText style={styles.name}>{item.name}</ThemedText>
                <ThemedText themeColor="textSecondary" style={styles.meta}>{item.admissionNo}</ThemedText>
              </View>
            </Pressable>
          )}
          ListEmptyComponent={
            <ThemedView style={styles.centered}>
              <ThemedText themeColor="textSecondary" style={styles.text}>
                {classListQuery.isError ? classListQuery.error.message : sectionId ? 'No students found.' : 'Select a class to view students.'}
              </ThemedText>
            </ThemedView>
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

      <Modal visible={!!selected} transparent animationType="fade" onRequestClose={() => setSelected(null)}>
        <Pressable style={styles.backdrop} onPress={() => setSelected(null)}>
          <Pressable style={[styles.detailSheet, { backgroundColor: theme.backgroundElement }]} onPress={(e) => e.stopPropagation()}>
            <ThemedText style={styles.detailTitle}>
              {selected?.name} - {selected?.admissionNo}
            </ThemedText>
            <ThemedText style={styles.detailRow}>a) Mobile no. for SMS: {selected?.smsMobile}</ThemedText>
            <ThemedText style={styles.detailRow}>b) WISE: {selected?.wiseTotal}</ThemedText>
            <ThemedText style={styles.detailRow}>c) Disciplinary cards: {selected?.disciplinaryTotal}</ThemedText>
            <ThemedText style={styles.detailRow}>
              d) Total attendance: {selected?.totalPresent}/{selected?.totalDays} (
              {attendancePercentage(selected ?? ({} as ClassListStudent))?.toFixed(2) ?? '—'}%)
            </ThemedText>
            <ThemedText style={styles.detailRow}>e) Today&apos;s attendance: {selected?.todayAttendance}</ThemedText>
          </Pressable>
        </Pressable>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  picker: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    margin: 12,
    padding: 12,
    borderRadius: 8,
  },
  searchInput: { borderWidth: 1, borderColor: '#8884', borderRadius: 8, marginHorizontal: 12, paddingHorizontal: 12, paddingVertical: 8, fontSize: 14 },
  pickerLabel: { fontSize: 15 },
  pickerChevron: { fontSize: 14 },
  listContent: { gap: 12, padding: 12 },
  card: { flexDirection: 'row', alignItems: 'center', gap: 12, padding: 12, borderRadius: 8 },
  avatar: { width: 48, height: 48, borderRadius: 24 },
  avatarPlaceholder: { backgroundColor: '#2658A5', alignItems: 'center', justifyContent: 'center' },
  avatarInitial: { color: '#fff', fontSize: 18, fontWeight: '700' },
  name: { fontSize: 15, fontWeight: '600' },
  meta: { fontSize: 13 },
  text: { fontSize: 14, textAlign: 'center', paddingHorizontal: 24 },
  backdrop: { flex: 1, backgroundColor: '#00000066', justifyContent: 'center', padding: 24 },
  detailSheet: { borderRadius: 8, padding: 16, gap: 8 },
  detailTitle: { fontSize: 16, fontWeight: '700', marginBottom: 4 },
  detailRow: { fontSize: 14 },
});
