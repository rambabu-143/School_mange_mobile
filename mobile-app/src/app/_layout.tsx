import { QueryCache, QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { DarkTheme, DefaultTheme, Stack, ThemeProvider } from 'expo-router';
import { useEffect } from 'react';
import { AppState } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import Toast from 'react-native-toast-message';

import { AnimatedSplashOverlay } from '@/components/animated-icon';
import { LockScreen } from '@/components/lock-screen';
import { useEffectiveColorScheme } from '@/hooks/use-theme';
import { useScreenLockStore } from '@/lib/screen-lock-store';
import { useSessionStore } from '@/lib/session-store';
import { useThemeStore } from '@/lib/theme-store';

import * as SplashScreen from 'expo-splash-screen';

SplashScreen.preventAutoHideAsync();

const queryClient = new QueryClient({
  queryCache: new QueryCache({
    onError: (error, query) => {
      const friendlyErrorMessage = (query.meta?.friendlyErrorMessage as string) || 'Something went wrong!';
      Toast.show({
        type: 'error',
        text1: friendlyErrorMessage || error.message,
        text2: friendlyErrorMessage ? error.message : undefined,
        position: 'bottom',
        bottomOffset: 100,
      });
    },
  }),
});

export default function RootLayout() {
  const colorScheme = useEffectiveColorScheme();
  const { session, isHydrated, hydrate } = useSessionStore();
  const hydrateTheme = useThemeStore((s) => s.hydrate);
  const { enabled: lockEnabled, unlockedThisLaunch, hydrate: hydrateLock, setUnlocked } = useScreenLockStore();

  useEffect(() => {
    hydrate();
    hydrateTheme();
    hydrateLock();
  }, [hydrate, hydrateTheme, hydrateLock]);

  // Native: FaceIDViewController re-prompts on every foreground, not just cold launch.
  useEffect(() => {
    const subscription = AppState.addEventListener('change', (state) => {
      if (state === 'background') setUnlocked(false);
    });
    return () => subscription.remove();
  }, [setUnlocked]);

  if (!isHydrated) {
    // AnimatedSplashOverlay below covers this frame; nothing else to render yet.
    return (
      <SafeAreaProvider>
        <ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
          <AnimatedSplashOverlay />
        </ThemeProvider>
      </SafeAreaProvider>
    );
  }

  return (
    <SafeAreaProvider>
      <QueryClientProvider client={queryClient}>
        <ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
          <AnimatedSplashOverlay />
          <Stack screenOptions={{ headerShown: false }}>
            <Stack.Protected guard={!!session}>
              <Stack.Screen name="(app)" />
            </Stack.Protected>
            <Stack.Protected guard={!session}>
              <Stack.Screen name="sign-in" />
            </Stack.Protected>
          </Stack>
          {session && lockEnabled && !unlockedThisLaunch ? <LockScreen /> : null}
          <Toast />
        </ThemeProvider>
      </QueryClientProvider>
    </SafeAreaProvider>
  );
}
