import * as React from 'react';
import {
  ActivityIndicator,
  Alert,
  FlatList,
  Image,
  ListRenderItem,
  Platform,
  RefreshControl,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import dayjs from 'dayjs';
import duration from 'dayjs/plugin/duration';

import { StaffLeaveApproval, useStaffLeaveApprovalsQuery } from '@/queries/useStaffLeaveApprovalsQuery';
import { YearSelectMenu } from './YearSelectMenu';
import { LeaveRequestApprovalCard } from './LeaveRequestApprovalCard';
import { useUpdateLeaveRequestStatusMutation } from '@/queries/useUpdateLeaveRequestStatusMutation';

dayjs.extend(duration);

export type LeaveApprovalModalContentProps = { closeModal: () => void };

const _LeaveApprovalModalContent: React.FC<LeaveApprovalModalContentProps> = ({ closeModal }) => {
  const [selectedYear, setSelectedYear] = React.useState(dayjs().format('YYYY'));

  const staffLeaveApprovalsQuery = useStaffLeaveApprovalsQuery(selectedYear);
  const updateLeaveRequestStatusMutation = useUpdateLeaveRequestStatusMutation();

  const updatingLeaveRequestId = updateLeaveRequestStatusMutation.isPending
    ? updateLeaveRequestStatusMutation.variables?.leave._id
    : null;

  const handleActionOnLeave = React.useCallback(
    async (actionType: 'positive' | 'negative', leave: StaffLeaveApproval) => {
      try {
        const isLastAssessor = leave.assessor?.at(-1)?.is_last_assessor || false;
        const status =
          actionType === 'positive' ? (isLastAssessor ? 'APPROVED' : 'Recommended') : isLastAssessor ? 'REJECTED' : 'Not-Recommended';

        await updateLeaveRequestStatusMutation.mutateAsync({
          isSanction: actionType === 'positive' && isLastAssessor,
          leave,
          status,
        });
        Alert.alert('Success', `Leave request has been ${status} successfully!`, [{ text: 'dismiss', style: 'default' }]);
      } catch (error) {
        Alert.alert('Error', (error as Error)?.message, [{ text: 'dismiss', style: 'default' }]);
      }
    },
    [updateLeaveRequestStatusMutation]
  );

  const confirmHandleActionOnLeave = React.useCallback(
    async (actionType: 'positive' | 'negative', leave: StaffLeaveApproval) => {
      const isLastAssessor = leave.assessor?.at(-1)?.is_last_assessor || false;
      const status = actionType === 'positive' ? (isLastAssessor ? 'Approved' : 'Recommended') : isLastAssessor ? 'Rejected' : 'Not-Recommended';
      const statusLabel = actionType === 'positive' ? (isLastAssessor ? 'Approve' : 'Recommend') : isLastAssessor ? 'Reject' : 'Not-Recommend';

      Alert.alert(
        `${status} Confirmation!`,
        `Are you sure you want to ${statusLabel} the leave request of ${leave.staff_id?.name}?`,
        [
          { text: 'Cancel', style: 'cancel' },
          { text: statusLabel, style: actionType === 'positive' ? 'default' : 'destructive', onPress: () => handleActionOnLeave(actionType, leave) },
        ],
        { cancelable: true, userInterfaceStyle: 'light' }
      );
    },
    [handleActionOnLeave]
  );

  const _renderItem: ListRenderItem<StaffLeaveApproval> = React.useCallback(
    ({ item }) => (
      <LeaveRequestApprovalCard
        data={item}
        onLeaveActionPress={confirmHandleActionOnLeave}
        imagePathPrefix={staffLeaveApprovalsQuery.data?.path as string | undefined || ''}
        style={{ opacity: updatingLeaveRequestId === item._id ? 0.3 : 1 }}
      />
    ),
    [updatingLeaveRequestId, confirmHandleActionOnLeave, staffLeaveApprovalsQuery.data?.path]
  );

  const leaveRequests = staffLeaveApprovalsQuery.data?.data;

  return (
    <View style={{ flex: 1, ...Platform.select({ android: styles.backdrop }) }}>
      <View style={{ flex: 1, backgroundColor: '#f6f6f6', ...Platform.select({ android: styles.content }) }}>
        <View style={{ backgroundColor: '#ffffff', gap: 8, paddingBottom: 12, borderColor: '#e0e0e0', borderBottomWidth: StyleSheet.hairlineWidth }}>
          <View style={[styles.header]}>
            <Text style={[styles.headerText]}>Leave Approvals</Text>

            <YearSelectMenu onSelect={setSelectedYear} selectedOption={selectedYear} />

            <TouchableOpacity onPress={() => closeModal()} style={styles.closeButton}>
              <Image source={require('@/assets/icons/ic_close.png')} style={{ width: 24, height: 24, resizeMode: 'contain' }} />
            </TouchableOpacity>
          </View>
        </View>

        {staffLeaveApprovalsQuery.isLoading ? (
          <View style={styles.fullScreenLoader}>
            <ActivityIndicator size={'large'} color={'#2658A5'} />
          </View>
        ) : (
          <FlatList
            data={leaveRequests}
            renderItem={_renderItem}
            extraData={staffLeaveApprovalsQuery.data?.path}
            contentContainerStyle={{ gap: 24, paddingHorizontal: 12, paddingTop: 16, paddingBottom: 48 }}
            ListEmptyComponent={
              <View style={styles.fullScreenLoader}>
                <Text style={styles.text}>
                  {staffLeaveApprovalsQuery.isError ? staffLeaveApprovalsQuery.error.message : 'No pending approvals!'}
                </Text>
              </View>
            }
            refreshControl={
              <RefreshControl
                refreshing={staffLeaveApprovalsQuery.isRefetching || false}
                tintColor={'#2658A5'}
                progressBackgroundColor={'#ffffff'}
                colors={['#2658A5']}
                onRefresh={() => staffLeaveApprovalsQuery.refetch()}
              />
            }
          />
        )}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  backdrop: { paddingTop: 44, backgroundColor: 'rgba(34, 34, 34, 0.6)', justifyContent: 'flex-end' },
  content: { borderTopRightRadius: 16, borderTopLeftRadius: 16, overflow: 'hidden' },
  header: { flexDirection: 'row', height: 52, paddingTop: 12, paddingLeft: 12, alignItems: 'center', gap: 8 },
  headerText: { flex: 1, fontSize: 18, lineHeight: 18 * 1.5, fontWeight: '600', color: '#323232' },
  text: { fontSize: 16, lineHeight: 15 * 1.5, fontWeight: '500', color: '#545454' },
  closeButton: { position: 'relative', alignItems: 'center', justifyContent: 'center', paddingHorizontal: 12, height: 32 },
  fullScreenLoader: { flex: 1, minHeight: 400, alignItems: 'center', justifyContent: 'center' },
});

export const LeaveApprovalModalContent = React.memo(_LeaveApprovalModalContent);
