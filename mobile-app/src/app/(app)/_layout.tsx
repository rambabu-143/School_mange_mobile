import { Redirect, Stack, usePathname } from 'expo-router';

import { useSessionStore } from '@/lib/session-store';

// Mirrors the per-role tile/drawer lists in index.tsx — a deep link or stale route must not reach
// another role's screens. Shared screens (notices, messages, settings, ...) are intentionally absent.
const STAFF_ONLY = new Set([
  'mark-attendance', 'attendance-summary', 'term-attendance', 'assign-homework', 'assigned-homework',
  'class-list', 'house-list', 'email-group',
]);
const STUDENT_PARENT_ONLY = new Set([
  'my-attendance', 'calendar', 'homework', 'holiday-homework', 'assignments', 'assignment-list',
  'syllabus', 'assessment', 'self-awareness', 'stream-selection', 'id-card', 'my-teacher',
  'parent-details', 'sibling', 'health',
]);
const PARENT_ONLY = new Set(['pay-bill', 'transport-renewal', 'transport', 'child-list']);

export default function AppLayout() {
  const session = useSessionStore((s) => s.session);
  const route = usePathname().split('/').filter(Boolean)[0] ?? '';

  const denied =
    (!session?.isStaff && STAFF_ONLY.has(route)) ||
    (session?.isStaff && (STUDENT_PARENT_ONLY.has(route) || PARENT_ONLY.has(route))) ||
    (!session?.isParent && PARENT_ONLY.has(route));
  if (denied) return <Redirect href="/" />;

  return (
    <Stack screenOptions={{ headerBackButtonDisplayMode: 'minimal' }}>
      <Stack.Screen name="index" options={{ headerShown: false }} />
      <Stack.Screen name="attendance" options={{ title: 'My Attendance' }} />
      <Stack.Screen name="notices" options={{ title: 'Notices' }} />
      <Stack.Screen name="messages" options={{ title: 'Messages' }} />
      <Stack.Screen name="notifications" options={{ title: 'Notifications' }} />
      <Stack.Screen name="gallery" options={{ title: 'Gallery' }} />
      <Stack.Screen name="pay-bill" options={{ title: 'Pay Bill' }} />
      <Stack.Screen name="social-media-consent" options={{ title: 'Social Media Consent' }} />
      <Stack.Screen name="my-attendance" options={{ title: 'My Attendance' }} />
      <Stack.Screen name="calendar" options={{ title: 'School Calendar' }} />
      <Stack.Screen name="homework" options={{ title: 'Homework' }} />
      <Stack.Screen name="holiday-homework" options={{ title: 'Holiday Homework' }} />
      <Stack.Screen name="assignments" options={{ title: 'Assignments' }} />
      <Stack.Screen name="assignment-list" options={{ title: 'Assignments' }} />
      <Stack.Screen name="syllabus" options={{ title: 'Syllabus' }} />
      <Stack.Screen name="assessment" options={{ title: 'Assessment Record' }} />
      <Stack.Screen name="self-awareness" options={{ title: 'Self Awareness' }} />
      <Stack.Screen name="stream-selection" options={{ title: 'Stream Selection' }} />
      <Stack.Screen name="id-card" options={{ title: 'ID Card' }} />
      <Stack.Screen name="my-teacher" options={{ title: 'My Teachers' }} />
      <Stack.Screen name="parent-details" options={{ title: 'Parent Details' }} />
      <Stack.Screen name="sibling" options={{ title: 'Siblings' }} />
      <Stack.Screen name="health" options={{ title: 'Health' }} />
      <Stack.Screen name="profile" options={{ title: 'Profile' }} />
      <Stack.Screen name="disciplinary" options={{ title: 'Disciplinary' }} />
      <Stack.Screen name="timetable" options={{ title: 'Timetable' }} />
      <Stack.Screen name="settings" options={{ title: 'Settings' }} />
      <Stack.Screen name="child-list" options={{ title: 'My Children' }} />
      <Stack.Screen name="transport" options={{ title: 'Transport' }} />
      <Stack.Screen name="transport-renewal" options={{ title: 'Transport Renewal' }} />
      <Stack.Screen name="mark-attendance" options={{ title: 'Mark Attendance' }} />
      <Stack.Screen name="attendance-summary" options={{ title: 'Attendance Summary' }} />
      <Stack.Screen name="term-attendance" options={{ title: 'Term Attendance' }} />
      <Stack.Screen name="assign-homework" options={{ title: 'Assign Homework' }} />
      <Stack.Screen name="assigned-homework" options={{ title: 'Assigned Homework' }} />
      <Stack.Screen name="class-list" options={{ title: 'Class List' }} />
      <Stack.Screen name="house-list" options={{ title: 'House List' }} />
      <Stack.Screen name="email-group" options={{ title: 'Email Group' }} />
      <Stack.Screen name="news-letter" options={{ title: 'Newsletter' }} />
      <Stack.Screen name="chronicles" options={{ title: 'Chronicles' }} />
      <Stack.Screen name="privacy-policy" options={{ title: 'Privacy Policy' }} />
      <Stack.Screen name="wise" options={{ title: 'Feedback' }} />
    </Stack>
  );
}
