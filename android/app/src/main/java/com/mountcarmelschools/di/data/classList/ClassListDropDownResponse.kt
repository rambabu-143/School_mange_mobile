package com.mountcarmelschools.di.data.classList


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class ClassListDropDownResponse(
        @Json(name = "status")
        val status: Boolean?,
        @Json(name = "message")
        val message: String?,
        @Json(name = "data")
        val `data`: List<Data?>?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
            @Json(name = "is_class_teacher")
            val isClassTeacher: Boolean?,
            @Json(name = "is_helper_teacher")
            val isHelperTeacher: Boolean?,
            @Json(name = "_id")
            val _id: String?,
            @Json(name = "standard")
            val standard: String?,
            @Json(name = "section")
            val section: String?,
            @Json(name = "branch_code")
            val branchCode: Int?,
            @Json(name = "standard_id")
            val standardId: StandardId?,
            @Json(name = "section_id")
            val sectionId: SectionId?,
            @Json(name = "created_at")
            val createdAt: String?,
            @Json(name = "class_teacher_history")
            val classTeacherHistory: List<ClassTeacherHistory?>?,
            @Json(name = "class_teacher_id")
            val classTeacherId: ClassTeacherId?,
            @Json(name = "helper_teacher_history")
            val helperTeacherHistory: List<HelperTeacherHistory?>?,
            @Json(name = "helper_teacher_id")
            val helperTeacherId: HelperTeacherId?,
            @Json(name = "id")
            val id: String?
    ) {
        @JsonClass(generateAdapter = true)
        data class StandardId(
                @Json(name = "_id")
                val id: String?,
                @Json(name = "name")
                val name: String?
        )

        @JsonClass(generateAdapter = true)
        data class SectionId(
                @Json(name = "_id")
                val id: String?,
                @Json(name = "name")
                val name: String?
        )

        @JsonClass(generateAdapter = true)
        data class ClassTeacherHistory(
                @Json(name = "created_on")
                val createdOn: String?,
                @Json(name = "updated_on")
                val updatedOn: String?,
                @Json(name = "_id")
                val id: String?,
                @Json(name = "class_teacher_id")
                val classTeacherId: String?
        )

        @JsonClass(generateAdapter = true)
        data class ClassTeacherId(
                @Json(name = "_id")
                val id: String?,
                @Json(name = "name")
                val name: String?
        )

        @JsonClass(generateAdapter = true)
        data class HelperTeacherHistory(
                @Json(name = "created_on")
                val createdOn: String?,
                @Json(name = "updated_on")
                val updatedOn: String?,
                @Json(name = "_id")
                val id: String?,
                @Json(name = "helper_teacher_id")
                val helperTeacherId: String?
        )

        @JsonClass(generateAdapter = true)
        data class HelperTeacherId(
                @Json(name = "_id")
                val id: String?,
                @Json(name = "name")
                val name: String?
        )
    }
}