import * as React from 'react';
import { ActivityIndicator, Modal, Pressable, ScrollView, StyleSheet, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import Toast from 'react-native-toast-message';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { SiblingLookupResult, useSiblingLookup, useTransportRenewalMutation } from '@/queries/useTransportRenewalMutation';
import { useTransportRenewalQuery } from '@/queries/useTransportRenewalQuery';

const RENEW_TERMS =
  'I hereby agree,\n' +
  '1. I may be required to travel in the bus a maximum of four times in the year from the first stop to the school in the morning and from the school to the last stop in the afternoon, as per the schedule provided, at least a week in advance. I agree to do this or arrange a substitute when required.\n' +
  '2. The school is held indemnified against all claims through accident or any other cause.\n' +
  '3. I have read the transport rules given in the school almanac and my ward will follow them.';

function Row({ label, value }: { label: string; value?: string | null }) {
  if (!value) return null;
  return (
    <View style={styles.row}>
      <ThemedText themeColor="textSecondary" style={styles.label}>{label}</ThemedText>
      <ThemedText style={styles.value}>{value}</ThemedText>
    </View>
  );
}

/** Native: TransportRenewalFragment. Renew/Withdraw choice + optional sibling add (by admission
 * no.) + a terms-and-conditions confirm dialog before submit. Address/mobile fields native shows
 * as editable text are never actually included in the POST body - rendered read-only here instead
 * of faking editability that doesn't do anything. */
export default function TransportRenewalScreen() {
  const query = useTransportRenewalQuery();
  const submitMutation = useTransportRenewalMutation();
  const siblingLookup = useSiblingLookup();
  const theme = useTheme();

  const [transportType, setTransportType] = React.useState<'renew' | 'withdraw'>('renew');
  const [admissionNoInput, setAdmissionNoInput] = React.useState('');
  const [siblings, setSiblings] = React.useState<SiblingLookupResult[]>([]);
  const [confirmVisible, setConfirmVisible] = React.useState(false);

  const addSibling = () => {
    const admissionNo = admissionNoInput.trim();
    if (!admissionNo) {
      Toast.show({ type: 'error', text1: 'Please enter admission no.', topOffset: 100, position: 'top' });
      return;
    }
    if (siblings.some((s) => s.admissionNo === admissionNo)) {
      Toast.show({ type: 'error', text1: 'Sibling Already Exist', topOffset: 100, position: 'top' });
      return;
    }
    siblingLookup.mutate(admissionNo, {
      onSuccess: (result) => {
        setSiblings((prev) => [...prev, result]);
        setAdmissionNoInput('');
      },
      onError: (err) => Toast.show({ type: 'error', text1: err instanceof Error ? err.message : 'Lookup failed', topOffset: 100, position: 'top' }),
    });
  };

  const submit = () => {
    submitMutation.mutate(
      { transportType, siblings },
      {
        onSuccess: () => {
          setConfirmVisible(false);
          Toast.show({ type: 'success', text1: 'Submitted', topOffset: 100, position: 'top' });
        },
        onError: (err) => Toast.show({ type: 'error', text1: err instanceof Error ? err.message : 'Submit failed', topOffset: 100, position: 'top' }),
      }
    );
  };

  if (query.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  if (!query.data?.form) {
    return (
      <ThemedView style={styles.centered}>
        <ThemedText themeColor="textSecondary" style={styles.text}>
          {query.data?.message ?? 'Transport renewal form not available.'}
        </ThemedText>
      </ThemedView>
    );
  }

  const form = query.data.form;
  const nextYear = form.nextYearSession ?? '';
  const withdrawYearStart = nextYear.split('-')[0];

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <ScrollView contentContainerStyle={styles.content}>
        <ThemedText style={styles.title}>TRANSPORT RENEWAL FORM FOR THE SESSION ({nextYear})</ThemedText>
        {form.branchAddress ? (
          <ThemedText themeColor="textSecondary" style={styles.address}>{form.branchAddress}</ThemedText>
        ) : null}

        <ThemedView type="backgroundElement" style={styles.card}>
          <Row label="Student" value={`${form.studentName ?? ''} (${form.admissionNo ?? ''})`} />
          <Row label="Provisional Class" value={form.promotedClass} />
          <Row label="Address" value={form.address} />
          <Row label="SMS Mobile" value={form.smsMobile} />
          <Row label="Father's Mobile" value={form.fatherMobile} />
          <Row label="Mother's Mobile" value={form.motherMobile} />
        </ThemedView>

        <ThemedText themeColor="textSecondary" style={styles.sectionTitle}>Current Transport</ThemedText>
        <ThemedView type="backgroundElement" style={styles.card}>
          <Row label="Morning route" value={form.currentMorningRoute} />
          <Row label="Pick-up point" value={form.currentPickupStop} />
          <Row label="Afternoon route" value={form.currentEveningRoute} />
          <Row label="Drop-off point" value={form.currentDropStop} />
        </ThemedView>

        <View style={styles.radioRow}>
          <Pressable style={styles.radioOption} onPress={() => setTransportType('renew')}>
            <View style={[styles.radioDot, transportType === 'renew' && styles.radioDotActive]} />
            <ThemedText style={styles.radioLabel}>Renew</ThemedText>
          </Pressable>
          <Pressable style={styles.radioOption} onPress={() => setTransportType('withdraw')}>
            <View style={[styles.radioDot, transportType === 'withdraw' && styles.radioDotActive]} />
            <ThemedText style={styles.radioLabel}>Withdraw</ThemedText>
          </Pressable>
        </View>

        <ThemedText themeColor="textSecondary" style={styles.sectionTitle}>Sibling? Add by admission no.</ThemedText>
        <View style={styles.siblingRow}>
          <TextInput
            style={[styles.siblingInput, { color: theme.text }]}
            placeholder="Admission no."
            placeholderTextColor={theme.textSecondary}
            value={admissionNoInput}
            onChangeText={setAdmissionNoInput}
          />
          <TouchableOpacity style={styles.addButton} onPress={addSibling} disabled={siblingLookup.isPending}>
            <Text style={styles.addButtonLabel}>Add</Text>
          </TouchableOpacity>
        </View>
        {siblings.map((s, i) => (
          <ThemedText key={s.admissionNo ?? i} style={styles.siblingItem}>
            {i + 1}. {s.admissionNo}-{s.name} ({s.section})
          </ThemedText>
        ))}

        <TouchableOpacity style={styles.submitButton} onPress={() => setConfirmVisible(true)}>
          <Text style={styles.submitLabel}>Submit</Text>
        </TouchableOpacity>
      </ScrollView>

      <Modal visible={confirmVisible} transparent animationType="fade" onRequestClose={() => setConfirmVisible(false)}>
        <View style={styles.modalBackdrop}>
          <ThemedView type="backgroundElement" style={styles.modalSheet}>
            <ThemedText style={styles.modalTitle}>{transportType === 'renew' ? 'Terms and Conditions' : 'Declaration'}</ThemedText>
            <ScrollView style={{ maxHeight: 300 }}>
              <ThemedText style={styles.modalText}>
                {transportType === 'renew'
                  ? RENEW_TERMS
                  : `I hereby accept and confirm that the school transport facility for my ward be withdrawn w.e.f 1st April ${withdrawYearStart} for the session ${nextYear}.`}
              </ThemedText>
            </ScrollView>
            <View style={styles.modalFooter}>
              <TouchableOpacity style={styles.secondaryButton} onPress={() => setConfirmVisible(false)}>
                <Text style={styles.secondaryLabel}>Close</Text>
              </TouchableOpacity>
              <TouchableOpacity style={styles.primaryButton} onPress={submit} disabled={submitMutation.isPending}>
                <Text style={styles.primaryLabel}>Save</Text>
              </TouchableOpacity>
            </View>
          </ThemedView>
        </View>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 24 },
  text: { fontSize: 14, textAlign: 'center' },
  content: { padding: 16, gap: 12 },
  title: { fontSize: 15, fontWeight: '700' },
  address: { fontSize: 12 },
  sectionTitle: { fontSize: 13, fontWeight: '600', marginTop: 8 },
  card: { gap: 8, padding: 12, borderRadius: 8 },
  row: { gap: 2 },
  label: { fontSize: 11, textTransform: 'uppercase' },
  value: { fontSize: 14 },
  radioRow: { flexDirection: 'row', gap: 24, marginTop: 8 },
  radioOption: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  radioDot: { width: 18, height: 18, borderRadius: 9, borderWidth: 2, borderColor: '#2658A5' },
  radioDotActive: { backgroundColor: '#2658A5' },
  radioLabel: { fontSize: 14 },
  siblingRow: { flexDirection: 'row', gap: 8 },
  siblingInput: { flex: 1, borderWidth: 1, borderColor: '#8884', borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10 },
  addButton: { paddingHorizontal: 16, justifyContent: 'center', borderRadius: 8, backgroundColor: '#eeeeee' },
  addButtonLabel: { fontWeight: '700', color: '#2658A5' },
  siblingItem: { fontSize: 13 },
  submitButton: { marginTop: 16, alignItems: 'center', paddingVertical: 14, borderRadius: 8, backgroundColor: '#2658A5' },
  submitLabel: { color: '#ffffff', fontWeight: '700' },
  modalBackdrop: { flex: 1, backgroundColor: '#00000066', justifyContent: 'center', padding: 24 },
  modalSheet: { borderRadius: 12, padding: 16, gap: 12 },
  modalTitle: { fontSize: 16, fontWeight: '700' },
  modalText: { fontSize: 13, lineHeight: 20 },
  modalFooter: { flexDirection: 'row', gap: 12 },
  secondaryButton: { flex: 1, alignItems: 'center', paddingVertical: 12, borderRadius: 8, backgroundColor: '#eeeeee' },
  secondaryLabel: { color: '#323232', fontWeight: '700' },
  primaryButton: { flex: 1, alignItems: 'center', paddingVertical: 12, borderRadius: 8, backgroundColor: '#2658A5' },
  primaryLabel: { color: '#ffffff', fontWeight: '700' },
});
