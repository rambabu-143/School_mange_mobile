import * as React from 'react';
import { StyleSheet, Text, TextStyle, View, ViewStyle } from 'react-native';

import type { LeaveAssessor as LeaveAssessorType } from '@/queries/useStaffLeaveRequestsQuery';

export type LeaveAssessorProps = {
  data: LeaveAssessorType;
  label?: React.ReactNode;
};

const _LeaveAssessor: React.FC<LeaveAssessorProps> = ({ data, label }) => {
  const statusStyle = getStatusStyles(data.status);

  return (
    <View
      style={{
        flexDirection: 'row',
        gap: 8,
        marginLeft: label ? 0 : -1,
        paddingVertical: 8,
        alignItems: 'center',
        justifyContent: 'flex-start',
      }}
    >
      {label ? (
        <Text style={styles.label}>{label}</Text>
      ) : (
        <View style={{ width: 8, height: 1.5, backgroundColor: '#bababa' }} />
      )}

      <Text style={[styles.text, { flexShrink: 1 }]} numberOfLines={2} ellipsizeMode="middle">
        <Text style={{ textTransform: 'capitalize' }}>{data?.assessor_id?.name?.replace(/ {2,}/, ' ')}</Text>{' '}
        ({data?.role_id?.short_name})
      </Text>

      <View style={[{ paddingVertical: 2, paddingHorizontal: 6, borderRadius: 4 }, { backgroundColor: statusStyle?.backgroundColor }]}>
        <Text style={[styles.smallText, { fontWeight: '500', color: statusStyle?.color, textTransform: 'capitalize' }]}>
          {data.status}
        </Text>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  smallText: { fontSize: 14, lineHeight: 14 * 1.5, fontWeight: '400', color: '#323232' },
  label: { fontSize: 15, lineHeight: 15 * 1.5, fontWeight: '500', color: '#767676' },
  text: { fontSize: 16, lineHeight: 16 * 1.5, fontWeight: '400', color: '#323232' },
});

export const LeaveAssessor = React.memo(_LeaveAssessor);

function getStatusStyles(status: string | null | undefined): (ViewStyle & TextStyle) | null {
  status = status?.toLowerCase?.();
  if (status === 'pending') return { backgroundColor: '#FFF4E5', color: '#FFA500' };
  if (status === 'approved') return { backgroundColor: '#E6F4EA', color: '#34A853' };
  if (status === 'rejected') return { backgroundColor: '#FDECEA', color: '#D93025' };
  if (status === 'cancelled') return { backgroundColor: '#F0F4F8', color: '#5F6368' };
  return null;
}
