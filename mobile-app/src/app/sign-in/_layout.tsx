import { Stack } from 'expo-router';

export default function SignInLayout() {
  return (
    <Stack>
      <Stack.Screen name="index" options={{ headerShown: false, title: '' }} />
      <Stack.Screen name="student" options={{ title: '🎓 Student sign in' }} />
      <Stack.Screen name="staff" options={{ title: '🍎 Staff sign in' }} />
      <Stack.Screen name="parent" options={{ title: '👪 Parent sign in' }} />
    </Stack>
  );
}
