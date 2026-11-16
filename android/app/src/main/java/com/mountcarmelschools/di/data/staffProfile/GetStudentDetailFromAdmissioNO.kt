package com.mountcarmelschools.di.data.staffProfile


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class GetStudentDetailFromAdmissioNO(
    @Json(name = "data")
    val `data`: Data?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "status")
    val status: Boolean?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "admission_no")
        val admissionNo: String?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "name")
        val name: String?,
        @Json(name = "school_code")
        val schoolCode: String?,
        @Json(name = "school_type")
        val schoolType: String?,
        @Json(name = "section_id")
        val sectionId: SectionId?,
        @Json(name = "siblings")
        val siblings: List<Sibling?>?,
        @Json(name = "standard_id")
        val standardId: StandardId?,
        @Json(name = "standard_section_id")
        val standardSectionId: StandardSectionId?,
        @Json(name = "year_session")
        val yearSession: String?
    ) {
        @JsonClass(generateAdapter = true)
        data class SectionId(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "name")
            val name: String?
        )

        @JsonClass(generateAdapter = true)
        data class Sibling(
            @Json(name = "admission_no")
            val admissionNo: String?,
            @Json(name = "sibling_id")
            val siblingId: SiblingId?
        ) {
            @JsonClass(generateAdapter = true)
            data class SiblingId(
                @Json(name = "admission_no")
                val admissionNo: String?,
                @Json(name = "_id")
                val id: String?,
                @Json(name = "name")
                val name: String?,
                @Json(name = "school_code")
                val schoolCode: String?,
                @Json(name = "school_type")
                val schoolType: String?,
                @Json(name = "section_id")
                val sectionId: SectionId?,
                @Json(name = "standard_id")
                val standardId: StandardId?,
                @Json(name = "standard_section_id")
                val standardSectionId: StandardSectionId?,
                @Json(name = "year_session")
                val yearSession: String?
            ) {
                @JsonClass(generateAdapter = true)
                data class SectionId(
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "name")
                    val name: String?
                )

                @JsonClass(generateAdapter = true)
                data class StandardId(
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "name")
                    val name: String?
                )

                @JsonClass(generateAdapter = true)
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
        }

        @JsonClass(generateAdapter = true)
        data class StandardId(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "name")
            val name: String?
        )

        @JsonClass(generateAdapter = true)
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
}