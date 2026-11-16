import * as React from 'react';
import { Image, Modal, Platform, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Stack } from 'expo-router';
import type { Event } from 'react-native-calendars/src/timeline/EventBlock';

import { CalendarListWrapper } from '@/components/attendance/CalendarListWrapper';
import { DayTimelineModalContent } from '@/components/attendance/DayTimelineModalContent';
import { NewEventModalContent } from '@/components/attendance/leave/NewEventModalContent';
import { LeaveRequestsModalContent } from '@/components/attendance/LeaveRequestsModalContent';
import { LeaveApprovalModalContent } from '@/components/attendance/LeaveApprovalModalContent';
import { useNewStaffApplicationStore } from '@/stores/new-staff-application-store';

// The 3 buttons below (new leave / requests / approvals) use the plain RN Modal-based
// DropdownMenu (src/design-system/dropdown-menu.tsx) — zeego was dropped, this screen
// is fully Expo-Go-testable now.
export default function AttendanceScreen() {
  const [dayModalVisible, setDayModalVisible] = React.useState(false);
  const [dayModalData, setDayModalData] = React.useState<{ date: string; events: Event[] } | null>(null);
  const [newEventModalVisible, setNewEventModalVisible] = React.useState(false);
  const [leaveRequestsModalVisible, setLeaveRequestsModalVisible] = React.useState(false);
  const [leaveApprovalModalVisible, setLeaveApprovalModalVisible] = React.useState(false);

  const resetNewEventStore = useNewStaffApplicationStore.getState().resetAllSlices;

  const closeDayModal = React.useCallback(() => setDayModalVisible(false), []);
  const dayModalDismissedHandler = React.useCallback(() => setDayModalData(null), []);

  const closeNewEventModal = React.useCallback(() => {
    setNewEventModalVisible(false);
    resetNewEventStore();
  }, []);

  const closeLeaveRequestsModal = React.useCallback(() => setLeaveRequestsModalVisible(false), []);
  const closeLeaveApprovalModal = React.useCallback(() => setLeaveApprovalModalVisible(false), []);

  const dayPressHandler = React.useCallback((date: string, events: Event[]) => {
    setDayModalVisible(true);
    setDayModalData({ date, events });
  }, []);

  return (
    <SafeAreaView style={{ flex: 1 }} edges={['left', 'right', 'bottom']}>
      <Stack.Screen
        options={{
          headerRight: () => (
            <View style={{ flexDirection: 'row', gap: 16, alignItems: 'center' }}>
              <TouchableOpacity onPress={() => setNewEventModalVisible(true)}>
                <Image source={require('@/assets/icons/ic_plus.png')} style={{ width: 26, height: 26, resizeMode: 'contain' }} />
              </TouchableOpacity>

              <TouchableOpacity onPress={() => setLeaveRequestsModalVisible(true)}>
                <Image source={require('@/assets/icons/ic_list_bullet.png')} style={{ width: 22, height: 22, resizeMode: 'contain' }} />
              </TouchableOpacity>

              <TouchableOpacity onPress={() => setLeaveApprovalModalVisible(true)}>
                <Image
                  source={require('@/assets/icons/ic_person_circle_checkmark.png')}
                  style={{ width: 30, height: 30, resizeMode: 'contain' }}
                />
              </TouchableOpacity>
            </View>
          ),
        }}
      />

      <View style={{ flex: 1 }}>
        <CalendarListWrapper onDayPress={dayPressHandler} />

        <Modal
          animationType="slide"
          transparent={Platform.OS !== 'ios'}
          visible={dayModalVisible}
          presentationStyle={Platform.OS === 'ios' ? 'pageSheet' : undefined}
          onDismiss={dayModalDismissedHandler}
          onRequestClose={closeDayModal}
          statusBarTranslucent={false}
        >
          {dayModalData ? (
            <DayTimelineModalContent date={dayModalData.date} events={dayModalData.events} closeModal={closeDayModal} />
          ) : null}
        </Modal>

        <Modal
          animationType="slide"
          transparent={Platform.OS !== 'ios'}
          visible={newEventModalVisible}
          presentationStyle={Platform.OS === 'ios' ? 'pageSheet' : undefined}
          onRequestClose={closeNewEventModal}
          statusBarTranslucent={false}
        >
          <NewEventModalContent closeModal={closeNewEventModal} />
        </Modal>

        <Modal
          animationType="slide"
          transparent={Platform.OS !== 'ios'}
          visible={leaveRequestsModalVisible}
          presentationStyle={Platform.OS === 'ios' ? 'pageSheet' : undefined}
          onRequestClose={closeLeaveRequestsModal}
          statusBarTranslucent={false}
        >
          <LeaveRequestsModalContent closeModal={closeLeaveRequestsModal} />
        </Modal>

        <Modal
          animationType="slide"
          transparent={Platform.OS !== 'ios'}
          visible={leaveApprovalModalVisible}
          presentationStyle={Platform.OS === 'ios' ? 'pageSheet' : undefined}
          onRequestClose={closeLeaveApprovalModal}
          statusBarTranslucent={false}
        >
          <LeaveApprovalModalContent closeModal={closeLeaveApprovalModal} />
        </Modal>
      </View>
    </SafeAreaView>
  );
}
