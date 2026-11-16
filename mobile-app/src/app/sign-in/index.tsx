import { Link } from 'expo-router';
import { Image, Pressable, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { Spacing } from '@/constants/theme';
import { useTheme } from '@/hooks/use-theme';

/** Native: SelectLoginTypeViewController — logo, "Welcome" / "Login as" (Georgia), then the same
 * three OTP_Staff/OTP_Parent/OTP_Student circular illustrations in this order. */
const ROLES = [
  { href: '/sign-in/staff', label: 'Staff', image: require('@/assets/images/sign-in/role-staff.png') },
  { href: '/sign-in/parent', label: 'Parent', image: require('@/assets/images/sign-in/role-parent.png') },
  { href: '/sign-in/student', label: 'Student', image: require('@/assets/images/sign-in/role-student.png') },
] as const;

export default function SignInRoleSelect() {
  const theme = useTheme();
  return (
    <SafeAreaView style={[styles.safeArea, { backgroundColor: theme.background }]}>
      <ThemedView style={styles.container}>
        <Image source={require('@/assets/images/mcs-logo.png')} style={styles.logo} resizeMode="contain" />

        <ThemedText style={styles.welcome}>Welcome</ThemedText>
        <ThemedText themeColor="textSecondary" style={styles.subtitle}>
          Login as
        </ThemedText>

        <View style={styles.roleList}>
          {ROLES.map((role) => (
            <Link key={role.href} href={role.href} asChild>
              <Pressable style={styles.roleButton}>
                <Image source={role.image} style={styles.roleImage} />
                <ThemedText style={styles.roleLabel}>{role.label}</ThemedText>
              </Pressable>
            </Link>
          ))}
        </View>

      </ThemedView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: { flex: 1 },
  container: {
    flex: 1,
    alignItems: 'center',
    paddingTop: Spacing.six,
    paddingHorizontal: Spacing.four,
  },
  logo: { width: 220, height: 220 },
  welcome: { fontFamily: 'Georgia', fontWeight: 'bold', fontSize: 28, marginTop: Spacing.three },
  subtitle: { fontFamily: 'Georgia', fontSize: 17, marginTop: Spacing.two },
  roleList: {
    flexDirection: 'row',
    justifyContent: 'center',
    gap: Spacing.five,
    marginTop: Spacing.five,
  },
  roleButton: { alignItems: 'center', gap: Spacing.two },
  roleImage: { width: 84, height: 84, borderRadius: 42 },
  roleLabel: { fontFamily: 'Georgia', fontSize: 17 },
});
