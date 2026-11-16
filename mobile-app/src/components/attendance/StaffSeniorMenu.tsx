import * as React from 'react';
import { StyleSheet, TouchableOpacity, Text, Image, Platform } from 'react-native';
import dayjs from 'dayjs';

import type { SeniorRole } from '@/queries/useGetStaffSeniorsQuery';
import { useGetStaffSeniorsQuery } from '@/queries/useGetStaffSeniorsQuery';
import {
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuItemTitle,
  DropdownMenuRoot,
  DropdownMenuTrigger,
  DropdownMenuGroup,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuItemSubtitle,
} from '@/design-system/dropdown-menu';

export type StaffSeniorMenuProps = {
  onSelect?: (option: SeniorRole) => void;
  onNoPriorApprovalSelect?: () => void;
  noPriorApprovalSelected?: boolean;
  selectedOption?: SeniorRole | null;
  noOptionLabel?: string;
};

const _StaffSeniorMenu: React.FC<StaffSeniorMenuProps> = ({
  onSelect,
  noPriorApprovalSelected,
  onNoPriorApprovalSelect,
  selectedOption,
  noOptionLabel,
}) => {
  const getStaffSeniorsQuery = useGetStaffSeniorsQuery(dayjs().format('YYYY'));

  const isValidLabel = Boolean(selectedOption || noOptionLabel);

  return (
    <DropdownMenuRoot>
      <DropdownMenuTrigger>
        <TouchableOpacity style={styles.triggerButton}>
          <Text maxFontSizeMultiplier={1.1} style={[styles.text, isValidLabel ? null : { color: '#565656' }]}>
            {selectedOption ? selectedOption.staff_id.name : noOptionLabel || 'Select'}
          </Text>

          <Image
            source={require('@/assets/icons/ic_chevron_up_chevron_down.png')}
            style={[{ width: 14, height: 14, resizeMode: 'contain' }, isValidLabel ? null : { tintColor: '#565656' }]}
          />
        </TouchableOpacity>
      </DropdownMenuTrigger>

      <DropdownMenuContent>
        <DropdownMenuCheckboxItem
          key={'no-prior-approval'}
          value={noPriorApprovalSelected || false}
          onSelect={() => onNoPriorApprovalSelect?.()}
        >
          <DropdownMenuItemTitle>{'No Prior Approval'}</DropdownMenuItemTitle>
        </DropdownMenuCheckboxItem>

        <DropdownMenuSeparator />

        <DropdownMenuGroup>
          <DropdownMenuLabel>Your Seniors</DropdownMenuLabel>

          {getStaffSeniorsQuery.data?.roles.map((seniorRole) => {
            return (
              <DropdownMenuCheckboxItem
                key={seniorRole._id}
                value={selectedOption?._id === seniorRole._id}
                onSelect={() => onSelect?.(seniorRole)}
              >
                <DropdownMenuItemTitle>
                  {`${seniorRole.staff_id.name}${Platform.OS === 'ios' ? '' : ` (${seniorRole.short_name})`}`}
                </DropdownMenuItemTitle>

                <DropdownMenuItemSubtitle>{`(${seniorRole.short_name})`}</DropdownMenuItemSubtitle>
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
  triggerButton: { flexDirection: 'row', gap: 8, alignItems: 'center', justifyContent: 'center' },
});

export const StaffSeniorMenu = React.memo(_StaffSeniorMenu);
