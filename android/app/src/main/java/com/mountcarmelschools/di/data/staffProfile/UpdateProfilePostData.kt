package com.mountcarmelschools.di.data.staffProfile


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class UpdateProfilePostData(
    @Json(name = "address")
    val address: Address?,
    @Json(name = "child_admission_no")
    val childAdmissionNo: Any?,
    @Json(name = "city")
    val city: String?,
    @Json(name = "date_of_anniversary")
    val dateOfAnniversary: Any?,
    @Json(name = "date_of_birth")
    val dateOfBirth: String?,
    @Json(name = "date_of_joining")
    val dateOfJoining: String?,
    @Json(name = "department_id")
    val departmentId: DepartmentId?,
    @Json(name = "emergency_mobile")
    val emergencyMobile: String?,
    @Json(name = "emergency_name")
    val emergencyName: String?,
    @Json(name = "have_students")
    val haveStudents: Boolean?,
    @Json(name = "local_address")
    val localAddress: String?,
    @Json(name = "mobile")
    val mobile: String?,
    @Json(name = "pincode")
    val pincode: String?,
    @Json(name = "qualification")
    val qualification: String?,
    @Json(name = "spouse_name")
    val spouseName: String?,
    @Json(name = "staffroom_id")
    val staffroomId: StaffroomId?,
    @Json(name = "students")
    val students: List<Student?>?,
    @Json(name = "update_child_details")
    val updateChildDetails: Boolean?
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
    data class DepartmentId(
        @Json(name = "_id")
        val id: String?,
        @Json(name = "name")
        val name: String?
    )

    @JsonClass(generateAdapter = true)
    data class StaffroomId(
        @Json(name = "_id")
        val id: String?,
        @Json(name = "room_no")
        val roomNo: String?
    )

    @JsonClass(generateAdapter = true)
    data class Student(
        @Json(name = "admission_no")
        val admissionNo: String?,
        @Json(name = "student_id")
        val studentId: String?
    )
}