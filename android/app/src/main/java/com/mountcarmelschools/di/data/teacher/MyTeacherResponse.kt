package com.mountcarmelschools.di.data.teacher


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class MyTeacherResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "class")
    val classX: Class?,
    @Json(name = "subjects")
    val subjects: List<Subject?>?,
    @Json(name = "house")
    val house: House?,
    @Json(name = "path")
    val path: String?
) {
    @JsonClass(generateAdapter = true)
    data class Class(
        @Json(name = "_id")
        val _id: String?,
        @Json(name = "class_teacher_id")
        val classTeacherId: ClassTeacherId?,
        @Json(name = "helper_teacher_id")
        val helperTeacherID: HelperTeacherId,
        @Json(name = "id")
        val id: String?
    ) {
        @JsonClass(generateAdapter = true)
        data class ClassTeacherId(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "name")
            val name: String?,
            @Json(name = "profile_pic")
            val profilePic: String?
        )

        @JsonClass(generateAdapter = true)
        data class HelperTeacherId(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "name")
            val name: String?,
            @Json(name = "profile_pic")
            val profilePic: String?
        )
    }

    @JsonClass(generateAdapter = true)
    data class Subject(
        @Json(name = "is_subject_divide")
        val isSubjectDivide: String?,
        @Json(name = "subject_parts")
        val subjectParts: List<String?>?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "__v")
        val v: Int?,
        @Json(name = "order")
        val order: String?,
        @Json(name = "subject_name")
        val subjectName: String?,
        @Json(name = "subject_teacher_id")
        val subjectTeacherId: List<SubjectTeacherId?>?
    ) {
        @JsonClass(generateAdapter = true)
        data class SubjectTeacherId(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "staff_id")
            val staffId: StaffId?,
            @Json(name = "part_subject_name")
            val partSubjectName: String?
        ) {
            @JsonClass(generateAdapter = true)
            data class StaffId(
                @Json(name = "_id")
                val id: String?,
                @Json(name = "name")
                val name: String?,
                @Json(name = "profile_pic")
                val profilePic: String?
            )
        }
    }

    @JsonClass(generateAdapter = true)
    data class House(
        @Json(name = "house_incharge_id")
        val houseInchargeId: List<HouseInchargeId?>?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "house_no")
        val houseNo: String?
    ) {
        @JsonClass(generateAdapter = true)
        data class HouseInchargeId(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "name")
            val name: String?,
            @Json(name = "profile_pic")
            val profilePic: String?
        )
    }
}