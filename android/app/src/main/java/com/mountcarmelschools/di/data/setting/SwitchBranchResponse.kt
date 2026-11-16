package com.mountcarmelschools.di.data.setting


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class SwitchBranchResponse(
    @Json(name = "menu")
    val menu: Menu?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "meta_data")
    val metaData: MetaData?,
    @Json(name = "path")
    val path: String?,
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
        val branchCode: Int?,
        @Json(name = "home_branch")
        val homeBranch: Int?,
        @Json(name = "home_school_code")
        val homeSchoolCode: String?,
        @Json(name = "is_staff")
        val isStaff: Boolean?,
        @Json(name = "school")
        val school: String?,
        @Json(name = "school_code")
        val schoolCode: String?,
        @Json(name = "school_type")
        val schoolType: String?,
        @Json(name = "schools")
        val schools: List<School?>?,
        @Json(name = "staff_type")
        val staffType: String?,
        @Json(name = "token")
        val token: String?,
        @Json(name = "year_session")
        val yearSession: String?,
        @Json(name = "years")
        val years: List<String?>?
    ) {
        @JsonClass(generateAdapter = true)
        data class School(
            @Json(name = "branch_code")
            val branchCode: Int?,
            @Json(name = "school_code")
            val schoolCode: String?
        )
    }

    @JsonClass(generateAdapter = true)
    data class User(
        @Json(name = "access")
        val access: List<Acces?>?,
        @Json(name = "access_class")
        val accessClass: List<AccessClas?>?,
        @Json(name = "branches")
        val branches: List<Any?>?,
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
        @Json(name = "last_active")
        val lastActive: String?,
        @Json(name = "mobile")
        val mobile: String?,
        @Json(name = "name")
        val name: String?,
        @Json(name = "new")
        val new: String?,
        @Json(name = "password")
        val password: String?,
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
            @Json(name = "section_id")
            val sectionId: String?,
            @Json(name = "standard")
            val standard: String?,
            @Json(name = "standard_id")
            val standardId: String?
        )

        @JsonClass(generateAdapter = true)
        data class School(
            @Json(name = "branch_code")
            val branchCode: Int?,
            @Json(name = "is_default")
            val isDefault: Boolean?,
            @Json(name = "school_code")
            val schoolCode: String?,
            @Json(name = "school_id")
            val schoolId: String?
        )

        @JsonClass(generateAdapter = true)
        data class StaffId(
            @Json(name = "access_year_session")
            val accessYearSession: List<String?>?,
            @Json(name = "address")
            val address: Address?,
            @Json(name = "branch_code")
            val branchCode: Int?,
            @Json(name = "class_teacher_history")
            val classTeacherHistory: List<ClassTeacherHistory?>?,
            @Json(name = "class_teacher_id")
            val classTeacherId: Any?,
            @Json(name = "created_at")
            val createdAt: String?,
            @Json(name = "current_category")
            val currentCategory: String?,
            @Json(name = "date_of_anniversary")
            val dateOfAnniversary: Any?,
            @Json(name = "date_of_birth")
            val dateOfBirth: String?,
            @Json(name = "date_of_joining")
            val dateOfJoining: String?,
            @Json(name = "date_of_promotion")
            val dateOfPromotion: String?,
            @Json(name = "default_year_session")
            val defaultYearSession: String?,
            @Json(name = "department_id")
            val departmentId: String?,
            @Json(name = "device_ids")
            val deviceIds: List<String?>?,
            @Json(name = "email")
            val email: String?,
            @Json(name = "emergency_mobile")
            val emergencyMobile: String?,
            @Json(name = "emergency_name")
            val emergencyName: String?,
            @Json(name = "employee_code")
            val employeeCode: String?,
            @Json(name = "father_name")
            val fatherName: String?,
            @Json(name = "have_students")
            val haveStudents: Boolean?,
            @Json(name = "helper_teacher_history")
            val helperTeacherHistory: List<HelperTeacherHistory?>?,
            @Json(name = "helper_teacher_id")
            val helperTeacherId: List<Any?>?,
            @Json(name = "house_incharge_history")
            val houseInchargeHistory: List<HouseInchargeHistory?>?,
            @Json(name = "house_incharge_id")
            val houseInchargeId: Any?,
            @Json(name = "house_teacher_history")
            val houseTeacherHistory: List<HouseTeacherHistory?>?,
            @Json(name = "_id")
            val id: String?,
            @Json(name = "initial_category")
            val initialCategory: String?,
            @Json(name = "is_child_studying")
            val isChildStudying: Boolean?,
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
            @Json(name = "pay_scale")
            val payScale: String?,
            @Json(name = "phone")
            val phone: String?,
            @Json(name = "profile_pic")
            val profilePic: String?,
            @Json(name = "qualification")
            val qualification: String?,
            @Json(name = "roles")
            val roles: List<Any?>?,
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
            val staffroomId: String?,
            @Json(name = "status")
            val status: Boolean?,
            @Json(name = "students")
            val students: List<Any?>?,
            @Json(name = "transport_bill_id")
            val transportBillId: String?,
            @Json(name = "transport_id")
            val transportId: String?,
            @Json(name = "updated_at")
            val updatedAt: String?,
            @Json(name = "__v")
            val v: Int?,
            @Json(name = "years")
            val years: List<Year?>?,
            @Json(name = "years_locked")
            val yearsLocked: List<YearsLocked?>?
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
            data class HelperTeacherHistory(
                @Json(name = "created_on")
                val createdOn: String?,
                @Json(name = "_id")
                val id: String?,
                @Json(name = "standard_section_id")
                val standardSectionId: List<String?>?,
                @Json(name = "updated_on")
                val updatedOn: String?
            )

            @JsonClass(generateAdapter = true)
            data class HouseInchargeHistory(
                @Json(name = "created_on")
                val createdOn: String?,
                @Json(name = "_id")
                val id: String?,
                @Json(name = "updated_on")
                val updatedOn: String?
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
                val branchCode: Int?,
                @Json(name = "group")
                val group: String?,
                @Json(name = "is_access")
                val isAccess: Boolean?,
                @Json(name = "school_code")
                val schoolCode: String?
            )

            @JsonClass(generateAdapter = true)
            data class Year(
                @Json(name = "branch_code")
                val branchCode: Int?,
                @Json(name = "employee_code")
                val employeeCode: String?,
                @Json(name = "is_teacher")
                val isTeacher: Boolean?,
                @Json(name = "schools")
                val schools: List<School?>?,
                @Json(name = "staff_type")
                val staffType: String?,
                @Json(name = "year_session")
                val yearSession: String?
            ) {
                @JsonClass(generateAdapter = true)
                data class School(
                    @Json(name = "access_modules")
                    val accessModules: List<String?>?,
                    @Json(name = "access_standard_section")
                    val accessStandardSection: List<String?>?,
                    @Json(name = "branch_code")
                    val branchCode: Int?,
                    @Json(name = "group")
                    val group: String?,
                    @Json(name = "is_access")
                    val isAccess: Boolean?,
                    @Json(name = "school_code")
                    val schoolCode: String?
                )
            }

            @JsonClass(generateAdapter = true)
            data class YearsLocked(
                @Json(name = "access_year_session")
                val accessYearSession: Any?,
                @Json(name = "address")
                val address: Address?,
                @Json(name = "branch_code")
                val branchCode: Int?,
                @Json(name = "class_teacher_history")
                val classTeacherHistory: List<ClassTeacherHistory?>?,
                @Json(name = "class_teacher_id")
                val classTeacherId: Any?,
                @Json(name = "current_category")
                val currentCategory: String?,
                @Json(name = "date_of_anniversary")
                val dateOfAnniversary: Any?,
                @Json(name = "date_of_birth")
                val dateOfBirth: String?,
                @Json(name = "date_of_joining")
                val dateOfJoining: String?,
                @Json(name = "date_of_promotion")
                val dateOfPromotion: String?,
                @Json(name = "department_id")
                val departmentId: String?,
                @Json(name = "email")
                val email: String?,
                @Json(name = "emergency_mobile")
                val emergencyMobile: String?,
                @Json(name = "emergency_name")
                val emergencyName: String?,
                @Json(name = "employee_code")
                val employeeCode: String?,
                @Json(name = "father_name")
                val fatherName: String?,
                @Json(name = "have_students")
                val haveStudents: Boolean?,
                @Json(name = "helper_teacher_history")
                val helperTeacherHistory: List<HelperTeacherHistory?>?,
                @Json(name = "helper_teacher_id")
                val helperTeacherId: Any?,
                @Json(name = "house_incharge_history")
                val houseInchargeHistory: List<HouseInchargeHistory?>?,
                @Json(name = "house_incharge_id")
                val houseInchargeId: Any?,
                @Json(name = "initial_category")
                val initialCategory: String?,
                @Json(name = "is_class_teacher")
                val isClassTeacher: Boolean?,
                @Json(name = "is_helper_teacher")
                val isHelperTeacher: Boolean?,
                @Json(name = "is_house_incharge")
                val isHouseIncharge: Boolean?,
                @Json(name = "is_teacher")
                val isTeacher: Boolean?,
                @Json(name = "is_transport")
                val isTransport: Boolean?,
                @Json(name = "mobile")
                val mobile: String?,
                @Json(name = "name")
                val name: String?,
                @Json(name = "pay_scale")
                val payScale: String?,
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
                @Json(name = "school_note")
                val schoolNote: Any?,
                @Json(name = "schools")
                val schools: List<School?>?,
                @Json(name = "spouse_name")
                val spouseName: String?,
                @Json(name = "staff_type")
                val staffType: String?,
                @Json(name = "staffroom_id")
                val staffroomId: String?,
                @Json(name = "students")
                val students: List<Any?>?,
                @Json(name = "transport_id")
                val transportId: Any?,
                @Json(name = "year_session")
                val yearSession: String?
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
                data class HelperTeacherHistory(
                    @Json(name = "created_on")
                    val createdOn: String?,
                    @Json(name = "_id")
                    val id: String?,
                    @Json(name = "standard_section_id")
                    val standardSectionId: List<String?>?,
                    @Json(name = "updated_on")
                    val updatedOn: String?
                )

                @JsonClass(generateAdapter = true)
                data class HouseInchargeHistory(
                    @Json(name = "created_on")
                    val createdOn: String?,
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
                    val branchCode: Int?,
                    @Json(name = "group")
                    val group: String?,
                    @Json(name = "is_access")
                    val isAccess: Boolean?,
                    @Json(name = "school_code")
                    val schoolCode: String?
                )
            }
        }

        @JsonClass(generateAdapter = true)
        data class Student(
            @Json(name = "admission_no")
            val admissionNo: String?,
            @Json(name = "student_id")
            val studentId: String?,
            @Json(name = "year_session")
            val yearSession: String?
        )

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