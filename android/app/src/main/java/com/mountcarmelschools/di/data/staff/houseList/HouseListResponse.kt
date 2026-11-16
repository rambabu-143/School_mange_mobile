package com.mountcarmelschools.di.data.staff.houseList


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class HouseListResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "data")
    val `data`: List<Data?>?,
    @Json(name = "path")
    val path: String?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "_id")
        val id: String?,
        @Json(name = "admission_no")
        val admissionNo: String?,
        @Json(name = "studentImg")
        val studentImg: String?,
        @Json(name = "gender")
        val gender: String?,
        @Json(name = "house_id")
        val houseId: HouseId?,
        @Json(name = "name")
        val name: String?,
        @Json(name = "profile_pic")
        val profilePic: String?,
        @Json(name = "standard_section_id")
        val standardSectionId: StandardSectionId?
    ) {
        @JsonClass(generateAdapter = true)
        data class HouseId(
            @Json(name = "house_incharge_id")
            val houseInchargeId: List<Any?>?,
            @Json(name = "_id")
            val id: String?,
            @Json(name = "house_no")
            val houseNo: String?
        )

        @JsonClass(generateAdapter = true)
        data class StandardSectionId(
            @Json(name = "_id")
            val _id: String?,
            @Json(name = "standard")
            val standard: String?,
            @Json(name = "section")
            val section: String?,
            @Json(name = "order")
            val order: Int?,
            @Json(name = "id")
            val id: String?
        )
    }
}