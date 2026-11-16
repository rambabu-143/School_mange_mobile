package com.mountcarmelschools.di.data.student


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class StudentNoticeResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "data")
    val `data`: List<Data?>?,
    @Json(name = "path")
    val path: String?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "attachments")
        val attachments: List<String?>?,
        @Json(name = "highlight")
        val highlight: Boolean?,
        @Json(name = "read_flag")
        val readFlag: Boolean?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "title")
        val title: String?,
        @Json(name = "text")
        val text: String?,
        @Json(name = "created_at")
        val createdAt: String?
    )
}