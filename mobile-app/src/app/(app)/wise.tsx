import { DateTimePickerEvent } from '@react-native-community/datetimepicker';
import { BlurView } from 'expo-blur';
import { Stack, useLocalSearchParams } from 'expo-router';
import * as React from 'react';
import { ActivityIndicator, Modal, ScrollView, StyleSheet, Text, TextInput, TouchableHighlight, TouchableOpacity, View } from 'react-native';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { useMutation } from '@tanstack/react-query';
import dayjs from 'dayjs';
import Toast from 'react-native-toast-message';

import RNDateTimePicker from '@/components/DateTimePicker';
import { SelectModal } from '@/components/select-modal';
import { Question } from '@/components/question';
import { QuestionRatingInput } from '@/components/question-rating-input';
import { QuestionTextInput } from '@/components/question-text-input';
import { QrScannerModal } from '@/components/qr-scanner-modal';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { surveyQuestions } from '@/constants/surveyQuestions';
import { useEffectiveColorScheme, useTheme } from '@/hooks/use-theme';
import { apiClient } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';
import { ClassSection, useClassSectionDropdownQuery } from '@/queries/useClassSectionDropdownQuery';
import { ClassListStudent, useClassListQuery } from '@/queries/useClassListQuery';
import { useProfileDetailQuery } from '@/queries/useProfileDetailQuery';
import { RatingAnswers, useStudentRatingMutation } from '@/queries/useStudentRatingMutation';
import { useStudentRatingQuery } from '@/queries/useStudentRatingQuery';
import { useStudentSearchByAdmissionNo } from '@/queries/useStudentSearchByAdmissionNo';

// ponytail: Question/QuestionRatingInput/QuestionTextInput (@/components/question*) are shared
// components outside this pass's scope — their own internal styling isn't touched here.

type Answers = Record<string, string | number>;

function initialAnswers(): Answers {
  const acc: Answers = {};
  surveyQuestions.forEach((section) =>
    section.data.forEach((q) => {
      acc[q.pos.toString()] = q.answerType === 'input' ? '' : 0;
    })
  );
  return acc;
}

function answersToRatings(answers: Answers): RatingAnswers {
  const ratings: RatingAnswers = {};
  surveyQuestions.forEach((section) =>
    section.data.forEach((q) => {
      ratings[`question${q.pos}`] = answers[q.pos.toString()];
    })
  );
  return ratings;
}

function ratingsToAnswers(ratings?: Record<string, string | number> | null): Answers {
  const acc = initialAnswers();
  if (!ratings) return acc;
  surveyQuestions.forEach((section) =>
    section.data.forEach((q) => {
      const value = ratings[`question${q.pos}`];
      if (value !== undefined) acc[q.pos.toString()] = value;
    })
  );
  return acc;
}

function StudentWiseScreen() {
  const { staffId, teacherName, subjectLabel } = useLocalSearchParams<{
    staffId?: string;
    teacherName?: string;
    subjectLabel?: string;
  }>();
  const profileDetailQuery = useProfileDetailQuery();
  const standardSectionId = profileDetailQuery.data?.standardSectionId;
  const ratingQuery = useStudentRatingQuery(staffId, standardSectionId);
  const ratingMutation = useStudentRatingMutation(staffId, standardSectionId);

  const [phase, setPhase] = React.useState<'intro' | 'survey' | 'submitted'>('intro');
  const [step, setStep] = React.useState(0);
  const [answers, setAnswers] = React.useState<Answers>(initialAnswers);
  const { bottom: bottomInset } = useSafeAreaInsets();
  const theme = useTheme();
  const colorScheme = useEffectiveColorScheme();

  React.useEffect(() => {
    if (!ratingQuery.data) return;
    // eslint-disable-next-line react-hooks/set-state-in-effect -- sync server data into editable local state
    setAnswers(ratingsToAnswers(ratingQuery.data.ratings));
    if (ratingQuery.data.is_final_submit) setPhase('submitted');
  }, [ratingQuery.data]);

  const currentSection = surveyQuestions[step];

  const onRatingAnswer = (question: { pos: number }, value: number) => {
    setAnswers((prev) => {
      const key = question.pos.toString();
      return { ...prev, [key]: value === prev[key] ? value - 1 : value };
    });
  };

  const onTextAnswer = (question: { pos: number }, value: string) => {
    setAnswers((prev) => ({ ...prev, [question.pos.toString()]: value }));
  };

  const submitFinal = () => {
    ratingMutation.mutate(
      { ratings: answersToRatings(answers), isFinalSubmit: true },
      { onSuccess: () => setPhase('submitted') }
    );
  };

  const saveDraft = () => {
    ratingMutation.mutate({ ratings: answersToRatings(answers), isFinalSubmit: false });
  };

  if (profileDetailQuery.isLoading || ratingQuery.isLoading) {
    return (
      <View style={[styles.container, { backgroundColor: theme.background, alignItems: 'center', justifyContent: 'center' }]}>
        <ActivityIndicator size="large" color="#2658A5" />
      </View>
    );
  }

  if (phase === 'submitted') {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top', 'left', 'right']}>
        <Stack.Screen options={{ title: 'My Feedback' }} />
        <ScrollView contentContainerStyle={styles.introContent}>
          <ThemedText style={styles.h1}>Thank you for your feedback! 🎉</ThemedText>
          {surveyQuestions.map((section) => (
            <View key={section.id} style={{ gap: 16, marginTop: 20 }}>
              <ThemedText style={styles.sectionTitle}>{section.title}</ThemedText>
              {section.data.map((q) => (
                <Question
                  key={q.pos}
                  question={q}
                  AnswerComponent={
                    q.answerType === 'rating' ? (
                      <QuestionRatingInput question={q} value={answers[q.pos.toString()] as number} disabled />
                    ) : (
                      <ThemedText style={styles.answerText}>Ans: {answers[q.pos.toString()] || '—'}</ThemedText>
                    )
                  }
                />
              ))}
            </View>
          ))}
        </ScrollView>
      </SafeAreaView>
    );
  }

  if (phase === 'survey') {
    return (
      <View style={{ flex: 1 }}>
        <ScrollView
          style={{ paddingHorizontal: 20, backgroundColor: theme.background }}
          contentContainerStyle={{ paddingTop: 20, paddingBottom: bottomInset + 140 }}>
          <Text style={styles.title}>{currentSection.title}</Text>
          <View style={{ gap: 32, marginTop: 12 }}>
            {currentSection.data.map((question) => (
              <Question
                key={question.pos}
                question={question}
                AnswerComponent={
                  question.answerType === 'rating' ? (
                    <QuestionRatingInput
                      question={question}
                      value={answers[question.pos.toString()] as number}
                      onAnswer={onRatingAnswer}
                    />
                  ) : (
                    <QuestionTextInput
                      question={question}
                      value={answers[question.pos.toString()] as string}
                      onAnswer={onTextAnswer}
                    />
                  )
                }
              />
            ))}
          </View>
        </ScrollView>

        <BlurView intensity={80} tint={colorScheme} style={styles.footerBlur}>
          <SafeAreaView edges={['right', 'bottom', 'left']} style={{ paddingHorizontal: 20, paddingVertical: 12 }}>
            <View style={{ flexDirection: 'row', gap: 8, marginBottom: 12 }}>
              {surveyQuestions.map((_, index) => (
                <View
                  key={index}
                  style={[styles.progressSegment, index <= step && styles.progressSegmentActive]}
                />
              ))}
            </View>
            <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
              <TouchableHighlight
                style={styles.secondaryButton}
                onPress={() => (step === 0 ? setPhase('intro') : setStep((s) => Math.max(0, s - 1)))}
                underlayColor="#bcbcbc">
                <Text style={styles.secondaryButtonLabel}>{step === 0 ? 'Cancel' : 'Previous'}</Text>
              </TouchableHighlight>

              <TouchableOpacity style={styles.draftButton} disabled={ratingMutation.isPending} onPress={saveDraft}>
                <Text style={styles.draftButtonLabel}>Save as Draft</Text>
              </TouchableOpacity>

              {step === surveyQuestions.length - 1 ? (
                <TouchableHighlight
                  style={styles.primaryButton}
                  disabled={ratingMutation.isPending}
                  onPress={submitFinal}
                  underlayColor="#043683">
                  <Text style={styles.primaryButtonLabel}>Submit</Text>
                </TouchableHighlight>
              ) : (
                <TouchableHighlight
                  style={styles.primaryButton}
                  onPress={() => setStep((s) => Math.min(surveyQuestions.length - 1, s + 1))}
                  underlayColor="#043683">
                  <Text style={styles.primaryButtonLabel}>Next</Text>
                </TouchableHighlight>
              )}
            </View>
          </SafeAreaView>
        </BlurView>
      </View>
    );
  }

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top', 'left', 'right']}>
      <ScrollView contentContainerStyle={styles.introContent}>
        <Text>
          <ThemedText style={styles.h2}>Date:</ThemedText>{' '}
          <ThemedText style={styles.underline}>{dayjs().format('ddd, DD MMM, YYYY')}</ThemedText>
        </Text>

        <View style={{ flexDirection: 'row', gap: 12, alignItems: 'center', marginTop: 16 }}>
          <View style={[styles.avatar, { backgroundColor: theme.backgroundElement }]} />
          <View>
            <ThemedText style={styles.p}>{teacherName || 'Teacher'}</ThemedText>
            <ThemedText themeColor="textSecondary" style={styles.subtitle}>{subjectLabel || 'Subject'}</ThemedText>
          </View>
        </View>

        <ThemedText style={styles.h2}>Instructions:</ThemedText>
        <ThemedText style={styles.p}>
          Please take a few minutes to answer the following questions about your teacher.{'\n'}
          Your honest feedback will help improve teaching and learning in our school.{'\n'}
          Your answers are anonymous.
        </ThemedText>

        <ThemedText style={styles.h3}>Scale:</ThemedText>
        {[
          ['10', 'outstanding'],
          ['9-8', 'excellent'],
          ['7-6', 'good'],
          ['5-4', 'average'],
          ['3-2', 'poor'],
          ['1', 'unacceptable'],
        ].map(([value, label]) => (
          <ThemedText key={label} style={styles.p}>
            {value} = {label}
          </ThemedText>
        ))}
      </ScrollView>

      <SafeAreaView edges={['right', 'bottom', 'left']} style={{ paddingHorizontal: 20, paddingVertical: 12 }}>
        <TouchableHighlight style={styles.primaryButton} underlayColor="#043682" onPress={() => setPhase('survey')}>
          <Text style={styles.primaryButtonLabel}>Give Feedback</Text>
        </TouchableHighlight>
      </SafeAreaView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  introContent: { paddingHorizontal: 20, paddingTop: 12, paddingBottom: 24, gap: 4 },
  h1: { fontSize: 24, lineHeight: 24 * 1.4, fontWeight: 'bold' },
  h2: { fontSize: 18, lineHeight: 18 * 1.6, fontWeight: 'bold', marginTop: 16 },
  h3: { fontSize: 17, lineHeight: 17 * 1.5, fontWeight: 'bold', marginTop: 12 },
  p: { fontSize: 16, lineHeight: 16 * 1.5 },
  subtitle: { fontSize: 15 },
  underline: { textDecorationLine: 'underline' },
  avatar: { width: 60, height: 60, borderRadius: 30 },
  sectionTitle: { fontSize: 19, lineHeight: 19 * 1.5, fontWeight: 'bold' },
  answerText: { fontSize: 17, lineHeight: 17 * 1.4 },
  title: { fontSize: 20, lineHeight: 20 * 1.5, fontWeight: 'bold', color: '#2658A5' },
  footerBlur: { position: 'absolute', width: '100%', bottom: 0 },
  progressSegment: { flexGrow: 1, backgroundColor: 'silver', height: 4, borderRadius: 8 },
  progressSegmentActive: { backgroundColor: '#2658A5' },
  secondaryButton: {
    alignSelf: 'flex-end',
    paddingVertical: 9,
    paddingHorizontal: 12,
    borderRadius: 4,
    backgroundColor: '#dedede',
  },
  secondaryButtonLabel: { fontSize: 17, fontWeight: 'bold', color: '#000000' },
  draftButton: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  draftButtonLabel: { fontSize: 17, fontWeight: 'bold', color: '#2658DF' },
  primaryButton: { alignSelf: 'flex-end', paddingVertical: 9, paddingHorizontal: 12, borderRadius: 4, backgroundColor: '#2658A5' },
  primaryButtonLabel: { fontSize: 17, fontWeight: 'bold', color: '#ffffff' },
});

// ---- Staff WISE-card issuing ----
// Native: WiseFragment's "By Class" tab (ui/wise/WiseFragment.kt) — staff picks a class, selects a
// card type (Worthy/Intellect/Stature/Emotion, mutually exclusive per student) + reason per student,
// then publishes the batch (POST wise). "By Student" (native's QR tab) reuses the same
// IssueCardModal/pending-batch flow below — QR scan just resolves a ClassListStudent-shaped record
// a different way (useStudentSearchByAdmissionNo) than picking one off the class roster.
const CARD_TYPES = [
  { key: 'worthy', label: 'Worthy Card' },
  { key: 'intellect', label: 'Intellect Card' },
  { key: 'stature', label: 'Stature Card' },
  { key: 'emotion', label: 'Emotion Card' },
] as const;
type CardKey = (typeof CARD_TYPES)[number]['key'];

const REASON_MAX = 80;

type PendingCard = { student: ClassListStudent; cardKey: CardKey; reason: string };

function useIssueWiseCardsMutation() {
  const token = useSessionStore((s) => s.session?.token);

  return useMutation({
    mutationFn: async ({ cards, date }: { cards: PendingCard[]; date: Date }) => {
      const wiseDate = dayjs(date).format('DD-MM-YYYY');
      const payload = cards.map(({ student, cardKey, reason }) => ({
        student_id: student.id,
        admission_no: student.admissionNo,
        worthy: cardKey === 'worthy' ? 1 : 0,
        intellect: cardKey === 'intellect' ? 1 : 0,
        stature: cardKey === 'stature' ? 1 : 0,
        emotion: cardKey === 'emotion' ? 1 : 0,
        reason,
        wise_date: wiseDate,
      }));
      return apiClient.post('wise', payload, token);
    },
  });
}

/** Owns the form state, keyed by student id in the parent so switching students remounts it fresh
 * (no reset-on-prop-change effect needed). */
function IssueCardForm({
  student,
  onClose,
  onAdd,
}: {
  student: ClassListStudent;
  onClose: () => void;
  onAdd: (card: PendingCard) => void;
}) {
  const theme = useTheme();
  const [cardKey, setCardKey] = React.useState<CardKey | null>(null);
  const [reason, setReason] = React.useState('');

  return (
    <View style={[staffStyles.modalCard, { backgroundColor: theme.background }]}>
      <ThemedText style={staffStyles.modalTitle}>{student.name}</ThemedText>
      <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 8, marginTop: 12 }}>
        {CARD_TYPES.map((type) => (
          <TouchableOpacity
            key={type.key}
            style={[staffStyles.cardTypeChip, cardKey === type.key && staffStyles.cardTypeChipActive]}
            onPress={() => setCardKey(type.key)}>
            <Text style={[staffStyles.cardTypeChipLabel, cardKey === type.key && { color: '#ffffff' }]}>{type.label}</Text>
          </TouchableOpacity>
        ))}
      </View>

      {cardKey ? (
        <TextInput
          style={[staffStyles.reasonInput, { color: theme.text, borderColor: theme.backgroundSelected }]}
          placeholder="Reason"
          placeholderTextColor={theme.textSecondary}
          value={reason}
          onChangeText={setReason}
          maxLength={REASON_MAX}
          multiline
        />
      ) : null}

      <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 12, marginTop: 16 }}>
        <TouchableOpacity onPress={onClose}>
          <Text style={{ color: theme.textSecondary, fontWeight: '600' }}>Cancel</Text>
        </TouchableOpacity>
        <TouchableOpacity
          disabled={!cardKey || !reason.trim()}
          onPress={() => {
            if (!cardKey) return;
            onAdd({ student, cardKey, reason: reason.trim() });
            onClose();
          }}>
          <Text style={{ color: '#2658A5', fontWeight: '700', opacity: !cardKey || !reason.trim() ? 0.4 : 1 }}>Add</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

function IssueCardModal({
  student,
  onClose,
  onAdd,
}: {
  student: ClassListStudent | null;
  onClose: () => void;
  onAdd: (card: PendingCard) => void;
}) {
  return (
    <Modal visible={!!student} transparent animationType="fade" onRequestClose={onClose}>
      <View style={staffStyles.modalBackdrop}>
        {student ? <IssueCardForm key={student.id} student={student} onClose={onClose} onAdd={onAdd} /> : null}
      </View>
    </Modal>
  );
}

function StaffWiseScreen() {
  const theme = useTheme();
  const classSectionQuery = useClassSectionDropdownQuery();
  const [section, setSection] = React.useState<ClassSection | null>(null);
  const classListQuery = useClassListQuery(section?.id ?? null);
  const [modalStudent, setModalStudent] = React.useState<ClassListStudent | null>(null);
  const [pending, setPending] = React.useState<PendingCard[]>([]);
  const issueMutation = useIssueWiseCardsMutation();
  const [qrVisible, setQrVisible] = React.useState(false);
  const [classPickerVisible, setClassPickerVisible] = React.useState(false);
  const [wiseDate, setWiseDate] = React.useState(new Date());
  const [search, setSearch] = React.useState('');
  const studentSearch = useStudentSearchByAdmissionNo();

  const onQrScanned = (admissionNo: string) => {
    setQrVisible(false);
    studentSearch.mutate(admissionNo, {
      onSuccess: (student) => setModalStudent(student),
      onError: (error) =>
        Toast.show({
          type: 'error',
          text1: 'Student not found',
          text2: error instanceof Error ? error.message : undefined,
          position: 'top',
          topOffset: 100,
        }),
    });
  };

  const publish = () => {
    issueMutation.mutate({ cards: pending, date: wiseDate }, {
      onSuccess: () => {
        setPending([]);
        Toast.show({ type: 'success', text1: 'WISE cards published', position: 'top', topOffset: 100 });
      },
      onError: (error) => {
        Toast.show({
          type: 'error',
          text1: 'Could not publish WISE cards',
          text2: error instanceof Error ? error.message : undefined,
          position: 'top',
          topOffset: 100,
        });
      },
    });
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <Stack.Screen options={{ title: 'WISE' }} />

      <ScrollView contentContainerStyle={{ padding: 16, gap: 8, paddingBottom: 100 }}>
        <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' }}>
          <ThemedText style={staffStyles.sectionLabel}>Class</ThemedText>
          <TouchableOpacity
            style={staffStyles.scanButton}
            disabled={studentSearch.isPending}
            onPress={() => setQrVisible(true)}>
            <Text style={staffStyles.scanButtonLabel}>{studentSearch.isPending ? 'Looking up…' : 'Scan QR'}</Text>
          </TouchableOpacity>
        </View>
        <TouchableOpacity
          style={[staffStyles.dropdown, { backgroundColor: theme.backgroundElement }]}
          onPress={() => setClassPickerVisible(true)}>
          <ThemedText>{section?.label ?? 'Select class'}</ThemedText>
          <ThemedText themeColor="textSecondary">▾</ThemedText>
        </TouchableOpacity>
        <ThemedText style={staffStyles.sectionLabel}>Date</ThemedText>
        <RNDateTimePicker
          value={wiseDate}
          mode="date"
          display="default"
          accentColor="#2658A5"
          onChange={(_e: DateTimePickerEvent, next?: Date) => next && setWiseDate(next)}
        />
        <TextInput
          style={[staffStyles.searchInput, { color: theme.text, borderColor: theme.backgroundSelected }]}
          placeholder="Search student by name or admission no."
          placeholderTextColor={theme.textSecondary}
          value={search}
          onChangeText={setSearch}
        />

        {classListQuery.isLoading ? <ActivityIndicator style={{ marginTop: 24 }} size="large" color="#2658A5" /> : null}

        {classListQuery.data?.filter((st) => !search || `${st.name ?? ''} ${st.admissionNo ?? ''}`.toLowerCase().includes(search.toLowerCase())).map((student) => {
          const queued = pending.find((p) => p.student.id === student.id);
          return (
            <ThemedView key={student.id} type="backgroundElement" style={staffStyles.studentRow}>
              <View style={{ flex: 1 }}>
                <ThemedText style={staffStyles.studentName}>{student.name}</ThemedText>
                <ThemedText themeColor="textSecondary" style={staffStyles.studentSub}>
                  {student.admissionNo} · WISE: {student.wiseTotal ?? 0}
                </ThemedText>
              </View>
              <TouchableOpacity
                style={[staffStyles.addButton, queued && staffStyles.addButtonQueued]}
                onPress={() => setModalStudent(student)}>
                <Text style={{ color: queued ? '#ffffff' : '#2658A5', fontWeight: '700' }}>{queued ? queued.cardKey : '+'}</Text>
              </TouchableOpacity>
            </ThemedView>
          );
        })}
      </ScrollView>

      {pending.length > 0 ? (
        <SafeAreaView edges={['bottom']} style={staffStyles.publishBar}>
          <TouchableOpacity style={styles.primaryButton} disabled={issueMutation.isPending} onPress={publish}>
            <Text style={styles.primaryButtonLabel}>{issueMutation.isPending ? 'Publishing…' : `Publish (${pending.length})`}</Text>
          </TouchableOpacity>
        </SafeAreaView>
      ) : null}

      <SelectModal
        visible={classPickerVisible}
        title="Select class"
        options={classSectionQuery.data ?? []}
        selectedIds={section ? [section.id] : []}
        onClose={() => setClassPickerVisible(false)}
        onChange={([id]) => setSection(classSectionQuery.data?.find((cs) => cs.id === id) ?? null)}
      />

      <IssueCardModal
        student={modalStudent}
        onClose={() => setModalStudent(null)}
        onAdd={(card) => setPending((prev) => [...prev.filter((p) => p.student.id !== card.student.id), card])}
      />

      <QrScannerModal visible={qrVisible} onClose={() => setQrVisible(false)} onScanned={onQrScanned} />
    </SafeAreaView>
  );
}

const staffStyles = StyleSheet.create({
  sectionLabel: { fontSize: 13, fontWeight: '700', textTransform: 'uppercase', letterSpacing: 0.4 },
  dropdown: { flexDirection: 'row', justifyContent: 'space-between', padding: 12, borderRadius: 8 },
  searchInput: { borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 8, fontSize: 14 },
  scanButton: { paddingHorizontal: 12, paddingVertical: 6, borderRadius: 20, backgroundColor: '#2658A5' },
  scanButtonLabel: { fontSize: 13, fontWeight: '700', color: '#ffffff' },
  classChip: { paddingHorizontal: 12, paddingVertical: 8, borderRadius: 20, backgroundColor: '#eeeeef' },
  classChipActive: { backgroundColor: '#2658A5' },
  classChipLabel: { fontSize: 14, fontWeight: '600', color: '#343434' },
  studentRow: { flexDirection: 'row', alignItems: 'center', gap: 12, padding: 14, borderRadius: 10 },
  studentName: { fontSize: 15, fontWeight: '600' },
  studentSub: { fontSize: 13, marginTop: 2 },
  addButton: {
    width: 36,
    height: 36,
    borderRadius: 18,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: '#2658A5',
  },
  addButtonQueued: { backgroundColor: '#2658A5', borderColor: '#2658A5', width: 'auto', paddingHorizontal: 10 },
  publishBar: { position: 'absolute', bottom: 0, left: 0, right: 0, paddingHorizontal: 16, paddingTop: 8 },
  modalBackdrop: { flex: 1, backgroundColor: 'rgba(0,0,0,0.35)', alignItems: 'center', justifyContent: 'center', padding: 24 },
  modalCard: { width: '100%', maxWidth: 400, borderRadius: 12, padding: 20 },
  modalTitle: { fontSize: 17, fontWeight: '700' },
  cardTypeChip: { paddingHorizontal: 12, paddingVertical: 8, borderRadius: 20, backgroundColor: '#eeeeef' },
  cardTypeChipActive: { backgroundColor: '#2658A5' },
  cardTypeChipLabel: { fontSize: 13, fontWeight: '600', color: '#343434' },
  reasonInput: { marginTop: 12, borderWidth: 1, borderRadius: 8, padding: 10, minHeight: 60, textAlignVertical: 'top' },
});

export default function WiseScreen() {
  const isStaff = useSessionStore((s) => s.session?.isStaff);
  return isStaff ? <StaffWiseScreen /> : <StudentWiseScreen />;
}
