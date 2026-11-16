import * as React from 'react';
import { Linking, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { useTheme } from '@/hooks/use-theme';

// ponytail: native opens this in an embedded WebViewScreenFragment. Opened
// externally instead — avoids adding react-native-webview for one static
// page, same trade-off already made for PDF attachments across the app.
const PRIVACY_POLICY_URL = 'https://mountcarmelschool.com/privacy-policy/';

export default function PrivacyPolicyScreen() {
  const theme = useTheme();
  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['left', 'right', 'bottom']}>
      <View style={styles.centered}>
        <TouchableOpacity style={styles.button} onPress={() => Linking.openURL(PRIVACY_POLICY_URL)}>
          <Text style={styles.buttonLabel}>View Privacy Policy</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  centered: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  button: { paddingHorizontal: 24, paddingVertical: 14, borderRadius: 8, backgroundColor: '#2658A5' },
  buttonLabel: { color: '#ffffff', fontWeight: '700', fontSize: 15 },
});
