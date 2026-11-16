package com.mountcarmelschools.di.data.login


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class LoginResponseFromApi(
    @Json(name = "menu")
    val menu: Menu?,
    @Json(name = "meta_data")
    val metaData: MetaData?,
    @Json(name = "path")
    val path: String?,
    @Json(name = "parent_path")
    val parent_path: String?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "user")
    val user: User?
) {
    @JsonClass(generateAdapter = true)
    data class Menu(
        @Json(name = "home_screen")
        val homeScreen: List<HomeScreen?>?,
        @Json(name = "side")
        val side: List<Side?>?
    ) {
        @JsonClass(generateAdapter = true)
        data class HomeScreen(
            @Json(name = "priority")
            val priority: Int?,
            @Json(name = "title")
            val title: String?
        )

        @JsonClass(generateAdapter = true)
        data class Side(
            @Json(name = "priority")
            val priority: Int?,
            @Json(name = "title")
            val title: String?
        )
    }

    @JsonClass(generateAdapter = true)
    data class MetaData(
        @Json(name = "branch_code")
        val branchCode: String?,
        @Json(name = "home_branch")
        val homeBranch: String?,
        @Json(name = "home_school_code")
        val homeSchoolCode: String?,
        @Json(name = "is_staff")
        val isStaff: Boolean?,
        @Json(name = "school")
        val school: String?,
        @Json(name = "school_code")
        val schoolCode: String?,
        @Json(name = "token")
        val token: String?,
        @Json(name = "year_session")
        val yearSession: String?,
        @Json(name = "staff_type")
        val staffType: String?

    )

    @JsonClass(generateAdapter = true)
    data class User(
        @Json(name = "access")
        val access: List<Acces?>?,
        @Json(name = "access_class")
        val accessClass: List<AccessClas?>?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "email")
        val email: String?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "is_staff")
        val isStaff: Boolean?,
        @Json(name = "mobile")
        val mobile: String?,
        @Json(name = "name")
        val name: String?,
        @Json(name = "new")
        val new: String?,
        @Json(name = "profile_pic")
        val profilePic: String?,
        @Json(name = "schools")
        val schools: List<School?>?,
        @Json(name = "staff_id")
        val staffId: StaffId?,
        @Json(name = "status")
        val status: Boolean?,
        @Json(name = "students")
        val students: List<Student?>?,
        @Json(name = "tokens")
        val tokens: List<Token?>?,
        @Json(name = "type")
        val type: String?,
        @Json(name = "type2")
        val type2: String?,
        @Json(name = "updated_at")
        val updatedAt: String?,
        @Json(name = "__v")
        val v: Int?,
        @Json(name = "years")
        val years: List<Year?>?
    ) {
        @JsonClass(generateAdapter = true)
        data class Acces(
            @Json(name = "module_name")
            val moduleName: String?
        )

        @JsonClass(generateAdapter = true)
        data class AccessClas(
            @Json(name = "_id")
            val _id: String?,
            @Json(name = "id")
            val id: String?,
            @Json(name = "school")
            val school: String?,
            @Json(name = "school_code")
            val schoolCode: String?,
            @Json(name = "section")
            val section: String?,
            @Json(name = "standard")
            val standard: String?
        )

        @JsonClass(generateAdapter = true)
        data class School(
            @Json(name = "branch_code")
            val branchCode: String?,
            @Json(name = "is_default")
            val isDefault: Boolean?,
            @Json(name = "school_code")
            val schoolCode: String?,
            @Json(name = "school_id")
            val schoolId: SchoolId?
        ) {
            @JsonClass(generateAdapter = true)
            data class SchoolId(
                @Json(name = "buildings")
                val buildings: List<Building?>?,
                @Json(name = "_id")
                val id: String?,
                @Json(name = "school_address")
                val schoolAddress: String?,
                @Json(name = "school_email")
                val schoolEmail: String?,
                @Json(name = "school_name")
                val schoolName: String?,
                @Json(name = "school_phone")
                val schoolPhone: String?
            ) {
                @JsonClass(generateAdapter = true)
                data class Building(
                    @Json(name = "building_id")
                    val buildingId: String?
                )
            }
        }

        @JsonClass(generateAdapter = true)
        data class StaffId(
            @Json(name = "address")
            val address: Address?,
            @Json(name = "branch_code")
            val branchCode: String?,
            @Json(name = "class_teacher_history")
            val classTeacherHistory: List<ClassTeacherHistory?>?,
            @Json(name = "created_at")
            val createdAt: String?,
            @Json(name = "date_of_anniversary")
            val dateOfAnniversary: String?,
            @Json(name = "date_of_birth")
            val dateOfBirth: String?,
            @Json(name = "date_of_joining")
            val dateOfJoining: String?,
            @Json(name = "department_id")
            val departmentId: DepartmentId?,
            @Json(name = "email")
            val email: String?,
            @Json(name = "emergency_mobile")
            val emergencyMobile: String?,
            @Json(name = "emergency_name")
            val emergencyName: String?,
            @Json(name = "employee_code")
            val employeeCode: String?,
            @Json(name = "have_students")
            val haveStudents: Boolean?,
            @Json(name = "helper_teacher_history")
            val helperTeacherHistory: List<Any?>?,
            @Json(name = "helper_teacher_id")
            val helperTeacherId: List<Any?>?,
            @Json(name = "house_incharge_history")
            val houseInchargeHistory: List<Any?>?,
            @Json(name = "house_teacher_history")
            val houseTeacherHistory: List<HouseTeacherHistory?>?,
            @Json(name = "_id")
            val id: String?,
            @Json(name = "is_class_teacher")
            val isClassTeacher: Boolean?,
            @Json(name = "is_deleted")
            val isDeleted: Boolean?,
            @Json(name = "is_helper_teacher")
            val isHelperTeacher: Boolean?,
            @Json(name = "is_house_incharge")
            val isHouseIncharge: Boolean?,
            @Json(name = "is_house_teacher")
            val isHouseTeacher: Boolean?,
            @Json(name = "is_teacher")
            val isTeacher: Boolean?,
            @Json(name = "is_transport")
            val isTransport: Boolean?,
            @Json(name = "mobile")
            val mobile: String?,
            @Json(name = "name")
            val name: String?,
            @Json(name = "phone")
            val phone: String?,
            @Json(name = "profile_pic")
            val profilePic: String?,
            @Json(name = "qualification")
            val qualification: String?,
            @Json(name = "school")
            val school: String?,
            @Json(name = "school_code")
            val schoolCode: String?,
            @Json(name = "schools")
            val schools: List<School?>?,
            @Json(name = "spouse_name")
            val spouseName: String?,
            @Json(name = "staff_type")
            val staffType: String?,
            @Json(name = "staff_upd")
            val staffUpd: Boolean?,
            @Json(name = "staffroom_id")
            val staffroomId: StaffroomId?,
            @Json(name = "status")
            val status: Boolean?,
            @Json(name = "students")
            val students: List<Any?>?,
            @Json(name = "updated_at")
            val updatedAt: String?,
            @Json(name = "__v")
            val v: Int?
        ) {
            @JsonClass(generateAdapter = true)
            data class Address(
                @Json(name = "city")
                val city: String?,
                @Json(name = "local_address")
                val localAddress: String?,
                @Json(name = "pincode")
                val pincode: String?
            )

            @JsonClass(generateAdapter = true)
            data class ClassTeacherHistory(
                @Json(name = "created_on")
                val createdOn: String?,
                @Json(name = "_id")
                val id: String?,
                @Json(name = "standard_section_id")
                val standardSectionId: String?,
                @Json(name = "updated_on")
                val updatedOn: String?
            )

            @JsonClass(generateAdapter = true)
            data class DepartmentId(
                @Json(name = "_id")
                val id: String?,
                @Json(name = "name")
                val name: String?
            )

            @JsonClass(generateAdapter = true)
            data class HouseTeacherHistory(
                @Json(name = "created_on")
                val createdOn: String?,
                @Json(name = "house_id")
                val houseId: String?,
                @Json(name = "_id")
                val id: String?,
                @Json(name = "updated_on")
                val updatedOn: String?
            )

            @JsonClass(generateAdapter = true)
            data class School(
                @Json(name = "access_modules")
                val accessModules: List<String?>?,
                @Json(name = "access_standard_section")
                val accessStandardSection: List<String?>?,
                @Json(name = "branch_code")
                val branchCode: String?,
                @Json(name = "group")
                val group: String?,
                @Json(name = "is_access")
                val isAccess: Boolean?,
                @Json(name = "school_code")
                val schoolCode: String?
            )

            @JsonClass(generateAdapter = true)
            data class StaffroomId(
                @Json(name = "_id")
                val id: String?,
                @Json(name = "room_no")
                val roomNo: String?
            )
        }

        @JsonClass(generateAdapter = true)
        data class Student(
            @Json(name = "admission_no")
            val admissionNo: String?,
            @Json(name = "student_id")
            val studentId: StudentId?,
            @Json(name = "year_session")
            val yearSession: String?
        ) {
            @JsonClass(generateAdapter = true)
            data class StudentId(
                @Json(name = "admission_no")
                val admissionNo: String?,
                @Json(name = "email")
                val email: String?,
                @Json(name = "_id")
                val id: String?,
                @Json(name = "name")
                var name: String?,
                @Json(name = "profile_pic")
                val profilePic: String?,
                @Json(name = "section_id")
                val sectionId: SectionId?,
                @Json(name = "sms_mobile")
                val smsMobile: String?,
                @Json(name = "standard_id")
                val standardId: StandardId?,
                @Json(name = "standard_section_id")
                val standardSectionId: StandardSectionId?,
                @Json(name = "studentImg")
                val studentImg: String?,
                @Json(name = "school_type")
                val school_type: String?,
                @Json(name = "year_branch")
                val year_branch: Int?
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
        data class Token(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "platform")
            val platform: String?,
            @Json(name = "token")
            val token: String?
        )

        @JsonClass(generateAdapter = true)
        data class Year(
            @Json(name = "is_default")
            val isDefault: Boolean?,
            @Json(name = "year_session")
            val yearSession: String?
        )
    }
}