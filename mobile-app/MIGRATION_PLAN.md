# MountCarmel → Expo migration plan

Standalone rewrite. Native iOS/Android apps stay live until this reaches parity; retire them once it does. Reference: Android Kotlin source (`android/app/src/main/java/com/mountcarmelschools/`) — iOS Swift is functionally identical, Kotlin was just easier to read for API shapes.

## Backend contract (as it actually is today)

- **Base URL**: native hardcodes it in `di/networking/RetrofitClient.kt` — `https://mountcarmelschool.com:4201/` (hand-swapped for prod builds). The Expo app reads `EXPO_PUBLIC_API_URL` (see `.env.example`), then `expo.extra.apiUrl`, then falls back to `https://mountcarmelschool.com:4201` (`src/lib/api-client.ts`). Still open: per-profile values in `eas.json` so preview/production builds can't silently use the wrong server.
- **One API surface**: contrary to the community names in the graph report (`StaffManagementAPI`, `WiseManagementAPI`, etc. — those are just response-model *package* names, not separate network interfaces), there is a single `ApiService.kt` with ~90 endpoints, mixed `Call<T>` (old, callback) and `suspend fun ... Response<T>` (new, coroutine) styles.
- **Auth**: no auto-injecting interceptor. Every call takes `@Header("Authorization") authorization: String?` manually, populated as `"Bearer " + token`. Token lives in `SharedPreferences("MyPreferences")` key `auth_token`, alongside `userId`, `standardId`, `standardSectionId`, `studentId`, `usertype`, `isParent`, `isStaff`, `staff_userId`, `current_branch`, `year_session`, `is_logged_in`, `screen_lock_enabled`.
- **Response envelope**: consistent `{status, message, data...}` per-endpoint (no generic wrapper type — each response is its own Moshi class), snake_case field names.

The old brownfield RN code (now in `legacy-brownfield-reference/`) independently confirms this: plain `fetch()`, `Authorization: Bearer <token>`, same `{status, message, data}` shape. It just repeated the base URL + header boilerplate in every query file — centralize that this time into one client.

## Foundation — build before porting any screen (P0)

The old brownfield screens never needed a login flow: the *native* shell always handled auth and handed RN a ready token via launch params. A standalone app has no native shell to do that anymore, so these are blocking, not optional:

- [x] **API client**: `src/lib/api-client.ts` — base URL + bearer header + envelope unwrap (`status`→throw on false, return `data`) + typed error. Replaces the copy-pasted fetch-per-query pattern in the legacy reference code. Also has `getEnvelope`/`postEnvelopeRaw` for the endpoints that need sibling fields (e.g. `path`) or non-standard status handling (regular-leave's confirmation dialog).
- [x] **Auth**: `src/api/auth.ts` + `src/app/sign-in.tsx` — staff/student **Google sign-in** (`user/googlelogin`, `src/lib/google-signin.ts`) and parent mobile→OTP (`user/generate-otp`, `user/parent-login`). Email/password login and the dev-bypass accounts were removed. Real Google sign-in on a debug build needs the debug SHA-1 registered in Firebase.
- [x] **Session storage**: `src/lib/session-store.ts` — Zustand + `expo-secure-store`, mirrors `SharedPreferenceUtils` (token, staffId, isStaff/isParent).
- [x] **Role-aware navigation shell**: `src/app/_layout.tsx` (`Stack.Protected` gate) → `(app)/_layout.tsx` (`Stack` wrapping `(tabs)`) → `(app)/(tabs)/_layout.tsx` (native tabs). Not yet role-differentiated (student/parent/staff all see the same tabs) — extend when P2 screens need it.
- [x] **Push notifications**: device token registration on dashboard load (`src/lib/use-push-token-registration.ts`).
- [x] **Parent multi-child switch + staff branch switch**: session-level state, multi-child switch in `child-list.tsx` + branch switch in `settings.tsx`.

## Already built & rewired to the new foundation (P1)

| Screen | Native equivalent | Status |
|---|---|---|
| StaffAttendance | *(none — net-new)* | **Done** — `src/app/(app)/attendance.tsx`. |
| PayBill | `ui/payment/FeePayment.kt` (WebView) | **Done** — `src/app/(app)/pay-bill.tsx`. Quarter selection + total calculation + `expo-web-browser` payment checkout bridge with auto-refresh. |
| SocialMediaConsentForm | *(none — net-new)* | **Done** — `src/app/(app)/social-media-consent.tsx`. Policy scroll gate + cross-platform parent name modal + `POST student/social-media-consent`. |
| TeacherEvaluationProgramme (rating) | `ui/wise/WiseFragment.kt` | **Done** — `src/app/(app)/wise.tsx`. WISE evaluation rating survey + staff card issuance with QR scanner. |

## Screen backlog (All Phases Complete)

**P2 — core daily-use, all user types**
- [x] Notices — `src/app/(app)/notices.tsx` + `src/queries/useNoticesQuery.ts`.
- [x] Messages — `src/app/(app)/messages.tsx` + `src/queries/useMessagesQuery.ts`.
- [x] Notifications — `src/app/(app)/notifications.tsx` + `src/queries/useNotificationsQuery.ts`.
- [x] Gallery — `src/app/(app)/gallery.tsx` + `src/queries/useGalleryQuery.ts`.
- [x] **Post-login profile-detail fetch** — `src/queries/useProfileDetailQuery.ts`.
- [x] Home dashboard tiles (`src/app/(app)/index.tsx`), Profile sub-screens (`profile.tsx`, `parent-details.tsx`, `sibling.tsx`, `health.tsx`), School calendar (`calendar.tsx`).

**P3 — staff workflows**
- [x] Mark attendance (`mark-attendance.tsx`), Attendance summary (`attendance-summary.tsx`), Term attendance (`term-attendance.tsx`), Assign homework (`assign-homework.tsx`), Assigned-homework list (`assigned-homework.tsx`), Disciplinary staff-issued (`disciplinary.tsx`), House list (`house-list.tsx`), Class list (`class-list.tsx`), WISE staff issuing (`wise.tsx`).

**P4 — student self-service**
- [x] Assignments (`assignments.tsx`, `assignment-list.tsx`), Homework (`homework.tsx`), Holiday homework (`holiday-homework.tsx`), Self-awareness questionnaire (`self-awareness.tsx`), Stream selection (`stream-selection.tsx`), Disciplinary student view (`disciplinary.tsx`), ID card (`id-card.tsx`), Timetable (`timetable.tsx`), My Teacher (`my-teacher.tsx`), Assessment record / date sheet (`assessment.tsx`, `syllabus.tsx`).

**P5 — parent-specific**
- [x] Transport renewal (`transport-renewal.tsx`, `transport.tsx`), Child list/switch (`child-list.tsx`), Fee bill view & pay (`pay-bill.tsx`).

**P6 — long tail**
- [x] Settings (`settings.tsx`), Screen lock (`lock-screen.tsx`, `screen-lock-store.ts`), generic links via `Linking.openURL`, QR scanner (`qr-scanner-modal.tsx`).

## P6 long-tail — resolved

- **Generic WebView screen / standalone PDF viewer**: never built as dedicated routes. Every actual
  call site (notices/messages/assignment/homework/holiday-homework attachments, email-group,
  stream-selection eligibility PDF, privacy policy) already opens its URL with `Linking.openURL`
  directly — validated independently 6+ times across the app. Adding `react-native-webview` or
  `react-native-pdf` now would just reintroduce the dev-client dependency this pattern was chosen
  to avoid, for a capability nothing actually needs. Not building these was the correct call, not a
  gap.
- **QR/barcode scanner**: built as `src/components/qr-scanner-modal.tsx` using `expo-camera`'s
  `CameraView` (Expo SDK-managed, Expo Go compatible, no dev-client build needed — unlike the
  Razorpay/PDF/zeego Tier-2 screens). Wired into:
  - Disciplinary staff-issuing (`disciplinary.tsx`'s `StaffDisciplinaryScreen`) — scan → resolve
    student via `POST student/detail/search` → pick card color/reason/action-taken/house-points →
    `POST disciplinary`. Native's "By Class" browse-roster entry mode wasn't ported (QR is the flow
    the scanner exists to serve); add it the same way `wise.tsx`'s `StaffWiseScreen` already does
    if needed.
  - WISE staff issuing (`wise.tsx`'s `StaffWiseScreen`) — added a "Scan QR" button next to the
    existing "By Class" picker; both paths funnel into the same `IssueCardModal`/pending-batch/
    publish flow, so QR is a second way to reach the existing form, not a separate implementation.
- **Screen lock**: built with `expo-local-authentication` (Expo SDK-managed, Expo Go compatible).
  `src/lib/screen-lock-store.ts` (zustand + secure-store, mirrors `session-store.ts`) holds the
  `screen_lock_enabled` flag; `settings.tsx` toggle requires a successful biometric check before
  enabling (mirrors `FaceIDEnableViewController`'s "can't lock yourself out" guard);
  `src/components/lock-screen.tsx` + an `AppState` listener in root `_layout.tsx` re-prompt on every
  background→foreground transition (mirrors `FaceIDViewController`'s `viewDidAppear` re-prompt), with
  a logout escape hatch if biometrics fail.

## Feedback round 1 (Shivani's staff + parent/student docs) — status

Branch `fix/feedback-round-1` (local + GitHub clean copy; **not on GitLab**). All items fixed in code; UI verified on an Android emulator against a fake backend (not real data). Highlights: term attendance route (`/false` 4th segment, fallback), Chronicles/Newsletter top-level fields, photo `path`, messages popup, absence popup YES/NO, drawer/profile header and photo, fee checkbox, WISE 80-char limit and parent WISE cards, homework/assigned-homework date bounds, ID card DOB format, staff disciplinary card colours, Transport Renewal payload matched to native (`sibling_id`, `standard_section_id`), Pay Now outcome toast.

**Not verifiable without real accounts/backend:** Pay Now end to end (does the portal page need login?), real response shapes for term attendance / Chronicles / Newsletter, student login, push delivery, real Google sign-in.

## Remaining before release

- [ ] Per-profile `EXPO_PUBLIC_API_URL` in `eas.json` (development / preview / production).
- [ ] Register debug + release SHA-1/SHA-256 in Firebase; confirm iOS `GoogleService-Info.plist` matches `com.app.MountCarmel`.
- [ ] Test with one real staff, parent and student account on a device.
- [ ] Push `fix/feedback-round-1` to GitLab and open the MR.
- [ ] Rotate keys if the tracked `.env` / Firebase files in git history are real; keep them out of future commits.
- [ ] EAS preview build → internal testing → production build and store submission.
- [ ] Retire the native Android/iOS apps once the Expo build is live and verified.
- [ ] Decide whether to add a test framework (none today).

## Open questions before building the backlog out further

- `AssignmentFragment` vs `assignementUpdated/AssignmentUpdatedFragment` look like two generations of the same feature (old date-sheet/syllabus API vs newer subject+date-range API). Confirm which is actually live in the native nav before porting — don't migrate both.
- Confirm the prod base-URL swap process (currently: hand-edit a comment-flagged constant) so the Expo app doesn't inherit the same footgun.
