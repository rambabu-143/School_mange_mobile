import * as React from 'react';
import { ActivityIndicator, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useNewLeaveSubmitAction } from './hooks/useNewLeaveSubmitAction';
import { useNewLeaveCancelAction } from './hooks/useNewLeaveCancelAction';

export type HeaderProps = { closeModal: () => void };

const _Header: React.FC<HeaderProps> = ({ closeModal }) => {
  const { submit, isLoading } = useNewLeaveSubmitAction(closeModal);
  const { cancel } = useNewLeaveCancelAction(closeModal);

  return (
    <View style={headerStyles.header}>
      <TouchableOpacity disabled={isLoading} onPress={cancel} style={headerStyles.closeButton}>
        <Text style={headerStyles.closeBottonText}>Cancel</Text>
      </TouchableOpacity>

      <Text style={headerStyles.headerText}>New</Text>

      <TouchableOpacity onPress={submit} disabled={isLoading} style={headerStyles.closeButton}>
        <Text style={[headerStyles.submitBottonText, isLoading ? { opacity: 0 } : null]}>Done</Text>
        {isLoading ? (
          <ActivityIndicator size={'small'} color={'#343434'} style={{ position: 'absolute' }} />
        ) : null}
      </TouchableOpacity>
    </View>
  );
};

export const Header = React.memo(_Header);

const headerStyles = StyleSheet.create({
  header: { flexDirection: 'row', height: 44, alignItems: 'center' },
  headerText: {
    flex: 1,
    fontSize: 15,
    lineHeight: 15 * 1.5,
    fontWeight: '600',
    color: '#323232',
    textAlign: 'center',
  },
  closeButton: {
    position: 'relative',
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 12,
    height: 32,
  },
  closeBottonText: { fontSize: 16, lineHeight: 16 * 1.5, fontWeight: '600', color: '#5E6D82' },
  submitBottonText: { fontSize: 16, lineHeight: 16 * 1.5, fontWeight: '600', color: '#007AFF' },
});
