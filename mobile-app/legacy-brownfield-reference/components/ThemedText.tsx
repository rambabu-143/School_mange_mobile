import * as React from 'react';
import { Text, StyleSheet } from 'react-native';
import type { TextProps } from 'react-native';

export type ThemedTextProps = TextProps & {
  lightColor?: string;
  darkColor?: string;
  type?: 'default' | 'title' | 'smallTitle' | 'defaultSemiBold' | 'subtitle' | 'link' | 'tiny';
};

export function ThemedText({
  style,
  lightColor,
  darkColor,
  type = 'default',
  ...rest
}: ThemedTextProps) {
  return (
    <Text
      style={[
        type === 'default' ? styles.default : undefined,
        type === 'title' ? styles.title : undefined,
        type === 'tiny' ? styles.tiny : undefined,
        type === 'defaultSemiBold' ? styles.defaultSemiBold : undefined,
        type === 'subtitle' ? styles.subtitle : undefined,
        type === 'link' ? styles.link : undefined,
        type === 'smallTitle' ? styles.smallTitle : undefined,
        style,
      ]}
      {...rest}
    />
  );
}

const styles = StyleSheet.create({
  default: {
    fontSize: 16,
    lineHeight: 24,
  },
  defaultSemiBold: {
    fontSize: 16,
    lineHeight: 24,
  },
  tiny: {
    fontSize: 14,
    lineHeight: 18,
  },
  title: {
    fontSize: 32,
    lineHeight: 32 * 1.5,
    fontWeight: 'bold',
  },
  subtitle: {
    fontSize: 20,
    lineHeight: 20*1.4,
    fontWeight: 'bold',
  },
  smallTitle: {
    fontSize: 18,
    lineHeight: 18*1.4,
    fontWeight: 'bold',
  },
  link: {
    lineHeight: 30,
    fontSize: 16,
    color: '#0a7ea4',
  },
});
