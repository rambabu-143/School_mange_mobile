import { useMutation } from '@tanstack/react-query';
import dayjs from 'dayjs';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type DisciplinaryCardKey = 'pink' | 'yellow' | 'red';

export type IssueDisciplinaryCardVariables = {
  studentId: string;
  admissionNo: string;
  cardKey: DisciplinaryCardKey;
  reason: string;
  reasonOther?: string;
  actionTaken: string;
  housePoint: string;
};

/** Native: DiscplinaryCardStaffViewController's SubmitDiscipalinaryCard → POST disciplinary
 * (array body, one entry per submit here — native batches multiple when issuing "by class"). */
export const useIssueDisciplinaryCardMutation = () => {
  const token = useSessionStore((s) => s.session?.token);

  return useMutation({
    mutationFn: async (variables: IssueDisciplinaryCardVariables) => {
      const payload = {
        student_id: variables.studentId,
        admission_no: variables.admissionNo,
        pink: variables.cardKey === 'pink' ? 1 : 0,
        yellow: variables.cardKey === 'yellow' ? 1 : 0,
        red: variables.cardKey === 'red' ? 1 : 0,
        reason: variables.reason,
        ...(variables.reasonOther ? { reason_other: variables.reasonOther } : {}),
        action_taken: variables.actionTaken,
        house_point: variables.housePoint,
        issue_date: dayjs().format('DD-MM-YYYY'),
      };
      return apiClient.post<{ status?: boolean; message?: string }>('disciplinary', [payload], token);
    },
  });
};
