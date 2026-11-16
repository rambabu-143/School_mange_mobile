package com.mountcarmelschools.ui.attendance.attendancesummary

import android.content.Context
import android.os.Bundle
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentAttendanceSummaryBinding
import com.mountcarmelschools.ui.commonAdapter.CommonInterface
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils
import java.text.SimpleDateFormat
import java.util.*

class AttendanceSummaryFragment :
    BaseFragment<FragmentAttendanceSummaryBinding, AttendanceSummaryViewModel>(), CommonInterface {

    private lateinit var mContext: Context

    companion object {
        fun newInstance() =
            AttendanceSummaryFragment()
    }

    override fun getLayoutID() = R.layout.fragment_attendance_summary

    override fun getViewModel() = AttendanceSummaryViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        dataBinding.attendanceSummaryViewModel = viewModel
        settingAttendanceSummaryRecyclerView()

        val cal = Calendar.getInstance();

        val df = SimpleDateFormat("dd-MM-yyyy")
        val startDate = df.format(cal.time)
        dataBinding.edtCalendar.text = startDate



        if (Utils.getUserType(mContext).equals("4")) {
            val startDateCal = Calendar.getInstance()

            val date =
                SimpleDateFormat("dd-MM-yyyy").parse(
                    (mContext as DashboardActivity).mSessionStartDate
                )
            startDateCal.time = date!!


            dataBinding.edtCalendar.setOnClickListener {
                Utils.showCalendarDialogWithFixDates(mContext, this, startDateCal)

            }
        }


        dataBinding.btnGo.setOnClickListener {
            getAttendanceSummery(dataBinding.edtCalendar.text.toString())

        }
        getAttendanceSummery(dataBinding.edtCalendar.text.toString())



    }

    private fun settingAttendanceSummaryRecyclerView() {
        dataBinding.rvSummary.layoutManager =
            LinearLayoutManager(mContext, LinearLayoutManager.VERTICAL, false)
        dataBinding.rvSummary.hasFixedSize()
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Attendance Summary")
    }

    private fun getAttendanceSummery(date: String) {

        (mContext as DashboardActivity).showProgress()

        viewModel.getAttendanceSummery(Utils.getAccessToken(mContext), date)
            .observe(

                viewLifecycleOwner, Observer {
                    (mContext as DashboardActivity).hideProgress()

                    if (it.status!! && it.data!=null && it.data!!.isNotEmpty()) {
                        dataBinding.rvSummary.adapter = AttendanceSummaryAdapter(mContext, it.data)

                    } else {
                        showErrorToast(it.message!!, mContext)
                        dataBinding.rvSummary.adapter = AttendanceSummaryAdapter(mContext, listOf())

                    }


                }

            )

    }

    override fun selectedDate(date: String) {
        dataBinding.edtCalendar.text = date
    }

    override fun selectClass(classId: String) {
        TODO("Not yet implemented")
    }

    override fun selectHouseId(houseId: String) {
        TODO("Not yet implemented")
    }

}
