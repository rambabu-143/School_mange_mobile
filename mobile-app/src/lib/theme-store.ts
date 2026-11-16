import * as SecureStore from 'expo-secure-store';
import { create } from 'zustand';

export type ColorSchemeName = 'light' | 'dark';

const STORAGE_KEY = 'mcs_theme_mode';

type ThemeState = {
  /** null = follow system scheme; set once the user toggles. */
  mode: ColorSchemeName | null;
  hydrate: () => Promise<void>;
  toggle: (current: ColorSchemeName) => Promise<void>;
};

export const useThemeStore = create<ThemeState>((set) => ({
  mode: null,

  hydrate: async () => {
    const raw = await SecureStore.getItemAsync(STORAGE_KEY);
    set({ mode: raw === 'light' || raw === 'dark' ? raw : null });
  },

  toggle: async (current) => {
    const next: ColorSchemeName = current === 'dark' ? 'light' : 'dark';
    await SecureStore.setItemAsync(STORAGE_KEY, next);
    set({ mode: next });
  },
}));
