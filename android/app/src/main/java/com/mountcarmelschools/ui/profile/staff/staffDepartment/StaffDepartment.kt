package com.mountcarmelschools.ui.profile.staff.staffDepartment

import android.content.Context
import android.os.Bundle
import android.view.View
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.StaffDepartmentBinding
import com.mountcarmelschools.ui.dashboard.DashboardActivity

class StaffDepartment : BaseFragment<StaffDepartmentBinding, StaffDepartmentViewModel>() {



    lateinit var mContext: Context

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Department")

    }

    override fun getLayoutID(): Int {
        return R.layout.staff_department
    }


    override fun getViewModel() = StaffDepartmentViewModel::class.java


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {

        if ((mContext as DashboardActivity).staffDetail.data != null) {
            if ((mContext as DashboardActivity).staffDetail.data?.departmentId != null) {
                dataBinding.department.text =
                    (mContext as DashboardActivity).staffDetail.data?.departmentId!!.name

            }

            if ((mContext as DashboardActivity).staffDetail.data?.staffroomId != null) {
                dataBinding.name.text =
                    (mContext as DashboardActivity).staffDetail.data?.staffroomId!!.roomNo
            }


        }

    }

}