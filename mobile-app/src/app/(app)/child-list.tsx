import { router } from 'expo-router';
import * as React from 'react';
import { ActivityIndicator, FlatList, Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useSessionStore } from '@/lib/session-store';
import { useSwitchChildMutation } from '@/queries/useSwitchChildMutation';

export default function ChildListScreen() {
  const theme = useTheme();
  const session = useSessionStore((s) => s.session);
  const switchChildMutation = useSwitchChildMutation();
  const [pendingAdmissionNo, setPendingAdmissionNo] = React.useState<string | null>(null);

  const handleSelect = async (child: { admissionNo: string; email?: string | null }) => {
    if (child.admissionNo === session?.admissionNo) return;
    setPendingAdmissionNo(child.admissionNo);
    try {
      await switchChildMutation.mutateAsync(child);
      router.replace('/');
    } finally {
      setPendingAdmissionNo(null);
    }
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <FlatList
        data={session?.children ?? []}
        keyExtractor={(item) => item.admissionNo}
        contentContainerStyle={styles.listContent}
        style={{ backgroundColor: theme.background }}
        renderItem={({ item }) => {
          const isCurrent = item.admissionNo === session?.admissionNo;
          const isPending = pendingAdmissionNo === item.admissionNo;
          return (
            <TouchableOpacity
              style={[
                styles.card,
                { backgroundColor: isCurrent ? theme.backgroundSelected : theme.backgroundElement },
              ]}
              disabled={isCurrent || switchChildMutation.isPending}
              onPress={() => handleSelect(item)}
            >
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
                  {item.standardName} · {item.admissionNo}
                </ThemedText>
              </View>
              {isPending ? <ActivityIndicator /> : isCurrent ? <Text style={styles.currentBadge}>Current</Text> : null}
            </TouchableOpacity>
          );
        }}
        ListEmptyComponent={
          <ThemedView style={styles.centered}>
            <ThemedText themeColor="textSecondary" style={styles.text}>No children found on this account.</ThemedText>
          </ThemedView>
        }
      />
      {switchChildMutation.isError && (
        <Text style={styles.error}>{switchChildMutation.error.message}</Text>
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  listContent: { gap: 12, padding: 12 },
  card: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    padding: 12,
    borderRadius: 8,
  },
  avatar: { width: 48, height: 48, borderRadius: 24 },
  avatarPlaceholder: { backgroundColor: '#2658A5', alignItems: 'center', justifyContent: 'center' },
  avatarInitial: { color: '#fff', fontSize: 18, fontWeight: '700' },
  name: { fontSize: 15, fontWeight: '600' },
  meta: { fontSize: 13 },
  currentBadge: { fontSize: 12, fontWeight: '600', color: '#2658A5' },
  text: { fontSize: 14 },
  error: { textAlign: 'center', color: '#c0392b', padding: 12 },
});
