package com.mountcarmelschools.ui.profile.staff.editProfile

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.ColorStateList
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.MotionEvent
import android.view.View
import android.widget.AdapterView.OnItemClickListener
import android.widget.ArrayAdapter
import android.widget.EditText
import android.widget.TextView
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.EditProfileFragmentBinding
import com.mountcarmelschools.di.data.staffProfile.*
import com.mountcarmelschools.ui.commonAdapter.CommonInterface
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils
import java.text.SimpleDateFormat
import java.util.*


class EditStaffProfileFragment :
    BaseFragment<EditProfileFragmentBinding, EditStaffProfileViewModel>(), CommonInterface {


    private var mSelectedDate: String = ""
    lateinit var mContext: Context
    var mSelectedCity = ""
    private var mSelectedDepartment = StaffProfileDetail.Data.DepartmentId("", "")
    private var mSelectedStaffRoom = StaffProfileDetail.Data.StaffroomId("", "")
    private var mCity: String = ""
    private var listOFNewAddedStudent = ArrayList<GetStudentDetailFromAdmissioNO.Data?>()

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Edit Profile")

    }

    override fun getLayoutID(): Int {

        return R.layout.edit_profile_fragment
    }

    override fun getViewModel(): Class<EditStaffProfileViewModel> {

        return EditStaffProfileViewModel::class.java

    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        dataBinding.edtDateOfBirth.setText(
            Utils.formattedDateFromString(
                "", "dd-MM-yyyy", (mContext as DashboardActivity).staffDetail.data?.dateOfBirth
            )
        );

        dataBinding.edtDateOfJoining.setText(
            Utils.formattedDateFromString(
                "", "dd-MM-yyyy", (mContext as DashboardActivity).staffDetail.data?.dateOfJoining
            )
        );


        dataBinding.edtAnniversary.setText(
            Utils.formattedDateFromString(
                "",
                "dd-MM-yyyy",
                (mContext as DashboardActivity).staffDetail.data?.dateOfAnniversary
            )
        )

        dataBinding.edtSpouseName.setText((mContext as DashboardActivity).staffDetail.data?.spouseName)
        dataBinding.edtMobileNumber.setText((mContext as DashboardActivity).staffDetail.data?.mobile)
        dataBinding.edtSosContact.setText((mContext as DashboardActivity).staffDetail.data?.emergencyName)
        dataBinding.edtSosMobileNo.setText((mContext as DashboardActivity).staffDetail.data?.emergencyMobile)
        dataBinding.edtLocalAddress.setText(
            (mContext as DashboardActivity).staffDetail.data?.address!!.localAddress
        )

        dataBinding.edtPin.setText(
            (mContext as DashboardActivity).staffDetail.data?.address!!.pincode
        )

        dataBinding.edtQualification.setText(
            (mContext as DashboardActivity).staffDetail.data?.qualification
        )
        mSelectedCity = (mContext as DashboardActivity).staffDetail.data?.address!!.city!!


        if ((mContext as DashboardActivity).staffDetail.data?.departmentId != null) {
            mSelectedDepartment = (mContext as DashboardActivity).staffDetail.data?.departmentId!!

        }


        if ((mContext as DashboardActivity).staffDetail.data?.staffroomId != null) {
            mSelectedStaffRoom = (mContext as DashboardActivity).staffDetail.data?.staffroomId!!
        }

        val arr = arrayOf("YES", "NO");

        var mHaveStudentValue = ""

        if ((mContext as DashboardActivity).staffDetail.data?.students != null && (mContext as DashboardActivity).staffDetail.data?.students!!.isNotEmpty()) {

            mHaveStudentValue = "YES"
            dataBinding.childContainer.visibility = View.VISIBLE
            dataBinding.admissioNoConatiner.visibility = View.VISIBLE
            showChildLayout()
        } else {
            mHaveStudentValue = "NO"
            dataBinding.childContainer.visibility = View.GONE
            dataBinding.admissioNoConatiner.visibility = View.GONE

        }

        val adapter: ArrayAdapter<String> = ArrayAdapter<String>(
            requireContext(), R.layout.dropdown_menu_popup_item, arr
        )
        dataBinding.childInMcs.setAdapter(adapter)

        dataBinding.childInMcs.setText(mHaveStudentValue, false);

        dataBinding.childInMcs.onItemClickListener = OnItemClickListener { parent, arg1, pos, id ->

            if (arr[pos] == "YES") {
                dataBinding.childContainer.visibility = View.VISIBLE
                dataBinding.admissioNoConatiner.visibility = View.VISIBLE
            } else {
                dataBinding.childContainer.visibility = View.GONE
                dataBinding.admissioNoConatiner.visibility = View.GONE
            }
        }


        dataBinding.edtDateOfBirth.setOnClickListener {
            mSelectedDate = "Dob"
            val startDateCal = Calendar.getInstance()

            val date = SimpleDateFormat("dd-MM-yyyy").parse(
                (mContext as DashboardActivity).mSessionStartDate
            )
            startDateCal.time = date!!


            Utils.showCalendarDialog(mContext, this)


        }

        dataBinding.edtAnniversaryLayout.setEndIconOnClickListener {

            mSelectedDate = "Anniversary"
            val startDateCal = Calendar.getInstance()

            val date = SimpleDateFormat("dd-MM-yyyy").parse(
                (mContext as DashboardActivity).mSessionStartDate
            )
            startDateCal.time = date!!


            Utils.showCalendarDialog(mContext, this)
        }


        dataBinding.close.setOnClickListener {

            (mContext as DashboardActivity).supportFragmentManager.popBackStack()

        }

        dataBinding.save.setOnClickListener {

            updateEditProfileData()

        }

        getAllCities()
        getAllDepartment()
        getAllStaff()


        dataBinding.addAdmissionNO.setOnClickListener {
            if (dataBinding.edtAdmissionNo.text.toString() == "") {
                showErrorToast("Please enter admission no.", mContext);

            } else if (childAlreadyAdded(dataBinding.edtAdmissionNo.text.toString())) {

                showErrorToast("Child Already Exist", mContext);

            } else if (childAlreadyAddedInNewList(
                    dataBinding.edtAdmissionNo.text.toString(), listOFNewAddedStudent
                )
            ) {

                showErrorToast("Child Already Exist", mContext);

            } else {

                checkAdmissionNO(dataBinding.edtAdmissionNo.text.toString())

            }
        }



        dataBinding.edtMobileNumber.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(s: Editable) {
                if (s.isEmpty() || s.length < 10) {
                    dataBinding.mobileNoLayout.error = " "
                    updateButton(true)
                } else {
                    dataBinding.mobileNoLayout.error = null
                    updateButton(false)
                }

            }

            override fun beforeTextChanged(
                s: CharSequence, start: Int, count: Int, after: Int
            ) {
            }

            override fun onTextChanged(
                s: CharSequence, start: Int, before: Int, count: Int
            ) {

            }
        })


        dataBinding.edtLocalAddress.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(s: Editable) {
                if (s.isEmpty()) {
                    dataBinding.localAddressLayout.error = " "
                    updateButton(true)
                } else {
                    dataBinding.localAddressLayout.error = null
                    updateButton(false)
                }

            }

            override fun beforeTextChanged(
                s: CharSequence, start: Int, count: Int, after: Int
            ) {
            }

            override fun onTextChanged(
                s: CharSequence, start: Int, before: Int, count: Int
            ) {

            }
        })

       dataBinding.edtPin.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(s: Editable) {
                if (s.isEmpty()) {
                    dataBinding.pinCodeLayout.error = " "
                    updateButton(true)
                } else {
                    dataBinding.pinCodeLayout.error = null
                    updateButton(false)
                }

            }

            override fun beforeTextChanged(
                s: CharSequence, start: Int, count: Int, after: Int
            ) {
            }

            override fun onTextChanged(
                s: CharSequence, start: Int, before: Int, count: Int
            ) {

            }
        })

        dataBinding.edtSosContact.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(s: Editable) {
                if (s.isEmpty()) {
                    dataBinding.sosNameLayout.error = " "
                    updateButton(true)
                } else {
                    dataBinding.sosNameLayout.error = null
                    updateButton(false)
                }

            }

            override fun beforeTextChanged(
                s: CharSequence, start: Int, count: Int, after: Int
            ) {
            }

            override fun onTextChanged(
                s: CharSequence, start: Int, before: Int, count: Int
            ) {

            }
        })

        dataBinding.edtSosMobileNo.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(s: Editable) {
                if (s.isEmpty() || s.length < 10) {
                    dataBinding. sosMobileLayout.error = " "
                    updateButton(true)
                } else {
                    dataBinding.sosMobileLayout.error = null
                    updateButton(false)
                }

            }

            override fun beforeTextChanged(
                s: CharSequence, start: Int, count: Int, after: Int
            ) {
            }

            override fun onTextChanged(
                s: CharSequence, start: Int, before: Int, count: Int
            ) {

            }
        })

        dataBinding.edtQualification.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(s: Editable) {
                if (s.isEmpty()) {
                    dataBinding.qualificationLayout.error = " "
                    updateButton(true)
                } else {
                    dataBinding.qualificationLayout.error = null
                    updateButton(false)
                }

            }

            override fun beforeTextChanged(
                s: CharSequence, start: Int, count: Int, after: Int
            ) {
            }

            override fun onTextChanged(
                s: CharSequence, start: Int, before: Int, count: Int
            ) {

            }
        })


    }

    private fun updateButton(b: Boolean) {
        if (b) {

            dataBinding.save.isClickable = false
            dataBinding.save.backgroundTintList = ColorStateList.valueOf(resources.getColor(R.color.dark_gray));

        } else {
            dataBinding.save.isClickable = true
            dataBinding.save.backgroundTintList =
                ColorStateList.valueOf(resources.getColor(R.color.blue_container));

        }

    }

    private fun updateEditProfileData() {
        (mContext as DashboardActivity).showProgress()


        val haveStudent = if (dataBinding.childContainer.visibility == View.GONE) {

            false

        } else {
            (mContext as DashboardActivity).staffDetail.data?.students!!.isNotEmpty() || listOFNewAddedStudent.isNotEmpty()
        }


        val mStudentList: MutableList<UpdateProfilePostData.Student> = ArrayList()


        if (dataBinding.childContainer.visibility == View.VISIBLE) {

            for (data in (mContext as DashboardActivity).staffDetail.data?.students!!) {
                mStudentList.add(
                    UpdateProfilePostData.Student(
                        data!!.admissionNo, data.standardId!!.id
                    )
                )
            }

            for (data in listOFNewAddedStudent) {
                mStudentList.add(
                    UpdateProfilePostData.Student(
                        data!!.admissionNo, data.id
                    )
                )
            }


            if (listOFNewAddedStudent.isNotEmpty() && listOFNewAddedStudent[0]!!.siblings != null) {
                for (data in listOFNewAddedStudent[0]!!.siblings!!) {
                    mStudentList.add(
                        UpdateProfilePostData.Student(
                            data!!.siblingId!!.admissionNo,
                            data.siblingId!!.id,
                        )
                    )
                }
            }

        }


        val data = UpdateProfilePostData(
            UpdateProfilePostData.Address(
                dataBinding.city.text.toString(),
                dataBinding.edtLocalAddress.text.toString(),
                dataBinding.edtPin.text.toString()
            ),
            "",
            dataBinding.city.text.toString(),
            dataBinding.edtAnniversary.text.toString(),
            dataBinding.edtDateOfBirth.text.toString(),
            dataBinding.edtDateOfJoining.text.toString(),
            UpdateProfilePostData.DepartmentId(mSelectedDepartment.id, mSelectedDepartment.name),
            dataBinding.edtSosMobileNo.text.toString(),
            dataBinding.edtSosContact.text.toString(),
            haveStudent,
            dataBinding.edtLocalAddress.text.toString(),
            dataBinding.edtMobileNumber.text.toString(),
            dataBinding.edtPin.text.toString(),
            dataBinding.edtQualification.text.toString(),
            dataBinding.edtSpouseName.text.toString(),
            UpdateProfilePostData.StaffroomId(mSelectedStaffRoom.id, mSelectedStaffRoom.roomNo),
            mStudentList,
            haveStudent
        )


        Log.e("test", "----------------- ${data.toString()}")

        viewModel.updateProfile(
            Utils.getAccessToken(mContext), Utils.getUserId(mContext), data

        ).observe(viewLifecycleOwner, androidx.lifecycle.Observer {
            (mContext as DashboardActivity).hideProgress()

            if (it.status!!) {

                (mContext as DashboardActivity).supportFragmentManager.popBackStack()
                (mContext as DashboardActivity).getStaffDetail();

            } else {
                showErrorToast(it.message!!, mContext)

            }

        })

    }

    private fun childAlreadyAddedInNewList(
        admissionNo: String, listOFNewAddedStudent: ArrayList<GetStudentDetailFromAdmissioNO.Data?>
    ): Boolean {


        for (data in listOFNewAddedStudent) {
            if (data!!.admissionNo.toString() == admissionNo) {
                return true
            }
        }
        return false
    }

    private fun childAlreadyAdded(admissionNo: String): Boolean {


        for (data in (mContext as DashboardActivity).staffDetail.data?.students!!) {

            if (data!!.admissionNo.toString() == admissionNo) {
                return true
            }
        }
        return false
    }

    private fun showChildLayout() {

        for ((index, data) in (mContext as DashboardActivity).staffDetail.data?.students!!.withIndex()) {

            val view = layoutInflater.inflate(R.layout.dropdown_menu_popup_item, null)

            val textView = view.findViewById<TextView>(R.id.text1);

            textView.text = "${data!!.standardId!!.name} (${data.admissionNo})"

            dataBinding.childContainer.addView(view)

        }


    }


    private fun getAllCities() {

        (mContext as DashboardActivity).showProgress()
        viewModel.getAllCity(
            Utils.getAccessToken(mContext)
        ).observe(viewLifecycleOwner, androidx.lifecycle.Observer {
            (mContext as DashboardActivity).hideProgress()

            if (it.status!!) {

                if (it.data != null) {

                    updateAdapter(it.data)
                }
            } else {
                showErrorToast(it.message!!, mContext)

            }

        })
    }

    private fun getAllDepartment() {


        (mContext as DashboardActivity).showProgress()
        viewModel.getAllDepartment(
            Utils.getAccessToken(mContext)
        ).observe(viewLifecycleOwner, androidx.lifecycle.Observer {
            (mContext as DashboardActivity).hideProgress()

            if (it.status!!) {

                if (it.data != null) {

                    updateDepartmentAdapter(it.data)
                }
            } else {
                showErrorToast(it.message!!, mContext)

            }

        })
    }

    private fun getAllStaff() {

        (mContext as DashboardActivity).showProgress()
        viewModel.getAllStaff(
            Utils.getAccessToken(mContext)
        ).observe(viewLifecycleOwner, androidx.lifecycle.Observer {
            (mContext as DashboardActivity).hideProgress()

            if (it.status!!) {

                if (it.data != null) {

                    updateStaffAdapter(it.data)
                }
            } else {
                showErrorToast(it.message!!, mContext)

            }

        })
    }

    private fun updateDepartmentAdapter(data: List<GetAllDepartmentResponse.Data?>) {
        val departments: ArrayList<String> = ArrayList()

        var department = ""


        for (depart in data) {
            if (depart!!.id.toString() == mSelectedDepartment.id) {
                department = depart.name!!

            }

            departments.add(depart!!.name!!)

        }
        val departArray = arrayOfNulls<String>(departments.size)

        departments.toArray(departArray)

        val adapter: ArrayAdapter<String> = ArrayAdapter<String>(
            requireContext(), R.layout.dropdown_menu_popup_item, departments
        )
        dataBinding.edtDepartment.setAdapter(adapter)

        dataBinding.edtDepartment.setText(department, false);


        dataBinding.edtDepartment.onItemClickListener =
            OnItemClickListener { parent, arg1, pos, id ->

                mSelectedDepartment =
                    StaffProfileDetail.Data.DepartmentId(data[pos]!!.id, data[pos]!!.name)

            }

    }

    private fun updateStaffAdapter(data: List<GetStaffRoomList.Data?>?) {
        val staffList: ArrayList<String> = ArrayList()


        var staffRoom = ""


        for (staff in data!!) {

            if (staff!!.id.toString() == mSelectedStaffRoom.id) {
                staffRoom = staff.roomNo!!

            }

            staffList.add(staff!!.roomNo!!)

        }
        val staffArray = arrayOfNulls<String>(staffList.size)

        staffList.toArray(staffArray)

        val adapter: ArrayAdapter<String> = ArrayAdapter<String>(
            requireContext(), R.layout.dropdown_menu_popup_item, staffList
        )
        dataBinding.edtStaffRoom.setAdapter(adapter)

        dataBinding.edtStaffRoom.setText(staffRoom, false);

        dataBinding.edtStaffRoom.onItemClickListener =
            OnItemClickListener { parent, arg1, pos, id ->

                mSelectedStaffRoom =
                    StaffProfileDetail.Data.StaffroomId(data[pos]!!.id, data[pos]!!.roomNo)

            }
    }

    private fun updateAdapter(data: List<GetAllCityResponse.Data?>) {
        val cities: ArrayList<String> = ArrayList()


        for (city in data) {

            cities.add(city!!.name!!)

        }

        val cityArray = arrayOfNulls<String>(cities.size)
        cities.toArray(cityArray)

        val adapter: ArrayAdapter<String> = ArrayAdapter<String>(
            requireContext(), R.layout.dropdown_menu_popup_item, cityArray
        )

        dataBinding.city.setAdapter(adapter)
        dataBinding.city.setText(mSelectedCity, false);


    }


    private fun checkAdmissionNO(admissionNo: String) {

        (mContext as DashboardActivity).showProgress()

        viewModel.checkAdmissionNo(
            Utils.getAccessToken(mContext), admissionNo
        ).observe(viewLifecycleOwner, androidx.lifecycle.Observer {
            (mContext as DashboardActivity).hideProgress()

            if (it.status!!) {

                dataBinding.edtAdmissionNo.setText("")
                showErrorToast(it.message!!, mContext)

                listOFNewAddedStudent.add(it.data)

                addNewChildLayout(it.data)

            } else {
                showErrorToast(it.message!!, mContext)

            }

        })
    }

    private fun addNewChildLayout(data: GetStudentDetailFromAdmissioNO.Data?) {
        for ((index, data) in listOFNewAddedStudent.withIndex()) {

            val view = layoutInflater.inflate(R.layout.dropdown_menu_popup_item, null)

            val textView = view.findViewById<TextView>(R.id.text1);

            textView.text = "${data!!.name} (${data.admissionNo})"

            dataBinding.childContainer.addView(view)

        }

        if (listOFNewAddedStudent[0]!!.siblings != null) {
            for (data in listOFNewAddedStudent[0]!!.siblings!!) {

                val view = layoutInflater.inflate(R.layout.dropdown_menu_popup_item, null)

                val textView = view.findViewById<TextView>(R.id.text1);

                textView.text = "${data!!.siblingId!!.name} (${data.admissionNo})"

                dataBinding.childContainer.addView(view)

            }
        }


    }

    override fun selectedDate(date: String) {

        if (mSelectedDate == "Dob") {
            dataBinding.edtDateOfBirth.setText(date)
        } else if (mSelectedDate == "Anniversary") {
            dataBinding.edtAnniversary.setText(date)
            dataBinding.edtAnniversary.setSelection(dataBinding.edtAnniversary.text!!.length)

        }
    }

    override fun selectClass(classId: String) {
    }

    override fun selectHouseId(houseId: String) {
    }

    @SuppressLint("ClickableViewAccessibility")
    fun EditText.setDrawableRightTouch(setClickListener: () -> Unit) {
        this.setOnTouchListener(View.OnTouchListener { _, event ->
            val DRAWABLE_LEFT = 0
            val DRAWABLE_TOP = 1
            val DRAWABLE_RIGHT = 2
            val DRAWABLE_BOTTOM = 3
            if (event.action == MotionEvent.ACTION_UP) {
                if (event.rawX >= this.right - this.compoundDrawables[DRAWABLE_RIGHT].bounds.width()) {
                    setClickListener()
                    return@OnTouchListener true
                }
            }
            false
        })
    }


}