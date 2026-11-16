package com.mountcarmelschools.di.data.studentIdCard

data class StudentIDCardResponse(

    val change_message: String,

    val `data`: Data,

    val is_change_request: Boolean,

    val is_form_submitted: Boolean,

    val message: String,

    val path: String,

    val status: Boolean

) {

    data class Data(

        val address: Address,

        val admission_no: String,

        val allergies: String,

        val bloodgroup: String,

        val class_section: String,

        val date_of_birth: String,

        val evening_route: String,

        val fathers_name: String,

        val morning_route: String,

        val transport_type: String,

        val name: String,

        val profile_pic: String,

        val session: String?,

        val sms_mobile: String

    ) {

        data class Address(

            val _id: String,

            val city: String,

            val country_id: CountryId,

            val created_at: String,

            val is_parent: Boolean,

            val is_staff: Boolean,

            val local_address: String,

            val parent: String,

            val pincode: String,

            val state_id: StateId

        ) {

            data class CountryId(

                val _id: String,

                val country_name: String

            )

            data class StateId(

                val _id: String,

                val state_name: String

            )

        }

    }

}