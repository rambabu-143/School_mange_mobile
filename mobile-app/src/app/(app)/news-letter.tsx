import * as React from 'react';
import { ActivityIndicator, Linking, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useDashboardDetailQuery } from '@/queries/useDashboardDetailQuery';

/** Native: DashboardActivity's `news_letter` drawer item -> AssessmentFragment(from="NewsLetter"), a single PDF. */
export default function NewsLetterScreen() {
  const query = useDashboardDetailQuery();
  const theme = useTheme();

  if (query.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  if (!query.data?.newsletterUrl) {
    return (
      <ThemedView style={styles.centered}>
        <ThemedText themeColor="textSecondary" style={styles.text}>NewsLetter data not found</ThemedText>
      </ThemedView>
    );
  }

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <View style={styles.centered}>
        <TouchableOpacity style={styles.button} onPress={() => Linking.openURL(query.data!.newsletterUrl!)}>
          <Text style={styles.buttonLabel}>View NewsLetter</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  text: { fontSize: 14 },
  button: { paddingHorizontal: 24, paddingVertical: 14, borderRadius: 8, backgroundColor: '#2658A5' },
  buttonLabel: { color: '#ffffff', fontWeight: '700', fontSize: 15 },
});
