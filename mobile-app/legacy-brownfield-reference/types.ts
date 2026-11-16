export type TeacherEvaluationProgrammeParams = {
  staff?: {
    id?: string;
    name?: string;
    profilePic?: string;
  };
  subjectLabel?: string;
  token?: string;
  standardSectionId?: string;
  studentId?: string;
};

export type PayBillScreenParams = {
  token?: string;
  type?: "school" | "transport" | "hostel";
  userType?: "staff" | "member";
  studentId?: string;
  staffId?: string;
  userImageUri?: string;
  userEmail?: string;
  billTypeUpdated?: boolean;
  studentType?: "OLD" | string;
};

export type StaffAttendanceParams = {
  token?: string;
  staffId?: string;
};

export type SocialMediaConsentFormParams = {
  token?: string;
  studentId?: string;
  admissionNumber?: string;
  uri?: string;
};
