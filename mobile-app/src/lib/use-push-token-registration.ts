import * as Notifications from 'expo-notifications';
import * as React from 'react';
import { Platform } from 'react-native';

import { updateDeviceToken } from '@/api/push';
import { useSessionStore } from '@/lib/session-store';

/**
 * Native: DashboardActivity fetches the FCM/APNs token on every dashboard load and PUTs it,
 * fire-and-forget (no error surfaced to the user). Mirrored here rather than on login, since
 * that's also where native re-registers on every app open in case the token rotated.
 */
export function usePushTokenRegistration() {
  const session = useSessionStore((s) => s.session);
  const { token, userId, isStaff } = session ?? {};

  React.useEffect(() => {
    if (!token || !userId) return;

    (async () => {
      if (Platform.OS === 'android') {
        await Notifications.setNotificationChannelAsync('default', {
          name: 'Default',
          importance: Notifications.AndroidImportance.MAX,
        });
      }

      const { status } = await Notifications.requestPermissionsAsync();
      if (status !== 'granted') return;

      const { data: deviceToken } = await Notifications.getDevicePushTokenAsync();
      await updateDeviceToken(token, userId, !!isStaff, deviceToken);
    })().catch(() => {});
  }, [token, userId, isStaff]);
}
