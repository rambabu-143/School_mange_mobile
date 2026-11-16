package com.mountcarmelschools.di.data.homework

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class HomeworkResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "path")
    val path: String?,
    @Json(name = "data")
    val data: List<Data>?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "_id")
        val id: String?,
        @Json(name = "text")
        val text: String?,
        @Json(name = "date")
        val date: String?,
        @Json(name = "attachment")
        val attachment: String?,
        @Json(name = "google_drive_file_id")
        val googleDriveFileId: String?,
        @Json(name = "google_drive_link")
        val googleDriveLink: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "updated_at")
        val updatedAt: String?,
        @Json(name = "sent_by_staff")
        val sentByStaff: SentByStaff?,
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
