import * as React from 'react';
import { ActivityIndicator, ScrollView, StyleSheet, View } from 'react-native';
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

/** Native: HealthFragment — view of studentDetail.data.medical. Student/parent only. */
export default function HealthScreen() {
  const profileDetailQuery = useProfileDetailQuery();
  const medical = profileDetailQuery.data?.medical;
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
      <ScrollView contentContainerStyle={styles.content}>
        {!medical ? (
          <ThemedView style={styles.centered}>
            <ThemedText themeColor="textSecondary" style={styles.text}>No health details found.</ThemedText>
          </ThemedView>
        ) : (
          <ThemedView type="backgroundElement" style={styles.card}>
            <Row label="Blood group" value={medical.bloodGroup} />
            <Row label="Allergies" value={medical.allergies} />
            <Row label="Height (cm)" value={medical.height} />
            <Row label="Weight (kg)" value={medical.weight} />
            <Row label="Vision left" value={medical.visionLeft} />
            <Row label="Vision right" value={medical.visionRight} />
            <Row label="BMI" value={medical.bmi} />
            <Row label="Hearing (dB)" value={medical.hearing} />
            {/* Native: hygiene and gums fields are hardcoded visibility="gone" in fragment_health.xml — real users never see them. */}
            <Row label="Teeth" value={medical.teeth} />
            <Row label="Lips" value={medical.lips} />
            <Row label="Plaque" value={medical.plaque} />
            <Row label="Breath" value={medical.breath} />
            <Row label="Dental concerns" value={medical.dentalConcerns} />
            <Row label="General observation" value={medical.generalObservation} />
            <Row label="Other observation" value={medical.otherObservation} />
            <Row label="Specific ailment" value={medical.specificAilment} />
          </ThemedView>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  content: { padding: 16 },
  card: { gap: 12, padding: 16, borderRadius: 8 },
  row: { gap: 2 },
  label: { fontSize: 12, textTransform: 'uppercase', letterSpacing: 0.5 },
  value: { fontSize: 15 },
  text: { fontSize: 14 },
});
