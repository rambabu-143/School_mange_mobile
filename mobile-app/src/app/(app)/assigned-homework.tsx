import { DateTimePickerEvent } from '@react-native-community/datetimepicker';
import dayjs from 'dayjs';
import * as React from 'react';
import { ActivityIndicator, Alert, FlatList, Linking, Pressable, StyleSheet, Text, TextInput, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import RNDateTimePicker from '@/components/DateTimePicker';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { AssignedHomework, useAssignedHomeworkListQuery } from '@/queries/useAssignedHomeworkListQuery';
import { useSessionStore } from '@/lib/session-store';
import { useDeleteAssignedHomeworkMutation } from '@/queries/useDeleteAssignedHomeworkMutation';

export default function AssignedHomeworkScreen() {
  const theme = useTheme();
  // Academic year runs 1 Apr - 31 Mar of the active session (e.g. "2026-27"); lock the calendars to it.
  const yearSession = useSessionStore((st) => st.session?.yearSession);
  const startYear = Number((yearSession ?? '').split('-')[0]) || dayjs().year();
  const minDate = new Date(startYear, 3, 1);
  const maxDate = new Date(startYear + 1, 2, 31);
  const [startDate, setStartDate] = React.useState(new Date());
  const [endDate, setEndDate] = React.useState(new Date());
  const [search, setSearch] = React.useState('');

  const startParam = dayjs(startDate).format('DD-MM-YYYY');
  const endParam = dayjs(endDate).format('DD-MM-YYYY');
  const listQuery = useAssignedHomeworkListQuery(startParam, endParam);
  const deleteMutation = useDeleteAssignedHomeworkMutation(startParam, endParam);

  const confirmDelete = (item: AssignedHomework) => {
    Alert.alert(
      'Are you sure you want to delete this homework?',
      undefined,
      [
        { text: 'Cancel', style: 'cancel' },
        { text: 'Delete', style: 'destructive', onPress: () => deleteMutation.mutate(item.id) },
      ],
      { cancelable: true }
    );
  };

  const filtered = (listQuery.data ?? []).filter(
    (h) =>
      !search ||
      h.text?.toLowerCase().includes(search.toLowerCase()) ||
      h.teacherName?.toLowerCase().includes(search.toLowerCase()) ||
      h.attachment?.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <View style={styles.filters}>
        <View style={styles.dateRow}>
          <View style={{ flex: 1 }}>
            <ThemedText themeColor="textSecondary" style={styles.dateLabel}>Start</ThemedText>
            <RNDateTimePicker
              value={startDate}
              mode="date"
              minimumDate={minDate}
              maximumDate={maxDate}
              display="default"
              accentColor="#2658A5"
              onChange={(_e: DateTimePickerEvent, next?: Date) => next && setStartDate(next)}
            />
          </View>
          <View style={{ flex: 1 }}>
            <ThemedText themeColor="textSecondary" style={styles.dateLabel}>End</ThemedText>
            <RNDateTimePicker
              value={endDate}
              mode="date"
              minimumDate={minDate}
              maximumDate={maxDate}
              display="default"
              accentColor="#2658A5"
              onChange={(_e: DateTimePickerEvent, next?: Date) => next && setEndDate(next)}
            />
          </View>
        </View>
        <TextInput
          placeholder="Search homework, teacher, or attachment"
          placeholderTextColor={theme.textSecondary}
          value={search}
          onChangeText={setSearch}
          style={[styles.searchInput, { color: theme.text }]}
        />
      </View>

      {listQuery.isLoading ? (
        <ThemedView style={styles.centered}>
          <ActivityIndicator size="large" color="#2658A5" />
        </ThemedView>
      ) : (
        <FlatList
          data={filtered}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.listContent}
          renderItem={({ item }) => (
            <ThemedView type="backgroundElement" style={styles.card}>
              <View style={styles.cardHeader}>
                <Text style={styles.subject}>{item.subjectName}</Text>
                <Pressable onPress={() => confirmDelete(item)} hitSlop={8}>
                  <Text style={styles.deleteIcon}>🗑</Text>
                </Pressable>
              </View>
              <ThemedText themeColor="textSecondary" style={styles.className}>
                {item.className} ({item.studentsLabel})
              </ThemedText>
              <ThemedText style={styles.text}>{item.text}</ThemedText>
              <ThemedText themeColor="textSecondary" style={styles.date}>{dayjs(item.date).format('MMM DD, YYYY')}</ThemedText>
              {item.teacherName && <ThemedText themeColor="textSecondary" style={styles.teacher}>Assigned by {item.teacherName}</ThemedText>}
              {item.googleDriveLink && (
                <Pressable onPress={() => Linking.openURL(item.googleDriveLink!)}>
                  <Text style={styles.attachmentLink}>{item.attachment ?? 'Attachment'}</Text>
                </Pressable>
              )}
            </ThemedView>
          )}
          ListEmptyComponent={
            <ThemedView style={styles.centered}>
              <ThemedText themeColor="textSecondary" style={styles.text}>{listQuery.isError ? listQuery.error.message : 'No homework found for this range.'}</ThemedText>
            </ThemedView>
          }
        />
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  filters: { padding: 12, gap: 8 },
  dateRow: { flexDirection: 'row', gap: 12 },
  dateLabel: { fontSize: 12, marginBottom: 4 },
  searchInput: { borderWidth: 1, borderColor: '#8884', borderRadius: 8, paddingHorizontal: 12, paddingVertical: 8, fontSize: 14 },
  listContent: { gap: 12, padding: 12, paddingTop: 0 },
  card: { gap: 4, padding: 12, borderRadius: 8 },
  cardHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  subject: { fontSize: 14, fontWeight: '700', color: '#2658A5' },
  deleteIcon: { fontSize: 16 },
  className: { fontSize: 12 },
  text: { fontSize: 14 },
  date: { fontSize: 12 },
  teacher: { fontSize: 12 },
  attachmentLink: { fontSize: 13, color: '#2658A5', textDecorationLine: 'underline' },
});
