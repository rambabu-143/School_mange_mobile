import * as React from 'react';
import { ActivityIndicator, Linking, ScrollView, StyleSheet, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import Toast from 'react-native-toast-message';

import { SelectModal } from '@/components/select-modal';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useStreamSelectionMutation } from '@/queries/useStreamSelectionMutation';
import { useStreamSelectionQuery } from '@/queries/useStreamSelectionQuery';

const SUBJECT_SLOTS = ['subject1', 'subject2', 'subject3', 'subject4', 'subject5'] as const;
const SLOT_LABELS = ['Subject 1', 'Subject 2', 'Subject 3', 'Subject 4', 'Subject 5'];

/** Native: StreamSelectionFragment. Pick a combination, then pick one subject per slot (5
 * required, an optional 6th "addition subject" if the combination allows it), plus a remark, then
 * Submit. Native's "already submitted -> read-only view" branch is entirely commented-out dead
 * code, so this always shows the live form, matching what real users actually see. */
export default function StreamSelectionScreen() {
  const query = useStreamSelectionQuery();
  const mutation = useStreamSelectionMutation();
  const theme = useTheme();

  const [combinationId, setCombinationId] = React.useState<string | null>(null);
  const [subjects, setSubjects] = React.useState<Record<string, string>>({});
  const [remark, setRemark] = React.useState('');
  const [pickerOpen, setPickerOpen] = React.useState<string | null>(null);

  const combination = query.data?.combinations.find((c) => c.id === combinationId);

  const setSubject = (slot: string, id: string) => setSubjects((prev) => ({ ...prev, [slot]: id }));

  const submit = () => {
    if (!combination) return Toast.show({ type: 'error', text1: 'Please select combination', topOffset: 100, position: 'top' });
    for (let i = 0; i < SUBJECT_SLOTS.length; i++) {
      if (!subjects[SUBJECT_SLOTS[i]]) {
        return Toast.show({ type: 'error', text1: `Please select subject ${i + 1}`, topOffset: 100, position: 'top' });
      }
    }
    mutation.mutate(
      {
        combinationId: combination.id,
        subject1: subjects.subject1,
        subject2: subjects.subject2,
        subject3: subjects.subject3,
        subject4: subjects.subject4,
        subject5: subjects.subject5,
        subject6: subjects.subject6,
        isAdditionalSubject: !!subjects.subject6,
        remark,
      },
      {
        onSuccess: (res) => Toast.show({ type: 'success', text1: res.message ?? 'Saved', topOffset: 100, position: 'top' }),
        onError: (err) => Toast.show({ type: 'error', text1: err instanceof Error ? err.message : 'Failed to save', topOffset: 100, position: 'top' }),
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

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <ScrollView style={styles.scroll} contentContainerStyle={styles.content}>
        {query.data?.eligibilityCriteria ? (
          <TouchableOpacity onPress={() => Linking.openURL(query.data!.eligibilityCriteria!)}>
            <Text style={styles.eligibilityLink}>View Eligibility Criteria</Text>
          </TouchableOpacity>
        ) : null}

        <TouchableOpacity
          style={[styles.picker, { backgroundColor: theme.backgroundElement }]}
          onPress={() => setPickerOpen('combination')}>
          <ThemedText style={styles.pickerLabel}>{combination?.combinationName ?? 'Select Combination'}</ThemedText>
        </TouchableOpacity>

        {combination &&
          SUBJECT_SLOTS.map((slot, i) => {
            const options = combination[slot];
            const selected = options.find((o) => o.id === subjects[slot]);
            return (
              <TouchableOpacity
                key={slot}
                style={[styles.picker, { backgroundColor: theme.backgroundElement }]}
                onPress={() => setPickerOpen(slot)}>
                <ThemedText style={styles.pickerLabel}>{selected?.label ?? 'Select Subject'}</ThemedText>
                <ThemedText themeColor="textSecondary" style={styles.slotHint}>{SLOT_LABELS[i]}</ThemedText>
              </TouchableOpacity>
            );
          })}

        {combination?.isAdditionalSubject && combination.subject6.length > 0 ? (
          <TouchableOpacity
            style={[styles.picker, { backgroundColor: theme.backgroundElement }]}
            onPress={() => setPickerOpen('subject6')}>
            <ThemedText style={styles.pickerLabel}>
              {combination.subject6.find((o) => o.id === subjects.subject6)?.label ?? 'Select Subject (optional)'}
            </ThemedText>
            <ThemedText themeColor="textSecondary" style={styles.slotHint}>Addition Subject</ThemedText>
          </TouchableOpacity>
        ) : null}

        <TextInput
          style={[styles.remarkInput, { color: theme.text }]}
          placeholder="Any other subject that you would like to study?"
          placeholderTextColor={theme.textSecondary}
          value={remark}
          onChangeText={setRemark}
          multiline
        />

        <TouchableOpacity style={styles.submitButton} onPress={submit} disabled={mutation.isPending}>
          <Text style={styles.submitLabel}>Submit</Text>
        </TouchableOpacity>
      </ScrollView>

      <SelectModal
        visible={pickerOpen === 'combination'}
        title="Select Combination"
        options={(query.data?.combinations ?? []).map((c) => ({ id: c.id, label: c.combinationName }))}
        selectedIds={combinationId ? [combinationId] : []}
        onClose={() => setPickerOpen(null)}
        onChange={([id]) => {
          setCombinationId(id);
          setSubjects({});
        }}
      />
      {([...SUBJECT_SLOTS, 'subject6'] as const).map((slot) =>
        pickerOpen === slot && combination ? (
          <SelectModal
            key={slot}
            visible
            title="Select Subject"
            options={combination[slot]}
            selectedIds={subjects[slot] ? [subjects[slot]] : []}
            onClose={() => setPickerOpen(null)}
            onChange={([id]) => setSubject(slot, id)}
          />
        ) : null
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  scroll: { flex: 1 },
  content: { padding: 16, gap: 10 },
  eligibilityLink: { color: '#2658A5', fontWeight: '600', marginBottom: 4 },
  picker: { padding: 12, borderRadius: 8 },
  pickerLabel: { fontSize: 15 },
  slotHint: { fontSize: 11, marginTop: 2 },
  remarkInput: { borderWidth: 1, borderColor: '#8884', borderRadius: 8, padding: 12, fontSize: 14, minHeight: 60, textAlignVertical: 'top', marginTop: 8 },
  submitButton: { marginTop: 12, alignItems: 'center', paddingVertical: 14, borderRadius: 8, backgroundColor: '#2658A5' },
  submitLabel: { color: '#ffffff', fontWeight: '700' },
});
