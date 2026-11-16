package com.mountcarmelschools.di.data.emailgroup


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class EmailGroupResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "data")
    val `data`: Data?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "email_group_file")
        val emailGroupFile: String?,
        @Json(name = "left_box")
        val leftBox: List<LeftBox?>?,
        @Json(name = "right_box")
        val rightBox: List<RightBox?>?
    ) {
        @JsonClass(generateAdapter = true)
        data class LeftBox(
            @Json(name = "type")
            val type: String?,
            @Json(name = "name")
            val name: String?,
            @Json(name = "bg")
            val bg: String?,
            @Json(name = "link_type")
            val linkType: String?,
            @Json(name = "value")
            val value: Any?
        )

        @JsonClass(generateAdapter = true)
        data class RightBox(
            @Json(name = "type")
            val type: String?,
            @Json(name = "name")
            val name: String?,
            @Json(name = "highlight")
            val highlight: Boolean?,
            @Json(name = "bg")
            val bg: String?,
            @Json(name = "link_type")
            val linkType: String?,
            @Json(name = "value")
            val value: String?
        )
    }
}