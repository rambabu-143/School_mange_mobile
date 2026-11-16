package com.mountcarmelschools.di.data.attendance


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class AttendanceResponse(
    @Json(name = "absent")
    val absent: Int?,
    @Json(name = "data")
    val `data`: List<Data?>?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "total")
    val total: Int?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "absent")
        val absent: List<Absent?>?,
        @Json(name = "branch_code")
        val branchCode: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "date")
        val date: String?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "is_sms_sent")
        val isSmsSent: Boolean?,
        @Json(name = "platform")
        val platform: String?,
        @Json(name = "school_code")
        val schoolCode: String?,
        @Json(name = "staff_id")
        val staffId: String?,
        @Json(name = "standard_section_id")
        val standardSectionId: String?,
        @Json(name = "updated_at")
        val updatedAt: String?,
        @Json(name = "__v")
        val v: Int?,
        @Json(name = "year_session")
        val yearSession: String?
    ) {
        @JsonClass(generateAdapter = true)
        data class Absent(
            @Json(name = "details")
            val details: String?,
            @Json(name = "_id")
            val id: String?,
            @Json(name = "information")
            val information: String?,
            @Json(name = "reason")
            val reason: String?,
            @Json(name = "student_id")
            val studentId: String?,
            @Json(name = "type")
            val type: String?,
            @Json(name = "value")
            val value: Int?
        )
    }
}