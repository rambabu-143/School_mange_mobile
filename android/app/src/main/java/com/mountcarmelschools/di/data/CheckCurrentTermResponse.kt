package com.mountcarmelschools.di.data


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class CheckCurrentTermResponse(
    @Json(name = "data")
    val `data`: Data?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "status")
    val status: Boolean?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "end_date")
        val endDate: String?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "start_date")
        val startDate: String?,
        @Json(name = "term_session")
        val termSession: String?,
        @Json(name = "updated_at")
        val updatedAt: String?,
        @Json(name = "year_session")
        val yearSession: String?
    )
}