package com.mountcarmelschools.di.data.disciplinaryCard


import com.squareup.moshi.Json

class DisciplinaryPostDataItem(
    @Json(name = "action_taken")
    val actionTaken: String?,
    @Json(name = "admission_no")
    val admissionNo: String?,
    @Json(name = "house_point")
    val housePoint: String?,
    @Json(name = "issue_date")
    val issueDate: String?,
    @Json(name = "pink")
    val pink: Int?,
    @Json(name = "reason")
    val reason: String?,
    @Json(name = "reason_other")
    val reason_other: String?,
    @Json(name = "red")
    val red: Int?,
    @Json(name = "student_id")
    val studentId: String?,
    @Json(name = "yellow")
    val yellow: Int?
)
