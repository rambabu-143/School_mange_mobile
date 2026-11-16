package com.mountcarmelschools.di.data.staffProfile


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class GetAllCityResponse(
    @Json(name = "data")
    val `data`: List<Data?>?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "status")
    val status: Boolean?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "city_code")
        val cityCode: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "name")
        val name: String?,
        @Json(name = "updated_at")
        val updatedAt: String?,
        @Json(name = "__v")
        val v: Int?
    )
}