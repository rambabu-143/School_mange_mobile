package com.mountcarmelschools.di.networking

import com.mountcarmelschools.di.data.CheckCurrentTermResponse
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.GetStatusList
import com.mountcarmelschools.di.data.NotificationCountModel
import com.mountcarmelschools.di.data.ParentImageUploadResponse
import com.mountcarmelschools.di.data.assesmentRecord.AssesmentRecordResponse
import com.mountcarmelschools.di.data.assignment.AssignmentUpdateResponse
import com.mountcarmelschools.di.data.assignment.AssignmentsResponse
import com.mountcarmelschools.di.data.classList.ClassListDropDownResponse
import com.mountcarmelschools.di.data.classList.ClassListResponse
import com.mountcarmelschools.di.data.config.ServerTimeResponse
import com.mountcarmelschools.di.data.dashboardApi.DashboardApiResponse
import com.mountcarmelschools.di.data.disciplinaryCard.DisciplinaryCardResponse
import com.mountcarmelschools.di.data.disciplinaryCard.DisciplinaryPostDataItem
import com.mountcarmelschools.di.data.disciplinaryCard.GetReasonListResponse
import com.mountcarmelschools.di.data.emailgroup.EmailGroupResponse
import com.mountcarmelschools.di.data.gallery.GalleryResponse
import com.mountcarmelschools.di.data.holidayHomeWork.HolidayHomeWorkResponse
import com.mountcarmelschools.di.data.homework.HomeworkResponse
import com.mountcarmelschools.di.data.login.LoginResponseFromApi
import com.mountcarmelschools.di.data.motherTongue.MotherTongueResponse
import com.mountcarmelschools.di.data.notificationHistory.NotificationPostData
import com.mountcarmelschools.di.data.notificationHistory.StaffNotificationHistoryResponse
import com.mountcarmelschools.di.data.parentlogindata.OTPPost
import com.mountcarmelschools.di.data.parentlogindata.OTPResponse
import com.mountcarmelschools.di.data.parentlogindata.OtpRequestData
import com.mountcarmelschools.di.data.reason.ReasonResponse
import com.mountcarmelschools.di.data.scann.ScanAPiResponse
import com.mountcarmelschools.di.data.scann.ScanPostData
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessRequest
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessResponse
import com.mountcarmelschools.di.data.setting.SwitchBranchRequest
import com.mountcarmelschools.di.data.setting.SwitchBranchResponse
import com.mountcarmelschools.di.data.setting.SwitchStudentRequest
import com.mountcarmelschools.di.data.staff.MarkedAttendanceResponse
import com.mountcarmelschools.di.data.staff.assignHomework.ClassHomeworkPostData
import com.mountcarmelschools.di.data.staff.assignHomework.StandardSectionListResponse
import com.mountcarmelschools.di.data.staff.assignHomework.StudentsHomeworkPostData
import com.mountcarmelschools.di.data.staff.assignHomework.StudentsListResponse
import com.mountcarmelschools.di.data.staff.assignHomework.SubjectListPostData
import com.mountcarmelschools.di.data.staff.assignHomework.SubjectListResponse
import com.mountcarmelschools.di.data.staff.assignHomework.UploadHomeworkAttachmentResponse
import com.mountcarmelschools.di.data.staff.attendanceSummery.AttendanceSummeryResponse
import com.mountcarmelschools.di.data.staff.houseList.GetHouseList
import com.mountcarmelschools.di.data.staff.houseList.HouseListPostData
import com.mountcarmelschools.di.data.staff.houseList.HouseListResponse
import com.mountcarmelschools.di.data.staff.markAttandance.MarkAttendanceDropDownResponse
import com.mountcarmelschools.di.data.staff.markAttandance.MarkAttendanceResponse
import com.mountcarmelschools.di.data.staff.markAttendance.MarkedAttendanceRequestBody
import com.mountcarmelschools.di.data.staff.notice.NoticeResponse
import com.mountcarmelschools.di.data.staff.sms.SmsResponse
import com.mountcarmelschools.di.data.staff.termAttandance.TermAttandanceResponse
import com.mountcarmelschools.di.data.staff.wiseStudentList.WiseListFromClassResponse
import com.mountcarmelschools.di.data.staff.wiseStudentList.WiseStudentListResponse
import com.mountcarmelschools.di.data.staffDashboard.StaffDashboard
import com.mountcarmelschools.di.data.staffProfile.GetAllCityResponse
import com.mountcarmelschools.di.data.staffProfile.GetAllDepartmentResponse
import com.mountcarmelschools.di.data.staffProfile.GetStaffRoomList
import com.mountcarmelschools.di.data.staffProfile.GetStudentDetailFromAdmissioNO
import com.mountcarmelschools.di.data.staffProfile.StaffProfileDetail
import com.mountcarmelschools.di.data.staffProfile.UpdateProfilePostData
import com.mountcarmelschools.di.data.staffhomework.StaffHomeworkResponse
import com.mountcarmelschools.di.data.streamSelection.StreamSelectionPostData
import com.mountcarmelschools.di.data.streamSelection.StreamSelectionResponse
import com.mountcarmelschools.di.data.student.SchoolCalendarResponse
import com.mountcarmelschools.di.data.student.StudentNoticeResponse
import com.mountcarmelschools.di.data.student.attendanceResponse.UpdatedStudentAttendanceResponse
import com.mountcarmelschools.di.data.student.setting.GetSettingResponse
import com.mountcarmelschools.di.data.studentDetail.SingleStudentDetail
import com.mountcarmelschools.di.data.studentIdCard.StudentIDCardResponse
import com.mountcarmelschools.di.data.studentIdCard.StudentIdCardPostData
import com.mountcarmelschools.di.data.studentprofile.GeneralPostData
import com.mountcarmelschools.di.data.studentprofile.GetAllCitiesResponse
import com.mountcarmelschools.di.data.studentprofile.GetAllOccupationResponse
import com.mountcarmelschools.di.data.studentprofile.GetAllStateResponse
import com.mountcarmelschools.di.data.studentprofile.GetAllSubCategoryResponse
import com.mountcarmelschools.di.data.studentprofile.MedicalPostData
import com.mountcarmelschools.di.data.studentprofile.QualificationResponse
import com.mountcarmelschools.di.data.studentprofile.ResidentialPostDataUpdated
import com.mountcarmelschools.di.data.syllabus.SyllabusResponse
import com.mountcarmelschools.di.data.teacher.MyTeacherResponse
import com.mountcarmelschools.di.data.timeTable.TimeTableResponse
import com.mountcarmelschools.di.data.transport.TransportRenewalPostData
import com.mountcarmelschools.di.data.transport.TransportRenewalResponse
import com.mountcarmelschools.di.data.updateToken.TokenPostData
import com.mountcarmelschools.di.data.updateToken.UpdateTokenResponse
import com.mountcarmelschools.di.data.versionControl.GetVersionResponse
import com.mountcarmelschools.di.data.wise.wiseRes.WiseResponseForStudent
import com.mountcarmelschools.di.data.wise.wiseRes.wisepostdata.WisePostDataForApi
import com.mountcarmelschools.di.loginData.LoginRequest
import com.mountcarmelschools.di.loginData.SocialLoginRequest
import com.mountcarmelschools.ui.setting.SettingPostData
import okhttp3.MultipartBody
import okhttp3.RequestBody
import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Headers
import retrofit2.http.Multipart
import retrofit2.http.POST
import retrofit2.http.PUT
import retrofit2.http.Part
import retrofit2.http.Path
import retrofit2.http.Streaming
import retrofit2.http.Url


interface ApiService {

    @POST("user/login")
    fun getLoginResponse(@Body loginRequest: LoginRequest): Call<LoginResponseFromApi>

    @POST("user/generate-otp")
    suspend fun parentLoginUpdated(
        @Body postData: OtpRequestData
    ): Response<OTPResponse>

    @POST("user/parent-login")
    fun parentOtpVerify(@Body otpData: OTPPost): Call<LoginResponseFromApi>

    @GET("report/student/class-list/section-wise/{section_id}")
    fun getClassListWithSection(
        @Header("Authorization") authorization: String?, @Path("section_id") section_id: String?
    ): Call<ClassListResponse?>


    @GET("staff/{id}")
    fun getStaffDetail(
        @Header("Authorization") authorization: String?, @Path("id") section_id: String?
    ): Call<StaffProfileDetail?>?


    @GET("school/house/all")
    fun getAllHouseList(
        @Header("Authorization") authorization: String?
    ): Call<GetHouseList?>?


    @GET("event-gallery/all/{date_of_admission}")
    fun getAllGallery(
        @Header("Authorization") authorization: String?,
        @Path("date_of_admission") date_of_admission: String
    ): Call<GalleryResponse?>?

    @GET("assignment/student/{student_id}/date-sheet")
    fun getDateSheet(
        @Header("Authorization") authorization: String?, @Path("student_id") student_id: String
    ): Call<StudentNoticeResponse?>?


    /*   @GET("datesheet/get-sheet")
       fun getDateSheet(
           @Header("Authorization") authorization: String?
       ): Call<DateSheetReponse?>?
   */
    @GET("student/detail/{id}")
    fun getStudentDetail(
        @Header("Authorization") authorization: String?, @Path("id") id: String?
    ): Call<SingleStudentDetail>


    @GET("time-table/student/{id}")
    fun getTimeTable(
        @Header("Authorization") authorization: String?, @Path("id") id: String?
    ): Call<TimeTableResponse?>?


    @GET("assignment/student/{student_id}/syllabus")
    fun getSyllabus(
        @Header("Authorization") authorization: String?, @Path("student_id") id: String?
    ): Call<SyllabusResponse?>?


    @GET("assignment/student/{id}/assignment")
    fun getAssignment(
        @Header("Authorization") authorization: String?, @Path("id") id: String?
    ): Call<AssignmentsResponse?>?


    @GET("wise/student-wise/{id}")
    fun getWise(
        @Header("Authorization") authorization: String?, @Path("id") id: String?
    ): Call<WiseResponseForStudent?>?


    @Headers(
        "Content-type: application/json"
    )
    @POST("wise")
    fun updateWiseCard(
        @Header("Authorization") authorization: String?, @Body data: List<WisePostDataForApi>
    ): Call<WiseResponseForStudent?>?


    @GET("student/detail/assesment-record/{id}")
    fun getAssessmentRecord(
        @Header("Authorization") authorization: String?, @Path("id") id: String?
    ): Call<AssesmentRecordResponse?>?

    /*
        @GET("sms/student/{id}/{standard_section_id}")
        fun getMessage(
            @Header("Authorization") authorization: String?,
            @Path("id") id: String?,
            @Path("standard_section_id") standard_section_id: String?
        ): Call<StudentMessageResponse?>?

        */
    @GET("sms/student/SMS/{id}")
    fun getMessageForStudent(
        @Header("Authorization") authorization: String?, @Path("id") id: String?
    ): Call<SmsResponse?>?

    @GET("/notice/student/{id}")
    fun getStudentNotice(
        @Header("Authorization") authorization: String?, @Path("id") id: String?
    ): Call<StudentNoticeResponse?>?


    @GET("attendance/mark-attendance/student/{id}/{start_date}/{end_date}")
    fun getAttendance(
        @Header("Authorization") authorization: String?,
        @Path("id") id: String?,
        @Path("start_date") start_date: String?,
        @Path("end_date") end_date: String?
    ): Call<UpdatedStudentAttendanceResponse?>?


    /*

    //------------------------------------STAFF API----------------------------------//
     */

    @GET("time-table/standard/{id}")
    fun getStaffTimeTable(
        @Header("Authorization") authorization: String?, @Path("id") id: String?
    ): Call<TimeTableResponse?>?


    @GET("/attendance/attendance-summary/{date}")
    fun getAttendanceSummery(
        @Header("Authorization") authorization: String?, @Path("date") date: String?
    ): Call<AttendanceSummeryResponse?>?


    @GET("/attendance/term-attendance/{standard_id}/{standard_section_id}/{term}")
    fun getTermAttendance(
        @Header("Authorization") authorization: String?,
        @Path("standard_id") standard_id: String?,
        @Path("standard_section_id") standard_section_id: String?,
        @Path("term") term: String?
    ): Call<TermAttandanceResponse?>?

    @GET("/attendance/mark-attendance/{standard_id}/{standard_section_id}/{date}")
    fun getStudentListForMarkAttendance(
        @Header("Authorization") authorization: String?,
        @Path("standard_id") standard_id: String?,
        @Path("standard_section_id") standard_section_id: String?,
        @Path("date") term: String?
    ): Call<MarkAttendanceResponse?>?


    @GET("/notice/staff/{id}")
    fun getNotice(
        @Header("Authorization") authorization: String?, @Path("id") id: String?
    ): Call<NoticeResponse?>?

    @GET("/sms/staff/SMS/{id}")
    fun getStaffMessage(
        @Header("Authorization") authorization: String?, @Path("id") id: String?
    ): Call<SmsResponse?>?


    @GET("/config/attendance-reason")
    fun getReason(
        @Header("Authorization") authorization: String?
    ): Call<ReasonResponse?>?


    @GET("/report/student/class-list/section-wise/{id}")
    fun getWiseStudentList(
        @Header("Authorization") authorization: String?, @Path("id") id: String?
    ): Call<WiseListFromClassResponse?>?


    @GET("/school/school-calendar/student/{id}")
    fun getSchoolCalendarData(
        @Header("Authorization") authorization: String?, @Path("id") id: String?
    ): Call<SchoolCalendarResponse?>?

    @GET("/wise/standard/{id}/{start_date}/{end_date}")
    fun getWiseStudentFromDate(
        @Header("Authorization") authorization: String?,
        @Path("id") id: String?,
        @Path("start_date") start_date: String?,
        @Path("end_date") end_date: String?

    ): Call<WiseStudentListResponse?>?


    @GET("/setting/app-setting/all")
    fun getSettingDetail(
        @Header("Authorization") authorization: String?
    ): Call<GetSettingResponse?>?


    @POST("attendance/mark-attendance")
    fun markAttendance(
        @Header("Authorization") authorization: String?,
        @Body markedAttendanceRequestBody: MarkedAttendanceRequestBody
    ): Call<MarkedAttendanceResponse?>?


    @POST("/setting/app-setting")
    fun updateSetting(
        @Header("Authorization") authorization: String?, @Body settingPostData: SettingPostData
    ): Call<GetSettingResponse?>?

    @Multipart
    @POST("config/upload-parent-profile")
    fun uploadProfileImage(
        @Header("Authorization") authorization: String?, @Part attachment: MultipartBody.Part
    ): Call<ParentImageUploadResponse?>?


    //----------------------------------------------------------------
    @POST("report/student/house-list")
    fun updateManyItem(
        @Header("Authorization") auth_token: String?, @Body houseList: HouseListPostData
    ): Call<HouseListResponse?>?


    @GET("setting/standard-section/assigned/class-list")
    fun getClassListDropDown(
        @Header("Authorization") authorization: String?
    ): Call<ClassListDropDownResponse?>?


    @GET("setting/standard-section/assigned/mark-attendance")
    fun getMarkAttendanceDropDown(
        @Header("Authorization") authorization: String?
    ): Call<MarkAttendanceDropDownResponse?>?

    @PUT("student/detail/update-device/{id}")
    fun updateStudentToken(
        @Header("Authorization") authorization: String?,
        @Body tokenPostData: TokenPostData,
        @Path("id") id: String?

    ): Call<UpdateTokenResponse?>?

    @PUT("staff/update-device/{id}")
    fun updateStaffToken(
        @Header("Authorization") authorization: String?,
        @Body tokenPostData: TokenPostData,
        @Path("id") id: String?

    ): Call<UpdateTokenResponse?>?

    @GET("sms/staff/APP/{id}")
    fun getStaffNotificationHistory(
        @Header("Authorization") authorization: String?, @Path("id") id: String?

    ): Call<StaffNotificationHistoryResponse?>?


    @GET("sms/student/APP/{id}")
    fun getStudentNotificationHistory(
        @Header("Authorization") authorization: String?, @Path("id") id: String?

    ): Call<StaffNotificationHistoryResponse?>?


    @GET("assignment/student/{id}/homework")
    fun getStudentHomeWork(
        @Header("Authorization") authorization: String?, @Path("id") id: String?

    ): Call<HolidayHomeWorkResponse?>?

    @PUT("sms/read/student/APP/{id}/{student_id}")
    fun updateStudentReadNotification(
        @Header("Authorization") authorization: String?,
        @Path("id") id: String?,
        @Path("student_id") student_id: String?,
        @Body notificationPostData: NotificationPostData
    ): Call<UpdateTokenResponse?>?

    @PUT("sms/read/staff/APP/{id}/{staff_id}")
    fun updateStaffReadNotification(
        @Header("Authorization") authorization: String?,
        @Path("id") id: String?,
        @Path("staff_id") student_id: String?,
        @Body notificationPostData: NotificationPostData
    ): Call<UpdateTokenResponse?>?


    @PUT("sms/read/student/SMS/{id}/{student_id}")
    fun updateStudentReadMessages(
        @Header("Authorization") authorization: String?,
        @Path("id") id: String?,
        @Path("student_id") student_id: String?,
        @Body notificationPostData: NotificationPostData
    ): Call<UpdateTokenResponse?>?

    @PUT("sms/read/staff/SMS/{id}/{staff_id}")
    fun updateStaffReadMessages(
        @Header("Authorization") authorization: String?,
        @Path("id") id: String?,
        @Path("staff_id") student_id: String?,
        @Body notificationPostData: NotificationPostData
    ): Call<UpdateTokenResponse?>?


    @GET("config/dashboard")
    fun getEmailGroup(
        @Header("Authorization") authorization: String
    ): Call<EmailGroupResponse>

    @GET("student/detail/my-teacher/{id}")
    fun getTeacherResponse(
        @Header("Authorization") authorization: String, @Path("id") id: String?
    ): Call<MyTeacherResponse>


    @POST("student/detail/search")
    fun getScanResponse(
        @Header("Authorization") authorization: String?, @Body scanData: ScanPostData
    ): Call<ScanAPiResponse?>?


    @GET("assignment/student/{student_id}/assignment/{subject_id}/{start_date}/{end_date}")
    fun getAssignmentBySubject(
        @Header("Authorization") authorization: String,
        @Path("student_id") student_id: String?,
        @Path("subject_id") subject_id: String?,
        @Path("start_date") start_date: String?,
        @Path("end_date") end_date: String?
    ): Call<AssignmentUpdateResponse>

    @GET("homework/student/{student_id}/{subject_id}/{start_date}/{end_date}")
    fun getHomeworkBySubject(
        @Header("Authorization") authorization: String,
        @Path("student_id") studentId: String,
        @Path("subject_id") subjectId: String,
        @Path("start_date") startDate: String,
        @Path("end_date") endDate: String
    ): Call<HomeworkResponse>

    @GET("homework/all/{start_date}/{end_date}")
    fun getAssignedHomeworkListInDateRange(
        @Header("Authorization") authorization: String,
        @Path("start_date") startDate: String,
        @Path("end_date") endDate: String
    ): Call<StaffHomeworkResponse>

    @DELETE("homework/{homework_id}/{start_date}/{end_date}")
    fun deleteAssignedHomework(
        @Header("Authorization") authorization: String,
        @Path("homework_id") homeworkId: String,
        @Path("start_date") startDate: String,
        @Path("end_date") endDate: String
    ): Call<StaffHomeworkResponse>

    @POST("user/googlelogin")
    fun socialLogin(
        @Body postData: SocialLoginRequest
    ): Call<LoginResponseFromApi>


    @POST("user/switch-school")
    fun switchBranch(
        @Header("Authorization") authorization: String, @Body postData: SwitchBranchRequest
    ): Call<SwitchBranchResponse>


    @POST("user/switch-student")
    fun switchStudent(
        @Header("Authorization") authorization: String, @Body postData: SwitchStudentRequest
    ): Call<LoginResponseFromApi>


    @Streaming
    @GET
    fun downloadFile(@Url fileUrl: String): Call<ResponseBody>


    @GET("app-version/android")
    fun getVersion(
    ): Call<GetVersionResponse>


    @GET("master/city/all")
    fun getAllCities(
        @Header("Authorization") authorization: String,
    ): Call<GetAllCityResponse>

    @GET("school/department/all")
    fun getAllDepartment(
        @Header("Authorization") authorization: String,
    ): Call<GetAllDepartmentResponse>


    @GET("school/staff-room/all")
    fun getAllStaffRoom(
        @Header("Authorization") authorization: String,
    ): Call<GetStaffRoomList>


    @GET("student/detail/admission/{admission_no}")
    fun checkValidAdmissionNo(
        @Header("Authorization") authorization: String, @Path("admission_no") admission_no: String?
    ): Call<GetStudentDetailFromAdmissioNO>


    @PUT("staff/{id}")
    fun updateProfile(
        @Header("Authorization") authorization: String,
        @Path("id") id: String,
        @Body data: UpdateProfilePostData
    ): Call<CommonResponse>

    @GET("config/term-details/{term}")
    fun checkCurrentTerm(
        @Header("Authorization") authorization: String, @Path("term") term: String?
    ): Call<CheckCurrentTermResponse>

    @GET("app-uploads/staff/{id}")
    fun getStaffStatus(
        @Header("Authorization") authorization: String, @Path("id") term: String?
    ): Call<GetStatusList>


    @GET("app-uploads/student/{id}")
    fun getStudentStatus(
        @Header("Authorization") authorization: String, @Path("id") term: String?
    ): Call<GetStatusList>


    @GET("sms/unread-count/staff/{id}")
    fun getStaffNotificationCount(
        @Header("Authorization") authorization: String, @Path("id") term: String?
    ): Call<NotificationCountModel>


    @GET("sms/unread-count/student/{id}")
    fun getStudentNotificationCount(
        @Header("Authorization") authorization: String, @Path("id") term: String?
    ): Call<NotificationCountModel>

    @GET("dashboard/student-dashboard/{student_id}/{fromDate}/{toDate}")
    fun getDashboardDetailApi(
        @Header("Authorization") authorization: String,
        @Path("student_id") student_id: String,
        @Path("fromDate") fromDate: String,
        @Path("toDate") toDate: String,
    ): Call<DashboardApiResponse>


    @GET("dashboard/staff-dashboard/{staff-id}/{fromDate}/{toDate}")
    fun getStaffDashboardDetailApi(
        @Header("Authorization") authorization: String,
        @Path("staff-id") student_id: String,
        @Path("fromDate") fromDate: String,
        @Path("toDate") toDate: String,
    ): Call<StaffDashboard>


    @POST("self-awareness")
    suspend fun updateSelfAwareness(
        @Header("Authorization") authorization: String, @Body postData: SelfAwarenessRequest
    ): Response<CommonResponse>


    @GET("self-awareness/{student_id}")
    suspend fun getSelfAwarenessUpdated(
        @Header("Authorization") authorization: String, @Path("student_id") student_id: String?
    ): Response<SelfAwarenessResponse>

    @GET("stream-selection/combination/all/{branch_code}/{year_session}")
    suspend fun getStreamSelection(
        @Header("Authorization") authorization: String,
        @Path("branch_code") branch_code: String?,
        @Path("year_session") year_session: String?
    ): Response<StreamSelectionResponse>


    @POST("stream-selection/student")
    suspend fun updateStreamSelection(
        @Header("Authorization") authorization: String,
        @Body postData: StreamSelectionPostData,
    ): Response<CommonResponse>


    @GET("master/mother-tongue/all")
    suspend fun getMotherTongue(
        @Header("Authorization") authorization: String,
    ): Response<MotherTongueResponse>

    @GET("master/city/all")
    suspend fun getAllCity(
        @Header("Authorization") authorization: String,
    ): Response<GetAllCitiesResponse>

    @GET("master/state/all?sortBy=state_name&sortMethod=asc")
    suspend fun getAllState(
        @Header("Authorization") authorization: String,
    ): Response<GetAllStateResponse>

    @GET("master/qualification/all")
    suspend fun getQualification(
        @Header("Authorization") authorization: String,
    ): Response<QualificationResponse>

    @GET("master/occupation/all?sortBy=occupation_name&sortMethod=asc")
    suspend fun getOccupation(
        @Header("Authorization") authorization: String,
    ): Response<GetAllOccupationResponse>

    @GET("master/occupation-category/all?sortBy=occupation_child_name&sortMethod=asc")
    suspend fun getSubCategoryOccupation(
        @Header("Authorization") authorization: String,
    ): Response<GetAllSubCategoryResponse>


    @PUT("student/detail/{id}")
    suspend fun updateUserProfile(
        @Header("Authorization") authorization: String,
        @Path("id") id: String, @Body body: GeneralPostData
    ): Response<CommonResponse>

    @PUT("student/detail/{id}")
    suspend fun updateUserResidentialProfile(
        @Header("Authorization") authorization: String,
        @Path("id") id: String, @Body body: ResidentialPostDataUpdated
    ): Response<CommonResponse>

    @PUT("student/detail/{id}")
    suspend fun updateUserMedicalData(
        @Header("Authorization") authorization: String,
        @Path("id") id: String, @Body body: MedicalPostData
    ): Response<CommonResponse>

    @PUT("student/detail/update-parent/{id}")
    suspend fun updateParentData(
        @Header("Authorization") authorization: String,
        @Path("id") id: String, @Body body: RequestBody
    ): Response<CommonResponse>

    @GET("student/detail/admission/{admission_no}")
    suspend fun checkValidAdmissionNoUpdated(
        @Header("Authorization") authorization: String, @Path("admission_no") admission_no: String?
    ): Response<GetStudentDetailFromAdmissioNO>

    @POST("transport/renewal-form")
    suspend fun updateTransportRenewal(
        @Header("Authorization") authorization: String,
        @Body postData: TransportRenewalPostData,
    ): Response<CommonResponse>

    @GET("transport/renewal-form/{id}")
    suspend fun getTransportRenewal(
        @Header("Authorization") authorization: String,
        @Path("id") id: String
    ): Response<TransportRenewalResponse>

    @GET("disciplinary/student-wise/{id}")
    suspend fun getDisciplinaryCard(
        @Header("Authorization") authorization: String,
        @Path("id") id: String
    ): Response<DisciplinaryCardResponse>


    @POST("student/detail/search")
    suspend fun getScanResponseDisciplinary(
        @Header("Authorization") authorization: String, @Body scanData: ScanPostData
    ): Response<ScanAPiResponse>

    @POST("disciplinary")
    suspend fun provideDisciplinary(
        @Header("Authorization") authorization: String, @Body data: List<DisciplinaryPostDataItem>
    ): Response<CommonResponse>

    @GET("config/disciplinary-reason/{id}")
    suspend fun getReasonForDisciplinary(
        @Header("Authorization") authorization: String, @Path("id") id: String
    ): Response<GetReasonListResponse>

    @GET("student/id-card/{student_id}")
    fun getStudentIDCard(
        @Header("Authorization") authorization: String,
        @Path("student_id") student_id: String,
    ): Call<StudentIDCardResponse>

    @PUT("student/id-card/{student_id}")
    fun updateStudentIDCard(
        @Header("Authorization") authorization: String,
        @Path("student_id") student_id: String,
        @Body data: StudentIdCardPostData
    ): Call<CommonResponse>

    @GET("config/real-time")
    fun getServerTime(
        @Header("Authorization") authorization: String,
    ): Call<ServerTimeResponse>

    @GET("setting/standard-section/assigned/homework")
    fun getStandardSectionList(
        @Header("Authorization") authorization: String,
    ): Call<StandardSectionListResponse>

    @GET("report/student/class-list/section-wise/{standard_section_id}")
    fun getStudentListForStandardSection(
        @Header("Authorization") authorization: String,
        @Path("standard_section_id") standardSectionId: String,
    ): Call<StudentsListResponse>

    @POST("master/subject/for-assignment")
    fun getSubjectListByStandardSection(
        @Header("Authorization") authorization: String?,
        @Body postData: SubjectListPostData,
    ): Call<SubjectListResponse>

    @Multipart
    @POST("config/upload")
    fun uploadHomeworkAttachment(
        @Header("Authorization") authorization: String?,
        @Part attachment: MultipartBody.Part
    ): Call<UploadHomeworkAttachmentResponse>

    @POST("homework")
    fun submitHomework(
        @Header("Authorization") authorization: String?,
        @Body postData: ClassHomeworkPostData,
    ): Call<CommonResponse>

    @POST("homework")
    fun submitHomework(
        @Header("Authorization") authorization: String?,
        @Body postData: StudentsHomeworkPostData,
    ): Call<CommonResponse>
}