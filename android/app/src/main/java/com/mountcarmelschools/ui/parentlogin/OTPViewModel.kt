package com.mountcarmelschools.ui.parentlogin

import android.content.Context
import android.content.Intent
import android.os.CountDownTimer
import android.text.Spanned
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.databinding.ObservableField
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.google.gson.Gson
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseViewModel
import com.mountcarmelschools.di.data.login.LoginResponseFromApi
import com.mountcarmelschools.di.data.parentlogindata.OTPPost
import com.mountcarmelschools.di.data.parentlogindata.OTPResponse
import com.mountcarmelschools.di.data.parentlogindata.OtpRequestData
import com.mountcarmelschools.di.networking.NoConnectivityException
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.ui.parentlogin.repo.ParentLoginRepository
import com.mountcarmelschools.utlis.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class OTPViewModel() : BaseViewModel<OtpNavigator>() {
    private val TAG = "OtpViewModel"
    val text = ObservableField<Spanned>()
    private val mutableLiveData: MutableLiveData<Response<ResponseBody>>? = null
    private val resendMutableLiveData: MutableLiveData<Response<ResponseBody>>? = null

    val oCount = ObservableField<String>()
    val progressCount = ObservableField<Int>()
    val timerVisible = ObservableField<Boolean>()
    val progressBar = ObservableField(false)
    private var countDownTimer: CountDownTimer? = null
    private val mCount: String? = null
    private var needToShowTimer = true

    fun onResendClick(view: View) {
        if (needToShowTimer) {
            timerVisible.set(true)
            getNavigator()?.clickOnResend(view)
            needToShowTimer = false
            if (countDownTimer != null) {
                countDownTimer!!.cancel()
            }
            countDownTimer = object : CountDownTimer(60000, 1000) {
                // adjust the milli seconds here
                override fun onTick(millisUntilFinished: Long) {
                    updateCount("00:" + millisUntilFinished / 1000)
                    progressCount.set((millisUntilFinished / 1000).toInt())
                }

                override fun onFinish() {
                    timerVisible.set(false)
                    needToShowTimer = true
                }
            }.start()
        }
    }

    fun updateCount(time: String?) {
        oCount.set(time)
    }

    fun continueClick() {
        getNavigator()!!.clickOnContinue()
    }

    /*

  Parent Login API
   */

    val liveDataParentLoginApi = MutableLiveData<ResponseStatus<OTPResponse>>()

    fun getParentLogin(context: Context, data: OtpRequestData) {

        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {

                val response = ParentLoginRepository().getParentLoginResponse(
                    data
                )
                withContext(Dispatchers.Main) {
                    onGetParentLoginResponse(context, response)
                }
            } catch (e: Exception) {

                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun onGetParentLoginResponse(
        context: Context, response: Response<OTPResponse>
    ) {
        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true) {
                    SharedPreferenceUtils.getInstance(context)?.setStringValue(
                        PARENT_MOBILE_NO, response.body()!!.data?.mobile
                    )

                    liveDataParentLoginApi.postValue(ResponseStatus.Success(it))
                } else {
                    liveDataParentLoginApi.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )
                }

            } ?: liveDataParentLoginApi.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataParentLoginApi.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }




    var otpResponse: MutableLiveData<LoginResponseFromApi>? = null
    fun verifyOtp(otpPost: OTPPost): LiveData<LoginResponseFromApi> {
        otpResponse = MutableLiveData()
        getVerified(otpPost)
        return otpResponse!!
    }

    private fun getVerified(otpPost: OTPPost) {
        progressBar.set(true)
        val responseCall: Call<LoginResponseFromApi> = RetrofitClient.apiService.parentOtpVerify(otpPost)
        responseCall.enqueue(object : Callback<LoginResponseFromApi> {

            override fun onResponse(call: Call<LoginResponseFromApi>, response: Response<LoginResponseFromApi>) {
                progressBar.set(false)
                if (response.body()?.status!!) {

                    if (response.body()!!.user?.type.toString().toLowerCase().equals("staff")) {

                        Log.e("", "staff")
                    } else if (response.body()!!.user?.type.toString().toLowerCase()
                            .equals("student")
                    ) {
                        Log.e("", "student")
                    } else {
                        val intent: Intent

                        print("user type " + response.body()!!.user?.type.toString());
                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setValue(IS_PARENT, true)

                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setValue(IS_LOGGED_IN, true)

                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setValue(IS_STAFF, false)


                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setValue(PARENT_URL, response.body()!!.parent_path)


                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setValue(PARENT_IMAGE_PATH, response.body()!!.user!!.profilePic)

                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setValue(PARENT_EMAIL_ID, response.body()!!.user!!.email)


                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setStringValue(
                                AUTH_TOKEN,
                                "Bearer " + response.body()!!.metaData?.token
                            )


                        val studentList = Gson().toJson(response.body()?.user!!.students)

                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setStringValue(
                                STUDENT_DATA_FOR_PARENT,
                                studentList
                            )

                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setStringValue(
                                MOBILE_NUMBER,
                                response.body()!!.user?.mobile
                            )

                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setStringValue(
                                USER_NAME,
                                response.body()!!.user?.name
                            )

                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                                ?.setStringValue(
                                        USER_ID,
                                        response.body()!!.user?.students?.get(0)?.studentId?.id
                                )

                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                                ?.setStringValue(
                                        STUDENT_ID,
                                        response.body()!!.user?.students?.get(0)?.studentId?.id
                                )

                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setStringValue(
                                SECTION_ID,
                                response.body()!!.user?.students?.get(0)?.studentId?.sectionId?.id
                            )
                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setStringValue(
                                STUDENT_ROLL_NO,
                                response.body()!!.user?.students?.get(0)?.studentId?.admissionNo
                            )
                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setStringValue(
                                STANDARD_ID,
                                response.body()!!.user?.students?.get(0)?.studentId?.standardId?.id
                            )
                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setStringValue(
                                STANDARD_SECTION_ID,
                                response.body()!!.user?.students?.get(0)?.studentId?.standardSectionId?.id
                            )

                        SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                            ?.setStringValue(
                                STANDARD_NAME,
                                response.body()!!.user?.students?.get(0)?.studentId?.standardId?.name
                            )

                        //senior check
                        if (response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 11 ||
                            response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 21 ||
                            response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 31
                        ) {
                            SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                                ?.setStringValue(USER_TYPE, "2")

                        } else {
                            SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                                ?.setStringValue(USER_TYPE, "1")
                        }

                        intent = Intent(
                            getNavigator()?.getContext()!!,
                            DashboardActivity::class.java
                        )
                        (getNavigator()?.getContext()!!).startActivity(intent)
                        getNavigator()?.finishOtpScreen()

                    }

                    Toast.makeText(
                        getNavigator()?.getContext()!!, "Login Successful", Toast.LENGTH_SHORT
                    ).show()


                } else {
                    Toast.makeText(

                        getNavigator()?.getContext()!!,
                        response.body()!!.message.toString(), Toast.LENGTH_SHORT
                    ).show()
                }

                otpResponse?.value = response.body()

            }

            override fun onFailure(call: Call<LoginResponseFromApi>, t: Throwable) {
                Toast.makeText(
                    getNavigator()?.getContext()!!,
                    t.localizedMessage, Toast.LENGTH_SHORT
                ).show()
                Log.d(TAG, "onFailure: " + t.localizedMessage)
                progressBar.set(false)
            }
        })

    }

}