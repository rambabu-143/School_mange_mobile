package com.mountcarmelschools.di.data.staffDashboard


import com.squareup.moshi.Json

data class StaffDashboard(
    @Json(name = "chronicles")
    val chronicles: Chronicles?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "newsletter")
    val newsletter: Newsletter?,
    @Json(name = "status")
    val status: Boolean?,
) {
    data class Chronicles(
        @Json(name = "data")
        val `data`: Data?,
        @Json(name = "path")
        val path: String?
    ) {
        data class Data(
            @Json(name = "end_date")
            val endDate: String?,
            @Json(name = "file_name")
            val fileName: String?,
            @Json(name = "_id")
            val id: String?,
            @Json(name = "name")
            val name: String?,
            @Json(name = "start_date")
            val startDate: String?
        )
    }

    data class DashboardData(
        @Json(name = "email_group_file")
        val emailGroupFile: String?,
        @Json(name = "left_box")
        val leftBox: List<LeftBox?>?,
        @Json(name = "right_box")
        val rightBox: List<RightBox?>?
    ) {
        data class LeftBox(
            @Json(name = "bg")
            val bg: String?,
            @Json(name = "link_type")
            val linkType: String?,
            @Json(name = "name")
            val name: String?,
            @Json(name = "type")
            val type: String?,
            @Json(name = "value")
            val value: String?
        )

        data class RightBox(
            @Json(name = "bg")
            val bg: String?,
            @Json(name = "highlight")
            val highlight: Boolean?,
            @Json(name = "link_type")
            val linkType: String?,
            @Json(name = "name")
            val name: String?,
            @Json(name = "type")
            val type: String?,
            @Json(name = "value")
            val value: String?
        )
    }

    data class Newsletter(
        @Json(name = "data")
        val `data`: Data?,
        @Json(name = "path")
        val path: String?
    ) {
        data class Data(
            @Json(name = "end_date")
            val endDate: String?,
            @Json(name = "file_name")
            val fileName: String?,
            @Json(name = "_id")
            val id: String?,
            @Json(name = "name")
            val name: String?,
            @Json(name = "start_date")
            val startDate: String?
        )
    }

    data class Notices(
        @Json(name = "data")
        val `data`: List<Any?>?,
        @Json(name = "path")
        val path: String?
    )

    data class TransportDetails(
        @Json(name = "busSecurity")
        val busSecurity: String?,
        @Json(name = "filepath")
        val filepath: String?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "installment")
        val installment: List<Installment?>?,
        @Json(name = "payable")
        val payable: Int?,
        @Json(name = "payment_date")
        val paymentDate: String?,
        @Json(name = "routeDetails")
        val routeDetails: List<RouteDetail?>?
    ) {
        data class Installment(
            @Json(name = "amount")
            val amount: Int?,
            @Json(name = "amount_payble")
            val amountPayble: Int?,
            @Json(name = "cheq_no")
            val cheqNo: String?,
            @Json(name = "date")
            val date: String?,
            @Json(name = "docno")
            val docno: String?,
            @Json(name = "inst_no")
            val instNo: String?,
            @Json(name = "installment_type")
            val installmentType: String?,
            @Json(name = "recdate")
            val recdate: String?,
            @Json(name = "receipt")
            val receipt: String?,
            @Json(name = "recived")
            val recived: String?,
            @Json(name = "type")
            val type: String?,
            @Json(name = "year_session")
            val yearSession: String?
        )

        data class RouteDetail(
            @Json(name = "e_slabAmt")
            val eSlabAmt: Int?,
            @Json(name = "evening_slabname")
            val eveningSlabname: String?,
            @Json(name = "eveningroute")
            val eveningroute: String?,
            @Json(name = "eveningstop")
            val eveningstop: String?,
            @Json(name = "formonth")
            val formonth: Int?,
            @Json(name = "monthfrom")
            val monthfrom: Int?,
            @Json(name = "monthto")
            val monthto: Int?,
            @Json(name = "morning_slabname")
            val morningSlabname: String?,
            @Json(name = "morningroute")
            val morningroute: String?,
            @Json(name = "morningstop")
            val morningstop: String?,
            @Json(name = "mslabAmt")
            val mslabAmt: Int?,
            @Json(name = "status")
            val status: String?,
            @Json(name = "tamt")
            val tamt: Int?,
            @Json(name = "totaltrnsportFee")
            val totaltrnsportFee: Int?,
            @Json(name = "transport_amt")
            val transportAmt: Int?
        )
    }

    data class Wise(
        @Json(name = "emotion")
        val emotion: Int?,
        @Json(name = "intellect")
        val intellect: Int?,
        @Json(name = "stature")
        val stature: Int?,
        @Json(name = "total")
        val total: Int?,
        @Json(name = "worthy")
        val worthy: Int?
    )
}