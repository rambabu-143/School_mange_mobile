import { useState } from 'react';
import { ActivityIndicator, Image, Pressable, StyleSheet } from 'react-native';

import { buildSessionFromLogin, googleLogin } from '@/api/auth';
import { pickGoogleAccount } from '@/lib/google-signin';
import { useSessionStore } from '@/lib/session-store';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { Spacing } from '@/constants/theme';

/** Shared by the Student and Staff sign-in screens — Google only, like native (Android hides the
 * email/password fields). The account's `is_staff` flag, not which screen you used, decides the role. */
export function GoogleSignInForm() {
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const setSession = useSessionStore((s) => s.setSession);

  const handleGoogle = async () => {
    setBusy(true);
    setError(null);
    try {
      const account = await pickGoogleAccount();
      if (!account) return;
      const res = await googleLogin(account.email, account.idToken);
      await setSession(buildSessionFromLogin(res, { isParent: false }));
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Google sign-in failed');
    } finally {
      setBusy(false);
    }
  };

  return (
    <ThemedView style={styles.form}>
      <Pressable style={styles.googleButton} onPress={handleGoogle} disabled={busy}>
        {busy ? (
          <ActivityIndicator />
        ) : (
          <>
            <Image source={require('@/assets/images/sign-in/google-g.png')} style={styles.googleLogo} />
            <ThemedText type="smallBold">Sign in with Google</ThemedText>
          </>
        )}
      </Pressable>
      {error && (
        <ThemedText themeColor="textSecondary" style={styles.error}>
          {error}
        </ThemedText>
      )}
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  form: { gap: Spacing.three },
  googleButton: {
    flexDirection: 'row',
    justifyContent: 'center',
    gap: Spacing.two,
    alignItems: 'center',
    paddingVertical: Spacing.three,
    borderRadius: Spacing.two,
    borderWidth: 1,
    borderColor: '#8884',
  },
  googleLogo: { width: 20, height: 20 },
  error: { textAlign: 'center' },
});
