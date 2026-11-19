import * as React from 'react';
import { Alert } from 'react-native';
import dayjs from 'dayjs';
import duration from 'dayjs/plugin/duration';
import minMax from 'dayjs/plugin/minMax';

import { useNewStaffApplicationStore } from '@/stores/new-staff-application-store';
import {
  LeaveRequest as RegularLeaveRequest,
  LeaveResponse as RegularLeaveResponse,
  useRegularLeaveMutation,
} from '@/queries/useRegularLeaveMutation';
import { LeaveRequest as ShortLeaveRequest, useShortLeaveMutation } from '@/queries/useShortLeaveMutation';
import { LeaveRequest as ODLeaveRequest, useODLeaveMutation } from '@/queries/useODLeaveMutation';
import { LeaveRequest as COLeaveRequest, useCOLeaveMutation } from '@/queries/useCOLeaveMutation';
import { useValidateFields } from './useValidateFields';

dayjs.extend(duration);
dayjs.extend(minMax);

export const useNewLeaveSubmitAction = (closeModal: () => void) => {
  const regularLeaveMutation = useRegularLeaveMutation();
  const shortLeaveMutation = useShortLeaveMutation();
  const odLeaveMutation = useODLeaveMutation();
  const coLeaveMutation = useCOLeaveMutation();

  const {
    validateShortLeaveFields,
    validateRegularLeaveFields,
    validateCommonFields,
    validateODLeaveFields,
    validateCOLeaveFields,
  } = useValidateFields();

  const submitRegularLeave = React.useCallback(
    async (options?: { isConfirmation: boolean; noOfHolidays: number }) => {
      try {
        const {
          numberOfDaysStr,
          numberOfHalfDays,
          from,
          to,
          leaveReasonText,
          isPriorApprovalTaken,
          priorApprovalTakenFrom,
          noPriorApprovalReasonText,
          singleHalfDayLeaveDetails,
          selectedLeaveCategory,
        } = useNewStaffApplicationStore.getState();

        const numOfDays = parseInt(numberOfDaysStr.trim());
        const totalDays = numOfDays + (numberOfHalfDays ? numberOfHalfDays / 2 : 0);

        const leaveCategoryId = selectedLeaveCategory?._id;
        if (!leaveCategoryId) {
          throw new Error('Leave category is not selected properly.');
        }
        const payload: RegularLeaveRequest = {
          leave_id: leaveCategoryId,
          no_of_half_days: numberOfHalfDays || 0,
          no_of_full_days: numberOfDaysStr.trim(),
          no_of_days: totalDays,
          from_date: dayjs(from).format('DD-MM-YYYY'),
          to_date: dayjs(to).format('DD-MM-YYYY'),
          year: dayjs(from).format('YYYY'),
          reason: leaveReasonText,
          prior_sanction: isPriorApprovalTaken ? ('YES' as const) : ('NO' as const),
          prior_sanction_from_whom: priorApprovalTakenFrom?.staff_id?.name ?? '',
          prior_sanction_why_not: priorApprovalTakenFrom ? '' : noPriorApprovalReasonText,
          first_half_day_in:
            numberOfHalfDays === 2
              ? 'SECOND-HALF'
              : numberOfHalfDays === 1 && singleHalfDayLeaveDetails.leaveIn
                ? singleHalfDayLeaveDetails.leaveIn === 'First-Half'
                  ? 'FIRST-HALF'
                  : 'SECOND-HALF'
                : null,
          first_half_day_on:
            numberOfHalfDays === 2
              ? dayjs(from).format('DD-MM-YYYY')
              : numberOfHalfDays === 1
                ? dayjs(singleHalfDayLeaveDetails.leaveOn).format('DD-MM-YYYY')
                : null,
          second_half_day_in: numberOfHalfDays === 2 ? 'FIRST-HALF' : null,
          second_half_day_on: numberOfHalfDays === 2 ? dayjs(to).format('DD-MM-YYYY') : null,
          deduct: options?.isConfirmation ? totalDays + options.noOfHolidays : totalDays,
          no_of_holidays: options?.isConfirmation ? options.noOfHolidays : undefined,
        };
        await regularLeaveMutation.mutateAsync(payload);
        closeModal();
      } catch (err) {
        const error = err as Error & { cause?: RegularLeaveResponse };
        if (error?.cause && typeof error.cause === 'object' && (error.cause as RegularLeaveResponse)?.is_dialog === true) {
          const { message, no_of_holidays } = error.cause as RegularLeaveResponse;
          const noOfHolidays = no_of_holidays ?? 0;
          Alert.alert('Confirmation Required', message || 'Are you sure you want to proceed?', [
            { text: 'Cancel', style: 'cancel' },
            {
              text: `Yes, Proceed${noOfHolidays > 0 ? ` (Including ${noOfHolidays} holiday${noOfHolidays > 1 ? 's' : ''})` : ''}`,
              // eslint-disable-next-line react-hooks/immutability -- only runs after submitRegularLeave is assigned
              onPress: () => submitRegularLeave({ isConfirmation: true, noOfHolidays }),
              style: 'destructive',
            },
          ]);
        } else {
          Alert.alert('Error!', error.message, [{ text: 'Dismiss', style: 'cancel' }]);
        }
      }
    },
    [closeModal]
  );

  const submitShortLeave = React.useCallback(async () => {
    try {
      const {
        shortLeaveDate,
        shortLeaveFromTime,
        shortLeaveToTime,
        leaveReasonText,
        isPriorApprovalTaken,
        priorApprovalTakenFrom,
        noPriorApprovalReasonText,
      } = useNewStaffApplicationStore.getState();

      const payload: ShortLeaveRequest = {
        year: dayjs(shortLeaveDate).format('YYYY'),
        duration: dayjs.duration(dayjs(shortLeaveToTime).diff(dayjs(shortLeaveFromTime))).format('HH:mm'),
        from_date: dayjs(shortLeaveDate).format('DD-MM-YYYY'),
        from_time: dayjs(shortLeaveFromTime).format('HH:mm'),
        to_time: dayjs(shortLeaveToTime).format('HH:mm'),
        reason: leaveReasonText,
        prior_sanction: isPriorApprovalTaken ? ('YES' as const) : ('NO' as const),
        prior_sanction_from_whom: priorApprovalTakenFrom?.staff_id?.name ?? '',
        prior_sanction_why_not: priorApprovalTakenFrom ? '' : noPriorApprovalReasonText,
      };
      await shortLeaveMutation.mutateAsync(payload);
      closeModal();
    } catch (error) {
      const err = error as Error;
      Alert.alert('Error!', err.message, [{ text: 'Dismiss', style: 'cancel' }]);
    }
  }, [closeModal]);

  const submitODLeave = React.useCallback(async () => {
    try {
      const {
        numberOfDaysStr,
        from,
        to,
        leaveReasonText,
        isPriorApprovalTaken,
        priorApprovalTakenFrom,
        noPriorApprovalReasonText,
      } = useNewStaffApplicationStore.getState();

      const numOfDays = parseInt(numberOfDaysStr.trim());

      const payload: ODLeaveRequest = {
        no_of_days: numOfDays,
        deduct: numOfDays,
        from_date: dayjs(from).format('DD-MM-YYYY'),
        to_date: dayjs(to).format('DD-MM-YYYY'),
        year: dayjs(from).format('YYYY'),
        reason: leaveReasonText,
        prior_sanction: isPriorApprovalTaken ? ('YES' as const) : ('NO' as const),
        prior_sanction_from_whom: priorApprovalTakenFrom?.staff_id?.name ?? '',
        prior_sanction_why_not: priorApprovalTakenFrom ? '' : noPriorApprovalReasonText,
      };
      await odLeaveMutation.mutateAsync(payload);
      closeModal();
    } catch (error) {
      const err = error as Error;
      Alert.alert('Error!', err.message, [{ text: 'Dismiss', style: 'cancel' }]);
    }
  }, [closeModal]);

  const submitCOLeave = React.useCallback(async () => {
    try {
      const {
        coLeaveDate,
        coAvailDate,
        coLeaveDayType,
        coHalfDayLeavePeriod,
        leaveReasonText,
        isPriorApprovalTaken,
        priorApprovalTakenFrom,
        noPriorApprovalReasonText,
      } = useNewStaffApplicationStore.getState();

      const payload: COLeaveRequest = {
        from_date: dayjs(coLeaveDate).format('DD-MM-YYYY'),
        avail_date: dayjs(coAvailDate).format('DD-MM-YYYY'),
        no_of_days: coLeaveDayType === 'Half Day' ? 0.5 : 1,
        period:
          coHalfDayLeavePeriod === 'First-Half'
            ? 'FIRST-HALF'
            : coHalfDayLeavePeriod === 'Second-Half'
              ? 'SECOND-HALF'
              : '',
        year: dayjs(coLeaveDate).format('YYYY'),
        reason: leaveReasonText,
        prior_sanction: isPriorApprovalTaken ? ('YES' as const) : ('NO' as const),
        prior_sanction_from_whom: priorApprovalTakenFrom?.staff_id?.name ?? '',
        prior_sanction_why_not: priorApprovalTakenFrom ? '' : noPriorApprovalReasonText,
      };
      await coLeaveMutation.mutateAsync(payload);
      closeModal();
    } catch (error) {
      const err = error as Error;
      Alert.alert(err.name || 'Error!', err.message, [{ text: 'Dismiss', style: 'cancel' }]);
    }
  }, [closeModal]);

  const submit = React.useCallback(() => {
    const { selectedLeaveType } = useNewStaffApplicationStore.getState();

    if (selectedLeaveType?.id === 'regular-leave') {
      if (!validateRegularLeaveFields()) return;
    } else if (selectedLeaveType?.id === 'short-leave') {
      if (!validateShortLeaveFields()) return;
    } else if (selectedLeaveType?.id === 'od') {
      if (!validateODLeaveFields()) return;
    } else if (selectedLeaveType?.id === 'co') {
      if (!validateCOLeaveFields()) return;
    }
    if (!validateCommonFields()) return;

    if (selectedLeaveType?.id === 'regular-leave') {
      submitRegularLeave();
    } else if (selectedLeaveType?.id === 'short-leave') {
      submitShortLeave();
    } else if (selectedLeaveType?.id === 'od') {
      submitODLeave();
    } else if (selectedLeaveType?.id === 'co') {
      submitCOLeave();
    } else {
      Alert.alert('Error!', 'Invalid leave type selected.', [{ text: 'Dismiss', style: 'cancel' }]);
    }
  }, [
    submitRegularLeave,
    submitShortLeave,
    submitODLeave,
    submitCOLeave,
    validateRegularLeaveFields,
    validateShortLeaveFields,
    validateODLeaveFields,
    validateCOLeaveFields,
    validateCommonFields,
  ]);

  return {
    submit,
    isLoading:
      regularLeaveMutation.isPending || shortLeaveMutation.isPending || odLeaveMutation.isPending,
  };
};
