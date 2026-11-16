package com.mountcarmelschools.di.data.reason


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class ReasonResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "data")
    val `data`: List<Data?>?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "reason")
        val reason: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "updated_at")
        val updatedAt: String?
    )
}