import dayjs from 'dayjs';
import * as React from 'react';
import { StyleSheet, TouchableOpacity, Text, Image, View } from 'react-native';

import {
  DropdownMenuContent,
  DropdownMenuRoot,
  DropdownMenuTrigger,
  DropdownMenuCheckboxItem,
  DropdownMenuItemTitle,
} from '@/design-system/dropdown-menu';

export type HalfDayLeaveDateMenuProps = {
  onSelect?: (option: Date) => void;
  onDisabledPress?: () => void;
  selectedOption?: Date | null;
  disabled?: boolean;
  dates: Date[];
};

const HalfDayLeaveDateMenuImpl: React.FC<HalfDayLeaveDateMenuProps> = ({
  onSelect,
  onDisabledPress,
  selectedOption,
  disabled,
  dates,
}) => {
  if (disabled) {
    return (
      <TouchableOpacity style={styles.triggerButton} onPress={onDisabledPress}>
        <View>
          <Text style={[styles.text, selectedOption ? null : { color: '#565656' }]}>
            {selectedOption ? dayjs(selectedOption).format('D MMM YYYY') : 'Select'}
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
      <DropdownMenuTrigger>
        <TouchableOpacity style={styles.triggerButton}>
          <View>
            <Text style={[styles.text, selectedOption ? null : { color: '#565656' }]}>
              {selectedOption ? dayjs(selectedOption).format('D MMM YYYY') : 'Select'}
            </Text>
          </View>

          <Image
            source={require('@/assets/icons/ic_chevron_up_chevron_down.png')}
            style={[{ width: 14, height: 14, resizeMode: 'contain' }, selectedOption ? null : { tintColor: '#565656' }]}
          />
        </TouchableOpacity>
      </DropdownMenuTrigger>

      <DropdownMenuContent>
        {dates.map((date, index) => {
          return (
            <DropdownMenuCheckboxItem
              key={index.toString()}
              value={selectedOption?.toDateString() === date?.toDateString()}
              onSelect={() => onSelect?.(date)}
            >
              <DropdownMenuItemTitle>{`${dayjs(date).format('DD MMM YYYY')}`}</DropdownMenuItemTitle>
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

export const HalfDayLeaveDateMenu = React.memo(HalfDayLeaveDateMenuImpl);
