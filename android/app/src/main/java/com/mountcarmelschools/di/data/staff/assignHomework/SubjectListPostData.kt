package com.mountcarmelschools.di.data.staff.assignHomework

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class SubjectListPostData(
    @Json(name = "standard_id")
    val standardId: List<String>,
    @Json(name = "standard_section_id")
    val standardSectionId: String
)
