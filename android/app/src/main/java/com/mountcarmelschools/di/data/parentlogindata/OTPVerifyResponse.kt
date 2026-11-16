package com.mountcarmelschools.di.data.parentlogindata

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class OTPVerifyResponse(
        @Json(name = "status")
        val status: Boolean? = null,
        @Json(name = "meta_data")
        val metaData: MetaData? = null,
        @Json(name = "user")
        val user: User? = null,
        @Json(name = "path")
        val path: String? = null,
        @Json(name = "message")
        val message: String?,
        @Json(name = "parent_path")
        val parentPath: String? = null) {
    @JsonClass(generateAdapter = true)
    data class User(
            @Json(name = "is_staff")
            val isStaff: Boolean? = null,
            @Json(name = "access")
            val access: List<Any>? = null,
            @Json(name = "access_class")
            val accessClass: List<Any>? = null,
            @Json(name = "status")
            val status: Boolean? = null,
            @Json(name = "is_deleted")
            val isDeleted: Boolean? = null,
            @Json(name = "_id") val id: String? = null,
            @Json(name = "name") val name: String? = null,
            @Json(name = "email") val email: String? = null,
            @Json(name = "students") val students: List<Student>? = null,
            @Json(name = "type") val type: String? = null,
            @Json(name = "mobile") val mobile: String? = null,
            @Json(name = "schools") val schools: List<School>? = null,
            @Json(name = "years") val years: List<Year>? = null,
            @Json(name = "tokens") val tokens: List<Token>? = null,
            @Json(name = "profile_pic") val profilePic: String? = null,
            @Json(name = "new") val _new: String? = null,
            @Json(name = "password") val password: String? = null,
            @Json(name = "created_at") val createdAt: String? = null,
            @Json(name = "updated_at") val updatedAt: String? = null,
            @Json(name = "updated_id") val updatedId: Boolean? = null,
            @Json(name = "__v") val v: Int? = null,
            @Json(name = "branches") val branches: List<Any>? = null,
            @Json(name = "last_active") val lastActive: String? = null
    ) {
        @JsonClass(generateAdapter = true)
        data class Student(@Json(name = "student_id")
                           val studentId: String? = null,

                           @Json(name = "year_session")
                           val yearSession: String? = null,

                           @Json(name = "admission_no")
                           val admissionNo: String? = null)

        @JsonClass(generateAdapter = true)
        data class School(@Json(name = "is_default")
                          val isDefault: Boolean? = null,

                          @Json(name = "branch_code")
                          val branchCode: Int? = null,

                          @Json(name = "school_code")
                          val schoolCode: String? = null,

                          @Json(name = "school_id")
                          val schoolId: String? = null)

        @JsonClass(generateAdapter = true)
        data class Year(@Json(name = "is_default")
                        val isDefault: Boolean? = null,

                        @Json(name = "year_session")
                        val yearSession: String? = null)

        @JsonClass(generateAdapter = true)
        data class Token(
                @Json(name = "platform")
                val platform: String? = null,
                @Json(name = "_id")
                val id: String? = null,
                @Json(name = "token")
                val token: String? = null)
    }

    @JsonClass(generateAdapter = true)
    data class MetaData(@Json(name = "token")
                        val token: String? = null,

                        @Json(name = "school_code")
                        val schoolCode: String? = null,

                        @Json(name = "branch_code")
                        val branchCode: Int? = null,

                        @Json(name = "home_branch")
                        val homeBranch: Int? = null,

                        @Json(name = "home_school_code")
                        val homeSchoolCode: String? = null,

                        @Json(name = "year_session")
                        val yearSession: String? = null,

                        @Json(name = "is_staff")
                        val isStaff: Boolean? = null,

                        @Json(name = "school")
                        val school: String? = null,

                        @Json(name = "school_type")
                        val schoolType: String? = null,

                        @Json(name = "years")
                        val years: List<String>? = null,

                        @Json(name = "schools")
                        val schools: List<Any>? = null,

                        @Json(name = "staff_type")
                        val staffType: String? = null
    )


}