package com.mountcarmelschools.di.data.dateSheet


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class DateSheetReponse(
    @Json(name = "data")
    val `data`: Data?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "path")
    val path: String?,
    @Json(name = "status")
    val status: Boolean?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "attachment")
        val attachment: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "created_by")
        val createdBy: String?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "platform")
        val platform: String?,
        @Json(name = "school_code")
        val schoolCode: String?,
        @Json(name = "__v")
        val v: Int?,
        @Json(name = "year_session")
        val yearSession: String?
    )
}