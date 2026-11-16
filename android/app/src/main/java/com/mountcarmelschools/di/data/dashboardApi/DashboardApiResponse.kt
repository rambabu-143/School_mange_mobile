package com.mountcarmelschools.di.data.dashboardApi


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)

data class DashboardApiResponse(
    @Json(name = "attendance_data")
    val attendanceData: AttendanceData,
    @Json(name = "newsletter")
    val newsletter: Newsletter,
    @Json(name = "chronicles")
    val chronicles: Chronicles,
    @Json(name = "current_time")
    val currentTime: String,
    @Json(name = "message")
    val message: String,
    @Json(name = "profile_pic_path")
    val profilePicPath: String,
    @Json(name = "real_time")
    val realTime: String,
    @Json(name = "self_awareness")
    val selfAwareness: SelfAwareness?,
    @Json(name = "session_details")
    val sessionDetails: SessionDetails,
    @Json(name = "stream")
    val stream: Stream?,
    @Json(name = "nomination")
    val nomination: Nomination?,
    @Json(name = "status")
    val status: Boolean,
    @Json(name = "today_date")
    val todayDate: String,
    @Json(name = "transport_renewal_form")
    val transportRenewal_Form: TransportRenewalForm?,
    @Json(name = "transport_request")
    val transportRequest: TransportRequest?,
    @Json(name = "id_card")
    val id_card: IdCard?,
) {
    data class AttendanceData(
        @Json(name = "date")
        val date: String,
        @Json(name = "month")
        val month: String,
        @Json(name = "reason")
        val reason: String,
        @Json(name = "type")
        val type: String,
        @Json(name = "year")
        val year: String
    )

    data class Chronicles(
        @Json(name = "data")
        val `data`: Data?,
        @Json(name = "path")
        val path: String
    ) {
        data class Data(
            @Json(name = "end_date")
            val endDate: String,
            @Json(name = "file_name")
            val fileName: String,
            @Json(name = "_id")
            val id: String,
            @Json(name = "name")
            val name: String,
            @Json(name = "start_date")
            val startDate: String
        )
    }

    data class Homework(
        @Json(name = "data")
        val `data`: Data,
        @Json(name = "path")
        val path: String
    ) {
        data class Data(
            @Json(name = "attachments")
            val attachments: List<String>,
            @Json(name = "created_at")
            val createdAt: String,
            @Json(name = "end_date")
            val endDate: String,
            @Json(name = "_id")
            val id: String,
            @Json(name = "sent_by_staff")
            val sentByStaff: SentByStaff,
            @Json(name = "start_date")
            val startDate: String,
            @Json(name = "text")
            val text: Any?,
            @Json(name = "title")
            val title: String,
            @Json(name = "type")
            val type: String
        ) {
            data class SentByStaff(
                @Json(name = "_id")
                val id: String,
                @Json(name = "name")
                val name: String
            )
        }
    }

    data class Ilc(
        @Json(name = "is_show_ilc")
        val isShowIlc: Boolean,
        @Json(name = "link")
        val link: String
    )

    data class Newsletter(
        @Json(name = "data")
        val `data`: Data?,
        @Json(name = "path")
        val path: String
    ) {
        data class Data(
            @Json(name = "end_date")
            val endDate: String,
            @Json(name = "file_name")
            val fileName: String,
            @Json(name = "_id")
            val id: String,
            @Json(name = "name")
            val name: String,
            @Json(name = "start_date")
            val startDate: String
        )
    }

    data class Notices(
        @Json(name = "data")
        val `data`: List<Data>,
        @Json(name = "path")
        val path: String
    ) {
        data class Data(
            @Json(name = "attachments")
            val attachments: List<String>,
            @Json(name = "branch_code")
            val branchCode: Int,
            @Json(name = "created_at")
            val createdAt: String,
            @Json(name = "created_type")
            val createdType: String,
            @Json(name = "end_date")
            val endDate: String,
            @Json(name = "highlight")
            val highlight: Boolean,
            @Json(name = "_id")
            val id: String,
            @Json(name = "is_deleted")
            val isDeleted: Boolean,
            @Json(name = "notice_number")
            val noticeNumber: NoticeNumber,
            @Json(name = "read_flag")
            val readFlag: Boolean,
            @Json(name = "school_code")
            val schoolCode: String,
            @Json(name = "sent_by_staff")
            val sentByStaff: SentByStaff,
            @Json(name = "start_date")
            val startDate: String,
            @Json(name = "text")
            val text: String,
            @Json(name = "title")
            val title: String,
            @Json(name = "__v")
            val v: Int,
            @Json(name = "year_session")
            val yearSession: String
        ) {
            data class NoticeNumber(
                @Json(name = "code")
                val code: String,
                @Json(name = "notice_audience")
                val noticeAudience: String,
                @Json(name = "number_value")
                val numberValue: Int
            )

            data class SentByStaff(
                @Json(name = "_id")
                val id: String,
                @Json(name = "name")
                val name: String
            )
        }
    }

    data class SelfAwareness(
        @Json(name = "setting")
        val setting: Setting?
    ) {
        data class Setting(
            @Json(name = "branch_code")
            val branchCode: Int,
            @Json(name = "created_at")
            val createdAt: String,
            @Json(name = "end_date")
            val endDate: String,
            @Json(name = "end_time")
            val endTime: String,
            @Json(name = "_id")
            val id: String,
            @Json(name = "is_deleted")
            val isDeleted: Boolean,
            @Json(name = "remark")
            val remark: String,
            @Json(name = "standard_sections")
            val standardSections: List<String>,
            @Json(name = "start_date")
            val startDate: String,
            @Json(name = "start_time")
            val startTime: String,
            @Json(name = "students")
            val students: List<Any>,
            @Json(name = "type")
            val type: String,
            @Json(name = "updated_at")
            val updatedAt: String,
            @Json(name = "__v")
            val v: Int,
            @Json(name = "year_session")
            val yearSession: String
        )
    }

    data class SessionDetails(
        @Json(name = "created_at")
        val createdAt: String,
        @Json(name = "_id")
        val id: String,
        @Json(name = "is_active_session")
        val isActiveSession: Boolean,
        @Json(name = "is_current_session")
        val isCurrentSession: Boolean,
        @Json(name = "is_deleted")
        val isDeleted: Boolean,
        @Json(name = "name")
        val name: String,
        @Json(name = "next_session")
        val nextSession: String,
        @Json(name = "order")
        val order: Int,
        @Json(name = "prev_session")
        val prevSession: String,
        @Json(name = "sesion_start")
        val sesionStart: String,
        @Json(name = "session_end")
        val sessionEnd: String,
        @Json(name = "updated_at")
        val updatedAt: String,
        @Json(name = "year_session")
        val yearSession: String
    )
    data class Nomination(
        @Json(name = "setting")
        val setting: Nomination.Setting?
    ) {
        data class Setting(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "standard_section_id")
            val standardSectionId: StandardSectionId?,
        ) {
            data class StandardSectionId(
                @Json(name = "_id")
                val _id: String?,
                @Json(name = "id")
                val id: String?,
                @Json(name = "section")
                val section: String?,
                @Json(name = "standard")
                val standard: String?
            )
        }
    }

    data class Stream(
        @Json(name = "data")
        val `data`: Data?,
        @Json(name = "setting")
        val setting: Setting?
    ) {
        data class Data(
            @Json(name = "branch_code")
            val branchCode: Int?,
            @Json(name = "combination_id")
            val combinationId: CombinationId?,
            @Json(name = "created_at")
            val createdAt: String?,
            @Json(name = "_id")
            val id: String?,
            @Json(name = "is_additional_subject")
            val isAdditionalSubject: Boolean?,
            @Json(name = "is_deleted")
            val isDeleted: Boolean?,
            @Json(name = "remark")
            val remark: String?,
            @Json(name = "student_id")
            val studentId: String?,
            @Json(name = "subject1")
            val subject1: String?,
            @Json(name = "subject2")
            val subject2: String?,
            @Json(name = "subject3")
            val subject3: String?,
            @Json(name = "subject4")
            val subject4: String?,
            @Json(name = "subject5")
            val subject5: String?,
            @Json(name = "subject6")
            val subject6: String?,
            @Json(name = "updated_at")
            val updatedAt: String?,
            @Json(name = "__v")
            val v: Int?,
            @Json(name = "year_session")
            val yearSession: String?
        ) {
            data class CombinationId(
                @Json(name = "combination_name")
                val combinationName: String?,
                @Json(name = "_id")
                val id: String?,
                @Json(name = "is_additional_subject")
                val isAdditionalSubject: Boolean?,
                @Json(name = "subject1")
                val subject1: List<Subject1?>?,
                @Json(name = "subject2")
                val subject2: List<Subject2?>?,
                @Json(name = "subject3")
                val subject3: List<Subject3?>?,
                @Json(name = "subject4")
                val subject4: List<Subject4?>?,
                @Json(name = "subject5")
                val subject5: List<Subject5?>?,
                @Json(name = "subject6")
                val subject6: List<Subject6?>?
            ) {
                data class Subject1(
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "subject_name")
                    val subjectName: String?
                )

                data class Subject2(
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "subject_name")
                    val subjectName: String?
                )

                data class Subject3(
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "subject_name")
                    val subjectName: String?
                )

                data class Subject4(
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "subject_name")
                    val subjectName: String?
                )

                data class Subject5(
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "subject_name")
                    val subjectName: String?
                )

                data class Subject6(
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "subject_name")
                    val subjectName: String?
                )
            }
        }

        data class Setting(
            @Json(name = "branch_code")
            val branchCode: Int?,
            @Json(name = "created_at")
            val createdAt: String?,
            @Json(name = "created_by")
            val createdBy: String?,
            @Json(name = "end_date")
            val endDate: String?,
            @Json(name = "end_time")
            val endTime: String?,
            @Json(name = "_id")
            val id: String?,
            @Json(name = "is_deleted")
            val isDeleted: Boolean?,
            @Json(name = "remark")
            val remark: String?,
            @Json(name = "standard_section_id")
            val standardSectionId: StandardSectionId?,
            @Json(name = "start_date")
            val startDate: String?,
            @Json(name = "start_time")
            val startTime: String?,
            @Json(name = "updated_at")
            val updatedAt: String?,
            @Json(name = "__v")
            val v: Int?,
            @Json(name = "year_session")
            val yearSession: String?
        ) {
            data class StandardSectionId(
                @Json(name = "_id")
                val _id: String?,
                @Json(name = "id")
                val id: String?,
                @Json(name = "section")
                val section: String?,
                @Json(name = "standard")
                val standard: String?
            )
        }
    }

    data class Wise(
        @Json(name = "total")
        val total: Int
    )
    data class TransportRenewalForm(
        @Json(name = "is_show")
        val isShow: Boolean
    )
    data class TransportRequest(
        @Json(name = "is_show")
        val isShow: Boolean?,
        @Json(name = "message")
        val message: String?,
    )
   data class IdCard(
        @Json(name = "is_show")
        val isShow: Boolean
    )


}