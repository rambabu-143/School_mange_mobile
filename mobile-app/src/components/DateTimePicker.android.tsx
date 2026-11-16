import * as React from 'react';
import { StyleSheet, Text, TouchableOpacity } from 'react-native';
import { DateTimePickerAndroid, AndroidNativeProps } from '@react-native-community/datetimepicker';
import dayjs from 'dayjs';

const DateTimePicker: React.FC<AndroidNativeProps & { disabled?: boolean }> = (props) => {
  const { mode } = props;

  return (
    <TouchableOpacity
      style={[styles.container, props.disabled ? null : styles.box, props.style]}
      disabled={props.disabled}
      onPress={() => {
        DateTimePickerAndroid.open(props);
      }}
    >
      <Text style={{ fontSize: 16, lineHeight: 16 * 1.5, color: '#000000' }}>
        {dayjs(props.value).format(mode === 'time' ? 'h:mm A' : 'DD MMM YYYY')}
      </Text>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  container: { paddingVertical: 4, paddingHorizontal: 12 },
  box: { backgroundColor: '#cdcdcd', borderRadius: 8 },
});

export default React.memo(DateTimePicker);
