package com.mountcarmelschools.di.data.classList


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class ClassListResponse(
    @Json(name = "data")
    val `data`: List<Data?>?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "path")
    val path: String?,
    @Json(name = "status")
    val status: Boolean?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "admission_no")
        val admissionNo: String?,
        @Json(name = "email")
        val email: String?,
        @Json(name = "gender")
        val gender: String?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "name")
        val name: String?,
        @Json(name = "profile_pic")
        val profilePic: String?,
        @Json(name = "sms_mobile")
        val smsMobile: String?,
        @Json(name = "standard_section_id")
        val standardSectionId: StandardSectionId?,
        @Json(name = "wise")
        val wise: Wise?,
        @Json(name = "studentImg")
        val studentImg: String?,
        @Json(name = "disciplinary")
        val disciplinary: Disciplinary?,
        @Json(name = "attendance_data")
        val attendance_data: AttendanceData?,
    ) {
        @JsonClass(generateAdapter = true)
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
        @JsonClass(generateAdapter = true)
        data class Wise(
            @Json(name = "total")
            val total: String?
        )

        @JsonClass(generateAdapter = true)
        data class Disciplinary(
            @Json(name = "total")
            val total: String?
        )
        @JsonClass(generateAdapter = true)
        data class AttendanceData(
            @Json(name = "today_attendance")
            val today_attendance: String?,
            @Json(name = "total_days")
            val total_days: Double?,
            @Json(name = "total_present")
            val total_present: Double?,
            @Json(name = "total_absent")
            val total_absent: Double?,
        )
    }
}