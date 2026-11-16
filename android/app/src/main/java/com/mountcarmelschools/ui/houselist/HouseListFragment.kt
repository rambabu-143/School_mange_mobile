package com.mountcarmelschools.ui.houselist

import android.app.AlertDialog
import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentHouseListBinding
import com.mountcarmelschools.di.data.classList.ClassListDropDownResponse
import com.mountcarmelschools.di.data.staff.houseList.GetHouseList
import com.mountcarmelschools.di.data.staff.houseList.HouseListResponse
import com.mountcarmelschools.ui.attendance.markattendance.MarkAttendanceInterface
import com.mountcarmelschools.ui.attendance.studentattendance.StudentAttendanceMarkAdapter
import com.mountcarmelschools.ui.commonAdapter.CommonInterface
import com.mountcarmelschools.ui.commonAdapter.StudentStandardAdapter
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils

class HouseListFragment : BaseFragment<FragmentHouseListBinding, HouseListViewModel>(),
    CommonInterface, MarkAttendanceInterface {

    private lateinit var mContext: Context

    private lateinit var studentList: ArrayList<String>
    private lateinit var mStudentListName: ArrayList<String>
    private lateinit var mHouseList: ArrayList<String>
    private lateinit var mHouseListName: ArrayList<String>
    private lateinit var mStandardAdapter: StudentStandardAdapter
    private lateinit var mHouseNameAdapter: HosueNameAdapter

    private lateinit var mStudentSelectImage: ImageView
    private lateinit var mHouseSelectImage: ImageView

    private var mHouseSelectAll: Boolean = false
    private var mStudentSelectAll: Boolean = false

    companion object {
        fun newInstance() = HouseListFragment()
    }

    private lateinit var houseListResponse: GetHouseList
    private lateinit var classListResponse: ClassListDropDownResponse

    override fun getLayoutID() = R.layout.fragment_house_list

    override fun getViewModel() = HouseListViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText(getString(R.string.house_list))
        settingStudentListRecyclerView()
    }

    lateinit var house_list_data: MutableList<GetHouseList.Data?>
    lateinit var classListData: MutableList<ClassListDropDownResponse.Data?>

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        settingStudentListRecyclerView()
        studentList = ArrayList<String>()
        mHouseList = ArrayList<String>()
        mHouseListName = ArrayList<String>()
        mStudentListName = ArrayList<String>()
        house_list_data = ArrayList()
        classListData = ArrayList()



        getHouseList()
        getClassListForDropDown()
        mHouseNameAdapter = HosueNameAdapter(
            mContext,
            house_list_data,
            this,
            ArrayList()
        )

        mStandardAdapter = StudentStandardAdapter(
                mContext,
                classListData,
                this,
                ArrayList()
        )


        dataBinding.classList.setOnClickListener {
            setupCLassListDialog()
        }



        dataBinding.houseList.setOnClickListener {

           houseListDialog()
        }


        dataBinding.btnGo.setOnClickListener {

            if (mHouseList.size == 0) {
                showErrorToast("Please select House", mContext)

            } else if (studentList.size == 0) {

                showErrorToast("Please select class section", mContext)

            } else {
                getHouseListResponse()
            }
        }

    }

    private fun setupCLassListDialog() {

        val dialogBuilder = AlertDialog.Builder(mContext)
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.selected_secton_dialog, null)
        dialogBuilder.setView(dialogView)


        val b = dialogBuilder.create()

        val heading = dialogView.findViewById(R.id.heading) as TextView

        val recyclerViewList = dialogView.findViewById(R.id.recyclerView) as RecyclerView
        val submit = dialogView.findViewById(R.id.submit) as Button
        mStudentSelectImage = dialogView.findViewById(R.id.selectAllImg) as ImageView
        submit.setOnClickListener {
            b.dismiss()
            updateCount()

        }


        recyclerViewList.layoutManager = LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)

        recyclerViewList.adapter = mStandardAdapter


        if (!mStudentSelectAll) {

            mStudentSelectImage.setImageResource(R.drawable.ic_check_box_outline)

        } else {
            mStudentSelectImage.setImageResource(R.drawable.ic_baseline_check_box)

        }




        heading.text = "Select Class"


        mStudentSelectImage.setOnClickListener {

            if (mStudentSelectImage.drawable.constantState == ContextCompat.getDrawable(
                    mContext,
                    R.drawable.ic_baseline_check_box
                )?.constantState
            ) {

                mStudentSelectAll = false

                mStudentSelectImage.setImageResource(R.drawable.ic_check_box_outline)
                studentList.clear()
                mStandardAdapter.updateValue(ArrayList<String>(), true)


            } else {

                mStudentSelectAll = true
                mStudentSelectImage.setImageResource(R.drawable.ic_baseline_check_box)
                for (data in classListData) {

                    studentList.add("" + data?._id.toString())
                }

                mStandardAdapter.updateValue(studentList, false)

            }


        }

        b.show()
        //-- just to fix first time visibility issue ... bug in adapter setting process
        Handler().postDelayed({
            try {
                mStandardAdapter.notifyDataSetChanged()
            }catch (ex: Exception){
                //ignore
            }
        }, 100)

    }

    private fun houseListDialog(){

        val dialogBuilder = AlertDialog.Builder(mContext)
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.selected_secton_dialog, null)
        dialogBuilder.setView(dialogView)


        val recyclerViewList = dialogView.findViewById(R.id.recyclerView) as RecyclerView
        val submit = dialogView.findViewById(R.id.submit) as Button
        val heading = dialogView.findViewById(R.id.heading) as TextView

        mHouseSelectImage = dialogView.findViewById(R.id.selectAllImg) as ImageView

        recyclerViewList.layoutManager = LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)

        recyclerViewList.adapter = mHouseNameAdapter

        if (!mHouseSelectAll) {

            mHouseSelectImage.setImageResource(R.drawable.ic_check_box_outline)

        } else {
            mHouseSelectImage.setImageResource(R.drawable.ic_baseline_check_box)

        }

        heading.text = "Select House"



        mHouseSelectImage.setOnClickListener {

            if (mHouseSelectImage.drawable.constantState == ContextCompat.getDrawable(
                    mContext,
                    R.drawable.ic_baseline_check_box
                )?.constantState
            ) {
                mHouseSelectAll = false

                mHouseSelectImage.setImageResource(R.drawable.ic_check_box_outline)
                mHouseList.clear()
                mHouseListName.clear()
                mHouseNameAdapter.updateValue(ArrayList<String>(), true)


            } else {

                mHouseSelectAll = true
                mHouseSelectImage.setImageResource(R.drawable.ic_baseline_check_box)
                for (Data in houseListResponse.data!!) {

                    mHouseList.add("" + Data?.id.toString())
                    mHouseListName.add("" + Data?.houseNo.toString())
                }

                mHouseNameAdapter.updateValue(mHouseList, false)

            }


        }

        val b = dialogBuilder.create()
        submit.setOnClickListener {
            b.dismiss()
            updateCount()
        }



        b.show()
        //-- just to fix first time visibility issue
        Handler().postDelayed({
            try {
                mHouseNameAdapter.notifyDataSetChanged()
            }catch (ex: Exception){
                //ignore
            }
        }, 100)

    }

    private fun getHouseList() {

        (mContext as DashboardActivity).showProgress()

        viewModel.getHouseList(Utils.getAccessToken(mContext)).observe(
            viewLifecycleOwner, Observer {
                (mContext as DashboardActivity).hideProgress()

                houseListResponse = it
                house_list_data.clear()
                house_list_data.addAll(houseListResponse.data!!)


            }
        )

    }


    private fun settingStudentListRecyclerView() {
        dataBinding.rvStudentList.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        dataBinding.rvStudentList.hasFixedSize()

    }

    private fun getHouseListResponse() {


        (mContext as DashboardActivity).showProgress()

        viewModel.getHouseResponseForAPi(Utils.getAccessToken(mContext), studentList, mHouseList)
            .observe(
                viewLifecycleOwner, Observer {

                    (mContext as DashboardActivity).hideProgress()

                    if (it.data != null) {
                        dataBinding.rvStudentList.adapter =
                            StudentAttendanceMarkAdapter(
                                mContext,
                                mutableListOf(),
                                it.data!! as List<HouseListResponse.Data>,
                                2,
                                it.path!!,
                                this
                            )

                    } else {
                            showErrorToast("There is no record for the selected details", mContext)
                    }
                }
            )

    }

    override fun selectedDate(date: String) {

    }

    override fun selectClass(classId: String) {

        if (studentList.contains(classId)) {

            studentList.remove(classId)

        } else {
            studentList.add(classId)
        }

        if (classListResponse.data?.count() != studentList.count()
        ) {
            mStudentSelectAll = false

            mStudentSelectImage.setImageResource(R.drawable.ic_check_box_outline)

        } else {
            mStudentSelectAll = true
            mStudentSelectImage.setImageResource(R.drawable.ic_baseline_check_box)

        }
        mStandardAdapter.updateValue(studentList, true)
/*
        dataBinding.layoutInflator.removeAllViews()

        updateView()*/


    }

    override fun selectHouseId(houseId: String) {

        if (mHouseList.contains(houseId)) {

            mHouseList.remove(houseId)

        } else {
            mHouseList.add(houseId)
        }

        if (houseListResponse.data?.count() != mHouseList.count()
        ) {

            mHouseSelectAll = false
            mHouseSelectImage.setImageResource(R.drawable.ic_check_box_outline)

        } else {
            mHouseSelectAll = true
            mHouseSelectImage.setImageResource(R.drawable.ic_baseline_check_box)

        }
        mHouseNameAdapter.updateValue(mHouseList, true)

     /*   dataBinding.layoutInflator.removeAllViews()

        updateView()*/
    }

    private fun updateCount() {

        if(mHouseList.count() > 0)
            dataBinding.houseListSelectedCount.text = mHouseList.count().toString()
        else
            dataBinding.houseListSelectedCount.text = "Select"

        if(studentList.count() > 0)
            dataBinding.classListSelectedCount.text = studentList.count().toString()
        else
            dataBinding.classListSelectedCount.text = "Select"

    }

    override fun selectedValue(type: String, id: String) {

    }

    override fun firstSelect(type: String, id: Boolean) {
    }

    override fun secondSelect(type: String, id: Boolean) {
    }

    fun updateView() {


        val content =
            LayoutInflater.from(mContext)
                .inflate(R.layout.houselist_inflator, null)

        var text = content.findViewById<TextView>(R.id.text)

        for (data in mHouseList) {

            text.text = data

            dataBinding.layoutInflator.addView(content)

        }


        for (data in studentList) {

            text.text = data

            dataBinding.layoutInflator.addView(content)

        }


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

                            classListResponse = it;
                            for (data in it.data) {
                                list.add(data?.standard.toString() + " " + data?.section.toString())

                            }
                            classListData.addAll(it.data)

                        }
                    }

                    (mContext as DashboardActivity).hideProgress()

                }
        )


    }


}
