package com.mountcarmelschools.ui.holidayHomework

import android.content.Context
import android.os.Bundle
import android.view.View
import androidx.core.content.ContextCompat
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentNoticeBinding
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils

class HolidayHomeWorkFragment : BaseFragment<FragmentNoticeBinding, HolidayHomeWorkViewModel>() {

    lateinit var mContext: Context

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun getLayoutID(): Int {

        return R.layout.fragment_notice
    }

    override fun getViewModel(): Class<HolidayHomeWorkViewModel> {
        return HolidayHomeWorkViewModel::class.java
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Holiday Homework")

    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        var userType = Utils.getUserType(mContext)
        if (userType.equals("1")) {

            dataBinding.parentBackground.setBackgroundColor(
                    ContextCompat.getColor(
                            mContext,
                            R.color.blue_background
                    )
            )
        } else if (userType.equals("2") || userType.equals("3")) {
            dataBinding.parentBackground.setBackgroundColor(
                    ContextCompat.getColor(
                            mContext,
                            R.color.fourth_background
                    )
            )

        }


        settingStudentListRecyclerView()
        getStudentNoticeDetail()

    }

    private fun settingStudentListRecyclerView() {
        dataBinding.recyclerView.layoutManager =
                LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        dataBinding.recyclerView.hasFixedSize()

    }


    private fun getStudentNoticeDetail() {

        (mContext as DashboardActivity).showProgress()

        viewModel.getStudentNoticeDetail(Utils.getAccessToken(mContext), Utils.getUserId(mContext))
                .observe(

                        viewLifecycleOwner, Observer {
                    (mContext as DashboardActivity).hideProgress()

                        if (it.status!!) {
                            var noticeAdapter = HolidayHomeWorkAdapter(mContext, it.data, it.path!!)

                            dataBinding.recyclerView.adapter = noticeAdapter

                        }else{
                            showErrorToast(it.message!!, mContext)

                        }

                })
    }


}