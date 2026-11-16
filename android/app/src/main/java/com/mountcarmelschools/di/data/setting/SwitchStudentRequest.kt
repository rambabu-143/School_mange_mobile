package com.mountcarmelschools.di.data.setting


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class SwitchStudentRequest(
    @Json(name = "email") val email: String,
    @Json(name = "platform") val platform: String,
    @Json(name = "admission_no") val admission_no: String,
)
