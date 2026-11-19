import * as React from 'react';
import { StyleSheet, TouchableOpacity, Text, Image, View } from 'react-native';

import {
  DropdownMenuRoot,
  DropdownMenuTrigger,
  DropdownMenuContent,
  DropdownMenuCheckboxItem,
  DropdownMenuItemTitle,
} from '@/design-system/dropdown-menu';

export type LeaveDayTypeMenuProps = {
  onSelect?: (option: 'Full Day' | 'Half Day') => void;
  onDisabledPress?: () => void;
  selectedOption?: 'Full Day' | 'Half Day' | null;
  disabled?: boolean;
};

const LeaveDayTypeMenuImpl: React.FC<LeaveDayTypeMenuProps> = ({
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
        {['Full Day' as const, 'Half Day' as const].map((leaveDayType) => {
          return (
            <DropdownMenuCheckboxItem
              key={leaveDayType}
              value={selectedOption === leaveDayType}
              onSelect={() => onSelect?.(leaveDayType)}
            >
              <DropdownMenuItemTitle>{`${leaveDayType}`}</DropdownMenuItemTitle>
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

export const LeaveDayTypeMenu = React.memo(LeaveDayTypeMenuImpl);
