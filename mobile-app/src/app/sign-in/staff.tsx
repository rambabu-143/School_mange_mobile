import { SafeAreaView } from 'react-native-safe-area-context';

import { GoogleSignInForm } from '@/components/google-sign-in-form';
import { ThemedView } from '@/components/themed-view';
import { Spacing } from '@/constants/theme';
import { useTheme } from '@/hooks/use-theme';

export default function StaffSignInScreen() {
  const theme = useTheme();
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <ThemedView style={{ flex: 1, justifyContent: 'center', paddingHorizontal: Spacing.four }}>
        <GoogleSignInForm />
      </ThemedView>
    </SafeAreaView>
  );
}
