import * as React from 'react';
import { StyleSheet, Text } from 'react-native';

import type { StaffLeaveRequest } from '@/queries/useStaffLeaveRequestsQuery';

export type LeaveRequestDetailsProps = {
  data: {
    prior_sanction_from_whom?: StaffLeaveRequest['prior_sanction_from_whom'];
    prior_sanction_why_not?: StaffLeaveRequest['prior_sanction_why_not'];
    reason?: StaffLeaveRequest['reason'];
  };
};

const LeaveRequestDetailsImpl: React.FC<LeaveRequestDetailsProps> = ({ data }) => {
  return (
    <React.Fragment>
      <Text style={styles.text}>
        <Text style={styles.label}>Leave Reason:</Text> {data.reason}
      </Text>

      {data.prior_sanction_from_whom ? (
        <Text style={styles.text}>
          <Text style={styles.label}>Prior Sanction From:</Text> {data.prior_sanction_from_whom}
        </Text>
      ) : (
        <Text style={styles.text}>
          <Text style={styles.label}>Reason for No Prior Sanction:</Text> {data.prior_sanction_why_not}
        </Text>
      )}
    </React.Fragment>
  );
};

const styles = StyleSheet.create({
  text: { fontSize: 16, lineHeight: 16 * 1.5, fontWeight: '400', color: '#323232' },
  label: { fontSize: 15, lineHeight: 15 * 1.5, fontWeight: '500', color: '#767676' },
});

export const LeaveRequestDetails = React.memo(LeaveRequestDetailsImpl);
