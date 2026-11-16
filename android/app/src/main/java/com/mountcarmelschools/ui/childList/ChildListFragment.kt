package com.mountcarmelschools.ui.childList

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.gson.Gson
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentChildListBinding
import com.mountcarmelschools.di.data.login.LoginResponseFromApi
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils

class ChildListFragment : BaseFragment<FragmentChildListBinding, ChildListViewModel>() {

    private lateinit var mContext: Context


    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context;
    }

    private val childImage =
        arrayOf(
            R.drawable.s_1,
            R.drawable.s_2
        )

    private val childName =
        arrayOf(
            "prabal Singh",
            "aadhya rangarajan"
        )

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun getLayoutID(): Int {

        return R.layout.fragment_child_list
    }

    override fun getViewModel(): Class<ChildListViewModel> {
        return ChildListViewModel::class.java
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        settingEventRecyclerView()

        val userType = Utils.getUserType(mContext)

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

        } else {
            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.parent_background
                )
            )
        }


    }


    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Child")

    }

    private fun settingEventRecyclerView() {
        dataBinding.rvChildList.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        dataBinding.rvChildList.hasFixedSize()

        if (Utils.getUserType(mContext).toString().equals("4")) {
            dataBinding.rvChildList.adapter = ChildListAdapterForParent(
                mContext,
                (mContext as DashboardActivity).staffDetail.data?.students!!,
                "http://139.59.38.61:4201/uploads/profile-pic/student/"
            )
        } else {
            var list = Gson().fromJson(
                Utils.getAllStudentDetail(mContext)
                , Array<LoginResponseFromApi.User.Student>::class.java
            ).toList()

            dataBinding.rvChildList.adapter = ChildListAdapter(
                mContext,
                list,
                "http://139.59.38.61:4201/uploads/profile-pic/student/"
            )
        }
    }
}