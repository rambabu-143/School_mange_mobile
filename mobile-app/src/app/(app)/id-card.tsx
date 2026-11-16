import dayjs from 'dayjs';
import * as React from 'react';
import { ActivityIndicator, Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import Toast from 'react-native-toast-message';

import { SelectModal, SelectModalOption } from '@/components/select-modal';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { IdCardChangeFields, useIdCardChangeRequestMutation } from '@/queries/useIdCardChangeRequestMutation';
import { useIdCardQuery } from '@/queries/useIdCardQuery';

const CHANGE_FIELDS: SelectModalOption[] = [
  { id: 'profile_pic', label: 'Student Photograph' },
  { id: 'name', label: 'Name' },
  { id: 'date_of_birth', label: 'Date of Birth' },
  { id: 'bloodgroup', label: 'Blood Group' },
  { id: 'allergies', label: 'Allergies' },
  { id: 'fathers_name', label: "Parent's Name" },
  { id: 'address', label: 'Address' },
  { id: 'sms_mobile', label: 'Mobile' },
  { id: 'transport', label: 'Transport' },
];

function Row({ label }: { label: string }) {
  return <ThemedText style={styles.row}>{label}</ThemedText>;
}

/** Native: IdCardFragment. Student/parent only. "Change Required" opens a checkbox list of fields
 * to flag for admin review (not an inline edit — same PUT either confirms as-is or flags fields). */
export default function IdCardScreen() {
  const idCardQuery = useIdCardQuery();
  const changeRequestMutation = useIdCardChangeRequestMutation();
  const [pickerVisible, setPickerVisible] = React.useState(false);
  const theme = useTheme();

  const submitChangeRequest = (fieldIds: string[]) => {
    const fields = CHANGE_FIELDS.reduce((acc, f) => {
      acc[f.id as keyof IdCardChangeFields] = fieldIds.includes(f.id);
      return acc;
    }, {} as IdCardChangeFields);

    changeRequestMutation.mutate(fields, {
      onSuccess: (res) => Toast.show({ type: 'success', text1: res.message ?? 'Submitted', topOffset: 100, position: 'top' }),
      onError: (err) => Toast.show({ type: 'error', text1: err instanceof Error ? err.message : 'Failed to submit', topOffset: 100, position: 'top' }),
    });
  };

  const confirmNoChange = () => submitChangeRequest([]);

  if (idCardQuery.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  const data = idCardQuery.data;

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <View style={styles.content}>
        {data?.profilePic ? <Image source={{ uri: data.profilePic }} style={styles.photo} /> : null}
        <Row label={`Admission No.: ${data?.admissionNo ?? '—'}`} />
        {data?.session ? <Row label={`Session: ${data.session}`} /> : null}
        <Row label={`Name: ${data?.name ?? '—'}`} />
        <Row label={`Class/Section: ${data?.classSection ?? '—'}`} />
        <Row label={`DOB: ${data?.dateOfBirth ? dayjs(data.dateOfBirth).format('DD-MM-YYYY') : '—'}`} />
        <Row label={`Blood Group: ${data?.bloodGroup ?? '—'}`} />
        <Row label={`Allergies (if any): ${data?.allergies ?? '—'}`} />
        <Row label={`Name: ${data?.fathersName ?? '—'}`} />
        <Row label={`Address: ${data?.address ?? '—'}`} />
        <Row label={`Mobile No: ${data?.mobile ?? '—'}`} />
        <Row label={`Transport: ${data?.transport ?? '—'}`} />

        {data?.changeMessage ? <Text style={styles.changeMessage}>{data.changeMessage}</Text> : null}

        {!data?.formSubmitted && (
          <View style={styles.footer}>
            <TouchableOpacity style={[styles.secondaryButton, { backgroundColor: theme.backgroundElement }]} onPress={() => setPickerVisible(true)}>
              <ThemedText style={styles.secondaryLabel}>Change Required</ThemedText>
            </TouchableOpacity>
            <TouchableOpacity style={styles.primaryButton} onPress={confirmNoChange}>
              <Text style={styles.primaryLabel}>Confirm</Text>
            </TouchableOpacity>
          </View>
        )}
      </View>

      <SelectModal
        visible={pickerVisible}
        title="What needs to change?"
        options={CHANGE_FIELDS}
        selectedIds={[]}
        multiple
        onClose={() => setPickerVisible(false)}
        onChange={submitChangeRequest}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  content: { padding: 16, gap: 8 },
  photo: { width: 100, height: 100, borderRadius: 8, alignSelf: 'center', marginBottom: 8 },
  row: { fontSize: 14 },
  changeMessage: { marginTop: 12, fontSize: 13, color: '#c0392b' },
  footer: { flexDirection: 'row', gap: 12, marginTop: 20 },
  secondaryButton: { flex: 1, alignItems: 'center', paddingVertical: 12, borderRadius: 8 },
  secondaryLabel: { fontWeight: '700' },
  primaryButton: { flex: 1, alignItems: 'center', paddingVertical: 12, borderRadius: 8, backgroundColor: '#2658A5' },
  primaryLabel: { color: '#ffffff', fontWeight: '700' },
});
