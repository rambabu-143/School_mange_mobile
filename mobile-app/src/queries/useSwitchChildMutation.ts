import { useMutation, useQueryClient } from '@tanstack/react-query';

import { buildSessionFromLogin, switchStudent } from '@/api/auth';
import { useSessionStore } from '@/lib/session-store';

/** Native: DashboardActivity's child-switch dialog → POST user/switch-student, then restarts the dashboard. */
export const useSwitchChildMutation = () => {
  const session = useSessionStore((s) => s.session);
  const setSession = useSessionStore((s) => s.setSession);
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (child: { admissionNo: string; email?: string | null }) => {
      if (!session?.token) throw new Error('Not signed in');
      if (!child.email) throw new Error('Missing student email for switch-student request');

      const res = await switchStudent(session.token, child.email, child.admissionNo);
      return buildSessionFromLogin(res, { isParent: true, targetAdmissionNo: child.admissionNo });
    },
    onSuccess: async (nextSession) => {
      await setSession(nextSession);
      await queryClient.invalidateQueries();
    },
  });
};
