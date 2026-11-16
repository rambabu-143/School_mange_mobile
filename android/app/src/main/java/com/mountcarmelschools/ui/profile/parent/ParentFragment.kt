package com.mountcarmelschools.ui.profile.parent

import android.app.AlertDialog
import android.content.Context
import android.os.Bundle
import android.util.ArrayMap
import android.util.Log
import android.view.View
import android.view.View.GONE
import android.view.View.VISIBLE
import android.view.WindowManager
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.AutoCompleteTextView
import android.widget.TextView
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import com.google.android.material.textview.MaterialTextView
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentParentsBinding
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.studentDetail.SingleStudentDetail
import com.mountcarmelschools.di.data.studentprofile.*
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.di.networking.ResponseStatusError
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.RequestBody
import okhttp3.RequestBody.Companion.create
import org.json.JSONObject
import java.util.*
import java.util.regex.Matcher
import java.util.regex.Pattern
import kotlin.Comparator
import kotlin.collections.ArrayList


class ParentFragment : BaseFragment<FragmentParentsBinding, ParentFragmentViewModel>(),
    ParentInterface {
    lateinit var mContext: Context

    lateinit var studentDetailData: SingleStudentDetail.Data

    var mQualificationResponse = ArrayList<QualificationResponse.Data>();

    var mOccupationCategory = ArrayList<GetAllOccupationResponse.Data>();

    var mOccupationSubCategory = ArrayList<GetAllSubCategoryResponse.Data>();


    private lateinit var mAdapter: ParentAdapter


    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }


    override fun getLayoutID(): Int {
        return R.layout.fragment_parents
    }

    override fun getViewModel(): Class<ParentFragmentViewModel> {
        return ParentFragmentViewModel::class.java

    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Parent Details")

    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        studentDetailData = (mContext as DashboardActivity).studentDetail.data!!

        studentDetailData.relation?.let {
            Collections.sort(
                it
            ) { lhs, rhs -> lhs!!.relation!!.compareTo(rhs!!.relation!!) }
        }

        mAdapter = ParentAdapter(
            mContext, studentDetailData.relation!!, this, ArrayList(), Utils.isParent(mContext)
        )

        dataBinding.recyclerView.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)

        dataBinding.recyclerView.adapter = mAdapter

        initObserver()
    }

    private fun initObserver() {

        viewModel.liveDataNetworkError.observe(viewLifecycleOwner, observerError)
        viewModel.liveDataGetQualification.observe(viewLifecycleOwner, observerGetQualification)
        viewModel.liveDataGetOccupationCategory.observe(
            viewLifecycleOwner, observerOccupationCategory
        )
        viewModel.liveDataGetOccupationSubCategory.observe(
            viewLifecycleOwner, observerGetOccupationSubCategory
        )
        viewModel.liveUpdateProfile.observe(
            viewLifecycleOwner, observerUpdateProfileResponse
        )

        getAllMaterData()
    }

    private val observerGetQualification =
        Observer<ResponseStatus<QualificationResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {
                    mQualificationResponse.addAll(responseStatus.response.data)

                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }

    private val observerOccupationCategory =
        Observer<ResponseStatus<GetAllOccupationResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {
                    mOccupationCategory.addAll(responseStatus.response.data)


                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }

    private val observerGetOccupationSubCategory =
        Observer<ResponseStatus<GetAllSubCategoryResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {
                    mOccupationSubCategory.addAll(responseStatus.response.data)

                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }

    private fun getAllMaterData() {

        (mContext as DashboardActivity).showProgress()

        viewModel.callAllQualificationResponse(
            mContext, Utils.getAccessToken(mContext)
        )
        viewModel.callAllOccupationCategoryResponse(
            mContext, Utils.getAccessToken(mContext)
        )

        viewModel.callAllOccupationSubCategoryResponse(
            mContext, Utils.getAccessToken(mContext)
        )


    }


    private fun showCommonEditDialog(
        type: String, realationShip: SingleStudentDetail.Data.Relation
    ) {
        val dialogBuilder = AlertDialog.Builder(mContext)
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.edit_edit_father_dialog, null)
        dialogBuilder.setView(dialogView)

        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()

        dialog.window!!.clearFlags(
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM
        )

        val edt_name = dialogView.findViewById(R.id.edt_name) as TextInputEditText


        val qualification = dialogView.findViewById(R.id.qualification) as AutoCompleteTextView
        val occupation = dialogView.findViewById(R.id.occupation) as AutoCompleteTextView

        val occupationSubCategory =
            dialogView.findViewById(R.id.subcategory) as AutoCompleteTextView

        val header = dialogView.findViewById(R.id.header) as MaterialTextView
        val organisation = dialogView.findViewById(R.id.edt_organisation) as TextInputEditText
        val designation = dialogView.findViewById(R.id.edt_designation) as TextInputEditText
        val office_address = dialogView.findViewById(R.id.edt_office_address) as TextInputEditText
        val office_no = dialogView.findViewById(R.id.edt_office_no) as TextInputEditText
        val pan_no = dialogView.findViewById(R.id.edt_pan_no) as TextInputEditText
        val email = dialogView.findViewById(R.id.edt_email) as TextInputEditText
        val mobileNumber = dialogView.findViewById(R.id.edt_mobileNumber) as TextInputEditText
        val occupationSubCategoryEdittext =
            dialogView.findViewById(R.id.occupationSubCategoryEdittext) as TextInputEditText
        val panLayout = dialogView.findViewById(R.id.panLayout) as TextInputLayout
        val officePhoneNoLayout =
            dialogView.findViewById(R.id.officePhoneNoLayout) as TextInputLayout
        val officeAddressLayout =
            dialogView.findViewById(R.id.officeAddressLayout) as TextInputLayout
        val designationLayout = dialogView.findViewById(R.id.designationLayout) as TextInputLayout
        val organisationLayout = dialogView.findViewById(R.id.organisationLayout) as TextInputLayout

        val occupationSubcategoryLayout =
            dialogView.findViewById(R.id.occupationSubcategoryLayout) as TextInputLayout

        val occupationSubCategoryEdittextLayout =
            dialogView.findViewById(R.id.occupationSubCategoryEdittextLayout) as TextInputLayout

        var qualification_id = ""
        var occupation_id = ""
        var occupation_sub_category = ""
        var selectedOccupationName = ""
        var selectedSubOccupationName = ""
        header.setText(type)



        if (realationShip.occupationId!!.occupationName!!.toLowerCase().equals("home maker")) {

            occupationSubcategoryLayout.visibility = GONE
            organisationLayout.visibility = GONE
            designationLayout.visibility = GONE
            officeAddressLayout.visibility = GONE
            officePhoneNoLayout.visibility = GONE
            panLayout.visibility = GONE
        } else {
            occupationSubcategoryLayout.visibility = VISIBLE
            organisationLayout.visibility = VISIBLE
            designationLayout.visibility = VISIBLE
            officeAddressLayout.visibility = VISIBLE
            officePhoneNoLayout.visibility = VISIBLE
            panLayout.visibility = VISIBLE
        }


        selectedOccupationName = realationShip.occupationId.occupationName.toString()
        selectedSubOccupationName = realationShip.occupationChildId!!.occupationChildName.toString()

        qualification_id = realationShip.qualificationId?.id.toString()
        occupation_id = realationShip.occupationId?.id.toString()
        occupation_sub_category = realationShip.occupationChildId?.id.toString()


        ///////////QUALIFICATION/////////
        val qualificationList = ArrayList<String>()
        val qualificationListId = ArrayList<String>()
        var qualificationIndex = 0
        for ((index, data) in mQualificationResponse.withIndex()) {
            qualificationList.add(data.qualification!!)
            qualificationListId.add(data.id!!)
            if (qualification_id == data.id) {
                qualificationIndex = index
            }
        }

        val qualificationAdapter: ArrayAdapter<String> = ArrayAdapter(
            mContext, android.R.layout.simple_list_item_1, android.R.id.text1, qualificationList
        )
        qualification.setAdapter(qualificationAdapter)
        qualification.setText(
            qualification.adapter.getItem(qualificationIndex).toString(), false
        )

        qualification.onItemClickListener = AdapterView.OnItemClickListener { _, _, position, _ ->

            qualification_id = qualificationListId[position]

        }

        var occupationSubCategoryIndex = 0
        val occupationSubCategoryList = ArrayList<String>()
        val occupationSubCategoryListId = ArrayList<String>()

        ///////////OCCUPATION/////////
        val occupationList = ArrayList<String>()
        val occupationListId = ArrayList<String>()
        var occupationIndex = 0
        for ((index, data) in mOccupationCategory.withIndex()) {
            occupationList.add(data.occupationName!!)
            occupationListId.add(data.id!!)

            if (occupation_id == data.id) {
                occupationIndex = index
            }
        }

        val occupationAdapter: ArrayAdapter<String> = ArrayAdapter(
            mContext, android.R.layout.simple_list_item_1, android.R.id.text1, occupationList
        )
        occupation.setAdapter(occupationAdapter)
        occupation.setText(
            occupation.adapter.getItem(occupationIndex).toString(), false
        )

        occupation.onItemClickListener = AdapterView.OnItemClickListener { _, _, position, _ ->


            selectedOccupationName = occupationList[position]
            if (selectedOccupationName.toLowerCase().equals("home maker")) {

                occupationSubcategoryLayout.visibility = GONE
                organisationLayout.visibility = GONE
                designationLayout.visibility = GONE
                officeAddressLayout.visibility = GONE
                officePhoneNoLayout.visibility = GONE
                panLayout.visibility = GONE
            } else {
                occupationSubcategoryLayout.visibility = VISIBLE
                organisationLayout.visibility = VISIBLE
                designationLayout.visibility = VISIBLE
                officeAddressLayout.visibility = VISIBLE
                officePhoneNoLayout.visibility = VISIBLE
                panLayout.visibility = VISIBLE
            }

            if (selectedOccupationName.toLowerCase() == "others" || selectedOccupationName.toLowerCase() == "other") {
                occupationSubCategoryEdittext.setText("")
                occupationSubCategoryEdittextLayout.visibility = View.VISIBLE
                occupationSubcategoryLayout.visibility = View.GONE
            } else {
                occupationSubCategoryEdittext.setText("")
                occupationSubCategoryEdittextLayout.visibility = View.GONE
                if (!selectedOccupationName.toLowerCase().equals("home maker")) {

                    occupationSubcategoryLayout.visibility = View.VISIBLE
                }

            }
            occupation_id = occupationListId[position]

            Log.e("-----------", occupation_id)
            ///////////OCCUPATION SUBCATEGORY/////////
            occupationSubCategoryList.clear()
            occupationSubCategoryListId.clear()
            for ((index, data) in mOccupationSubCategory.withIndex()) {

                if (data.occupationId.toString() == occupation_id) {
                    occupationSubCategoryList.add(data.occupationChildName!!)
                    occupationSubCategoryListId.add(data.id!!)

                    Log.e("-----------", data.occupationChildName)

                }


            }

            for ((index, data) in occupationSubCategoryListId.withIndex()) {
                if (occupation_sub_category == data) {
                    occupationSubCategoryIndex = index
                }
            }

            Log.e("-----------", occupationSubCategoryList.toString())


            val occupationSubCategoryAdapter: ArrayAdapter<String> = ArrayAdapter(
                mContext,
                android.R.layout.simple_list_item_1,
                android.R.id.text1,
                occupationSubCategoryList
            )
            occupationSubCategory.setAdapter(occupationSubCategoryAdapter)
            if (occupationSubCategoryList.size > 0) {
                occupationSubCategory.setText(
                    occupationSubCategory.adapter.getItem(occupationSubCategoryIndex).toString(),
                    false
                )
            }


        }


        if (selectedOccupationName.toLowerCase() == "others" || selectedOccupationName.toLowerCase() == "other") {
            occupationSubCategoryEdittext.setText(realationShip.otherOccupation.toString())
            occupationSubCategoryEdittextLayout.visibility = View.VISIBLE
            occupationSubcategoryLayout.visibility = View.GONE
        } else {
            occupationSubCategoryEdittextLayout.visibility = View.GONE
            if (!selectedOccupationName.toLowerCase().equals("home maker")) {

                occupationSubcategoryLayout.visibility = View.VISIBLE
            }
        }


        ///////////OCCUPATION SUBCATEGORY/////////
        occupationSubCategoryList.clear()
        occupationSubCategoryListId.clear()
        for ((index, data) in mOccupationSubCategory.withIndex()) {

            if (data.occupationId.toString() == occupation_id.toString()) {
                occupationSubCategoryList.add(data.occupationChildName!!)
                occupationSubCategoryListId.add(data.id!!)

            }

        }

        for ((index, data) in occupationSubCategoryListId.withIndex()) {

            if (occupation_sub_category == data) {
                occupationSubCategoryIndex = index
            }

        }

        val occupationSubCategoryAdapter: ArrayAdapter<String> = ArrayAdapter(
            mContext,
            android.R.layout.simple_list_item_1,
            android.R.id.text1,
            occupationSubCategoryList
        )
        occupationSubCategory.setAdapter(occupationSubCategoryAdapter)
        if (occupationSubCategoryList.size > 0) {
            occupationSubCategory.setText(
                occupationSubCategory.adapter.getItem(occupationSubCategoryIndex).toString(), false
            )
        }

        occupationSubCategory.onItemClickListener =
            AdapterView.OnItemClickListener { _, _, position, _ ->

                selectedSubOccupationName = occupationSubCategoryList[position]

                if (selectedSubOccupationName.toLowerCase() == "others" || selectedSubOccupationName.toLowerCase() == "other") {
                    occupationSubCategoryEdittext.setText("")
                    occupationSubCategoryEdittextLayout.visibility = View.VISIBLE
                } else {
                    occupationSubCategoryEdittextLayout.visibility = View.GONE
                }

                occupation_sub_category = occupationSubCategoryListId[position]

            }

        if (occupationSubcategoryLayout.visibility == VISIBLE) {
            if ((selectedSubOccupationName.toLowerCase() == "others"
                        || selectedSubOccupationName.toLowerCase() == "other")
            ) {
                occupationSubCategoryEdittext.setText(realationShip.otherOccupation.toString())
                occupationSubCategoryEdittextLayout.visibility = View.VISIBLE
            } else {
                occupationSubCategoryEdittextLayout.visibility = View.GONE

            }
        }


        edt_name.setText(realationShip.name)
        organisation.setText(realationShip.organization)
        designation.setText(realationShip?.designation)
        office_address.setText(realationShip?.office_Address)
        office_no.setText(realationShip?.officePhone)
        pan_no.setText(realationShip?.pancard)
        email.setText(realationShip?.email)
        mobileNumber.setText(realationShip?.mobile)


        val submit = dialogView.findViewById(R.id.submit) as TextView
        val close = dialogView.findViewById(R.id.close) as TextView





        close.setOnClickListener {
            dialog.dismiss()
            dialog.cancel()
        }

        submit.setOnClickListener {

            if (mobileNumber.text.toString() == "") {
                showErrorToast("Please enter mobile number", mContext)
            } else if (mobileNumber.text!!.length != 10) {
                showErrorToast("Please enter valid mobile number", mContext)

            } else if (email.text.toString() == "") {
                showErrorToast("Please enter email", mContext)

            } else if (!isEditTextContainEmail(email.text.toString())) {
                showErrorToast("Please enter valid email", mContext)

            } else if (pan_no.text.toString() != "" && pan_no.text.toString()
                    .toLowerCase() != "na" && pan_no.text.toString().lowercase()
                != "n/a" && !pan_no.text.toString().matches("[A-Z]{5}[0-9]{4}[A-Z]{1}".toRegex())
            ) {
                showErrorToast("Please enter valid pan number", mContext)
            } else {
                val jsonParams: ArrayMap<String, Any>
                if (selectedOccupationName.toLowerCase() == "home maker") {
                    jsonParams = ArrayMap<String, Any>()
                    jsonParams.put("relation", realationShip.relation!!);
                    jsonParams.put("name", realationShip.name);
                    jsonParams.put("mobile", mobileNumber.text.toString());
                    jsonParams.put("email", email.text.toString());
                    jsonParams.put("occupation_id", occupation_id);
                    jsonParams.put("qualification_id", qualification_id);
                    jsonParams.put("pancard", pan_no.text.toString());

                } else if (occupationSubCategoryEdittextLayout.visibility != View.GONE) {
                    jsonParams = ArrayMap<String, Any>()
                    jsonParams.put("relation", realationShip.relation!!);
                    jsonParams.put("name", realationShip.name);
                    jsonParams.put("mobile", mobileNumber.text.toString());
                    jsonParams.put("email", email.text.toString());
                    jsonParams.put("occupation_id", occupation_id);
                    jsonParams.put("qualification_id", qualification_id);
                    jsonParams.put("pancard", pan_no.text.toString());
                    jsonParams.put(
                        "other_occupation",
                        occupationSubCategoryEdittext.text.toString()
                    );
                    jsonParams.put("designation", designation.text.toString());
                    jsonParams.put("office_address", office_address.text.toString());
                    jsonParams.put("office_phone", office_no.text.toString());
                    jsonParams.put("organization", organisation.text.toString());
                } else {
                    jsonParams = ArrayMap<String, Any>()
                    jsonParams.put("relation", realationShip.relation!!);
                    jsonParams.put("name", realationShip.name);
                    jsonParams.put("mobile", mobileNumber.text.toString());
                    jsonParams.put("email", email.text.toString());
                    jsonParams.put("occupation_id", occupation_id);
                    jsonParams.put("qualification_id", qualification_id);
                    jsonParams.put("pancard", pan_no.text.toString());
                    jsonParams.put(
                        "other_occupation",
                        occupationSubCategoryEdittext.text.toString()
                    );
                    jsonParams.put("designation", designation.text.toString());
                    jsonParams.put("occupation_child_id", occupation_sub_category);
                    jsonParams.put("office_address", office_address.text.toString());
                    jsonParams.put("office_phone", office_no.text.toString());
                    jsonParams.put("organization", organisation.text.toString());
                }


                Log.e("---------test", jsonParams.toString())
                val body: RequestBody = create(
                    "application/json; charset=utf-8".toMediaTypeOrNull(),
                    JSONObject(jsonParams).toString()
                )

                viewModel.callForUpdateProfile(
                    requireContext(),
                    Utils.getAccessToken(mContext),
                    Utils.getStudentID(mContext),
                    body
                )
                dialog.dismiss();
                dialog.cancel();
            }


        }
    }

    fun isEditTextContainEmail(str: String): Boolean {
        return try {
            val pattern: Pattern =
                Pattern.compile("^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$")
            val matcher: Matcher = pattern.matcher(str)
            matcher.matches()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override val observerError = Observer<ResponseStatusError> {

        when (it) {
            is ResponseStatusError.NoInternetError -> {
                showErrorToast(getString(R.string.check_internet_connection), requireContext())
            }

            is ResponseStatusError.TechnicalError -> {
                showErrorToast(getString(R.string.some_technical_issue_occurred), requireContext())
            }

            is ResponseStatusError.ErrorResponseError -> {}
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

    override fun editParent(type: String, relationship: SingleStudentDetail.Data.Relation) {
        showCommonEditDialog(type, relationship)
    }


}