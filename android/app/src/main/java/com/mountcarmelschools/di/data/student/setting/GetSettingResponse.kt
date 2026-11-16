package com.mountcarmelschools.di.data.student.setting


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class GetSettingResponse(
    @Json(name = "status")
    var status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "data")
    val `data`: List<Data?>?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "name")
        val name: String?,
        @Json(name = "status")
        val status: Boolean?
    )
}