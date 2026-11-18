import { useQuery } from '@tanstack/react-query';

import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

export type WiseCardKey = 'worthy' | 'intellect' | 'stature' | 'emotion';
export type WiseCardEntry = { id: string; reason?: string | null; date?: string | null; staffName?: string | null };
export type WiseCards = Record<WiseCardKey, { count: number; entries: WiseCardEntry[] }>;

type ApiEntry = { _id?: string | null; reason?: string | null; wise_date?: string | null; staff_id?: { name?: string | null } | null };
type ApiCategory = { count?: number | null; data?: (ApiEntry | null)[] | null };

const KEYS: WiseCardKey[] = ['worthy', 'intellect', 'stature', 'emotion'];

/** Native: GET wise/student-wise/{admission_no} (WiseFragment, student/parent) — WISE cards the student has received. */
export const useWiseCardsQuery = () => {
  const { token, admissionNo } = useSessionStore((s) => s.session) ?? {};

  return useQuery({
    enabled: !!token && !!admissionNo,
    queryKey: ['wise-cards', admissionNo],
    queryFn: async (): Promise<WiseCards> => {
      const result = await apiClient.getEnvelope<Record<WiseCardKey, ApiCategory | null>>(`wise/student-wise/${admissionNo}`, token);
      return Object.fromEntries(
        KEYS.map((k) => {
          const cat = result.data?.[k];
          return [
            k,
            {
              count: cat?.count ?? 0,
              entries: (cat?.data ?? []).filter((e): e is ApiEntry => !!e).map((e, i) => ({
                id: e._id ?? String(i),
                reason: e.reason,
                date: e.wise_date,
                staffName: e.staff_id?.name,
              })),
            },
          ];
        })
      ) as WiseCards;
    },
  });
};
