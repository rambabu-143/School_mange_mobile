package com.mountcarmelschools.ui.profile.transport

import android.annotation.SuppressLint
import android.content.Context
import android.os.Bundle
import android.view.View
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentTransportBinding
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils

class TransportFragment : BaseFragment<FragmentTransportBinding, TransportFragmentViewModel>() {
    private lateinit var mContext: Context

    override fun getLayoutID(): Int {
        return R.layout.fragment_transport

    }

    override fun getViewModel() = TransportFragmentViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }


    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Transport")

    }

    @SuppressLint("SetTextI18n")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        if (Utils.getUserType(mContext).equals("4")) {
            if ((mContext as DashboardActivity).staffDetail.data?.transportId != null) {
                dataBinding.morningValue.text =
                        (mContext as DashboardActivity).staffDetail.data?.transportId?.routesDetails!!.get(0)?.mRouteId?.routeName
                dataBinding.eveningValue.text =
                        (mContext as DashboardActivity).staffDetail.data?.transportId?.routesDetails!!.get(0)?.eRouteId!!.routeName
                dataBinding.pickUpValue.text =
                        (mContext as DashboardActivity).staffDetail.data?.transportId?.routesDetails!!.get(0)?.mTransportRouteStopId!!.stopName
                dataBinding.dropOfValue.text =
                        (mContext as DashboardActivity).staffDetail.data?.transportId?.routesDetails!!.get(0)?.eTransportRouteStopId?.stopName

                dataBinding.fromValue.text = theMonth(
                        (mContext as DashboardActivity).staffDetail.data?.transportId?.routesDetails!!.get(0)?.eMonthFrom!! - 1
                )
                dataBinding.toValue.text = theMonth(
                        (mContext as DashboardActivity).staffDetail.data?.transportId?.routesDetails!!.get(0)?.mMonthTo!! - 1
                )
            }
        } else {
            val studentDetailData = (mContext as DashboardActivity)
                .studentDetail.data?.transportBillId?.transportAry

            if (studentDetailData != null) {
                dataBinding.durationLayout.visibility = View.GONE
                dataBinding.durationView.visibility = View.GONE
                dataBinding.transportLayout.visibility = View.VISIBLE
                dataBinding.noTransport.visibility = View.GONE
                dataBinding.morningValue.text =
                    studentDetailData.get(studentDetailData.size - 1)!!.morningroute
                dataBinding.eveningValue.text =
                    studentDetailData.get(studentDetailData.size - 1)!!.eveningroute
                dataBinding.pickUpValue.text =
                    studentDetailData.get(studentDetailData.size - 1)!!.morningstop
                dataBinding.dropOfValue.text =
                    studentDetailData.get(studentDetailData.size - 1)!!.eveningstop


            } else {
                dataBinding.durationLayout.visibility = View.GONE
                dataBinding.durationView.visibility = View.GONE
                dataBinding.transportLayout.visibility = View.GONE
                dataBinding.noTransport.visibility = View.VISIBLE

            }
        }
    }

    fun theMonth(month: Int): String? {
        val monthNames = arrayOf(
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
        )
        return monthNames[month]
    }

}