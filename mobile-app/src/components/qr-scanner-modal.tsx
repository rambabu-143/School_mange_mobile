import { CameraView, useCameraPermissions } from 'expo-camera';
import * as React from 'react';
import { Modal, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

/** Native: QRCodeScannerController (used by both DiscplinaryCardStaffViewController and Wise's
 * StudentViewController) — scans the QR on a student's ID card, which encodes their admission_no
 * plain-text. One scan per open; caller re-opens for another. */
export function QrScannerModal({
  visible,
  onClose,
  onScanned,
}: {
  visible: boolean;
  onClose: () => void;
  onScanned: (admissionNo: string) => void;
}) {
  const [permission, requestPermission] = useCameraPermissions();
  const scannedRef = React.useRef(false);

  React.useEffect(() => {
    if (visible) scannedRef.current = false;
  }, [visible]);

  return (
    <Modal visible={visible} animationType="slide" onRequestClose={onClose}>
      <View style={styles.container}>
        {permission?.granted ? (
          <CameraView
            style={StyleSheet.absoluteFill}
            barcodeScannerSettings={{ barcodeTypes: ['qr'] }}
            onBarcodeScanned={({ data }) => {
              if (scannedRef.current || !data) return;
              scannedRef.current = true;
              onScanned(data);
            }}
          />
        ) : (
          <View style={styles.permissionPrompt}>
            <Text style={styles.permissionText}>
              {permission?.canAskAgain === false
                ? 'Camera access was denied. Enable it from device settings to scan.'
                : 'Camera access is needed to scan the student ID QR code.'}
            </Text>
            {permission?.canAskAgain !== false ? (
              <TouchableOpacity style={styles.grantButton} onPress={requestPermission}>
                <Text style={styles.grantButtonLabel}>Grant Camera Access</Text>
              </TouchableOpacity>
            ) : null}
          </View>
        )}

        <SafeAreaView style={styles.closeRow}>
          <TouchableOpacity style={styles.closeButton} onPress={onClose}>
            <Text style={styles.closeLabel}>Cancel</Text>
          </TouchableOpacity>
        </SafeAreaView>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#000000' },
  permissionPrompt: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 32, gap: 16 },
  permissionText: { color: '#ffffff', textAlign: 'center', fontSize: 15 },
  grantButton: { backgroundColor: '#2658A5', paddingHorizontal: 24, paddingVertical: 12, borderRadius: 8 },
  grantButtonLabel: { color: '#ffffff', fontWeight: '700' },
  closeRow: { position: 'absolute', top: 0, right: 0 },
  closeButton: { padding: 16 },
  closeLabel: { color: '#ffffff', fontWeight: '700', fontSize: 16 },
});
