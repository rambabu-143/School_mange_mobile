import * as React from "react";

import { NewLeave } from "./NewLeave/NewLeave";
import { NewShortLeave } from "./NewShortLeave/NewShortLeave";
import { ModalUtilityProps } from "./types";
import { useNewStaffApplicationStore } from "../../../stores/new-staff-application-store";
import { NewCOLeave } from "./NewCOLeave/NewCOLeave";
import { NewODLeave } from "./NewODLeave/NewODLeave";

export type LeaveScreensProps = {} & ModalUtilityProps;

const _LeaveScreens: React.FC<LeaveScreensProps> = ({ params }) => {
  const selectedLeaveType = useNewStaffApplicationStore(state => state.selectedLeaveType);

  if (selectedLeaveType.id === 'regular-leave') {
    return <NewLeave params={params} />;
  }

  if (selectedLeaveType.id === 'short-leave') {
    return <NewShortLeave params={params} />;
  }

  if (selectedLeaveType.id === 'co') {
    return <NewCOLeave params={params} />;
  }

  if (selectedLeaveType.id === 'od') {
    return <NewODLeave params={params} />;
  }

  return null;
};

export const LeaveScreens = React.memo(_LeaveScreens);
