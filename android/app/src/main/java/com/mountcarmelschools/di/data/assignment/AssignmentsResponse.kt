package com.mountcarmelschools.di.data.assignment


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class AssignmentsResponse(
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
        @Json(name = "_id")
        val id: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "end_date")
        val endDate: String?,
        @Json(name = "sent_by_staff")
        val sentByStaff: SentByStaff?,
        @Json(name = "start_date")
        val startDate: String?,
        @Json(name = "text")
        val text: String?,
        @Json(name = "title")
        val title: String?,
        @Json(name = "type")
        val type: String?
    ) {
        @JsonClass(generateAdapter = true)
        data class SentByStaff(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "name")
            val name: String?
        )
    }
}