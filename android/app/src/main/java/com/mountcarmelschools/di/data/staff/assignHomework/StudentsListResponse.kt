package com.mountcarmelschools.di.data.staff.assignHomework

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class StudentsListResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "path")
    val path: String?,
    @Json(name = "data")
    val data: List<StudentData>?
) {
    @JsonClass(generateAdapter = true)
    data class StudentData(
        @Json(name = "is_transport")
        val isTransport: Boolean?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "admission_no")
        val admissionNum: String?,
        @Json(name = "name")
        val name: String?,
        @Json(name = "standard_id")
        val standardId: String?,
        @Json(name = "date_of_admission")
        val dateOfAdmission: String?,
        @Json(name = "email")
        val email: String?,
        @Json(name = "gender")
        val gender: String?,
        @Json(name = "sms_mobile")
        val smsMobile: String?,
        @Json(name = "profile_pic")
        val profilePic: String?,
        @Json(name = "studentImg")
        val studentImg: String?,
        @Json(name = "prev_admission_no")
        val prevAdmissionNum: String?,
    )
}
