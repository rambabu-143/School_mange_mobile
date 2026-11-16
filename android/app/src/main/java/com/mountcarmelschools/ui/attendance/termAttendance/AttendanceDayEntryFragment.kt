package com.mountcarmelschools.ui.attendance.termAttendance

import android.annotation.SuppressLint
import android.content.Context
import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.RadioGroup
import android.widget.TextView.OnEditorActionListener
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentAttendanceDayEntryBinding
import com.mountcarmelschools.di.data.classList.ClassListDropDownResponse
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils


class AttendanceDayEntryFragment :
    BaseFragment<FragmentAttendanceDayEntryBinding, AttendanceDayEntryViewModel>() {


    private lateinit var mContext: Context
    private var mTerm: String = "1"

    private var mSelectedPosition = 0
    lateinit var mClassListDropDown: List<ClassListDropDownResponse.Data>;

    private lateinit var attandanceAdapter: AttendanceDayEntryAdapter


    companion object {
        fun newInstance() = AttendanceDayEntryFragment()
    }

    override fun getLayoutID() = R.layout.fragment_attendance_day_entry

    override fun getViewModel() = AttendanceDayEntryViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        dataBinding.attendanceDateViewModel = viewModel
        settingStudentListRecyclerView()




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
                    if (mSelectedPosition > 0) {
                        getTermAttendanceSummery(
                            mTerm
                        )
                    }
                }

            }



        dataBinding.edtSearch.setOnEditorActionListener(OnEditorActionListener { _, actionId, event ->
            if (actionId == EditorInfo.IME_ACTION_SEARCH) {
                Utils.hideKeyboard(requireView(), requireContext())
                return@OnEditorActionListener true
            }
            false
        })



        dataBinding.rgTerms.setOnCheckedChangeListener(object : RadioGroup.OnCheckedChangeListener {
            override fun onCheckedChanged(group: RadioGroup?, checkedId: Int) {
                if (dataBinding.rbTerm1.isChecked) {

                    mTerm = "1"
                } else if (dataBinding.rbTerm2.isChecked) {
                    mTerm = "2"
                } else {
                    mTerm = "3"
                }

                if(mSelectedPosition > 0)
                    getTermAttendanceSummery(
                        mTerm
                    )
            }

        })



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
                if (::attandanceAdapter.isInitialized && attandanceAdapter != null) {
                    attandanceAdapter.getFilter().filter(s)
                }
            }
        })

        getClassListForDropDown();
    }


    private fun settingStudentListRecyclerView() {
        dataBinding.rvStudentList.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        dataBinding.rvStudentList.hasFixedSize()

    }


    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Term Attendance")
    }

    @SuppressLint("SetTextI18n")
    private fun getTermAttendanceSummery(
        term: String
    ) {

        (mContext as DashboardActivity).showProgress()

        viewModel.getTermAttendanceSummery(
                Utils.getAccessToken(mContext),
                mClassListDropDown.get(mSelectedPosition - 1).standardId?.id.toString(),
                mClassListDropDown.get(mSelectedPosition - 1)._id.toString(),
                term

        )
            .observe(
                viewLifecycleOwner, Observer {

                    (mContext as DashboardActivity).hideProgress()
                    if (it.data != null && it.data.isNotEmpty()) {

                        dataBinding.tvStudent.text = "Total : " + it.data.size


                        attandanceAdapter = AttendanceDayEntryAdapter(mContext, it.data, it.path!!)

                        dataBinding.rvStudentList.adapter = attandanceAdapter


                        if (!TextUtils.isEmpty(dataBinding.edtSearch.text)) {
                            attandanceAdapter.getFilter().filter(dataBinding.edtSearch.text)
                        }
                    } else {
                        attandanceAdapter = AttendanceDayEntryAdapter(mContext, listOf(), "")

                        dataBinding.tvStudent.text = "Total : 0"

                        dataBinding.rvStudentList.adapter = attandanceAdapter


                    }
            }
            )
    }


    private fun getClassListForDropDown() {

        (mContext as DashboardActivity).showProgress()
        viewModel.getClassListForDropDown(
                Utils.getAccessToken(mContext)
        ).observe(
                viewLifecycleOwner,
                Observer {

                    val list = ArrayList<String>()

                    if (it.status!!) {

                        if (it.data?.size!! > 0) {
                            mClassListDropDown = it.data as List<ClassListDropDownResponse.Data>;

                            list.add("Select")
                            for (data in it.data) {
                                list.add(data?.standard.toString() + " " + data?.section.toString())

                            }


                            // Create adapter and add in AutoCompleteTextView
                            val adapter = ArrayAdapter(
                                    mContext,
                                    android.R.layout.simple_list_item_1, list
                            )
                            dataBinding.sectionList.adapter = adapter

                        }
                    }

                    (mContext as DashboardActivity).hideProgress()

                }
        )


    }


}

