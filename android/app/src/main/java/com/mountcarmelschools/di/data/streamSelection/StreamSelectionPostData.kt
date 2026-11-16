package com.mountcarmelschools.di.data.streamSelection


import com.squareup.moshi.Json

data class StreamSelectionPostData(
    @Json(name = "combination_id")
    val combinationId: String?,
    @Json(name = "is_additional_subject")
    val isAdditionalSubject: Boolean?,
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
    val subject6: String?
)