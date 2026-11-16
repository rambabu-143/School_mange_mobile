import * as React from 'react';
import { ActivityIndicator, Image, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { Card } from '@/design-system/card';
import { useTheme } from '@/hooks/use-theme';
import { useSessionStore } from '@/lib/session-store';
import { Installment, useFeeBillQuery } from '@/queries/useFeeBillQuery';
import { indianNumberFormatter } from '@/utils/indianNumberFormatter';

// ponytail: Card (@/design-system/card) has its own hardcoded white background/shadow —
// it's a shared design-system component outside this pass's scope, so cards on this screen
// stay light-surfaced even in dark mode until Card itself is themed.

import * as WebBrowser from 'expo-web-browser';
import Toast from 'react-native-toast-message';
import { useQueryClient } from '@tanstack/react-query';

const CHECKBOX_ICONS = {
  active: require('@/assets/images/paybill/ic_checkbox_active.png'),
  inactive: require('@/assets/images/paybill/ic_checkbox_inactive.png'),
  indeterminate: require('@/assets/images/paybill/ic_checkbox_indeterminate.png'),
};

function InstallmentRow({
  data,
  selected,
  onPress,
}: {
  data: Installment;
  selected: boolean;
  onPress: () => void;
}) {
  const disabled = data.installment_type === 'CURRENT' || data.installment_type === 'PAST';
  const isSelected = data.installment_type === 'CURRENT' || selected;
  const icon =
    data.installment_type === 'PAST'
      ? CHECKBOX_ICONS.indeterminate
      : isSelected
        ? CHECKBOX_ICONS.active
        : CHECKBOX_ICONS.inactive;

  return (
    <Card touchable disabled={disabled} activeOpacity={0.55} onPress={onPress} style={styles.row}>
      <View style={styles.rowHeader}>
        <Image source={icon} style={styles.checkbox} />
        <Text style={styles.installmentLabel}>{data.inst_no}</Text>
      </View>
      <View style={styles.rowAmounts}>
        <View style={styles.amountLabels}>
          <Text style={styles.amountText}>Amount</Text>
          {data.fine_installment ? <Text style={styles.amountText}>Fine</Text> : null}
          {data.recived ? <Text style={styles.amountText}>Received</Text> : null}
          <Text style={styles.amountText}>Due</Text>
        </View>
        <View style={styles.amountValues}>
          <Text style={styles.amountText}>{indianNumberFormatter(data.amount ?? 0)}</Text>
          {data.fine_installment ? (
            <Text style={[styles.amountText, styles.fine]}>{indianNumberFormatter(data.fine_installment)}</Text>
          ) : null}
          {data.recived ? (
            <Text style={[styles.amountText, styles.received]}>{indianNumberFormatter(data.recived)}</Text>
          ) : null}
          <Text style={[styles.amountText, data.amount_payble ? styles.due : null]}>
            {indianNumberFormatter(data.amount_payble ?? 0)}
          </Text>
        </View>
      </View>
    </Card>
  );
}

export default function PayBillScreen() {
  const session = useSessionStore((s) => s.session);
  const [selected, setSelected] = React.useState<Record<string, boolean>>({});
  const [paying, setPaying] = React.useState(false);
  const feeBillQuery = useFeeBillQuery();
  const queryClient = useQueryClient();
  const installments = feeBillQuery.data ?? [];
  const theme = useTheme();

  // Native reference (Installments.tsx): selecting installment N cascades to auto-select every
  // unselected FUTURE installment before it; deselecting N cascades to deselect every selected
  // FUTURE installment after it. You can't pay a later quarter while skipping an earlier one.
  const toggle = (installment: Installment) => {
    if (installment.installment_type !== 'FUTURE' || !installment.inst_no) return;
    const futureInstallments = installments.filter((i) => i.installment_type === 'FUTURE');
    const idx = futureInstallments.findIndex((i) => i.inst_no === installment.inst_no);
    const isSelected = !!selected[installment.inst_no];

    setSelected((prev) => {
      const next = { ...prev };
      const affected = isSelected ? futureInstallments.slice(idx) : futureInstallments.slice(0, idx + 1);
      affected.forEach((i) => {
        if (i.inst_no) next[i.inst_no] = !isSelected;
      });
      return next;
    });
  };

  const total = installments.reduce((sum, inst) => {
    const included = inst.installment_type === 'CURRENT' || (inst.inst_no && selected[inst.inst_no]);
    return included ? sum + (inst.amount_payble ?? 0) : sum;
  }, 0);

  const handlePayNow = async () => {
    if (total <= 0) {
      Toast.show({
        type: 'info',
        text1: 'No pending amount',
        text2: 'Selected installments have zero payable due.',
        position: 'top',
        topOffset: 100,
      });
      return;
    }

    if (!session?.userId) {
      Toast.show({
        type: 'error',
        text1: 'Session Error',
        text2: 'User session not found. Please log in again.',
        position: 'top',
        topOffset: 100,
      });
      return;
    }

    const paymentUrl = `https://mountcarmelschool.com/parent/payment/fee-bill-app/${session.userId}`;

    try {
      setPaying(true);
      await WebBrowser.openAuthSessionAsync(paymentUrl);
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : 'Unable to open checkout session';
      Toast.show({
        type: 'error',
        text1: 'Payment Portal Error',
        text2: msg,
        position: 'top',
        topOffset: 100,
      });
    } finally {
      setPaying(false);
      // Invalidate and refetch bill data to refresh paid status upon returning
      await queryClient.invalidateQueries({ queryKey: ['fee-bill'] });
      await feeBillQuery.refetch();
    }
  };

  if (feeBillQuery.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  if (installments.length === 0) {
    return (
      <ThemedView style={styles.centered}>
        <ThemedText themeColor="textSecondary">No fee bill found.</ThemedText>
      </ThemedView>
    );
  }

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['left', 'right', 'bottom']}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <Card style={styles.profileCard}>
          <Text style={styles.name}>{session?.name ?? 'Student'}</Text>
          <Text style={styles.label}>Admission No.: {session?.admissionNo ?? '—'}</Text>
        </Card>

        <ThemedText style={styles.sectionTitle}>Quarterly Installments</ThemedText>
        {installments.map((inst) => (
          <InstallmentRow
            key={inst.inst_no}
            data={inst}
            selected={!!(inst.inst_no && selected[inst.inst_no])}
            onPress={() => toggle(inst)}
          />
        ))}
      </ScrollView>

      <View style={[styles.footer, { borderTopColor: theme.backgroundElement }]}>
        <View>
          <ThemedText themeColor="textSecondary" style={styles.footerLabel}>Total Payable</ThemedText>
          <ThemedText style={styles.footerAmount}>{indianNumberFormatter(total)}</ThemedText>
        </View>
        <Pressable
          style={[styles.payButton, (total <= 0 || paying) && styles.payButtonDisabled]}
          disabled={total <= 0 || paying}
          onPress={handlePayNow}
        >
          {paying ? (
            <ActivityIndicator size="small" color="#ffffff" />
          ) : (
            <Text style={styles.payButtonLabel}>Pay Now</Text>
          )}
        </Pressable>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  scrollContent: { gap: 12, padding: 16, paddingBottom: 32 },
  profileCard: { gap: 4 },
  name: { fontSize: 16, fontWeight: '600', textTransform: 'capitalize' },
  label: { color: '#545454' },
  sectionTitle: { fontSize: 14, marginLeft: 4 },
  row: { gap: 12 },
  rowHeader: { flexDirection: 'row', gap: 12, alignItems: 'center' },
  checkbox: { width: 24, height: 24, resizeMode: 'contain' },
  installmentLabel: { fontSize: 16, fontWeight: '600', textTransform: 'capitalize', flex: 1 },
  rowAmounts: { flexDirection: 'row', gap: 12, justifyContent: 'flex-end' },
  amountLabels: { alignItems: 'flex-end', gap: 2 },
  amountValues: { alignItems: 'flex-end', gap: 2 },
  amountText: { fontSize: 15 },
  fine: { color: '#D32F2F' },
  received: { color: '#308234' },
  due: { color: '#FF3B30', fontWeight: '600' },
  footer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 16,
    borderTopWidth: StyleSheet.hairlineWidth,
  },
  footerLabel: { fontSize: 13 },
  footerAmount: { fontSize: 20, fontWeight: '700' },
  payButton: {
    paddingHorizontal: 24,
    paddingVertical: 14,
    borderRadius: 8,
    backgroundColor: '#3c87f7',
    minWidth: 110,
    alignItems: 'center',
    justifyContent: 'center',
  },
  payButtonDisabled: {
    opacity: 0.5,
    backgroundColor: '#94a3b8',
  },
  payButtonLabel: { color: '#ffffff', fontWeight: '700' },
});
