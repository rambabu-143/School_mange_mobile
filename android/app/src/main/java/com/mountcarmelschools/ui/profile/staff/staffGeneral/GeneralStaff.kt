package com.mountcarmelschools.ui.profile.staff.staffGeneral

import android.annotation.SuppressLint
import android.content.Context
import android.os.Bundle
import android.view.View
import android.widget.TextView
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.StaffGeneralProfileBinding
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils

class GeneralStaff : BaseFragment<StaffGeneralProfileBinding, GeneralStaffViewModel>() {


    lateinit var mContext: Context

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("General")

    }
    override fun getLayoutID(): Int {

        return R.layout.staff_general_profile
    }

    override fun getViewModel(): Class<GeneralStaffViewModel> {

        return GeneralStaffViewModel::class.java

    }

    @SuppressLint("SetTextI18n")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        dataBinding.name.text = (mContext as DashboardActivity).staffDetail.data?.name
        dataBinding.dob.text = Utils.formattedDateFromString(
            "", "dd-MM-yyyy",
            (mContext as DashboardActivity).staffDetail.data?.dateOfBirth
        )

        dataBinding.doj.text = Utils.formattedDateFromString(
            "", "dd-MM-yyyy",
            (mContext as DashboardActivity).staffDetail.data?.dateOfJoining
        )


        dataBinding.anniversary.text = Utils.formattedDateFromString(
            "", "dd-MM-yyyy",
            (mContext as DashboardActivity).staffDetail.data?.dateOfAnniversary
        )


        dataBinding.spouseName.text = (mContext as DashboardActivity).staffDetail.data?.spouseName
        dataBinding.email.text = (mContext as DashboardActivity).staffDetail.data?.email
        dataBinding.mobile.text = (mContext as DashboardActivity).staffDetail.data?.mobile
        dataBinding.sosMobile.text =
            (mContext as DashboardActivity).staffDetail.data?.emergencyMobile
        dataBinding.sosName.text = (mContext as DashboardActivity).staffDetail.data?.emergencyName
        dataBinding.address.text =
            (mContext as DashboardActivity).staffDetail.data?.address!!.localAddress + ", " +
                    (mContext as DashboardActivity).staffDetail.data?.address!!.city + ", " +
                    (mContext as DashboardActivity).staffDetail.data?.address!!.pincode


        if ((mContext as DashboardActivity).staffDetail.data?.students != null &&
            (mContext as DashboardActivity).staffDetail.data?.students!!.isNotEmpty()
        ) {

            dataBinding.tvChildMcs.text = "Yes"
            dataBinding.childContainer.visibility = View.VISIBLE
            dataBinding.childView.visibility = View.VISIBLE
            showChildLayout()
        } else {
            dataBinding.tvChildMcs.text = "NO"
            dataBinding.childContainer.visibility = View.GONE
            dataBinding.childView.visibility = View.GONE

        }


    }

    @SuppressLint("SetTextI18n")
    private fun showChildLayout() {

        for ((index, data) in (mContext as DashboardActivity).staffDetail.data?.students!!.withIndex()) {

            val view = layoutInflater.inflate(R.layout.dropdown_menu_popup_item, null)

            val textView = view.findViewById<TextView>(R.id.text1);

            val position = index + 1
            textView.text = "$position . ${data!!.standardId!!.name} (${data.admissionNo})"

            dataBinding.childContainer.addView(view)

        }


    }

}