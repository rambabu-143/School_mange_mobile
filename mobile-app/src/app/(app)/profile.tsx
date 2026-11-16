import { router } from 'expo-router';
import * as React from 'react';
import { ActivityIndicator, Image, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import dayjs from 'dayjs';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { useSessionStore } from '@/lib/session-store';
import { useProfileDetailQuery } from '@/queries/useProfileDetailQuery';

const formatDate = (value?: string | null) => (value ? dayjs(value).format('DD-MM-YYYY') : '—');

// Native ProfileFragment is a hub linking to General/Health/Sibling/Parent/Transport (student) or
// General/Department/Qualification (staff) sub-screens. General is folded into this screen; staff
// Qualification/Department are tabs below the header.
function Row({ label, value }: { label: string; value?: string | null }) {
  if (!value) return null;
  return (
    <View style={styles.row}>
      <ThemedText themeColor="textSecondary" style={styles.label}>{label}</ThemedText>
      <ThemedText style={styles.value}>{value}</ThemedText>
    </View>
  );
}

function NavRow({ label, route }: { label: string; route: string }) {
  return (
    <Pressable style={styles.navRow} onPress={() => router.push(route as never)}>
      <ThemedText style={styles.navLabel}>{label}</ThemedText>
      <ThemedText themeColor="textSecondary" style={styles.navChevron}>›</ThemedText>
    </Pressable>
  );
}

export default function ProfileScreen() {
  const session = useSessionStore((s) => s.session);
  const profileDetailQuery = useProfileDetailQuery();
  const data = profileDetailQuery.data;
  const theme = useTheme();
  const [staffTab, setStaffTab] = React.useState<'general' | 'qualification' | 'department'>('general');

  if (profileDetailQuery.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  const photoUri = data?.profilePic && data?.path ? `${data.path.replace(/\/$/, '')}/${data.profilePic}` : null;
  const address = data?.address;
  const addressLine = address
    ? [address.localAddress, address.city, address.state, address.country, address.pincode].filter(Boolean).join(', ')
    : null;

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <ScrollView contentContainerStyle={styles.content}>
        <View style={styles.header}>
          {photoUri ? (
            <Image source={{ uri: photoUri }} style={styles.avatar} />
          ) : (
            <View style={[styles.avatar, styles.avatarPlaceholder]}>
              <Text style={styles.avatarInitial}>{(data?.name ?? session?.name ?? '?').charAt(0).toUpperCase()}</Text>
            </View>
          )}
          <ThemedText style={styles.name}>{data?.name ?? session?.name ?? 'Unknown'}</ThemedText>
        </View>

        {profileDetailQuery.isError ? (
          <ThemedText themeColor="textSecondary" style={styles.error}>{profileDetailQuery.error.message}</ThemedText>
        ) : (
          <ThemedView type="backgroundElement" style={styles.card}>
            {session?.isStaff && staffTab === 'qualification' ? (
              <Row label="Qualification" value={data?.qualification} />
            ) : session?.isStaff && staffTab === 'department' ? (
              <Row label="Department" value={data?.departmentName} />
            ) : session?.isStaff ? (
              <>
                <Row label="Employee code" value={data?.employeeCode} />
                <Row label="Date of birth" value={formatDate(data?.dateOfBirth)} />
                <Row label="Date of joining" value={formatDate(data?.dateOfJoining)} />
                <Row label="Anniversary" value={formatDate(data?.dateOfAnniversary)} />
                <Row label="Spouse name" value={data?.spouseName} />
                <Row label="Email" value={data?.email} />
                <Row label="Mobile" value={data?.mobile} />
                <Row label="Emergency contact" value={data?.emergencyName} />
                <Row label="Emergency mobile" value={data?.emergencyMobile} />
                <Row label="Address" value={addressLine} />
                {data?.children?.length ? (
                  <View style={styles.row}>
                    <ThemedText themeColor="textSecondary" style={styles.label}>Children at MCS</ThemedText>
                    <View style={{ flex: 1 }}>
                      {data.children.map((child, index) => (
                        <ThemedText key={index} style={styles.value}>
                          {child.standardName} ({child.admissionNo})
                        </ThemedText>
                      ))}
                    </View>
                  </View>
                ) : null}
              </>
            ) : (
              <>
                <Row label="Admission no." value={data?.admissionNo} />
                <Row label="Admission date" value={formatDate(data?.dateOfAdmission)} />
                <Row label="House" value={data?.house} />
                <Row label="Subjects" value={data?.subjects} />
                <Row label="Achievement" value={data?.scholastic} />
                <Row label="Gender" value={data?.gender} />
                <Row label="Date of birth" value={formatDate(data?.dateOfBirth)} />
                <Row label="Nationality" value={data?.nationality} />
                <Row label="Aadhar number" value={data?.aadharCard} />
                <Row label="Email" value={data?.email} />
                <Row label="SMS mobile" value={data?.smsMobile} />
                <Row label="Address" value={addressLine} />
              </>
            )}
          </ThemedView>
        )}

        {session?.isStaff ? (
          <View style={styles.tabGrid}>
            {([['general', 'General'], ['qualification', 'Qualification'], ['department', 'Department']] as const).map(([key, label]) => (
              <Pressable key={key} style={[styles.tab, staffTab === key && styles.tabActive]} onPress={() => setStaffTab(key)}>
                <Text style={[styles.tabLabel, staffTab === key && styles.tabLabelActive]}>{label}</Text>
              </Pressable>
            ))}
            <Pressable style={styles.tab} onPress={() => router.push('/transport' as never)}>
              <Text style={styles.tabLabel}>Transport</Text>
            </Pressable>
          </View>
        ) : null}

        {session?.isStaff ? null : (
          <ThemedView type="backgroundElement" style={styles.card}>
            <NavRow label="Health" route="/health" />
            <NavRow label="Siblings" route="/sibling" />
            <NavRow label="Parent details" route="/parent-details" />
            <NavRow label="Transport" route="/transport" />
          </ThemedView>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  tabGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  tab: { width: '48%', alignItems: 'center', paddingVertical: 12, borderRadius: 8, backgroundColor: '#eeeeef' },
  tabActive: { backgroundColor: '#2658A5' },
  tabLabel: { fontSize: 14, fontWeight: '600', color: '#343434' },
  tabLabelActive: { color: '#ffffff' },
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  content: { padding: 16, gap: 16 },
  header: { alignItems: 'center', gap: 4 },
  avatar: { width: 88, height: 88, borderRadius: 44 },
  avatarPlaceholder: { backgroundColor: '#2658A5', alignItems: 'center', justifyContent: 'center' },
  avatarInitial: { color: '#fff', fontSize: 32, fontWeight: '700' },
  name: { fontSize: 18, fontWeight: '700', marginTop: 8 },
  role: { fontSize: 13 },
  card: { gap: 12, padding: 16, borderRadius: 8 },
  row: { flexDirection: 'row', alignItems: 'flex-start', gap: 8 },
  label: { fontSize: 13, width: 130 },
  value: { fontSize: 15, flex: 1 },
  error: { textAlign: 'center', padding: 16 },
  navRow: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', paddingVertical: 8 },
  navLabel: { fontSize: 15 },
  navChevron: { fontSize: 18 },
});
