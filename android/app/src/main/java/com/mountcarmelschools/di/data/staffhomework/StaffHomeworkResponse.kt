package com.mountcarmelschools.di.data.staffhomework

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class StaffHomeworkResponse(
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
        @Json(name = "selected_section")
        val selectedSection: Section?,
        @Json(name = "standard_section")
        val standardSection: Section?,
        @Json(name = "students")
        val students: List<String>?,
        @Json(name = "subject_id")
        val subjectId: Subject,
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

        @JsonClass(generateAdapter = true)
        data class Section(
            @Json(name = "id")
            val id: String?,
            @Json(name = "_id")
            val _id: String?,
            @Json(name = "standard")
            val standard: String?,
            @Json(name = "section")
            val section: String?
        )

        @JsonClass(generateAdapter = true)
        data class Subject(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "subject_name")
            val subjectName: String?
        )
    }
}
