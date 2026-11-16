import { LeaveType } from '@/types/new-staff-application-store.types';

export const leaveTypes: LeaveType[] = [
  { id: 'regular-leave' as const, label: 'Leave' },
  { id: 'short-leave' as const, label: 'Short' },
  { id: 'co' as const, label: 'CO' },
  { id: 'od' as const, label: 'OD' },
];
