package com.mountcarmelschools.ui.disciplinary.forstaff


import android.content.Context
import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.mountcarmelschools.R
import com.mountcarmelschools.base.McopBaseViewModel
import com.mountcarmelschools.di.data.CheckCurrentTermResponse
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.classList.ClassListDropDownResponse
import com.mountcarmelschools.di.data.disciplinaryCard.DisciplinaryPostDataItem
import com.mountcarmelschools.di.data.disciplinaryCard.GetReasonListResponse
import com.mountcarmelschools.di.data.scann.ScanAPiResponse
import com.mountcarmelschools.di.data.scann.ScanPostData
import com.mountcarmelschools.di.data.staff.wiseStudentList.WiseListFromClassResponse
import com.mountcarmelschools.di.networking.NoConnectivityException
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.di.networking.RetrofitClient
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class DisciplinaryForStaffViewModel : McopBaseViewModel() {

    /*
    GET QR Code Response
     */

    val liveDataScanQrCode = MutableLiveData<ResponseStatus<ScanAPiResponse>>()

    fun callScanQrCode(context: Context, authToken: String, data: ScanPostData) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = DisciplinaryForStaffRepository().getDisciplinaryData(
                    authToken = authToken, data = data
                )
                withContext(Dispatchers.Main) {
                    onCallScanQrCodeResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun onCallScanQrCodeResponse(
        context: Context,
        response: Response<ScanAPiResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveDataScanQrCode.postValue(ResponseStatus.Success(it))
                else
                    liveDataScanQrCode.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveDataScanQrCode.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataScanQrCode.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }


    /*
 Provide disciplinary
  */

    val liveDataProvideDisciplinary = MutableLiveData<ResponseStatus<CommonResponse>>()

    fun callProvideDisciplinary(context: Context, authToken: String, data: ArrayList<DisciplinaryPostDataItem>) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = DisciplinaryForStaffRepository().provideDisciplinaryData(
                    authToken = authToken, data = data
                )
                withContext(Dispatchers.Main) {
                    callProvideDisciplinaryResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun callProvideDisciplinaryResponse(
        context: Context,
        response: Response<CommonResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveDataProvideDisciplinary.postValue(ResponseStatus.Success(it))
                else
                    liveDataProvideDisciplinary.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveDataProvideDisciplinary.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataProvideDisciplinary.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }



    val liveDataReasonList = MutableLiveData<ResponseStatus<GetReasonListResponse>>()

    fun callGetReasonList(context: Context, authToken: String, data: String) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = DisciplinaryForStaffRepository().getReasonList(
                    authToken = authToken, data = data
                )
                withContext(Dispatchers.Main) {
                    callGetReasonListResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun callGetReasonListResponse(
        context: Context,
        response: Response<GetReasonListResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveDataReasonList.postValue(ResponseStatus.Success(it))
                else
                    liveDataReasonList.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveDataReasonList.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataReasonList.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }


    var currentTermResponse: MutableLiveData<CheckCurrentTermResponse>? = null

    fun getCurrentTermResponse(
        authToken: String,
        term: String
    ): LiveData<CheckCurrentTermResponse> {
        currentTermResponse = MutableLiveData()

        currentTermResponse(authToken, term)
        return currentTermResponse!!
    }

    private fun currentTermResponse(authToken: String, term: String) {

        val responseCall: Call<CheckCurrentTermResponse> =
            RetrofitClient.apiService.checkCurrentTerm(authToken, term)

        responseCall.enqueue(object : Callback<CheckCurrentTermResponse> {
            override fun onResponse(
                call: Call<CheckCurrentTermResponse>,
                response: Response<CheckCurrentTermResponse>
            ) {

                currentTermResponse?.value = response.body()

            }

            override fun onFailure(
                call: Call<CheckCurrentTermResponse>,
                t: Throwable
            ) {
            }
        })
    }


    //------------------------GET CLASS LIST DROPDOWN RESPONSE--------------------//

    var responseClassListLiveData: MutableLiveData<ClassListDropDownResponse>? = null

    fun getClassListForDropDown(authToken: String): LiveData<ClassListDropDownResponse> {
        responseClassListLiveData = MutableLiveData()

        getClassListForDropDownResponse(authToken)
        return responseClassListLiveData!!
    }

    private fun getClassListForDropDownResponse(authToken: String) {

        val responseCall: Call<ClassListDropDownResponse?>? =
            RetrofitClient.apiService.getClassListDropDown(authToken)

        responseCall?.enqueue(object : Callback<ClassListDropDownResponse?> {
            override fun onResponse(
                call: Call<ClassListDropDownResponse?>,
                response: Response<ClassListDropDownResponse?>
            ) {

                responseClassListLiveData?.value = response.body()

            }

            override fun onFailure(
                call: Call<ClassListDropDownResponse?>,
                t: Throwable
            ) {

                Log.e("error", t.localizedMessage)
            }
        })
    }


    /*
Get Student Wise
*/
    var studentWiseList: MutableLiveData<WiseListFromClassResponse>? = null

    fun getWiseStudentList(
        authToken: String,
        id: String
    ): LiveData<WiseListFromClassResponse> {
            studentWiseList = MutableLiveData()

        getWiseStudentListResponse(authToken, id)
        return studentWiseList!!
    }

    private fun getWiseStudentListResponse(
        authToken: String,
        standardID: String
    ) {

        val responseCall: Call<WiseListFromClassResponse?>? =
            RetrofitClient.apiService.getWiseStudentList(authToken, standardID)

        responseCall?.enqueue(object : Callback<WiseListFromClassResponse?> {
            override fun onResponse(
                call: Call<WiseListFromClassResponse?>,
                response: Response<WiseListFromClassResponse?>
            ) {
                if (response.isSuccessful) {

                    studentWiseList?.value = response.body()

                }

            }

            override fun onFailure(
                call: Call<WiseListFromClassResponse?>,
                t: Throwable
            ) {
            }
        })
    }
}