package com.mountcarmelschools.di.data.disciplinaryCard


import com.squareup.moshi.Json

data class DisciplinaryCardResponse(
    @Json(name = "data")
    val `data`: Data?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "student")
    val student: Student?
) {
    data class Data(
        @Json(name = "pink")
        val pink: Pink?,
        @Json(name = "red")
        val red: Red?,
        @Json(name = "yellow")
        val yellow: Yellow?
    ) {
        data class Pink(
            @Json(name = "count")
            val count: Int?,
            @Json(name = "data")
            val `data`: List<Data?>?
        ) {
            data class Data(
                @Json(name = "action_taken")
                val actionTaken: String?,
                @Json(name = "admission_no")
                val admissionNo: String?,
                @Json(name = "branch_code")
                val branchCode: Int?,
                @Json(name = "created_at")
                val createdAt: String?,
                @Json(name = "house_point")
                val housePoint: Int?,
                @Json(name = "_id")
                val id: String?,
                @Json(name = "is_deleted")
                val isDeleted: Boolean?,
                @Json(name = "issue_date")
                val issueDate: String?,
                @Json(name = "pink")
                val pink: Int?,
                @Json(name = "reason")
                val reason: String?,
                @Json(name = "reason_other")
                val reasonOther: String?,
                @Json(name = "red")
                val red: Int?,
                @Json(name = "school_code")
                val schoolCode: String?,
                @Json(name = "staff_id")
                val staffId: StaffId?,
                @Json(name = "student_id")
                val studentId: StudentId?,
                @Json(name = "updated_at")
                val updatedAt: String?,
                @Json(name = "__v")
                val v: Int?,
                @Json(name = "year_session")
                val yearSession: String?,
                @Json(name = "yellow")
                val yellow: Int?
            ) {
                data class StaffId(
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "name")
                    val name: String?
                )

                data class StudentId(
                    @Json(name = "admission_no")
                    val admissionNo: String?,
                    @Json(name = "house_id")
                    val houseId: HouseId?,
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "name")
                    val name: String?,
                    @Json(name = "standard_section_id")
                    val standardSectionId: StandardSectionId?
                ) {
                    data class HouseId(
                        @Json(name = "house_no")
                        val houseNo: String?,
                        @Json(name = "_id")
                        val id: String?
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
            }
        }

        data class Red(
            @Json(name = "count")
            val count: Int?,
            @Json(name = "data")
            val `data`: List<Data?>?
        ) {
            data class Data(
                @Json(name = "action_taken")
                val actionTaken: String?,
                @Json(name = "admission_no")
                val admissionNo: String?,
                @Json(name = "branch_code")
                val branchCode: Int?,
                @Json(name = "created_at")
                val createdAt: String?,
                @Json(name = "house_point")
                val housePoint: Int?,
                @Json(name = "_id")
                val id: String?,
                @Json(name = "is_deleted")
                val isDeleted: Boolean?,
                @Json(name = "issue_date")
                val issueDate: String?,
                @Json(name = "pink")
                val pink: Int?,
                @Json(name = "reason")
                val reason: String?,
                @Json(name = "reason_other")
                val reasonOther: String?,
                @Json(name = "red")
                val red: Int?,
                @Json(name = "school_code")
                val schoolCode: String?,
                @Json(name = "staff_id")
                val staffId: StaffId?,
                @Json(name = "student_id")
                val studentId: StudentId?,
                @Json(name = "updated_at")
                val updatedAt: String?,
                @Json(name = "__v")
                val v: Int?,
                @Json(name = "year_session")
                val yearSession: String?,
                @Json(name = "yellow")
                val yellow: Int?
            ) {
                data class StaffId(
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "name")
                    val name: String?
                )

                data class StudentId(
                    @Json(name = "admission_no")
                    val admissionNo: String?,
                    @Json(name = "house_id")
                    val houseId: HouseId?,
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "name")
                    val name: String?,
                    @Json(name = "standard_section_id")
                    val standardSectionId: StandardSectionId?
                ) {
                    data class HouseId(
                        @Json(name = "house_no")
                        val houseNo: String?,
                        @Json(name = "_id")
                        val id: String?
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
            }
        }

        data class Yellow(
            @Json(name = "count")
            val count: Int?,
            @Json(name = "data")
            val `data`: List<Data?>?
        ) {
            data class Data(
                @Json(name = "action_taken")
                val actionTaken: String?,
                @Json(name = "admission_no")
                val admissionNo: String?,
                @Json(name = "branch_code")
                val branchCode: Int?,
                @Json(name = "created_at")
                val createdAt: String?,
                @Json(name = "house_point")
                val housePoint: Int?,
                @Json(name = "_id")
                val id: String?,
                @Json(name = "is_deleted")
                val isDeleted: Boolean?,
                @Json(name = "issue_date")
                val issueDate: String?,
                @Json(name = "pink")
                val pink: Int?,
                @Json(name = "reason")
                val reason: String?,
                @Json(name = "reason_other")
                val reasonOther: String?,
                @Json(name = "red")
                val red: Int?,
                @Json(name = "school_code")
                val schoolCode: String?,
                @Json(name = "staff_id")
                val staffId: StaffId?,
                @Json(name = "student_id")
                val studentId: StudentId?,
                @Json(name = "updated_at")
                val updatedAt: String?,
                @Json(name = "__v")
                val v: Int?,
                @Json(name = "year_session")
                val yearSession: String?,
                @Json(name = "yellow")
                val yellow: Int?
            ) {
                data class StaffId(
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "name")
                    val name: String?
                )

                data class StudentId(
                    @Json(name = "admission_no")
                    val admissionNo: String?,
                    @Json(name = "house_id")
                    val houseId: HouseId?,
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "name")
                    val name: String?,
                    @Json(name = "standard_section_id")
                    val standardSectionId: StandardSectionId?
                ) {
                    data class HouseId(
                        @Json(name = "house_no")
                        val houseNo: String?,
                        @Json(name = "_id")
                        val id: String?
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
            }
        }
    }

    data class Student(
        @Json(name = "admission_no")
        val admissionNo: String?,
        @Json(name = "house_id")
        val houseId: String?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "name")
        val name: String?,
        @Json(name = "standard_section_id")
        val standardSectionId: StandardSectionId?
    ) {
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