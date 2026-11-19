import * as React from 'react';
import { ActivityIndicator, Modal, ScrollView, StyleSheet, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import Toast from 'react-native-toast-message';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useSelfAwarenessMutation } from '@/queries/useSelfAwarenessMutation';
import { useSelfAwarenessQuery } from '@/queries/useSelfAwarenessQuery';

function Field({ label, value, onChangeText, error }: { label: string; value: string; onChangeText: (v: string) => void; error?: string | null }) {
  const theme = useTheme();
  return (
    <View style={styles.field}>
      <ThemedText themeColor="textSecondary" style={styles.fieldLabel}>{label}</ThemedText>
      <TextInput
        style={[styles.input, { color: theme.text }]}
        value={value}
        onChangeText={onChangeText}
        multiline
        placeholderTextColor={theme.textSecondary}
      />
      {error ? <Text style={styles.errorText}>{error}</Text> : null}
    </View>
  );
}

function ReadRow({ label, value }: { label: string; value?: string | null }) {
  return (
    <View style={styles.readRow}>
      <ThemedText themeColor="textSecondary" style={styles.fieldLabel}>{label}</ThemedText>
      <ThemedText style={styles.readValue}>{value}</ThemedText>
    </View>
  );
}

/** Native: SelfAwarenessFragment. A 4-field form (Goal, Strength, Interest/Hobbies,
 * Responsibilities); "Preview" opens a confirm dialog with Save as Draft / Submit. Once submitted,
 * shows a read-only view instead. Requires a "golive" round opened server-side for this section. */
export default function SelfAwarenessScreen() {
  const query = useSelfAwarenessQuery();
  const mutation = useSelfAwarenessMutation();
  const theme = useTheme();

  const [goal, setGoal] = React.useState('');
  const [strength, setStrength] = React.useState('');
  const [hobbies, setHobbies] = React.useState('');
  const [responsibilities, setResponsibilities] = React.useState('');
  const [previewVisible, setPreviewVisible] = React.useState(false);
  const [error, setError] = React.useState<string | null>(null);

  React.useEffect(() => {
    if (!query.data) return;
    // eslint-disable-next-line react-hooks/set-state-in-effect -- sync server data into editable local state
    setGoal(query.data.myGoal ?? '');
    setStrength(query.data.myStrength ?? '');
    setHobbies(query.data.myInterestHobbies ?? '');
    setResponsibilities(query.data.responsibilities ?? '');
  }, [query.data]);

  const openPreview = () => setPreviewVisible(true);

  const submit = (isSubmit: boolean) => {
    if (isSubmit) {
      if (!goal.trim()) return setError('Please enter Goal');
      if (!strength.trim()) return setError('Please enter Strength');
      if (!hobbies.trim()) return setError('Please enter Hobbies');
      if (!responsibilities.trim()) return setError('Please enter Hobbies');
    }
    setError(null);
    setPreviewVisible(false);
    mutation.mutate(
      { myGoal: goal, myStrength: strength, myInterestHobbies: hobbies, responsibilities, isSubmit },
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

  if (query.isError) {
    return (
      <ThemedView style={styles.centered}>
        <ThemedText themeColor="textSecondary" style={styles.text}>{query.error.message}</ThemedText>
      </ThemedView>
    );
  }

  if (query.data?.isSubmit) {
    return (
      <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
        <ScrollView style={styles.scroll} contentContainerStyle={styles.content}>
          <ReadRow label="My Goal" value={query.data.myGoal} />
          <ReadRow label="My Strength" value={query.data.myStrength} />
          <ReadRow label="My Interests / Hobbies" value={query.data.myInterestHobbies} />
          <ReadRow label="Responsibilities" value={query.data.responsibilities} />
        </ScrollView>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <ScrollView contentContainerStyle={styles.content}>
        <Field label="My Goal" value={goal} onChangeText={setGoal} />
        <Field label="My Strength" value={strength} onChangeText={setStrength} />
        <Field label="My Interests / Hobbies" value={hobbies} onChangeText={setHobbies} />
        <Field label="Responsibilities" value={responsibilities} onChangeText={setResponsibilities} />

        <TouchableOpacity style={styles.previewButton} onPress={openPreview}>
          <Text style={styles.previewLabel}>Preview</Text>
        </TouchableOpacity>
      </ScrollView>

      <Modal visible={previewVisible} transparent animationType="fade" onRequestClose={() => setPreviewVisible(false)}>
        <View style={styles.modalBackdrop}>
          <ThemedView type="backgroundElement" style={styles.modalSheet}>
            <ScrollView style={styles.scroll}>
              <ReadRow label="My Goal" value={goal} />
              <ReadRow label="My Strength" value={strength} />
              <ReadRow label="My Interests / Hobbies" value={hobbies} />
              <ReadRow label="Responsibilities" value={responsibilities} />
              {error ? <Text style={styles.errorText}>{error}</Text> : null}
            </ScrollView>
            <View style={styles.modalFooter}>
              <TouchableOpacity style={styles.secondaryButton} onPress={() => submit(false)}>
                <Text style={styles.secondaryLabel}>Save as Draft</Text>
              </TouchableOpacity>
              <TouchableOpacity style={styles.primaryButton} onPress={() => submit(true)}>
                <Text style={styles.primaryLabel}>Submit</Text>
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
  scroll: { flex: 1 },
  text: { fontSize: 14, textAlign: 'center' },
  content: { padding: 16, gap: 16 },
  field: { gap: 6 },
  fieldLabel: { fontSize: 13, fontWeight: '600' },
  input: { borderWidth: 1, borderColor: '#8884', borderRadius: 8, padding: 12, fontSize: 14, minHeight: 60, textAlignVertical: 'top' },
  errorText: { color: '#c0392b', fontSize: 12 },
  previewButton: { marginTop: 8, alignItems: 'center', paddingVertical: 14, borderRadius: 8, backgroundColor: '#2658A5' },
  previewLabel: { color: '#ffffff', fontWeight: '700' },
  readRow: { gap: 4, marginBottom: 16 },
  readValue: { fontSize: 15 },
  modalBackdrop: { flex: 1, backgroundColor: '#00000066', justifyContent: 'center', padding: 24 },
  modalSheet: { maxHeight: '80%', borderRadius: 12, padding: 16, gap: 12 },
  modalFooter: { flexDirection: 'row', gap: 12 },
  secondaryButton: { flex: 1, alignItems: 'center', paddingVertical: 12, borderRadius: 8, backgroundColor: '#eeeeee' },
  secondaryLabel: { color: '#323232', fontWeight: '700' },
  primaryButton: { flex: 1, alignItems: 'center', paddingVertical: 12, borderRadius: 8, backgroundColor: '#2658A5' },
  primaryLabel: { color: '#ffffff', fontWeight: '700' },
});
