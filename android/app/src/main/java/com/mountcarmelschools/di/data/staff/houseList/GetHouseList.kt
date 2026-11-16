package com.mountcarmelschools.di.data.staff.houseList


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class GetHouseList(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "data")
    val `data`: List<Data?>?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "is_house_incharge")
        val isHouseIncharge: Boolean?,
        @Json(name = "house_incharge_id")
        val houseInchargeId: List<Any?>?,
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "house_no")
        val houseNo: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "updated_at")
        val updatedAt: String?,
        @Json(name = "__v")
        val v: Int?,
        @Json(name = "house_incharge_history")
        val houseInchargeHistory: List<Any?>?
    )
}