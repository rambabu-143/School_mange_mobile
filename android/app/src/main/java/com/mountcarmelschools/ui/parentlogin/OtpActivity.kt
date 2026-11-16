package com.mountcarmelschools.ui.parentlogin

import android.content.Context
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.Editable
import android.text.Html
import android.text.TextUtils
import android.text.TextWatcher
import android.util.Log
import android.view.KeyEvent
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.TextView.OnEditorActionListener
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.lifecycle.Observer
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.material.snackbar.Snackbar
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseActivity
import com.mountcarmelschools.databinding.ActivityOtpBinding
import com.mountcarmelschools.di.data.parentlogindata.OTPPost
import com.mountcarmelschools.di.data.parentlogindata.OTPResponse
import com.mountcarmelschools.di.data.parentlogindata.OtpRequestData
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessResponse
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.receiver.MySMSBroadcastReceiver
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.PARENT_MOBILE_NO
import com.mountcarmelschools.utlis.SharedPreferenceUtils
import com.mountcarmelschools.utlis.TEMP_OTP
import com.mountcarmelschools.utlis.Utils

class OtpActivity : BaseActivity<ActivityOtpBinding, OTPViewModel>(), OtpNavigator,
    MySMSBroadcastReceiver.OTPReceiveListener {

    lateinit var mobile: String
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        viewModel.setNavigator(this)
        dataBinding.otpViewModel = viewModel
        viewModel.setNavigator(this)
        val bundle: Bundle? = intent.extras
        if (bundle != null) {
            mobile = bundle.getString("paren_no", "")
        }
        val subStr = mobile.substring(6, 10)
        dataBinding.textPlaceHolder.text = Html.fromHtml(
            getString(R.string.please_enter_verification_code_sent_to_your_mobile_number) + "<b> " +
                    "(+91)-" + "XXXXXX" + subStr + " </b>" +
                    " </b><br/>"
        )



        dataBinding.editText1.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                if (dataBinding.editText1.text.toString().length == 1) //size as per your requirement
                {
                    dataBinding.editText2.requestFocus(View.FOCUS_RIGHT)
                }
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {}
        })
        dataBinding.editText2.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                if (dataBinding.editText2.text.toString().length == 1) //size as per your requirement
                {
                    dataBinding.editText3.requestFocus(View.FOCUS_RIGHT)
                } else if (s.isEmpty()) {
                    dataBinding.editText1.requestFocus(View.FOCUS_LEFT)
                }
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {}
        })
        dataBinding.editText3.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                if (dataBinding.editText3.text.toString().length == 1) //size as per your requirement
                {
                    dataBinding.editText4.requestFocus(View.FOCUS_RIGHT)
                } else if (s.isEmpty()) {
                    dataBinding.editText2.requestFocus(View.FOCUS_LEFT)
                }
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {}
        })
        dataBinding.editText4.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                if (dataBinding.editText4.text.toString().length == 1) {
                    dataBinding.editText5.requestFocus(View.FOCUS_RIGHT)
                } else if (s.isEmpty()) {
                    dataBinding.editText3.requestFocus(View.FOCUS_LEFT)
                } else {
                    Snackbar.make(
                        dataBinding.constraintLayout,
                        getString(R.string.please_enter_otp),
                        Snackbar.LENGTH_LONG
                    ).show();

                }
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {}
        })

        dataBinding.editText5.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                if (dataBinding.editText5.text.length == 1) {
                    dataBinding.editText6.requestFocus(View.FOCUS_RIGHT)
                } else if (s.isEmpty()) {
                    dataBinding.editText4.requestFocus(View.FOCUS_LEFT)
                } else {
                    Snackbar.make(
                        dataBinding.constraintLayout,
                        getString(R.string.please_enter_otp),
                        Snackbar.LENGTH_LONG
                    ).show();

                }
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {}
        })

        dataBinding.editText6.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                if (dataBinding.editText1.text.length == 1 &&
                    dataBinding.editText2.text.length == 1 &&
                    dataBinding.editText3.text.length == 1 &&
                    dataBinding.editText4.text.length == 1 &&
                    dataBinding.editText5.text.length == 1 &&
                    dataBinding.editText6.text.length == 1
                ) {
                } else if (s.isEmpty()) {
                    dataBinding.editText5.requestFocus(View.FOCUS_LEFT)
                } else {
                    Snackbar.make(
                        dataBinding.constraintLayout,
                        getString(R.string.please_enter_otp),
                        Snackbar.LENGTH_LONG
                    ).show();

                }
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {}
        })


        dataBinding.editText6.setOnEditorActionListener(OnEditorActionListener { v, actionId, event ->
            if (event != null && event.keyCode == KeyEvent.KEYCODE_ENTER || actionId == EditorInfo.IME_ACTION_DONE) {
                clickOnContinue()
            }
            false
        })

        val handler = Handler(Looper.myLooper()!!) // just to  get previous screen receiver value -- have re factor it

        handler.postDelayed({
            runOnUiThread {
                val otp: String = SharedPreferenceUtils.getInstance(this@OtpActivity)
                    ?.getStringValue(TEMP_OTP, "")!!
                if (!TextUtils.isEmpty(otp)) {
                    SharedPreferenceUtils.getInstance(this@OtpActivity)
                        ?.setStringValue(TEMP_OTP, "")
                    dataBinding.editText1.setText("" + otp[0])
                    dataBinding.editText2.setText("" + otp[1])
                    dataBinding.editText3.setText("" + otp[2])
                    dataBinding.editText4.setText("" + otp[3])
                    dataBinding.editText5.setText("" + otp[4])
                    dataBinding.editText6.setText("" + otp[5])
                    clickOnContinue()
                }
            }
        }, 150)

        initObserver()
    }

    override fun getLayoutId() = R.layout.activity_otp

    override fun getViewModel() = OTPViewModel::class.java

    private fun initObserver() {

        viewModel.liveDataNetworkError.observe(this, observerError)
        viewModel.liveDataParentLoginApi.observe(this, observerParentLogin)
    }

    override fun clickOnContinue() {
        if (dataBinding.editText1.text.length == 1 &&
            dataBinding.editText2.text.length == 1 &&
            dataBinding.editText3.text.length == 1 &&
            dataBinding.editText4.text.length == 1 &&
            dataBinding.editText5.text.length == 1 &&
            dataBinding.editText6.text.length == 1
        ) {
            if (Utils.isNetworkAvailable(this@OtpActivity)) {
                val otp: String = dataBinding.editText1.text.toString() + "" +
                        dataBinding.editText2.text + "" +
                        dataBinding.editText3.text + "" +
                        dataBinding.editText4.text + "" +
                        dataBinding.editText5.text + "" +
                        dataBinding.editText6.text
                val otpPostData = OTPPost(
                    SharedPreferenceUtils.getInstance(this@OtpActivity)!!
                        .getStringValue(PARENT_MOBILE_NO, "")!!, otp,
                    "android"
                )
                viewModel.verifyOtp(otpPostData).observe(this@OtpActivity, Observer {

                })
            } else {
                Toast.makeText(getContext()!!, "No internet connection", Toast.LENGTH_SHORT).show()

            }
        } else {
            Toast.makeText(getContext()!!, "Please enter verification code/OTP", Toast.LENGTH_SHORT)
                .show()

        }
    }

    private lateinit var smsBroadcast: MySMSBroadcastReceiver

    override fun onStart() {
        super.onStart()
        autoOTPVerify()
        smsBroadcast = MySMSBroadcastReceiver()
        smsBroadcast.initOTPListener(this)
        val intentFilter = IntentFilter()
        intentFilter.addAction(SmsRetriever.SMS_RETRIEVED_ACTION)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            applicationContext.registerReceiver(smsBroadcast, intentFilter, RECEIVER_EXPORTED)
        }
        else{
            applicationContext.registerReceiver(smsBroadcast, intentFilter)

        }
    }

    override fun clickOnResend(view: View) {
        dataBinding.editText1.setText("")
        dataBinding.editText2.setText("")
        dataBinding.editText3.setText("")
        dataBinding.editText4.setText("")
        dataBinding.editText5.setText("")
        dataBinding.editText6.setText("")
        dataBinding.editText1.isFocusable = true
        dataBinding.editText1.moveCursorToVisibleOffset()
        dataBinding.editText1.requestFocus(View.FOCUS_LEFT)


        val postData = OtpRequestData(
            SharedPreferenceUtils.getInstance(view.context)?.getStringValue(PARENT_MOBILE_NO, "")!!
        );

        viewModel.getParentLogin(this, postData)

    }

    override fun getContext(): Context? {
        return this@OtpActivity
    }

    private val observerParentLogin =
        Observer<ResponseStatus<OTPResponse>> { responseStatus ->

            when (responseStatus) {
                is ResponseStatus.Success -> {
                    Toast.makeText(this@OtpActivity, "OTP Sent Successfully", Toast.LENGTH_SHORT)
                        .show()

                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage)
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage)

                }
            }
        }


    override fun onError(message: String?) {
        TODO("Not yet implemented")
    }

    override fun finishOtpScreen() {
        finish()
    }

    override fun onOTPReceived(otp: String?) {
        try {
            dataBinding.editText1.setText("" + otp!![0])
            dataBinding.editText2.setText("" + otp!![1])
            dataBinding.editText3.setText("" + otp!![2])
            dataBinding.editText4.setText("" + otp!![3])
            dataBinding.editText5.setText("" + otp!![4])
            dataBinding.editText6.setText("" + otp!![5])
            clickOnContinue()
        } catch (ex: Exception) {
            Log.e("error", "ex" + ex.message)
            //GlobalFunctions.reportException(TAG, ex);
        }
    }

    override fun onOTPTimeOut() {
        TODO("Not yet implemented")
    }

    private fun autoOTPVerify() {
        val client = SmsRetriever.getClient(this /* context */)
        val task = client.startSmsRetriever()
        task.addOnSuccessListener { aVoid: Void? ->
            // Successfully started retriever, expect broadcast intent
            Log.e("sjj", " success ")
        }
        task.addOnFailureListener { e: java.lang.Exception? -> Log.e("sjj", " error ") }
    }


}