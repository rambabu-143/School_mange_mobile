import * as React from 'react';
import { ActivityIndicator, FlatList, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import dayjs from 'dayjs';
import { Calendar } from 'react-native-calendars';

import { ThemedText } from '@/components/themed-text';
import { useTheme } from '@/hooks/use-theme';
import { useMyAttendanceCalendarQuery } from '@/queries/useMyAttendanceCalendarQuery';

/** Native: studentattendance/AttendanceFragment (non-staff branch) - "Attendance" home-grid tile. */
export default function MyAttendanceScreen() {
  const [month, setMonth] = React.useState(() => dayjs().startOf('month'));
  const startDate = month.startOf('month').format('DD-MM-YYYY');
  const endDate = month.endOf('month').format('DD-MM-YYYY');
  const query = useMyAttendanceCalendarQuery(startDate, endDate);
  const theme = useTheme();

  const flaggedDays = (query.data?.days ?? []).filter((d) => d.date);
  const markedDates = Object.fromEntries(
    flaggedDays.map((d) => [dayjs(d.date).format('YYYY-MM-DD'), { marked: true, dotColor: d.isHalfDay ? '#e08e0b' : '#c0392b' }])
  );

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <Calendar
        key={theme.background}
        current={month.format('YYYY-MM-DD')}
        onMonthChange={(m) => setMonth(dayjs(m.dateString).startOf('month'))}
        markedDates={markedDates}
        enableSwipeMonths
        theme={{ calendarBackground: theme.background, dayTextColor: theme.text, monthTextColor: theme.text, textDisabledColor: theme.textSecondary, arrowColor: '#2658A5' }}
      />

      {query.isLoading ? (
        <View style={styles.centered}>
          <ActivityIndicator size="large" color="#2658A5" />
        </View>
      ) : (
        <>
          <View style={styles.statsRow}>
            <View style={styles.statBox}>
              <ThemedText style={styles.statValue}>{query.data?.present ?? 0}</ThemedText>
              <ThemedText themeColor="textSecondary" style={styles.statLabel}>Present</ThemedText>
            </View>
            <View style={styles.statBox}>
              <ThemedText style={styles.statValue}>{query.data?.absent ?? 0}</ThemedText>
              <ThemedText themeColor="textSecondary" style={styles.statLabel}>Absent</ThemedText>
            </View>
            <View style={styles.statBox}>
              <ThemedText style={styles.statValue}>{query.data?.total ?? 0}</ThemedText>
              <ThemedText themeColor="textSecondary" style={styles.statLabel}>Total Days</ThemedText>
            </View>
          </View>

          <FlatList
            data={flaggedDays}
            keyExtractor={(item, i) => item.date ?? i.toString()}
            contentContainerStyle={styles.listContent}
            renderItem={({ item }) => (
              // Absent/half-day cards use a fixed pastel status background (not theme-driven, like a
              // status legend) so their text stays hardcoded dark to stay readable on that fixed tint.
              <View style={[styles.dayCard, item.isHalfDay ? styles.halfDayCard : styles.absentCard]}>
                <Text style={styles.dayDate}>{dayjs(item.date).format('DD-MM-YYYY')}</Text>
                <Text style={styles.dayStatus}>{item.isHalfDay ? 'Half Day' : 'Absent'}</Text>
                {item.information || item.reason ? (
                  <Text style={styles.dayReason}>{item.information || item.reason}</Text>
                ) : null}
              </View>
            )}
            ListEmptyComponent={
              <View style={styles.centered}>
                <ThemedText themeColor="textSecondary" style={styles.text}>
                  {query.isError ? query.error.message : 'No absences this month.'}
                </ThemedText>
              </View>
            }
          />
        </>
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 200, alignItems: 'center', justifyContent: 'center' },
  text: { fontSize: 14 },
  monthRow: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', paddingHorizontal: 24, paddingVertical: 12 },
  arrow: { fontSize: 28, color: '#2658A5', paddingHorizontal: 12 },
  monthLabel: { fontSize: 16, fontWeight: '700' },
  statsRow: { flexDirection: 'row', justifyContent: 'space-around', paddingBottom: 12 },
  statBox: { alignItems: 'center' },
  statValue: { fontSize: 22, fontWeight: '800' },
  statLabel: { fontSize: 12 },
  listContent: { gap: 10, padding: 12, paddingTop: 0 },
  dayCard: { gap: 4, padding: 12, borderRadius: 8, borderLeftWidth: 4 },
  absentCard: { backgroundColor: '#fdecea', borderLeftColor: '#c0392b' },
  halfDayCard: { backgroundColor: '#fef5e0', borderLeftColor: '#e08e0b' },
  dayDate: { fontSize: 14, fontWeight: '600', color: '#323232' },
  dayStatus: { fontSize: 13, color: '#545454' },
  dayReason: { fontSize: 12, color: '#8a8a8a' },
});
