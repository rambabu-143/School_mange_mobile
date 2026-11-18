import dayjs from 'dayjs';
import { BlurView } from 'expo-blur';
import { router } from 'expo-router';
import * as React from 'react';
import { Image, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';

import { AnimatedPressable } from '@/components/animated-pressable';
import { AppDrawer } from '@/components/app-drawer';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { MaxContentWidth, Spacing } from '@/constants/theme';
import { useEffectiveColorScheme, useTheme } from '@/hooks/use-theme';
import { useSessionStore } from '@/lib/session-store';
import { usePushTokenRegistration } from '@/lib/use-push-token-registration';
import { useProfileDetailQuery } from '@/queries/useProfileDetailQuery';

type Tile = {
  label: string;
  route: string;
  icon?: number;
  emoji?: string;
  disabled?: boolean;
  /** Fixed (non-theme) circle background — for icon assets that are plain white and would
   * otherwise vanish against the light-mode grey circle. */
  tint?: string;
};

const ICONS = {
  notices: require('@/assets/images/dashboard/ic_staff_notice.png'),
  gallery: require('@/assets/images/dashboard/ic_3rd_gallery.png'),
  calendar: require('@/assets/images/dashboard/ic_3rd_school_calendar.png'),
  profile: require('@/assets/images/dashboard/ic_bottom_profile.png'),
  profileStaff: require('@/assets/images/dashboard/ic_bottom_profile_staff.png'),
  attendance: require('@/assets/images/dashboard/ic_staff_mark_attendance.png'),
  attendanceSummary: require('@/assets/images/dashboard/ic_staff_attendance_summary.png'),
  termAttendance: require('@/assets/images/dashboard/ic_staff_attendance_day.png'),
  timeTableStaff: require('@/assets/images/dashboard/ic_staff_time_table.png'),
  classList: require('@/assets/images/dashboard/icon_staff_class_list.png'),
  houseList: require('@/assets/images/dashboard/icon_staff_house_list.png'),
  disciplinary: require('@/assets/images/dashboard/discipline_student.png'),
  wise: require('@/assets/images/dashboard/wise.png'),
  settings: require('@/assets/images/dashboard/ic_3rd_setting.png'),
  assignments: require('@/assets/images/dashboard/ic_3rd_assignments.png'),
  holidayHomework: require('@/assets/images/dashboard/ic_3rd_holiday_homework.png'),
  dateSheet: require('@/assets/images/dashboard/ic_3rd_date_sheet.png'),
  idCard: require('@/assets/images/dashboard/id_card.jpeg'),
  selfAwareness: require('@/assets/images/dashboard/self_awareness.png'),
  streamSelection: require('@/assets/images/dashboard/streamselection.png'),
  fee: require('@/assets/images/dashboard/fee.png'),
  transport: require('@/assets/images/dashboard/bus.png'),
};

// ponytail: containStandard/isTenthStandard mirror MountCarmelUtils.kt exactly (grade-gating for
// Self Awareness / Stream Selection drawer tiles). The extra native showSelfAwareness/
// showStreamSelection/showTransportRenewal/showIdCard dashboard flags are NOT replicated — those
// tiles show whenever the grade gate passes, unconditionally. Add the flag fetch if product needs it.
const SELF_AWARENESS_STANDARDS = ['IV', 'V', 'VI', 'VII', 'VIII'];
const isTenthStandard = (standard?: string | null) => (standard ?? '').toUpperCase() === 'X';
const isSelfAwarenessStandard = (standard?: string | null) =>
  SELF_AWARENESS_STANDARDS.includes((standard ?? '').toUpperCase());

/** Native: HomeFragment's rv_top_category (HomeTopAdapter) — 4-item horizontal quick row. */
function quickTilesFor(isStaff: boolean): Tile[] {
  if (isStaff) {
    return [
      { label: 'Class List', route: '/class-list', icon: ICONS.classList, tint: '#3c87f7' },
      { label: 'House List', route: '/house-list', icon: ICONS.houseList, tint: '#f59e0b' },
      { label: 'Notice', route: '/notices', icon: ICONS.notices },
      { label: 'Messages', route: '/messages', emoji: '💬' },
    ];
  }
  return [
    { label: 'AR', route: '/assignments', icon: ICONS.assignments },
    { label: 'Gallery', route: '/gallery', icon: ICONS.gallery },
    { label: 'Notice', route: '/notices', icon: ICONS.notices },
    { label: 'Messages', route: '/messages', emoji: '💬' },
  ];
}

/** Native: HomeFragment's fixed 2x3 grid (attendanceLayout/wiseLayout/homeworkLayout), role-relabeled. */
function gridFor(isStaff: boolean, isParent: boolean): Tile[][] {
  const row1: Tile[] = isStaff
    ? [
        // Native's staff "Mark Attendance" tile opens AttendanceFragment's staff branch
        // (class/section + date + Go), which mark-attendance.tsx already fuses with the actual
        // roster screen (MarkAttendanceFragment) into one flow.
        { label: 'Mark Attendance', route: '/mark-attendance', icon: ICONS.attendance },
        { label: 'Attendance Summary', route: '/attendance-summary', icon: ICONS.attendanceSummary },
      ]
    : [
        { label: 'Attendance', route: '/my-attendance', icon: ICONS.attendance },
        { label: 'School Calendar', route: '/calendar', icon: ICONS.calendar },
      ];
  const row2: Tile[] = [
    { label: 'Disciplinary', route: '/disciplinary', icon: ICONS.disciplinary },
    // Student/parent WISE = cards received; teacher feedback survey stays reachable via My Teachers.
    { label: 'WISE', route: isStaff ? '/wise' : '/wise-cards', icon: ICONS.wise },
  ];
  const row3: Tile[] = [
    // Native: cl_assign_homework is View.GONE for everyone except staff.
    ...(isStaff ? [{ label: 'Assign Homework', route: '/assign-homework', emoji: '📝' }] : []),
    isStaff
      ? { label: 'View Assigned Homework', route: '/assigned-homework', emoji: '📄' }
      : { label: 'Homework', route: '/homework', emoji: '📚' },
  ];
  return [row1, row2, row3];
}

/** Native: MountCarmelUtils.getDrawerIconsAndLabel — one flat list per role, exact order/labels. */
function drawerItemsFor(isStaff: boolean, isParent: boolean, standardName?: string | null): Tile[] {
  if (isStaff) {
    return [
      // Native: this drawer item is dead code (DashboardActivity.itemClick's staff_attendance
      // case is an empty {} block) — routed to the working Mark Attendance flow instead of
      // leaving it a no-op.
      { label: 'My Attendance', route: '/attendance', icon: ICONS.attendance },
      // Native: this drawer item is ALSO dead code (time_table case is empty {}) — TimeTableFragment
      // is unreachable anywhere in the live native app. Routed to our built Timetable screen anyway
      // rather than leaving a dead drawer entry.
      { label: 'Time Table', route: '/timetable', icon: ICONS.timeTableStaff },
      { label: 'Email Group', route: '/email-group', emoji: '📧' },
      { label: 'Term Attendance', route: '/term-attendance', icon: ICONS.termAttendance },
      { label: 'Chronicles', route: '/chronicles', emoji: '📰' },
      { label: 'NewsLetter', route: '/news-letter', emoji: '📰' },
      { label: 'Privacy Policy', route: '/privacy-policy', emoji: '📃' },
      { label: 'Settings', route: '/settings', icon: ICONS.settings },
    ];
  }

  return [
    { label: 'Assignments', route: '/assignment-list', icon: ICONS.assignments },
    { label: 'Syllabus', route: '/syllabus', icon: ICONS.assignments },
    { label: 'Date Sheet', route: '/assessment', icon: ICONS.dateSheet },
    { label: 'Holiday Homework', route: '/holiday-homework', icon: ICONS.holidayHomework },
    ...(isSelfAwarenessStandard(standardName)
      ? [{ label: 'Self Awareness', route: '/self-awareness', icon: ICONS.selfAwareness }]
      : []),
    ...(isTenthStandard(standardName)
      ? [{ label: 'Stream Selection', route: '/stream-selection', icon: ICONS.streamSelection }]
      : []),
    ...(isParent
      ? ([
          { label: 'Fee', route: '/pay-bill', icon: ICONS.fee },
          { label: 'Transport Renewal', route: '/transport-renewal', icon: ICONS.transport },
        ] as Tile[])
      : []),
    { label: 'Chronicles', route: '/chronicles', emoji: '📰' },
    { label: 'NewsLetter', route: '/news-letter', emoji: '📰' },
    { label: 'Privacy Policy', route: '/privacy-policy', emoji: '📃' },
    { label: 'ID Card', route: '/id-card', icon: ICONS.idCard },
    { label: 'Settings', route: '/settings', icon: ICONS.settings },
  ];
}

function TileIcon({ tile }: { tile: Tile }) {
  if (tile.icon) return <Image source={tile.icon} style={styles.tileIcon} resizeMode="contain" />;
  return <Text style={styles.tileEmoji}>{tile.emoji ?? '•'}</Text>;
}

const FLOATING_BAR_HEIGHT = 68;
const FLOATING_BAR_MARGIN = Spacing.three;

export default function HomeScreen() {
  const { session, clearSession } = useSessionStore();
  const profileDetailQuery = useProfileDetailQuery();
  const [drawerOpen, setDrawerOpen] = React.useState(false);
  const theme = useTheme();
  const colorScheme = useEffectiveColorScheme();
  const insets = useSafeAreaInsets();
  usePushTokenRegistration();

  const isStaff = !!session?.isStaff;
  const isParent = !!session?.isParent;
  const quickTiles = quickTilesFor(isStaff);
  const grid = gridFor(isStaff, isParent);
  const profile = profileDetailQuery.data;
  const drawerPhoto = profile?.profilePic && profile?.path ? `${profile.path}/${profile.profilePic}` : null;
  const drawerItems = drawerItemsFor(isStaff, isParent, session?.standardName);

  const navigate = (tile: Tile) => {
    if (tile.disabled) return;
    setDrawerOpen(false);
    router.push(tile.route as never);
  };

  const getGreeting = () => {
    const hour = new Date().getHours();
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  };

  // Native: bottom-bar left icon is "My Teachers" -> MyTeacherFragment for everyone except staff,
  // where the same slot relabels to "Fee" -> FeeFragment (HomeViewModel.onTeacher).
  const bottomLeftTile: Tile = isStaff
    ? { label: 'Fee', route: '/pay-bill', icon: ICONS.fee }
    : { label: 'My Teachers', route: '/my-teacher', emoji: '🧑‍🏫' };

  return (
    <ThemedView style={styles.container}>
      <SafeAreaView style={styles.safeArea} edges={['top', 'left', 'right']}>
        <ThemedView style={styles.header}>
          <Pressable hitSlop={12} onPress={() => setDrawerOpen(true)}>
            <ThemedText style={styles.hamburger}>☰</ThemedText>
          </Pressable>
          <ThemedText type="smallBold">Mount Carmel</ThemedText>
          <ThemedView style={{ width: 24 }} />
        </ThemedView>

        <ScrollView style={styles.scroll} contentContainerStyle={[styles.scrollContent, { paddingBottom: Spacing.four * 2 }]}>
          <ThemedView type="backgroundElement" style={styles.card}>
            <ThemedText type="smallBold">{session?.name || 'Unknown user'}</ThemedText>
            <ThemedText type="small" themeColor="textSecondary">
              {getGreeting()}
            </ThemedText>
            {profileDetailQuery.data && (
              <ThemedText type="small" themeColor="textSecondary">
                {isStaff
                  ? `${profileDetailQuery.data.employeeCode ?? '—'} · ${profileDetailQuery.data.departmentName ?? '—'}`
                  : `Admission ${profileDetailQuery.data.admissionNo ?? '—'} · since ${profileDetailQuery.data.dateOfAdmission ? dayjs(profileDetailQuery.data.dateOfAdmission).format('DD-MM-YYYY') : '—'}`}
              </ThemedText>
            )}
          </ThemedView>

          <ThemedView style={styles.quickRow}>
            {quickTiles.map((tile) => (
              <AnimatedPressable key={tile.route + tile.label} style={styles.quickTile} onPress={() => navigate(tile)}>
                <ThemedView
                  type="backgroundElement"
                  style={[styles.quickIconWrap, tile.tint ? { backgroundColor: tile.tint } : null]}>
                  <TileIcon tile={tile} />
                </ThemedView>
                <ThemedText type="small" style={styles.quickLabel}>
                  {tile.label}
                </ThemedText>
              </AnimatedPressable>
            ))}
          </ThemedView>

          {grid.map((row, i) => (
            <View key={i} style={styles.gridRow}>
              {row.map((tile) => (
                <AnimatedPressable
                  key={tile.route + tile.label}
                  disabled={tile.disabled}
                  style={[
                    styles.gridTile,
                    { backgroundColor: theme.backgroundElement },
                    tile.disabled && styles.gridTileDisabled,
                  ]}
                  onPress={() => navigate(tile)}>
                  <TileIcon tile={tile} />
                  <ThemedText type="small" style={styles.gridLabel}>
                    {tile.label}
                  </ThemedText>
                </AnimatedPressable>
              ))}
            </View>
          ))}
        </ScrollView>

        {/* Docked (not floating-over-content) — an absolutely positioned bar always captures
            taps across its full rectangle, which made the cards behind it unreachable. Sitting
            in normal layout flow guarantees the ScrollView above it never scrolls under it. */}
        <BlurView
          intensity={65}
          tint={colorScheme === 'dark' ? 'dark' : 'light'}
          style={[
            styles.bottomBar,
            {
              marginHorizontal: FLOATING_BAR_MARGIN,
              marginTop: FLOATING_BAR_MARGIN,
              marginBottom: insets.bottom + FLOATING_BAR_MARGIN,
              borderColor: colorScheme === 'dark' ? 'rgba(255,255,255,0.14)' : 'rgba(255,255,255,0.55)',
            },
          ]}>
          <View
            style={[
              StyleSheet.absoluteFill,
              { backgroundColor: colorScheme === 'dark' ? 'rgba(18,26,22,0.4)' : 'rgba(255,255,255,0.42)' },
            ]}
          />
          <View style={styles.bottomBarContent}>
            <AnimatedPressable style={styles.bottomTile} onPress={() => navigate(bottomLeftTile)}>
              <View style={[styles.bottomIconWrap, { backgroundColor: theme.text + '14' }]}>
                <TileIcon tile={bottomLeftTile} />
              </View>
              <ThemedText type="small" style={styles.bottomLabel}>
                {bottomLeftTile.label}
              </ThemedText>
            </AnimatedPressable>
            <AnimatedPressable
              style={styles.bottomTile}
              onPress={() => navigate({ label: 'Profile', route: '/profile', icon: isStaff ? ICONS.profileStaff : ICONS.profile })}>
              <View style={[styles.bottomIconWrap, { backgroundColor: theme.text + '14' }]}>
                <Image
                  source={drawerPhoto ? { uri: drawerPhoto } : isStaff ? ICONS.profileStaff : ICONS.profile}
                  style={drawerPhoto ? styles.bottomAvatar : styles.tileIcon}
                  resizeMode={drawerPhoto ? 'cover' : 'contain'}
                />
              </View>
              <ThemedText type="small" style={styles.bottomLabel}>
                Profile
              </ThemedText>
            </AnimatedPressable>
            <AnimatedPressable style={styles.bottomTile} onPress={() => clearSession()}>
              <View style={[styles.bottomIconWrap, { backgroundColor: theme.text + '14' }]}>
                <Text style={styles.tileEmoji}>🚪</Text>
              </View>
              <ThemedText type="small" style={styles.bottomLabel}>
                Logout
              </ThemedText>
            </AnimatedPressable>
          </View>
        </BlurView>
      </SafeAreaView>

      <AppDrawer visible={drawerOpen} onClose={() => setDrawerOpen(false)}>
        <SafeAreaView style={{ flex: 1 }} edges={['top', 'left', 'bottom']}>
          <ScrollView contentContainerStyle={styles.drawerContent}>
            <View style={styles.drawerProfile}>
              {drawerPhoto ? <Image source={{ uri: drawerPhoto }} style={styles.drawerAvatar} /> : (
                <ThemedView type="backgroundElement" style={styles.drawerAvatar} />
              )}
              <View style={{ flex: 1 }}>
                <ThemedText type="smallBold">{profileDetailQuery.data?.name || session?.name || 'Unknown user'}</ThemedText>
                {profileDetailQuery.data?.mobile ? (
                  <ThemedText type="small" themeColor="textSecondary">{profileDetailQuery.data.mobile}</ThemedText>
                ) : null}
              </View>
            </View>
            <ThemedText type="subtitle" style={styles.drawerTitle}>
              Menu
            </ThemedText>
            {drawerItems.map((tile) => (
              <AnimatedPressable key={tile.route + tile.label} style={styles.drawerRow} onPress={() => navigate(tile)}>
                <ThemedView type="backgroundElement" style={styles.drawerIconWrap}>
                  <TileIcon tile={tile} />
                </ThemedView>
                <ThemedText type="default">{tile.label}</ThemedText>
              </AnimatedPressable>
            ))}
          </ScrollView>
        </SafeAreaView>
      </AppDrawer>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  safeArea: { flex: 1 },
  scroll: { flex: 1 },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: Spacing.three,
    paddingVertical: Spacing.two,
  },
  hamburger: { fontSize: 22, width: 24 },
  scrollContent: {
    paddingHorizontal: Spacing.four,
    gap: Spacing.four,
    alignSelf: 'center',
    width: '100%',
    maxWidth: MaxContentWidth,
  },
  card: {
    gap: Spacing.one,
    paddingHorizontal: Spacing.three,
    paddingVertical: Spacing.four,
    borderRadius: Spacing.four,
  },
  // Spacing.three gap made 4 tiles (4*76 + 3*gap) wider than a standard phone's content width,
  // wrapping "Messages" to its own row — Spacing.two keeps all 4 on one line.
  quickRow: { flexDirection: 'row', flexWrap: 'wrap', gap: Spacing.two },
  quickTile: { alignItems: 'center', width: 76, gap: Spacing.one },
  quickIconWrap: {
    width: 60,
    height: 60,
    borderRadius: 30,
    alignItems: 'center',
    justifyContent: 'center',
  },
  quickLabel: { textAlign: 'center' },
  gridRow: { flexDirection: 'row', gap: Spacing.three },
  gridTile: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    gap: Spacing.one,
    paddingVertical: Spacing.four,
    borderRadius: Spacing.three,
  },
  gridTileDisabled: { opacity: 0.5 },
  gridLabel: { textAlign: 'center' },
  tileIcon: { width: 32, height: 32 },
  tileEmoji: { fontSize: 22 },
  bottomBar: {
    height: FLOATING_BAR_HEIGHT,
    borderRadius: FLOATING_BAR_HEIGHT / 2,
    borderWidth: 1,
    overflow: 'hidden',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 10 },
    shadowOpacity: 0.16,
    shadowRadius: 24,
    elevation: 14,
  },
  bottomBarContent: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'center',
  },
  bottomTile: { alignItems: 'center', gap: 2 },
  bottomIconWrap: {
    width: 34,
    height: 34,
    borderRadius: 17,
    alignItems: 'center',
    justifyContent: 'center',
  },
  bottomLabel: { fontSize: 11 },
  drawerContent: { padding: Spacing.four, gap: Spacing.one },
  drawerProfile: { flexDirection: 'row', alignItems: 'center', gap: Spacing.two, marginBottom: Spacing.three },
  bottomAvatar: { width: 40, height: 40, borderRadius: 20 },
  drawerAvatar: { width: 56, height: 56, borderRadius: 28 },
  drawerTitle: { marginBottom: Spacing.two },
  drawerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: Spacing.three,
    paddingVertical: Spacing.two,
  },
  drawerIconWrap: {
    width: 40,
    height: 40,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
