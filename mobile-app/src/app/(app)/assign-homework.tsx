import dayjs from 'dayjs';
import * as React from 'react';
import { ActivityIndicator, Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import Toast from 'react-native-toast-message';

import { ThemedText } from '@/components/themed-text';
import { SelectModal } from '@/components/select-modal';
import { useTheme } from '@/hooks/use-theme';
import { useAssignHomeworkMutation } from '@/queries/useAssignHomeworkMutation';
import { useClassListQuery } from '@/queries/useClassListQuery';
import { useHomeworkClassDropdownQuery } from '@/queries/useHomeworkClassDropdownQuery';
import { useHomeworkSubjectListQuery } from '@/queries/useHomeworkSubjectListQuery';

const MAX_LENGTH = 300;

type AssigneeType = 'whole' | 'selected';

function showError(message: string) {
  Toast.show({ type: 'error', text1: message, topOffset: 100, position: 'top' });
}

export default function AssignHomeworkScreen() {
  const theme = useTheme();
  const [classPickerVisible, setClassPickerVisible] = React.useState(false);
  const [sectionId, setSectionId] = React.useState<string | null>(null);
  const [subjectPickerVisible, setSubjectPickerVisible] = React.useState(false);
  const [subjectId, setSubjectId] = React.useState<string | null>(null);
  const [assigneeType, setAssigneeType] = React.useState<AssigneeType | null>(null);
  const [studentsPickerVisible, setStudentsPickerVisible] = React.useState(false);
  const [selectedStudentIds, setSelectedStudentIds] = React.useState<string[]>([]);
  const [text, setText] = React.useState('');

  const classDropdownQuery = useHomeworkClassDropdownQuery();
  const section = classDropdownQuery.data?.find((s) => s.id === sectionId);
  const subjectListQuery = useHomeworkSubjectListQuery(section?.standardId ?? null, section?.id ?? null);
  const subject = subjectListQuery.data?.find((s) => s.id === subjectId);
  const studentsQuery = useClassListQuery(sectionId);
  const submitMutation = useAssignHomeworkMutation();

  const date = dayjs().format('DD-MM-YYYY');

  const selectClass = (id: string) => {
    setSectionId(id);
    setSubjectId(null);
    setAssigneeType(null);
    setSelectedStudentIds([]);
  };

  const handleSubmit = () => {
    if (!section) return showError('Please select standard and section');
    if (!subject) return showError('Please select subject');
    if (!assigneeType) return showError('Please select assignee type');
    if (assigneeType === 'selected' && selectedStudentIds.length === 0) return showError('Please select students');
    if (!text.trim()) return showError('Please enter homework content');

    submitMutation.mutate(
      {
        standardSectionId: section.id,
        subjectId: subject.id,
        text,
        date,
        studentIds: assigneeType === 'selected' ? selectedStudentIds : [],
      },
      {
        onSuccess: () => {
          Toast.show({ type: 'success', text1: 'Homework assigned successfully', topOffset: 100, position: 'top' });
          setAssigneeType(null);
          setSelectedStudentIds([]);
          setText('');
        },
        onError: (err) => showError(err.message),
      }
    );
  };

  return (
    <SafeAreaView style={{ flex: 1 }} edges={['left', 'right', 'bottom']}>
      <ScrollView contentContainerStyle={styles.content}>
        <ThemedText themeColor="textSecondary" style={styles.dateLabel}>Homework for: {date}</ThemedText>

        <Pressable style={[styles.picker, { backgroundColor: theme.backgroundElement }]} onPress={() => setClassPickerVisible(true)}>
          <ThemedText style={styles.pickerLabel}>{section?.label ?? 'Select class'}</ThemedText>
        </Pressable>

        <Pressable
          style={[styles.picker, { backgroundColor: theme.backgroundElement }, !section && styles.pickerDisabled]}
          disabled={!section}
          onPress={() => setSubjectPickerVisible(true)}
        >
          <ThemedText style={styles.pickerLabel}>{subject?.label ?? 'Select subject'}</ThemedText>
        </Pressable>

        <View style={styles.assigneeRow}>
          <Pressable
            style={[
              styles.assigneeButton,
              { backgroundColor: theme.backgroundElement },
              assigneeType === 'whole' && styles.assigneeButtonActive,
            ]}
            onPress={() => {
              setAssigneeType('whole');
              setSelectedStudentIds([]);
            }}
          >
            <ThemedText style={[styles.assigneeLabel, assigneeType === 'whole' && styles.assigneeLabelActive]}>Whole Class</ThemedText>
          </Pressable>
          <Pressable
            style={[
              styles.assigneeButton,
              { backgroundColor: theme.backgroundElement },
              assigneeType === 'selected' && styles.assigneeButtonActive,
            ]}
            onPress={() => setAssigneeType('selected')}
          >
            <ThemedText style={[styles.assigneeLabel, assigneeType === 'selected' && styles.assigneeLabelActive]}>Selected Students</ThemedText>
          </Pressable>
        </View>

        {assigneeType === 'selected' && (
          <Pressable style={[styles.picker, { backgroundColor: theme.backgroundElement }]} onPress={() => setStudentsPickerVisible(true)}>
            <ThemedText style={styles.pickerLabel}>
              {selectedStudentIds.length === 0 ? 'Select Students' : `${selectedStudentIds.length} Student${selectedStudentIds.length > 1 ? 's' : ''} Selected`}
            </ThemedText>
          </Pressable>
        )}

        <View>
          <TextInput
            placeholder="Homework content"
            placeholderTextColor={theme.textSecondary}
            value={text}
            onChangeText={(v) => setText(v.slice(0, MAX_LENGTH))}
            multiline
            style={[styles.textArea, { color: theme.text }]}
          />
          <ThemedText themeColor="textSecondary" style={styles.charCounter}>
            {text.length}/{MAX_LENGTH}
          </ThemedText>
        </View>

        <Pressable style={styles.submitButton} onPress={handleSubmit} disabled={submitMutation.isPending}>
          {submitMutation.isPending ? <ActivityIndicator color="#fff" /> : <Text style={styles.submitLabel}>Assign Homework</Text>}
        </Pressable>
      </ScrollView>

      <SelectModal
        visible={classPickerVisible}
        title="Select class"
        options={classDropdownQuery.data ?? []}
        selectedIds={sectionId ? [sectionId] : []}
        onClose={() => setClassPickerVisible(false)}
        onChange={([id]) => selectClass(id)}
      />
      <SelectModal
        visible={subjectPickerVisible}
        title="Select subject"
        options={subjectListQuery.data ?? []}
        selectedIds={subjectId ? [subjectId] : []}
        onClose={() => setSubjectPickerVisible(false)}
        onChange={([id]) => setSubjectId(id)}
      />
      <SelectModal
        visible={studentsPickerVisible}
        title={`Students of Class ${section?.label ?? ''}`}
        multiple
        options={(studentsQuery.data ?? []).map((s) => ({ id: s.id, label: `${s.name} (${s.admissionNo})` }))}
        selectedIds={selectedStudentIds}
        onClose={() => setStudentsPickerVisible(false)}
        onChange={setSelectedStudentIds}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  content: { padding: 16, gap: 12 },
  dateLabel: { fontSize: 13 },
  picker: { padding: 12, borderRadius: 8 },
  pickerDisabled: { opacity: 0.5 },
  pickerLabel: { fontSize: 15 },
  assigneeRow: { flexDirection: 'row', gap: 8 },
  assigneeButton: { flex: 1, alignItems: 'center', paddingVertical: 10, borderRadius: 8 },
  assigneeButtonActive: { backgroundColor: '#2658A5' },
  assigneeLabel: { fontSize: 13, fontWeight: '600' },
  assigneeLabelActive: { color: '#fff' },
  textArea: { minHeight: 120, borderWidth: 1, borderColor: '#8884', borderRadius: 8, padding: 12, fontSize: 14, textAlignVertical: 'top' },
  charCounter: { textAlign: 'right', fontSize: 12, marginTop: 4 },
  submitButton: { alignItems: 'center', paddingVertical: 14, borderRadius: 8, backgroundColor: '#2658A5' },
  submitLabel: { color: '#fff', fontWeight: '700', fontSize: 15 },
});
