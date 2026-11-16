import * as React from 'react';
import { FlatList, Modal, Pressable, StyleSheet, Text } from 'react-native';

export type SelectModalOption = { id: string; label: string };

type SelectModalProps = {
  visible: boolean;
  title: string;
  options: SelectModalOption[];
  selectedIds: string[];
  multiple?: boolean;
  onClose: () => void;
  onChange: (ids: string[]) => void;
};

/** Plain Modal + FlatList picker — Expo-Go-safe stand-in for native's checkbox-list dialogs (Class List / House List). */
export function SelectModal({ visible, onClose, ...bodyProps }: SelectModalProps) {
  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onClose}>
      <Pressable style={styles.backdrop} onPress={onClose}>
        {/* Mounted fresh each time the modal opens, so `pending` always starts from the current selection. */}
        {visible && <SelectModalBody {...bodyProps} onClose={onClose} />}
      </Pressable>
    </Modal>
  );
}

function SelectModalBody({ title, options, selectedIds, multiple, onClose, onChange }: Omit<SelectModalProps, 'visible'>) {
  const [pending, setPending] = React.useState<string[]>(selectedIds);

  const toggle = (id: string) => {
    if (!multiple) {
      onChange([id]);
      onClose();
      return;
    }
    setPending((prev) => (prev.includes(id) ? prev.filter((v) => v !== id) : [...prev, id]));
  };

  const toggleAll = () => {
    setPending((prev) => (prev.length === options.length ? [] : options.map((o) => o.id)));
  };

  return (
    <Pressable style={styles.sheet} onPress={(e) => e.stopPropagation()}>
      <Text style={styles.title}>{title}</Text>

      {multiple && (
        <Pressable style={styles.row} onPress={toggleAll}>
          <Text style={styles.checkbox}>{pending.length === options.length ? '☑' : '☐'}</Text>
          <Text style={styles.rowLabel}>Select all</Text>
        </Pressable>
      )}

      <FlatList
        data={options}
        keyExtractor={(item) => item.id}
        style={styles.list}
        renderItem={({ item }) => (
          <Pressable style={styles.row} onPress={() => toggle(item.id)}>
            {multiple && <Text style={styles.checkbox}>{pending.includes(item.id) ? '☑' : '☐'}</Text>}
            <Text style={styles.rowLabel}>{item.label}</Text>
          </Pressable>
        )}
      />

      {multiple && (
        <Pressable
          style={styles.submitButton}
          onPress={() => {
            onChange(pending);
            onClose();
          }}
        >
          <Text style={styles.submitLabel}>Done</Text>
        </Pressable>
      )}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  backdrop: { flex: 1, backgroundColor: '#00000066', justifyContent: 'center', padding: 24 },
  sheet: { maxHeight: '70%', borderRadius: 8, backgroundColor: '#fff', padding: 16, gap: 8 },
  title: { fontSize: 16, fontWeight: '700', color: '#323232', marginBottom: 4 },
  list: { flexGrow: 0 },
  row: { flexDirection: 'row', alignItems: 'center', gap: 10, paddingVertical: 10 },
  checkbox: { fontSize: 16, color: '#2658A5' },
  rowLabel: { fontSize: 15, color: '#323232' },
  submitButton: { alignItems: 'center', paddingVertical: 12, borderRadius: 8, backgroundColor: '#2658A5', marginTop: 8 },
  submitLabel: { color: '#fff', fontWeight: '700' },
});
