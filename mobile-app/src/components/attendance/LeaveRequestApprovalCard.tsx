import * as React from 'react';
import dayjs from 'dayjs';
import {
  Image,
  StyleProp,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  ViewStyle,
  Animated,
  useAnimatedValue,
  Easing,
} from 'react-native';

import { Card } from '@/components/Card';
import { LeaveAssessor } from './LeaveAssessor';
import { LeaveFromToDateTimeView } from './LeaveFromToDateTimeView';
import { LeaveRequestDetailsTrigger } from './LeaveRequestDetailsTrigger';
import { LeaveRequestDetails } from './LeaveRequestDetails';
import type { StaffLeaveApproval } from '@/queries/useStaffLeaveApprovalsQuery';

export type LeaveRequestApprovalCardProps = {
  style?: StyleProp<ViewStyle>;
  data: StaffLeaveApproval;
  imagePathPrefix?: string;
  onLeaveActionPress?: (action: 'positive' | 'negative', leaveRequest: StaffLeaveApproval) => void;
};

const _LeaveRequestApprovalCard: React.FC<LeaveRequestApprovalCardProps> = ({
  style,
  data,
  imagePathPrefix,
  onLeaveActionPress,
}) => {
  const [expanded, setExpanded] = React.useState(false);
  const expandedValue = useAnimatedValue(0);

  const assessors = data.assessor;
  const currentAssessor = Array.isArray(assessors) && assessors.length > 0 ? assessors.at(assessors.length - 1) : null;

  const onPositiveActionPress = () => onLeaveActionPress?.('positive', data);
  const onNegativeActionPress = () => onLeaveActionPress?.('negative', data);

  const handleDetailsPress = () => {
    expandedValue.stopAnimation();

    Animated.timing(expandedValue, {
      toValue: !expanded ? 1 : 0,
      useNativeDriver: true,
      duration: 300,
      isInteraction: true,
      easing: Easing.linear,
    }).start();

    setExpanded(!expanded);
  };

  return (
    <Card style={StyleSheet.flatten([styles.container, style])}>
      <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
        <View style={{ gap: 8, flex: 1 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
            <Image source={require('@/assets/icons/ic_calendar_clock.png')} style={{ width: 20, height: 20, resizeMode: 'contain' }} />
            <Text style={styles.smallText}>Submitted on {dayjs(data.created_at).format('DD MMM YYYY')}</Text>
          </View>

          <View style={{ gap: 4 }}>
            <Text style={styles.label}>
              Name: <Text style={styles.text}>{data.staff_id?.name}</Text>
            </Text>

            {data.staff_id?.profile_pic ? null : (
              <Text style={styles.label}>
                Emp. Code: <Text style={styles.text}>{data.staff_id?.employee_code || 'N.A.'}</Text>
              </Text>
            )}

            {data.leave_type === 'LEAVE' ? (
              <Text style={styles.label}>
                Leave Type: <Text style={styles.text}>{data.leave_id?.leave_name}</Text>
              </Text>
            ) : null}
          </View>
        </View>

        <Image
          source={{ uri: `${imagePathPrefix || ''}/${data.staff_id?.profile_pic}` }}
          style={{ width: 56, height: 56, borderRadius: 28, backgroundColor: '#fefefe', resizeMode: 'center' }}
        />
      </View>

      <LeaveFromToDateTimeView data={data} />

      <View style={styles.triggerContainer}>
        <View style={{ flex: 1 }} />
        <LeaveRequestDetailsTrigger expandedValue={expandedValue} triggerText="More Details" onPress={handleDetailsPress} />
      </View>

      {expanded ? (
        <>
          <Text style={styles.label}>
            Emp. Code: <Text style={styles.text}>{data.staff_id?.employee_code || 'N.A.'}</Text>
          </Text>
          <Text style={styles.label}>
            Desigation: <Text style={styles.text}>{data.staff_id?.designation || 'N.A.'}</Text>
          </Text>
          <Text style={styles.label}>
            Department: <Text style={styles.text}>{data.staff_id?.department_id?.name || 'N.A.'}</Text>
          </Text>

          <LeaveRequestDetails data={data} />

          <View style={styles.previousAssessors}>
            <Text style={styles.label}>Previous Assessors:</Text>

            <View style={{ flexDirection: 'row' }}>
              <View style={styles.previousAssessorsLine} />

              <View style={styles.previousAssessorsWrapper}>
                {assessors?.map((assessor) => (
                  <LeaveAssessor key={assessor._id} data={assessor} />
                ))}
              </View>
            </View>
          </View>
        </>
      ) : null}

      {currentAssessor ? (
        <View style={styles.buttonContainer}>
          <TouchableOpacity style={styles.button} onPress={onPositiveActionPress}>
            <Text style={[styles.text, styles.semiBold, { color: '#34A853' }]}>
              {currentAssessor.is_last_assessor ? 'Approve' : 'Recommend'}
            </Text>
          </TouchableOpacity>

          <View style={styles.verticalDivider} />

          <TouchableOpacity style={styles.button} onPress={onNegativeActionPress}>
            <Text style={[styles.text, styles.semiBold, { color: '#0D47A1' }]}>
              {currentAssessor.is_last_assessor ? 'Reject' : 'Not-Recommend'}
            </Text>
          </TouchableOpacity>
        </View>
      ) : null}
    </Card>
  );
};

const styles = StyleSheet.create({
  container: {
    flexGrow: 1,
    padding: 12,
    paddingBottom: 0,
    gap: 4,
    borderRadius: 8,
    backgroundColor: '#ffffff',
    shadowColor: '#000000',
    shadowRadius: 2,
    shadowOffset: { height: 0.7, width: 0 },
    shadowOpacity: 0.07,
    elevation: 2,
  },
  smallText: { fontSize: 14, lineHeight: 14 * 1.5, fontWeight: '400', color: '#323232' },
  label: { fontSize: 15, lineHeight: 15 * 1.5, fontWeight: '500', color: '#767676' },
  text: { fontSize: 16, lineHeight: 16 * 1.5, fontWeight: '400', color: '#323232' },
  semiBold: { fontWeight: '500' },
  verticalDivider: { height: '100%', width: StyleSheet.hairlineWidth, backgroundColor: '#676767' },
  buttonContainer: { flexDirection: 'row', borderTopColor: '#676767', borderTopWidth: StyleSheet.hairlineWidth },
  button: { flex: 1, padding: 12, alignItems: 'center', justifyContent: 'center' },
  previousAssessors: { flex: 1, gap: 2 },
  previousAssessorsLine: { width: 1.5, backgroundColor: '#bababa', marginBottom: 12 },
  previousAssessorsWrapper: { flexDirection: 'column', flex: 1 },
  triggerContainer: { flex: 1, paddingVertical: 4, flexDirection: 'row', alignItems: 'flex-end', gap: 32 },
});

export const LeaveRequestApprovalCard = React.memo(_LeaveRequestApprovalCard);
