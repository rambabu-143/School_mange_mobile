package com.mountcarmelschools.di.data.student.attendanceResponse


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class UpdatedStudentAttendanceResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "data")
    val `data`: List<Data?>?,
    @Json(name = "absent_data")
    val absentData: List<AbsentData?>?,
    @Json(name = "total")
    val total: Int?,
    @Json(name = "absent")
    val absent: Int?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "date")
        val date: String?,
        @Json(name = "day")
        val day: String?,
        @Json(name = "standard_id")
        val standardId: String?,
        @Json(name = "status")
        val status: String?,
        @Json(name = "remark")
        val remark: String?,
        @Json(name = "term")
        val term: Int?,
        @Json(name = "school_code")
        val schoolCode: String?,
        @Json(name = "branch_code")
        val branchCode: String?,
        @Json(name = "year_session")
        val yearSession: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "updated_at")
        val updatedAt: String?,
        @Json(name = "updated_by")
        val updatedBy: Any?
    )

    @JsonClass(generateAdapter = true)
    data class AbsentData(
        @Json(name = "is_sms_sent")
        val isSmsSent: Boolean?,
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "standard_section_id")
        val standardSectionId: String?,
        @Json(name = "__v")
        val v: Int?,
        @Json(name = "absent")
        val absent: List<Absent?>?,
        @Json(name = "branch_code")
        val branchCode: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "date")
        val date: String?,
        @Json(name = "platform")
        val platform: String?,
        @Json(name = "school_code")
        val schoolCode: String?,
        @Json(name = "staff_id")
        val staffId: String?,
        @Json(name = "updated_at")
        val updatedAt: String?,
        @Json(name = "year_session")
        val yearSession: String?
    ) {
        @JsonClass(generateAdapter = true)
        data class Absent(
            @Json(name = "type")
            val type: String?,
            @Json(name = "value")
            val value: String?,
            @Json(name = "_id")
            val id: String?,
            @Json(name = "student_id")
            val studentId: String?,
            @Json(name = "reason")
            val reason: String?,
            @Json(name = "details")
            val details: String?,
            @Json(name = "information")
            val information: String?
        )
    }
}