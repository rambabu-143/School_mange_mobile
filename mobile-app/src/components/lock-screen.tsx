import { BlurView } from 'expo-blur';
import * as LocalAuthentication from 'expo-local-authentication';
import * as React from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { useEffectiveColorScheme, useTheme } from '@/hooks/use-theme';
import { useSessionStore } from '@/lib/session-store';
import { useScreenLockStore } from '@/lib/screen-lock-store';

/** Native: FaceIDViewController — blurred full-screen gate shown on every foreground while
 * screen_lock_enabled. Prompts biometrics immediately on mount, same as native's viewDidAppear. */
export function LockScreen() {
  const session = useSessionStore((s) => s.session);
  const clearSession = useSessionStore((s) => s.clearSession);
  const setUnlocked = useScreenLockStore((s) => s.setUnlocked);
  const theme = useTheme();
  const colorScheme = useEffectiveColorScheme();
  const [authenticating, setAuthenticating] = React.useState(false);
  const [failed, setFailed] = React.useState(false);

  const authenticate = React.useCallback(async () => {
    setAuthenticating(true);
    setFailed(false);
    const result = await LocalAuthentication.authenticateAsync({ cancelLabel: 'Cancel' });
    setAuthenticating(false);
    if (result.success) {
      setUnlocked(true);
    } else {
      setFailed(true);
    }
  }, [setUnlocked]);

  React.useEffect(() => {
    let active = true;
    (async () => {
      const result = await LocalAuthentication.authenticateAsync({ cancelLabel: 'Cancel' });
      if (!active) return;
      if (result.success) {
        setUnlocked(true);
      } else {
        setFailed(true);
      }
    })();
    return () => {
      active = false;
    };
  }, [setUnlocked]);

  return (
    <View style={StyleSheet.absoluteFill}>
      <BlurView intensity={80} tint={colorScheme} style={StyleSheet.absoluteFill} />
      <SafeAreaView style={styles.content}>
        <Text style={[styles.name, { color: theme.text }]}>{session?.name ?? ''}</Text>

        {!authenticating ? (
          <View style={styles.actions}>
            <TouchableOpacity style={[styles.button, { backgroundColor: '#2658A5' }]} onPress={authenticate}>
              <Text style={styles.buttonLabel}>Unlock</Text>
            </TouchableOpacity>
            {failed ? <Text style={styles.failedText}>Authentication failed. Try again or log out.</Text> : null}
            <TouchableOpacity style={styles.logoutButton} onPress={() => clearSession()}>
              <Text style={[styles.logoutLabel, { color: theme.textSecondary }]}>Log out</Text>
            </TouchableOpacity>
          </View>
        ) : null}
      </SafeAreaView>
    </View>
  );
}

const styles = StyleSheet.create({
  content: { flex: 1, alignItems: 'center', justifyContent: 'center', gap: 24, padding: 24 },
  name: { fontSize: 20, fontWeight: '700', textTransform: 'capitalize' },
  actions: { alignItems: 'center', gap: 16 },
  button: { paddingHorizontal: 32, paddingVertical: 14, borderRadius: 8 },
  buttonLabel: { color: '#ffffff', fontWeight: '700', fontSize: 16 },
  failedText: { fontSize: 13, color: '#D32F2F', textAlign: 'center' },
  logoutButton: { padding: 8 },
  logoutLabel: { fontSize: 14, fontWeight: '600' },
});
