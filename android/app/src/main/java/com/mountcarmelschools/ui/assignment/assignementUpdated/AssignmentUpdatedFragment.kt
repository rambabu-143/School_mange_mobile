package com.mountcarmelschools.ui.assignment.assignementUpdated

import android.annotation.SuppressLint
import android.content.Context
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import androidx.core.view.ViewCompat
import androidx.recyclerview.widget.GridLayoutManager
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.AsignmentUpdateScreenBinding
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.CommonUtils
import com.mountcarmelschools.utlis.Utils
import java.text.DateFormat
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*

class AssignmentUpdatedFragment :
    BaseFragment<AsignmentUpdateScreenBinding, AssignmentUpdatedViewModel>() {

    private lateinit var mAdater: AssignmentUpdateAdapter
    private var mEndDate: String = ""
    private var mStartDate: String = ""
    private var mSubjectId: String = ""
    private var mSelectedPosition: Int = 0
    private lateinit var mContext: Context
    val formatter: DateFormat = SimpleDateFormat("MMM yyyy", Locale.ENGLISH)


    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Assignments")
    }

    override fun getLayoutID(): Int {
        return R.layout.asignment_update_screen
    }

    override fun getViewModel() = AssignmentUpdatedViewModel::class.java


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        if ((mContext as DashboardActivity).studentDetail.data?.comboId?.subjects != null) {
            val allSubject = ((mContext as DashboardActivity).studentDetail.data?.comboId?.subjects)
            val list = ArrayList<String>()
            list.add("Select")
            for (data in allSubject!!) {

                list.add(data?.subjectName!!)
            }

            val adapter = ArrayAdapter(
                mContext,
                R.layout.selected_text_view_black, list
            )
            dataBinding.selectSubject.setAdapter(adapter)


            dataBinding.selectSubject.onItemSelectedListener =
                object : AdapterView.OnItemSelectedListener {
                    override fun onNothingSelected(parent: AdapterView<*>?) {

                    }

                    override fun onItemSelected(
                        parent: AdapterView<*>?,
                        view: View?,
                        position: Int,
                        id: Long
                    ) {

                        if (position > 0) {

                            mSelectedPosition = position - 1

                            mSubjectId = allSubject.get(mSelectedPosition)?.id!!;
                        } else {

                            mSubjectId = ""
                        }
                    }

                }
        }


        val dateStart = CommonUtils.stingFormatStringToDate(
            "dd-MM-yyyy",
            "MMM yyyy",
            (mContext as DashboardActivity).mSessionStartDate
        )
        val dateEnd = CommonUtils.stingFormatStringToDate(
            "dd-MM-yyyy",
            "MMM yyyy",
            (mContext as DashboardActivity).mSessionEndDate
        )

        val monthList = ArrayList<String>()
        monthList.add("Select")

        val startDate: Calendar? = stringToCalendar(dateStart)
        val endDate: Calendar? = stringToCalendar(dateEnd)

        while (!startDate?.after(endDate)!!) {
            println("datessss " + formatter.format(startDate.time))
            if (formatter.format(startDate.time).equals("Jul 2020"))
                monthList.add("July 2020")
            else
                monthList.add("" + formatter.format(startDate.time))

            startDate.add(Calendar.MONTH, 1)

        }
        // println("datessss " + formatter.format(endDate?.time))
        //monthList.add("" + formatter.format(startDate.time))

        val adapter1 = ArrayAdapter(
            mContext,
            R.layout.selected_text_view_black, monthList
        )
        dataBinding.selectMonth.setAdapter(adapter1)

        dataBinding.selectMonth.onItemSelectedListener =
            object : AdapterView.OnItemSelectedListener {
                override fun onNothingSelected(parent: AdapterView<*>?) {

                }

                @SuppressLint("SimpleDateFormat")
                override fun onItemSelected(
                    parent: AdapterView<*>?,
                    view: View?,
                    position: Int,
                    id: Long
                ) {

                    if (position > 0) {
                        try {
                            val date = formatter.parse(monthList.get(position))

                            val df = SimpleDateFormat("dd-MM-yyyy")

                            mStartDate = df.format(getMonthInterval(date)?.get(0))

                            mEndDate = df.format(getMonthInterval(date)?.get(1))


                        } catch (e: ParseException) {
                            e.printStackTrace()
                        }
                    } else {
                        mStartDate = ""
                        mEndDate = ""
                    }

                }

            }

        dataBinding.rvStudentList.layoutManager =
            GridLayoutManager(mContext, 2, GridLayoutManager.VERTICAL, false)
        dataBinding.rvStudentList.hasFixedSize()



        dataBinding.btnGo.setOnClickListener {

            dataBinding.edtCalendar1.setText("")
            if (mSubjectId.equals("")) {
                showErrorToast("Please select subject", mContext)
            } else if (mStartDate.equals("") && mEndDate.equals("")) {
                showErrorToast("Please select month", mContext)
            } else {

                (mContext as DashboardActivity).showProgress()
                viewModel.getAssignmentUpdated(
                    Utils.getAccessToken(mContext),
                    Utils.getUserId(mContext), mSubjectId, mStartDate, mEndDate
                ).observe(
                    viewLifecycleOwner, androidx.lifecycle.Observer {
                        (mContext as DashboardActivity).hideProgress()

                        if (it.status!!) {
                            if (it.data!!.size > 0) {
                                ViewCompat.setNestedScrollingEnabled(
                                    dataBinding.rvStudentList,
                                    false
                                );

                                dataBinding.rvStudentList.visibility = View.VISIBLE
                                dataBinding.holder.visibility = View.GONE

                                mAdater =
                                    AssignmentUpdateAdapter(mContext, it.data, it.path.toString())
                                dataBinding.rvStudentList.adapter = mAdater


                            } else {
                                dataBinding.rvStudentList.visibility = View.GONE
                                dataBinding.holder.visibility = View.VISIBLE
                                mAdater = AssignmentUpdateAdapter(mContext, listOf(), "")
                                dataBinding.rvStudentList.adapter = mAdater
                            }

                        } else {
                            showErrorToast(it.message!!, mContext)
                        }
                    }
                )
            }
        }

        dataBinding.edtCalendar1.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(s: Editable) {}
            override fun beforeTextChanged(
                s: CharSequence, start: Int,
                count: Int, after: Int
            ) {
            }

            override fun onTextChanged(
                s: CharSequence, start: Int,
                before: Int, count: Int
            ) {
                if (::mAdater.isInitialized) {
                    mAdater.getFilter().filter(s)
                }
            }
        })
    }

    private fun stringToCalendar(string: String): Calendar? {
        val date: Date = formatter.parse(string)
        val calendar = Calendar.getInstance()
        calendar.time = date
        return calendar
    }


    @Throws(Exception::class)
    fun getMonthInterval(data: Date?): Array<Date?>? {
        val dates = arrayOfNulls<Date>(2)
        val start = Calendar.getInstance()
        val end = Calendar.getInstance()
        start.time = data
        start[Calendar.DAY_OF_MONTH] = start.getActualMinimum(Calendar.DAY_OF_MONTH)
        start[Calendar.HOUR_OF_DAY] = 0
        start[Calendar.MINUTE] = 0
        start[Calendar.SECOND] = 0
        end.time = data
        end[Calendar.DAY_OF_MONTH] = end.getActualMaximum(Calendar.DAY_OF_MONTH)
        end[Calendar.HOUR_OF_DAY] = 23
        end[Calendar.MINUTE] = 59
        end[Calendar.SECOND] = 59

        //System.out.println("start "+ start.getTime());
        //System.out.println("end   "+ end.getTime());
        dates[0] = start.time
        dates[1] = end.time
        return dates
    }

}