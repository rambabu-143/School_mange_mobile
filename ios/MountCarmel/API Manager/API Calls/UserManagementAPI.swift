//
//  UserManagement.swift
//  BusinessForSale
//
//  Created by Chauhan Ramdevsinh on 04/02/20.
//  Copyright © 2020 HimAnshu Patel. All rights reserved.
//

import UIKit
import Alamofire

class UserManagementAPI: NSObject {
    open class func login(body: LoginUserRequest, completion: @escaping ((_ data: LoginAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_LOGIN
        let parameters = body.dictionary
        let api : APITest = APITest<LoginAPIResponse>()
        api.requestforPOST(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    open class func googleLogin(body: googleLoginUserRequest, completion: @escaping ((_ data: LoginAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_GOOGLELOGIN
        let parameters = body.dictionary
        let api : APITest = APITest<LoginAPIResponse>()
        api.requestforPOST(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                print(error)
                completion(nil, error)
            }
        }
    }
    
    open class func updateStudentFcmToken(body: fcmTokenRequest, completion: @escaping ((_ data: fcmModel?,_ error: Error?) -> Void)) {
        let URLString = API_StudentUpdateFcmToken.replacingOccurrences(of:"\(API_KEY_ID)", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        print("API :\(URLString)")
        // https://mountcarmelschool.com:4201/student/detail/update-device/2cedabedf329f6f3225dd82c
        let parameters = body.dictionary
        let api : APITest = APITest<fcmModel>()
        api.requestforPUT(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func updateStaffFcmToken(body: fcmTokenRequest, completion: @escaping ((_ data: fcmModel?,_ error: Error?) -> Void)) {
        let URLString = API_StaffUpdateFcmToken.replacingOccurrences(of:"\(API_KEY_STAFF_ID)", with: APP_DELEGATE.userInfo?.staffId?.ID ?? "")
        print("API :\(URLString)")
    // https://mountcarmelschool.com:4201/staff/update-device/5e84707c53bc8728d938a82f
        let parameters = body.dictionary
        let api : APITest = APITest<fcmModel>()
        api.requestforPUT(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func generateOTP(body: LoginOTPRequest, completion: @escaping ((_ data: LoginWithOTPResponse?,_ error: Error?) -> Void)) {
        let URLString = API_GENERATE_OTP
        let parameters = body.dictionary
        let api : APITest = APITest<LoginWithOTPResponse>()
        api.requestforPOST(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func verifyOTP(body: verifyOTPRequest, completion: @escaping ((_ data: LoginAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_VERIFY_OTP
        let parameters = body.dictionary
        let api : APITest = APITest<LoginAPIResponse>()
        api.requestforPOST(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getAllDepartment(completion: @escaping ((_ data: DepartmentDataModel?,_ error: Error?) -> Void)) {
        let api : APITest = APITest<DepartmentDataModel>()
        api.requestforGET(url: API_AllDepartmemt, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    open class func getAllCity(completion: @escaping ((_ data: CityDataModel?,_ error: Error?) -> Void)) {
        let api : APITest = APITest<CityDataModel>()
        api.requestforGET(url: API_AllCity, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    open class func getAllStaffRoom(completion: @escaping ((_ data: StaffRoomDataModel?,_ error: Error?) -> Void)) {
        let api : APITest = APITest<StaffRoomDataModel>()
        api.requestforGET(url: API_AllStaffRoom, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func checkAdmissionNo(admissionNo:String,completion: @escaping ((_ data: AdmissionDataModel?,_ error: Error?) -> Void)) {
        let api : APITest = APITest<AdmissionDataModel>()
        api.requestforGET(url: API_CheckAdmissionNo(ad_no: admissionNo), parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
}

class StudentManagementAPI : NSObject {
    open class func gallary(dateOfAdmission : String?, completion: @escaping ((_ data: GallaryAPIResponse?,_ error: Error?) -> Void)) {
        //let URLString = API_GETGALLERY
        
        let URLString = API_GETGALLERY.replacingOccurrences(of:"\(API_KEY_DateOFAdmission)", with: dateOfAdmission ?? "")
        print(URLString)
        let api : APITest = APITest<GallaryAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func assignmentList(studentID:String? ,subjectID:String?,startDate:String?,endDate:String? , completion: @escaping ((_ data: AssignmentAPIResponse?,_ error: Error?) -> Void)) {
        var URLString = API_ASSIGNMENTS.replacingOccurrences(of:API_KEY_STUDENT_ID, with: studentID ?? "")
        
        URLString = URLString.replacingOccurrences(of:API_KEY_SUBJECT_ID, with: subjectID ?? "")
        
        URLString = URLString.replacingOccurrences(of:API_KEY_START_DATE, with: startDate ?? "")
        
        URLString = URLString.replacingOccurrences(of:API_KEY_END_DATE, with: endDate ?? "")
        
        print(URLString)
        
        let api : APITest = APITest<AssignmentAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getHomeworkList(studentId: String, subjectId: String, startDate: String, endDate: String, completion: @escaping ((_ data: HomeworkAPIResponse?, _ error: Error?) -> Void)) {
        let URLString = API_HOMEWORK
            .replacingOccurrences(of: API_KEY_STUDENT_ID, with: studentId)
            .replacingOccurrences(of: API_KEY_SUBJECT_ID, with: subjectId)
            .replacingOccurrences(of: API_KEY_START_DATE, with: startDate)
            .replacingOccurrences(of: API_KEY_END_DATE, with: endDate)
        
        print(URLString)
        
        let api : APITest = APITest<HomeworkAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { response, error in
            completion(response?.body, error)
        }
    }
    
    open class func getStuddentDetails(studentID:String?, completion: @escaping ((_ data: StudentDetailAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_STUDENTDETAIL.replacingOccurrences(of:API_KEY_STUDENT_ID, with: studentID ?? "")
        let api : APITest = APITest<StudentDetailAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getTransportRenewalShow(studentID:String?, completion: @escaping ((_ data: TransportRenewbleModel?,_ error: Error?) -> Void)) {
        let URLString = API_TRANSPORTRENEWALFORMSHOW(stID: studentID ?? "")
        let api : APITest = APITest<TransportRenewbleModel>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getDisiplinatyCardList(admisionNO:String, completion: @escaping ((_ data: DisciplinatyModel?,_ error: Error?) -> Void)) {
        let URLString = API_DISCIPLINARYCARDLIST(admissionNo: admisionNO)
        let api : APITest = APITest<DisciplinatyModel>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                print(error)
                completion(nil, error)
            }
        }
    }
        
    open class func getAdmissionDetail(admisionNO:String, completion: @escaping ((_ data: StudentDetailAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_AdmissionDetail(adNO: admisionNO)
        let api : APITest = APITest<StudentDetailAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func postTransportRenewalData(parameters: [String:Any], completion: @escaping ((_ data: TransportRenewalModel?,_ error: Error?) -> Void)) {
        let URLString = API_TRANSPORTRENEWALFORM
        let api : APITest = APITest<TransportRenewalModel>()
        api.requestforPOST(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    struct TransportRenewalModel:Codable{
        let message:String?
    }
    
    open class func postTransportWithdrawalData(parameters: [String:Any], completion: @escaping ((_ data: TransportRenewalModel?,_ error: Error?) -> Void)) {
        let URLString = API_TRANSPORTRENEWALFORM
        let api : APITest = APITest<TransportRenewalModel>()
        api.requestforPOST(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getMyTeachers(completion: @escaping ((_ data: MyTeacherResponse?,_ error: Error?) -> Void)) {
        
        let URLString = API_MYTEACHERS.replacingOccurrences(of:"\(API_KEY_ID)", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        print("API :\(URLString)")
        
        let api : APITest = APITest<MyTeacherResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getHolidayHomework(completion: @escaping ((_ data: StaffNoticeAPIResponse?,_ error: Error?) -> Void)) {
        
        let URLString = API_HolidayHomeWork.replacingOccurrences(of:"\(API_KEY_ID)", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        print("API :\(URLString)")
        
        let api : APITest = APITest<StaffNoticeAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getSubjectList(completion: @escaping ((_ data: StaffNoticeAPIResponse?,_ error: Error?) -> Void)) {
        
        let URLString = API_SubjectList.replacingOccurrences(of:"\(API_KEY_ID)", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        print("API :\(URLString)")
        
        let api : APITest = APITest<StaffNoticeAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func selfAwerness(body: selfAwernessRequest, completion: @escaping ((_ data: SelfAwernessPost?,_ error: Error?) -> Void)) {
        let URLString = API_SELFAWERNESS
        let parameters = body.dictionary
        let api : APITest = APITest<SelfAwernessPost>()
        api.requestforPOST(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getSelfAwerness( completion: @escaping ((_ data: SelfAwernessData?,_ error: Error?) -> Void)) {
        let URLString = API_SELFAWERNESS_GET(st_id: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        let api : APITest = APITest<SelfAwernessData>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func ShowSelfAwernessInMenu(completion: @escaping ((_ data: SelfAwernessMenu?,_ error: Error?) -> Void)) {
        let stid = APP_DELEGATE.selected_Student?.studentId?.ID ?? ""
        let strtDate = CommonFunctions.getDateInString(date: Date().startOfMonth(), strDateFormat: DateFormat.DateFormat_DDMMYYYY )
        let endDate = CommonFunctions.getDateInString(date: Date().endOfMonth(), strDateFormat: DateFormat.DateFormat_DDMMYYYY )
        
        let URLString = API_SHOWSELFAWERNESSMENU(endPoint: "\(stid)/\(strtDate)/\(endDate)")
        print(URLString)
        
        let api : APITest = APITest<SelfAwernessMenu>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }

    open class func getStreamSelection( completion: @escaping ((_ data: streamDataModel?,_ error: Error?) -> Void)) {
        let URLString = API_GETSTREAMSELECTIONDATA(bcode: String(APP_DELEGATE.student_Branch_code ?? 0), ysession: APP_DELEGATE.yearSession ?? "")
        print(URLString)
        let api : APITest = APITest<streamDataModel>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func postStreamSelection(body: [String:Any], completion: @escaping ((_ data: postStreamDataModel?,_ error: Error?) -> Void)) {
        let URLString = API_POSTSTREAMSELECTION
        let parameters = body
        let api : APITest = APITest<postStreamDataModel>()
        api.requestforPOST(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
}

class StaffManageMentAPI: NSObject{
    open class func getHomeworkList(
        startDate: String,
        endDate: String,
        completion: @escaping ((_ data: StaffHomeworkAPIResponse?, _ error: Error?) -> Void)
    ) {
        let URLString = API_HOMEWORK_FOR_STAFF
            .replacingOccurrences(of: API_KEY_START_DATE, with: startDate)
            .replacingOccurrences(of: API_KEY_END_DATE, with: endDate)
        
        print(URLString)
        
        let api : APITest = APITest<StaffHomeworkAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { response, error in
            completion(response?.body, error)
        }
    }
    
    open class func deleteHomework(
        homeworkId: String,
        startDate: String,
        endDate: String,
        completion: @escaping ((_ data: StaffHomeworkDeleteAPIResponse?, _ error: Error?) -> Void)
    ) {
        let URLString = API_DELETE_STAFF_HOMEWORK
            .replacingOccurrences(of: API_KEY_HOMEWORK_ID, with: homeworkId)
            .replacingOccurrences(of: API_KEY_START_DATE, with: startDate)
            .replacingOccurrences(of: API_KEY_END_DATE, with: endDate)
        
        print(URLString)
        
        let api : APITest = APITest<StaffHomeworkDeleteAPIResponse>()
        api.requestforDELETE(url: URLString, parameter: nil) { response, error in
            completion(response?.body, error)
        }
    }
    
    open class func StaffDashboardApi(completion: @escaping ((_ data: SelfAwernessMenu?,_ error: Error?) -> Void)) {
        let stid = APP_DELEGATE.userInfo?.staffId?.ID ?? ""
        let strtDate = CommonFunctions.getDateInString(date: Date().startOfMonth(), strDateFormat: DateFormat.DateFormat_DDMMYYYY )
        let endDate = CommonFunctions.getDateInString(date: Date().endOfMonth(), strDateFormat: DateFormat.DateFormat_DDMMYYYY )
        
        let URLString = API_SHOWSTAFFMENU(endPoint: "\(stid)/\(strtDate)/\(endDate)")
        print(URLString)
        
        let api : APITest = APITest<SelfAwernessMenu>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func houseList( completion: @escaping ((_ data: HouseApiResponse?,_ error: Error?) -> Void)) {
        let URLString = API_HOUSELIST
        let api : APITest = APITest<HouseApiResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    open class func houseListByID(houseID:String?, completion: @escaping ((_ data: HouseAPIDictResponse?,_ error: Error?) -> Void)) {
        let URLString = API_HOUSEBYID.replacingOccurrences(of:API_KEY_ID, with: houseID ?? "")
        print("API :\(URLString)")
        let api : APITest = APITest<HouseAPIDictResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    open class func classList( completion: @escaping ((_ data: ClassListApiResponse?,_ error: Error?) -> Void)) {
        let URLString = API_ASSIGNEDCLASSLIST
        let api : APITest = APITest<ClassListApiResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // MARK: - Welcome
    struct storyModel: Codable {
        let status: Bool?
        let message: String?
        let data: [Data]?
        let path: String?
    }

    // MARK: - Datum
    struct Data: Codable {
        let staffs: [Staff]?
        let id, title, text, startDate: String?
        let endDate, fileName: String?
        let sentByStaff: Staff?
        let createdAt: String?

        enum CodingKeys: String, CodingKey {
            case staffs
            case id = "_id"
            case title, text
            case startDate = "start_date"
            case endDate = "end_date"
            case fileName = "file_name"
            case sentByStaff = "sent_by_staff"
            case createdAt = "created_at"
        }
    }

    // MARK: - Staff
    struct Staff: Codable {
        let id, name: String?

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case name
        }
    }
    
    open class func storyUploads(isstaff:Bool, completion: @escaping ((_ data: [String:Any]?,_ url:String?,_ error: Error?) -> Void)) {
        var URLString = ""
        if isstaff{
            URLString = API_STAFFUPLOADS.replacingOccurrences(of:"\(API_KEY_STAFF_ID)", with: APP_DELEGATE.userInfo?.staffId?.ID ?? "")
        }else{
            URLString = API_STUDENTUPLOADS.replacingOccurrences(of:"\(API_KEY_STUDENT_ID)", with:APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        }
        
        print(URLString)
        let api : APITest = APITest<storyModel>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
              let M = response?.body
             
                if let D = M?.data, D.count != 0{
                    var arrsnap = [[String:Any]]()
                    for snap in D{
                        let fileName = snap.fileName ?? ""
                        let tempDict = [
                            "id": snap.id ?? "",
                            "mime_type": fileName.contains(".mp4") ? "video" : "image",
                            "url": (M?.path ?? "")+fileName,
                            "last_updated": ""
                        ]
                        arrsnap.append(tempDict)
                    }
                    
                    let json = [
                     "other_stories_count": 1,
                         "other_stories": [
                             [
                                 "user": [
                                     "id": "b2",
                                     "name": "",
                                     "picture": ""
                                 ],
                                 "id": "a2",
                                 "last_updated": 0,
                                 "snaps_count": M?.data?.count ?? 0,
                                 "snaps":arrsnap,
                             ]
                         ]
                     ]
                    print(json)
                    completion(json,(M?.path ?? "")+(M?.data?.first?.fileName ?? ""), error)
                }else{
                    completion(nil,nil, nil)
                }
            } else {
                completion(nil,nil, error)
            }
        }
       // .replacingOccurrences(of:API_KEY_STUDENT_ID, with: studentID ?? "")
    }
    
    /*{
        "status": true,
        "message": "Data retrieved successfully",
        "data": [{
            "staffs": [{
                "_id": "5e84707c53bc8728d938a82f",
                "name": "BHOOPENDRA KUMAR 1"
            }, {
                "_id": "5e4a9b3754e1d107631effac",
                "name": "BHOOPENDRA YADAV"
            }, {
                "_id": "5eb2bc26d9033569fa38223c",
                "name": "MEENAKSHI GAUR"
            }, {
                "_id": "5eb234d81a22bcc1abb68feb",
                "name": "SHIVANI RUDRA"
            }],
            "_id": "639c677c165ce16bf3ce8e51",
            "title": "Test File",
            "text": "testing file upload",
            "start_date": "2022-12-15T18:31:00.000Z",
            "end_date": "2022-12-28T18:29:00.000Z",
            "file_name": "delete-icon-1671194489002.png",
            "sent_by_staff": {
                "_id": "5e84707c53bc8728d938a82f",
                "name": "BHOOPENDRA KUMAR 1"
            },
            "created_at": "2022-12-16T12:41:32.098Z"
        }],
        "path": "https://mountcarmelschool.com:4201/uploads/app/2022-23/11/"
    }*/
    
  /*  {
        "other_stories_count": 4,
       
        "other_stories": [
            {
                "id": "a2",
                "last_updated": 1504799962,
                "user": {
                    "id": "b2",
                    "name": "Terasa",
                    "picture": "https://randomuser.me/api/portraits/med/women/1.jpg"
                },
                "snaps_count": 1,
                "snaps": [
                    {
                        "id": "c8",
                        "mime_type": "image",
                        "url": "https://i.pinimg.com/736x/62/32/ef/6232ef50dd5b94cb97960e22c7c6dafb--galaxy-wallpaper-iphone-iphone-.jpg",
                        "last_updated": "2m"
                    }
                ]
            }
        ]
    }*/
    
    
    struct NotificationCountModel: Codable {
        let status: Bool?
        let message: String?
        let sms_count: Int?
        let notification_count: Int?
    }
    
    open class func GetNotificationCount(isstaff:Bool, completion: @escaping ((_ smsCount:Int,_ notificationCount:Int,_ error: Error?) -> Void)) {
        var URLString = ""
        if isstaff{
            URLString = API_STAFFNOTIFICATION.replacingOccurrences(of:"\(API_KEY_STAFF_ID)", with: APP_DELEGATE.userInfo?.staffId?.ID ?? "")
        }else{
            URLString = API_STUDENTNOTIFICATION.replacingOccurrences(of:"\(API_KEY_STUDENT_ID)", with:APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        }
        
        print(URLString)
        let api : APITest = APITest<NotificationCountModel>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
              let M = response?.body
                if let status = M?.status, status{
                    completion(M?.sms_count ?? 0, M?.notification_count ?? 0, nil)
                }else{
                    completion(0,0,nil)
                }
            } else {
                completion(0,0,error)
            }
        }
       // .replacingOccurrences(of:API_KEY_STUDENT_ID, with: studentID ?? "")
    }
    
    
    open class func GetStartDate(term:String, completion: @escaping ((_ data: CalenderStartDateApiResponse?,_ error: Error?) -> Void)) {
        let URLString = Mount_Carmel.API_WiseGetStartDate(term:term)
        let api : APITest = APITest<CalenderStartDateApiResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
    
    open class func classWiseListByID(classID:String?, completion: @escaping ((_ data: HouseReportAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_CLASS_WISE_BYID.replacingOccurrences(of:API_KEY_STANDARD_SECTION_ID, with: classID ?? "")
        print("API :\(URLString)")
        let api : APITest = APITest<HouseReportAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                print(error)
                completion(nil, error)
            }
        }
    }
    
    open class func TimeTableByID(ClassID:String?, completion: @escaping ((_ data: TimeTableAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_TIMETABLEBYID.replacingOccurrences(of:"{id}", with: ClassID ?? "")
        print("API :\(URLString)")
        let api : APITest = APITest<TimeTableAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func houseListReport(body: HouseReport, completion: @escaping ((_ data: HouseReportAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_HOUSEREPORTBYCLASS
        let parameters = body.dictionary
        let api : APITest = APITest<HouseReportAPIResponse>()
        api.requestforPOST(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
            
        }
    }
    
    open class func switchStudent(body: switchStudent, completion: @escaping ((_ data: LoginAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_SwitchStudent
        let parameters = body.dictionary
        let api : APITest = APITest<LoginAPIResponse>()
        api.requestforPOST(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
            
        }
    }

    
    open class func getNoticeListForStudents(completion: @escaping ((_ data: NoticeAPIResponse?,_ error: Error?) -> Void)) {

//        var arrStudents = [LoginAPIStudent]()
//        arrStudents = APP_DELEGATE.userInfo?.students ?? [LoginAPIStudent]()
        
        let URLString = API_NOTICE.replacingOccurrences(of:"\(API_KEY_STUDENT_ID)", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        print("API :\(URLString)")
       
        let api : APITest = APITest<NoticeAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getNoticeListForStaff(completion: @escaping ((_ data: StaffNoticeAPIResponse?,_ error: Error?) -> Void)) {
        
        let URLString = API_NOTICE_STAFF.replacingOccurrences(of:"\(API_KEY_STAFF_ID)", with: APP_DELEGATE.userInfo?.staffId?.ID ?? "")
        print("API :\(URLString)")
        
        let api : APITest = APITest<StaffNoticeAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    open class func getStudentsAllMessages(completion: @escaping ((_ data: MessageAPIResponse?,_ error: Error?) -> Void)) {
        
//        var arrStudents = [LoginAPIStudent]()
//        arrStudents = APP_DELEGATE.userInfo?.students ?? [LoginAPIStudent]()
        
        let URLString = API_STUDENTALLMESSAGES.replacingOccurrences(of:"\(API_KEY_STUDENT_ID)", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        
       // URLString = URLString.replacingOccurrences(of:"\(API_KEY_STANDARD_SECTION_ID)", with: APP_DELEGATE.selected_Student?.studentId?.standardId?.ID ?? "")
        
        print("API :\(URLString)")
        
        let api : APITest = APITest<MessageAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func updateStudentMessage(messageID : String,body: MessageReadUnreadParam ,completion: @escaping ((_ data: MessageAPIResponse?,_ error: Error?) -> Void)) {
        var URLString = ""
        
        if APP_DELEGATE.userType == LoginType.Staff {
            URLString = API_UPDATEMESSAGESTATUS_STAFF.replacingOccurrences(of:"\(API_KEY_TYPE)", with: "SMS")
            
            URLString = URLString.replacingOccurrences(of:"\(API_KEY_ID)", with: messageID )
            
            URLString = URLString.replacingOccurrences(of:"\(API_KEY_STAFF_ID)", with: APP_DELEGATE.userInfo?.staffId?.ID ?? "")
        }else{
            URLString = API_UPDATESTATUS_NOTIFICATION.replacingOccurrences(of:"\(API_KEY_TYPE)", with: "SMS")
            
            URLString = URLString.replacingOccurrences(of:"\(API_KEY_ID)", with: messageID )
            
            URLString = URLString.replacingOccurrences(of:"\(API_KEY_STUDENT_ID)", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        }
        
        print("API :\(URLString)")
        let parameters = body.dictionary
        let api : APITest = APITest<MessageAPIResponse>()
        api.requestforPUT(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func updateStudentNotification(messageID : String,body: MessageReadUnreadParam ,completion: @escaping ((_ data: MessageAPIResponse?,_ error: Error?) -> Void)) {
        var URLString = ""
        
        if APP_DELEGATE.userType == LoginType.Staff {
            URLString = API_UPDATEMESSAGESTATUS_STAFF.replacingOccurrences(of:"\(API_KEY_TYPE)", with: "APP")
            
            URLString = URLString.replacingOccurrences(of:"\(API_KEY_ID)", with: messageID )
            
            URLString = URLString.replacingOccurrences(of:"\(API_KEY_STAFF_ID)", with: APP_DELEGATE.userInfo?.staffId?.ID ?? "")
        }else{
            URLString = API_UPDATESTATUS_NOTIFICATION.replacingOccurrences(of:"\(API_KEY_TYPE)", with: "APP")
            
            URLString = URLString.replacingOccurrences(of:"\(API_KEY_ID)", with: messageID )
            
            URLString = URLString.replacingOccurrences(of:"\(API_KEY_STUDENT_ID)", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        }
                
        print("API :\(URLString)")
        let parameters = body.dictionary
        let api : APITest = APITest<MessageAPIResponse>()
        api.requestforPUT(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
    open class func getStudentsNotification(completion: @escaping ((_ data: MessageAPIResponse?,_ error: Error?) -> Void)) {
        
        let URLString = API_STUDENTNOTIFICATION_LIST.replacingOccurrences(of:"\(API_KEY_STUDENT_ID)", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        
        print("API :\(URLString)")
        
        let api : APITest = APITest<MessageAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func updateStudentNotification(body: [String:Any], completion: @escaping ((_ data: SettingAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_UPDATESETTING
        let parameters = body
        let api : APITest = APITest<SettingAPIResponse>()
        api.requestforPUT(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getStaffMessages(completion: @escaping ((_ data: MessageAPIResponse?,_ error: Error?) -> Void)) {
        
        let URLString = API_STAFF_MESSAGES.replacingOccurrences(of:"\(API_KEY_STAFF_ID)", with: APP_DELEGATE.userInfo?.staffId?.ID ?? "")
        
        print("API :\(URLString)")
        
        let api : APITest = APITest<MessageAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getStaffNotifications(completion: @escaping ((_ data: MessageAPIResponse?,_ error: Error?) -> Void)) {
        
        let URLString = API_STAFF_NOTIFICATION.replacingOccurrences(of:"\(API_KEY_STAFF_ID)", with: APP_DELEGATE.userInfo?.staffId?.ID ?? "")
        
        print("API :\(URLString)")
        
        let api : APITest = APITest<MessageAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getFees(completion: @escaping ((_ data: FeeAPIResponse?,_ error: Error?) -> Void)) {
        
//        var arrStudents = [LoginAPIStudent]()
//        arrStudents = APP_DELEGATE.userInfo?.students ?? [LoginAPIStudent]()
        
        let URLString = API_FEELIST.replacingOccurrences(of:"{id}", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        print("API :\(URLString)")
        
        let api : APITest = APITest<FeeAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getSchoolFeeDetail(completion: @escaping ((_ data: FeeDetailsAPIResponse?,_ error: Error?) -> Void)) {
        
//        var arrStudents = [LoginAPIStudent]()
//        arrStudents = APP_DELEGATE.userInfo?.students ?? [LoginAPIStudent]()
        
        let URLString = API_SCHOOLFEEDETAIL.replacingOccurrences(of:"{id}", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        print("API :\(URLString)")
        
        let api : APITest = APITest<FeeDetailsAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func syllabusList(studentId: String, completion: @escaping ((_ data: SyllabusAPIResponse?,_ error: Error?) -> Void)) {
        //let URLString = API_SYLLABUS
        
        let URLString = API_SYLLABUS.replacingOccurrences(of:"\(API_KEY_STANDARD_ID)", with: studentId)
        print("API :\(URLString)")
        let api : APITest = APITest<SyllabusAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func syllabusList_new(studentId: String, completion: @escaping ((_ data: StaffNoticeAPIResponse?,_ error: Error?) -> Void)) {
        //let URLString = API_SYLLABUS
        
        let URLString = API_SYLLABUS_NEW.replacingOccurrences(of:"\(API_KEY_STUDENT_ID)", with: studentId)
        print("API :\(URLString)")
        let api : APITest = APITest<StaffNoticeAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getStudentAttendance(startDate : String? ,endDate:String?,completion: @escaping ((_ data: SubmitAttendanceAPIResponse?,_ error: Error?) -> Void)) {
        
//        var arrStudents = [LoginAPIStudent]()
//        arrStudents = APP_DELEGATE.userInfo?.students ?? [LoginAPIStudent]()
        
        var URLString = API_STUDENTATTANDANCE.replacingOccurrences(of:"\(API_KEY_STUDENT_ID)", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
    
        URLString = URLString + "/\(startDate ?? "")" + "/\(endDate ?? "")"
        
        print("API :\(URLString)")
        
        let api : APITest = APITest<SubmitAttendanceAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getSchoolCalendar(completion: @escaping ((_ data: SchoolCalanderAPIResponse?,_ error: Error?) -> Void)) {
        
        //        var arrStudents = [LoginAPIStudent]()
        //        arrStudents = APP_DELEGATE.userInfo?.students ?? [LoginAPIStudent]()
        
        var URLString = API_SCHOOLCALENDAR.replacingOccurrences(of:"\(API_KEY_STANDARD_ID)", with: APP_DELEGATE.selected_Student?.studentId?.standardId?.id ?? "")
        
        print("API :\(URLString)")
        
        let api : APITest = APITest<SchoolCalanderAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getSettingsList(completion: @escaping ((_ data: SettingAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_ALLSETTING
        print("API :\(URLString)")
        let api : APITest = APITest<SettingAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func updateSettingsAPI(body: SettingParam, completion: @escaping ((_ data: SettingAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_UPDATESETTING
        let parameters = body.dictionary
        let api : APITest = APITest<SettingAPIResponse>()
        api.requestforPOST(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getAttendanceDayEntry(standardId:String?,sectionID:String?,terms:Int?, completion: @escaping ((_ data: AttendanceEntryAPIResponse?,_ error: Error?) -> Void)) {
        
//        let standard_Id = "5e392994e0687b1082b208df"
//        let section_ID = "5e805e7fba400d5f03d1d874"
        
         var URLString = API_ATTANDANCEDAYSENTRY.replacingOccurrences(of:"\(API_KEY_STANDARD_ID)", with: standardId ?? "")
        
        URLString = URLString.replacingOccurrences(of:"\(API_KEY_STANDARD_SECTION_ID)", with: sectionID ?? "")
        
        URLString = URLString.replacingOccurrences(of:"\(API_KEY_TERM)", with: "\(terms ?? 1)" )
        
        let api : APITest = APITest<AttendanceEntryAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getMarkAttendanceList(standardId:String?,sectionID:String?,date:String?, completion: @escaping ((_ data: MarkAttendanceAPIResponse?,_ error: Error?) -> Void)) {
        
//       let standard_Id = "5e392994e0687b1082b208df"
//       let section_ID = "5e805e7fba400d5f03d1d874"
        
        var URLString = API_MARKATTENDANCELIST.replacingOccurrences(of:"\(API_KEY_STANDARD_ID)", with: standardId ?? "")
        
        URLString = URLString.replacingOccurrences(of:"\(API_KEY_STANDARD_SECTION_ID)", with: sectionID ?? "")
        
        URLString = URLString.replacingOccurrences(of:"\(API_DATE)", with: date ?? "" )
        
        let api : APITest = APITest<MarkAttendanceAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func GetAttendanceSummary(date:String?, completion: @escaping ((_ data: AttendanceSummaryAPIResponse?,_ error: Error?) -> Void)) {
        //let URLString = API_ATTENDANCESUMMARY
        let URLString = API_ATTENDANCESUMMARY.replacingOccurrences(of:"\(API_DATE)", with: date ?? "")
        let api : APITest = APITest<AttendanceSummaryAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getStaffDetails(completion: @escaping ((_ data: StaffDetailAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_STAFFDETAIL.replacingOccurrences(of:API_KEY_STAFF_ID, with: APP_DELEGATE.userInfo?.staffId?.ID ?? "")
        let api : APITest = APITest<StaffDetailAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func putStaffDetails(param:[String:Any],completion: @escaping ((_ data: UpdateStaffDataModel?,_ error: Error?) -> Void)) {
        let URLString = API_STAFFDETAIL.replacingOccurrences(of:API_KEY_STAFF_ID, with: APP_DELEGATE.userInfo?.staffId?.ID ?? "")
        let api : APITest = APITest<UpdateStaffDataModel>()
        api.requestforPUT(url: URLString, parameter: param) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getEmailGroup(completion: @escaping ((_ data: EmailGroupAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_EmailGroup
        
        let api : APITest = APITest<EmailGroupAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
        
    
    open class func SwitchSchool(body: SwitchSchoolParam, completion: @escaping ((_ data: SwitchSchoolModel?,_ error: Error?) -> Void)) {
        let parameters = body.dictionary
        let api : APITest = APITest<SwitchSchoolModel>()
        
        api.requestforPOST(url: API_SwitchSchool, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func SendDisiplinatyCard(body: [[String:Any]], completion: @escaping ((_ data: SwitchSchoolModel?,_ error: Error?) -> Void)) {
        let parameters = body
        let api : APITest = APITest<SwitchSchoolModel>()
        
        api.requestforPOSTArray(url: API_SENDDISCIPLINARYCARD, parameter: body) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getDisiplinatyCardReason(card:String, completion: @escaping ((_ data: DisiplinatyCardStaffReasonModel?,_ error: Error?) -> Void)) {
        let URLString = API_DISCIPLINARYSTAFFREASON(Card: card)
        let api : APITest = APITest<DisiplinatyCardStaffReasonModel>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                print(error)
                completion(nil, error)
            }
        }
    }
    
    open class func getDisiplinatyStudentInfo(adno:String, completion: @escaping ((_ data: DisplinarySearchStudentsAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_STUDENTINFODISCIPLINARY(adNo: adno)
        let api : APITest = APITest<DisplinarySearchStudentsAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                print(error)
                completion(nil, error)
            }
        }
    }
    
    open class func getClassListForAssigningHomework(
        completion: @escaping ((_ data: StandardSectionAPIResponse?, _ error: Error?) -> Void)
    ) {
        let URLString = API_ASSIGNED_CLASSLIST_HOMEWORK
        
        let api : APITest = APITest<StandardSectionAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { response, error in
            completion(response?.body, error)
        }
    }
    
    open class func getSubjectListForAssigningHomework(
        standardId: String,
        standardSectionId: String,
        completion: @escaping ((_ data: SubjectListAPIResponse?, _ error: Error?) -> Void)
    ) {
        let URLString = API_SUBJECTLIST_HOMEWORK
        let payload: [String: AnyHashable] = [
            "standard_id": [standardId],
            "standard_section_id": standardSectionId
        ]
        
        let api : APITest = APITest<SubjectListAPIResponse>()
        api.requestforPOST(url: URLString, parameter: payload) { response, error in
            completion(response?.body, error)
        }
    }
    
    open class func getStudentListForAssigningHomework(
        standardSectionId: String,
        completion: @escaping ((_ data: ClassStudentListAPIResponse?, _ error: Error?) -> Void)
    ) {
        let URLString = API_STUDENTLIST_HOMEWORK
            .replacingOccurrences(of: API_KEY_STANDARD_SECTION_ID, with: standardSectionId)
        
        let api : APITest = APITest<ClassStudentListAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { response, error in
            completion(response?.body, error)
        }
    }
    
    open class func uploadAssignmentFile(
        assignmentFileURL: URL,
        uploadProgressHandler: @escaping Alamofire.Request.ProgressHandler,
        completion: @escaping ((_ data: AttachmentUploadAPIResponse?, _ error: Error?) -> Void)
    ) {
        let URLString = API_UPLOAD_FILE
        
        let api : APITest = APITest<AttachmentUploadAPIResponse>()
        api.requestforFileUpload(
            url: URLString,
            fileURL: assignmentFileURL,
            uploadProgressHandler: uploadProgressHandler
        ) { (response, error) in
            completion(response?.body, error)
        }
    }
    
    open class func assignHomework(
        data: HomeworkAssignment,
        completion: @escaping ((_ data: AssignHomeworkAPIResponse?, _ error: Error?) -> Void)
    ) {
        let URLString = API_SUBMIT_HOMEWORK
        
        let api : APITest = APITest<AssignHomeworkAPIResponse>()
        api.requestforPOST(url: URLString, parameter: data.toDict()) { (response, error) in
            completion(response?.body, error)
        }
    }
    
    open class func getRealTime(
        completion: @escaping ((_ data: RealTimeAPIResponse?, _ error: Error?) -> Void)
    ) {
        let URLString = API_REAL_TIME
        
        let api : APITest = APITest<RealTimeAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            completion(response?.body, error)
        }
    }
}

class WiseManagementAPI : NSObject {
//    wise/student/5e428327f3c49184a40e3027/20-01-2019/25-01-2020
    open class func studentWise(scanedID:String?, startDate: String?, endDate: String?, completion: @escaping ((_ data: WiseListAPIResponse?,_ error: Error?) -> Void)) {
        var URLString = API_STUDENT_WISE_LIST.replacingOccurrences(of:API_KEY_ID, with: scanedID ?? "")
        URLString = URLString.replacingOccurrences(of:API_KEY_START_DATE, with: startDate ?? "")
        URLString = URLString.replacingOccurrences(of:API_KEY_END_DATE, with: endDate ?? "")
        print("API :\(URLString)")
        let api : APITest = APITest<WiseListAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func classWise(scanedID:String?, startDate: String?, endDate: String?, completion: @escaping ((_ data: WiseListAPIResponse?,_ error: Error?) -> Void)) {
        var URLString = API_CLASS_WISE_LIST.replacingOccurrences(of:API_KEY_ID, with: scanedID ?? "")
        URLString = URLString.replacingOccurrences(of:API_KEY_START_DATE, with: startDate ?? "")
        URLString = URLString.replacingOccurrences(of:API_KEY_END_DATE, with: endDate ?? "")
        print("API :\(URLString)")
        let api : APITest = APITest<WiseListAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func saveClassStudent(body: [[String:Any]], completion: @escaping ((_ data: WiseClassAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_SAVEWISETOSTUDENT
        print("URL: \(URLString)")
        
        
        let api : APITest = APITest<WiseClassAPIResponse>()
        api.requestforPOSTArray(url: URLString, parameter: body) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func searchWiseStudentsFromQR(body: SearchStudentsParam, completion: @escaping ((_ data: SearchStudentsAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_SEARCHSTUDENTSFROMQR
        let parameters = body.dictionary
        let api : APITest = APITest<SearchStudentsAPIResponse>()
        api.requestforPOST(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func wiseAllowDates(url : String,completion: @escaping ((_ data: WiseDateAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = url
        let api : APITest = APITest<WiseDateAPIResponse>()
        api.requestforGET(url: URLString,parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getstudentWiseCards(url : String,completion: @escaping ((_ data: StudentWiseResponse?,_ error: Error?) -> Void)) {
        let URLString = url
        let api : APITest = APITest<StudentWiseResponse>()
        api.requestforGET(url: URLString,parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
}

class MarkAttendanceManagemnetAPI{
    open class func searchStudents(body: SearchStudentsParam, completion: @escaping ((_ data: SearchStudentsAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_SEARCHSTUDENTS
        let parameters = body.dictionary
        let api : APITest = APITest<SearchStudentsAPIResponse>()
        api.requestforPOST(url: URLString, parameter: parameters) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func submitAttendance(body: [String:Any], completion: @escaping ((_ data: SubmitAttendanceAPIResponse?,_ error: Error?) -> Void)) {
        let URLString = API_SUBMITATTENDANCE
        print("URL: \(URLString)")
        //let parameters = body.dictionary
        let api : APITest = APITest<SubmitAttendanceAPIResponse>()
        api.requestforPOST(url: URLString, parameter: body) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    open class func getAttendanceReason(completion: @escaping ((_ data: ReasonAPIResponse?,_ error: Error?) -> Void)) {
        
        let URLString = API_ATTENDANCEREASON
        print("URL: \(URLString)")
        
        let api : APITest = APITest<ReasonAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
}



class NotificationsManagementAPI {
    open class func notificationsList(studentID:String?, completion: @escaping ((_ data: NotificationListAPIResponse?,_ error: Error?) -> Void)) {
        
//        var arrStudents = [LoginAPIStudent]()
//        arrStudents = APP_DELEGATE.userInfo?.students ?? [LoginAPIStudent]()
        
        let URLString = API_STUDENTNOTIFICATION_LIST.replacingOccurrences(of:"\(API_KEY_STUDENT_ID)", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        
       // let URLString = API_NOTIFICATION_LIST.replacingOccurrences(of:"{id}", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        
        print("API :\(URLString)")
        let api : APITest = APITest<NotificationListAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
}
class ParentManagementAPI {
    open class func getDataSheet(completion: @escaping ((_ data: StaffNoticeAPIResponse?,_ error: Error?) -> Void)) {
        
        let URLString = API_DATASHEET.replacingOccurrences(of:API_KEY_STUDENT_ID, with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        
        print("API :\(URLString)")
        
        let api : APITest = APITest<StaffNoticeAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
    open class func getAssesmentRecord(completion: @escaping ((_ data: AssesmentAPIResponse?,_ error: Error?) -> Void)) {
        
//        var arrStudents = [LoginAPIStudent]()
//        arrStudents = APP_DELEGATE.userInfo?.students ?? [LoginAPIStudent]()
        
        let URLString = API_ASSESMENTRECORD.replacingOccurrences(of:"{id}", with: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
       
        print("API :\(URLString)")
        
        let api : APITest = APITest<AssesmentAPIResponse>()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            if error == nil {
                completion(response?.body, error)
            } else {
                completion(nil, error)
            }
        }
    }
}
