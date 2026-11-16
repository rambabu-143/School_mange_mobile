package com.mountcarmelschools.di.data.disciplinaryCard


import com.squareup.moshi.Json

data class GetReasonListResponse(
    @Json(name = "data")
    val `data`: List<Data?>?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "status")
    val status: Boolean?
) {
    data class Data(
        @Json(name = "card_type")
        val cardType: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "reason")
        val reason: String?,
        @Json(name = "updated_at")
        val updatedAt: String?
    )
}