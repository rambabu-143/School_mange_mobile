package com.mountcarmelschools.ui.profile.staff.staffQualification

import android.content.Context
import android.os.Bundle
import android.view.View
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.StaffQualificationBinding
import com.mountcarmelschools.ui.dashboard.DashboardActivity

class StaffQualification : BaseFragment<StaffQualificationBinding, StaffQualificationVIewModel>() {


    lateinit var mContext: Context

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Qualification")

    }

    override fun getLayoutID(): Int {
        return R.layout.staff_qualification
    }

    override fun getViewModel() = StaffQualificationVIewModel::class.java


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        dataBinding.qualification.text =
            (mContext as DashboardActivity).staffDetail.data?.qualification.toString()

    }
}