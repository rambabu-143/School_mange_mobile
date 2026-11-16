import { DateTimePickerEvent } from '@react-native-community/datetimepicker';
import dayjs from 'dayjs';
import * as React from 'react';
import { ActivityIndicator, FlatList, Pressable, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import RNDateTimePicker from '@/components/DateTimePicker';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { AttendanceSummarySection, useAttendanceSummaryQuery } from '@/queries/useAttendanceSummaryQuery';

function SectionCard({ section }: { section: AttendanceSummarySection }) {
  const [expanded, setExpanded] = React.useState(false);
  const absentCount = section.students.length;

  const title = !section.isAttendanceMarked
    ? `${section.standard} ${section.section}`
    : absentCount > 0
      ? `${section.standard} ${section.section}  ${absentCount} absent / ${section.totalStudent}`
      : `${section.standard} ${section.section}  All present`;

  return (
    <ThemedView type="backgroundElement" style={styles.card}>
      <Pressable
        style={styles.cardHeader}
        disabled={absentCount === 0}
        onPress={() => setExpanded((e) => !e)}
      >
        <View style={{ flex: 1 }}>
          <ThemedText style={styles.cardTitle}>{title}</ThemedText>
          <ThemedText themeColor="textSecondary" style={styles.cardDate}>
            {section.isAttendanceMarked
              ? dayjs(section.attendanceMarkedAt).format('DD-MM-YYYY | hh:mm a')
              : 'Attendance Not Marked'}
          </ThemedText>
        </View>
        {absentCount > 0 && <ThemedText themeColor="textSecondary" style={styles.chevron}>{expanded ? '▴' : '▾'}</ThemedText>}
      </Pressable>

      {expanded &&
        section.students.map((student) => (
          <View key={student.id} style={styles.studentRow}>
            <ThemedText style={styles.studentName}>
              {student.admissionNo}-{student.name}
            </ThemedText>
            <ThemedText themeColor="textSecondary" style={styles.studentReason}>
              {student.isHalfDay ? 'Half Day' : 'Full Day'}
              {(student.reason?.toLowerCase() === 'others' ? student.details : student.reason)
                ? ` | ${student.reason?.toLowerCase() === 'others' ? student.details : student.reason}`
                : ''}
            </ThemedText>
          </View>
        ))}
    </ThemedView>
  );
}

export default function AttendanceSummaryScreen() {
  const theme = useTheme();
  const [date, setDate] = React.useState(new Date());
  const dateParam = dayjs(date).format('DD-MM-YYYY');
  const attendanceSummaryQuery = useAttendanceSummaryQuery(dateParam);

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <View style={styles.dateRow}>
        <RNDateTimePicker
          value={date}
          mode="date"
          display="default"
          accentColor="#2658A5"
          onChange={(_event: DateTimePickerEvent, next?: Date) => {
            if (next) setDate(next);
          }}
        />
      </View>

      {attendanceSummaryQuery.isLoading ? (
        <ThemedView style={styles.centered}>
          <ActivityIndicator size="large" color="#2658A5" />
        </ThemedView>
      ) : (
        <FlatList
          data={attendanceSummaryQuery.data ?? []}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.listContent}
          renderItem={({ item }) => <SectionCard section={item} />}
          ListEmptyComponent={
            <ThemedView style={styles.centered}>
              <ThemedText themeColor="textSecondary" style={styles.text}>
                {attendanceSummaryQuery.isError ? attendanceSummaryQuery.error.message : 'No sections found.'}
              </ThemedText>
            </ThemedView>
          }
        />
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  dateRow: { padding: 12 },
  listContent: { gap: 12, padding: 12, paddingTop: 0 },
  card: { borderRadius: 8, overflow: 'hidden' },
  cardHeader: { flexDirection: 'row', alignItems: 'center', padding: 12, gap: 8 },
  cardTitle: { fontSize: 15, fontWeight: '600' },
  cardDate: { fontSize: 12 },
  chevron: { fontSize: 16 },
  studentRow: { paddingHorizontal: 12, paddingVertical: 8, borderTopWidth: 1, borderTopColor: '#e5e5e5' },
  studentName: { fontSize: 14, fontWeight: '600' },
  studentReason: { fontSize: 13 },
  text: { fontSize: 14, textAlign: 'center', paddingHorizontal: 24 },
});
