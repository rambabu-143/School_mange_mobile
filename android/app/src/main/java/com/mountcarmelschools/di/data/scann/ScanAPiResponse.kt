package com.mountcarmelschools.di.data.scann


import com.squareup.moshi.Json

data class ScanAPiResponse(
    @Json(name = "data")
    val `data`: List<Data?>?,
    @Json(name = "disciplinary")
    val disciplinary: Disciplinary?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "path")
    val path: String?,
    @Json(name = "status")
    val status: Boolean?
) {
    data class Data(
        @Json(name = "achievement")
        val achievement: Achievement?,
        @Json(name = "admission_no")
        val admissionNo: String?,
        @Json(name = "email")
        val email: String?,
        @Json(name = "house_id")
        val houseId: HouseId?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "name")
        val name: String?,
        @Json(name = "prefect")
        val prefect: Prefect?,
        @Json(name = "profile_pic")
        val profilePic: String?,
        @Json(name = "relation")
        val relation: List<Relation?>?,
        @Json(name = "section_id")
        val sectionId: SectionId?,
        @Json(name = "sms_mobile")
        val smsMobile: String?,
        @Json(name = "special_needs")
        val specialNeeds: SpecialNeeds?,
        @Json(name = "standard_id")
        val standardId: StandardId?,
        @Json(name = "standard_section_id")
        val standardSectionId: StandardSectionId?
    ) {
        data class Achievement(
            @Json(name = "coscholastic")
            val coscholastic: List<Any?>?,
            @Json(name = "scholastic")
            val scholastic: String?
        )

        data class HouseId(
            @Json(name = "house_no")
            val houseNo: String?,
            @Json(name = "_id")
            val id: String?
        )

        data class Prefect(
            @Json(name = "prefect_post_id")
            val prefectPostId: String?,
            @Json(name = "value")
            val value: String?
        )

        data class Relation(
            @Json(name = "designation")
            val designation: String?,
            @Json(name = "email")
            val email: String?,
            @Json(name = "mobile")
            val mobile: String?,
            @Json(name = "name")
            val name: String?,
            @Json(name = "occupation_child_id")
            val occupationChildId: String?,
            @Json(name = "occupation_id")
            val occupationId: String?,
            @Json(name = "office_address")
            val officeAddress: String?,
            @Json(name = "office_phone")
            val officePhone: String?,
            @Json(name = "organization")
            val organization: String?,
            @Json(name = "pancard")
            val pancard: String?,
            @Json(name = "qualification_id")
            val qualificationId: String?,
            @Json(name = "relation")
            val relation: String?,
            @Json(name = "salutation")
            val salutation: String?,
            @Json(name = "title")
            val title: String?
        )

        data class SectionId(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "name")
            val name: String?
        )

        data class SpecialNeeds(
            @Json(name = "special_needs_id")
            val specialNeedsId: Any?,
            @Json(name = "value")
            val value: String?
        )

        data class StandardId(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "name")
            val name: String?
        )

        data class StandardSectionId(
            @Json(name = "_id")
            val _id: String?,
            @Json(name = "id")
            val id: String?,
            @Json(name = "section")
            val section: String?,
            @Json(name = "standard")
            val standard: String?
        )
    }

    data class Disciplinary(
        @Json(name = "red")
        val red: Int?,
        @Json(name = "tardy")
        val tardy: Int?,
        @Json(name = "warning")
        val warning: Int?
    )
}