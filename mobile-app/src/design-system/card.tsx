import * as React from 'react';
import { StyleSheet, TouchableOpacity, View } from 'react-native';
import type { TouchableOpacityProps, ViewProps } from 'react-native';

import { useTheme } from '@/hooks/use-theme';

export type CardProps = ({ touchable: true } & TouchableOpacityProps) | ViewProps;

export const Card: React.FC<CardProps> = ({ style, ...restProps }) => {
  const theme = useTheme();
  const themedStyle = [styles.container, { backgroundColor: theme.backgroundElement }, style];

  if ('touchable' in restProps) {
    return <TouchableOpacity style={StyleSheet.flatten(themedStyle)} {...restProps} />;
  }

  return <View style={StyleSheet.flatten(themedStyle)} {...restProps} />;
};

const styles = StyleSheet.create({
  container: {
    flexGrow: 1,
    padding: 12,
    borderRadius: 8,
    shadowColor: '#000000',
    shadowRadius: 2,
    shadowOffset: { height: 0.7, width: 0 },
    shadowOpacity: 0.07,
    elevation: 2,
  },
});
