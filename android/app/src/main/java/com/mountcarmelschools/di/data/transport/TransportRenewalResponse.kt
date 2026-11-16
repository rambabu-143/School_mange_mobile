package com.mountcarmelschools.di.data.transport


import com.squareup.moshi.Json

data class TransportRenewalResponse(
    @Json(name = "branch_details")
    val branchDetails: BranchDetails?,
    @Json(name = "data")
    val `data`: Data?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "next_year_session")
    val nextYearSession: String?,
    @Json(name = "path")
    val path: String?,
    @Json(name = "promoted_class")
    val promotedClass: String?,
    @Json(name = "status")
    val status: Boolean?
) {
    data class BranchDetails(
        @Json(name = "branch_address")
        val branchAddress: String?,
        @Json(name = "branch_code")
        val branchCode: Int?,
        @Json(name = "branch_email")
        val branchEmail: String?,
        @Json(name = "branch_opening_hrs")
        val branchOpeningHrs: String?,
        @Json(name = "branch_phone")
        val branchPhone: String?,
        @Json(name = "branch_website")
        val branchWebsite: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "default_year")
        val defaultYear: String?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "school_id")
        val schoolId: String?,
        @Json(name = "school_type")
        val schoolType: String?,
        @Json(name = "updated_at")
        val updatedAt: String?,
        @Json(name = "__v")
        val v: Int?,
        @Json(name = "years")
        val years: List<String?>?
    )

    data class Data(
        @Json(name = "address")
        val address: List<Addres?>?,
        @Json(name = "admission_no")
        val admissionNo: String?,
        @Json(name = "gender")
        val gender: String?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "is_transport")
        val isTransport: Boolean?,
        @Json(name = "name")
        val name: String?,
        @Json(name = "profile_pic")
        val profilePic: String?,
        @Json(name = "relation")
        val relation: List<Relation?>?,
        @Json(name = "siblings")
        val siblings: List<Any?>?,
        @Json(name = "sms_mobile")
        val smsMobile: String?,
        @Json(name = "standard_section_id")
        val standardSectionId: StandardSectionId?,
        @Json(name = "transport_details")
        val transportDetails: TransportDetails?,
        @Json(name = "transport_id")
        val transportId: TransportId?
    ) {
        data class Addres(
            @Json(name = "city")
            val city: String?,
            @Json(name = "country_id")
            val countryId: CountryId?,
            @Json(name = "created_at")
            val createdAt: String?,
            @Json(name = "_id")
            val id: String?,
            @Json(name = "is_parent")
            val isParent: Boolean?,
            @Json(name = "is_staff")
            val isStaff: Boolean?,
            @Json(name = "local_address")
            val localAddress: String?,
            @Json(name = "parent")
            val parent: String?,
            @Json(name = "pincode")
            val pincode: String?,
            @Json(name = "state_id")
            val stateId: StateId?
        ) {
            data class CountryId(
                @Json(name = "country_code")
                val countryCode: String?,
                @Json(name = "country_name")
                val countryName: String?,
                @Json(name = "_id")
                val id: String?
            )

            data class StateId(
                @Json(name = "_id")
                val id: String?,
                @Json(name = "state_code")
                val stateCode: String?,
                @Json(name = "state_name")
                val stateName: String?
            )
        }

        data class Relation(
            @Json(name = "designation")
            val designation: String?,
            @Json(name = "email")
            val email: String?,
            @Json(name = "_id")
            val id: String?,
            @Json(name = "mobile")
            val mobile: String?,
            @Json(name = "name")
            val name: String?,
            @Json(name = "occupation_child_id")
            val occupationChildId: String?,
            @Json(name = "occupation_id")
            val occupationId: String?,
            @Json(name = "office_address")
            val officeAddress: String?,
            @Json(name = "office_phone")
            val officePhone: String?,
            @Json(name = "organization")
            val organization: String?,
            @Json(name = "other_occupation")
            val otherOccupation: String?,
            @Json(name = "pancard")
            val pancard: String?,
            @Json(name = "qualification_id")
            val qualificationId: String?,
            @Json(name = "relation")
            val relation: String?
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

        data class TransportId(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "routeData")
            val routeData: List<TransportDetails.RouteData?>?,
        )

        data class TransportDetails(
            @Json(name = "address")
            val address: String?,
            @Json(name = "admission_no")
            val admissionNo: String?,
            @Json(name = "bill_type")
            val billType: Int?,
            @Json(name = "class")
            val classX: String?,
            @Json(name = "created_at")
            val createdAt: String?,
            @Json(name = "dateofbussecurity")
            val dateofbussecurity: String?,
            @Json(name = "fathername")
            val fathername: String?,
            @Json(name = "firstPaymentOn")
            val firstPaymentOn: String?,
            @Json(name = "_id")
            val id: String?,
            @Json(name = "is_checked_promotion")
            val isCheckedPromotion: Boolean?,
            @Json(name = "is_deleted")
            val isDeleted: Boolean?,
            @Json(name = "last")
            val last: Boolean?,
            @Json(name = "name")
            val name: String?,
            @Json(name = "old_id")
            val oldId: String?,
            @Json(name = "order")
            val order: Int?,
            @Json(name = "refundAmount")
            val refundAmount: Int?,
            @Json(name = "routeData")
            val routeData: List<RouteData?>?,
            @Json(name = "school_code")
            val schoolCode: String?,
            @Json(name = "section")
            val section: String?,
            @Json(name = "section_id")
            val sectionId: String?,
            @Json(name = "securityAmount")
            val securityAmount: Int?,
            @Json(name = "standard_section_id")
            val standardSectionId: String?,
            @Json(name = "status")
            val status: String?,
            @Json(name = "student_type")
            val studentType: String?,
            @Json(name = "tbillurl")
            val tbillurl: String?,
            @Json(name = "transWithdrawalDate")
            val transWithdrawalDate: String?,
            @Json(name = "transportAdmissionDate")
            val transportAdmissionDate: String?,
            @Json(name = "transport_bill_me")
            val transportBillMe: Boolean?,
            @Json(name = "transport_receipt")
            val transportReceipt: String?,
            @Json(name = "trfeegnron")
            val trfeegnron: String?,
            @Json(name = "updated_at")
            val updatedAt: String?,
            @Json(name = "year_session")
            val yearSession: String?
        ) {
            data class RouteData(
                @Json(name = "evening_slabname")
                val eveningSlabname: String?,
                @Json(name = "eveningroute")
                val eveningroute: String?,
                @Json(name = "eveningstop")
                val eveningstop: String?,
                @Json(name = "monthfrom")
                val monthfrom: String?,
                @Json(name = "monthto")
                val monthto: String?,
                @Json(name = "morning_slabname")
                val morningSlabname: String?,
                @Json(name = "morningroute")
                val morningroute: String?,
                @Json(name = "morningstop")
                val morningstop: String?,
                @Json(name = "serialNumber")
                val serialNumber: Int?
            )
        }
    }
}