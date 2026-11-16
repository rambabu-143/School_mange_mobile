package com.mountcarmelschools.di.data.wise.wiseRes


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class WisePostData(
    @Json(name = "admission_no")
    val admissionNo: String?,
    @Json(name = "reason")
    val reason: String?,
    @Json(name = "student_id")
    val studentId: String?,
    @Json(name = "wise_date")
    val wiseDate: String?,
    @Json(name = "type")
    val type: String?
)