import * as React from 'react';
import { StyleSheet, TouchableOpacity, Text, Image, View, Platform } from 'react-native';
import dayjs from 'dayjs';

import { StaffLeaveDetails, useStaffLeaveBalancesQuery } from '@/queries/useStaffLeaveBalancesQuery';
import {
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuLabel,
  DropdownMenuRoot,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
  DropdownMenuCheckboxItem,
  DropdownMenuItemSubtitle,
  DropdownMenuItemTitle,
} from '@/design-system/dropdown-menu';

export type LeaveTypeMenuProps = {
  onSelect?: (option: StaffLeaveDetails) => void;
  selectedOption?: StaffLeaveDetails | null;
};

const LeaveTypeMenuImpl: React.FC<LeaveTypeMenuProps> = ({ onSelect, selectedOption }) => {
  const staffLeaveBalancesQuery = useStaffLeaveBalancesQuery(dayjs().format('YYYY'));

  return (
    <DropdownMenuRoot>
      <DropdownMenuTrigger>
        <TouchableOpacity style={styles.triggerButton}>
          <View>
            <Text style={[styles.text, selectedOption ? null : { color: '#565656' }]}>
              {selectedOption ? selectedOption.leave_name : 'Select'}
            </Text>

            {selectedOption?.balance ? (
              <Text style={styles.smallText}>Bal: {selectedOption?.balance} day(s)</Text>
            ) : null}
          </View>

          <Image
            source={require('@/assets/icons/ic_chevron_up_chevron_down.png')}
            style={[{ width: 14, height: 14, resizeMode: 'contain' }, selectedOption ? null : { tintColor: '#565656' }]}
          />
        </TouchableOpacity>
      </DropdownMenuTrigger>

      <DropdownMenuContent>
        <DropdownMenuGroup>
          <DropdownMenuLabel>Available</DropdownMenuLabel>

          {staffLeaveBalancesQuery.data
            ?.filter(
              (leaveBalance) =>
                leaveBalance.leave_code === 'LWP' ||
                (leaveBalance.total && leaveBalance.total > 0 && leaveBalance.balance && leaveBalance.balance > 0)
            )
            ?.map((leaveBalance, index) => {
              return (
                <DropdownMenuCheckboxItem
                  key={leaveBalance._id || index.toString()}
                  value={selectedOption?._id === leaveBalance._id}
                  onSelect={() => onSelect?.(leaveBalance)}
                >
                  <DropdownMenuItemTitle>
                    {`${leaveBalance.leave_name} (${leaveBalance.leave_code})${Platform.OS === 'android' ? ` (Bal: ${leaveBalance.leave_code === 'LWP' ? '♾️' : typeof leaveBalance.balance === 'number' ? leaveBalance.balance : '-'})` : ''}`}
                  </DropdownMenuItemTitle>

                  <DropdownMenuItemSubtitle>
                    {`Balance: ${leaveBalance.leave_code === 'LWP' ? '♾️' : typeof leaveBalance.balance === 'number' ? leaveBalance.balance : '-'}`}
                  </DropdownMenuItemSubtitle>
                </DropdownMenuCheckboxItem>
              );
            })}
        </DropdownMenuGroup>

        <DropdownMenuSeparator />

        <DropdownMenuGroup>
          <DropdownMenuLabel>Not Available</DropdownMenuLabel>

          {staffLeaveBalancesQuery.data
            ?.filter(
              (leaveBalance) =>
                leaveBalance.leave_code !== 'LWP' &&
                leaveBalance.total &&
                leaveBalance.total > 0 &&
                (!leaveBalance.balance || leaveBalance.balance <= 0)
            )
            ?.map((leaveBalance, index) => {
              return (
                <DropdownMenuCheckboxItem
                  key={leaveBalance._id || index.toString()}
                  value={selectedOption?._id === leaveBalance._id}
                  disabled
                  onSelect={() => onSelect?.(leaveBalance)}
                >
                  <DropdownMenuItemTitle>
                    {`${leaveBalance.leave_name} (${leaveBalance.leave_code})`}
                  </DropdownMenuItemTitle>

                  <DropdownMenuItemSubtitle>
                    {`Balance: ${typeof leaveBalance.balance === 'number' ? leaveBalance.balance : '-'}`}
                  </DropdownMenuItemSubtitle>
                </DropdownMenuCheckboxItem>
              );
            })}
        </DropdownMenuGroup>
      </DropdownMenuContent>
    </DropdownMenuRoot>
  );
};

const styles = StyleSheet.create({
  text: { fontSize: 16, lineHeight: 16 * 1.5, color: '#000000' },
  smallText: { fontSize: 14, lineHeight: 14 * 1.5, color: '#343434' },
  triggerButton: { flexDirection: 'row', gap: 8, alignItems: 'center', justifyContent: 'center' },
});

export const LeaveTypeMenu = React.memo(LeaveTypeMenuImpl);
