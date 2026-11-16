import * as React from 'react';
import dayjs from 'dayjs';

import { useNewStaffApplicationStore } from '@/stores/new-staff-application-store';

export const useValidateFields = () => {
  const validateShortLeaveFields = React.useCallback((): boolean => {
    const { shortLeaveFromTime, shortLeaveToTime, setDateTimeSelectionError } =
      useNewStaffApplicationStore.getState();

    if (dayjs(shortLeaveFromTime).isAfter(dayjs(shortLeaveToTime))) {
      setDateTimeSelectionError(`The end time must be after the start time.`);
      return false;
    }
    const timeDuration = dayjs(shortLeaveToTime).diff(dayjs(shortLeaveFromTime), 'minute');
    if (timeDuration > 60) {
      setDateTimeSelectionError(`Short leave duration cannot exceed 1 hour.`);
      return false;
    }
    if (timeDuration < 1) {
      setDateTimeSelectionError(`Short leave duration must be at least 2 minutes.`);
      return false;
    }
    setDateTimeSelectionError('');
    return true;
  }, []);

  const validateRegularLeaveFields = React.useCallback((): boolean => {
    const {
      from,
      to,
      selectedLeaveCategory,
      numberOfHalfDays,
      numberOfDaysStr,
      singleHalfDayLeaveDetails,
      setDateTimeSelectionError,
      setSingleHalfDayLeaveError,
    } = useNewStaffApplicationStore.getState();

    if (!selectedLeaveCategory?._id) {
      setDateTimeSelectionError('Please select leave type first');
      return false;
    }
    if (selectedLeaveCategory.is_half_day_applicable === 'Yes' && numberOfHalfDays === null) {
      setDateTimeSelectionError('Please select number of half days leaves');
      return false;
    }
    if (numberOfDaysStr.length <= 0) {
      setDateTimeSelectionError('Please enter number of full days leaves');
      return false;
    }
    const numOfDays = parseInt(numberOfDaysStr.trim());
    if (
      isNaN(numOfDays) ||
      (numberOfHalfDays && numberOfHalfDays > 0 && selectedLeaveCategory.is_half_day_applicable === 'Yes'
        ? numOfDays < 0
        : numOfDays <= 0)
    ) {
      setDateTimeSelectionError('Please enter valid number of days for leave');
      return false;
    }
    if (selectedLeaveCategory.leave_code?.toLowerCase?.() !== 'lwp') {
      const balance = selectedLeaveCategory.balance;
      if (!balance) {
        setDateTimeSelectionError(`${selectedLeaveCategory.leave_name} doesn't have leave balance!`);
        return false;
      }
      if (numOfDays + (numberOfHalfDays || 0) / 2 > balance) {
        setDateTimeSelectionError(
          `Leave balance exceeded. Available balance: ${selectedLeaveCategory?.balance ?? 0} day(s).`
        );
        return false;
      }
    }
    const maxInRow = selectedLeaveCategory?.max_in_row;
    if (maxInRow) {
      const maxInRowNum = parseInt(maxInRow);
      if (!isNaN(maxInRowNum) && numOfDays > maxInRowNum) {
        setDateTimeSelectionError(
          `A maximum of ${maxInRowNum} consecutive day(s) is allowed for ${selectedLeaveCategory.leave_name}.`
        );
        return false;
      }
    }
    const maxInMonth = selectedLeaveCategory?.max_in_month;
    if (maxInMonth) {
      const maxInMonthNum = parseInt(maxInMonth);
      if (!isNaN(maxInMonthNum) && numOfDays > maxInMonthNum) {
        setDateTimeSelectionError(
          `A maximum of ${maxInMonthNum} day(s) is allowed for ${selectedLeaveCategory.leave_name} per month.`
        );
        return false;
      }

      const leavesTakenInMonthNum = selectedLeaveCategory?.leaves_taken_in_month;
      if (typeof leavesTakenInMonthNum === 'number' && numOfDays > maxInMonthNum - leavesTakenInMonthNum) {
        setDateTimeSelectionError(
          `Only ${maxInMonthNum - leavesTakenInMonthNum} day(s) of ${selectedLeaveCategory.leave_name} remaining this month.`
        );
        return false;
      }
    }
    setDateTimeSelectionError('');
    if (selectedLeaveCategory.is_half_day_applicable === 'Yes' && numberOfHalfDays === 1) {
      if (singleHalfDayLeaveDetails.leaveIn === null || !singleHalfDayLeaveDetails.leaveOn) {
        setSingleHalfDayLeaveError('Please select date and in which half you want to take leave.');
        return false;
      }
      if (
        singleHalfDayLeaveDetails.leaveOn !== from &&
        singleHalfDayLeaveDetails.leaveOn !== to
      ) {
        setSingleHalfDayLeaveError(
          "Half day leave should be either `from` or `to` date. It can't be a middle date."
        );
        return false;
      }
    }
    setSingleHalfDayLeaveError('');
    return true;
  }, []);

  const validateODLeaveFields = React.useCallback((): boolean => {
    const { numberOfDaysStr, setDateTimeSelectionError } = useNewStaffApplicationStore.getState();

    if (numberOfDaysStr.length <= 0) {
      setDateTimeSelectionError('Please enter number of days leaves');
      return false;
    }
    const numOfDays = parseInt(numberOfDaysStr.trim());
    if (isNaN(numOfDays) || numOfDays <= 0) {
      setDateTimeSelectionError('Please enter valid number of days for leave');
      return false;
    }
    setDateTimeSelectionError('');
    return true;
  }, []);

  const validateCOLeaveFields = React.useCallback((): boolean => {
    const { setCoDateTimeSelectionError, coHalfDayLeavePeriod, coLeaveDayType } =
      useNewStaffApplicationStore.getState();

    if (!coLeaveDayType) {
      setCoDateTimeSelectionError('Please select whether full day or half day');
      return false;
    }
    if (coLeaveDayType === 'Half Day' && !coHalfDayLeavePeriod) {
      setCoDateTimeSelectionError('Please select whether first half or second half');
      return false;
    }
    setCoDateTimeSelectionError('');
    return true;
  }, []);

  const validateCommonFields = React.useCallback((): boolean => {
    const {
      leaveReasonText,
      setLeaveReasonError,
      isPriorApprovalTaken,
      noPriorApprovalReasonText,
      setPriorApprovalError,
    } = useNewStaffApplicationStore.getState();

    if (!leaveReasonText) {
      setLeaveReasonError('Please provide a reason for leave');
      return false;
    }
    if (isPriorApprovalTaken === null) {
      setPriorApprovalError(`Please specify whether prior approval was obtained and from whom.`);
      return false;
    }
    if (isPriorApprovalTaken === false && !noPriorApprovalReasonText) {
      setPriorApprovalError(`Please provide a reason for not obtaining prior approval.`);
      return false;
    }
    return true;
  }, []);

  return {
    validateShortLeaveFields,
    validateRegularLeaveFields,
    validateODLeaveFields,
    validateCOLeaveFields,
    validateCommonFields,
  };
};
