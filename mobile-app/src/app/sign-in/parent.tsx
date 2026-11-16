import { useState } from 'react';
import { ActivityIndicator, Pressable, StyleSheet, TextInput } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { buildSessionFromLogin, generateOtp, verifyOtp } from '@/api/auth';
import { useSessionStore } from '@/lib/session-store';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { Spacing } from '@/constants/theme';
import { useTheme } from '@/hooks/use-theme';

export default function ParentSignInScreen() {
  const [mobile, setMobile] = useState('');
  const [otp, setOtp] = useState('');
  const [otpSent, setOtpSent] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const theme = useTheme();
  const setSession = useSessionStore((s) => s.setSession);

  const handleSendOtp = async () => {
    setBusy(true);
    setError(null);
    try {
      await generateOtp(mobile.trim());
      setOtpSent(true);
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Could not send OTP');
    } finally {
      setBusy(false);
    }
  };

  const handleVerifyOtp = async () => {
    setBusy(true);
    setError(null);
    try {
      const res = await verifyOtp(mobile.trim(), otp.trim());
      await setSession(buildSessionFromLogin(res, { isParent: true }));
    } catch (e) {
      setError(e instanceof Error ? e.message : 'OTP verification failed');
    } finally {
      setBusy(false);
    }
  };

  return (
    <SafeAreaView style={[styles.safeArea, { backgroundColor: theme.background }]} edges={['left', 'right', 'bottom']}>
      <ThemedView style={styles.container}>
        <ThemedView style={styles.form}>
          <TextInput
            placeholder="Mobile number"
            keyboardType="phone-pad"
            value={mobile}
            onChangeText={setMobile}
            editable={!otpSent}
            placeholderTextColor={theme.textSecondary}
            style={[styles.input, { color: theme.text, backgroundColor: theme.backgroundElement }]}
          />
          {otpSent && (
            <TextInput
              placeholder="OTP"
              keyboardType="number-pad"
              value={otp}
              onChangeText={setOtp}
              placeholderTextColor={theme.textSecondary}
              style={[styles.input, { color: theme.text, backgroundColor: theme.backgroundElement }]}
            />
          )}
          <Pressable
            style={styles.submitButton}
            onPress={otpSent ? handleVerifyOtp : handleSendOtp}
            disabled={busy}>
            {busy ? (
              <ActivityIndicator color="#ffffff" />
            ) : (
              <ThemedText type="smallBold" style={styles.submitButtonText}>
                {otpSent ? 'Verify OTP' : 'Send OTP'}
              </ThemedText>
            )}
          </Pressable>
        </ThemedView>

        {error && (
          <ThemedText themeColor="textSecondary" style={styles.error}>
            {error}
          </ThemedText>
        )}
      </ThemedView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: { flex: 1 },
  container: {
    flex: 1,
    justifyContent: 'center',
    paddingHorizontal: Spacing.four,
    gap: Spacing.four,
  },
  form: { gap: Spacing.three },
  input: {
    borderWidth: 1,
    borderColor: '#8884',
    borderRadius: Spacing.two,
    paddingHorizontal: Spacing.three,
    paddingVertical: Spacing.two,
    fontSize: 16,
  },
  submitButton: {
    alignItems: 'center',
    paddingVertical: Spacing.three,
    borderRadius: Spacing.two,
    backgroundColor: '#3c87f7',
  },
  submitButtonText: { color: '#ffffff' },
  error: { textAlign: 'center' },
});
