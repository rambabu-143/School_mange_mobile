package com.mountcarmelschools.ui.parentlogin

import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.text.Html
import android.view.LayoutInflater
import android.view.View
import android.widget.TextView
import androidx.core.content.ContentProviderCompat.requireContext
import androidx.lifecycle.Observer
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseActivity
import com.mountcarmelschools.databinding.ActivityParentLoginBinding
import com.mountcarmelschools.di.data.parentlogindata.OTPResponse
import com.mountcarmelschools.di.data.parentlogindata.OtpRequestData
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessResponse
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.di.networking.ResponseStatusError
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.PARENT_MOBILE_NO
import com.mountcarmelschools.utlis.SharedPreferenceUtils

class ParentLoginActivity : BaseActivity<ActivityParentLoginBinding, ParentLoginViewModel>(),
    ParentNavigator {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        dataBinding.parentModel = viewModel

        if (!SharedPreferenceUtils.getInstance(baseContext)!!
                .getStringValue(PARENT_MOBILE_NO, "").equals("")
        ) {
            viewModel.mobile.set(
                SharedPreferenceUtils.getInstance(
                    baseContext
                )!!.getStringValue(PARENT_MOBILE_NO, "")
            )
        }

        //  dataBinding.edtMobileNumber.addPrefix("91")

        dataBinding.btnSubmit.setOnClickListener(View.OnClickListener {
            if (viewModel.checkValidation(it)) {
                openAlertDialog(it)
            }
        })
        initObserver()
    }

    override fun getLayoutId() = R.layout.activity_parent_login

    override fun getViewModel() = ParentLoginViewModel::class.java


    private fun initObserver() {

        viewModel.liveDataNetworkError.observe(this, observerError)

        viewModel.liveDataParentLoginApi.observe(this, observerParentLogin)

    }

    private fun openAlertDialog(view: View) {
        val dialogBuilder = AlertDialog.Builder(view.context)
        val inflater =
            (view.context).getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val dialogView: View = inflater.inflate(R.layout.submit_popup, null)
        dialogBuilder.setView(dialogView)

        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()
        val tvMsg = dialogView.findViewById(R.id.txt_title) as TextView
        val edit = dialogView.findViewById(R.id.btn_edit) as TextView
        val tvContinue = dialogView.findViewById(R.id.btn_continue) as TextView

        tvMsg.text = Html.fromHtml(
            getString(R.string.are_you_sure_mobile_number) + "<b> " +
                    "(+91)-" + viewModel.mobile.get() + " </b>" + getString(R.string.registered_as_parent) +
                    " </b><br/>"
        )
        edit.setOnClickListener {
            dialog.dismiss()
        }

        tvContinue.setOnClickListener {
            dialog.dismiss()
            if (viewModel.checkValidation(view)) {

                val postData = OtpRequestData(viewModel.mobile.get()!!);

                viewModel.getParentLogin(this,postData)


            }

        }

    }

    override fun getContext(): Context {
        return this@ParentLoginActivity
    }

    override fun onError(message: String?) {

    }

    override val observerError = Observer<ResponseStatusError> {

        when (it) {

            is ResponseStatusError.NoInternetError -> {
                showSuccessToast(getString(R.string.check_internet_connection))
            }

            is ResponseStatusError.TechnicalError -> {
                showSuccessToast(it.errorMessageCode.toString())
            }

            is ResponseStatusError.ErrorResponseError -> {
            }
        }
    }

    private val observerParentLogin =
        Observer<ResponseStatus<OTPResponse>> { responseStatus ->
            when (responseStatus) {
                is ResponseStatus.Success -> {
                    val intent = Intent(this@ParentLoginActivity, OtpActivity::class.java)
                    intent.putExtra("paren_no", viewModel.mobile.get())
                    startActivity(intent)
                    this@ParentLoginActivity.finish()

                }
                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage)
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage)

                }
            }
        }

}

