package com.mountcarmelschools.di.data.staffProfile


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class GetAllDepartmentResponse(
    @Json(name = "data")
    val `data`: List<Data?>?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "status")
    val status: Boolean?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "_id")
        val id: String?,
        @Json(name = "name")
        val name: String?,
        @Json(name = "order")
        val order: Int?,
        @Json(name = "__v")
        val v: Int?,
        @Json(name = "year_session")
        val yearSession: String?
    )
}