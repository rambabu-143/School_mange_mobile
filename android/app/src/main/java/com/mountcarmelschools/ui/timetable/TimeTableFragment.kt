package com.mountcarmelschools.ui.timetable

import android.content.Context
import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import androidx.core.content.ContextCompat
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentTimeTableBinding
import com.mountcarmelschools.di.data.timeTable.CustomTimeTableResponse
import com.mountcarmelschools.di.data.timeTable.TimeTableResponse
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils

class TimeTableFragment : BaseFragment<FragmentTimeTableBinding, TimeTableViewModel>(),
    TimeTableInterface {

    companion object {
        fun newInstance() = TimeTableFragment()
    }

    private var mSelectedPosition: Int = -1

    private val dayArray =
        arrayOf(
            "Mon",
            "Tue",
            "Wed",
            "Thu",
            "Fri"
        )

    private lateinit var mContext: Context

    private lateinit var daysAdapter: DaysAdapter
    private lateinit var timeTableResponse: TimeTableResponse

    override fun getLayoutID() = R.layout.fragment_time_table

    override fun getViewModel() = TimeTableViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        settingDaysRecyclerView()
        settingTimeTableListRecyclerView()
        val userType = Utils.getUserType(mContext)
        val list = ArrayList<String>()

        list.add("Select")

        if (userType.equals("1")) {

            dataBinding.rvStudentList.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.blue_background
                )
            )
        } else if (userType.equals("2") || userType.equals("3")) {
            dataBinding.rvStudentList.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.fourth_background
                )
            )

        } else
            dataBinding.rvStudentList.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.parent_background
                )
            )


        if (userType.equals("4")) {


            for (AccessStandardSection in (mContext as DashboardActivity).staffDetail.data?.schools?.get(
                0
            )!!.accessStandardSection!!) {

                list.add(AccessStandardSection?.standard.toString() + " " + AccessStandardSection?.section.toString())
            }


            // Create adapter and add in AutoCompleteTextView
            val adapter = ArrayAdapter(
                mContext,
                android.R.layout.simple_list_item_1, list
            )
            dataBinding.sectionList.setAdapter(adapter)


            dataBinding.sectionList?.onItemSelectedListener =
                object : AdapterView.OnItemSelectedListener {
                    override fun onNothingSelected(parent: AdapterView<*>?) {

                    }

                    override fun onItemSelected(
                        parent: AdapterView<*>?,
                        view: View?,
                        position: Int,
                        id: Long
                    ) {

                        if(position > 0)
                        getStaffTimeTableDetail(
                            (mContext as DashboardActivity).staffDetail.data?.schools?.get(
                                    0
                            )?.accessStandardSection?.get(position - 1)?._id.toString()
                        )
                        else
                            showErrorToast("Please select class", mContext)

                        mSelectedPosition = position
                    }

                }





            dataBinding.cvClass.visibility = View.VISIBLE
            dataBinding.tvSelectClasslabel.visibility = View.VISIBLE

            dataBinding.rvDay.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.staffBackground
                )
            )
            dataBinding.rvStudentList.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.white
                )
            )

/*
            getStaffTimeTableDetail(
                (mContext as DashboardActivity).staffDetail.data?.schools?.get(
                    0
                )?.accessStandardSection?.get(0)?._id.toString()
            )*/

        } else {
            dataBinding.cvClass.visibility = View.GONE
            dataBinding.tvSelectClasslabel.visibility = View.GONE
            dataBinding.rvDay.setBackgroundColor(ContextCompat.getColor(mContext, R.color.white))
            dataBinding.rvStudentList.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.staffBackground
                )
            )
            getTimeTableDetail();

        }

    }

    private fun settingDaysRecyclerView() {
        dataBinding.rvDay.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.HORIZONTAL, false)
        dataBinding.rvDay.hasFixedSize()

        daysAdapter = DaysAdapter(mContext, dayArray, 0, this)
        dataBinding.rvDay.adapter = daysAdapter
    }

    private fun settingTimeTableListRecyclerView() {
        dataBinding.rvStudentList.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        dataBinding.rvStudentList.hasFixedSize()

    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText(getString(R.string.time_table))
    }

    private fun getTimeTableDetail() {

        (mContext as DashboardActivity).showProgress()

        viewModel.getTimeTable(Utils.getAccessToken(mContext), Utils.getUserId(mContext)).observe(

            viewLifecycleOwner, Observer {
                (mContext as DashboardActivity).hideProgress()

                timeTableResponse = it

                val list = ArrayList<CustomTimeTableResponse>()

                timeTableResponse.data?.resource?.get(0)?.monday!!.forEach {

                    list.add(
                        CustomTimeTableResponse(

                            it?.classX,
                            it?.day,

                            it?.endAt,
                            it?.endTime,
                            it?.section,
                            it?.startAt,
                            it?.startTime,
                            it?.subject

                        )
                    )


                }

                dataBinding.rvStudentList.adapter =
                    TimeTableAdapter(mContext, list)
            }
        )

    }

    private fun getStaffTimeTableDetail(standardId: String) {

        (mContext as DashboardActivity).showProgress()

        viewModel.getStaffTimeTable(Utils.getAccessToken(mContext), standardId)
            .observe(

                viewLifecycleOwner, Observer {
                    (mContext as DashboardActivity).hideProgress()

                    timeTableResponse = it

                    val list = ArrayList<CustomTimeTableResponse>()
                    settingDaysRecyclerView()
                    timeTableResponse.data?.resource?.get(0)?.monday!!.forEach {

                        list.add(
                            CustomTimeTableResponse(

                                it?.classX,
                                it?.day,

                                it?.endAt,
                                it?.endTime,
                                it?.section,
                                it?.startAt,
                                it?.startTime,
                                it?.subject

                            )
                        )


                    }

                    dataBinding.rvStudentList.adapter =
                        TimeTableAdapter(mContext, list)
                }
            )

    }

    override fun selectedValue(value: Int) {
        daysAdapter = DaysAdapter(mContext, dayArray, value, this)
        dataBinding.rvDay.adapter = daysAdapter

        if (::timeTableResponse.isInitialized && timeTableResponse != null && timeTableResponse.data != null) {
            if (value == 0) {
                val list = ArrayList<CustomTimeTableResponse>()

                timeTableResponse.data?.resource?.get(0)?.monday!!.forEach {

                    list.add(
                            CustomTimeTableResponse(

                                    it?.classX,
                                    it?.day,

                                    it?.endAt,
                                    it?.endTime,
                                    it?.section,
                                    it?.startAt,
                                    it?.startTime,
                                    it?.subject

                            )
                    )


                }

                dataBinding.rvStudentList.adapter =
                        TimeTableAdapter(mContext, list)
            } else if (value == 1) {
                val list = ArrayList<CustomTimeTableResponse>()

                timeTableResponse.data?.resource?.get(0)?.tuesday!!.forEach {

                    list.add(
                            CustomTimeTableResponse(

                                    it?.classX,
                                    it?.day,

                                    it?.endAt,
                                    it?.endTime,
                                    it?.section,
                                    it?.startAt,
                                    it?.startTime,
                                    it?.subject

                            )
                    )


                }

                dataBinding.rvStudentList.adapter =
                    TimeTableAdapter(mContext, list)
            } else if (value == 2) {
                val list = ArrayList<CustomTimeTableResponse>()

                timeTableResponse.data?.resource?.get(0)?.wednesday!!.forEach {

                    list.add(
                        CustomTimeTableResponse(

                            it?.classX,
                            it?.day,

                            it?.endAt,
                            it?.endTime,
                            it?.section,
                            it?.startAt,
                            it?.startTime,
                            it?.subject

                        )
                    )


                }

                dataBinding.rvStudentList.adapter =
                    TimeTableAdapter(mContext, list)
            } else if (value == 3) {
                val list = ArrayList<CustomTimeTableResponse>()

                timeTableResponse.data?.resource?.get(0)?.thursday!!.forEach {

                    list.add(
                        CustomTimeTableResponse(

                            it?.classX,
                            it?.day,

                            it?.endAt,
                            it?.endTime,
                            it?.section,
                            it?.startAt,
                            it?.startTime,
                            it?.subject

                        )
                    )


                }

                dataBinding.rvStudentList.adapter =
                    TimeTableAdapter(mContext, list)
            } else if (value == 4) {
                val list = ArrayList<CustomTimeTableResponse>()

                timeTableResponse.data?.resource?.get(0)?.friday!!.forEach {

                    list.add(
                        CustomTimeTableResponse(

                            it?.classX,
                            it?.day,

                            it?.endAt,
                            it?.endTime,
                            it?.section,
                            it?.startAt,
                            it?.startTime,
                            it?.subject

                        )
                    )


                }

                dataBinding.rvStudentList.adapter =
                    TimeTableAdapter(mContext, list)
            }
        }
    }

}
