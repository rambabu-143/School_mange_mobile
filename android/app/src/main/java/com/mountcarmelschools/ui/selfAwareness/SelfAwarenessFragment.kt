package com.mountcarmelschools.ui.selfAwareness

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.widget.TextView
import androidx.lifecycle.Observer
import com.google.android.material.imageview.ShapeableImageView
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentSelfawarenessBinding
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessRequest
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessResponse
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.di.networking.ResponseStatusError
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils


class SelfAwarenessFragment :
    BaseFragment<FragmentSelfawarenessBinding, SelfAwarenessViewModel>() {


    lateinit var mContext: Context

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Self Awareness")

    }

    override fun getLayoutID(): Int {

        return R.layout.fragment_selfawareness
    }

    override fun getViewModel(): Class<SelfAwarenessViewModel> {

        return SelfAwarenessViewModel::class.java

    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        dataBinding.selfAwareViewModel = viewModel

        dataBinding.lastDateOfSubmission.text =
            "Last Date of Submission: " + ((mContext) as DashboardActivity).mSelfAwarenessEndDate+":00"


        dataBinding.preview.setOnClickListener {

            showPreviewDialog()
        }

        // getSelfAwareness()

        initObserver()

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

    private fun initObserver() {

        viewModel.liveDataNetworkError.observe(viewLifecycleOwner, observerError)
        viewModel.liveDataSelfAwareness.observe(viewLifecycleOwner, observerGetSelfAwareness)
        viewModel.liveSubmitSelfAwareness.observe(viewLifecycleOwner, observerUpdateSelfAwareness)

        getSelfAwareness()
    }


    private fun getSelfAwareness() {
        (mContext as DashboardActivity).showProgress()
        viewModel.callGetSelfAwareness(
            requireContext(),
            Utils.getAccessToken(mContext),
            Utils.getUserId(mContext),
        )
    }

    private val observerGetSelfAwareness =
        Observer<ResponseStatus<SelfAwarenessResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {

                    if (responseStatus.response.data?.is_submit == null) {

                        dataBinding.selfAwarenessForm.visibility = View.VISIBLE
                        dataBinding.previewForm.visibility = View.GONE
                    } else {
                        if (!responseStatus.response.data.is_submit) {
                            dataBinding.selfAwarenessForm.visibility = View.VISIBLE
                            dataBinding.previewForm.visibility = View.GONE

                            dataBinding.edtGoals.setText(responseStatus.response.data.my_goal!!.toString())
                            dataBinding.edtStrength.setText(responseStatus.response.data.my_strength!!.toString())
                            dataBinding.edtInterest.setText(responseStatus.response.data.my_interest_hobbies!!.toString())
                            dataBinding.edtResponsible.setText(responseStatus.response.data.responsibilities!!.toString())
                        } else {
                            dataBinding.selfAwarenessForm.visibility = View.GONE
                            dataBinding.previewForm.visibility = View.VISIBLE

                            dataBinding.tvGoal.text =
                                responseStatus.response.data?.my_goal!!.toString()
                            dataBinding.tvStrength.text =
                                responseStatus.response.data.my_strength!!.toString()
                            dataBinding.tvHobbies.text =
                                responseStatus.response.data.my_interest_hobbies!!.toString()
                            dataBinding.tvResponsibilities.text =
                                responseStatus.response.data.responsibilities!!.toString()

                        }
                    }
                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }

    private fun showPreviewDialog() {
        val dialogBuilder = AlertDialog.Builder(mContext)
        val inflater =
            (mContext).getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val dialogView: View = inflater.inflate(R.layout.preview_selfawareness_dialog, null)
        dialogBuilder.setView(dialogView)

        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()

        val saveAsDraft = dialogView.findViewById(R.id.btn_saveAs) as TextView
        val submit = dialogView.findViewById(R.id.btn_submit) as TextView
        val tvResponsibilities = dialogView.findViewById(R.id.tvResponsibilities) as TextView
        val tvHobbies = dialogView.findViewById(R.id.tvHobbies) as TextView
        val tvStrength = dialogView.findViewById(R.id.tvStrength) as TextView
        val tvGoal = dialogView.findViewById(R.id.tvGoal) as TextView
        val iv_close = dialogView.findViewById(R.id.iv_close) as ShapeableImageView

        tvGoal.text = dataBinding.edtGoals.text.toString()
        tvStrength.text = dataBinding.edtStrength.text.toString()
        tvHobbies.text = dataBinding.edtInterest.text.toString()
        tvResponsibilities.text = dataBinding.edtResponsible.text.toString()




        iv_close.setOnClickListener {
            dialog.dismiss();
        }

        saveAsDraft.setOnClickListener {
            dialog.dismiss()

            val data = SelfAwarenessRequest(
                tvGoal.text.toString(),
                tvStrength.text.toString(),
                tvHobbies.text.toString(),
                tvResponsibilities.text.toString(),
                "false",
                Utils.getUserId(mContext),
                (mContext as DashboardActivity).studentDetail.data!!.standard_section_id!!.id.toString(),

                )

            updateData(data)
        }

        submit.setOnClickListener {
            if (tvGoal.text.isEmpty()) {

                dataBinding.edtGoals.requestFocus();
                dataBinding.edtGoals.isCursorVisible = true;
                dataBinding.edtGoals.error = "Please enter Goal"

            } else if (tvStrength.text.isEmpty()) {

                dataBinding.edtStrength.requestFocus();
                dataBinding.edtStrength.isCursorVisible = true;
                dataBinding.edtStrength.error = "Please enter Strength"
            } else if (tvHobbies.text.isEmpty()) {

                dataBinding.edtInterest.requestFocus();
                dataBinding.edtInterest.isCursorVisible = true;
                dataBinding.edtInterest.error = "Please enter Hobbies"
            } else if (tvResponsibilities.text.isEmpty()) {
                dataBinding.edtResponsible.requestFocus();
                dataBinding.edtResponsible.isCursorVisible = true;
                dataBinding.edtResponsible.error = "Please enter Hobbies"
            } else {
                val data = SelfAwarenessRequest(
                    tvGoal.text.toString(),
                    tvStrength.text.toString(),
                    tvHobbies.text.toString(),
                    tvResponsibilities.text.toString(),
                    "true",
                    Utils.getUserId(mContext),
                    (mContext as DashboardActivity).studentDetail.data!!.standard_section_id!!.id.toString(),

                    )

                updateData(data)
            }
            dialog.dismiss()

        }


    }

    private fun updateData(
        data: SelfAwarenessRequest
    ) {
        (mContext as DashboardActivity).showProgress()
        viewModel.callSubmitSelfAwareness(
            context = requireContext(), data = data, authToken = Utils.getAccessToken(mContext),
        )
    }

    private val observerUpdateSelfAwareness =
        Observer<ResponseStatus<CommonResponse>> { it ->
            (mContext as DashboardActivity).hideProgress()

            when (it) {
                is ResponseStatus.Success -> {
                    showSuccessToast(it.response.message!!, requireContext())
                    getSelfAwareness()
                }

                is ResponseStatus.Error -> {

                    showErrorToast(it.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(it.responseMessage, requireContext())

                }
            }
        }

}