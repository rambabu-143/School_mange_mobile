package com.mountcarmelschools.di.data.parentlogindata

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class OTPResponse(
        @Json(name = "status")
        val status: Boolean?,
        @Json(name = "message")
        val message: String?,
        @Json(name = "data")
        val `data`: Data?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
            @Json(name = "is_approved")
            val isApproved: Boolean,
            @Json(name = "is_deleted")
            val isDeleted: Boolean,
            @Json(name = "_id")
            val id: String?,
            @Json(name = "user_id")
            val userId: String?,
            @Json(name = "mobile")
            val mobile: String?,
            @Json(name = "otp")
            val otp: String?,
            @Json(name = "valid_time")
            val validTime: String?,
            @Json(name = "branch_code")
            val branchCode: Int?,
            @Json(name = "year_session")
            val yearSession: String?,
            @Json(name = "created_at")
            val createdAt: String?,
            @Json(name = "updated_at")
            val updatedAt: String,
            @Json(name = "__v")
            val v: Int?
    )
}