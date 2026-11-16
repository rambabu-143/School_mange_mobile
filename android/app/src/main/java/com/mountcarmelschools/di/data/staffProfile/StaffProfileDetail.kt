package com.mountcarmelschools.di.data.staffProfile


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class StaffProfileDetail(
    @Json(name = "status") val status: Boolean?,
    @Json(name = "token_expired") val token_expired: Boolean?,
    @Json(name = "message") val message: String?,
    @Json(name = "data") val `data`: Data?,
    @Json(name = "path") val path: String?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "address") val address: Address?,
        @Json(name = "spouse_name") val spouseName: String?,
        @Json(name = "emergency_mobile") val emergencyMobile: String?,
        @Json(name = "emergency_name") val emergencyName: String?,
        @Json(name = "employee_code") val employeeCode: String?,
        @Json(name = "default_year_session") val defaultYearSession: String?,
        @Json(name = "phone") val phone: String?,
        @Json(name = "qualification") val qualification: String?,
        @Json(name = "is_class_teacher") val isClassTeacher: Boolean?,
        @Json(name = "is_helper_teacher") val isHelperTeacher: Boolean?,
        @Json(name = "helper_teacher_id") val helperTeacherId: List<Any?>?,
        @Json(name = "is_house_incharge") val isHouseIncharge: Boolean?,
        @Json(name = "is_teacher") val isTeacher: Boolean?,
        @Json(name = "have_students") val haveStudents: Boolean?,
        @Json(name = "is_transport") val isTransport: Boolean?,
        @Json(name = "status") val status: Boolean?,
        @Json(name = "is_deleted") val isDeleted: Boolean?,
        @Json(name = "_id") val id: String?,
        @Json(name = "__v") val v: Int?,
        @Json(name = "branch_code") val branchCode: String?,
        @Json(name = "class_teacher_history") val classTeacherHistory: List<ClassTeacherHistory?>?,
        @Json(name = "created_at") val createdAt: String?,
        @Json(name = "date_of_anniversary") val dateOfAnniversary: String?,
        @Json(name = "date_of_birth") val dateOfBirth: String?,
        @Json(name = "date_of_joining") val dateOfJoining: String?,
        @Json(name = "department_id") val departmentId: DepartmentId?,
        @Json(name = "email") val email: String?,
        @Json(name = "house_teacher_history") val houseTeacherHistory: List<HouseTeacherHistory?>?,
        @Json(name = "is_house_teacher") val isHouseTeacher: Boolean?,
        @Json(name = "mobile") val mobile: String?,
        @Json(name = "name") val name: String?,
        @Json(name = "profile_pic") val profilePic: String?,
        @Json(name = "school") val school: String?,
        @Json(name = "school_code") val schoolCode: String?,
        @Json(name = "schools") val schools: List<School?>?,
        @Json(name = "staff_type") val staffType: String?,
        @Json(name = "staff_upd") val staffUpd: Boolean?,
        @Json(name = "staffroom_id") val staffroomId: StaffroomId?,
        @Json(name = "updated_at") val updatedAt: String?,
        @Json(name = "students") val students: List<Student?>?,
        @Json(name = "helper_teacher_history") val helperTeacherHistory: List<Any?>?,
        @Json(name = "house_incharge_history") val houseInchargeHistory: List<Any?>?,
        @Json(name = "years") val years: List<Year?>?,
        @Json(name = "transport_bill_id") val transportBillId: TransportBillId?,
        @Json(name = "transport_id") val transportId: TransportId?
    ) {
        @JsonClass(generateAdapter = true)
        data class Address(
            @Json(name = "local_address") val localAddress: String?,
            @Json(name = "pincode") val pincode: String?,
            @Json(name = "city") val city: String?
        )

        @JsonClass(generateAdapter = true)
        data class ClassTeacherHistory(
            @Json(name = "created_on") val createdOn: String?,
            @Json(name = "updated_on") val updatedOn: String?,
            @Json(name = "_id") val id: String?,
            @Json(name = "standard_section_id") val standardSectionId: String?
        )

        @JsonClass(generateAdapter = true)
        data class DepartmentId(
            @Json(name = "_id") val id: String?, @Json(name = "name") val name: String?
        )

        @JsonClass(generateAdapter = true)
        data class HouseTeacherHistory(
            @Json(name = "_id") val id: String?,
            @Json(name = "created_on") val createdOn: String?,
            @Json(name = "updated_on") val updatedOn: String?,
            @Json(name = "house_id") val houseId: String?
        )

        @JsonClass(generateAdapter = true)
        data class School(
            @Json(name = "is_access") val isAccess: Boolean?,
            @Json(name = "branch_code") val branchCode: String?,
            @Json(name = "access_modules") val accessModules: List<AccessModule?>?,
            @Json(name = "access_standard_section") val accessStandardSection: List<AccessStandardSection?>?,
            @Json(name = "group") val group: String?,
            @Json(name = "school_code") val schoolCode: String?
        ) {
            @JsonClass(generateAdapter = true)
            data class AccessModule(
                @Json(name = "_id") val id: String?, @Json(name = "label") val label: String?
            )

            @JsonClass(generateAdapter = true)
            data class AccessStandardSection(
                @Json(name = "_id") val _id: String?,
                @Json(name = "standard") val standard: String?,
                @Json(name = "section") val section: String?,
                @Json(name = "standard_id") val standardId: String?,
                @Json(name = "section_id") val sectionId: String?,
                @Json(name = "id") val id: String?
            )
        }

        @JsonClass(generateAdapter = true)
        data class StaffroomId(
            @Json(name = "_id") val id: String?, @Json(name = "room_no") val roomNo: String?
        )

        @JsonClass(generateAdapter = true)
        data class Student(
            @Json(name = "_id") val id: String?,
            @Json(name = "admission_no") val admissionNo: String?,
            @Json(name = "section_id") val sectionId: SectionId?,
            @Json(name = "email") val email: String?,
            @Json(name = "name") val name: String?,
            @Json(name = "profile_pic") val profilePic: String?,
            @Json(name = "sms_mobile") val smsMobile: String?,
            @Json(name = "student_id") val standardId: StandardId?,
            @Json(name = "year_session") val yearSession: String?,
            @Json(name = "school_type") val schoolType: String?
        ) {
            @JsonClass(generateAdapter = true)
            data class SectionId(
                @Json(name = "_id") val id: String?, @Json(name = "name") val name: String?
            )

            @JsonClass(generateAdapter = true)
            data class StandardId(
                @Json(name = "_id") val id: String?, @Json(name = "name") val name: String?
            )
        }

        @JsonClass(generateAdapter = true)
        data class Year(
            @Json(name = "employee_code") val employeeCode: String?,
            @Json(name = "schools") val schools: List<School?>?,
            @Json(name = "year_session") val yearSession: String?,
            @Json(name = "staff_type") val staffType: String?,
            @Json(name = "branch_code") val branchCode: String?
        ) {
            @JsonClass(generateAdapter = true)
            data class School(
                @Json(name = "is_access") val isAccess: Boolean?,
                @Json(name = "branch_code") val branchCode: String?,
                @Json(name = "access_modules") val accessModules: List<String?>?,
                @Json(name = "access_standard_section") val accessStandardSection: List<String?>?,
                @Json(name = "group") val group: String?,
                @Json(name = "school_code") val schoolCode: String?,
                @Json(name = "staff_type") val staffType: String?
            )
        }

        @JsonClass(generateAdapter = true)
        data class TransportBillId(
            @Json(name = "admission_no") val admissionNo: String,
            @Json(name = "busSecurity") val busSecurity: String,
            @Json(name = "busSecurityAmt") val busSecurityAmt: String,
            @Json(name = "class") val classX: String,
            @Json(name = "date") val date: String,
            @Json(name = "filepath") val filepath: String,
            @Json(name = "_id") val id: String,
            @Json(name = "installment") val installment: List<Installment>,
            @Json(name = "installmentNO") val installmentNO: String,
            @Json(name = "name") val name: String,
            @Json(name = "order") val order: Int,
            @Json(name = "payable") val payable: Int,
            @Json(name = "full_payment_received") val fullPaymentReceived: Boolean?,
            @Json(name = "payment_date") val paymentDate: String,
            @Json(name = "routeDetails") val routeDetails: List<RouteDetail>,
            @Json(name = "school_code") val schoolCode: String,
            @Json(name = "section") val section: String,
            @Json(name = "session") val session: String,
            @Json(name = "staffemail") val staffemail: String,
            @Json(name = "status") val status: String,
            @Json(name = "t_carry_forward_show") val tCarryForwardShow: Boolean,
            @Json(name = "time") val time: String,
            @Json(name = "totalMonth") val totalMonth: Int,
            @Json(name = "transportAry") val transportAry: List<Any>,
            @Json(name = "transport_entryId") val transportEntryId: String,
            @Json(name = "transport_for") val transportFor: String,
            @Json(name = "transport_total_amt") val transportTotalAmt: Int,
            @Json(name = "year_session") val yearSession: String
        ) {
            @JsonClass(generateAdapter = true)
            data class Installment(
                @Json(name = "amount") val amount: Int,
                @Json(name = "amount_payble") val amountPayble: Int,
                @Json(name = "cheq_no") val cheqNo: String,
                @Json(name = "date") val date: String,
                @Json(name = "docno") val docno: String,
                @Json(name = "inst_no") val instNo: String,
                @Json(name = "installment_type") val installmentType: String,
                @Json(name = "recdate") val recdate: String,
                @Json(name = "receipt") val receipt: String,
                @Json(name = "recived") val recived: String,
                @Json(name = "type") val type: String,
                @Json(name = "year_session") val yearSession: String
            )

            @JsonClass(generateAdapter = true)
            data class RouteDetail(

                @Json(name = "morningroute") val morningroute: String,
                @Json(name = "morningstop") val morningstop: String,
                @Json(name = "evening_slabname") val eveningSlabname: String,
                @Json(name = "eveningroute") val eveningroute: String,
                @Json(name = "eveningstop") val eveningstop: String,
                @Json(name = "morning_slabname") val morningSlabname: String,
                @Json(name = "transport_amt") val transportAmt: Int,
                @Json(name = "tamt") val tamt: Int,
                @Json(name = "mslabAmt") val mslabAmt: Int,
                @Json(name = "e_slabAmt") val eSlabAmt: Int,
                @Json(name = "formonth") val formonth: Int,

                )
        }

        @JsonClass(generateAdapter = true)
        data class TransportId(
            @Json(name = "_id") val id: String?,
            @Json(name = "routes_details") val routesDetails: List<RoutesDetail?>?
        ) {
            @JsonClass(generateAdapter = true)
            data class RoutesDetail(
                @Json(name = "_id") val id: String?,
                @Json(name = "m_route_id") val mRouteId: MRouteId?,
                @Json(name = "m_transport_route_stop_id") val mTransportRouteStopId: MTransportRouteStopId?,
                @Json(name = "m_month_from") val mMonthFrom: Int?,
                @Json(name = "m_month_to") val mMonthTo: Int?,
                @Json(name = "m_transport_slab_id") val mTransportSlabId: MTransportSlabId?,
                @Json(name = "e_route_id") val eRouteId: ERouteId?,
                @Json(name = "e_transport_route_stop_id") val eTransportRouteStopId: ETransportRouteStopId?,
                @Json(name = "e_month_from") val eMonthFrom: Int?,
                @Json(name = "e_month_to") val eMonthTo: Int?,
                @Json(name = "e_transport_slab_id") val eTransportSlabId: ETransportSlabId?
            ) {
                @JsonClass(generateAdapter = true)
                data class MRouteId(
                    @Json(name = "route_name") val routeName: String?
                )

                @JsonClass(generateAdapter = true)
                data class MTransportRouteStopId(
                    @Json(name = "stop_name") val stopName: String?
                )

                @JsonClass(generateAdapter = true)
                data class MTransportSlabId(
                    @Json(name = "slab_name") val slabName: String?
                )

                @JsonClass(generateAdapter = true)
                data class ERouteId(
                    @Json(name = "route_name") val routeName: String?
                )

                @JsonClass(generateAdapter = true)
                data class ETransportRouteStopId(
                    @Json(name = "stop_name") val stopName: String?
                )

                @JsonClass(generateAdapter = true)
                data class ETransportSlabId(
                    @Json(name = "slab_name") val slabName: String?
                )
            }
        }
    }
}