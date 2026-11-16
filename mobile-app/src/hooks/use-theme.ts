/**
 * Learn more about light and dark modes:
 * https://docs.expo.dev/guides/color-schemes/
 */

import { Colors } from '@/constants/theme';
import { useColorScheme } from '@/hooks/use-color-scheme';
import { useThemeStore } from '@/lib/theme-store';

/** System scheme, unless the user has toggled an override in Settings. */
export function useEffectiveColorScheme(): 'light' | 'dark' {
  const system = useColorScheme();
  const override = useThemeStore((s) => s.mode);

  return override ?? (system === 'dark' ? 'dark' : 'light');
}

export function useTheme() {
  return Colors[useEffectiveColorScheme()];
}
