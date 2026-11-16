package com.mountcarmelschools.di.data.student


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class StudentMessageResponse(
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
        val staffs: List<Any?>?,
        @Json(name = "students")
        val students: List<Any?>?,
        @Json(name = "alumnies")
        val alumnies: List<Any?>?,
        @Json(name = "board_of_directors")
        val boardOfDirectors: List<Any?>?,
        @Json(name = "receiver_type")
        val receiverType: List<String?>?,
        @Json(name = "type")
        val type: List<String?>?,
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
        @Json(name = "student_id")
        val studentId: StudentId?,
        @Json(name = "sent_by_staff")
        val sentByStaff: Any?,
        @Json(name = "sms_type")
        val smsType: String?,
        @Json(name = "school_code")
        val schoolCode: String?,
        @Json(name = "year_session")
        val yearSession: String?,
        @Json(name = "mobile_no")
        val mobileNo: Long?,
        @Json(name = "read_flag")
        val readFlag: Boolean?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "mobiles")
        val mobiles: List<Mobile?>?,
        @Json(name = "__v")
        val v: Int?,
        @Json(name = "cron_time")
        val cronTime: String?
    ) {
        @JsonClass(generateAdapter = true)
        data class TextLocalRes(
            @Json(name = "success")
            val success: List<String?>?,
            @Json(name = "failure")
            val failure: List<Any?>?
        )

        @JsonClass(generateAdapter = true)
        data class StudentId(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "admission_no")
            val admissionNo: String?,
            @Json(name = "name")
            val name: String?
        )

        @JsonClass(generateAdapter = true)
        data class Mobile(
            @Json(name = "number")
            val number: String?,
            @Json(name = "text")
            val text: String?,
            @Json(name = "student_id")
            val studentId: String?
        )
    }
}