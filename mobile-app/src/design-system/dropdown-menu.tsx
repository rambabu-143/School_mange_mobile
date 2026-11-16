import React, { createContext, useContext, useState } from 'react';
import { Modal, Pressable, StyleSheet, Text, View } from 'react-native';

import { Spacing } from '@/constants/theme';
import { useTheme } from '@/hooks/use-theme';

/**
 * ponytail: plain RN Modal-based picker, replacing zeego/react-native-ios-context-menu — that
 * library doesn't build against RN 0.86's New Architecture (missing RCTRootContentView symbol).
 * Centered list instead of an anchored native popover; same Root/Trigger/Content/Item API so the
 * 7 call sites under src/components/attendance/ didn't need to change.
 */

type MenuContext = { open: boolean; setOpen: (open: boolean) => void };
const DropdownMenuContext = createContext<MenuContext | null>(null);

function useMenu() {
  const ctx = useContext(DropdownMenuContext);
  if (!ctx) throw new Error('DropdownMenu parts must be used within a DropdownMenuRoot');
  return ctx;
}

export function DropdownMenuRoot({ children }: { children: React.ReactNode }) {
  const [open, setOpen] = useState(false);
  return <DropdownMenuContext.Provider value={{ open, setOpen }}>{children}</DropdownMenuContext.Provider>;
}

export function DropdownMenuTrigger({
  children,
  about,
}: {
  children: React.ReactElement<{ onPress?: () => void; accessibilityLabel?: string }>;
  /** Accessibility label for the trigger. */
  about?: string;
}) {
  const { setOpen } = useMenu();
  return React.cloneElement(children, { onPress: () => setOpen(true), accessibilityLabel: about });
}

export function DropdownMenuContent({ children }: { children: React.ReactNode }) {
  const { open, setOpen } = useMenu();
  const theme = useTheme();
  return (
    <Modal visible={open} transparent animationType="fade" onRequestClose={() => setOpen(false)}>
      <Pressable style={styles.backdrop} onPress={() => setOpen(false)}>
        <Pressable
          style={[styles.card, { backgroundColor: theme.backgroundElement }]}
          onPress={(e) => e.stopPropagation()}>
          {children}
        </Pressable>
      </Pressable>
    </Modal>
  );
}

export function DropdownMenuGroup({ children }: { children: React.ReactNode }) {
  return <View>{children}</View>;
}

export function DropdownMenuLabel({ children }: { children: React.ReactNode }) {
  const theme = useTheme();
  return <Text style={[styles.label, { color: theme.textSecondary }]}>{children}</Text>;
}

export function DropdownMenuSeparator() {
  const theme = useTheme();
  return <View style={[styles.separator, { backgroundColor: theme.backgroundSelected }]} />;
}

export function DropdownMenuCheckboxItem({
  value,
  onSelect,
  disabled,
  children,
}: {
  value: boolean;
  onSelect?: () => void;
  disabled?: boolean;
  children: React.ReactNode;
}) {
  const { setOpen } = useMenu();
  const theme = useTheme();
  return (
    <Pressable
      style={[styles.item, disabled && styles.itemDisabled]}
      disabled={disabled}
      onPress={() => {
        onSelect?.();
        setOpen(false);
      }}>
      <View style={styles.itemText}>{children}</View>
      {value && <Text style={[styles.check, { color: theme.text }]}>✓</Text>}
    </Pressable>
  );
}

export function DropdownMenuItemTitle({ children }: { children: React.ReactNode }) {
  const theme = useTheme();
  return <Text style={[styles.itemTitle, { color: theme.text }]}>{children}</Text>;
}

export function DropdownMenuItemSubtitle({ children }: { children: React.ReactNode }) {
  const theme = useTheme();
  return <Text style={[styles.itemSubtitle, { color: theme.textSecondary }]}>{children}</Text>;
}

const styles = StyleSheet.create({
  backdrop: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.35)',
    alignItems: 'center',
    justifyContent: 'center',
    padding: Spacing.four,
  },
  card: {
    width: '100%',
    maxWidth: 340,
    maxHeight: '70%',
    borderRadius: Spacing.two,
    paddingVertical: Spacing.two,
    overflow: 'hidden',
  },
  label: {
    fontSize: 12,
    fontWeight: '600',
    textTransform: 'uppercase',
    letterSpacing: 0.4,
    paddingHorizontal: Spacing.three,
    paddingVertical: Spacing.two,
  },
  separator: {
    height: StyleSheet.hairlineWidth,
    marginVertical: Spacing.one,
  },
  item: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: Spacing.two,
    paddingHorizontal: Spacing.three,
    paddingVertical: Spacing.three,
  },
  itemDisabled: { opacity: 0.4 },
  itemText: { flex: 1 },
  itemTitle: { fontSize: 16 },
  itemSubtitle: { fontSize: 13, marginTop: 2 },
  check: { fontSize: 16, fontWeight: '700' },
});
