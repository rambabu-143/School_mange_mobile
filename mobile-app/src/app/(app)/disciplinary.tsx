import * as React from 'react';
import { ActivityIndicator, Modal, Pressable, ScrollView, StyleSheet, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import dayjs from 'dayjs';
import Toast from 'react-native-toast-message';

import { SelectModal } from '@/components/select-modal';
import { QrScannerModal } from '@/components/qr-scanner-modal';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useSessionStore } from '@/lib/session-store';
import { DisciplinaryCategory, DisciplinaryEntry, useDisciplinaryCardQuery } from '@/queries/useDisciplinaryCardQuery';
import { useClassListQuery } from '@/queries/useClassListQuery';
import { useClassSectionDropdownQuery } from '@/queries/useClassSectionDropdownQuery';
import { useDisciplinaryReasonsQuery } from '@/queries/useDisciplinaryReasonsQuery';
import { DisciplinaryCardKey, useIssueDisciplinaryCardMutation } from '@/queries/useIssueDisciplinaryCardMutation';
import { ScannedStudent, useStudentSearchByAdmissionNo } from '@/queries/useStudentSearchByAdmissionNo';

// ponytail: pink/yellow/red are fixed severity-card colors (native app parity) — always light
// pastel backgrounds regardless of theme, so their on-card text stays hardcoded dark too.
const CARDS: { key: 'pink' | 'yellow' | 'red'; title: string; colorName: string; color: string }[] = [
  { key: 'pink', title: 'WARNING CARD', colorName: 'Pink', color: '#ee7d9b' },
  { key: 'yellow', title: 'TARDY CARD', colorName: 'Yellow', color: '#f3cb2f' },
  { key: 'red', title: 'RED CARD', colorName: 'Red', color: '#e5584d' },
];

const OTHER_REASON = 'Any other reason';
const HOUSE_POINTS = ['1', '2', '3', '4', '5'].map((n) => ({ id: n, label: n }));

/** Native: DiscplinaryCardStaffViewController's "By QR" flow (viewQRCode → scanned student →
 * viewTextfields → submit). "By Class" entry mode is skipped here — QR is the flow the scanner
 * infra exists to serve; the class-roster browse mode can be added the same way wise.tsx's
 * StaffWiseScreen picks students, if needed later. */
function IssueDisciplinaryForm({
  student,
  onCancel,
  onSubmitted,
}: {
  student: ScannedStudent;
  onCancel: () => void;
  onSubmitted: () => void;
}) {
  const theme = useTheme();
  const [cardKey, setCardKey] = React.useState<DisciplinaryCardKey | null>(null);
  const [reason, setReason] = React.useState('');
  const [reasonOther, setReasonOther] = React.useState('');
  const [reasonPickerVisible, setReasonPickerVisible] = React.useState(false);
  const [pointPickerVisible, setPointPickerVisible] = React.useState(false);
  const [actionTaken, setActionTaken] = React.useState('');
  const [housePoint, setHousePoint] = React.useState('');
  const issueMutation = useIssueDisciplinaryCardMutation();

  const reasonsQuery = useDisciplinaryReasonsQuery(cardKey);
  const isOther = reason === OTHER_REASON;
  const canSubmit = !!cardKey && reason !== '' && (!isOther || reasonOther.trim() !== '') && actionTaken.trim() !== '' && housePoint.trim() !== '';

  const submit = () => {
    if (!cardKey) return;
    issueMutation.mutate(
      {
        studentId: student.id,
        admissionNo: student.admissionNo,
        cardKey,
        reason,
        ...(isOther ? { reasonOther: reasonOther.trim() } : {}),
        actionTaken: actionTaken.trim(),
        housePoint: housePoint.trim(),
      },
      {
        onSuccess: () => {
          Toast.show({ type: 'success', text1: `Card issued to ${student.name ?? 'student'}`, position: 'top', topOffset: 100 });
          onSubmitted();
        },
        onError: (error) =>
          Toast.show({
            type: 'error',
            text1: 'Could not issue card',
            text2: error instanceof Error ? error.message : undefined,
            position: 'top',
            topOffset: 100,
          }),
      }
    );
  };

  return (
    <ScrollView contentContainerStyle={staffStyles.formContent}>
      <ThemedView type="backgroundElement" style={staffStyles.studentCard}>
        <ThemedText style={staffStyles.studentName}>{student.name ?? 'Student'}</ThemedText>
        <ThemedText themeColor="textSecondary" style={staffStyles.studentSub}>
          {student.admissionNo}
          {student.standardName ? ` · ${student.standardName}${student.sectionName ? ` ${student.sectionName}` : ''}` : ''}
        </ThemedText>
      </ThemedView>

      <View style={staffStyles.cardRow}>
        {CARDS.map((card) => (
          <Pressable
            key={card.key}
            style={[
              staffStyles.cardChoice,
              { backgroundColor: card.color },
              cardKey === card.key && staffStyles.cardChoiceActive,
            ]}
            onPress={() => {
              setCardKey(card.key);
              setReason('');
            }}>
            <Text style={staffStyles.cardChoiceLabel}>{card.title}</Text>
            <Text style={staffStyles.cardChoiceColor}>{card.colorName}</Text>
          </Pressable>
        ))}
      </View>

      <TouchableOpacity
        style={[staffStyles.input, staffStyles.dropdown, { borderColor: theme.backgroundSelected, opacity: cardKey ? 1 : 0.5 }]}
        disabled={!cardKey}
        onPress={() => setReasonPickerVisible(true)}>
        <ThemedText themeColor={reason ? 'text' : 'textSecondary'}>{reason || (cardKey ? 'Select reason' : 'Select a card first')}</ThemedText>
        <ThemedText themeColor="textSecondary">▾</ThemedText>
      </TouchableOpacity>
      {isOther ? (
        <TextInput
          style={[staffStyles.input, { color: theme.text, borderColor: theme.backgroundSelected }]}
          placeholder="Other reason"
          placeholderTextColor={theme.textSecondary}
          value={reasonOther}
          onChangeText={setReasonOther}
          multiline
        />
      ) : null}
      <TextInput
        style={[staffStyles.input, { color: theme.text, borderColor: theme.backgroundSelected }]}
        placeholder="Action taken"
        placeholderTextColor={theme.textSecondary}
        value={actionTaken}
        onChangeText={setActionTaken}
        multiline
      />
      <TouchableOpacity
        style={[staffStyles.input, staffStyles.dropdown, { borderColor: theme.backgroundSelected }]}
        onPress={() => setPointPickerVisible(true)}>
        <ThemedText themeColor={housePoint ? 'text' : 'textSecondary'}>{housePoint ? `House points deducted: ${housePoint}` : 'House points deducted'}</ThemedText>
        <ThemedText themeColor="textSecondary">▾</ThemedText>
      </TouchableOpacity>

      <View style={staffStyles.formActions}>
        <TouchableOpacity onPress={onCancel} disabled={issueMutation.isPending}>
          <Text style={{ color: theme.textSecondary, fontWeight: '600' }}>Cancel</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[staffStyles.submitButton, (!canSubmit || issueMutation.isPending) && { opacity: 0.4 }]}
          disabled={!canSubmit || issueMutation.isPending}
          onPress={submit}>
          <Text style={staffStyles.submitButtonLabel}>{issueMutation.isPending ? 'Issuing…' : 'Issue Card'}</Text>
        </TouchableOpacity>
      </View>

      <SelectModal
        visible={reasonPickerVisible}
        title="Select reason"
        options={reasonsQuery.data ?? []}
        selectedIds={[]}
        onClose={() => setReasonPickerVisible(false)}
        onChange={([id]) => setReason(reasonsQuery.data?.find((x) => x.id === id)?.label ?? '')}
      />
      <SelectModal
        visible={pointPickerVisible}
        title="House points deducted"
        options={HOUSE_POINTS}
        selectedIds={housePoint ? [housePoint] : []}
        onClose={() => setPointPickerVisible(false)}
        onChange={([id]) => setHousePoint(id)}
      />
    </ScrollView>
  );
}

function StaffDisciplinaryScreen() {
  const theme = useTheme();
  const [qrVisible, setQrVisible] = React.useState(false);
  const [scannedStudent, setScannedStudent] = React.useState<ScannedStudent | null>(null);
  const studentSearch = useStudentSearchByAdmissionNo();
  const [classPickerVisible, setClassPickerVisible] = React.useState(false);
  const [sectionId, setSectionId] = React.useState<string | null>(null);
  const [search, setSearch] = React.useState('');
  const classDropdown = useClassSectionDropdownQuery();
  const classList = useClassListQuery(sectionId);
  const sectionLabel = classDropdown.data?.find((c) => c.id === sectionId)?.label;
  const roster = (classList.data ?? []).filter(
    (st) => !search || `${st.name ?? ''} ${st.admissionNo ?? ''}`.toLowerCase().includes(search.toLowerCase())
  );

  const onQrScanned = (admissionNo: string) => {
    setQrVisible(false);
    studentSearch.mutate(admissionNo, {
      onSuccess: setScannedStudent,
      onError: (error) =>
        Toast.show({
          type: 'error',
          text1: 'Student not found',
          text2: error instanceof Error ? error.message : undefined,
          position: 'top',
          topOffset: 100,
        }),
    });
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      {scannedStudent ? (
        <IssueDisciplinaryForm
          student={scannedStudent}
          onCancel={() => setScannedStudent(null)}
          onSubmitted={() => setScannedStudent(null)}
        />
      ) : (
        <ScrollView contentContainerStyle={staffStyles.formContent}>
          <TouchableOpacity
            style={staffStyles.scanButton}
            disabled={studentSearch.isPending}
            onPress={() => setQrVisible(true)}>
            <Text style={[staffStyles.scanButtonLabel, { textAlign: 'center' }]}>{studentSearch.isPending ? 'Looking up…' : 'Scan QR'}</Text>
          </TouchableOpacity>

          <ThemedText themeColor="textSecondary" style={styles.text}>or choose by class</ThemedText>
          <TouchableOpacity
            style={[staffStyles.input, staffStyles.dropdown, { borderColor: theme.backgroundSelected }]}
            onPress={() => setClassPickerVisible(true)}>
            <ThemedText themeColor={sectionLabel ? 'text' : 'textSecondary'}>{sectionLabel ?? 'Select class'}</ThemedText>
            <ThemedText themeColor="textSecondary">▾</ThemedText>
          </TouchableOpacity>
          {sectionId ? (
            <TextInput
              style={[staffStyles.input, { color: theme.text, borderColor: theme.backgroundSelected }]}
              placeholder="Search student by name or admission no."
              placeholderTextColor={theme.textSecondary}
              value={search}
              onChangeText={setSearch}
            />
          ) : null}
          {classList.isLoading ? <ActivityIndicator color="#2658A5" /> : null}
          {roster.map((st) => (
            <TouchableOpacity
              key={st.id}
              onPress={() =>
                setScannedStudent({
                  id: st.id,
                  admissionNo: st.admissionNo ?? '',
                  name: st.name,
                  profilePic: st.profilePic,
                  standardName: sectionLabel,
                  sectionName: null,
                })
              }>
              <ThemedView type="backgroundElement" style={staffStyles.studentCard}>
                <ThemedText style={staffStyles.studentName}>{st.name}</ThemedText>
                <ThemedText themeColor="textSecondary" style={staffStyles.studentSub}>{st.admissionNo}</ThemedText>
              </ThemedView>
            </TouchableOpacity>
          ))}
        </ScrollView>
      )}

      <SelectModal
        visible={classPickerVisible}
        title="Select class"
        options={classDropdown.data ?? []}
        selectedIds={sectionId ? [sectionId] : []}
        onClose={() => setClassPickerVisible(false)}
        onChange={([id]) => setSectionId(id)}
      />

      <QrScannerModal visible={qrVisible} onClose={() => setQrVisible(false)} onScanned={onQrScanned} />
    </SafeAreaView>
  );
}

function EntryDetail({ entry, card }: { entry: DisciplinaryEntry; card: (typeof CARDS)[number] }) {
  // Native: "Any other reason" is replaced by the free-text reason; otherwise "reason , other".
  const isOther = entry.reason === 'Any other reason';
  const reason = [isOther ? '' : entry.reason, entry.reasonOther].filter(Boolean).join(' , ');
  return (
    <View style={[styles.entryCard, { backgroundColor: card.color }]}>
      <Text style={styles.entryHeader}>{card.title}</Text>
      <Text style={styles.entryRow}>Reason: {reason || '—'}</Text>
      <Text style={styles.entryRow}>Action taken: {entry.actionTaken || '—'}</Text>
      <Text style={styles.entryRow}>Issued to: {entry.issuedTo || '—'}</Text>
      <Text style={styles.entryRow}>
        House points deducted: {entry.housePoint ?? '—'} {entry.houseNo ? `(${entry.houseNo})` : ''}
      </Text>
      <Text style={styles.entryRow}>Issued by: {entry.staffName || '—'}</Text>
      <Text style={styles.entryRow}>Date: {entry.issueDate ? dayjs(entry.issueDate).format('DD-MM-YYYY') : '—'}</Text>
    </View>
  );
}

/** Native: DisciplinaryCardFragment (student/parent) shows 3 categories; a swipeable card-pager on
 * tap. Simplified here to a scrollable list in a modal — same data, simpler navigation. */
export default function DisciplinaryScreen() {
  const session = useSessionStore((s) => s.session);
  const query = useDisciplinaryCardQuery();
  const theme = useTheme();
  const [openKey, setOpenKey] = React.useState<'pink' | 'yellow' | 'red' | null>(null);

  if (session?.isStaff) {
    return <StaffDisciplinaryScreen />;
  }

  if (query.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  const openCategory: DisciplinaryCategory | undefined = openKey ? query.data?.[openKey] : undefined;

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <View style={styles.content}>
        {CARDS.map((card) => {
          const category = query.data?.[card.key];
          return (
            <Pressable
              key={card.key}
              style={[styles.card, { backgroundColor: card.color }]}
              disabled={!category?.count}
              onPress={() => setOpenKey(card.key)}>
              <Text style={styles.cardTitle}>{card.title}</Text>
              <Text style={styles.cardColorName}>{card.colorName}</Text>
              <Text style={styles.cardCount}>{category?.count ?? 0}</Text>
            </Pressable>
          );
        })}
      </View>

      <Modal visible={!!openKey} animationType="slide" onRequestClose={() => setOpenKey(null)}>
        <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }}>
          <Pressable style={styles.closeButton} onPress={() => setOpenKey(null)}>
            <Text style={styles.closeLabel}>Close</Text>
          </Pressable>
          <ScrollView style={styles.scroll} contentContainerStyle={styles.modalContent}>
            {openCategory?.entries.map((entry) => (
              <EntryDetail key={entry.id} entry={entry} card={CARDS.find((c) => c.key === openKey)!} />
            ))}
          </ScrollView>
        </SafeAreaView>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 24 },
  text: { fontSize: 14, textAlign: 'center' },
  content: { padding: 16, gap: 12 },
  card: { borderRadius: 12, padding: 20, alignItems: 'center', gap: 8 },
  cardTitle: { fontSize: 15, fontWeight: '700', color: '#323232' },
  cardColorName: { fontSize: 13, fontWeight: '600', color: '#323232' },
  cardCount: { fontSize: 28, fontWeight: '800', color: '#323232' },
  closeButton: { alignSelf: 'flex-end', padding: 16 },
  closeLabel: { color: '#2658A5', fontWeight: '700' },
  scroll: { flex: 1 },
  modalContent: { padding: 16, gap: 12 },
  entryCard: { gap: 4, padding: 14, borderRadius: 8 },
  entryHeader: { fontSize: 15, fontWeight: '800', color: '#323232', marginBottom: 4 },
  entryRow: { fontSize: 14, color: '#323232' },
});

const staffStyles = StyleSheet.create({
  scanButton: { paddingHorizontal: 24, paddingVertical: 14, borderRadius: 8, backgroundColor: '#2658A5' },
  scanButtonLabel: { color: '#ffffff', fontWeight: '700', fontSize: 15 },
  formContent: { padding: 16, gap: 12, paddingBottom: 32 },
  studentCard: { padding: 14, borderRadius: 10, gap: 2 },
  studentName: { fontSize: 16, fontWeight: '700', textTransform: 'capitalize' },
  studentSub: { fontSize: 13 },
  cardRow: { flexDirection: 'row', gap: 8 },
  cardChoice: { flex: 1, borderRadius: 10, paddingVertical: 14, alignItems: 'center', borderWidth: 2, borderColor: 'transparent' },
  cardChoiceActive: { borderColor: '#323232' },
  cardChoiceColor: { fontSize: 11, fontWeight: '600', color: '#323232', marginTop: 2 },
  dropdown: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  cardChoiceLabel: { fontSize: 12, fontWeight: '700', color: '#323232', textAlign: 'center' },
  input: { borderWidth: 1, borderRadius: 8, padding: 12, minHeight: 48, textAlignVertical: 'top' },
  formActions: { flexDirection: 'row', justifyContent: 'flex-end', gap: 16, marginTop: 4, alignItems: 'center' },
  submitButton: { paddingHorizontal: 20, paddingVertical: 12, borderRadius: 8, backgroundColor: '#2658A5' },
  submitButtonLabel: { color: '#ffffff', fontWeight: '700' },
});
