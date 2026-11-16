package com.mountcarmelschools.di.data.staff.assignHomework

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class StandardSectionListResponse (
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "data")
    val data: List<StandardSectionData>?
) {
    @JsonClass(generateAdapter = true)
    data class StandardSectionData(
        @Json(name = "is_class_teacher")
        val isClassTeacher: Boolean?,
        @Json(name = "is_helper_teacher")
        val isHelperTeacher: Boolean?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "standard")
        val standard: String?,
        @Json(name = "section")
        val section: String?,
        @Json(name = "branch_code")
        val branchCode: Int?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "standard_id")
        val standardId: IDName?,
        @Json(name = "section_id")
        val sectionId: IDName?,
        @Json(name = "class_teacher_id")
        val classTeacherId: IDName?,
        @Json(name = "helper_teacher_id")
        val helperTeacherId: IDName?,
    ) {
        @JsonClass(generateAdapter = true)
        data class IDName (
            @Json(name = "_id")
            val id: String?,
            @Json(name = "name")
            val name: String?
        )
    }
}
