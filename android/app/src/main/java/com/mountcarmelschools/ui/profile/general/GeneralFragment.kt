package com.mountcarmelschools.ui.profile.general

import android.app.AlertDialog
import android.content.Context
import android.os.Bundle
import android.service.autofill.UserData
import android.view.View
import android.view.WindowManager
import android.widget.*
import androidx.lifecycle.Observer
import com.google.android.gms.common.util.ArrayUtils
import com.google.android.material.textfield.TextInputEditText
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentGeneralBinding
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.motherTongue.MotherTongueResponse
import com.mountcarmelschools.di.data.studentDetail.SingleStudentDetail
import com.mountcarmelschools.di.data.studentprofile.*
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils
import org.json.JSONException
import org.json.JSONObject


class GeneralFragment : BaseFragment<FragmentGeneralBinding, GeneralFragmentViewModel>() {

    lateinit var mContext: Context
    var motherTongueList = ArrayList<String>();
    var motherTongueIDList = ArrayList<String>();
    var mMotherTongueId = "";
    var mMotherSelected = 0;

    var aadhaarNumber = ""

    var mCountryId = ""


    var mAllStateList = ArrayList<GetAllStateResponse.Data>();

    var mAllCityList = ArrayList<GetAllCitiesResponse.Data>();

    var mSelectedCity = "";
    var mSelectedStateId = "";
    var mPin = "";
    var mLocalAddress = "";
    lateinit var studentDetailData: SingleStudentDetail.Data

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }


    override fun getLayoutID(): Int {
        return R.layout.fragment_general
    }

    override fun getViewModel(): Class<GeneralFragmentViewModel> {
        return GeneralFragmentViewModel::class.java

    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("General Details")

    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        if (Utils.isParent(mContext)) {
            dataBinding.residentAddressEditIcon.visibility = View.VISIBLE
            dataBinding.generalInformationEditIcon.visibility = View.VISIBLE
        }


        studentDetailData = (mContext as DashboardActivity).studentDetail.data!!

        dataBinding.admissionNo.text = studentDetailData!!.admissionNo

        var admissionDate = Utils.formattedDateFromString(
            "", "dd-MM-yyyy", studentDetailData.dateOfAdmission
        )
        dataBinding.admissionDate.text = admissionDate

        if (studentDetailData.houseId != null) {
            dataBinding.house.text = "House : " + studentDetailData.houseId!!.houseNo
        } else {
            dataBinding.house.text = "House : "
        }


        var subjects = "";

        if (studentDetailData.comboId?.subjects != null) {

            for (sub in studentDetailData.comboId?.subjects!!) {
                if (subjects.equals("")) {
                    subjects = sub!!.subjectName.toString()
                } else {
                    subjects = subjects + " , " + sub!!.subjectName.toString()
                }

            }
        }
        dataBinding.subjects.text = "Subjects : " + subjects;

        if (studentDetailData.achievement?.scholastic?.name == "null" || studentDetailData.achievement?.scholastic?.name == null) {
            dataBinding.scholastic.text =
                "Scholastic/Co-Scholastic Achievement : -";
        } else {
            dataBinding.scholastic.text =
                "Scholastic/Co-Scholastic Achievement : " + studentDetailData.achievement?.scholastic?.name
        }
        dataBinding.name.text = studentDetailData.name
        dataBinding.gender.text = studentDetailData.gender

        val dob = Utils.formattedDateFromString(
            "", "dd-MM-yyyy", studentDetailData.dateOfBirth
        )
        dataBinding.dob.text = "Date of Birth : $dob"

        dataBinding.nationality.text = "Nationality : " + studentDetailData.nationality

        dataBinding.aadhar.text = "Aadhar Number : " + studentDetailData.aadharCard

        aadhaarNumber = studentDetailData.aadharCard.toString()
        dataBinding.email.text = "Email : " + studentDetailData.email

        dataBinding.mobileNo.text =
            "Mobile No. (For SMS Notification) : " + studentDetailData.smsMobile

        mMotherTongueId = studentDetailData.motherTongueId!!.id.toString()



        if (studentDetailData.address != null && studentDetailData.address!!.isNotEmpty()) {
            mCountryId =
                studentDetailData.address!!.get(studentDetailData.address!!.size - 1)!!.countryId.toString()

            dataBinding.address.text =
                "Address : " + studentDetailData.address!!.get(studentDetailData.address!!.size - 1)!!.localAddress
            dataBinding.city.text =
                studentDetailData.address!!.get(studentDetailData.address!!.size - 1)!!.city
            dataBinding.state.text =
                "State : " + studentDetailData.address!!.get(studentDetailData.address!!.size - 1)!!.stateId!!.stateName

            dataBinding.country.text = "Country : " + (studentDetailData.address!!.get(studentDetailData.address!!.size-1)?.countryId?.countryName)

            mCountryId =
                studentDetailData.address!!.get(studentDetailData.address!!.size - 1)!!.countryId?.id.toString()

            dataBinding.pinCode.text =
                "Pin Code : " + studentDetailData.address!!.get(studentDetailData.address!!.size - 1)!!.pincode


            mSelectedCity =
                studentDetailData.address!![studentDetailData.address!!.size - 1]!!.city!!
            //  mSelectedStateId = studentDetailData.address!![studentDetailData.address!!.size - 1]!!.stateId!!.id.toString()
            mSelectedStateId =
                studentDetailData.address!!.get(studentDetailData.address!!.size - 1)!!.stateId!!.stateName.toString()


            mLocalAddress =
                studentDetailData.address!![studentDetailData.address!!.size - 1]!!.localAddress.toString()


            mPin =
                studentDetailData.address!![studentDetailData.address!!.size - 1]!!.pincode as String
        }


        dataBinding.generalInformationEditIcon.setOnClickListener {

            openGeneralInfoDialog()

        }
        dataBinding.residentAddressEditIcon.setOnClickListener {

            openResidentaialAddressDialog()

        }

        initObserver()
    }

    private fun initObserver() {

        viewModel.liveDataNetworkError.observe(viewLifecycleOwner, observerError)
        viewModel.liveDataGetMotherTongue.observe(viewLifecycleOwner, observerMotherTongueResponse)
        viewModel.liveDataUpdateProfile.observe(viewLifecycleOwner, observerUpdateProfileResponse)
        viewModel.liveDataGetAllCities.observe(viewLifecycleOwner, observerGetAllCitiesResponse)
        viewModel.liveDataGetAllState.observe(viewLifecycleOwner, observerGetAllStateResponse)
        viewModel.liveDataUpdateResidentialProfile.observe(
            viewLifecycleOwner, observerResidentialProfile
        )

        getAllMaterData()
    }

    private fun getAllMaterData() {
        (mContext as DashboardActivity).showProgress()
        viewModel.callMotherTongueResponse(
            requireContext(), Utils.getAccessToken(mContext)
        )

        (mContext as DashboardActivity).showProgress()
        viewModel.callAllCitiesResponse(
            requireContext(), Utils.getAccessToken(mContext)
        )

        (mContext as DashboardActivity).showProgress()
        viewModel.callAllStateResponse(
            requireContext(), Utils.getAccessToken(mContext)
        )
    }

    private val observerMotherTongueResponse =
        Observer<ResponseStatus<MotherTongueResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {

                    updateMotherTongueDropDown(responseStatus.response.data)
                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }

    private val observerUpdateProfileResponse =
        Observer<ResponseStatus<CommonResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {
                    (mContext as DashboardActivity).supportFragmentManager.popBackStack();

                    (mContext as DashboardActivity).getStudentDetail();


                    showSuccessToast(responseStatus.response.message.toString(), requireContext())
                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }


    ///----------------City----------------------
    private val observerGetAllCitiesResponse =
        Observer<ResponseStatus<GetAllCitiesResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {

                    mAllCityList.addAll(responseStatus.response.data)
                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }


    ///----------------STATE-----------------------
    private val observerGetAllStateResponse =
        Observer<ResponseStatus<GetAllStateResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {
                    mAllStateList.addAll(responseStatus.response.data)
                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }


    private val observerResidentialProfile =
        Observer<ResponseStatus<CommonResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {
                    (mContext as DashboardActivity).supportFragmentManager.popBackStack();

                    (mContext as DashboardActivity).getStudentDetail();

                    showSuccessToast(responseStatus.response.message.toString(), requireContext())
                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }

    private fun updateMotherTongueDropDown(data: List<MotherTongueResponse.Data?>?) {

        for ((index, value1) in data!!.withIndex()) {
            motherTongueList.add(value1!!.name.toString())
            motherTongueIDList.add(value1.id.toString())

            if (value1.id.toString() == mMotherTongueId) {
                mMotherSelected = index;
            }
        }

    }


    private fun openGeneralInfoDialog() {
        val dialogBuilder = AlertDialog.Builder(mContext)
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.edit_general_information_dialog, null)
        dialogBuilder.setView(dialogView)


        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()

        dialog.window!!.clearFlags(
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM
        )

        val motherTongue = dialogView.findViewById(R.id.mother_tongue) as AutoCompleteTextView
        val edtAdarCard = dialogView.findViewById(R.id.edt_adarCard) as TextInputEditText
        val submit = dialogView.findViewById(R.id.submit) as TextView
        val close = dialogView.findViewById(R.id.close) as TextView


        edtAdarCard.setText(aadhaarNumber.toString());
        val adapter: ArrayAdapter<String> = ArrayAdapter(
            mContext, android.R.layout.simple_list_item_1, android.R.id.text1, motherTongueList
        )

        motherTongue.setAdapter(adapter)
        motherTongue.setText(
            motherTongue.adapter.getItem(mMotherSelected).toString(), false
        )


        motherTongue.onItemClickListener =
            AdapterView.OnItemClickListener { parent, view, position, id ->

                mMotherTongueId = motherTongueIDList[position]

            }


        close.setOnClickListener {
            dialog.dismiss()
            dialog.cancel()
        }

        submit.setOnClickListener {

            if (edtAdarCard.text.toString().isEmpty()) {
                showErrorToast("Please enter Aadhaar No.", mContext)
            } else if (edtAdarCard.text!!.length != 12) {
                showErrorToast("Please enter valid Aadhaar No.", mContext)
            } else {
                dialog.dismiss();
                dialog.cancel();
                val data = GeneralPostData(
                    edtAdarCard.text.toString(), mMotherTongueId
                )
                viewModel.updateProfile(
                    requireContext(),
                    Utils.getAccessToken(mContext),
                    Utils.getStudentID(mContext),
                    data
                )
            }
        }
    }

    private fun openResidentaialAddressDialog() {
        val dialogBuilder = AlertDialog.Builder(mContext)
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.edti_residental_address_dialog, null)
        dialogBuilder.setView(dialogView)


        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()

        dialog.window!!.clearFlags(
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM
        )

        val submit = dialogView.findViewById(R.id.submit) as TextView
        val close = dialogView.findViewById(R.id.close) as TextView
        val city = dialogView.findViewById(R.id.city) as AutoCompleteTextView
        val state = dialogView.findViewById(R.id.state) as AutoCompleteTextView
        val edtPin = dialogView.findViewById(R.id.edt_pin) as TextInputEditText
        val edtLocalAddress = dialogView.findViewById(R.id.edt_localAddress) as TextInputEditText

        edtPin.setText(mPin)
        edtLocalAddress.setText(mLocalAddress)

        val cityList = ArrayList<String>()

        var mPosition = 0
        for ((index, data) in mAllCityList.withIndex()) {
            if (data.name!!.isNotEmpty()) {
                cityList.add(data.name)

                if (data.name == mSelectedCity) {
                    mPosition = index;
                }
            }
        }

        val cityAdapter: ArrayAdapter<String> = ArrayAdapter(
            mContext, android.R.layout.simple_list_item_1, android.R.id.text1, cityList
        )
        city.setAdapter(cityAdapter)
        city.setText(
            city.adapter.getItem(mPosition).toString(), false
        )

        city.onItemClickListener =
            AdapterView.OnItemClickListener { parent, view, position, id ->

                mSelectedCity = cityList[position]

            }

        var mStatePosition = 0
        val stateList = ArrayList<String>()
        val stateListId = ArrayList<String>()
        for ((index, data) in mAllStateList.withIndex()) {
            if (data.stateName!!.isNotEmpty()) {
                stateList.add(data.stateName)
                stateListId.add(data.id!!)
                if (data.stateName == mSelectedStateId) {
                    mStatePosition = index;
                }
            }

        }

        val stateAdapter: ArrayAdapter<String> = ArrayAdapter(
            mContext, android.R.layout.simple_list_item_1, android.R.id.text1, stateList
        )
        state.setAdapter(stateAdapter)


        state.setText(
            stateList.get(ArrayList<String>(stateList).indexOf(mSelectedStateId))
        )

        state.onItemClickListener =
            AdapterView.OnItemClickListener { parent, view, position, id ->
                mSelectedStateId = stateListId[position]

            }

        close.setOnClickListener {
            dialog.dismiss()
            dialog.cancel()
        }

        submit.setOnClickListener {

            if (edtLocalAddress.text.toString().isEmpty()) {
                showErrorToast("Please enter address.", mContext)
            } else if (edtPin.text!!.toString().isEmpty()) {
                showErrorToast("Please enter pin code.", mContext)
            } else if (edtPin.text!!.length != 6) {
                showErrorToast("Please enter valid pin code.", mContext)
            } else {
                dialog.dismiss();
                dialog.cancel();

                val list = ArrayList<ResidentialPostDataUpdated.Addres>();
                var listData: ResidentialPostDataUpdated.Addres
                for (data in studentDetailData.address!!) {
                    listData = ResidentialPostDataUpdated.Addres(
                        city = data?.city, localAddress = data?.localAddress.toString(),
                        pincode = data?.pincode.toString(), stateId = data?.stateId?.id,
                        country_id = data?.countryId?.id,
                    )
                    list.add(listData)
                }
                list.add(
                    ResidentialPostDataUpdated.Addres(
                        city = mSelectedCity, localAddress = edtLocalAddress.text.toString(),
                        pincode = edtPin.text.toString(), stateId = mSelectedStateId,
                        country_id = mCountryId,
                        is_parent = true,
                        parent = Utils.getUserName(mContext)
                    )
                )
                val data = ResidentialPostDataUpdated(
                    list
                )
                viewModel.updateResidentailProfile(
                    requireContext(),
                    Utils.getAccessToken(mContext),
                    Utils.getStudentID(mContext),
                    data
                )
            }

        }
    }

}