import * as LocalAuthentication from 'expo-local-authentication';
import * as React from 'react';
import { ActivityIndicator, StyleSheet, Switch, Text, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import Toast from 'react-native-toast-message';

import { buildSessionFromLogin, switchBranch } from '@/api/auth';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import {
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItemTitle,
  DropdownMenuLabel,
  DropdownMenuRoot,
  DropdownMenuTrigger,
} from '@/design-system/dropdown-menu';
import { useEffectiveColorScheme } from '@/hooks/use-theme';
import { useScreenLockStore } from '@/lib/screen-lock-store';
import { useSessionStore } from '@/lib/session-store';
import { useThemeStore } from '@/lib/theme-store';
import { useProfileDetailQuery } from '@/queries/useProfileDetailQuery';

// ponytail: native SettingFragment's notification toggles (Email/App/SMS) are
// static — the actual on/off switch logic is commented out in
// SettingFragment.kt, so native users only ever see an always-on green dot,
// never an interactive switch. Reproduced as static rows here, matching what
// native actually ships (not what its dead code suggests it could do).
function Row({ label }: { label: string }) {
  return (
    <View style={styles.row}>
      <ThemedText style={styles.rowLabel}>{label}</ThemedText>
      <View style={styles.dot} />
    </View>
  );
}

/** Native: FaceIDEnableViewController — enabling requires a successful biometric check first (so you
 * can't lock yourself out with a device that can't actually authenticate you). Disabling needs no
 * check, matching native. */
function ScreenLockRow() {
  const enabled = useScreenLockStore((s) => s.enabled);
  const setEnabled = useScreenLockStore((s) => s.setEnabled);
  const [busy, setBusy] = React.useState(false);

  const onToggle = async (value: boolean) => {
    if (!value) {
      await setEnabled(false);
      return;
    }
    setBusy(true);
    const hasHardware = await LocalAuthentication.hasHardwareAsync();
    const enrolled = await LocalAuthentication.isEnrolledAsync();
    if (!hasHardware || !enrolled) {
      setBusy(false);
      Toast.show({
        type: 'error',
        text1: 'Biometric authentication unavailable',
        text2: 'Set up Face ID / fingerprint unlock on this device first.',
        position: 'top',
        topOffset: 100,
      });
      return;
    }
    const result = await LocalAuthentication.authenticateAsync({ cancelLabel: 'Cancel' });
    setBusy(false);
    if (result.success) {
      await setEnabled(true);
    }
  };

  return (
    <View style={styles.row}>
      <ThemedText style={styles.rowLabel}>Screen Lock</ThemedText>
      {busy ? <ActivityIndicator size="small" /> : <Switch value={enabled} onValueChange={onToggle} />}
    </View>
  );
}

/** Native: SettingFragment's branch dropdown (userType "4" / SUPER-ADMIN-ish staff with >1 accessible
 * branch). Source list is staffDetail.schools filtered by is_access (BRANCH_DATA_FOR_STAFF), same as
 * useProfileDetailQuery's `branches` field. */
function BranchSwitcher() {
  const session = useSessionStore((s) => s.session);
  const setSession = useSessionStore((s) => s.setSession);
  const profileQuery = useProfileDetailQuery();
  const queryClient = useQueryClient();

  const mutation = useMutation({
    mutationFn: async (branchCode: string) => {
      if (!session?.token) throw new Error('Missing session token');
      const res = await switchBranch(session.token, branchCode);
      return buildSessionFromLogin(res, { isParent: false });
    },
    onSuccess: async (newSession) => {
      await setSession(newSession);
      queryClient.invalidateQueries();
      Toast.show({ type: 'success', text1: 'Branch switched', position: 'top', topOffset: 100 });
    },
    onError: (error) => {
      Toast.show({
        type: 'error',
        text1: 'Could not switch branch',
        text2: error instanceof Error ? error.message : undefined,
        position: 'top',
        topOffset: 100,
      });
    },
  });

  const branches = profileQuery.data?.branches ?? [];
  if (branches.length <= 1) return null;

  const currentLabel = branches.find((b) => b.branchCode === session?.branchCode);

  return (
    <View style={styles.row}>
      <ThemedText style={styles.rowLabel}>Branch</ThemedText>
      <DropdownMenuRoot>
        <DropdownMenuTrigger>
          <TouchableOpacity style={styles.branchTrigger} disabled={mutation.isPending}>
            {mutation.isPending ? (
              <ActivityIndicator size="small" />
            ) : (
              <Text style={[styles.rowLabel, { color: '#2658A5' }]}>
                {currentLabel ? `${currentLabel.schoolCode} (${currentLabel.branchCode})` : 'Select'}
              </Text>
            )}
          </TouchableOpacity>
        </DropdownMenuTrigger>

        <DropdownMenuContent>
          <DropdownMenuGroup>
            <DropdownMenuLabel>Switch Branch</DropdownMenuLabel>
            {branches.map((branch) => (
              <DropdownMenuCheckboxItem
                key={branch.branchCode}
                value={branch.branchCode === session?.branchCode}
                onSelect={() => mutation.mutate(branch.branchCode)}>
                <DropdownMenuItemTitle>
                  {branch.schoolCode} ({branch.branchCode})
                </DropdownMenuItemTitle>
              </DropdownMenuCheckboxItem>
            ))}
          </DropdownMenuGroup>
        </DropdownMenuContent>
      </DropdownMenuRoot>
    </View>
  );
}

export default function SettingsScreen() {
  const session = useSessionStore((s) => s.session);
  const colorScheme = useEffectiveColorScheme();
  const toggleTheme = useThemeStore((s) => s.toggle);

  return (
    <SafeAreaView style={{ flex: 1 }} edges={['left', 'right', 'bottom']}>
      <ThemedView style={styles.container}>
        <View style={styles.content}>
          <View style={styles.row}>
            <ThemedText style={styles.rowLabel}>Dark Mode</ThemedText>
            <Switch value={colorScheme === 'dark'} onValueChange={() => toggleTheme(colorScheme)} />
          </View>

          <Row label="Email Notification" />
          <Row label="App" />
          <Row label="SMS" />

          <ScreenLockRow />

          {session?.isStaff ? <BranchSwitcher /> : null}

          {session?.yearSession ? (
            <ThemedView type="backgroundElement" style={styles.yearBox}>
              <ThemedText style={styles.yearText}>{session.yearSession}</ThemedText>
            </ThemedView>
          ) : null}
        </View>
      </ThemedView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  content: { padding: 16, gap: 4 },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 14,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: '#dddddd',
  },
  rowLabel: { fontSize: 14 },
  dot: { width: 10, height: 10, borderRadius: 5, backgroundColor: '#3ac569' },
  branchTrigger: { paddingVertical: 4, minWidth: 60, alignItems: 'flex-end' },
  yearBox: {
    marginTop: 16,
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 8,
  },
  yearText: { fontSize: 14 },
});
