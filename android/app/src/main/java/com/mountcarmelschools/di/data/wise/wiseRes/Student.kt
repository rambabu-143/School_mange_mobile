package com.mountcarmelschools.di.data.wise.wiseRes


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class Student(
    @Json(name = "_id")
    val id: String?,
    @Json(name = "admission_no")
    val admissionNo: String?,
    @Json(name = "name")
    val name: String?,
    @Json(name = "standard_section_id")
    val standardSectionId: StandardSectionId?
)