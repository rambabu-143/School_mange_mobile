package com.mountcarmelschools.di.data.wise.wiseRes.wisepostdata


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
class WisePostDataForApi(
    @Json(name = "admission_no")
    val admissionNo: String?,
    @Json(name = "emotion")
    val emotion: Int?,
    @Json(name = "intellect")
    val intellect: Int?,
    @Json(name = "reason")
    val reason: String?,
    @Json(name = "stature")
    val stature: Int?,
    @Json(name = "student_id")
    val studentId: String?,
    @Json(name = "wise_date")
    val wiseDate: String?,
    @Json(name = "worthy")
    val worthy: Int?
)
