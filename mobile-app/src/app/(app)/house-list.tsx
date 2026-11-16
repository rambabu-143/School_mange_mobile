import * as React from 'react';
import { ActivityIndicator, FlatList, Image, Pressable, StyleSheet, Text, TextInput, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { SelectModal } from '@/components/select-modal';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useClassSectionDropdownQuery } from '@/queries/useClassSectionDropdownQuery';
import { useHouseListDropdownQuery } from '@/queries/useHouseListDropdownQuery';
import { useHouseListMutation } from '@/queries/useHouseListMutation';

const matches = (s: { name?: string | null; admissionNo?: string | null }, q: string) =>
  !q || (s.name ?? '').toLowerCase().includes(q.toLowerCase()) || (s.admissionNo ?? '').toLowerCase().includes(q.toLowerCase());

export default function HouseListScreen() {
  const theme = useTheme();
  const [classPickerVisible, setClassPickerVisible] = React.useState(false);
  const [housePickerVisible, setHousePickerVisible] = React.useState(false);
  const [selectedSections, setSelectedSections] = React.useState<string[]>([]);
  const [search, setSearch] = React.useState('');
  const [selectedHouses, setSelectedHouses] = React.useState<string[]>([]);

  const classDropdownQuery = useClassSectionDropdownQuery();
  const houseDropdownQuery = useHouseListDropdownQuery();
  const houseListMutation = useHouseListMutation();

  const handleGo = () => {
    if (selectedSections.length === 0 || selectedHouses.length === 0) return;
    houseListMutation.mutate({ standardSections: selectedSections, houses: selectedHouses });
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <View style={styles.filters}>
        <Pressable style={[styles.picker, { backgroundColor: theme.backgroundElement }]} onPress={() => setClassPickerVisible(true)}>
          <ThemedText style={styles.pickerLabel}>Class: {selectedSections.length || 'Select'}</ThemedText>
        </Pressable>
        <Pressable style={[styles.picker, { backgroundColor: theme.backgroundElement }]} onPress={() => setHousePickerVisible(true)}>
          <ThemedText style={styles.pickerLabel}>House: {selectedHouses.length || 'Select'}</ThemedText>
        </Pressable>
        <Pressable style={styles.goButton} onPress={handleGo}>
          <Text style={styles.goLabel}>Go</Text>
        </Pressable>
      </View>

      <TextInput
        placeholder="Search by name or admission no."
        placeholderTextColor={theme.textSecondary}
        value={search}
        onChangeText={setSearch}
        style={[styles.searchInput, { color: theme.text }]}
      />

      {houseListMutation.isPending ? (
        <ThemedView style={styles.centered}>
          <ActivityIndicator size="large" color="#2658A5" />
        </ThemedView>
      ) : (
        <FlatList
          data={(houseListMutation.data ?? []).filter((s) => matches(s, search))}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.listContent}
          renderItem={({ item }) => (
            <ThemedView type="backgroundElement" style={styles.card}>
              {item.profilePic ? (
                <Image source={{ uri: item.profilePic }} style={styles.avatar} />
              ) : (
                <View style={[styles.avatar, styles.avatarPlaceholder]}>
                  <Text style={styles.avatarInitial}>{(item.name ?? '?').charAt(0).toUpperCase()}</Text>
                </View>
              )}
              <View style={{ flex: 1 }}>
                <ThemedText style={styles.name}>{item.name}</ThemedText>
                <ThemedText themeColor="textSecondary" style={styles.meta}>
                  {item.admissionNo}
                </ThemedText>
              </View>
            </ThemedView>
          )}
          ListEmptyComponent={
            <ThemedView style={styles.centered}>
              <ThemedText themeColor="textSecondary" style={styles.text}>
                {houseListMutation.isError
                  ? houseListMutation.error.message
                  : 'Select at least one class and house, then tap Go.'}
              </ThemedText>
            </ThemedView>
          }
        />
      )}

      <SelectModal
        visible={classPickerVisible}
        title="Select class"
        multiple
        options={classDropdownQuery.data ?? []}
        selectedIds={selectedSections}
        onClose={() => setClassPickerVisible(false)}
        onChange={setSelectedSections}
      />
      <SelectModal
        visible={housePickerVisible}
        title="Select house"
        multiple
        options={(houseDropdownQuery.data ?? []).map((h) => ({ id: h.id, label: h.houseNo }))}
        selectedIds={selectedHouses}
        onClose={() => setHousePickerVisible(false)}
        onChange={setSelectedHouses}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  searchInput: { borderWidth: 1, borderColor: '#8884', borderRadius: 8, marginHorizontal: 12, paddingHorizontal: 12, paddingVertical: 8, fontSize: 14 },
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  filters: { flexDirection: 'row', gap: 8, margin: 12, alignItems: 'center' },
  picker: { flex: 1, padding: 12, borderRadius: 8 },
  pickerLabel: { fontSize: 14 },
  goButton: { paddingHorizontal: 16, paddingVertical: 12, borderRadius: 8, backgroundColor: '#2658A5' },
  goLabel: { color: '#fff', fontWeight: '700' },
  listContent: { gap: 12, padding: 12 },
  card: { flexDirection: 'row', alignItems: 'center', gap: 12, padding: 12, borderRadius: 8 },
  avatar: { width: 48, height: 48, borderRadius: 24 },
  avatarPlaceholder: { backgroundColor: '#2658A5', alignItems: 'center', justifyContent: 'center' },
  avatarInitial: { color: '#fff', fontSize: 18, fontWeight: '700' },
  name: { fontSize: 15, fontWeight: '600' },
  meta: { fontSize: 13 },
  text: { fontSize: 14, textAlign: 'center', paddingHorizontal: 24 },
});
