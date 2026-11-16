package com.mountcarmelschools.di.data.notificationHistory


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class StaffNotificationHistoryResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "data")
    val `data`: List<Data?>?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
            @Json(name = "receiver_type")
        val receiverType: List<String?>?,
            @Json(name = "type")
        val type: List<String?>?,
            @Json(name = "response_status")
        val responseStatus: Boolean?,
            @Json(name = "is_deleted")
        val isDeleted: Boolean?,
            @Json(name = "_id")
        val id: String?,
            @Json(name = "sms_text")
        val smsText: String?,
            @Json(name = "sms_type")
        val smsType: String?,
            @Json(name = "created_type")
            val createdType: String?,
            @Json(name = "mobiles")
            val mobiles: List<Mobile?>?,
            @Json(name = "school_code")
            val schoolCode: String?,
            @Json(name = "branch_code")
            val branchCode: String?,
            @Json(name = "year_session")
            val yearSession: String?,
            @Json(name = "notifications")
            var notifications: List<Notification?> = ArrayList(),
            @Json(name = "created_at")
            val createdAt: String?,
            @Json(name = "__v")
            val v: Int?,
            @Json(name = "sent_by_staff")
            val sentByStaff: SentByStaff?
    ) {
        @JsonClass(generateAdapter = true)
        data class Mobile(
            @Json(name = "read_flag")
            val readFlag: Boolean?,
            @Json(name = "device_id")
            val deviceId: List<Any?>?,
            @Json(name = "number")
            val number: String?,
            @Json(name = "text")
            val text: String?,
            @Json(name = "staff_id")
            val staffId: String?
        )

        @JsonClass(generateAdapter = true)
        data class Notification(
                @Json(name = "read_flag")
                var readFlag: Boolean = false,
                @Json(name = "device_id")
                val deviceId: List<Any?>?,
                @Json(name = "number")
                val number: String?,
                @Json(name = "text")
                val text: String?,
                @Json(name = "staff_id")
                val staffId: String?
        )

        @JsonClass(generateAdapter = true)
        data class SentByStaff(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "name")
            val name: String?
        )
    }
}