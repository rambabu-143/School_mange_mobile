import * as React from 'react';
import { Dimensions, Pressable, StyleSheet } from 'react-native';
import Animated, { runOnJS, useAnimatedStyle, withSpring, withTiming } from 'react-native-reanimated';

import { ThemedView } from '@/components/themed-view';

const DRAWER_WIDTH = Math.min(320, Dimensions.get('window').width * 0.82);
const DRAWER_SPRING = { damping: 22, stiffness: 260, mass: 0.9 };

// ponytail: hand-rolled with Reanimated (already installed) instead of
// pulling in @react-navigation/drawer — this app only needs one slide-in
// panel opened from Home, not a full drawer navigator with per-screen state.
export function AppDrawer({
  visible,
  onClose,
  children,
}: {
  visible: boolean;
  onClose: () => void;
  children: React.ReactNode;
}) {
  const [mounted, setMounted] = React.useState(visible);

  React.useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect -- sync server data into editable local state
    if (visible) setMounted(true);
  }, [visible]);

  const panelStyle = useAnimatedStyle(() => ({
    transform: [
      {
        translateX: withSpring(visible ? 0 : -DRAWER_WIDTH, DRAWER_SPRING, (finished) => {
          if (finished && !visible) runOnJS(setMounted)(false);
        }),
      },
    ],
  }));

  const backdropStyle = useAnimatedStyle(() => ({
    opacity: withTiming(visible ? 1 : 0, { duration: 200 }),
  }));

  if (!mounted) return null;

  return (
    <Animated.View
      style={[StyleSheet.absoluteFill, backdropStyle, styles.backdrop]}
      pointerEvents={visible ? 'auto' : 'none'}>
      <Pressable style={StyleSheet.absoluteFill} onPress={onClose} />
      <Animated.View style={[styles.panel, panelStyle]}>
        <ThemedView type="background" style={styles.panelInner}>
          {children}
        </ThemedView>
      </Animated.View>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  backdrop: { backgroundColor: 'rgba(0,0,0,0.4)', zIndex: 50 },
  panel: { position: 'absolute', top: 0, bottom: 0, left: 0, width: DRAWER_WIDTH },
  panelInner: { flex: 1 },
});
