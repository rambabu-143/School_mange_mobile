package com.mountcarmelschools.di.data.staff.sms


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class SmsResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "data")
    val `data`: List<Data?>?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
            @Json(name = "text_local_res")
        val textLocalRes: TextLocalRes?,
            @Json(name = "staffs")
        val staffs: List<String?>?,
            @Json(name = "students")
        val students: List<String?>?,
            @Json(name = "alumnies")
        val alumnies: List<Any?>?,
            @Json(name = "board_of_directors")
        val boardOfDirectors: List<Any?>?,
            @Json(name = "receiver_type")
        val receiverType: List<String?>?,
            @Json(name = "type")
        val type: List<Any?>?,
            @Json(name = "response_status")
        val responseStatus: Boolean?,
            @Json(name = "is_cron")
        val isCron: Boolean?,
            @Json(name = "cron_executed")
        val cronExecuted: Boolean?,
            @Json(name = "cron_response")
        val cronResponse: Boolean?,
            @Json(name = "is_deleted")
        val isDeleted: Boolean?,
            @Json(name = "_id")
        val id: String?,
            @Json(name = "sms_text")
            val smsText: String?,
            @Json(name = "sms_type")
            val smsType: String?,
            @Json(name = "sent_by_staff")
            val sentByStaff: SentByStaff?,
            @Json(name = "school_code")
            val schoolCode: String?,
            @Json(name = "year_session")
            val yearSession: String?,
            @Json(name = "mobiles")
            var mobiles: List<Mobile?> = ArrayList(),
            @Json(name = "created_at")
            val createdAt: String?,
            @Json(name = "__v")
            val v: Int?
    ) {
        @JsonClass(generateAdapter = true)
        data class TextLocalRes(
            @Json(name = "success")
            val success: List<Any?>?,
            @Json(name = "failure")
            val failure: List<Any?>?
        )

        @JsonClass(generateAdapter = true)
        data class SentByStaff(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "name")
            val name: String?
        )

        @JsonClass(generateAdapter = true)
        data class Mobile(
                @Json(name = "read_flag")
                var readFlag: Boolean = false,
                @Json(name = "number")
                val number: String?,
                @Json(name = "text")
                val text: String?,
                @Json(name = "student_id")
                val studentId: String?
        )
    }
}