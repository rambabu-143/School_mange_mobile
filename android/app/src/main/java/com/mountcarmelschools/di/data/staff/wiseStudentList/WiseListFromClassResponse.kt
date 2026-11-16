package com.mountcarmelschools.di.data.staff.wiseStudentList


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class WiseListFromClassResponse(
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
        @Json(name = "email")
        val email: String?,
        @Json(name = "gender")
        val gender: String?,
        @Json(name = "house_id")
        val houseId: HouseId?,
        @Json(name = "disciplinary")
        val disciplinary: Disciplinary?,
        @Json(name = "name")
        val name: String?,
        @Json(name = "profile_pic")
        val profilePic: String?,
        @Json(name = "sms_mobile")
        val smsMobile: String?,
        @Json(name = "standard_section_id")
        val standardSectionId: StandardSectionId?,
        @Json(name = "combo_id")
        val comboId: Any?
    ) {
        @JsonClass(generateAdapter = true)
        data class HouseId(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "house_no")
            val houseNo: String?
        )
        @JsonClass(generateAdapter = true)
        data class Disciplinary(
            @Json(name = "pink")
            val pink: String?,
            @Json(name = "yellow")
            val yellow: String?,
            @Json(name = "red")
            val red: String?
        )

        @JsonClass(generateAdapter = true)
        data class StandardSectionId(
            @Json(name = "_id")
            val _id: String?,
            @Json(name = "section")
            val section: String?,
            @Json(name = "standard")
            val standard: String?,
            @Json(name = "id")
            val id: String?
        )
    }
}