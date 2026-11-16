package com.mountcarmelschools.di.data.staff.assignHomework

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class UploadHomeworkAttachmentResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "file_name")
    val fileName: String?,
    @Json(name = "originalname")
    val originalName: String?,
    @Json(name = "file_size")
    val fileSize: Int?,
    @Json(name = "path")
    val path: String?,
)
