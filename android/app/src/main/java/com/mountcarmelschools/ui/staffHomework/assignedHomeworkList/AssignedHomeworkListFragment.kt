package com.mountcarmelschools.ui.staffHomework.assignedHomeworkList

import android.app.DatePickerDialog
import android.content.Context
import android.content.DialogInterface
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.core.view.ViewCompat
import androidx.core.widget.doOnTextChanged
import androidx.recyclerview.widget.LinearLayoutManager
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentAssignedHomeworkListBinding
import com.mountcarmelschools.di.data.staffhomework.StaffHomeworkResponse
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils
import java.text.SimpleDateFormat
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Calendar
import java.util.Locale

data class DMY (var day: Int = 0, var month: Int = 0, var year: Int = 0) {
    fun isValid(): Boolean {
        return day > 0 && month > 0 && year > 0
    }
    fun isBefore(dmy: DMY): Boolean {
        // If years are not same
        if (this.year != dmy.year) {
            // true when current year is less than given year, false otherwise
            return this.year < dmy.year
        }
        // If months are not same
        if (this.month != dmy.month) {
            // true when current month is less than given month, false otherwise
            return this.month < dmy.month
        }
        return this.day < dmy.day
    }
    override fun toString(): String {
        return "${day.toString().padStart(2, '0')}-${(month + 1).toString().padStart(2, '0')}-$year"
    }
}

class AssignedHomeworkListFragment : BaseFragment<FragmentAssignedHomeworkListBinding, AssignedHomeworkListViewModel>() {
    private lateinit var context: Context
    private var homeworkListRVAdapter: AssignedHomeworkListAdapter? = null

    private var sessionStartDate: Long? = null
    private var sessionEndDate: Long? = null

    private var startDMY: DMY = DMY()
    private var endDMY: DMY = DMY()

    override fun getLayoutID() = R.layout.fragment_assigned_homework_list

    override fun getViewModel() = AssignedHomeworkListViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        this.context = context
    }

    override fun onResume() {
        super.onResume()
        (context as DashboardActivity).setHeaderText("View Assigned Homework")
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        configureStartDateInput()

        configureEndDateInput()

        // Configure Submit Button
        dataBinding.submitButton.setOnClickListener {
            fetchHomeworkList()
        }

        // Configure Recycler View that is Homework List
        dataBinding.homeworksList.layoutManager = LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false)

        // Configure Recycler View Refresh Controller
        dataBinding.homeworksListRefreshController.setColorSchemeResources(R.color.blue, R.color.green, R.color.orange, R.color.red)
        dataBinding.homeworksListRefreshController.setOnRefreshListener {
            fetchHomeworkList { success ->
                dataBinding.homeworksListRefreshController.isRefreshing = false;
                if (success == true) {
                    dataBinding.homeworksList.adapter?.notifyDataSetChanged()
                }
            }
        }

        // Configure Search Homework Input
        dataBinding.searchInputField.doOnTextChanged { charSeq, start, before, count ->
            homeworkListRVAdapter?.filter?.filter(charSeq)
        }

        fetchTermDetails()
        fetchHomeworkList()
    }

    private fun configureStartDateInput() {
        val (dayOfMonth, month, year) = getCurrentDMYComponents()

        setStartDate(year, month, dayOfMonth)

        dataBinding.startDateInput.setOnClickListener {
            val datePickerDialog = DatePickerDialog(
                context,
                R.style.DatePickerDialogTheme,
                { _, year, month, dayOfMonth -> setStartDate(year, month, dayOfMonth) },
                this.startDMY.year,
                this.startDMY.month,
                this.startDMY.day
            )
            sessionStartDate?.let { datePickerDialog.datePicker.minDate = it }
            sessionEndDate?.let { datePickerDialog.datePicker.maxDate = it }

            datePickerDialog.show()
        }
    }

    private fun configureEndDateInput() {
        val (dayOfMonth, month, year) = getCurrentDMYComponents()

        setEndDate(year, month, dayOfMonth)

        dataBinding.endDateInput.setOnClickListener {
            val datePickerDialog = DatePickerDialog(
                context,
                R.style.DatePickerDialogTheme,
                { _, year, month, dayOfMonth -> setEndDate(year, month, dayOfMonth) },
                this.endDMY.year,
                this.endDMY.month,
                this.endDMY.day
            )
            sessionStartDate?.let { datePickerDialog.datePicker.minDate = it }
            sessionEndDate?.let { datePickerDialog.datePicker.maxDate = it }

            datePickerDialog.show()
        }
    }

    private fun getCurrentDMYComponents(): Triple<Int, Int, Int> {
        // on below line we are getting
        // the instance of our calendar.
        val c = Calendar.getInstance()

        // on below line we are getting
        // our day, month and year.
        val year = c.get(Calendar.YEAR)
        val month = c.get(Calendar.MONTH)
        val dayOfMonth = c.get(Calendar.DAY_OF_MONTH)

        return Triple(dayOfMonth, month, year)
    }

    private fun setStartDate(year: Int, month: Int, dayOfMonth: Int) {
        setDate(
            startDMY,
            dataBinding.startDateInput,
            year,
            month,
            dayOfMonth,
        )
    }

    private fun setEndDate(year: Int, month: Int, dayOfMonth: Int) {
        setDate(
            endDMY,
            dataBinding.endDateInput,
            year,
            month,
            dayOfMonth,
        )
    }

    private fun setDate(date: DMY, textView: TextView, year: Int, month: Int, dayOfMonth: Int) {
        date.year = year
        date.month = month
        date.day = dayOfMonth

        val calendar = Calendar.getInstance()
        calendar.set(year, month, dayOfMonth)
        val dateFormatter = SimpleDateFormat("dd MMM, yyyy", Locale.US)
        val dateToDisplay = dateFormatter.format(calendar.time) ?: return

        textView.text = dateToDisplay
        textView.setTextColor(resources.getColor(R.color.black))
        textView.setCompoundDrawables(null, null, null, null)
    }

    private fun validateDates(): Boolean {
        val startDate = this.startDMY
        if (!startDate.isValid()) {
            showErrorToast("Please select start date", context)
            return false
        }
        val endDate = this.endDMY
        if (!endDate.isValid()) {
            showErrorToast("Please select end date", context)
            return false
        }
        if (endDate.isBefore(startDate)) {
            showErrorToast("End date must be equal to or more than Start date!", context)
            return false
        }
        return true
    }

    private fun handleStaffHomeworkListResponse(homeworkResponse: StaffHomeworkResponse) {
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
        val adapter = AssignedHomeworkListAdapter(
            context,
            if (homeworkResponse.data.isNullOrEmpty()) listOf() else homeworkResponse.data,
            dataBinding.searchInputField.text.toString()
        ) {
            presentDeleteConfirmAlert(it)
        }
        homeworkListRVAdapter = adapter
        dataBinding.homeworksList.adapter = adapter
    }

    private fun presentDeleteConfirmAlert(homeworkId: String) {
        val alertDialog = AlertDialog.Builder(context)
        alertDialog.setTitle("Are you sure you want to delete this homework?")
        alertDialog.setPositiveButton("Delete") { dialog: DialogInterface, _: Int ->
            deleteHomeworkById(homeworkId)
            dialog.dismiss()
        }
        alertDialog.setNeutralButton("Cancel") { dialog: DialogInterface, _: Int ->
            dialog.cancel()
            dialog.dismiss()
        }
        alertDialog.show()
    }

    private fun fetchHomeworkList(final: ((success: Boolean?) -> Unit)? = null) {
        val validDates = validateDates()
        if (!validDates) {
            return
        }
        dataBinding.searchInputField.setText("") // clear search input
        (context as DashboardActivity).showProgress() // show loader

        // fetch homework data
        viewModel.getAssignedHomeworkList(
            Utils.getAccessToken(context),
            this.startDMY.toString(),
            this.endDMY.toString()
        ).observe(viewLifecycleOwner) { homeworkRes ->
            (context as DashboardActivity).hideProgress() // hide loader
            val homeworkResponse = homeworkRes ?: run {
                final?.invoke(false)
                return@observe
            }
            if (homeworkResponse.status == true) {
                handleStaffHomeworkListResponse(homeworkResponse)
            } else if (homeworkResponse.message != null) {
                showErrorToast(homeworkResponse.message, context)
            }
            final?.invoke(homeworkResponse.status == true)
        }
    }

    private fun fetchTermDetails() {
        viewModel.getCurrentTermResponse(Utils.getAccessToken(context), "3")
            .observe(viewLifecycleOwner) { checkCurrentTermRes ->
                val checkCurrentTermResponse = checkCurrentTermRes ?: return@observe

                val dateFormatter = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.getDefault())

                if (checkCurrentTermResponse.status == true) {
                    try {
                        checkCurrentTermResponse.data?.startDate?.let { startDateStr ->
                            sessionStartDate = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                LocalDateTime.parse(startDateStr, DateTimeFormatter.ISO_DATE_TIME)?.atZone(ZoneId.systemDefault())?.toInstant()?.toEpochMilli()
                            } else {
                                dateFormatter.parse(startDateStr)?.time
                            }
                        }
                        checkCurrentTermResponse.data?.endDate?.let { endDateStr ->
                            sessionEndDate = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                LocalDateTime.parse(endDateStr, DateTimeFormatter.ISO_DATE_TIME)?.atZone(ZoneId.systemDefault())?.toInstant()?.toEpochMilli()
                            } else {
                                dateFormatter.parse(endDateStr)?.time
                            }
                        }
                    } catch (error: Exception) {
                        Log.e("AssignedHomeworkListFragment", "${error.message}")
                    }
                } else if (checkCurrentTermResponse.message != null) {
                    showErrorToast(checkCurrentTermResponse.message, context)
                }
            }
    }

    private fun deleteHomeworkById(homeworkId: String) {
        val validDates = validateDates()
        if (!validDates) {
            return
        }
        (context as DashboardActivity).showProgress() // show loader

        // fetch homework data
        viewModel.deleteAssignedHomework(
            Utils.getAccessToken(context),
            homeworkId,
            this.startDMY.toString(),
            this.endDMY.toString()
        ).observe(viewLifecycleOwner) { deleteHomeworkRes ->
            (context as DashboardActivity).hideProgress() // hide loader
            val homeworkResponse = deleteHomeworkRes ?: run {
                return@observe
            }
            if (homeworkResponse.status == true) {
                handleStaffHomeworkListResponse(homeworkResponse)
            } else if (homeworkResponse.message != null) {
                showErrorToast(homeworkResponse.message, context)
            }
        }
    }
}