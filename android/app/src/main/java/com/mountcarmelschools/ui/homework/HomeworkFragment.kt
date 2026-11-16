package com.mountcarmelschools.ui.homework

import android.content.Context
import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import androidx.core.view.ViewCompat
import androidx.core.widget.doOnTextChanged
import androidx.recyclerview.widget.LinearLayoutManager
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentHomeworkBinding
import com.mountcarmelschools.di.data.studentDetail.SingleStudentDetail
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

class HomeworkFragment : BaseFragment<FragmentHomeworkBinding, HomeworkViewModel>() {
    private lateinit var context: Context
    private var homeworkListRVAdapter: HomeworkAdapter? = null
    private var studentSubjects: List<SingleStudentDetail.Data.ComboId.Subject?>? = null
    private var monthsList: ArrayList<String>? = null

    private var startDate: String? = null
    private var endDate: String? = null
    private var selectedSubjectId: String? = null

    override fun getLayoutID() = R.layout.fragment_homework

    override fun getViewModel() = HomeworkViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        this.context = context
    }

    override fun onResume() {
        super.onResume()
        (context as DashboardActivity).setHeaderText("Homework")
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // If subjects are available, Configure Subject Picker
        val subjects = (context as DashboardActivity).studentDetail.data?.comboId?.subjects
        subjects?.let { subjectsList ->
            this.studentSubjects = subjectsList

            // Setting Adapter to Subject Picker
            val subjectsNameList = subjectsList.mapNotNull { subject -> subject?.subjectName }
            dataBinding.selectSubjectInput.setAdapter(ArrayAdapter(
                context,
                R.layout.selected_text_view_black,
                subjectsNameList
            ))
            if (subjectsNameList.isNotEmpty()) {
                setSubjectId(0) // setting subject id by default spinner position
            }
            dataBinding.selectSubjectInput.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
                override fun onItemSelected(
                    parent: AdapterView<*>?,
                    view: View?,
                    position: Int,
                    id: Long
                ) {
                    onSelectedSubjectChange(position)
                }

                override fun onNothingSelected(parent: AdapterView<*>?) {
                    onSelectedSubjectChange(-1)
                }
            }
        }

        // Configure Month Picker
        val monthsList = arrayListOf<String>()
        val mmmYYYYFormatter = SimpleDateFormat("MMM yyyy", Locale.ENGLISH)
        val ddMmYYYYFormatter = SimpleDateFormat("dd-MM-yyyy", Locale.ENGLISH)
        val startCalendar = Calendar.getInstance()
        ddMmYYYYFormatter.parse((context as DashboardActivity).mSessionStartDate)?.let {
            startCalendar.time = it
        }
        val endCalendar = Calendar.getInstance()
        ddMmYYYYFormatter.parse((context as DashboardActivity).mSessionEndDate)?.let {
            endCalendar.time = it
        }
        while (startCalendar.before(endCalendar)) {
            val formattedDate = mmmYYYYFormatter.format(startCalendar.time)
            monthsList.add(formattedDate)

            // Increasing month by 1 in start calendar
            startCalendar.add(Calendar.MONTH, 1)
        }
        this.monthsList = monthsList

        // Getting current month position from `monthsList`
        val currentMonthStr = mmmYYYYFormatter.format(Calendar.getInstance().time)
        val currentMonthPos = monthsList.indexOf(currentMonthStr)

        dataBinding.selectDateInput.setAdapter(ArrayAdapter(
            context,
            R.layout.selected_text_view_black,
            monthsList
        ))
        if (currentMonthPos >= 0 && currentMonthPos < monthsList.size) {
            dataBinding.selectDateInput.setSelection(currentMonthPos)

            setStartAndEndDate(currentMonthPos) // setting start & end date as per current month position
        }
        dataBinding.selectDateInput.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onNothingSelected(parent: AdapterView<*>?) {
                onSelectedMonthChange(-1)
            }

            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View?,
                position: Int,
                id: Long
            ) {
                onSelectedMonthChange(position)
            }
        }

        // Configure Recycler View that is Homework List
        dataBinding.homeworksList.layoutManager = LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false)

        // Configure Search Homework Input
        dataBinding.searchInputField.doOnTextChanged { charSeq, start, before, count ->
            homeworkListRVAdapter?.filter?.filter(charSeq)
        }
    }

    private fun onSelectedSubjectChange(selectedPosition: Int) {
        setSubjectId(selectedPosition)

        fetchHomework()
    }

    private fun setSubjectId(selectedPosition: Int) {
        selectedSubjectId = studentSubjects?.getOrNull(selectedPosition)?.id
    }

    private fun onSelectedMonthChange(selectedPosition: Int) {
        setStartAndEndDate(selectedPosition)

        fetchHomework()
    }

    private fun setStartAndEndDate(selectedPosition: Int) {
        try {
            val selectedMonthYearDate = this.monthsList?.getOrNull(selectedPosition)?.let {
                SimpleDateFormat("MMM yyyy", Locale.ENGLISH).parse(it)
            }
            if (selectedMonthYearDate == null) {
                startDate = null
                endDate = null
            } else {
                val (monthStartDate, monthEndDate) = getMonthInterval(selectedMonthYearDate)

                val dateFormatter = SimpleDateFormat("dd-MM-yyyy", Locale.ENGLISH)

                startDate = dateFormatter.format(monthStartDate)
                endDate = dateFormatter.format(monthEndDate)
            }
        } catch (e: ParseException) {
            e.printStackTrace()
            startDate = null
            endDate = null
        }
    }

    private fun fetchHomework() {
        val selectedSubjectId = this.selectedSubjectId
        if (selectedSubjectId == null || selectedSubjectId == "") {
            showErrorToast("Please select subject", context)
            return
        }
        val startDate = this.startDate
        val endDate = this.endDate
        if (startDate.isNullOrEmpty() || endDate.isNullOrEmpty()) {
            showErrorToast("Please select month", context)
            return
        }
        dataBinding.searchInputField.setText("") // clear search input
        (context as DashboardActivity).showProgress() // show loader

        // fetch homework data
        viewModel.getHomework(
            Utils.getAccessToken(context),
            Utils.getUserId(context),
            selectedSubjectId,
            startDate,
            endDate
        ).observe(viewLifecycleOwner) { homeworkRes ->
            (context as DashboardActivity).hideProgress() // hide loader
            val homeworkResponse = homeworkRes ?: return@observe

            if (homeworkResponse.status == true) {
                if (homeworkResponse.data.isNullOrEmpty()) {
                    dataBinding.homeworksList.visibility = View.GONE
                    dataBinding.emptyView.visibility = View.VISIBLE
                } else {
                    ViewCompat.setNestedScrollingEnabled(
                        dataBinding.homeworksList,
                        false
                    );
                    dataBinding.homeworksList.visibility = View.VISIBLE
                    dataBinding.emptyView.visibility = View.GONE
                }
                val adapter = HomeworkAdapter(
                    context,
                    if (homeworkResponse.data.isNullOrEmpty()) listOf() else homeworkResponse.data
                )
                homeworkListRVAdapter = adapter
                dataBinding.homeworksList.adapter = adapter
            } else if (homeworkResponse.message != null) {
                showErrorToast(homeworkResponse.message, context)
            }
        }
    }

    // Utility function
    private fun getMonthInterval(data: Date): Pair<Date, Date> {
        val start = Calendar.getInstance()
        start.time = data
        start[Calendar.DAY_OF_MONTH] = start.getActualMinimum(Calendar.DAY_OF_MONTH)
        start[Calendar.HOUR_OF_DAY] = 0
        start[Calendar.MINUTE] = 0
        start[Calendar.SECOND] = 0

        val end = Calendar.getInstance()
        end.time = data
        end[Calendar.DAY_OF_MONTH] = end.getActualMaximum(Calendar.DAY_OF_MONTH)
        end[Calendar.HOUR_OF_DAY] = 23
        end[Calendar.MINUTE] = 59
        end[Calendar.SECOND] = 59

        return Pair(start.time, end.time)
    }
}