package com.mountcarmelschools.ui.profile.health

import android.app.AlertDialog
import android.content.Context
import android.os.Bundle
import android.view.View
import android.view.WindowManager
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.AutoCompleteTextView
import android.widget.TextView
import androidx.lifecycle.Observer
import com.google.android.material.textfield.TextInputEditText
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentHealthBinding
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.studentprofile.GeneralPostData
import com.mountcarmelschools.di.data.studentprofile.MedicalPostData
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.di.networking.ResponseStatusError
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils

class HealthFragment : BaseFragment<FragmentHealthBinding, HealthFragmentViewModel>() {
    lateinit var mContext: Context


    var mBloodGroup = ""
    var mAllergies = ""
    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }


    override fun getLayoutID(): Int {
        return R.layout.fragment_health
    }

    override fun getViewModel(): Class<HealthFragmentViewModel> {
        return HealthFragmentViewModel::class.java

    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Health Details")

    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        if (Utils.isParent(mContext)) {
            dataBinding.medicalEditIcon.visibility = View.VISIBLE
        }
        val studentDetailData = (mContext as DashboardActivity).studentDetail.data

        dataBinding.bloodGroup.text = "Blood Group : " + studentDetailData?.medical?.bloodgroup
        dataBinding.alergies.text = "Allergies : " + studentDetailData?.medical?.allergies
        dataBinding.height.text = "Height(cm) : " + studentDetailData?.medical?.height
        dataBinding.weight.text = "Weight(kg) : " + studentDetailData?.medical?.weight
        dataBinding.visionLeft.text = "Vision Left : " + studentDetailData?.medical?.visionleft
        dataBinding.visionRight.text = "Vision Right : " + studentDetailData?.medical?.visionright
        dataBinding.hygiene.text = "Hygiene : " + studentDetailData?.medical?.hygiene
        dataBinding.bmi.text = "BMI : " + studentDetailData?.medical?.bmi
        dataBinding.hearing.text = "Hearing(db) : " + studentDetailData?.medical?.hearing
        dataBinding.lips.text = "Lips : " + studentDetailData?.medical?.lips
        dataBinding.teeth.text = "Teeth : " + studentDetailData?.medical?.teeth
        dataBinding.plaque.text = "Plaque : " + studentDetailData?.medical?.plaque
        dataBinding.gums.text = "Gums : " + studentDetailData?.medical?.gums
        dataBinding.breath.text = "Breath : " + studentDetailData?.medical?.breath
        dataBinding.dentalConcerns.text = "Dental Concerns : " + studentDetailData?.medical?.dental_concerns
        dataBinding.generalObservation.text = "General Observation : " + studentDetailData?.medical?.general_observation
        dataBinding.otherObservation.text = "Other Observation : " + studentDetailData?.medical?.other_observation
        dataBinding.specoficAliments.text =
            "Specific Ailments: " + studentDetailData?.medical?.specificailment

        mBloodGroup = studentDetailData?.medical?.bloodgroup.toString()
        mAllergies = studentDetailData?.medical?.allergies.toString()

        dataBinding.medicalEditIcon.setOnClickListener {
            openMedicalInfoDialog()
        }
        initObserver()
    }

    private fun initObserver() {

        viewModel.liveDataNetworkError.observe(viewLifecycleOwner, observerError)
        viewModel.liveDataHealth.observe(viewLifecycleOwner, observerUpdateMedicalResponse)
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


    private fun openMedicalInfoDialog() {
        val dialogBuilder = AlertDialog.Builder(mContext)
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.edit_medical_info, null)
        dialogBuilder.setView(dialogView)

        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()

        dialog.window!!.clearFlags(
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM
        )

        val bloodGroup = dialogView.findViewById(R.id.bloodGroup) as AutoCompleteTextView
        val edtAllergies = dialogView.findViewById(R.id.edt_allergies) as TextInputEditText
        val submit = dialogView.findViewById(R.id.submit) as TextView
        val close = dialogView.findViewById(R.id.close) as TextView


        edtAllergies.setText(mAllergies);
        val bloodGroupList = ArrayList<String>();
        bloodGroupList.add("A+")
        bloodGroupList.add("A-")
        bloodGroupList.add("AB+")
        bloodGroupList.add("AB-")
        bloodGroupList.add("B+")
        bloodGroupList.add("B-")
        bloodGroupList.add("O+")
        bloodGroupList.add("O-")

        var mSelectedBloodGroup = 0
        for ((index, data) in bloodGroupList.withIndex()) {

            if (mBloodGroup == data) {
                mSelectedBloodGroup = index
            }
        }

        val adapter: ArrayAdapter<String> = ArrayAdapter(
            mContext, android.R.layout.simple_list_item_1, android.R.id.text1, bloodGroupList
        )

        bloodGroup.setAdapter(adapter)
        bloodGroup.setText(
            bloodGroup.adapter.getItem(mSelectedBloodGroup).toString(), false
        )


        bloodGroup.onItemClickListener =
            AdapterView.OnItemClickListener { parent, view, position, id ->

                mBloodGroup = bloodGroupList[position].toString()

            }


        close.setOnClickListener {
            dialog.dismiss()
            dialog.cancel()
        }

        submit.setOnClickListener {
            dialog.dismiss();
            dialog.cancel();
            val medical = MedicalPostData.Medical(
                allergies = edtAllergies.text.toString(),
                mBloodGroup
            )
            val data = MedicalPostData(
                medical
            )
            viewModel.updateMedical(
                requireContext(), Utils.getAccessToken(mContext), Utils.getStudentID(mContext), data
            )

        }
    }

    private val observerUpdateMedicalResponse =
        Observer<ResponseStatus<CommonResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {
                    (mContext as DashboardActivity).getStudentDetail();
                    (mContext as DashboardActivity).supportFragmentManager.popBackStack();


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

}