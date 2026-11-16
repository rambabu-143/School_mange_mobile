package com.mountcarmelschools.di.data.staff.termAttandance


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class TermAttandanceResponse(
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
        @Json(name = "date_of_withdrawal")
        val date_of_withdrawal: String?,
        @Json(name = "combo_id")
        val comboId: String?,
        @Json(name = "attendance_data")
        val attendanceData: AttendanceData?
    ) {
        @JsonClass(generateAdapter = true)
        data class AttendanceData(
            @Json(name = "total_days")
            val totalDays: Double?,
            @Json(name = "total_present")
            val totalPresent: Double?,
            @Json(name = "total_absent")
            val totalAbsent: Double?
        )
    }
}