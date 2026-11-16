import * as SecureStore from 'expo-secure-store';
import { create } from 'zustand';

// Mirrors native SharedPreferences `screen_lock_enabled` (FaceIDEnableViewController /
// FaceIDViewController). `unlockedThisLaunch` isn't persisted — every fresh app launch (and every
// background→foreground transition, per the app-state listener in root _layout.tsx) re-locks.
const STORAGE_KEY = 'mcs_screen_lock_enabled';

type ScreenLockState = {
  enabled: boolean;
  isHydrated: boolean;
  unlockedThisLaunch: boolean;
  hydrate: () => Promise<void>;
  setEnabled: (enabled: boolean) => Promise<void>;
  setUnlocked: (unlocked: boolean) => void;
};

export const useScreenLockStore = create<ScreenLockState>((set) => ({
  enabled: false,
  isHydrated: false,
  unlockedThisLaunch: false,

  hydrate: async () => {
    const raw = await SecureStore.getItemAsync(STORAGE_KEY);
    set({ enabled: raw === 'true', isHydrated: true });
  },

  setEnabled: async (enabled) => {
    await SecureStore.setItemAsync(STORAGE_KEY, enabled ? 'true' : 'false');
    set({ enabled, unlockedThisLaunch: enabled ? false : true });
  },

  setUnlocked: (unlocked) => set({ unlockedThisLaunch: unlocked }),
}));
