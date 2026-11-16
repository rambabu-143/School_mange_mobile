package com.mountcarmelschools.ui.calendar

import android.content.Context
import android.os.Bundle
import android.util.Log
import androidx.appcompat.content.res.AppCompatResources
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.applandeo.materialcalendarview.CalendarView
import com.applandeo.materialcalendarview.EventDay
import com.applandeo.materialcalendarview.listeners.OnCalendarPageChangeListener
import com.applandeo.materialcalendarview.listeners.OnDayClickListener
import com.applandeo.materialcalendarview.listeners.OnSelectDateListener
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentSchoolCalendarBinding
import com.mountcarmelschools.di.data.student.SchoolCalendarResponse
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

class SchoolCalendarFragment :
    BaseFragment<FragmentSchoolCalendarBinding, SchoolCalendarViewModel>(), OnSelectDateListener {

    private lateinit var mContext: Context
    private lateinit var calender: CalendarView;

    private var holidaysList = ArrayList<SchoolCalendarResponse.Holiday>()

    private var eventList = ArrayList<SchoolCalendarResponse.Event>()
    private var eventDate = ArrayList<Date>()
    private var eventName = ArrayList<String>()

    private var purpleEventDate = ArrayList<Date>()
    private var purpleEventName = ArrayList<String>()


    private var yellowEventDate = ArrayList<Date>()
    private var yellowEventName = ArrayList<String>()


    private var recyclerViewDate = ArrayList<String>()
    private var recyclerViewText = ArrayList<String>()
    private var eventColor = ArrayList<Int>()
    private var recyclerViewColor = ArrayList<Int>()

    val events: MutableList<EventDay> =
        ArrayList()


    companion object {
        fun newInstance() = SchoolCalendarFragment()
    }

    override fun getLayoutID() = R.layout.fragment_school_calendar

    override fun getViewModel() = SchoolCalendarViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        settingEventRecyclerView()
        setCalendar()
        val userType = Utils.getUserType(mContext)

        if (userType.equals("1")) {

            dataBinding.parentLayout.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.white
                )
            )
        } else if (userType.equals("2") || userType.equals("3")) {
            dataBinding.parentLayout.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.white
                )
            )

        } else {
            dataBinding.parentLayout.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.white
                )
            )
        }

        getCalendarDate(Utils.getStandardId(mContext))
    }


    private fun settingEventRecyclerView() {
        dataBinding.rvEvent.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        dataBinding.rvEvent.hasFixedSize()
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


        val cal1 = Calendar.getInstance()

        val date1 =
            SimpleDateFormat("dd-MM-yyyy").parse(
                (mContext as DashboardActivity).mSessionEndDate
            )
        cal1.time = date1!!
        calender.setMaximumDate(cal1)

        calender.setPreviousButtonImage(
            AppCompatResources.getDrawable(
                mContext,
                R.drawable.ic_left_arrow_black
            )!!
        )



        calender.setForwardButtonImage(
            AppCompatResources.getDrawable(
                mContext,
                R.drawable.ic_right_arrow_black
            )!!
        )

        getAllSundayDate(Calendar.getInstance())?.let {
            dataBinding.calendarView.setDisabledDays(it)
        }


        calender.setOnForwardPageChangeListener(object : OnCalendarPageChangeListener {
            override fun onChange() {

                updateCalendarDate(true)

            }

        })
        calender.setOnPreviousPageChangeListener(object : OnCalendarPageChangeListener {
            override fun onChange() {

                updateCalendarDate(true)

            }
        })

        calender.setOnDayClickListener(object : OnDayClickListener {
            override fun onDayClick(eventDay: EventDay) {


                if (purpleEventDate.contains(eventDay.calendar.time)) {


                    if (mContext is DashboardActivity) {
                        (mContext as DashboardActivity).showCustomToastAnimation(
                            purpleEventName.get(purpleEventDate.indexOf(eventDay.calendar.time)),
                            R.color.event_color,
                            R.color.white
                        )
                    }

                } else if (checkIFYellowExist(eventDay.calendar.time)) {


                }
            }

        })

    }

    private fun checkIFYellowExist(time: Date): Boolean {
        for ((index, data) in yellowEventDate.withIndex()) {
            if (isDateSame(toCalendar(data), toCalendar(time))) {
                if (mContext is DashboardActivity) {
                    if (yellowEventName.get(index) != "") {
                        (mContext as DashboardActivity).showCustomToastAnimation(
                            yellowEventName.get(index),
                            R.color.yellow_color,
                            R.color.black
                        )
                    }
                }
                return true
            }
        }

        return false
    }

    private fun isDateSame(c1: Calendar, c2: Calendar): Boolean {
        return c1[Calendar.YEAR] == c2[Calendar.YEAR]
                && c1[Calendar.MONTH] == c2[Calendar.MONTH]
                && c1[Calendar.DAY_OF_MONTH] == c2[Calendar.DAY_OF_MONTH]
    }

    fun toCalendar(date: Date): Calendar {
        val cal = Calendar.getInstance()
        cal.time = date
        return cal
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("School Calendar")
    }

    override fun onSelect(calendar: List<Calendar>) {

    }

    private fun getCalendarDate(id: String) {
        (mContext as DashboardActivity).showProgress()

        viewModel.getSchoolCalendar(
            Utils.getAccessToken(mContext),
            id
        ).observe(
            viewLifecycleOwner, androidx.lifecycle.Observer {


                if (it.status!!) {

                    if (it.events!!.size > 0) {
                        for (data in it.events!!) {

                            eventList.add(data!!)


                            try {
                                val cal = Calendar.getInstance()

                                val string = Utils.formattedDateFromString(
                                    "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'",
                                    "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'",
                                    data?.startDate
                                )

                                val date =
                                    SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss.SSS'Z'").parse(string)

                                cal.time = date!!

                                /*  val date1 =
                                      SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy").format(
                                          date
                                      )*/



                                eventDate.add(date)
                                eventName.add(data.title!! + "|" + data.remark)
                                eventColor.add(R.color.event_color)

                                enable_weekend(cal)


                                val eventData = if (data.location.equals("")) {
                                    data.title + " | " + data.remark
                                } else {
                                    data.title + " | " + data.location + " | " + data.remark
                                }

                                purpleEventDate.add(date)
                                purpleEventName.add(eventData)

                                events.add(EventDay(cal, R.drawable.blue_dot_small))

                            } catch (e: ParseException) {


                            }


                        }

                    }

                    if (it.holidays!!.size > 0) {

                        for (data in it.holidays!!) {

                            holidaysList.add(data!!)


                            try {
                                val cal = Calendar.getInstance()

                                if (data?.status.equals("HOLIDAY")) {

                                    val string = Utils.formattedDateFromString(
                                        "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'",
                                        "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'",
                                        data?.date
                                    )

                                    val date =
                                        SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss.SSS'Z'").parse(
                                            string
                                        )
                                    cal.time = date!!

                                    eventDate.add(date)

                                    eventName.add(data.remark!!)
                                    eventColor.add(R.color.yellowDark)

                                    yellowEventDate.add(date)
                                    yellowEventName.add(data.remark)

                                    enable_weekend(cal)

                                    events.add(EventDay(cal, R.drawable.yellow_dot_small))

                                }

                                disableDayList?.let {
                                    dataBinding.calendarView.setDisabledDays(it)
                                }

                            } catch (e: ParseException) {


                            }


                        }

                    }


                }

                (mContext as DashboardActivity).runOnUiThread(java.lang.Runnable {
                    dataBinding.calendarView.setEvents(events)
                    updateCalendarDate(false)


                })
                (mContext as DashboardActivity).hideProgress()

            }
        )

    }

    private fun updateCalendarDate(calender_navigation: Boolean) {

        recyclerViewDate.clear()
        recyclerViewText.clear()
        recyclerViewColor.clear()

        var value = (calender.currentPageDate[Calendar.MONTH]);
        var startDate = Date()
        var endDate = Date()
        val c = Calendar.getInstance()
        val year = c[Calendar.YEAR]
        val day = 1
        c.set(year, value, day)
        val numOfDaysInMonth = c.getActualMaximum(Calendar.DAY_OF_MONTH)
        startDate = c.time
        c.add(Calendar.DAY_OF_MONTH, numOfDaysInMonth - 1)
        endDate = c.time


        if (calender_navigation)
            getAllSundayDate(c)

        if (startDate.toString() != "" && endDate.toString() != "") {
            getListForMonth(startDate, endDate)
        }
    }

    public fun getListForMonth(startData: Date, endDate: Date) {
        val formattedStartDate = getDate(startData)
        val formattedEndDate = getDate(endDate)

        if (formattedStartDate != null && formattedEndDate != null) {
            for (i in 0 until eventDate.size) {
                getDate(eventDate[i])?.let { formattedEventDate ->
                    if (formattedEventDate.after(formattedStartDate)
                        && formattedEventDate.before(formattedEndDate)
                        || formattedEventDate == formattedStartDate
                        || formattedEventDate == formattedEndDate
                    ) {

                        val string = Utils.formattedDateFromStringValue(
                            "EEE MMM dd HH:mm:ss zzz yyyy", "dd-MM-yyyy", eventDate.get(i).toString()
                        )
                        recyclerViewDate.add(string!!)

                        recyclerViewText.add(eventName.get(i))

                        recyclerViewColor.add(eventColor.get(i))

                        val cal = Calendar.getInstance()
                        cal.time = eventDate?.get(i)

                        enable_weekend(cal)


                    }
                }
            }
        }


        dataBinding.rvEvent.adapter = SchoolEventAdapter(
            mContext, recyclerViewDate, recyclerViewText, recyclerViewColor
        )

        System.out.println(recyclerViewDate)
        System.out.println(recyclerViewText)

        disableDayList?.let {
            dataBinding.calendarView.setDisabledDays(it)
        }

        dataBinding.calendarView.setEvents(events)
    }

    fun enable_weekend(cal: Calendar) {
        var str_calender = calendar_to_str(cal)
        if (disableDayListStr.contains(str_calender)) {
            disableDayList.removeAt(disableDayListStr.indexOf(str_calender))
            disableDayListStr.remove(str_calender)
        }
    }

    private fun getDate(date: Date): Date? {
        try {
            val dateStr = date.toString()
            val string = Utils.formattedDateFromStringValue(
                "EEE MMM dd HH:mm:ss zzz yyyy", "dd-MM-yyyy", dateStr
            )
            if (string.isNullOrEmpty()) throw ParseException("Cannot parse empty or null string: $string", 0)
            return SimpleDateFormat("dd-MM-yyyy", Locale.ENGLISH).parse(string)
        } catch (e: Exception) {
            Log.e("SchoolCalendarFragment", e.message ?: e.cause.toString())
            return null
        }
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

    var disableDayList: ArrayList<Calendar> = ArrayList()
    var disableDayListStr: ArrayList<String> = ArrayList()
    fun getAllSundayDate(cal: Calendar): ArrayList<Calendar>? {
        //max month next month for Exp: next 2 month from this month
        disableDayList.clear()
        disableDayListStr.clear()
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
                    disableDayListStr.add(calendar_to_str(curCal))
                }
            }
            cal.add(Calendar.MONTH, 1)
        }
        return disableDayList
    }

    fun calendar_to_str(cal: Calendar): String {
        val format1 = SimpleDateFormat("yyyy-MM-dd")
        return format1.format(Date(cal.timeInMillis))
    }
}
