package com.mountcarmelschools.ui.login

import android.content.Context
import android.content.Intent
import android.content.Intent.FLAG_ACTIVITY_NEW_TASK
import android.text.TextUtils
import android.view.View
import android.widget.Toast
import androidx.databinding.ObservableField
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.google.gson.Gson
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseViewModel
import com.mountcarmelschools.di.data.login.LoginResponseFromApi
import com.mountcarmelschools.di.loginData.LoginRequest
import com.mountcarmelschools.di.loginData.SocialLoginRequest
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.AUTH_TOKEN
import com.mountcarmelschools.utlis.EMPLOYEE_CODE
import com.mountcarmelschools.utlis.IS_LOGGED_IN
import com.mountcarmelschools.utlis.IS_PARENT
import com.mountcarmelschools.utlis.IS_STAFF
import com.mountcarmelschools.utlis.MOBILE_NUMBER
import com.mountcarmelschools.utlis.PARENT_EMAIL_ID
import com.mountcarmelschools.utlis.PARENT_IMAGE_PATH
import com.mountcarmelschools.utlis.PARENT_URL
import com.mountcarmelschools.utlis.SECTION_ID
import com.mountcarmelschools.utlis.STAFF_USER_ID
import com.mountcarmelschools.utlis.STANDARD_ID
import com.mountcarmelschools.utlis.STANDARD_NAME
import com.mountcarmelschools.utlis.STANDARD_SECTION_ID
import com.mountcarmelschools.utlis.STUDENT_DATA_FOR_PARENT
import com.mountcarmelschools.utlis.STUDENT_EMAIL_ID
import com.mountcarmelschools.utlis.STUDENT_ID
import com.mountcarmelschools.utlis.STUDENT_ROLL_NO
import com.mountcarmelschools.utlis.SharedPreferenceUtils
import com.mountcarmelschools.utlis.TEACHER_EMAIL_ID
import com.mountcarmelschools.utlis.USER_ID
import com.mountcarmelschools.utlis.USER_NAME
import com.mountcarmelschools.utlis.USER_TYPE
import com.mountcarmelschools.utlis.Utils
import com.mountcarmelschools.utlis.YEAR_SESSION
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class LoginViewModel : BaseViewModel<LoginNavigator>() {

    var progressBar = ObservableField<Boolean>(false)

    var email = ObservableField<String>("")

    var password = ObservableField<String>("")

    /*
    Student loginS
   aaravarora3010@mountcarmeldelhi.com
     father
     google:Arora@2022fa

     namishkalra1802@mountcarmelschool.com
     Namish@2022

     teacher login
     webmaster@mountcarmelschool.com
     bhoopendra
     google:- cash2019

     //
   poojaarora@mountcarmeldelhi.com
     mehra@0202
OR
mehraarora@0202
     */


    var responseLiveData: MutableLiveData<LoginResponseFromApi>? = null


    fun getLogin(loginRequest: LoginRequest, view: View): LiveData<LoginResponseFromApi> {
        responseLiveData = MutableLiveData()

        loginResponse(loginRequest, view)
        return responseLiveData!!
    }

    fun onGogleSignIn(view: View) {

        getNavigator()!!.onSignInClick()
    }


    fun onGoogleSuccess(view: Context, email: String, idToken: String) {
        val loginRequest = SocialLoginRequest(
            email,
            idToken,
            "android"
        )

        socialLoginResponse(loginRequest, view)


    }

    fun onLoginButton(view: View) {

        /*   if (TextUtils.isEmpty(email.get())) {

               Toasty.error(view.context,"Please enter value from 1 - 4").show()
           }

           else {

               val intent = Intent(view.context, DashboardActivity::class.java)
               SharedPreferenceUtils.getInstance(view.context)
                   ?.setStringValue(USER_TYPE, email.get().toString())
               (view.context).startActivity(intent)

           }

   */


        if (Utils.isNetworkAvailable(view.context)) {

            if (checkValidation(view)) {


                val loginRequest = LoginRequest(email.get()!!, password.get()!!, "android")

                getLogin(loginRequest, view)


            }
        } else {


            Toast.makeText(
                view.context,
                view.context.resources.getString(R.string.internet_connection), Toast.LENGTH_SHORT
            ).show()
        }


    }


    private fun checkValidation(view: View): Boolean {

        if (TextUtils.isEmpty(email.get())) {

            Toast.makeText(
                view.context,
                view.context.resources.getString(R.string.please_enter_email),
                Toast.LENGTH_SHORT
            ).show()

            return false
        } else if (!Utils.isEmailValid(email.get())) {

            Toast.makeText(
                view.context,
                view.context.resources.getString(R.string.please_enter_valid_email),
                Toast.LENGTH_SHORT
            ).show()

            return false
        } else if (TextUtils.isEmpty(password.get())) {

            Toast.makeText(
                view.context,
                view.context.resources.getString(R.string.please_enter_password),
                Toast.LENGTH_SHORT
            ).show()

            return false
        }

        return true

    }


    private fun loginResponse(postData: LoginRequest, view: View) {
        progressBar.set(true)

        val responseCall: Call<LoginResponseFromApi> =
            RetrofitClient.apiService.getLoginResponse(postData)
        responseCall.enqueue(object : Callback<LoginResponseFromApi?> {
            override fun onResponse(
                call: Call<LoginResponseFromApi?>,
                response: Response<LoginResponseFromApi?>
            ) {
                if (response.isSuccessful) {

                    if (response.body()?.status!!) {

                        if (response.body()!!.user?.type.toString().toLowerCase().equals("staff") &&
                            response.body()!!.user?.type2.toString() == ""
                        ) {
                            val intent = Intent(view.context, DashboardActivity::class.java)

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(IS_PARENT, false)
                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(IS_STAFF, true)

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(TEACHER_EMAIL_ID, postData.email)

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(IS_LOGGED_IN, true)


                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(PARENT_URL, response.body()!!.path)

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(PARENT_IMAGE_PATH, response.body()!!.user!!.profilePic)

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    MOBILE_NUMBER,
                                    response.body()!!.user?.mobile
                                )
                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    EMPLOYEE_CODE,
                                    response.body()!!.user?.staffId!!.employeeCode
                                )

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    USER_NAME,
                                    response.body()!!.user?.name
                                )


                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(USER_TYPE, "4")


                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    USER_ID,
                                    response.body()!!.user?.staffId?.id
                                )

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    STAFF_USER_ID,
                                    response.body()!!.user?.staffId?.id
                                )

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    AUTH_TOKEN,
                                    "Bearer " + response.body()!!.metaData?.token
                                )

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    YEAR_SESSION,
                                    response.body()!!.metaData?.yearSession
                                )


                            val studentList = Gson().toJson(response.body()?.user!!.students)

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    STUDENT_DATA_FOR_PARENT,
                                    studentList
                                )

                            (view.context).startActivity(intent)
                            getNavigator()?.finishLogin()

                        } else if (response.body()!!.user?.type.toString().toLowerCase()
                                .equals("student")
                        ) {

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(IS_PARENT, false)
                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(IS_STAFF, false)

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(IS_LOGGED_IN, true)


                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(STUDENT_EMAIL_ID, postData.email)


                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    USER_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.id
                                )


                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    STUDENT_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.id
                                )

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    SECTION_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.sectionId?.id
                                )
                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    STUDENT_ROLL_NO,
                                    response.body()!!.user?.students?.get(0)?.studentId?.admissionNo
                                )
                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    STANDARD_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.standardId?.id
                                )
                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    STANDARD_SECTION_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.standardSectionId?.id
                                )

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    STANDARD_NAME,
                                    response.body()!!.user?.students?.get(0)?.studentId?.standardId?.name
                                )



                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    AUTH_TOKEN,
                                    "Bearer " + response.body()!!.metaData?.token
                                )
                            println("user id " + response.body()!!.user?.students?.get(0)?.studentId?.id + "Bearer " + response.body()!!.metaData?.token)


                            //senior check
                            if (response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 11 ||
                                response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 21 ||
                                response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 31
                            ) {

                                val intent = Intent(view.context, DashboardActivity::class.java)
                                SharedPreferenceUtils.getInstance(view.context)
                                    ?.setStringValue(USER_TYPE, "2")
                                (view.context).startActivity(intent)
                                getNavigator()?.finishLogin()

                            } else {

                                val intent = Intent(view.context, DashboardActivity::class.java)
                                SharedPreferenceUtils.getInstance(view.context)
                                    ?.setStringValue(USER_TYPE, "1")
                                (view.context).startActivity(intent)
                                getNavigator()?.finishLogin()

                            }

                        }
                        else {
                            val intent = Intent(view.context, DashboardActivity::class.java)

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(IS_PARENT, true)

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(IS_LOGGED_IN, true)
                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(IS_STAFF, false)


                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(PARENT_URL, response.body()!!.parent_path)


                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(PARENT_EMAIL_ID, response.body()!!.user!!.email)


                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setValue(PARENT_IMAGE_PATH, response.body()!!.user!!.profilePic)



                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    AUTH_TOKEN,
                                    "Bearer " + response.body()!!.metaData?.token
                                )

                            val studentList = Gson().toJson(response.body()?.user!!.students)

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    STUDENT_DATA_FOR_PARENT,
                                    studentList
                                )

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    MOBILE_NUMBER,
                                    response.body()!!.user?.mobile
                                )

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    USER_NAME,
                                    response.body()!!.user?.name
                                )

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    USER_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.id
                                )

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    STUDENT_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.id
                                )

                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    SECTION_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.sectionId?.id
                                )
                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    STUDENT_ROLL_NO,
                                    response.body()!!.user?.students?.get(0)?.studentId?.admissionNo
                                )
                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    STANDARD_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.standardId?.id
                                )
                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    STANDARD_SECTION_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.standardSectionId?.id
                                )
                            SharedPreferenceUtils.getInstance(view.context)
                                ?.setStringValue(
                                    STANDARD_NAME,
                                    response.body()!!.user?.students?.get(0)?.studentId?.standardId?.name
                                )

                            //senior check
                            if (response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 11 ||
                                response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 21 ||
                                response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 31
                            ) {

                                val intent = Intent(view.context, DashboardActivity::class.java)
                                SharedPreferenceUtils.getInstance(view.context)
                                    ?.setStringValue(USER_TYPE, "2")
                                (view.context).startActivity(intent)
                                getNavigator()?.finishLogin()

                            } else {

                                val intent = Intent(view.context, DashboardActivity::class.java)
                                SharedPreferenceUtils.getInstance(view.context)
                                    ?.setStringValue(USER_TYPE, "1")
                                (view.context).startActivity(intent)
                                getNavigator()?.finishLogin()

                            }

                            (view.context).startActivity(intent)
                            getNavigator()?.finishLogin()

                        }

                        Toast.makeText(
                            view.context,
                            "Login Successful",
                            Toast.LENGTH_SHORT
                        ).show()

                    } else {
                        Toast.makeText(
                            view.context,
                            response.body()!!.message.toString(),
                            Toast.LENGTH_SHORT
                        ).show()
                    }

                    responseLiveData?.value = response.body()

                }

                progressBar.set(false)

            }

            override fun onFailure(
                call: Call<LoginResponseFromApi?>,
                t: Throwable
            ) {
                progressBar.set(false)
            }
        })
    }


    private fun socialLoginResponse(postData: SocialLoginRequest, context: Context) {
        progressBar.set(true)

        val responseCall: Call<LoginResponseFromApi> =
            RetrofitClient.apiService.socialLogin(postData)
        responseCall.enqueue(object : Callback<LoginResponseFromApi?> {
            override fun onResponse(
                call: Call<LoginResponseFromApi?>,
                response: Response<LoginResponseFromApi?>
            ) {
                if (response.isSuccessful) {

                    if (response.body()?.status!!) {

                        if (response.body()!!.user?.type.toString().toLowerCase().equals("staff") &&
                            response.body()!!.user?.type2.toString() == ""
                        ) {
                            val intent = Intent(context, DashboardActivity::class.java)

                            intent.flags = FLAG_ACTIVITY_NEW_TASK

                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(IS_PARENT, false)
                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(IS_STAFF, true)

                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(TEACHER_EMAIL_ID, postData.email)

                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(IS_LOGGED_IN, true)


                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(PARENT_URL, response.body()!!.path)

                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(PARENT_IMAGE_PATH, response.body()!!.user!!.profilePic)

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    MOBILE_NUMBER,
                                    response.body()!!.user?.mobile
                                )
                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    EMPLOYEE_CODE,
                                    response.body()!!.user?.staffId!!.employeeCode
                                )

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    USER_NAME,
                                    response.body()!!.user?.name
                                )


                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(USER_TYPE, "4")


                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    USER_ID,
                                    response.body()!!.user?.staffId?.id
                                )

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    STAFF_USER_ID,
                                    response.body()!!.user?.staffId?.id
                                )

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    AUTH_TOKEN,
                                    "Bearer " + response.body()!!.metaData?.token
                                )

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    YEAR_SESSION,
                                    response.body()!!.metaData?.yearSession
                                )


                            val studentList = Gson().toJson(response.body()?.user!!.students)

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    STUDENT_DATA_FOR_PARENT,
                                    studentList
                                )

                            (context).startActivity(intent)
                            getNavigator()?.finishLogin()

                        } else if (response.body()!!.user?.type.toString().toLowerCase()
                                .equals("student")
                        ) {

                            val intent = Intent(context, DashboardActivity::class.java)

                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(IS_PARENT, false)
                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(IS_STAFF, false)

                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(IS_LOGGED_IN, true)


                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(STUDENT_EMAIL_ID, postData.email)


                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    USER_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.id
                                )


                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    STUDENT_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.id
                                )

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    SECTION_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.sectionId?.id
                                )
                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    STUDENT_ROLL_NO,
                                    response.body()!!.user?.students?.get(0)?.studentId?.admissionNo
                                )
                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    STANDARD_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.standardId?.id
                                )
                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    STANDARD_SECTION_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.standardSectionId?.id
                                )

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    STANDARD_NAME,
                                    response.body()!!.user?.students?.get(0)?.studentId?.standardId?.name
                                )

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    AUTH_TOKEN,
                                    "Bearer " + response.body()!!.metaData?.token
                                )
                            println("user id " + response.body()!!.user?.students?.get(0)?.studentId?.id + "Bearer " + response.body()!!.metaData?.token)


                            //senior check
                            if (response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 11 ||
                                response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 21 ||
                                response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 31
                            ) {
                                SharedPreferenceUtils.getInstance(context)
                                    ?.setStringValue(USER_TYPE, "2")
                            } else {
                                SharedPreferenceUtils.getInstance(context)
                                    ?.setStringValue(USER_TYPE, "1")
                            }

                            intent.flags = FLAG_ACTIVITY_NEW_TASK
                            (context).startActivity(intent)
                            getNavigator()?.finishLogin()

                        } else {
                            val intent = Intent(context, DashboardActivity::class.java)
                            intent.flags = FLAG_ACTIVITY_NEW_TASK

                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(IS_PARENT, true)

                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(IS_LOGGED_IN, true)
                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(IS_STAFF, false)


                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(PARENT_URL, response.body()!!.parent_path)


                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(PARENT_EMAIL_ID, response.body()!!.user!!.email)


                            SharedPreferenceUtils.getInstance(context)
                                ?.setValue(PARENT_IMAGE_PATH, response.body()!!.user!!.profilePic)



                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    AUTH_TOKEN,
                                    "Bearer " + response.body()!!.metaData?.token
                                )

                            val studentList = Gson().toJson(response.body()?.user!!.students)

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    STUDENT_DATA_FOR_PARENT,
                                    studentList
                                )

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    MOBILE_NUMBER,
                                    response.body()!!.user?.mobile
                                )

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    USER_NAME,
                                    response.body()!!.user?.name
                                )

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    USER_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.id
                                )

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    STUDENT_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.id
                                )

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    SECTION_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.sectionId?.id
                                )
                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    STUDENT_ROLL_NO,
                                    response.body()!!.user?.students?.get(0)?.studentId?.admissionNo
                                )
                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    STANDARD_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.standardId?.id
                                )
                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    STANDARD_SECTION_ID,
                                    response.body()!!.user?.students?.get(0)?.studentId?.standardSectionId?.id
                                )

                            SharedPreferenceUtils.getInstance(context)
                                ?.setStringValue(
                                    STANDARD_NAME,
                                    response.body()!!.user?.students?.get(0)?.studentId?.standardId?.name
                                )

                            //senior check
                            if (response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 11 ||
                                response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 21 ||
                                response.body()!!.user?.students?.get(0)?.studentId?.year_branch == 31
                            ) {

                                SharedPreferenceUtils.getInstance(context)
                                    ?.setStringValue(USER_TYPE, "2")

                            } else {

                                SharedPreferenceUtils.getInstance(context)
                                    ?.setStringValue(USER_TYPE, "1")

                            }

                            (context).startActivity(intent)
                            getNavigator()?.finishLogin()

                        }

                        Toast.makeText(
                            context,
                            "Login Successful",
                            Toast.LENGTH_SHORT
                        ).show()

                    } else {
                        Toast.makeText(
                            context,
                            response.body()!!.message.toString(),
                            Toast.LENGTH_SHORT
                        ).show()
                    }

                    responseLiveData?.value = response.body()

                }

                progressBar.set(false)

            }

            override fun onFailure(
                call: Call<LoginResponseFromApi?>,
                t: Throwable
            ) {
                Toast.makeText(
                    context, t.localizedMessage,
                    Toast.LENGTH_SHORT
                ).show()
                progressBar.set(false)
            }
        })
    }
}