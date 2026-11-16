package com.mountcarmelschools.ui.assignment

import android.content.Context
import android.os.Bundle
import androidx.core.content.ContextCompat
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.GridLayoutManager
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentAssignmentBinding
import com.mountcarmelschools.di.data.assignment.AssignementForAdapter
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils

class AssignmentFragment : BaseFragment<FragmentAssignmentBinding, AssignmentViewModel>() {

    private lateinit var mContext: Context


    private lateinit var userType: String


    companion object {
        fun newInstance() = AssignmentFragment()
    }


    override fun getLayoutID() = R.layout.fragment_assignment

    override fun getViewModel() = AssignmentViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        userType = Utils.getUserType(mContext)

/*
        dataBinding.parentBackground.setBackgroundColor(
            Utils.getBackGroundColor(userType)
        )
*/

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

        } else
            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.parent_background
                )
            )
        if (arguments?.getString("from").equals("Syllabus")) {
            getSyllabus()
        } else {
            getAssignments()

        }

        settingAssignmentRecyclerView(userType)
    }

    private fun getAssignments() {
        (mContext as DashboardActivity).showProgress()

        viewModel.getAssignment(Utils.getAccessToken(mContext), Utils.getUserId(mContext)).observe(

            viewLifecycleOwner, Observer {
                (mContext as DashboardActivity).hideProgress()
                if (it.status!!) {

                    val list = ArrayList<AssignementForAdapter>()

                    it.data!!.forEach {

                        list.add(
                            AssignementForAdapter(
                                it?.attachments?.get(0),
                                it?.title,
                                it?.startDate
                            )
                        )
                    }
                    dataBinding.rvAssignment.adapter =
                        AssignmentAdapter(mContext, list, it.path.toString(),"Assignment")
                } else {
                    showErrorToast(it.message!!, mContext)

                }

            }
        )


    }


    private fun settingAssignmentRecyclerView(userType: String) {
        dataBinding.rvAssignment.layoutManager =
            GridLayoutManager(mContext, 2, GridLayoutManager.VERTICAL, false)
        dataBinding.rvAssignment.hasFixedSize()

    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText(arguments?.getString("from"))
    }

    private fun getSyllabus() {

        (mContext as DashboardActivity).showProgress()

        viewModel.getSyllabus(Utils.getAccessToken(mContext), Utils.getUserId(mContext)).observe(

            viewLifecycleOwner, Observer {
                (mContext as DashboardActivity).hideProgress()

                if (it.status!!) {
                    val list = ArrayList<AssignementForAdapter>()

                    it.data!!.forEach {

                        list.add(
                            AssignementForAdapter(
                                it?.attachments!![0],
                                it.title,
                                it.createdAt
                            )
                        )
                    }
                    dataBinding.rvAssignment.adapter =
                        AssignmentAdapter(mContext, list, it.path.toString(),"Syllabus")
                } else {
                    showErrorToast(it.message!!, mContext)

                }


            }
        )


    }


}
