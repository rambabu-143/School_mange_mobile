import { DateTimePickerEvent } from '@react-native-community/datetimepicker';
import dayjs from 'dayjs';
import * as React from 'react';
import { ActivityIndicator, FlatList, Image, Modal, Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import Toast from 'react-native-toast-message';

import RNDateTimePicker from '@/components/DateTimePicker';
import { SelectModal } from '@/components/select-modal';
import { ThemedText } from '@/components/themed-text';
import { useTheme } from '@/hooks/use-theme';
import { useAttendanceReasonQuery } from '@/queries/useAttendanceReasonQuery';
import { useMarkAttendanceDropdownQuery } from '@/queries/useMarkAttendanceDropdownQuery';
import { useMarkAttendanceMutation } from '@/queries/useMarkAttendanceMutation';
import { MarkAttendanceStudent, useMarkAttendanceRosterMutation } from '@/queries/useMarkAttendanceRosterMutation';

const INFO_OPTIONS = ['Information Received', 'YES', 'NO'];

function isAbsent(s: MarkAttendanceStudent) {
  return s.first || s.second;
}

function absentType(s: MarkAttendanceStudent): { type: 'first' | 'second' | 'full'; value: 0.5 | 1 } {
  if (s.first && s.second) return { type: 'full', value: 1 };
  if (s.first) return { type: 'first', value: 0.5 };
  return { type: 'second', value: 0.5 };
}

export default function MarkAttendanceScreen() {
  const theme = useTheme();
  const [classPickerVisible, setClassPickerVisible] = React.useState(false);
  const [sectionId, setSectionId] = React.useState<string | null>(null);
  const [date, setDate] = React.useState(new Date());
  const [roster, setRoster] = React.useState<MarkAttendanceStudent[] | null>(null);
  const [search, setSearch] = React.useState('');
  const [reasonModalVisible, setReasonModalVisible] = React.useState(false);
  const [confirmModalVisible, setConfirmModalVisible] = React.useState(false);
  const [allAbsentModalVisible, setAllAbsentModalVisible] = React.useState(false);
  const [carryForwardVisible, setCarryForwardVisible] = React.useState(false);
  const [carryForwardDate, setCarryForwardDate] = React.useState(new Date());
  const [reasonPickerForId, setReasonPickerForId] = React.useState<string | null>(null);

  const dropdownQuery = useMarkAttendanceDropdownQuery();
  const reasonQuery = useAttendanceReasonQuery();
  const rosterMutation = useMarkAttendanceRosterMutation();
  const submitMutation = useMarkAttendanceMutation();

  const section = dropdownQuery.data?.find((s) => s.id === sectionId);
  const dateParam = dayjs(date).format('DD-MM-YYYY');
  const reasonOptions = (reasonQuery.data ?? []).map((r) => ({ id: r, label: r }));

  const handleGo = () => {
    if (!section) {
      Toast.show({ type: 'error', text1: 'Please select class', topOffset: 100, position: 'top' });
      return;
    }
    rosterMutation.mutate(
      { standardId: section.standardId, sectionId: section.id, date: dateParam },
      { onSuccess: setRoster }
    );
  };

  const updateStudent = (id: string, patch: Partial<MarkAttendanceStudent>) => {
    setRoster((prev) => prev?.map((s) => (s.id === id ? { ...s, ...patch } : s)) ?? null);
  };

  const toggleHalf = (student: MarkAttendanceStudent, half: 'first' | 'second') => {
    if (student.isWithdrawnSection || student.isSectionChanged) return;
    updateStudent(student.id, { [half]: !student[half] });
  };

  const changeClass = () => {
    setRoster(null);
    setSectionId(null);
  };

  const buildAbsentEntries = (students: MarkAttendanceStudent[]) => {
    return students.map((s) => {
      const { type, value } = absentType(s);
      return { studentId: s.id, type, value, reason: s.reason, details: s.others, information: s.information };
    });
  };

  const submit = (absentStudents: ReturnType<typeof buildAbsentEntries>) => {
    if (!section || !roster) return;
    submitMutation.mutate(
      { standardId: section.standardId, sectionId: section.id, date: dateParam, absentStudents, roster },
      {
        onSuccess: (res) => {
          Toast.show({ type: 'success', text1: res.message ?? 'Attendance marked', topOffset: 100, position: 'top' });
          setRoster(null);
          setSectionId(null);
        },
        onError: (err) => Toast.show({ type: 'error', text1: err.message, topOffset: 100, position: 'top' }),
      }
    );
  };

  const handleMarkAttendancePress = () => {
    const absent = (roster ?? []).filter(isAbsent);
    if (absent.length === 0) {
      Toast.show({ type: 'error', text1: 'Please select student', topOffset: 100, position: 'top' });
      return;
    }
    setReasonModalVisible(true);
  };

  const handleReasonContinue = () => {
    const absent = (roster ?? []).filter(isAbsent);
    const missingInfo = absent.some((s) => !s.information);
    if (missingInfo) {
      Toast.show({
        type: 'error',
        text1: 'Please update Information Received for all students marked absent',
        topOffset: 100,
        position: 'top',
      });
      return;
    }
    const missingOthers = absent.some((s) => s.reason.toLowerCase() === 'others' && !s.others);
    if (missingOthers) {
      Toast.show({ type: 'error', text1: 'Enter others reason', topOffset: 100, position: 'top' });
      return;
    }
    setReasonModalVisible(false);
    setConfirmModalVisible(true);
  };

  const handleMarkAllPresent = () => {
    submit([]);
  };

  const handleCarryForwardGo = () => {
    if (!section) return;
    const cfDateParam = dayjs(carryForwardDate).format('DD-MM-YYYY');
    rosterMutation.mutate(
      { standardId: section.standardId, sectionId: section.id, date: cfDateParam },
      { onSuccess: setRoster }
    );
    setCarryForwardVisible(false);
  };

  const filteredRoster = (roster ?? []).filter(
    (s) => !search || s.name?.toLowerCase().includes(search.toLowerCase()) || s.admissionNo?.toLowerCase().includes(search.toLowerCase())
  );
  const absentStudents = (roster ?? []).filter(isAbsent);

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      {!roster ? (
        <View style={styles.selectionContainer}>
          <Pressable style={[styles.picker, { backgroundColor: theme.backgroundElement }]} onPress={() => setClassPickerVisible(true)}>
            <ThemedText style={styles.pickerLabel}>{section?.label ?? 'Select class'}</ThemedText>
          </Pressable>
          <RNDateTimePicker
            value={date}
            mode="date"
            display="default"
            accentColor="#2658A5"
            onChange={(_event: DateTimePickerEvent, next?: Date) => {
              if (next) setDate(next);
            }}
          />
          <Pressable style={styles.goButton} onPress={handleGo} disabled={rosterMutation.isPending}>
            {rosterMutation.isPending ? <ActivityIndicator color="#fff" /> : <Text style={styles.goLabel}>Go</Text>}
          </Pressable>
          {rosterMutation.isError && <Text style={styles.errorText}>{rosterMutation.error.message}</Text>}
        </View>
      ) : (
        <>
          <View style={styles.header}>
            <Pressable onPress={changeClass}>
              <Text style={styles.headerTitle}>
                {section?.label}, Total: {roster.length}
              </Text>
            </Pressable>
            <ThemedText themeColor="textSecondary" style={styles.headerDate}>{dateParam}</ThemedText>
          </View>

          <View style={styles.actionsRow}>
            <Pressable style={[styles.actionButton, { backgroundColor: theme.backgroundElement }]} onPress={handleMarkAllPresent}>
              <ThemedText style={styles.actionLabel}>All Present</ThemedText>
            </Pressable>
            <Pressable style={[styles.actionButton, { backgroundColor: theme.backgroundElement }]} onPress={() => setAllAbsentModalVisible(true)}>
              <ThemedText style={styles.actionLabel}>All Absent</ThemedText>
            </Pressable>
            <Pressable style={[styles.actionButton, { backgroundColor: theme.backgroundElement }]} onPress={() => setCarryForwardVisible(true)}>
              <ThemedText style={styles.actionLabel}>Carry Fwd</ThemedText>
            </Pressable>
          </View>

          <TextInput
            placeholder="Search by name or admission no."
            placeholderTextColor={theme.textSecondary}
            value={search}
            onChangeText={setSearch}
            style={[styles.searchInput, { color: theme.text }]}
          />

          <FlatList
            data={filteredRoster}
            keyExtractor={(item) => item.id}
            contentContainerStyle={styles.listContent}
            renderItem={({ item, index }) => (
              <View
                style={[
                  styles.card,
                  { backgroundColor: theme.backgroundElement },
                  (item.isWithdrawnSection || item.isSectionChanged) && styles.cardDisabled,
                ]}
              >
                {item.profilePic ? (
                  <Image source={{ uri: item.profilePic }} style={styles.avatar} />
                ) : (
                  <View style={[styles.avatar, styles.avatarPlaceholder]}>
                    <Text style={styles.avatarInitial}>{(item.name ?? '?').charAt(0).toUpperCase()}</Text>
                  </View>
                )}
                <ThemedText themeColor="textSecondary" style={styles.serial}>{index + 1}</ThemedText>
                <View style={{ flex: 1 }}>
                  <ThemedText style={styles.name}>{item.name}</ThemedText>
                  <ThemedText themeColor="textSecondary" style={styles.meta}>{item.admissionNo}</ThemedText>
                </View>
                <Pressable
                  style={[styles.halfChip, { backgroundColor: theme.background }, item.first && styles.halfChipActive]}
                  onPress={() => toggleHalf(item, 'first')}
                >
                  <Text style={[styles.halfChipLabel, item.first && styles.halfChipLabelActive]}>AM</Text>
                </Pressable>
                <Pressable
                  style={[styles.halfChip, { backgroundColor: theme.background }, item.second && styles.halfChipActive]}
                  onPress={() => toggleHalf(item, 'second')}
                >
                  <Text style={[styles.halfChipLabel, item.second && styles.halfChipLabelActive]}>PM</Text>
                </Pressable>
              </View>
            )}
          />

          <Pressable style={styles.submitButton} onPress={handleMarkAttendancePress} disabled={submitMutation.isPending}>
            {submitMutation.isPending ? <ActivityIndicator color="#fff" /> : <Text style={styles.submitLabel}>Mark Attendance</Text>}
          </Pressable>
        </>
      )}

      <SelectModal
        visible={classPickerVisible}
        title="Select class"
        options={dropdownQuery.data ?? []}
        selectedIds={sectionId ? [sectionId] : []}
        onClose={() => setClassPickerVisible(false)}
        onChange={([id]) => setSectionId(id)}
      />

      {/* Reason collection — one row per absent student, mirrors native's per-student dialog list */}
      {/* hidden while the reason picker (a sibling Modal) is up — iOS can't stack two Modals */}
      <Modal visible={reasonModalVisible && !reasonPickerForId} transparent animationType="fade" onRequestClose={() => setReasonModalVisible(false)}>
        <Pressable style={styles.backdrop} onPress={() => setReasonModalVisible(false)}>
          <Pressable style={[styles.reasonSheet, { backgroundColor: theme.backgroundElement }]} onPress={(e) => e.stopPropagation()}>
            <ThemedText style={styles.sheetTitle}>Reason for absence</ThemedText>
            <ScrollView style={{ maxHeight: 400 }}>
              {absentStudents.map((item) => (
                <View key={item.id} style={styles.reasonRow}>
                  <ThemedText style={styles.reasonName}>
                    {item.admissionNo} - {item.name} ({item.first && item.second ? 'Full Day' : 'Half Day'})
                  </ThemedText>
                  <Pressable style={[styles.reasonPicker, { backgroundColor: theme.backgroundSelected }]} onPress={() => setReasonPickerForId(item.id)}>
                    <ThemedText style={styles.reasonPickerLabel}>{item.reason || 'Select Reason'}</ThemedText>
                  </Pressable>
                  {item.reason.toLowerCase() === 'others' && (
                    <TextInput
                      placeholder="Details"
                      placeholderTextColor={theme.textSecondary}
                      value={item.others}
                      onChangeText={(v) => updateStudent(item.id, { others: v })}
                      style={[styles.othersInput, { color: theme.text }]}
                    />
                  )}
                  <ThemedText themeColor="textSecondary" style={{ fontSize: 12, marginTop: 6 }}>Information Received</ThemedText>
                  <View style={styles.infoRow}>
                    {INFO_OPTIONS.filter((o) => o !== 'Information Received').map((opt) => (
                      <Pressable
                        key={opt}
                        style={[styles.infoChip, { backgroundColor: theme.background }, item.information === opt && styles.infoChipActive]}
                        onPress={() => updateStudent(item.id, { information: opt })}
                      >
                        <Text style={[styles.infoChipLabel, item.information === opt && styles.infoChipLabelActive]}>{opt}</Text>
                      </Pressable>
                    ))}
                  </View>
                </View>
              ))}
            </ScrollView>
            <Pressable style={styles.submitButton} onPress={handleReasonContinue}>
              <Text style={styles.submitLabel}>Continue</Text>
            </Pressable>
          </Pressable>
        </Pressable>
      </Modal>

      <SelectModal
        visible={!!reasonPickerForId}
        title="Select reason"
        options={reasonOptions}
        selectedIds={reasonPickerForId ? [roster?.find((s) => s.id === reasonPickerForId)?.reason ?? ''] : []}
        onClose={() => setReasonPickerForId(null)}
        onChange={([reason]) => {
          if (reasonPickerForId) updateStudent(reasonPickerForId, { reason });
        }}
      />

      {/* Final confirmation with totals, matches native's total_student_dialog */}
      <Modal visible={confirmModalVisible} transparent animationType="fade" onRequestClose={() => setConfirmModalVisible(false)}>
        <Pressable style={styles.backdrop} onPress={() => setConfirmModalVisible(false)}>
          <Pressable style={[styles.confirmSheet, { backgroundColor: theme.backgroundElement }]} onPress={(e) => e.stopPropagation()}>
            <ThemedText style={styles.sheetTitle}>{section?.label}</ThemedText>
            <ThemedText style={styles.confirmRow}>Date: {dateParam}</ThemedText>
            <ThemedText style={styles.confirmRow}>Total: {roster?.length ?? 0}</ThemedText>
            <ThemedText style={styles.confirmRow}>Present: {(roster?.length ?? 0) - absentStudents.length}</ThemedText>
            <ThemedText style={styles.confirmRow}>Full day absent: {absentStudents.filter((s) => s.first && s.second).length}</ThemedText>
            <ThemedText style={styles.confirmRow}>Half day absent: {absentStudents.filter((s) => !(s.first && s.second)).length}</ThemedText>
            <Pressable
              style={styles.submitButton}
              onPress={() => {
                setConfirmModalVisible(false);
                submit(buildAbsentEntries(absentStudents));
              }}
            >
              <Text style={styles.submitLabel}>Submit</Text>
            </Pressable>
          </Pressable>
        </Pressable>
      </Modal>

      {/* All-absent quick action — one reason/information applied to every student */}
      <Modal visible={allAbsentModalVisible} transparent animationType="fade" onRequestClose={() => setAllAbsentModalVisible(false)}>
        <Pressable style={styles.backdrop} onPress={() => setAllAbsentModalVisible(false)}>
          <AllAbsentForm
            reasonOptions={reasonOptions}
            onCancel={() => setAllAbsentModalVisible(false)}
            onSave={(reason, information, details) => {
              setAllAbsentModalVisible(false);
              if (!roster) return;
              submit(
                roster.map((s) => ({ studentId: s.id, type: 'full', value: 1, reason, details, information }))
              );
            }}
          />
        </Pressable>
      </Modal>

      {/* Carry forward — pull an earlier date's marks onto this roster for review before submitting */}
      <Modal visible={carryForwardVisible} transparent animationType="fade" onRequestClose={() => setCarryForwardVisible(false)}>
        <Pressable style={styles.backdrop} onPress={() => setCarryForwardVisible(false)}>
          <Pressable style={[styles.confirmSheet, { backgroundColor: theme.backgroundElement }]} onPress={(e) => e.stopPropagation()}>
            <ThemedText style={styles.sheetTitle}>Carry forward from</ThemedText>
            <RNDateTimePicker
              value={carryForwardDate}
              mode="date"
              display="default"
              accentColor="#2658A5"
              onChange={(_event: DateTimePickerEvent, next?: Date) => {
                if (next) setCarryForwardDate(next);
              }}
            />
            <Pressable style={styles.submitButton} onPress={handleCarryForwardGo}>
              <Text style={styles.submitLabel}>Go</Text>
            </Pressable>
          </Pressable>
        </Pressable>
      </Modal>
    </SafeAreaView>
  );
}

function AllAbsentForm({
  reasonOptions,
  onCancel,
  onSave,
}: {
  reasonOptions: { id: string; label: string }[];
  onCancel: () => void;
  onSave: (reason: string, information: string, details: string) => void;
}) {
  const theme = useTheme();
  const [reason, setReason] = React.useState('');
  const [information, setInformation] = React.useState('');
  const [details, setDetails] = React.useState('');
  const [reasonPickerVisible, setReasonPickerVisible] = React.useState(false);

  return (
    <Pressable style={[styles.confirmSheet, { backgroundColor: theme.backgroundElement }]} onPress={(e) => e.stopPropagation()}>
      <ThemedText style={styles.sheetTitle}>Mark all absent</ThemedText>
      <Pressable style={[styles.reasonPicker, { backgroundColor: theme.backgroundSelected }]} onPress={() => setReasonPickerVisible(true)}>
        <ThemedText style={styles.reasonPickerLabel}>{reason || 'Select Reason'}</ThemedText>
      </Pressable>
      {reason.toLowerCase() === 'others' && (
        <TextInput
          placeholder="Details"
          placeholderTextColor={theme.textSecondary}
          value={details}
          onChangeText={setDetails}
          style={[styles.othersInput, { color: theme.text }]}
        />
      )}
      <View style={styles.infoRow}>
        {INFO_OPTIONS.filter((o) => o !== 'Information Received').map((opt) => (
          <Pressable
            key={opt}
            style={[styles.infoChip, { backgroundColor: theme.background }, information === opt && styles.infoChipActive]}
            onPress={() => setInformation(opt)}
          >
            <Text style={[styles.infoChipLabel, information === opt && styles.infoChipLabelActive]}>{opt}</Text>
          </Pressable>
        ))}
      </View>
      <Pressable
        style={styles.submitButton}
        onPress={() => {
          if (!information) {
            Toast.show({ type: 'error', text1: 'Please update Information Received', topOffset: 100, position: 'top' });
            return;
          }
          if (reason.toLowerCase() === 'others' && !details) {
            Toast.show({ type: 'error', text1: 'Enter others reason', topOffset: 100, position: 'top' });
            return;
          }
          onSave(reason, information, details);
        }}
      >
        <Text style={styles.submitLabel}>Save</Text>
      </Pressable>

      <SelectModal
        visible={reasonPickerVisible}
        title="Select reason"
        options={reasonOptions}
        selectedIds={reason ? [reason] : []}
        onClose={() => setReasonPickerVisible(false)}
        onChange={([r]) => setReason(r)}
      />
    </Pressable>
  );
}

const styles = StyleSheet.create({
  selectionContainer: { padding: 16, gap: 12 },
  picker: { padding: 12, borderRadius: 8 },
  pickerLabel: { fontSize: 15 },
  goButton: { alignItems: 'center', paddingVertical: 12, borderRadius: 8, backgroundColor: '#2658A5' },
  goLabel: { color: '#fff', fontWeight: '700' },
  errorText: { color: '#c0392b', textAlign: 'center' },
  header: { padding: 12, gap: 2 },
  headerTitle: { fontSize: 15, fontWeight: '700', color: '#2658A5' },
  headerDate: { fontSize: 12 },
  actionsRow: { flexDirection: 'row', gap: 8, paddingHorizontal: 12, marginBottom: 8 },
  actionButton: { flex: 1, alignItems: 'center', paddingVertical: 8, borderRadius: 8 },
  actionLabel: { fontSize: 12, fontWeight: '600' },
  searchInput: {
    marginHorizontal: 12,
    marginBottom: 8,
    borderWidth: 1,
    borderColor: '#8884',
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 8,
    fontSize: 14,
  },
  listContent: { gap: 10, padding: 12, paddingTop: 0, paddingBottom: 90 },
  card: { flexDirection: 'row', alignItems: 'center', gap: 8, padding: 10, borderRadius: 8 },
  cardDisabled: { opacity: 0.5 },
  avatar: { width: 36, height: 36, borderRadius: 18 },
  avatarPlaceholder: { backgroundColor: '#2658A5', alignItems: 'center', justifyContent: 'center' },
  avatarInitial: { color: '#fff', fontSize: 14, fontWeight: '700' },
  serial: { fontSize: 11, width: 16, textAlign: 'center' },
  name: { fontSize: 14, fontWeight: '600' },
  meta: { fontSize: 12 },
  halfChip: { width: 34, height: 28, alignItems: 'center', justifyContent: 'center', borderRadius: 6, borderWidth: 1, borderColor: '#2658A5' },
  halfChipActive: { backgroundColor: '#2658A5' },
  halfChipLabel: { fontSize: 11, fontWeight: '700', color: '#2658A5' },
  halfChipLabelActive: { color: '#fff' },
  submitButton: { position: 'absolute', left: 12, right: 12, bottom: 12, alignItems: 'center', paddingVertical: 14, borderRadius: 8, backgroundColor: '#2658A5' },
  submitLabel: { color: '#fff', fontWeight: '700', fontSize: 15 },
  backdrop: { flex: 1, backgroundColor: '#00000066', justifyContent: 'center', padding: 24 },
  reasonSheet: { maxHeight: '80%', borderRadius: 8, padding: 16, gap: 12 },
  confirmSheet: { borderRadius: 8, padding: 16, gap: 12 },
  sheetTitle: { fontSize: 16, fontWeight: '700' },
  confirmRow: { fontSize: 14 },
  reasonRow: { gap: 6, paddingVertical: 10, borderTopWidth: 1, borderTopColor: '#e5e5e5' },
  reasonName: { fontSize: 13, fontWeight: '600' },
  reasonPicker: { padding: 10, borderRadius: 8 },
  reasonPickerLabel: { fontSize: 13 },
  othersInput: { borderWidth: 1, borderColor: '#8884', borderRadius: 8, paddingHorizontal: 10, paddingVertical: 8, fontSize: 13 },
  infoRow: { flexDirection: 'row', gap: 6, flexWrap: 'wrap' },
  infoChip: { paddingHorizontal: 10, paddingVertical: 6, borderRadius: 6, borderWidth: 1, borderColor: '#2658A5' },
  infoChipActive: { backgroundColor: '#2658A5' },
  infoChipLabel: { fontSize: 12, color: '#2658A5', fontWeight: '600' },
  infoChipLabelActive: { color: '#fff' },
});
