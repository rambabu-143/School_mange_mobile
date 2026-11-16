import * as React from 'react';
import { ActivityIndicator, FlatList, Pressable, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { SelectModal } from '@/components/select-modal';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useSessionStore } from '@/lib/session-store';
import { useClassSectionDropdownQuery } from '@/queries/useClassSectionDropdownQuery';
import { useProfileDetailQuery } from '@/queries/useProfileDetailQuery';
import { TimetableByDay, useTimetableQuery } from '@/queries/useTimetableQuery';

const DAYS: { key: keyof TimetableByDay; label: string }[] = [
  { key: 'monday', label: 'Mon' },
  { key: 'tuesday', label: 'Tue' },
  { key: 'wednesday', label: 'Wed' },
  { key: 'thursday', label: 'Thu' },
  { key: 'friday', label: 'Fri' },
];

export default function TimetableScreen() {
  const session = useSessionStore((s) => s.session);
  const [day, setDay] = React.useState<keyof TimetableByDay>('monday');
  const [classPickerVisible, setClassPickerVisible] = React.useState(false);
  const [standardSectionId, setStandardSectionId] = React.useState<string | null>(null);

  const profileDetailQuery = useProfileDetailQuery();
  // Native reads the profile's access_standard_section; some staff accounts have none, so fall back to the
  // assigned-classes dropdown (same {id, standardId, label} shape) rather than showing an empty picker.
  const profileClasses = profileDetailQuery.data?.accessStandardSection ?? [];
  const dropdownQuery = useClassSectionDropdownQuery({ enabled: !!session?.isStaff && profileClasses.length === 0 });
  const classOptions = profileClasses.length ? profileClasses : (dropdownQuery.data ?? []);
  const selectedClass = classOptions.find((c) => c.id === standardSectionId);
  const timetableQuery = useTimetableQuery(session?.isStaff ? selectedClass?.standardId : undefined);
  const theme = useTheme();

  if (session?.isStaff && classOptions.length === 0 && (profileDetailQuery.isLoading || dropdownQuery.isLoading)) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      {session?.isStaff && (
        <Pressable style={[styles.classPicker, { backgroundColor: theme.backgroundElement }]} onPress={() => setClassPickerVisible(true)}>
          <ThemedText style={styles.classPickerLabel}>{selectedClass?.label ?? 'Select class'}</ThemedText>
        </Pressable>
      )}

      <View style={styles.dayRow}>
        {DAYS.map((d) => (
          <Pressable
            key={d.key}
            style={[styles.dayChip, { backgroundColor: theme.backgroundElement }, day === d.key && styles.dayChipActive]}
            onPress={() => setDay(d.key)}>
            <ThemedText style={[styles.dayLabel, day === d.key && styles.dayLabelActive]}>{d.label}</ThemedText>
          </Pressable>
        ))}
      </View>

      {timetableQuery.isLoading ? (
        <View style={styles.centered}>
          <ActivityIndicator size="large" color="#2658A5" />
        </View>
      ) : (
        <FlatList
          data={timetableQuery.data?.[day] ?? []}
          keyExtractor={(item, index) => index.toString()}
          contentContainerStyle={styles.listContent}
          renderItem={({ item }) => (
            <ThemedView type="backgroundElement" style={styles.card}>
              <ThemedText style={styles.subject}>{item.subject}</ThemedText>
              <ThemedText themeColor="textSecondary" style={styles.time}>
                {item.startTime} - {item.endTime}
              </ThemedText>
            </ThemedView>
          )}
          ListEmptyComponent={
            <View style={styles.centered}>
              <ThemedText themeColor="textSecondary" style={styles.text}>
                {timetableQuery.isError
                  ? timetableQuery.error.message
                  : session?.isStaff && !selectedClass
                    ? 'Select a class to view its timetable.'
                    : 'No periods found for this day.'}
              </ThemedText>
            </View>
          }
        />
      )}

      <SelectModal
        visible={classPickerVisible}
        title="Select class"
        options={classOptions}
        selectedIds={standardSectionId ? [standardSectionId] : []}
        onClose={() => setClassPickerVisible(false)}
        onChange={([id]) => setStandardSectionId(id)}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  classPicker: { margin: 12, padding: 12, borderRadius: 8 },
  classPickerLabel: { fontSize: 15 },
  dayRow: { flexDirection: 'row', gap: 8, paddingHorizontal: 12, marginBottom: 8 },
  dayChip: { flex: 1, alignItems: 'center', paddingVertical: 8, borderRadius: 8 },
  dayChipActive: { backgroundColor: '#2658A5' },
  dayLabel: { fontSize: 13, fontWeight: '600' },
  dayLabelActive: { color: '#fff' },
  listContent: { gap: 10, padding: 12, paddingTop: 0 },
  card: { padding: 12, borderRadius: 8, gap: 2 },
  subject: { fontSize: 15, fontWeight: '600' },
  time: { fontSize: 13 },
  text: { fontSize: 14, textAlign: 'center', paddingHorizontal: 24 },
});
