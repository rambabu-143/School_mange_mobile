import * as React from 'react';
import { StyleSheet, Text, TextInput, View } from 'react-native';

import { StaffSeniorMenu } from '@/components/attendance/StaffSeniorMenu';
import { useNewStaffApplicationStore } from '@/stores/new-staff-application-store';
import { SeniorRole } from '@/queries/useGetStaffSeniorsQuery';

export const CommonFieldsImpl: React.FC = () => {
  const leaveReasonText = useNewStaffApplicationStore((state) => state.leaveReasonText);
  const setLeaveReasonText = useNewStaffApplicationStore.getState().setLeaveReasonText;

  const leaveReasonError = useNewStaffApplicationStore((state) => state.leaveReasonError);
  const setLeaveReasonError = useNewStaffApplicationStore.getState().setLeaveReasonError;

  const priorApprovalTakenFrom = useNewStaffApplicationStore((state) => state.priorApprovalTakenFrom);
  const isPriorApprovalTaken = useNewStaffApplicationStore((state) => state.isPriorApprovalTaken);

  const noPriorApprovalReasonText = useNewStaffApplicationStore((state) => state.noPriorApprovalReasonText);
  const setNoPriorApprovalReasonText = useNewStaffApplicationStore.getState().setNoPriorApprovalReasonText;

  const priorApprovalError = useNewStaffApplicationStore((state) => state.priorApprovalError);
  const setPriorApprovalError = useNewStaffApplicationStore.getState().setPriorApprovalError;

  const setIsPriorApprovalTaken = useNewStaffApplicationStore.getState().setIsPriorApprovalTaken;
  const setPriorApprovalTakenFrom = useNewStaffApplicationStore.getState().setPriorApprovalTakenFrom;

  const onSeniorSelect = React.useCallback((option: SeniorRole) => {
    setIsPriorApprovalTaken(true);
    setPriorApprovalTakenFrom(option);
    setPriorApprovalError('');
  }, []);

  const onNoPriorApprovalSelect = React.useCallback(() => {
    setIsPriorApprovalTaken(false);
    setPriorApprovalTakenFrom(null);
    setPriorApprovalError('');
  }, []);

  return (
    <>
      {/* Leave Reason */}
      <View style={{ gap: 2 }}>
        <View style={{ gap: 4, backgroundColor: '#efefef', borderRadius: 8, padding: 16 }}>
          <View
            style={{
              flexDirection: 'row',
              gap: 12,
              alignItems: 'center',
              justifyContent: 'space-between',
            }}
          >
            <Text style={{ fontSize: 15, lineHeight: 15 * 1.5, color: '#343434', fontWeight: '500' }}>
              Leave Reason:
            </Text>

            <Text style={{ fontSize: 14, lineHeight: 14 * 1.5, color: '#000000', fontWeight: '400' }}>
              {leaveReasonText.length}/150
            </Text>
          </View>

          <TextInput
            style={{ paddingTop: 0, fontSize: 16, lineHeight: 16 * 1.5 }}
            placeholderTextColor={'#9a9a9a'}
            placeholder="Please provide a reason for leave"
            onChangeText={(text) => {
              setLeaveReasonText(text);
              setLeaveReasonError('');
            }}
            numberOfLines={4}
            maxLength={150}
            multiline
          />
        </View>

        {leaveReasonError.length > 0 ? (
          <Text style={{ fontSize: 14, lineHeight: 14 * 1.5, color: 'tomato', fontWeight: '500', marginLeft: 4 }}>
            {leaveReasonError}
          </Text>
        ) : null}
      </View>

      {/* Prior Approval */}
      <View style={{ gap: 2 }}>
        <View style={{ backgroundColor: '#efefef', borderRadius: 8 }}>
          <View
            style={{
              flexDirection: 'row',
              gap: 24,
              padding: 16,
              alignItems: 'flex-start',
              justifyContent: 'space-between',
            }}
          >
            <Text
              style={{ flex: 1, fontSize: 15, lineHeight: 15 * 1.5, fontWeight: '500', color: '#343434' }}
            >
              Prior sanction has been obtained from:
            </Text>

            <StaffSeniorMenu
              selectedOption={priorApprovalTakenFrom}
              noPriorApprovalSelected={isPriorApprovalTaken === false}
              noOptionLabel={isPriorApprovalTaken === false ? 'No Prior Approval' : undefined}
              onSelect={onSeniorSelect}
              onNoPriorApprovalSelect={onNoPriorApprovalSelect}
            />
          </View>

          {isPriorApprovalTaken === false ? (
            <>
              <View style={styles.cardItemDivider} />

              <View style={{ gap: 8, padding: 16, flexDirection: 'row', alignItems: 'flex-start' }}>
                <TextInput
                  style={{ flex: 1, paddingTop: 0, fontSize: 16, lineHeight: 16 * 1.5, minHeight: 48 }}
                  defaultValue={noPriorApprovalReasonText}
                  placeholderTextColor={'#9a9a9a'}
                  placeholder="Please provide a reason for not obtaining prior leave sanction"
                  onChangeText={(text) => {
                    setNoPriorApprovalReasonText(text);
                    setPriorApprovalError('');
                  }}
                  maxLength={150}
                  multiline
                />

                <Text style={{ marginTop: 4, fontSize: 14, lineHeight: 14 * 1.5, fontWeight: '400' }}>
                  {noPriorApprovalReasonText.length}/150
                </Text>
              </View>
            </>
          ) : null}
        </View>

        {priorApprovalError ? (
          <Text style={{ fontSize: 14, lineHeight: 14 * 1.5, color: 'tomato', fontWeight: '500', marginLeft: 4 }}>
            {priorApprovalError}
          </Text>
        ) : null}
      </View>
    </>
  );
};

const styles = StyleSheet.create({
  cardItemDivider: {
    height: StyleSheet.hairlineWidth,
    marginLeft: 16,
    backgroundColor: '#343434',
  },
});

export const CommonFields = React.memo(CommonFieldsImpl);
