package com.mountcarmelschools.di.data.gallery


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class GalleryResponse(
    @Json(name = "data")
    val `data`: List<Data?>?,
    @Json(name = "path")
    val path: String?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
            @Json(name = "is_deleted")
            val isDeleted: Boolean?,
            @Json(name = "_id")
            val id: String?,
            @Json(name = "__v")
            val v: Int?,
            @Json(name = "branch_code")
            val  branchCode : Int?,
            @Json(name = "created_at")
            val createdAt: String?,
            @Json(name = "event_date")
            val evenDate :String?,
            @Json(name = "images")
            val images: List<Images>,
            @Json(name = "information")
            val information : String?,
            @Json(name = "name")
            val eventName: String?,
            @Json(name = "staff_id")
            val staffId : String?,
            @Json(name = "thumbnail")
            val thumbnail : String?,
            @Json(name = "updated_at")
            val updatedAt :String?,
            @Json(name = "year_session")
            val yearSession : String?,
            @Json(name = "description")
            val description : String?


    ) {
        @JsonClass(generateAdapter = true)
        data class Images(
            @Json(name = "file_name")
            val filename: String?,
            @Json(name = "is_thumbnail")
            val isThumbnail : Boolean?,
            @Json(name = "_id")
            val id : String?,
            @Json(name = "bytes")
            val bytes : Long?

        )
    }
}