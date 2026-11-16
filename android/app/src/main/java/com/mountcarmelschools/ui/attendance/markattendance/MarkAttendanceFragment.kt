package com.mountcarmelschools.ui.attendance.markattendance

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.os.SystemClock
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.view.*
import android.view.inputmethod.EditorInfo
import android.widget.*
import androidx.cardview.widget.CardView
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.gson.Gson
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentMarkAttendanceBinding
import com.mountcarmelschools.di.data.staff.markAttandance.MarkAttendanceResponse
import com.mountcarmelschools.di.data.staff.markAttendance.MarkedAttendanceRequestBody
import com.mountcarmelschools.ui.attendance.studentattendance.AttendanceFragment.Companion.clear_class_selection
import com.mountcarmelschools.ui.attendance.studentattendance.StudentAttendanceMarkAdapter
import com.mountcarmelschools.ui.commonAdapter.CommonInterface
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils
import java.text.SimpleDateFormat
import java.util.*


class MarkAttendanceFragment :
    BaseFragment<FragmentMarkAttendanceBinding, MarkAttendanceViewModel>(),
    MarkAttendanceInterface, DialogInterface, CommonInterface {

    private lateinit var mContext: Context
    private lateinit var mMarkStudentList: MutableList<MarkAttendanceResponse.Data?>
    private lateinit var mSelectedStudent: ArrayList<MarkAttendanceResponse.Data?>
    private lateinit var sectionChangedStudentsList: List<MarkedAttendanceRequestBody.StudentId>

    private lateinit var mPath: String
    private lateinit var mClass: String
    private lateinit var mDate: String
    private lateinit var mId: String
    private lateinit var mStandardId: String
    private lateinit var mTextViewForCarryForward: TextView

    private lateinit var studentAdapter: StudentAttendanceMarkAdapter;

    private var reasonList = ArrayList<String>()


    private var mLastClickTime: Long = 0

    companion object {
        fun newInstance() = MarkAttendanceFragment()
    }

    override fun getLayoutID() = R.layout.fragment_mark_attendance

    override fun getViewModel() = MarkAttendanceViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)


    }

    @SuppressLint("SetTextI18n")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        mMarkStudentList = Gson().fromJson(        // Back to another variable
            arguments?.getString("json"), Array<MarkAttendanceResponse.Data>::class.java
        ).toMutableList()

        sectionChangedStudentsList = mMarkStudentList.mapNotNull { student ->
            val studentId = student?.id
            if (studentId == null || student.isSectionChanged == true) {
                return@mapNotNull null
            } else {
                return@mapNotNull MarkedAttendanceRequestBody.StudentId(studentId)
            }
        }

        mPath = arguments?.getString("path").toString()

        mClass = arguments?.getString("class").toString()
        mDate = arguments?.getString("date").toString()
        mStandardId = arguments?.getString("standard_id").toString()
        mId = arguments?.getString("id").toString()

        dataBinding.tvClass.text = "${mClass}, Total : ${mMarkStudentList.count()}"

        dataBinding.tvTodayDate.text = mDate
        dataBinding.rvStudentList.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        dataBinding.rvStudentList.hasFixedSize()
        studentAdapter = StudentAttendanceMarkAdapter(
            mContext,
            mMarkStudentList,
            listOf(),
            0,
            mPath,
            this
        )
        dataBinding.rvStudentList.adapter = studentAdapter

        dataBinding.btnMarkattendance.setOnClickListener {


            if (SystemClock.elapsedRealtime() - mLastClickTime < 1000) {
                return@setOnClickListener;
            }
            mLastClickTime = SystemClock.elapsedRealtime();

            mSelectedStudent = ArrayList()

            mSelectedStudent.clear()

            for (i in mMarkStudentList.indices) {
                if (!mMarkStudentList[i]?.first.equals("") || !mMarkStudentList[i]?.second.equals("")) {

                    mSelectedStudent.add(mMarkStudentList.get(i))
                }

            }
            if (mSelectedStudent.size > 0) {
                openDialog()
                /*       val inflater = layoutInflater
                       val dialoglayout: View = inflater.inflate(R.layout.markattendance_student_dialog, null)
                       val builder = AlertDialog.Builder(requireActivity())
                       builder.setView(dialoglayout)
                       builder.show()*/

            } else
                showErrorToast(getString(R.string.please_select_student), mContext)

        }

        getReason()

        dataBinding.edtSearch.addTextChangedListener(object : TextWatcher {
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
                if (studentAdapter != null) {
                    studentAdapter.getFilter().filter(s)
                }
            }
        })

        dataBinding.icDots.setOnClickListener {

            val dialog = BottomSheetDialog(requireContext())
            val bottomSheet = layoutInflater.inflate(R.layout.bottom_sheet_mark_attendance, null)


            val cancel: TextView = bottomSheet.findViewById(R.id.cancel) as TextView
            val mark_all_absent: TextView =
                bottomSheet.findViewById(R.id.mark_all_absent) as TextView
            val mark_all_present: TextView =
                bottomSheet.findViewById(R.id.mark_all_present) as TextView
            val carry_forward: TextView = bottomSheet.findViewById(R.id.carry_forward) as TextView


            cancel.setOnClickListener {
                dialog.dismiss()
                dialog.cancel()
            }


            mark_all_present.setOnClickListener {

                dialog.dismiss()
                dialog.cancel()
                markAllPresent()

            }

            mark_all_absent.setOnClickListener {
                dialog.dismiss()
                dialog.cancel()
                markAllAbsentReason()
            }

            carry_forward.setOnClickListener {

                showCarryForward()
                dialog.dismiss()
                dialog.cancel()

            }


            dialog.setContentView(bottomSheet)
            dialog.show()

        }

    }

    private fun showCarryForward() {

        val dialogBuilder = AlertDialog.Builder(requireContext())
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.carry_forward_dialog, null)
        dialogBuilder.setView(dialogView)


        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()

        mTextViewForCarryForward = dialog.findViewById(R.id.edt_calendar);

        val ic_go_carryforward = dialog.findViewById<TextView>(R.id.ic_go_carryforward);
        ic_go_carryforward.setOnClickListener {
            dialog.dismiss()
            dialog.cancel()
            if (mTextViewForCarryForward.text != "") {
                getStudentListForMarkAttendance(
                    mStandardId, mId
                )
            }
        }

        val ic_close_carryForward = dialog.findViewById<TextView>(R.id.ic_close_carryForward);

        ic_close_carryForward.setOnClickListener {
            dialog.dismiss()
            dialog.cancel()

        }

        mTextViewForCarryForward.setOnClickListener {
            val startDateCal = Calendar.getInstance()

            val date =
                SimpleDateFormat("dd-MM-yyyy").parse(
                    (mContext as DashboardActivity).mSessionStartDate
                )
            startDateCal.time = date!!


            Utils.showCalendarDialogWithFixDates(mContext, this, startDateCal)


        }

    }


    private fun getStudentListForMarkAttendance(standard_id: String, id: String) {


        var first: Boolean = false

        (mContext as DashboardActivity).showProgress()

        viewModel.getStudentMarkedResponseFromDate(
            Utils.getAccessToken(mContext),
            standard_id,
            id,
            mTextViewForCarryForward.text.toString()
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

                            mMarkStudentList.toList().forEach {
                                mMarkStudentList.remove(it)
                            }

                            mMarkStudentList.addAll(updateList)

                            studentAdapter.updateData(updateList)


                            //


                        }
                    } else {

                        showErrorToast(it.message!!, mContext)

                    }

                }
            )


    }


    private fun markAllAbsentReason() {
        val dialogBuilder = AlertDialog.Builder(requireContext())
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.all_absent_select_reason_dialog, null)
        dialogBuilder.setView(dialogView)


        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()
        var mSelectedReason = ""
        var mSelectedDetails = ""
        var mSelectedInformation = ""


        val ic_close = dialogView.findViewById<TextView>(R.id.ic_close)
        ic_close.setOnClickListener {
            dialog.dismiss()
            dialog.cancel()
        }
        val ic_save = dialogView.findViewById<TextView>(R.id.ic_save)
        val information = dialogView.findViewById<Spinner>(R.id.information)
        val reason = dialogView.findViewById<Spinner>(R.id.reason)
        val others = dialogView.findViewById<EditText>(R.id.others)
        val otherLayout = dialogView.findViewById<CardView>(R.id.otherLayout)

        ic_save.setOnClickListener {
            if (mSelectedInformation.equals("Information Received")) {

                showErrorToast(
                    "Please update Information Received for all students marked absent",
                    mContext
                )

            } else if (mSelectedReason.lowercase() == "others" && mSelectedDetails == ""
            ) {
                showErrorToast("Enter others reason", mContext)

            } else {
                dialog.dismiss()
                dialog.cancel()

                markAllAbsent(mSelectedReason, mSelectedDetails, mSelectedInformation)
            }
        }


        val infoArr = arrayOf("Information Received", "YES", "NO")


        val adapter = ArrayAdapter(
            requireContext(),
            R.layout.selected_text_view, infoArr
        )
        val reasonAdapter = ArrayAdapter(
            requireContext(),
            R.layout.selected_text_view, reasonList
        )

        information?.adapter = adapter

        reason.adapter = reasonAdapter
        information?.onItemSelectedListener =
            object : AdapterView.OnItemSelectedListener {
                override fun onNothingSelected(parent: AdapterView<*>?) {

                }

                override fun onItemSelected(
                    parent: AdapterView<*>?,
                    view: View?,
                    position: Int,
                    id: Long
                ) {
                    mSelectedInformation = infoArr[position]
                }

            }

        others!!.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(s: Editable) {

                mSelectedDetails = s.toString()
            }

            override fun beforeTextChanged(
                s: CharSequence, start: Int,
                count: Int, after: Int
            ) {
            }

            override fun onTextChanged(
                s: CharSequence, start: Int,
                before: Int, count: Int
            ) {

            }
        })

        reason?.onItemSelectedListener =
            object : AdapterView.OnItemSelectedListener {
                override fun onNothingSelected(parent: AdapterView<*>?) {

                }

                override fun onItemSelected(
                    parent: AdapterView<*>?,
                    view: View?,
                    position: Int,
                    id: Long
                ) {
                    if (!reasonList[position].equals("Select Reason")) {
                        if (reasonList[position].toString().lowercase().equals("others")) {

                            mSelectedReason = reasonList[position]

                            otherLayout!!.visibility = View.VISIBLE

                            others!!.setImeOptions(EditorInfo.IME_ACTION_DONE);

                        } else {
                            mSelectedReason = reasonList[position].toString()
                            otherLayout!!.visibility = View.GONE
                        }
                    } else if (reasonList[position].equals("Select Reason")) {
                        otherLayout!!.visibility = View.GONE
                        mSelectedReason = ""
                    }
                }

            }


    }

    private fun markAllPresent() {

        val dialogBuilder = AlertDialog.Builder(requireContext())
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.all_present_dialog, null)
        dialogBuilder.setView(dialogView)


        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()


        val save = dialogView.findViewById<TextView>(R.id.save)

        val close = dialogView.findViewById<TextView>(R.id.close)


        save.setOnClickListener {

            dialog.dismiss()
            dialog.cancel()

            if (SystemClock.elapsedRealtime() - mLastClickTime < 1000) {
                return@setOnClickListener;
            }
            mLastClickTime = SystemClock.elapsedRealtime();

            var studentList = ArrayList<MarkedAttendanceRequestBody.Student>()

            val markedAttendanceRequestBody = MarkedAttendanceRequestBody(
                mStandardId,
                mId,
                mDate,
                studentList,
                sectionChangedStudentsList,
                sectionChangedStudentsList.size,
            )
            updateAttendance(markedAttendanceRequestBody, null, 1)

            // (mContext as DashboardActivity).supportFragmentManager.popBackStack()
        }



        close.setOnClickListener {
            dialog.dismiss()
        }

    }

    private fun markAllAbsent(reason: String, details: String, information: String) {

        val dialogBuilder = AlertDialog.Builder(requireContext())
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.all_absent_dialog, null)
        dialogBuilder.setView(dialogView)


        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()
        val ic_save_absent = dialogView.findViewById<TextView>(R.id.ic_save_absent)
        val ic_close_absent = dialogView.findViewById<TextView>(R.id.ic_close_absent)



        ic_save_absent.setOnClickListener {

            dialog.dismiss()
            dialog.cancel()

            if (SystemClock.elapsedRealtime() - mLastClickTime < 1000) {
                return@setOnClickListener;
            }
            mLastClickTime = SystemClock.elapsedRealtime();

            val studentList = ArrayList<MarkedAttendanceRequestBody.Student>()

            for (data in mMarkStudentList) {

                studentList.add(
                    MarkedAttendanceRequestBody.Student(
                        data!!.id, "full", 1.0, reason, details, information
                    )
                )
            }

            val markedAttendanceRequestBody = MarkedAttendanceRequestBody(
                mStandardId,
                mId,
                mDate,
                studentList,
                sectionChangedStudentsList,
                sectionChangedStudentsList.size,
            )
            updateAttendance(markedAttendanceRequestBody, null, 1)

        }



        ic_close_absent.setOnClickListener {
            dialog.dismiss()
        }

    }


    private fun getReason() {
        reasonList.clear()
        (mContext as DashboardActivity).showProgress()

        viewModel.getReason(
            Utils.getAccessToken(mContext)
        ).observe(viewLifecycleOwner, Observer {
            (mContext as DashboardActivity).hideProgress()

            reasonList.add("Select Reason")

            for (value in it.data!!) {
                reasonList.add(value?.reason!!)
            }
        })
    }


    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText(mContext.resources.getString(R.string.mark_attendance))
    }

    override fun selectedValue(type: String, id: String) {


    }

    override fun firstSelect(id: String, type: Boolean) {


        for (i in mMarkStudentList.indices) {
            if (mMarkStudentList[i]?.id.equals(id)) {
                if (type) {
                    mMarkStudentList[i]?.first = "first"
                } else {
                    mMarkStudentList[i]?.first = ""

                }
            }

        }


    }

    override fun secondSelect(id: String, type: Boolean) {
        for (i in mMarkStudentList.indices) {
            if (mMarkStudentList[i]?.id.equals(id)) {
                if (type) {
                    mMarkStudentList[i]?.second = "second"
                } else {
                    mMarkStudentList[i]?.second = ""

                }
            }

        }

    }

    override fun selectedReason(str: String, id: String) {
        for (i in mSelectedStudent.indices) {
            if (mSelectedStudent[i]?.id.equals(id)) {
                mSelectedStudent[i]?.reason = str
            }
        }
    }

    override fun selectedInfo(str: String, id: String) {
        for (i in mSelectedStudent.indices) {
            if (mSelectedStudent[i]?.id.equals(id)) {
                mSelectedStudent[i]?.information = str
            }
        }
    }

    override fun enteredOtherReason(str: String, id: String) {
        for (i in mSelectedStudent.indices) {
            if (mSelectedStudent[i]?.id.equals(id)) {
                mSelectedStudent[i]?.others = str
            }
        }
    }

    private fun openDialog() {
        val dialogBuilder = AlertDialog.Builder(mContext)
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.markattendance_student_dialog, null)
        dialogBuilder.setView(dialogView)


        val b = dialogBuilder.create()
        b.setContentView(R.layout.markattendance_student_dialog)
        b.setCancelable(false)
        b.setCanceledOnTouchOutside(false)
        b.show()


        b.window!!.clearFlags(
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM
        )

        val recyclerViewList = dialogView.findViewById(R.id.recyclerView) as RecyclerView
        val totalStudent = dialogView.findViewById(R.id.totalStudent) as TextView
        val date = dialogView.findViewById(R.id.date) as TextView
        val className = dialogView.findViewById(R.id.className) as Button
        val submit = dialogView.findViewById(R.id.submit) as Button
        val close = dialogView.findViewById(R.id.close) as ImageView

        className.text = mClass

        date.text = mDate

        totalStudent.text = "Total : ${mSelectedStudent.count()}"


        recyclerViewList.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        recyclerViewList.hasFixedSize()

        val adp = MarkAttendanceDialogAdapter(mContext, mSelectedStudent, mPath, this, reasonList)
        recyclerViewList.adapter = adp


        close.setOnClickListener {
            b.dismiss()
            b.cancel()
        }

        submit.setOnClickListener {

            if (SystemClock.elapsedRealtime() - mLastClickTime < 1000) {
                return@setOnClickListener;
            }
            mLastClickTime = SystemClock.elapsedRealtime();

            var studentList = ArrayList<MarkedAttendanceRequestBody.Student>()
            var check_missing_param = false
            var check_missing_param_other = false
            for (data in mSelectedStudent) {

                //   || TextUtils.isEmpty(data?.reason)
                if (TextUtils.isEmpty(data?.information)) {
                    check_missing_param = true
                    break
                }
                if (data?.reason != null &&
                    data.reason.toString().lowercase().equals("others")
                    && data.others.equals("")
                ) {
                    check_missing_param_other = true
                    break
                }


                var type = ""
                var value: Double
                if (data!!.first.equals("first") &&
                    data.second.equals("second")
                ) {
                    type = "full"
                    value = 1.0
                } else if (data.first.equals("first")) {

                    type = "first"
                    value = 0.5
                } else {

                    type = "second"
                    value = 0.5
                }
                studentList.add(
                    MarkedAttendanceRequestBody.Student(
                        data.id, type, value, data.reason, "", data.information
                    )
                )
            }

            if (check_missing_param) {
                showErrorToast(
                    "Please update Information Received for all students marked absent",
                    mContext
                )
            } else if (check_missing_param_other) {
                showErrorToast("Enter others reason", mContext)
            } else {
                b.dismiss()
                b.cancel()
                openTotalDialog()
            }

        }


        //added to just to fix adapter visibility
        Handler().postDelayed({
            try {
                adp.notifyDataSetChanged()
            } catch (ex: Exception) {
                //
            }
        }, 100)


    }

    private fun updateAttendance(
        json: MarkedAttendanceRequestBody?,
        dialog: AlertDialog?,
        i: Int

    ) {

        (mContext as DashboardActivity).showProgress()

        if (i == 0) {

        }
        viewModel.markAttendance(
            Utils.getAccessToken(mContext),
            json
        ).observe(viewLifecycleOwner, Observer {
            (mContext as DashboardActivity).hideProgress()
            if (i == 0) {
            }
            it?.message?.let { it1 ->
                if (i == 0 && dialog != null) {
                    dialog.dismiss()
                }
                showSuccessToast(it1, mContext)
                (mContext as DashboardActivity).supportFragmentManager.popBackStack()
                //showSuccessToast(it1, mContext)
                //openTotalDialog()
            }
        })
    }


    @SuppressLint("SetTextI18n")
    fun openTotalDialog() {
        val dialogBuilder = AlertDialog.Builder(mContext)
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.total_student_dialog, null)
        dialogBuilder.setView(dialogView)


        val b = dialogBuilder.create()
        b.setCancelable(false)
        b.setCanceledOnTouchOutside(false)
        b.show()

        val date = dialogView.findViewById(R.id.date) as TextView
        val totalTxt = dialogView.findViewById(R.id.totalTxt) as TextView
        val presentTxt = dialogView.findViewById(R.id.presentTxt) as TextView
        val halfDay = dialogView.findViewById(R.id.halfDay) as TextView
        val fullDay = dialogView.findViewById(R.id.fullDay) as TextView
        val className = dialogView.findViewById(R.id.className) as Button
        val close = dialogView.findViewById(R.id.close) as ImageView
        val submit = dialogView.findViewById(R.id.submit) as Button

        className.text = mClass

        date.text = mDate

        clear_class_selection = true

        close.setOnClickListener {

            b.dismiss()
            b.cancel()

            // (mContext as DashboardActivity).supportFragmentManager.popBackStack()
        }


        submit.setOnClickListener {

            b.dismiss()
            b.cancel()

            if (SystemClock.elapsedRealtime() - mLastClickTime < 1000) {
                return@setOnClickListener;
            }
            mLastClickTime = SystemClock.elapsedRealtime();

            var studentList = ArrayList<MarkedAttendanceRequestBody.Student>()
            var check_missing_param = false
            for (data in mSelectedStudent) {

                //   || TextUtils.isEmpty(data?.reason)
                if (TextUtils.isEmpty(data?.information)) {
                    check_missing_param = true
                    break
                }


                var type = ""
                var value: Double
                if (data!!.first.equals("first") &&
                    data.second.equals("second")
                ) {
                    type = "full"
                    value = 1.0
                } else if (data.first.equals("first")) {

                    type = "first"
                    value = 0.5
                } else {

                    type = "second"
                    value = 0.5
                }
                studentList.add(
                    MarkedAttendanceRequestBody.Student(
                        data.id, type, value, data.reason, data.others, data.information
                    )
                )
            }

            if (check_missing_param)
                showErrorToast(
                    "Please update Information Received for all students marked absent",
                    mContext
                )
            else {
                val markedAttendanceRequestBody = MarkedAttendanceRequestBody(
                    mStandardId,
                    mId,
                    mDate,
                    studentList,
                    sectionChangedStudentsList,
                    sectionChangedStudentsList.size,
                )
                updateAttendance(markedAttendanceRequestBody, b, 0)
            }

            // (mContext as DashboardActivity).supportFragmentManager.popBackStack()
        }




        totalTxt.text = "${mMarkStudentList.count()}"
        presentTxt.text = "" + (mMarkStudentList.count() - mSelectedStudent.count())
        //  absentTxt.text = "${mSelectedStudent.count()}"

        var halfTotal: Int = 0
        var fullTotal: Int = 0

        for (data in mSelectedStudent) {


            if (data!!.first.equals("first") &&
                data.second.equals("second")
            ) {
                fullTotal += 1
            } else if (data.first.equals("first")) {

                halfTotal += 1

            } else {

                halfTotal += 1

            }
        }

        fullDay.text = fullTotal.toString()
        halfDay.text = halfTotal.toString()

    }

    override fun selectedDate(date: String) {
        mTextViewForCarryForward.text = date
    }

    override fun selectClass(classId: String) {

    }

    override fun selectHouseId(houseId: String) {

    }


}
