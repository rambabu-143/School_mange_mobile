package com.mountcarmelschools.ui.attendance.studentattendance

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.TextView
import androidx.appcompat.content.res.AppCompatResources
import androidx.core.content.ContextCompat
import com.applandeo.materialcalendarview.CalendarView
import com.applandeo.materialcalendarview.EventDay
import com.applandeo.materialcalendarview.listeners.OnCalendarPageChangeListener
import com.applandeo.materialcalendarview.listeners.OnDayClickListener
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.google.gson.Gson
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentAttendanceBinding
import com.mountcarmelschools.di.data.staff.markAttandance.MarkAttendanceDropDownResponse
import com.mountcarmelschools.di.data.staff.markAttandance.MarkAttendanceResponse
import com.mountcarmelschools.di.data.transport.TransportRenewalPostData
import com.mountcarmelschools.ui.attendance.markattendance.MarkAttendanceFragment
import com.mountcarmelschools.ui.commonAdapter.CommonInterface
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*


class AttendanceFragment : BaseFragment<FragmentAttendanceBinding, AttendanceViewModel>(),
    CommonInterface {

    private lateinit var mContext: Context
    private lateinit var calender: CalendarView;
    private var mSelectedPosition = 0
    var list = ArrayList<String>()
    val holidayCalendarList = ArrayList<Calendar>()
    val holidayRemark = ArrayList<String>()
    lateinit var mClassListDropDown: List<MarkAttendanceDropDownResponse.Data>;


    companion object {
        var clear_class_selection = false
        fun newInstance() =
            AttendanceFragment()
    }

    override fun getLayoutID() = R.layout.fragment_attendance

    override fun getViewModel() = AttendanceViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        if (clear_class_selection) {
            clear_class_selection = false
            dataBinding.sectionList.setSelection(0)
        }
        if (Utils.getUserType(mContext).equals("4", false)) {
            (mContext as DashboardActivity).setHeaderText(mContext.resources.getString(R.string.mark_attendance))
            dataBinding.clStaffMarkAttendance.visibility = View.VISIBLE
        } else {
            (mContext as DashboardActivity).setHeaderText(mContext.resources.getString(R.string.attendance))
            dataBinding.clStudentAttendanceDetails.visibility = View.VISIBLE
        }
    }


    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        dataBinding.attendanceViewModel = viewModel
//        dataBinding.calendarView.calendarView.setDate(Date())

        val cal = Calendar.getInstance();

        val df = SimpleDateFormat("dd-MM-yyyy")
        dataBinding.edtCalendar.text = df.format(cal.time)



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


        val userType = Utils.getUserType(mContext)

        if (userType.equals("1")) {

            dataBinding.clStudentAttendanceDetails.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.blue_background
                )
            )
            setCalendar()

        } else if (userType.equals("2") || userType.equals("3")) {
            dataBinding.clStudentAttendanceDetails.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.fourth_background
                )
            )
            setCalendar()

        } else
            dataBinding.clStudentAttendanceDetails.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.parent_background
                )
            )

        if (!(mContext as DashboardActivity).userImage.equals("")) {

            Glide.with(this)
                .load((mContext as DashboardActivity).userImage)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .error(R.drawable.default_image)
                .into(dataBinding.cvStudentImage)

        }

        if (userType.equals("4")) {

            /* for (AccessStandardSection in (mContext as DashboardActivity).staffDetail.data?.schools?.get(
                 0
             )!!.accessStandardSection!!) {

                 list.add(AccessStandardSection?.standard.toString() + " " + AccessStandardSection?.section.toString())
             }


             // Create adapter and add in AutoCompleteTextView
             val adapter = ArrayAdapter(
                 mContext,
                 android.R.layout.simple_list_item_1, list
             )
             dataBinding.sectionList.adapter = adapter*/
            getClassListForDropDown()


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


                        mSelectedPosition = position
                    }

                }
        } else {
            getAttendance(Calendar.getInstance().time, 1)

        }
        dataBinding.arrowDisable.visibility = View.VISIBLE





        dataBinding.btnGo.setOnClickListener {

            if (mSelectedPosition > 0)
                getStudentListForMarkAttendance(
                    mClassListDropDown.get(mSelectedPosition - 1).standardId?.id.toString(),
                    mClassListDropDown.get(mSelectedPosition - 1)._id.toString()
                )
            else
                showErrorToast("Please select class", mContext)
        }


    }

    private fun setCalendar() {
        calender = dataBinding.calendarView.findViewById<CalendarView>(R.id.calendarView)
        calender.showCurrentMonthPage()

        val cal = Calendar.getInstance()

        val date =
            SimpleDateFormat("dd-MM-yyyy").parse(
                (mContext as DashboardActivity).mSessionStartDate
            )
        cal.time = date!!

        calender.setMinimumDate(cal)
        calender.setPreviousButtonImage(
            AppCompatResources.getDrawable(
                mContext,
                R.drawable.ic_left_arrow_black
            )!!
        )
        getAllSundayDate(Calendar.getInstance())?.let {
            dataBinding.calendarView.setDisabledDays(it)
        }
/*
        calender.setForwardButtonImage(
            AppCompatResources.getDrawable(
                mContext,
                R.drawable.ic_right_arrow_gray
            )!!
        )
*/

        calender.setOnForwardPageChangeListener(object : OnCalendarPageChangeListener {
            override fun onChange() {

                val todayCalender = Calendar.getInstance(TimeZone.getDefault())

                if ((calender.currentPageDate[Calendar.MONTH] + 1).equals(todayCalender[Calendar.MONTH] + 1)) {
                    getAttendance(calender.currentPageDate.time, 1)


                    calender.setForwardButtonImage(
                        AppCompatResources.getDrawable(
                            mContext,
                            R.drawable.ic_right_arrow_white
                        )!!
                    )
                    updateArrowButton(1)

                } else if ((calender.currentPageDate[Calendar.MONTH] + 1) < (todayCalender[Calendar.MONTH] + 1)) {
                    getAttendance(calender.currentPageDate.time, 0)

                    calender.setForwardButtonImage(
                        AppCompatResources.getDrawable(
                            mContext,
                            R.drawable.ic_right_arrow_black
                        )!!
                    )
                    updateArrowButton(0)

                } else {
                    updateArrowButton(0)
                    calender.setForwardButtonImage(
                        AppCompatResources.getDrawable(
                            mContext,
                            R.drawable.ic_right_arrow_white
                        )!!
                    )
                    dataBinding.tvAbCount.text = "0"
                    dataBinding.tvPresent.text =
                        "0"
                    dataBinding.halfDay.text = "0"
                }


                getAllSundayDate(calender.currentPageDate)?.let {
                    dataBinding.calendarView.setDisabledDays(it)
                }
            }

        })
        calender.setOnPreviousPageChangeListener(object : OnCalendarPageChangeListener {
            override fun onChange() {

                val todayCalender = Calendar.getInstance(TimeZone.getDefault())

                if ((calender.currentPageDate[Calendar.MONTH] + 1).equals(todayCalender[Calendar.MONTH] + 1)) {
                    getAttendance(calender.currentPageDate.time, 1)

                    calender.setForwardButtonImage(
                        AppCompatResources.getDrawable(
                            mContext,
                            R.drawable.ic_right_arrow_white
                        )!!

                    )
                    updateArrowButton(1)


                } else if ((calender.currentPageDate[Calendar.MONTH] + 1) < (todayCalender[Calendar.MONTH] + 1)) {
                    getAttendance(calender.currentPageDate.time, 0)

                    calender.setForwardButtonImage(
                        AppCompatResources.getDrawable(
                            mContext,
                            R.drawable.ic_right_arrow_black
                        )!!
                    )
                    (mContext as DashboardActivity).runOnUiThread(java.lang.Runnable {

                        updateArrowButton(0)
                    })
                } else {

                    calender.setForwardButtonImage(
                        AppCompatResources.getDrawable(
                            mContext,
                            R.drawable.ic_right_arrow_white
                        )!!
                    )
                    dataBinding.tvAbCount.text = "0"
                    dataBinding.tvPresent.text = "0"
                    dataBinding.halfDay.text = "0"
                    updateArrowButton(0)

                }

                getAllSundayDate(calender.currentPageDate)?.let {
                    dataBinding.calendarView.setDisabledDays(it)
                }
            }
        })


        calender.setOnDayClickListener(object : OnDayClickListener {
            @SuppressLint("SuspiciousIndentation")
            override fun onDayClick(eventDay: EventDay) {

                if (holidayCalendarList.contains(eventDay.calendar)) {

                    val data = holidayRemark.get(holidayCalendarList.indexOf(eventDay.calendar))
                    if (data != "" && !data.contains("--")) {

                        (mContext as DashboardActivity).showCustomToastAnotherAnimation(
                            data,
                            R.color.yellow_color, R.color.black
                        )
                    }
                    else{
                        if (data != "" ) {
                            val list = data.split("--");
                            (mContext as DashboardActivity).showCustomToastAnotherAnimation(
                                "Information Received : "+list[0]+"\n"+"Reason : "+list[1],
                                R.color.yellow_color, R.color.black
                            )
                        }
                    }

                } else {
                    Log.e("", "");
                }
            }

        })

    }

    private fun updateArrowButton(i: Int) {

        if (i == 0) {
            dataBinding.arrowDisable.layoutParams.width = 0
            dataBinding.arrowDisable.layoutParams.height = 0
        } else {
            dataBinding.arrowDisable.layoutParams.width = 300
            dataBinding.arrowDisable.layoutParams.height = 300
        }

    }


    @SuppressLint("SimpleDateFormat", "SetTextI18n")
    private fun getAttendance(newDate: Date, value: Int) {

        (mContext as DashboardActivity).showProgress()

        val df = SimpleDateFormat("dd-MM-yyyy")
        val startDate = df.format(getMonthInterval(newDate)?.get(0))
        var endDate: String
        /*   if (value == 1) {
               endDate = df.format(Calendar.getInstance().time)

           } else {*/
        endDate = df.format(getMonthInterval(newDate)?.get(1))

        // }


        viewModel.getAttendance(
            Utils.getAccessToken(mContext),
            Utils.getUserId(mContext),
            startDate,
            endDate
        )
            .observe(

                requireActivity(), androidx.lifecycle.Observer

                {

                    (mContext as DashboardActivity).hideProgress()

                    if (it.status!!) {

                        val events: MutableList<EventDay> =
                            ArrayList()
                        var halfDay = 0
                        var fullDay = 0

                        dataBinding.tvPresent.text = it.total?.minus(it.absent!!).toString()

                        if (it.absentData?.size!! > 0) {
                            for (data in it.absentData) {
                                if (data?.absent?.size!! > 0) {
                                    if (data.absent.get(0)!!.value.equals("1")) {
                                        val cal = Calendar.getInstance()

                                        val date =
                                            SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss.SSS'Z'").parse(
                                                data?.date
                                            )
                                        cal.time = date!!
                                        events.add(EventDay(cal, R.drawable.red_dot_small))

                                        if (disableDayList.contains(cal))
                                            disableDayList.remove(cal)

                                        holidayCalendarList.add(cal)
                                        for (absentData in data.absent)
                                        {
                                            if (absentData?.studentId==Utils.getUserId(mContext) )
                                            {
                                                holidayRemark.add(absentData.information + "--" + absentData.reason.toString())

                                            }
                                        }

                                        fullDay += 1;
                                    } else {
                                        val cal = Calendar.getInstance()

                                        val date1 =
                                            SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss.SSS'Z'").parse(
                                                data?.date
                                            )
                                        cal.time = date1!!
                                        events.add(EventDay(cal, R.drawable.orange_dot_small))

                                        if (disableDayList.contains(cal))
                                            disableDayList.remove(cal)

                                        holidayCalendarList.add(cal)

                                        for (absentData in data.absent)
                                        {
                                            if (absentData?.studentId==Utils.getUserId(mContext))
                                            {
                                                holidayRemark.add(absentData.information + "--" + absentData.reason.toString())

                                            }
                                        }
                                        halfDay += 1;

                                    }
                                }

                            }
                        }

                        if (it.data?.size!! > 0) {
                            for (Data in it.data) {
                                try {
                                    val cal = Calendar.getInstance()

                                    if (Data?.status.equals("HOLIDAY")) {

                                        val string = Utils.formattedDateFromString(
                                            "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'",
                                            "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'",
                                            Data?.date
                                        )

                                        val date =
                                            SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss.SSS'Z'").parse(
                                                string
                                            )
                                        cal.time = date!!

                                        events.add(EventDay(cal, R.drawable.yellow_dot_small))

                                        if (disableDayList.contains(cal))
                                            disableDayList.remove(cal)

                                        holidayCalendarList.add(cal)
                                        holidayRemark.add(Data?.remark.toString())

                                    }

                                } catch (e: ParseException) {

                                }
                            }

                        }


                        disableDayList?.let {
                            dataBinding.calendarView.setDisabledDays(it)
                        }

                        dataBinding.calendarView.setEvents(events)
                        dataBinding.tvAbCount.text = "" + fullDay
                        dataBinding.halfDay.text = "" + halfDay


                    } else {

                        dataBinding.tvAbCount.text = "0"
                        dataBinding.tvPresent.text = "0"
                        dataBinding.halfDay.text = "0"
                        showErrorToast(it.message!!.toString(), mContext)

                    }
                }
            )


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

    override fun selectedDate(date: String) {
        dataBinding.edtCalendar.text = date
    }

    override fun selectClass(classId: String) {
        TODO("Not yet implemented")
    }

    override fun selectHouseId(houseId: String) {
        TODO("Not yet implemented")
    }


    private fun getStudentListForMarkAttendance(standard_id: String, id: String) {


        var first: Boolean = false

        (mContext as DashboardActivity).showProgress()

        viewModel.getMarkedAttendanceResponse(
            Utils.getAccessToken(mContext),
            standard_id,
            id,
            dataBinding.edtCalendar.text.toString()
        )
            .observe(

                viewLifecycleOwner, androidx.lifecycle.Observer {

                    (mContext as DashboardActivity).hideProgress()

                    if (it.status!!) {
                        if (it.data != null) {
                            var updateList = ArrayList<MarkAttendanceResponse.Data?>()
                            for (update in it.data) {
                                if (update!!.attendance != null) {
                                    if (update.attendance?.type.equals("second")) {

                                        update.second = "second"
                                    } else if (update.attendance?.type.equals("first")) {

                                        update.first = "first"

                                    } else if (update.attendance?.type.equals("full")) {
                                        update.second = "second"
                                        update.first = "first"

                                    }

                                    update.reason = update.attendance!!.reason
                                    update.information = update.attendance.information
                                    update.others = update.attendance.details

                                }
                                updateList.add(update)

                            }


                            val bundle = Bundle()

                            val json = Gson().toJson(updateList)  // To JSON
                            bundle.putString("json", json)
                            bundle.putString("path", it.path)
                            bundle.putString("date", dataBinding.edtCalendar.text.toString())
                            bundle.putString("class", list.get(mSelectedPosition))
                            bundle.putString("id", id)
                            bundle.putString("standard_id", standard_id)

                            val fragment = MarkAttendanceFragment()
                            fragment.arguments = bundle


                            Utils.replaceFragment(
                                mContext,
                                R.id.fl_dashboardContainer,
                                fragment,
                                "MarkAttendanceFragment"
                            )
                        }


                    } else {

                        showErrorToast(it.message!!, mContext)

                    }

                }
            )


    }

    var disableDayList: ArrayList<Calendar> = ArrayList()
    fun getAllSundayDate(cal: Calendar): ArrayList<Calendar>? {
        //max month next month for Exp: next 2 month from this month
        disableDayList.clear()
        for (index in 0 until 2) {
            val year = cal[Calendar.YEAR]
            val month = cal[Calendar.MONTH]
            val curCal = Calendar.getInstance()
            curCal[year, month] = 1
            val daysInMonth = curCal.getActualMaximum(Calendar.DAY_OF_MONTH)
            for (day in 1..daysInMonth) {
                curCal[year, month] = day
                val dayOfWeek = curCal[Calendar.DAY_OF_WEEK]
                if (dayOfWeek == Calendar.SATURDAY || dayOfWeek == Calendar.SUNDAY) {
                    disableDayList.add(curCal.clone() as Calendar)
                    val curDate = Date(curCal.timeInMillis)
                    System.out.println(curDate)
                }
            }
            cal.add(Calendar.MONTH, 1)
        }
        return disableDayList
    }

    private fun getClassListForDropDown() {

        (mContext as DashboardActivity).showProgress()
        viewModel.getClassListForDropDown(
            Utils.getAccessToken(mContext)
        ).observe(
            viewLifecycleOwner,
            androidx.lifecycle.Observer {

                list = ArrayList<String>()

                if (it.status!!) {

                    if (it.data?.size!! > 0) {
                        mClassListDropDown = it.data as List<MarkAttendanceDropDownResponse.Data>;
                        list.add("Select")
                        for (data in it.data) {
                            list.add(data?.standard.toString() + " " + data?.section.toString())
                        }
                        val adapter = ArrayAdapter(
                            mContext,
                            android.R.layout.simple_list_item_1, list
                        )
                        dataBinding.sectionList.setAdapter(adapter)

                    }
                }

                (mContext as DashboardActivity).hideProgress()

            }
        )


    }
    fun showDialog(information:String ,reasonTxt:String ) {
        val dialogBuilder = AlertDialog.Builder(mContext)
        val inflater =
            (mContext).getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val dialogView: View = inflater.inflate(R.layout.dialog_attendance, null)
        dialogBuilder.setView(dialogView)

        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()

        val cancel = dialogView.findViewById(R.id.close) as TextView
        val reason = dialogView.findViewById(R.id.reason) as TextView
        val informationReceived = dialogView.findViewById(R.id.informationReceived) as TextView


        reason.text = reasonTxt
        informationReceived.text = information
        cancel.setOnClickListener {
            dialog.dismiss()
        }

    }

}
