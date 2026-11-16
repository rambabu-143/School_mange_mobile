import { router } from 'expo-router';
import * as React from 'react';
import { ActivityIndicator, FlatList, Image, Pressable, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useSessionStore } from '@/lib/session-store';
import { useMyTeacherQuery } from '@/queries/useMyTeacherQuery';

const ROMAN_STANDARDS = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI', 'XII'];
const ROLE_TITLES = new Set(['Class Teacher', 'Helper Teacher', 'House Teacher']);

// Native: MyTeacherFragment's showSurveyCTA = isStudent && standardNum >= 9 — only students (not
// parents/staff) in standard IX+ see the WISE "Take Survey" entry point, and only on subject-teacher
// cards (not Class/Helper/House Teacher rows).
function canGiveFeedback(isStaff: boolean, isParent: boolean, standardName: string | null | undefined, title: string) {
  if (isStaff || isParent) return false;
  if (ROLE_TITLES.has(title)) return false;
  const standardNum = ROMAN_STANDARDS.indexOf((standardName ?? '').toUpperCase()) + 1;
  return standardNum >= 9;
}

export default function MyTeacherScreen() {
  const session = useSessionStore((s) => s.session);
  const myTeacherQuery = useMyTeacherQuery();
  const theme = useTheme();

  if (myTeacherQuery.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <FlatList
        data={myTeacherQuery.data ?? []}
        keyExtractor={(item, index) => `${item.id ?? ''}-${index}`}
        contentContainerStyle={styles.listContent}
        renderItem={({ item }) => (
          <Pressable
            style={[styles.card, { backgroundColor: theme.backgroundElement }]}
            disabled={!item.id || !canGiveFeedback(!!session?.isStaff, !!session?.isParent, session?.standardName, item.title)}
            onPress={() =>
              router.push({
                pathname: '/wise',
                params: { staffId: item.id ?? '', teacherName: item.name ?? '', subjectLabel: item.title },
              })
            }>
            {item.profilePic ? (
              <Image source={{ uri: item.profilePic }} style={styles.avatar} />
            ) : (
              <View style={[styles.avatar, styles.avatarPlaceholder]}>
                <Text style={styles.avatarInitial}>{(item.name ?? '?').charAt(0).toUpperCase()}</Text>
              </View>
            )}
            <View>
              <ThemedText themeColor="textSecondary" style={styles.title}>{item.title}</ThemedText>
              <ThemedText style={styles.name}>{item.name}</ThemedText>
            </View>
          </Pressable>
        )}
        ListEmptyComponent={
          <ThemedView style={styles.centered}>
            <ThemedText themeColor="textSecondary" style={styles.text}>
              {myTeacherQuery.isError ? myTeacherQuery.error.message : 'No teachers found.'}
            </ThemedText>
          </ThemedView>
        }
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  listContent: { gap: 12, padding: 12 },
  card: { flexDirection: 'row', alignItems: 'center', gap: 12, padding: 12, borderRadius: 8 },
  avatar: { width: 48, height: 48, borderRadius: 24 },
  avatarPlaceholder: { backgroundColor: '#2658A5', alignItems: 'center', justifyContent: 'center' },
  avatarInitial: { color: '#fff', fontSize: 18, fontWeight: '700' },
  title: { fontSize: 12, textTransform: 'uppercase' },
  name: { fontSize: 15, fontWeight: '600' },
  text: { fontSize: 14 },
});
