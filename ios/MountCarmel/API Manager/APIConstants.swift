//
//  APIConstants.swift
//  BusinessForSale
//
//  Created by Chauhan Ramdevsinh on 04/02/20.
//  Copyright © 2020 HimAnshu Patel. All rights reserved.
//

import UIKit

let PLATFORM_TYPE : String = "ios"
let API_KEY_ID : String = "{id}"
let API_KEY_START_DATE : String = "{start_date}"
let API_KEY_END_DATE : String = "{end_date}"
let API_KEY_STUDENT_ID : String = "{student_id}"
let API_KEY_STAFF_ID : String = "{staff_id}"
let API_KEY_STANDARD_ID : String = "{standard_id}"
let API_KEY_STANDARD_SECTION_ID : String = "{standard_section_id}"
let API_KEY_TERM : String = "{term}"
let API_DATE : String = "{date}"
let API_KEY_TYPE : String = "{type}"
let API_KEY_SUBJECT_ID : String = "{subject_id}"
let API_KEY_DateOFAdmission : String = "{date_of_admission}"
let API_KEY_HOMEWORK_ID : String = "{homework_id}"

//let BASE_URL : String = "https://mountcarmelschool.com:3000/"
//
//let BASE_URL : String = "http://139.59.38.61:4201/"
//let BASE_URL : String = "https://mountcarmelschool.com:4202/"
let BASE_URL : String = "https://mountcarmelschool.com:4201/"

//User Management
let API_LOGIN : String = BASE_URL + "user/login"
let API_GOOGLELOGIN : String = BASE_URL + "user/googlelogin"
let API_GENERATE_OTP : String = BASE_URL + "user/generate-otp"
let API_VERIFY_OTP : String = BASE_URL + "user/parent-login"
let API_ASSIGNMENTS : String = BASE_URL + "assignment/student/\(API_KEY_STUDENT_ID)/assignment/\(API_KEY_SUBJECT_ID)/\(API_KEY_START_DATE)/\(API_KEY_END_DATE)"
let API_HOMEWORK : String = BASE_URL + "homework/student/\(API_KEY_STUDENT_ID)/\(API_KEY_SUBJECT_ID)/\(API_KEY_START_DATE)/\(API_KEY_END_DATE)"
let URI_PRIVACY_POLICY = "https://mountcarmelschool.com/privacy-policy/"
//Staff
let API_HOMEWORK_FOR_STAFF : String = BASE_URL + "homework/all/\(API_KEY_START_DATE)/\(API_KEY_END_DATE)"
let API_DELETE_STAFF_HOMEWORK : String = BASE_URL + "homework/\(API_KEY_HOMEWORK_ID)/\(API_KEY_START_DATE)/\(API_KEY_END_DATE)"
let API_HOUSELIST : String = BASE_URL + "school/house/all"
let API_HOUSEBYID : String = BASE_URL + "school/house/\(API_KEY_ID)"
let API_CLASSLIST : String = BASE_URL + "school/standard/all"
let API_CLASSLISTWITHSECTION = BASE_URL + "setting/standard-section/all"
//let API_ASSIGNEDCLASSLIST = BASE_URL + "setting/standard-section/assigned/class-list" - this one was old

let API_ASSIGNEDCLASSLIST = BASE_URL + "setting/standard-section/assigned/mark-attendance"
let API_ASSIGNED_CLASSLIST_HOMEWORK = BASE_URL + "setting/standard-section/assigned/homework"
let API_SUBJECTLIST_HOMEWORK = BASE_URL + "master/subject/for-assignment"
let API_STUDENTLIST_HOMEWORK = BASE_URL + "report/student/class-list/section-wise/\(API_KEY_STANDARD_SECTION_ID)"
let API_UPLOAD_FILE = BASE_URL + "config/upload"
let API_SUBMIT_HOMEWORK = BASE_URL + "homework"
let API_REAL_TIME = BASE_URL + "config/real-time"
let API_STAFFUPLOADS = BASE_URL + "app-uploads/staff/\(API_KEY_STAFF_ID)"
let API_STUDENTUPLOADS = BASE_URL + "app-uploads/student/\(API_KEY_STUDENT_ID)"

let API_STAFFNOTIFICATION = BASE_URL + "sms/unread-count/staff/\(API_KEY_STAFF_ID)"
let API_STUDENTNOTIFICATION = BASE_URL + "sms/unread-count/student/\(API_KEY_STUDENT_ID)"


// https://mountcarmelschool.com:4201/app-uploads/staff/{staff_id}
// https://mountcarmelschool.com:4201/app-uploads/student/{student_id}

func API_WiseGetStartDate(term:String)->String{ return BASE_URL + "config/term-details/\(term)" }

let API_EmailGroup : String = BASE_URL + "config/dashboard"
let API_StaffUpdateFcmToken : String = BASE_URL + "staff/update-device/\(API_KEY_STAFF_ID)"

let API_SwitchStudent : String = BASE_URL + "user/switch-student"

//let API_CLASS_WISE_BYID : String = BASE_URL + "report/student/class-list/section-wise/\(API_KEY_STANDARD_SECTION_ID)"
let API_CLASS_WISE_BYID : String = BASE_URL + "report/student/class-list/section-wise-detail/\(API_KEY_STANDARD_SECTION_ID)"
let API_STUDENT_WISE_LIST : String = BASE_URL + "wise/student/\(API_KEY_ID)/\(API_KEY_START_DATE)/\(API_KEY_END_DATE)"
let API_CLASS_WISE_LIST : String = BASE_URL + "wise/standard/\(API_KEY_ID)/\(API_KEY_START_DATE)/\(API_KEY_END_DATE)"
let API_TIMETABLEBYID : String = BASE_URL + "time-table/student/{id}"
let API_HOUSEREPORTBYCLASS : String = BASE_URL + "report/student/house-list"
let API_NOTICE : String = BASE_URL + "notice/student/\(API_KEY_STUDENT_ID)"
let API_NOTICE_STAFF : String = BASE_URL + "notice/staff/\(API_KEY_STAFF_ID)"
let API_STAFF_MESSAGES : String = BASE_URL + "sms/staff/SMS/\(API_KEY_STAFF_ID)"
let API_STAFF_NOTIFICATION : String = BASE_URL + "sms/staff/APP/\(API_KEY_STAFF_ID)"

let API_FEELIST = BASE_URL + "student/detail/bill-list/{id}"
let API_NOTIFICATION_LIST : String = BASE_URL + "notification/student/\(API_KEY_ID)"
let API_SCHOOLFEEDETAIL : String = BASE_URL + "student/detail/school-bill/{id}"
let API_SYLLABUS : String = BASE_URL + "syllabus/standard/\(API_KEY_STANDARD_ID)"
let API_SYLLABUS_NEW : String = BASE_URL + "assignment/student/\(API_KEY_STUDENT_ID)/syllabus"
let API_ATTANDANCEDAYSENTRY : String = BASE_URL + "attendance/term-attendance/\(API_KEY_STANDARD_ID)/\(API_KEY_STANDARD_SECTION_ID)/\(API_KEY_TERM)"

let API_MARKATTENDANCELIST : String = BASE_URL + "attendance/mark-attendance/\(API_KEY_STANDARD_ID)/\(API_KEY_STANDARD_SECTION_ID)/\(API_DATE)"
let API_ATTENDANCESUMMARY : String = BASE_URL + "attendance/attendance-summary/\(API_DATE)"
let API_PAYFEEBILL : String = "https://www.mountcarmelschool.com/stafftest/payment/fee-bill-app/\(API_KEY_STUDENT_ID)"

let API_PAYSCHOOLBILL : String = "https://www.mountcarmelschool.com/parent/payment/fee-bill-app/\(API_KEY_STUDENT_ID)"
let API_PAYTRANSPORTBILL : String = "https://www.mountcarmelschool.com/parent/payment/transport-bill-app/\(API_KEY_STUDENT_ID)"
let API_PAYTRANSPORTBILLSTAFF : String = "https://www.mountcarmelschool.com/parent/payment/staff-transport-bill-app/\(API_KEY_STAFF_ID)"
let API_PAYHOSTELBILL : String = "https://www.mountcarmelschool.com/parent/payment/hostel-bill-app/\(API_KEY_STUDENT_ID)"

let API_STAFFDETAIL : String = BASE_URL + "staff/\(API_KEY_STAFF_ID)"
let API_STAFF_SMS = "https://mountcarmelschool.com:4202/sms/staff/SMS/\(API_KEY_STAFF_ID)"
let API_UPDATEMESSAGESTATUS_STAFF : String = BASE_URL + "sms/read/staff/\(API_KEY_TYPE)/\(API_KEY_ID)/\(API_KEY_STAFF_ID)"
let API_SwitchSchool : String = BASE_URL + "user/switch-school"

// MARK-ATTENDANCE
let API_SEARCHSTUDENTS = BASE_URL + "student/detail/search"
let API_SUBMITATTENDANCE = BASE_URL + "attendance/mark-attendance"
let API_ATTENDANCEREASON = BASE_URL + "config/attendance-reason"
let API_ATTENDANCEDATE = BASE_URL + "config/Attendance-dates"

//WISE SECTION
let API_SAVEWISETOSTUDENT = BASE_URL + "wise"
let API_SEARCHSTUDENTSFROMQR = BASE_URL + "wise/search"
let API_WISEATTENDANCEDATE = BASE_URL + "config/wise-dates"
let API_STUDENTWISE = BASE_URL + "wise/student-wise/"


//Parent
let API_DATASHEET : String = BASE_URL + "assignment/student/\(API_KEY_STUDENT_ID)/date-sheet" //old one = "datesheet/get-sheet"
let API_ASSESMENTRECORD : String = BASE_URL + "student/detail/assesment-record/{id}"
//let API_GETGALLERY = BASE_URL + "gallery/all/\(API_KEY_DateOFAdmission)"
let API_GETGALLERY = BASE_URL + "event-gallery/all/\(API_KEY_DateOFAdmission)"
let API_UPLOADIMAGE =  BASE_URL + "config/upload-parent-profile"

let API_ALLSETTING =  BASE_URL + "setting/app-setting/all"
let API_UPDATESETTING =  BASE_URL + "setting/app-setting"

// STUDENT
let API_STUDENTATTANDANCE = BASE_URL + "attendance/mark-attendance/student/\(API_KEY_STUDENT_ID)"
let API_STUDENTDETAIL = BASE_URL + "student/detail/\(API_KEY_STUDENT_ID)" //fcmfcm
let API_SCHOOLCALENDAR = BASE_URL + "school/school-calendar/student/\(API_KEY_STANDARD_ID)"

func API_AdmissionDetail(adNO:String)->String{
    return BASE_URL+"student/detail/admission/"+adNO
}

let API_STUDENTALLMESSAGES : String = BASE_URL + "sms/student/SMS/\(API_KEY_STUDENT_ID)"
let API_STUDENTNOTIFICATION_LIST : String = BASE_URL + "sms/student/APP/\(API_KEY_STUDENT_ID)"
let API_UPDATESTATUS_NOTIFICATION : String = BASE_URL + "sms/read/student/\(API_KEY_TYPE)/\(API_KEY_ID)/\(API_KEY_STUDENT_ID)"
let API_MYTEACHERS : String = BASE_URL + "student/detail/my-teacher/\(API_KEY_ID)"
let API_HolidayHomeWork : String = BASE_URL + "assignment/student/\(API_KEY_ID)/homework"
let API_SubjectList : String = BASE_URL + "student/detail/\(API_KEY_ID)"
let API_StudentUpdateFcmToken : String = BASE_URL + "student/detail/update-device/\(API_KEY_ID)"

let API_TRANSPORT_REQUEST : String = "https://mountcarmelschool.com/parent/transport-request/request-form-app/\(API_KEY_ID)"

let API_AllDepartmemt : String = BASE_URL + "school/department/all"
let API_AllCity : String = BASE_URL + "master/city/all"
let API_AllStaffRoom : String = BASE_URL + "school/staff-room/all"
func API_CheckAdmissionNo(ad_no:String)->String { return BASE_URL + "student/detail/admission/" + ad_no }
let API_SELFAWERNESS : String = BASE_URL + "self-awareness"
func API_SELFAWERNESS_GET(st_id:String)->String{return BASE_URL + "self-awareness/"+st_id}
func API_SHOWSELFAWERNESSMENU(endPoint:String)->String{
    return BASE_URL + "dashboard/student-dashboard/" + endPoint
}
func API_SHOWSTAFFMENU(endPoint:String)->String{
//https://mountcarmelschool.com:4201/dashboard/staff-dashboard/5e84707c53bc8728d938a82f/01-9-2023/30-9-2023
    return BASE_URL + "dashboard/staff-dashboard/" + endPoint
}
let API_TRANSPORTRENEWALFORM : String = BASE_URL + "transport/renewal-form"

func API_GETSTREAMSELECTIONDATA (bcode:String,ysession:String)->String{
    return BASE_URL + "stream-selection/combination/all/\(bcode)/\(ysession)"
}
let API_POSTSTREAMSELECTION = BASE_URL + "stream-selection/student"

let API_CITY = BASE_URL + "master/city/all"
let API_STATE = BASE_URL + "master/state/all"
let API_COUNTRY = BASE_URL + "master/country/all"
let API_MOTHERTOUNGE = BASE_URL + "master/mother-tongue/all"
let API_QUALIFICATION = BASE_URL + "master/qualification/all"

func API_STUDENTDETAIL(stID:String)->String{
    return BASE_URL+"student/detail/"+stID
}
func API_TRANSPORTRENEWALFORMSHOW(stID:String)->String{
    return BASE_URL+"transport/renewal-form/"+stID
}

func API_DISCIPLINARYCARDLIST(admissionNo:String)->String{
    return BASE_URL+"disciplinary/student-wise/\(admissionNo)"
}

let API_OCCUPATION = BASE_URL + "master/occupation/all?sortBy=occupation_name&sortMethod=asc"

func API_SubCategory()->String{
    return BASE_URL+"master/occupation-category/all?sortBy=occupation_child_name&sortMethod=asc"
}
func API_UPDATEPARENT(stID:String)->String{
    return BASE_URL+"student/detail/update-parent/"+stID
}

func API_DISCIPLINARYSTAFFREASON(Card:String)->String{
    return BASE_URL+"config/disciplinary-reason/\(Card)"
}
let API_SENDDISCIPLINARYCARD = BASE_URL+"disciplinary"

func API_STUDENTINFODISCIPLINARY(adNo:String)->String{
    return BASE_URL+"student/detail/admission/\(adNo)"
}

func API_GETIDCARDINFO()->String{
    return BASE_URL+"student/id-card/\(APP_DELEGATE.selected_Student?.studentId?.ID ?? "")"
}

