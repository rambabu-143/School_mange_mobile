import * as React from 'react';
import { StyleSheet, TouchableOpacity, Text, Image, View } from 'react-native';

import {
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuItemTitle,
  DropdownMenuRoot,
  DropdownMenuTrigger,
} from '@/design-system/dropdown-menu';

export type HalfDaySelectionMenuProps = {
  onSelect?: (option: 0 | 1 | 2) => void;
  onDisabledPress: () => void;
  selectedOption: 0 | 1 | 2;
  disabled?: boolean;
};

const HalfDaySelectionMenuImpl: React.FC<HalfDaySelectionMenuProps> = ({
  onSelect,
  onDisabledPress,
  selectedOption,
  disabled,
}) => {
  if (disabled) {
    return (
      <TouchableOpacity style={styles.triggerButton} onPress={onDisabledPress}>
        <View>
          <Text style={[styles.text, selectedOption ? null : { color: '#565656' }]}>
            {typeof selectedOption === 'number' ? selectedOption : 'Select'}
          </Text>
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
      <DropdownMenuTrigger about="Select number of half day leaves">
        <TouchableOpacity style={styles.triggerButton}>
          <View>
            <Text style={[styles.text, selectedOption ? null : { color: '#565656' }]}>
              {typeof selectedOption === 'number' ? selectedOption : 'Select'}
            </Text>
          </View>

          <Image
            source={require('@/assets/icons/ic_chevron_up_chevron_down.png')}
            style={[{ width: 14, height: 14, resizeMode: 'contain' }, selectedOption ? null : { tintColor: '#565656' }]}
          />
        </TouchableOpacity>
      </DropdownMenuTrigger>

      <DropdownMenuContent>
        {[0 as const, 1 as const, 2 as const].map((halfDayLeave, index) => {
          return (
            <DropdownMenuCheckboxItem
              key={(halfDayLeave || index).toString()}
              value={selectedOption === halfDayLeave}
              onSelect={() => onSelect?.(halfDayLeave)}
            >
              <DropdownMenuItemTitle>{`${halfDayLeave}`}</DropdownMenuItemTitle>
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

export const HalfDaySelectionMenu = React.memo(HalfDaySelectionMenuImpl);
