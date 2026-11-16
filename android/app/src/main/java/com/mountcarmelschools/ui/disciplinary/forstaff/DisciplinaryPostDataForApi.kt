package com.mountcarmelschools.ui.disciplinary.forstaff


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
class DisciplinaryPostDataForApi(
    @Json(name = "admission_no")
    val admissionNo: String?,
    @Json(name = "student_id")
    val studentId: String?,
    @Json(name = "pink")
    val pink: Int?,
    @Json(name = "yellow")
    val yellow: Int?,
    @Json(name = "red")
    val red: Int?,
    @Json(name = "reason")
    val reason: String?,
    @Json(name = "reason_other")
    val reason_other: String?,
    @Json(name = "action_taken")
    val action_taken: String?,
    @Json(name = "house_point")
    val house_point: String?,
    @Json(name = "issue_date")
    val issue_date: String?,
)
