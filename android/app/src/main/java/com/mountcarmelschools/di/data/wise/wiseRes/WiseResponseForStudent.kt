package com.mountcarmelschools.di.data.wise.wiseRes


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class WiseResponseForStudent(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "student")
    val student: Student?,
    @Json(name = "data")
    val `data`: Data?
)