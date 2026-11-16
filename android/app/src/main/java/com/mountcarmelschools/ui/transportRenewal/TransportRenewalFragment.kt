package com.mountcarmelschools.ui.transportRenewal

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.View.GONE
import android.view.View.VISIBLE
import android.view.ViewGroup
import android.widget.TextView
import androidx.lifecycle.Observer
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentTransportRenewalBinding
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.staff.sms.SmsResponse
import com.mountcarmelschools.di.data.staffProfile.GetStudentDetailFromAdmissioNO
import com.mountcarmelschools.di.data.streamSelection.StreamSelectionResponse
import com.mountcarmelschools.di.data.studentDetail.SingleStudentDetail
import com.mountcarmelschools.di.data.transport.TransportRenewalPostData
import com.mountcarmelschools.di.data.transport.TransportRenewalPostData.SiblingDetail
import com.mountcarmelschools.di.data.transport.TransportRenewalResponse
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.di.networking.ResponseStatusError
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.ui.welcome.WelcomeActivity
import com.mountcarmelschools.utlis.SharedPreferenceUtils
import com.mountcarmelschools.utlis.Utils
import java.util.ArrayList

class TransportRenewalFragment :
    BaseFragment<FragmentTransportRenewalBinding, TransportRenewalViewModel>() {


    lateinit var mContext: Context

    lateinit var studentDetailData: SingleStudentDetail.Data

    private var listOFNewAddedStudent = ArrayList<GetStudentDetailFromAdmissioNO.Data?>()

    private var selectedType = "renew"

    private var renewalYear=""

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Transport Renewal")

        viewModel.callTransportRenewal(
            mContext,
            Utils.getAccessToken(mContext),
            studentDetailData.id.toString()
        )

    }

    override fun getLayoutID(): Int {

        return R.layout.fragment_transport_renewal
    }

    override fun getViewModel(): Class<TransportRenewalViewModel> {

        return TransportRenewalViewModel::class.java

    }

    @SuppressLint("SetTextI18n")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        dataBinding.transportRenewalViewModel = viewModel

        studentDetailData = (mContext as DashboardActivity).studentDetail.data!!

        dataBinding.edtAddress.setText(
            studentDetailData.address!![studentDetailData.address!!.size - 1]!!.localAddress
                    + ", "
                    + studentDetailData.address!![studentDetailData.address!!.size - 1]!!.city+", "
                    + studentDetailData.address!![studentDetailData.address!!.size - 1]!!.stateId?.stateName+", "
                    + studentDetailData.address!![studentDetailData.address!!.size - 1]!!.countryId?.countryName+", "
                    + studentDetailData.address!![studentDetailData.address!!.size - 1]!!.pincode
        )
        dataBinding.edtSmsNo.setText(studentDetailData.smsMobile)

        dataBinding.transportRenewalText.setText("TRANSPORT RENEWAL FORM FOR THE SESSION (" + (mContext as DashboardActivity).currentYear + ")")

        for (item in studentDetailData.relation!!) {
            if (item!!.relation.equals("FATHER") || item.relation.equals("father")) {
                dataBinding.edtFatherNo.setText(item.mobile)
            } else {
                dataBinding.edtMotherNo.setText(item.mobile)

            }
        }

            val studentDetailData = (mContext as DashboardActivity)
                .studentDetail.data?.transportBillId?.transportAry

            dataBinding.morningValue.text = studentDetailData?.get(studentDetailData.size - 1)!!.morningroute
            dataBinding.pickUpValue.text = studentDetailData.get(studentDetailData.size - 1)!!.morningstop


            dataBinding.afterNoonValue.text =studentDetailData.get(studentDetailData.size - 1)!!.eveningroute
            dataBinding.dropOffPoint.text = studentDetailData.get(studentDetailData.size - 1)!!.eveningstop


        initObserver()

    }

    private fun initObserver() {

        viewModel.liveDataNetworkError.observe(viewLifecycleOwner, observerError)
        viewModel.liveAdmissionNumberConfirmation.observe(
            viewLifecycleOwner,
            observerCheckAdmissionNumber
        )
        viewModel.liveDataUpdateRenewalData.observe(
            viewLifecycleOwner,
            observerTransportRenewalPostData
        )
        viewModel.liveDataGetTransportRenewal.observe(
            viewLifecycleOwner,
            observerTransportRenewalData
        )




        dataBinding.siblingRadioButton.setOnCheckedChangeListener { group, checkedId ->
            when (checkedId) {
                R.id.yesRadioButton -> {

                    dataBinding.admissionNoContainer.visibility = VISIBLE
                }
                R.id.noRadioButton -> {
                    dataBinding.admissionNoContainer.visibility = View.GONE


                }
            }
        }


        dataBinding.renewRadioGroup.setOnCheckedChangeListener { group, checkedId ->
            when (checkedId) {
                R.id.renew -> {

                    selectedType = "renew"
                }
                R.id.withdraw -> {
                    selectedType = "withdraw"


                }
            }
        }



        dataBinding.siblingRadioButton.setOnCheckedChangeListener { group, checkedId ->
            when (checkedId) {
                R.id.yesRadioButton -> {

                    dataBinding.admissionNoContainer.visibility = VISIBLE
                }
                R.id.noRadioButton -> {
                    dataBinding.admissionNoContainer.visibility = View.GONE


                }
            }
        }


        if ((mContext as DashboardActivity).userName != "") {

            dataBinding.edtName.setText((mContext as DashboardActivity).userName)

        }

        if ((mContext as DashboardActivity).userImage != "") {

            Glide.with(this)
                .load((mContext as DashboardActivity).userImage)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .error(R.drawable.default_image)
                .into(dataBinding.studentImage)
        }

        if ((mContext as DashboardActivity).userAdmission != "") {

            dataBinding.edtAdmission.setText((mContext as DashboardActivity).userAdmission)

        }

        dataBinding.addAdmissionNO.setOnClickListener {
            if (dataBinding.edtAdmissionNo.text.toString() == "") {
                showErrorToast("Please enter admission no.", mContext);

            } else if (childAlreadyAddedInNewList(
                    dataBinding.edtAdmissionNo.text.toString(), listOFNewAddedStudent
                )
            ) {

                showErrorToast("Sibling Already Exist", mContext);

            } else {
                (mContext as DashboardActivity).showProgress()
                viewModel.callCheckAdmissionNumber(
                    mContext,
                    Utils.getAccessToken(mContext),
                    dataBinding.edtAdmissionNo.text.toString()
                )

            }
        }

        dataBinding.submit.setOnClickListener {
            showDialog()
        }
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


    private fun addNewChildLayout(data: GetStudentDetailFromAdmissioNO.Data?) {
        dataBinding.siblingContainer.removeAllViews()
        for ((index, data) in listOFNewAddedStudent.withIndex()) {

            val view = layoutInflater.inflate(R.layout.dropdown_menu_popup_item, null)

            val textView = view.findViewById<TextView>(R.id.text1);

            val currentIndex = index + 1
            textView.text =
                "$currentIndex. ${data!!.admissionNo}-${data!!.name} (${data.standardSectionId!!.standard}  ${data.standardSectionId!!.section})"

            dataBinding.siblingContainer.visibility = VISIBLE
            dataBinding.siblingContainer.addView(view)

        }

        if (listOFNewAddedStudent.size > 0 && listOFNewAddedStudent[0]!!.siblings != null) {
            for (data in listOFNewAddedStudent[0]!!.siblings!!) {

                val view = layoutInflater.inflate(R.layout.dropdown_menu_popup_item, null)

                val textView = view.findViewById<TextView>(R.id.text1);

                textView.text = "${data!!.siblingId!!.name} (${data.admissionNo})"

                dataBinding.siblingContainer.visibility = VISIBLE
                dataBinding.siblingContainer.addView(view)

            }
        }


    }

    private val observerCheckAdmissionNumber =
        Observer<ResponseStatus<GetStudentDetailFromAdmissioNO>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {

                    dataBinding.edtAdmissionNo.setText("")

                    listOFNewAddedStudent.add(responseStatus.response.data)

                    addNewChildLayout(responseStatus.response.data)

                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }


    private val observerTransportRenewalData =
        Observer<ResponseStatus<TransportRenewalResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {
                    renewalYear=responseStatus.response.nextYearSession.toString();
                    dataBinding.headerAddress.text = responseStatus.response.branchDetails?.branchAddress.toString()
                    dataBinding.transportRenewalText.setText("TRANSPORT RENEWAL FORM FOR THE SESSION (" + responseStatus.response.nextYearSession + ")")

                    dataBinding.inYear.setText(" (In " +responseStatus.response.nextYearSession+ " )")
                    dataBinding.form.visibility = VISIBLE
                    dataBinding.placeHolder.visibility = GONE
                    dataBinding.edtProvisional.setText(responseStatus.response.promotedClass+ " " + studentDetailData.standard_section_id?.section)

                }

                is ResponseStatus.Error -> {
                    dataBinding.form.visibility = GONE
                    dataBinding.placeHolder.visibility = VISIBLE
                    dataBinding.placeHolderText.text = responseStatus.responseMessage

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }

    private val observerTransportRenewalPostData =
        Observer<ResponseStatus<CommonResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {

                    (mContext as DashboardActivity).supportFragmentManager.popBackStack()
                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }


    override val observerError = Observer<ResponseStatusError> {
        (mContext as DashboardActivity).hideProgress()

        when (it) {

            is ResponseStatusError.NoInternetError -> {
                showSuccessToast(getString(R.string.check_internet_connection), requireContext())
            }

            is ResponseStatusError.TechnicalError -> {
                showSuccessToast(it.errorMessageCode.toString(), requireContext())
            }

            is ResponseStatusError.ErrorResponseError -> {
            }
        }
    }

    fun showDialog() {
        val dialogBuilder = AlertDialog.Builder(mContext)
        val inflater =
            (mContext).getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val dialogView: View = inflater.inflate(R.layout.transport_renewal_dialog, null)
        dialogBuilder.setView(dialogView)


        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()

        val cancel = dialogView.findViewById(R.id.close) as TextView
        val save = dialogView.findViewById(R.id.save) as TextView
        val condition = dialogView.findViewById(R.id.condition) as TextView
        val description = dialogView.findViewById(R.id.description) as TextView

        if (selectedType == "renew")
        {
            condition.setText("Terms and Conditions")
            description.setText("I hereby agree,\n1. I may be required to travel in the bus a maximum of four times in the year from the first stop to the school in the morning and from the school to the last stop in the afternoon, as per the schedule provided, at least a week in advance. I agree to do this or arrange a substitute when required.\n2. The school is held indemnified against all claims through accident or any other cause.\n3. I have read the transport rules given in the school almanac and my ward will follow them.")
        }
        else{
            var data = renewalYear.split("-")
            condition.setText("Declaration")
            description.setText("I hereby accept and confirm that the school transport facility for my ward be withdrawn w.e.f 1st April ${data[0]} for the session $renewalYear.")

        }



        cancel.setOnClickListener {
            dialog.dismiss()
        }

        save.setOnClickListener {
            val data: TransportRenewalPostData
            if (listOFNewAddedStudent.size > 0) {

                val siblingDetails = ArrayList<SiblingDetail>()

                for (item in listOFNewAddedStudent) {
                    val value = SiblingDetail(
                        admissionNo = item?.admissionNo,
                        classX = studentDetailData.standard_section_id?.standard,
                        name = item?.name,
                        schoolCode = item?.schoolCode,
                        section = item?.sectionId?.name,
                        siblingId = item?.id,
                        standardSectionId = studentDetailData.standard_section_id?.id
                    )
                    siblingDetails.add(value)
                }
                data = TransportRenewalPostData(
                    (mContext as DashboardActivity).userAdmission,
                    siblingDetails = siblingDetails,
                    studentId = studentDetailData.id,
                    transportType = selectedType
                )
            } else {

                data = TransportRenewalPostData(
                    (mContext as DashboardActivity).userAdmission,
                    siblingDetails = arrayListOf(),
                    studentId = studentDetailData.id,
                    transportType = selectedType
                );
            }



            viewModel.callUpdateTransportRenewal(
                mContext, Utils.getAccessToken(mContext), data,
            )
            dialog.dismiss()
        }
    }

}