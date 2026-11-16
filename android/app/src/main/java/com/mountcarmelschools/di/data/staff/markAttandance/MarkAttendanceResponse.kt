package com.mountcarmelschools.di.data.staff.markAttandance


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class MarkAttendanceResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "path")
    val path: String?,
    @Json(name = "data")
    val `data`: List<Data?>?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "_id")
        val id: String?,
        @Json(name = "admission_no")
        val admissionNo: String?,
        @Json(name = "studentImg")
        val studentImg: String?,
        @Json(name = "email")
        val email: String?,
        @Json(name = "gender")
        val gender: String?,
        @Json(name = "house_id")
        val houseId: String?,
        @Json(name = "name")
        val name: String?,
        @Json(name = "profile_pic")
        val profilePic: String?,
        @Json(name = "sms_mobile")
        val smsMobile: String?,
        @Json(name = "standard_section_id")
        val standardSectionId: StandardSectionId?,
        @Json(name = "is_section_changed")
        val isSectionChanged: Boolean?,
        @Json(name = "combo_id")
        val comboId: String?,
        @Json(name = "attendance")
        val attendance: Attendance?,
        var first: String? = "",
        var second: String? = "",
        var reason: String? = "",
        var information: String? = "",
        var others: String? = ""
    ) {
        @JsonClass(generateAdapter = true)
        data class Attendance(
            @Json(name = "marked_on")
            val markedOn: String?,
            @Json(name = "type")
            val type: String?,
            @Json(name = "reason")
            val reason: String?,
            @Json(name = "details")
            val details: String?,
            @Json(name = "information")
            val information: String?
        )

        @JsonClass(generateAdapter = true)
        data class StandardSectionId(
            @Json(name = "_id")
            val _id: String?,
            @Json(name = "standard")
            val standard: String?,
            @Json(name = "section")
            val section: String?,
            @Json(name = "id")
            val id: String?
        )
    }
}


