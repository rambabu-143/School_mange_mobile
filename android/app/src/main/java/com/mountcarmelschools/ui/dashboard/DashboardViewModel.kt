package com.mountcarmelschools.ui.dashboard

import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.TextView
import android.widget.Toast
import androidx.databinding.ObservableField
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.google.gson.Gson
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseViewModel
import com.mountcarmelschools.di.data.ParentImageUploadResponse
import com.mountcarmelschools.di.data.emailgroup.EmailGroupResponse
import com.mountcarmelschools.di.data.login.LoginResponseFromApi
import com.mountcarmelschools.di.data.setting.SwitchStudentRequest
import com.mountcarmelschools.di.data.staffProfile.StaffProfileDetail
import com.mountcarmelschools.di.data.studentDetail.SingleStudentDetail
import com.mountcarmelschools.di.data.updateToken.TokenPostData
import com.mountcarmelschools.di.data.updateToken.UpdateTokenResponse
import com.mountcarmelschools.di.loginData.LoginResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.ui.login.LoginActivity
import com.mountcarmelschools.ui.notification.NotificationFragment
import com.mountcarmelschools.ui.setting.SettingFragment
import com.mountcarmelschools.utlis.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File


class DashboardViewModel() : BaseViewModel<DashboardNavigator>() {
    private val TAG = "DashboardViewModel"
    var progressBar = ObservableField<Boolean>(false)
    var mobileNumber = ObservableField<String>()
    var password = ObservableField<String>()

    var responseLiveData: MutableLiveData<LoginResponse>? = null

    private var repository = DashboardRepository(this)

    private var _screenLockManager: ScreenLockManager? = null

    val screenLockManager: ScreenLockManager? get() = _screenLockManager

    fun setScreenLockManager(screenLockManager: ScreenLockManager) {
        _screenLockManager = screenLockManager
    }

    fun getLogin(): LiveData<LoginResponse> {
        if (responseLiveData == null) {
            responseLiveData = MutableLiveData()
        }
        return responseLiveData!!
    }

    fun onNotification(view: View) {
        Utils.replaceFragment(
            view.context,
            R.id.fl_dashboardContainer,
            NotificationFragment(),
            "DashboardActivity"
        )


    }

    fun onSetting(view: View) {
        Utils.replaceFragment(
            view.context,
            R.id.fl_dashboardContainer,
            SettingFragment(),
            "SettingFragment"
        )
    }


    fun onLogout(view: View) {
        getNavigator()?.logoutDialog(view)
    }

    private fun openAlertDialog(view: View) {
        val dialogBuilder = AlertDialog.Builder(view.context)
        val inflater =
            (view.context).getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val dialogView: View = inflater.inflate(R.layout.logout_dialog, null)
        dialogBuilder.setView(dialogView)

        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()

        val cancel = dialogView.findViewById(R.id.btn_cancel) as TextView
        val logout = dialogView.findViewById(R.id.btn_continue) as TextView

        cancel.setOnClickListener {
            dialog.dismiss()
        }

        logout.setOnClickListener {
            dialog.dismiss()
            val intent = Intent(view.context, LoginActivity::class.java)
            intent.flags =
                Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            SharedPreferenceUtils.getInstance(view.context)?.clear()
            (view.context).startActivity(intent)

        }

    }


    fun onLoginButton(view: View) {
        progressBar.set(true)
//        if (checkValidation(view)) {
//            val loginRequest = LoginRequest(mobileNumber.get()!!.toInt(), password.get()!!)
//            repository.getLoginCall(loginRequest)
//        }
        progressBar.set(false)
    }

    /*
      private fun checkValidation(view: View): Boolean {
          if (TextUtils.isEmpty(mobileNumber.get())) {
              Toast.makeText(
                  view.context,
                  view.context.resources.getString(R.string.enter_mobile_number),
                  Toast.LENGTH_LONG
              ).show()
              return false
          } else if (!Utils.isMobileZero(mobileNumber.get())) {
              Toast.makeText(
                  view.context,
                  view.context.resources.getString(R.string.enter_mobile_number),
                  Toast.LENGTH_LONG
              ).show()
              return false
          } else if (TextUtils.isEmpty(password.get())) {
              Toast.makeText(
                  view.context,
                  view.context.resources.getString(R.string.please_enter_password),
                  Toast.LENGTH_LONG
              ).show()
              return false
          } else if (password.get()!!.length < 4) {
              Toast.makeText(view.context, "", Toast.LENGTH_LONG).show()
              return false
          }
          return true
      }*/


    /*
    Get Staff Detail
     */


    var staffLiveData: MutableLiveData<StaffProfileDetail>? = null

    fun getStaffDetail(authToken: String, sectionId: String): LiveData<StaffProfileDetail> {
        staffLiveData = MutableLiveData()
        getStaffDetailResponse(authToken, sectionId)
        return staffLiveData!!
    }

    private fun getStaffDetailResponse(authToken: String, sectionId: String) {

        val responseCall: Call<StaffProfileDetail?>? =
            RetrofitClient.apiService.getStaffDetail(authToken, sectionId)
        responseCall?.enqueue(object : Callback<StaffProfileDetail?> {
            override fun onResponse(
                call: Call<StaffProfileDetail?>,
                response: Response<StaffProfileDetail?>
            ) {
                if (response.body() != null && response.body()?.status!!) {
                    staffLiveData?.value = response.body()
                } else if (response.body() != null && response.body()?.token_expired != null &&
                    response.body()?.token_expired!!
                ) {
                    getNavigator()?.onError(response.body()?.message!!)
                } else {
                    Log.d(TAG, " staff onResponse: " + response.body()?.message!!)
                    getNavigator()?.onError(response.body()?.message!!)
                }
            }

            override fun onFailure(
                call: Call<StaffProfileDetail?>,
                t: Throwable
            ) {
                Log.d(TAG, "onResponse: " + t.message!!)
                getNavigator()?.onError(t.message!!)
            }
        })
    }

    //--------------- End Staff Detail -------------------------//


    /*
    Get Student Detail
     */


    var studentDetailLiveList: MutableLiveData<SingleStudentDetail>? = null

    fun getStudentDetail(authToken: String, sectionId: String): LiveData<SingleStudentDetail> {
        if (studentDetailLiveList == null) {
            studentDetailLiveList = MutableLiveData()
        }

        getStudentDetailResponse(authToken, sectionId)
        return studentDetailLiveList!!
    }

    private fun getStudentDetailResponse(authToken: String, sectionId: String) {

        val responseCall: Call<SingleStudentDetail> =
            RetrofitClient.apiService.getStudentDetail(authToken, sectionId)

        responseCall.enqueue(object : Callback<SingleStudentDetail?> {
            override fun onResponse(
                call: Call<SingleStudentDetail?>,
                response: Response<SingleStudentDetail?>
            ) {
                if (response.body() != null && response.body()?.status!!) {
                    studentDetailLiveList?.value = response.body()
                } else if (response.body() != null && response.body()?.token_expired != null &&
                    response.body()?.token_expired!!
                ) {
                    getNavigator()?.onError(response.body()?.message!!)
                } else {
                    Log.d(TAG, " student onResponse: " + response.body()?.message!!)
                    getNavigator()?.onError(response.body()?.message!!)
                }

            }

            override fun onFailure(
                call: Call<SingleStudentDetail?>,
                t: Throwable
            ) {
                getNavigator()?.onError(t.localizedMessage!!)
                Log.d(TAG, "onResponse: " + t.message!!)
            }
        })
    }

    //--------------- End Staff Detail -------------------------//

    /*
    upload image
     */

    var uploadImageResponse: MutableLiveData<ParentImageUploadResponse>? = null

    fun uploadProfile(
        authToken: String,
        imagePath: String,
        file: File
    ): LiveData<ParentImageUploadResponse> {
        uploadImageResponse = MutableLiveData()
        uploadProfileResponse(authToken, imagePath, file)
        return uploadImageResponse!!
    }

    private fun uploadProfileResponse(
        authToken: String,
        type: String,
        file: File


    ) {
        val filePart: MultipartBody.Part?

        filePart = MultipartBody.Part.createFormData(
            "attachment",
            file.name,
            RequestBody.create(type.toMediaTypeOrNull(), file)
        )

        val responseCall: Call<ParentImageUploadResponse?>? =
            RetrofitClient.apiService.uploadProfileImage(
                authToken, filePart!!
            )

        responseCall?.enqueue(object : Callback<ParentImageUploadResponse?> {
            override fun onResponse(
                call: Call<ParentImageUploadResponse?>,
                response: Response<ParentImageUploadResponse?>
            ) {
                if (response.body() != null && response.body()?.status!!) {
                    uploadImageResponse?.value = response.body()
                } else {
                    Log.d(TAG, " upload prof onResponse: " + response.body()?.message!!)
                    getNavigator()?.onError(response.body()?.message!!)
                }


            }

            override fun onFailure(
                call: Call<ParentImageUploadResponse?>,
                t: Throwable
            ) {

                val getSettingResponse = ParentImageUploadResponse(false, t.localizedMessage, null)

                uploadImageResponse?.value = getSettingResponse
                getNavigator()?.onError(t.localizedMessage!!)
                Log.d(TAG, "onFailure: " + t.message!!)
            }
        })
    }

    /*
   update student token
    */
    var updateStudentToken: MutableLiveData<UpdateTokenResponse>? = null

    fun updateToken(
        authToken: String,
        id: String,
        data: TokenPostData
    ): LiveData<UpdateTokenResponse> {
        updateStudentToken = MutableLiveData()
        updateTokenResponse(authToken, id, data)
        return updateStudentToken!!
    }

    private fun updateTokenResponse(
        authToken: String,
        id: String,
        tokenPostData: TokenPostData

    ) {
        val responseCall: Call<UpdateTokenResponse?>? =
            RetrofitClient.apiService.updateStudentToken(authToken, tokenPostData, id)

        responseCall?.enqueue(object : Callback<UpdateTokenResponse?> {
            override fun onResponse(
                call: Call<UpdateTokenResponse?>,
                response: Response<UpdateTokenResponse?>
            ) {
                if (response.body() != null && response.body()?.status!!) {
                    updateStudentToken?.value = response.body()

                } else {
                    Log.d(TAG, "update token onResponse: " + response.body()?.message!!)
                    getNavigator()?.onError(response.body()?.message!!)
                }

            }

            override fun onFailure(
                call: Call<UpdateTokenResponse?>,
                t: Throwable
            ) {
                getNavigator()?.onError(t.localizedMessage!!)
                Log.d(TAG, "onFailure: " + t.localizedMessage!!)
            }
        })
    }


    /*
 update  token  for staff
  */
    var updateStaffToken: MutableLiveData<UpdateTokenResponse>? = null

    fun updateStaffToken(
        authToken: String,
        id: String,
        data: TokenPostData
    ): LiveData<UpdateTokenResponse> {
        updateStaffToken = MutableLiveData()
        updateStaffTokenResponse(authToken, id, data)
        return updateStaffToken!!
    }

    private fun updateStaffTokenResponse(
        authToken: String,
        id: String,
        tokenPostData: TokenPostData

    ) {
        val responseCall: Call<UpdateTokenResponse?>? =
            RetrofitClient.apiService.updateStaffToken(authToken, tokenPostData, id)

        responseCall?.enqueue(object : Callback<UpdateTokenResponse?> {
            override fun onResponse(
                call: Call<UpdateTokenResponse?>,
                response: Response<UpdateTokenResponse?>
            ) {
                if (response.body() != null && response.body()?.status!!) {
                    updateStaffToken?.value = response.body()

                } else {
                    Log.d(TAG, "staff token onResponse: " + response.body()?.message!!)
                    getNavigator()?.onError(response.body()?.message!!)
                }


            }

            override fun onFailure(
                call: Call<UpdateTokenResponse?>,
                t: Throwable
            ) {
                getNavigator()?.onError(t.localizedMessage!!)
                Log.d(TAG, t.localizedMessage!!)
            }
        })
    }


    /*
  Email Group for staff
  */
    var emailGroup: MutableLiveData<EmailGroupResponse>? = null

    fun getEmailGroup(
        authToken: String
    ): LiveData<EmailGroupResponse> {
        emailGroup = MutableLiveData()
        getEmailGroupResponse(authToken)
        return emailGroup!!
    }

    private fun getEmailGroupResponse(
        authToken: String

    ) {
        val responseCall: Call<EmailGroupResponse> =
            RetrofitClient.apiService.getEmailGroup(authToken)

        responseCall.enqueue(object : Callback<EmailGroupResponse?> {
            override fun onResponse(
                call: Call<EmailGroupResponse?>,
                response: Response<EmailGroupResponse?>
            ) {
                if (response.body() != null && response.body()?.status!!) {
                    emailGroup?.value = response.body()

                } else {
                    Log.d(TAG, "email onResponse: " + response.body()?.status!!)
                    getNavigator()?.onError("Something Went Wrong!")
                }


            }

            override fun onFailure(
                call: Call<EmailGroupResponse?>,
                t: Throwable
            ) {
                getNavigator()?.onError(t.localizedMessage!!)
                Log.d(TAG, t.localizedMessage!!)
            }
        })
    }

    var mSwitchStudentResponse: MutableLiveData<LoginResponseFromApi>? = null
    fun switchUser(
        authToken: String,
        otpPost: SwitchStudentRequest
    ): LiveData<LoginResponseFromApi> {
        mSwitchStudentResponse = MutableLiveData()
        switchUserResponse(authToken, otpPost)
        return mSwitchStudentResponse!!
    }

    private fun switchUserResponse(
        authToken: String,
        switchStudentPostData: SwitchStudentRequest
    ) {
        progressBar.set(true)
        val responseCall: Call<LoginResponseFromApi> =
            RetrofitClient.apiService.switchStudent(authToken, switchStudentPostData)
        responseCall.enqueue(object : Callback<LoginResponseFromApi> {

            override fun onResponse(
                call: Call<LoginResponseFromApi>,
                response: Response<LoginResponseFromApi>
            ) {
                progressBar.set(false)
                if (response.body()?.status!!) {

                    SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                        ?.setValue(IS_PARENT, true)


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



                    if (response.body()!!.user!!.students!!.isNotEmpty()) {

                        for (selectStudent in response.body()!!.user!!.students!!) {

                            if (switchStudentPostData.admission_no == selectStudent!!.studentId!!.admissionNo) {

                                SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                                    ?.setStringValue(
                                        USER_ID,
                                        selectStudent.studentId?.id
                                    )

                                SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                                    ?.setStringValue(
                                        STUDENT_ID,
                                        selectStudent.studentId?.id
                                    )

                                SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                                    ?.setStringValue(
                                        SECTION_ID,
                                        selectStudent.studentId?.sectionId?.id
                                    )
                                SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                                    ?.setStringValue(
                                        STUDENT_ROLL_NO,
                                        selectStudent.studentId?.admissionNo
                                    )
                                SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                                    ?.setStringValue(
                                        STANDARD_ID,
                                        selectStudent.studentId?.standardId?.id
                                    )
                                SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                                    ?.setStringValue(
                                        STANDARD_SECTION_ID,
                                        selectStudent.studentId?.standardSectionId?.id
                                    )

                                SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                                    ?.setStringValue(
                                        STANDARD_NAME,
                                        selectStudent.studentId?.standardId?.name
                                    )

                                //senior check
                                if (selectStudent.studentId?.year_branch == 11 ||
                                    selectStudent.studentId?.year_branch == 21 ||
                                    selectStudent.studentId?.year_branch == 31
                                ) {

                                    SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                                        ?.setStringValue(USER_TYPE, "2")

                                } else {

                                    SharedPreferenceUtils.getInstance(getNavigator()?.getContext()!!)
                                        ?.setStringValue(USER_TYPE, "1")

                                }


                            }

                        }

                    }


                    Toast.makeText(
                        getNavigator()?.getContext()!!, "Switch Successful", Toast.LENGTH_SHORT
                    ).show()


                } else {
                    Toast.makeText(

                        getNavigator()?.getContext()!!,
                        response.body()!!.message.toString(), Toast.LENGTH_SHORT
                    ).show()
                }

                mSwitchStudentResponse?.value = response.body()

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