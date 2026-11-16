import * as React from 'react';
import { StyleSheet, TouchableOpacity, Text, Image, View } from 'react-native';

import {
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuItemTitle,
  DropdownMenuRoot,
  DropdownMenuTrigger,
} from '@/design-system/dropdown-menu';

export type HalfDayLeaveTypeMenuProps = {
  onSelect?: (option: 'First-Half' | 'Second-Half') => void;
  onDisabledPress?: () => void;
  selectedOption?: 'First-Half' | 'Second-Half' | null;
  disabled?: boolean;
};

const _HalfDayLeaveTypeMenu: React.FC<HalfDayLeaveTypeMenuProps> = ({
  onSelect,
  onDisabledPress,
  selectedOption,
  disabled,
}) => {
  if (disabled) {
    return (
      <TouchableOpacity style={styles.triggerButton} onPress={onDisabledPress}>
        <View>
          <Text style={[styles.text, selectedOption ? null : { color: '#565656' }]}>{selectedOption ?? 'Select'}</Text>
        </View>

        <Image
          source={require('@/assets/icons/ic_chevron_up_chevron_down.png')}
          style={[{ width: 14, height: 14, resizeMode: 'contain' }, selectedOption ? null : { tintColor: '#565656' }]}
        />
      </TouchableOpacity>
    );
  }
  return (
    <DropdownMenuRoot>
      <DropdownMenuTrigger>
        <TouchableOpacity style={styles.triggerButton}>
          <View>
            <Text style={[styles.text, selectedOption ? null : { color: '#565656' }]}>{selectedOption ?? 'Select'}</Text>
          </View>

          <Image
            source={require('@/assets/icons/ic_chevron_up_chevron_down.png')}
            style={[{ width: 14, height: 14, resizeMode: 'contain' }, selectedOption ? null : { tintColor: '#565656' }]}
          />
        </TouchableOpacity>
      </DropdownMenuTrigger>

      <DropdownMenuContent>
        {(['First-Half', 'Second-Half'] as const).map((halfDayLeaveType) => {
          return (
            <DropdownMenuCheckboxItem
              key={halfDayLeaveType}
              value={selectedOption === halfDayLeaveType}
              onSelect={() => onSelect?.(halfDayLeaveType)}
            >
              <DropdownMenuItemTitle>{`${halfDayLeaveType}`}</DropdownMenuItemTitle>
            </DropdownMenuCheckboxItem>
          );
        })}
      </DropdownMenuContent>
    </DropdownMenuRoot>
  );
};

const styles = StyleSheet.create({
  text: { fontSize: 16, lineHeight: 16 * 1.5, color: '#000000' },
  triggerButton: { flexDirection: 'row', gap: 8, alignItems: 'center', justifyContent: 'center' },
});

export const HalfDayLeaveTypeMenu = React.memo(_HalfDayLeaveTypeMenu);
