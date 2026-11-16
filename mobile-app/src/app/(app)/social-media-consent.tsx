import * as Haptics from 'expo-haptics';
import { router } from 'expo-router';
import * as React from 'react';
import {
  ActivityIndicator,
  Image,
  Modal,
  NativeScrollEvent,
  NativeSyntheticEvent,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableHighlight,
  TouchableOpacity,
  View,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import Toast from 'react-native-toast-message';

import { ThemedText } from '@/components/themed-text';
import { useTheme } from '@/hooks/use-theme';
import { useSocialMediaConsentMutation } from '@/queries/useSocialMediaConsentMutation';

const POLICY_TEXT = `MOUNT CARMEL SCHOOL
"OffLine till Nine" Policy & Digital Wellness Guidelines

Dear Parents and Students,

In today's digital era, screen time and online engagement have increased significantly. While technology enables immense learning opportunities, excessive and unmonitored digital presence during crucial family and study hours can have adverse impacts on emotional well-being, physical health, sleep patterns, and academic growth.

POLICY OBJECTIVES:
1. Promote Dedicated Focus Hours: Ensuring student evenings from 6:00 PM to 9:00 PM are preserved for focused studies, homework, reading, and healthy family bonding.
2. Digital Safety & Mindful Social Media Usage: Encouraging constructive, safe, and age-appropriate participation on digital platforms with parental supervision.
3. Mental & Physical Well-being: Fostering restorative sleep cycles, reduced screen fatigue, and balanced extracurricular lifestyles.

PARENTAL COMMITMENT & GUIDELINES:
• I agree to encourage my child to refrain from recreational device usage and social media browsing during the designated evening hours (6 PM - 9 PM).
• I will maintain active awareness and supervision regarding the apps, games, and platforms accessed by my ward.
• I agree to support the school's digital wellness culture by promoting healthy offline hobbies, sports, and reading habits at home.

Please review the policy in full. By submitting your consent below, you confirm your partnership with Mount Carmel School in building a healthy digital environment for our children.`;

export default function SocialMediaConsentScreen() {
  const [hasReadToEnd, setHasReadToEnd] = React.useState(false);
  const [agree, setAgree] = React.useState(false);
  const [errorVisible, setErrorVisible] = React.useState(false);
  const [modalVisible, setModalVisible] = React.useState(false);
  const [parentName, setParentName] = React.useState('');
  const consentMutation = useSocialMediaConsentMutation();
  const submitting = consentMutation.isPending;
  const theme = useTheme();

  const handleScroll = (e: NativeSyntheticEvent<NativeScrollEvent>) => {
    const { contentOffset, contentSize, layoutMeasurement } = e.nativeEvent;
    if (contentOffset.y + layoutMeasurement.height >= contentSize.height - 24) {
      setHasReadToEnd(true);
    }
  };

  const handleCheckboxPress = () => {
    if (!hasReadToEnd) {
      Toast.show({
        type: 'error',
        text1: 'Please read the policy till the last page before accepting it.',
        topOffset: 100,
        position: 'top',
      });
      return;
    }
    setErrorVisible(false);
    setAgree((value) => !value);
    Haptics.selectionAsync();
  };

  const handleSubmitPress = () => {
    if (!agree) {
      setErrorVisible(true);
      return;
    }
    setModalVisible(true);
  };

  const handleConfirmSubmit = () => {
    const trimmed = parentName.trim();
    if (trimmed.length < 3 || !/^[a-zA-Z\s\-'.]+$/.test(trimmed)) {
      Toast.show({
        type: 'error',
        text1: 'Please enter a valid full name!',
        topOffset: 100,
        position: 'top',
      });
      return;
    }
    setModalVisible(false);
    consentMutation.mutate(
      { is_agree: true, parent_name: trimmed },
      {
        onSuccess: () => {
          router.replace('/assignments');
        },
      }
    );
  };

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['left', 'right', 'bottom']}>
      <ScrollView
        style={[styles.content, { backgroundColor: theme.backgroundElement }]}
        onScroll={handleScroll}
        scrollEventThrottle={200}
      >
        <ThemedText style={styles.policyText}>{POLICY_TEXT}</ThemedText>
      </ScrollView>

      <View style={[styles.footer, { backgroundColor: theme.backgroundElement, borderTopColor: theme.background }]}>
        <TouchableOpacity disabled={submitting} style={styles.checkboxRow} onPress={handleCheckboxPress}>
          <Image
            source={
              agree
                ? require('@/assets/images/paybill/ic_checkbox_active.png')
                : require('@/assets/images/paybill/ic_checkbox_inactive.png')
            }
            style={styles.checkboxImage}
          />
          <ThemedText style={styles.describe}>
            I agree to follow and support the "OffLine till Nine" policy at home.
          </ThemedText>
        </TouchableOpacity>

        {errorVisible ? <Text style={styles.error}>Please review the full policy to the end to continue.</Text> : null}

        <TouchableHighlight style={styles.submitButton} disabled={submitting} onPress={handleSubmitPress}>
          <View style={styles.submitButtonInner}>
            <Text style={[styles.submitButtonText, { opacity: submitting ? 0 : 1 }]}>Submit & view AR</Text>
            {submitting ? <ActivityIndicator size="small" color="#ffffff" style={styles.loader} /> : null}
          </View>
        </TouchableHighlight>
      </View>

      {/* Confirmation Modal */}
      <Modal visible={modalVisible} transparent animationType="fade">
        <View style={styles.modalOverlay}>
          <View style={[styles.modalCard, { backgroundColor: theme.background }]}>
            <ThemedText style={styles.modalTitle}>Almost done!</ThemedText>
            <ThemedText themeColor="textSecondary" style={styles.modalSubtitle}>
              To confirm your participation, please type your full name below:
            </ThemedText>

            <TextInput
              style={[styles.nameInput, { color: theme.text, borderColor: theme.backgroundElement }]}
              placeholder="Full Parent / Guardian Name"
              placeholderTextColor="#94a3b8"
              value={parentName}
              onChangeText={setParentName}
              autoFocus
            />

            <View style={styles.modalActions}>
              <TouchableOpacity
                style={[styles.modalButton, styles.cancelButton]}
                onPress={() => setModalVisible(false)}
              >
                <Text style={styles.cancelButtonText}>Cancel</Text>
              </TouchableOpacity>

              <TouchableOpacity
                style={[styles.modalButton, styles.confirmButton]}
                onPress={handleConfirmSubmit}
              >
                <Text style={styles.confirmButtonText}>Confirm & Submit</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  content: { flex: 1 },
  policyText: { padding: 20, fontSize: 14, lineHeight: 22 },
  footer: {
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderTopWidth: StyleSheet.hairlineWidth,
    gap: 12,
  },
  checkboxRow: { flexDirection: 'row', gap: 12, alignItems: 'center' },
  checkboxImage: { width: 24, height: 24, resizeMode: 'contain' },
  describe: { flexShrink: 1, fontSize: 14, lineHeight: 20 },
  error: { fontSize: 13, lineHeight: 18, color: '#ef4444' },
  submitButton: { paddingVertical: 14, paddingHorizontal: 16, borderRadius: 8, backgroundColor: '#2658A5' },
  submitButtonInner: { position: 'relative', alignItems: 'center' },
  submitButtonText: { fontSize: 16, fontWeight: '700', color: '#ffffff' },
  loader: { flex: 1, position: 'absolute', alignSelf: 'center' },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.6)',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 24,
  },
  modalCard: {
    width: '100%',
    maxWidth: 380,
    borderRadius: 16,
    padding: 24,
    gap: 16,
  },
  modalTitle: { fontSize: 18, fontWeight: '700' },
  modalSubtitle: { fontSize: 14, lineHeight: 20 },
  nameInput: {
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 14,
    paddingVertical: 10,
    fontSize: 15,
  },
  modalActions: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    gap: 12,
    marginTop: 8,
  },
  modalButton: {
    paddingHorizontal: 16,
    paddingVertical: 10,
    borderRadius: 8,
  },
  cancelButton: {
    backgroundColor: '#f1f5f9',
  },
  cancelButtonText: {
    color: '#475569',
    fontWeight: '600',
    fontSize: 14,
  },
  confirmButton: {
    backgroundColor: '#2658A5',
  },
  confirmButtonText: {
    color: '#ffffff',
    fontWeight: '600',
    fontSize: 14,
  },
});

