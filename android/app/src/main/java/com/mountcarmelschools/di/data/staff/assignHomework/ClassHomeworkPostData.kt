package com.mountcarmelschools.di.data.staff.assignHomework

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class ClassHomeworkPostData(
    @Json(name = "standard_section")
    val standardSectionId: String,
    @Json(name = "text")
    val text: String,
    @Json(name = "subject_id")
    val subjectId: String,
    @Json(name = "date")
    val date: String, // DD-MM-YYYY
    @Json(name = "attachment")
    val attachment: String?
)
