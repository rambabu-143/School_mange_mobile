package com.mountcarmelschools.ui.classlist

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.health.connect.datatypes.units.Percentage
import android.media.Image
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.ImageView
import android.widget.TextView
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentClassListBinding
import com.mountcarmelschools.di.data.classList.ClassListDropDownResponse
import com.mountcarmelschools.di.data.classList.ClassListResponse
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.ui.login.LoginActivity
import com.mountcarmelschools.utlis.SharedPreferenceUtils
import com.mountcarmelschools.utlis.Utils
import java.text.DecimalFormat


class ClassListFragment : BaseFragment<FragmentClassListBinding, ClassListViewModel>(), ClassListInterface {

    private lateinit var mContext: Context

    private var mSelectedPosition = 0

    lateinit var mClassListDropDown: List<ClassListDropDownResponse.Data>;

    companion object {
        fun newInstance() = ClassListFragment()
    }

    override fun getLayoutID() = R.layout.fragment_class_list

    override fun getViewModel() = ClassListViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        // TODO: Use the ViewModel
    }


    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText(getString(R.string.class_list))

        settingStudentListRecyclerView()
        getClassListForDropDown()


        /*  val list = ArrayList<String>()
          list.add("Select")
          for (AccessStandardSection in (mContext as DashboardActivity).staffDetail.data?.schools?.get(
              0
          )!!.accessStandardSection!!) {

              list.add(AccessStandardSection?.standard.toString() + " " + AccessStandardSection?.section.toString())
          }

          settingStudentListRecyclerView()

          // Create adapter and add in AutoCompleteTextView
          val adapter = ArrayAdapter(
              mContext,
              android.R.layout.simple_list_item_1, list
          )
          dataBinding.sectionList.setAdapter(adapter)
  */



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
        dataBinding.btnGo.setOnClickListener {
            if(mSelectedPosition > 0)
            getClassList(
                    mClassListDropDown.get(mSelectedPosition-1)._id.toString()
            )
            else
                showErrorToast("Please select class", mContext)
        }

        // getClassList("5e805e7fba400d5f03d1d874")


    }

    private fun settingStudentListRecyclerView() {
        dataBinding.rvStudentList.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        dataBinding.rvStudentList.hasFixedSize()

    }

    private fun getClassList(sectionId: String) {


        (mContext as DashboardActivity).showProgress()
        viewModel.getClassList(
            Utils.getAccessToken(mContext),
            sectionId
        ).observe(
            viewLifecycleOwner,
            Observer {


                if (it.status!!) {

                    if (it.data?.size!! > 0) {
                        dataBinding.rvStudentList.adapter =
                            ClassListAdapter(
                                mContext,
                                it.data,
                                it.path!!,
                                this
                            )
                    } else {
                            showErrorToast("There is no record for the selected class", mContext)
                    }
                }

                (mContext as DashboardActivity).hideProgress()

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
                            dataBinding.sectionList.setAdapter(adapter)


                        }
                    }

                    (mContext as DashboardActivity).hideProgress()

                }
        )


    }

    @SuppressLint("SetTextI18n")
    override fun selectedClassList(get: ClassListResponse.Data?) {


        val percentageData = get?.attendance_data?.total_days?.let {
            (get.attendance_data.total_present?.times(100))?.div(
                it.toInt())
        }
        val percentage:Double = String.format("%.2f", percentageData).toDouble()


        val dialogBuilder = AlertDialog.Builder(mContext)
        val inflater =
            (mContext).getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val dialogView: View = inflater.inflate(R.layout.dialog_class_list, null)
        dialogBuilder.setView(dialogView)

        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()

        val headingName = dialogView.findViewById(R.id.headingName) as TextView
        val mobileNo = dialogView.findViewById(R.id.mobileNo) as TextView
        val wise = dialogView.findViewById(R.id.wise) as TextView
        val disciplinaryCard = dialogView.findViewById(R.id.disciplinaryCard) as TextView
        val totalAttendance = dialogView.findViewById(R.id.totalAttendance) as TextView
        val attendance = dialogView.findViewById(R.id.attendance) as TextView
        val ic_close = dialogView.findViewById(R.id.ic_close) as ImageView

        headingName.text = "${get?.name} - ${get?.admissionNo}"
        mobileNo.text = "a) Mobile no. for SMS : ${get?.smsMobile}"
        wise.text = "b) WISE : ${get?.wise?.total}"
        disciplinaryCard.text = "c) Disciplinary cards : ${get?.disciplinary?.total}"

        val totalPresent = DecimalFormat("#.######").format(get?.attendance_data?.total_present)
        val totalDays = DecimalFormat("#.######").format(get?.attendance_data?.total_days)
        totalAttendance.text = "d) Total Attendance : ${totalPresent}/${totalDays} (${percentage}%)"
        attendance.text = "e) Today's Attendance : ${get?.attendance_data?.today_attendance}"
        ic_close.setOnClickListener {
            dialog.cancel()
            dialog.dismiss()
        }

    }


}
