import * as React from 'react';
import { NativeSyntheticEvent, StyleSheet } from 'react-native';
import SegmentedControl, {
  type NativeSegmentedControlIOSChangeEvent,
} from '@react-native-segmented-control/segmented-control';

import { leaveTypes } from './constants';
import { useNewStaffApplicationStore } from '@/stores/new-staff-application-store';

const LeaveSegmentedControlImpl: React.FC = () => {
  const selectedLeaveType = useNewStaffApplicationStore((state) => state.selectedLeaveType);
  const setSelectedLeaveType = useNewStaffApplicationStore.getState().setSelectedLeaveType;

  const leaveTypeLabels = React.useMemo(() => leaveTypes.map((leaveType) => leaveType.label), []);

  const handleLeaveTypeChange = React.useCallback(
    (event: NativeSyntheticEvent<NativeSegmentedControlIOSChangeEvent>) => {
      const selectedIndex = event.nativeEvent.selectedSegmentIndex;
      setSelectedLeaveType(leaveTypes[selectedIndex]);
    },
    []
  );

  return (
    <SegmentedControl
      style={styles.container}
      values={leaveTypeLabels}
      selectedIndex={leaveTypes.findIndex((leaveType) => leaveType.id === selectedLeaveType?.id)}
      onChange={handleLeaveTypeChange}
      appearance="light"
    />
  );
};

const styles = StyleSheet.create({
  container: { marginHorizontal: 12, marginVertical: 8 },
});

export const LeaveSegmentedControl = React.memo(LeaveSegmentedControlImpl);
