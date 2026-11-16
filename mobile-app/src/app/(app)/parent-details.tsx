import * as React from 'react';
import { ActivityIndicator, FlatList, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useProfileDetailQuery } from '@/queries/useProfileDetailQuery';

function Row({ label, value }: { label: string; value?: string | null }) {
  if (!value) return null;
  return (
    <View style={styles.row}>
      <ThemedText themeColor="textSecondary" style={styles.label}>{label}</ThemedText>
      <ThemedText style={styles.value}>{value}</ThemedText>
    </View>
  );
}

/** Native: ParentFragment — view of studentDetail.data.relation (father/mother/guardian). Student/parent only. */
export default function ParentDetailsScreen() {
  const profileDetailQuery = useProfileDetailQuery();
  const theme = useTheme();

  if (profileDetailQuery.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <FlatList
        data={profileDetailQuery.data?.relations ?? []}
        keyExtractor={(item, index) => item.relation ?? index.toString()}
        contentContainerStyle={styles.listContent}
        renderItem={({ item }) => (
          <ThemedView type="backgroundElement" style={styles.card}>
            <Text style={styles.title}>{item.relation}</Text>
            <Row label="Name" value={item.name} />
            <Row label="Qualification" value={item.qualification} />
            <Row label="Occupation" value={item.occupation} />
            <Row label="Organisation" value={item.organization} />
            <Row label="Designation" value={item.designation} />
            <Row label="Office address" value={item.officeAddress} />
            <Row label="Office phone" value={item.officePhone} />
            <Row label="Email" value={item.email} />
            <Row label="Mobile" value={item.mobile} />
            <Row label="PAN" value={item.pan} />
          </ThemedView>
        )}
        ListEmptyComponent={
          <ThemedView style={styles.centered}>
            <ThemedText themeColor="textSecondary" style={styles.text}>No parent/guardian details found.</ThemedText>
          </ThemedView>
        }
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  listContent: { gap: 12, padding: 12 },
  card: { gap: 8, padding: 16, borderRadius: 8 },
  title: { fontSize: 15, fontWeight: '700', color: '#2658A5', textTransform: 'uppercase' },
  row: { gap: 2 },
  label: { fontSize: 12, textTransform: 'uppercase', letterSpacing: 0.5 },
  value: { fontSize: 15 },
  text: { fontSize: 14 },
});
