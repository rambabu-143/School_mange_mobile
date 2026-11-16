import * as React from 'react';

import { NewLeave } from './NewLeave/NewLeave';
import { NewShortLeave } from './NewShortLeave/NewShortLeave';
import { NewCOLeave } from './NewCOLeave/NewCOLeave';
import { NewODLeave } from './NewODLeave/NewODLeave';
import { useNewStaffApplicationStore } from '@/stores/new-staff-application-store';

const _LeaveScreens: React.FC = () => {
  const selectedLeaveType = useNewStaffApplicationStore((state) => state.selectedLeaveType);

  if (selectedLeaveType.id === 'regular-leave') return <NewLeave />;
  if (selectedLeaveType.id === 'short-leave') return <NewShortLeave />;
  if (selectedLeaveType.id === 'co') return <NewCOLeave />;
  if (selectedLeaveType.id === 'od') return <NewODLeave />;

  return null;
};

export const LeaveScreens = React.memo(_LeaveScreens);
