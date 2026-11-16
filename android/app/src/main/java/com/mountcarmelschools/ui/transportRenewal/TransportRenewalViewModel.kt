package com.mountcarmelschools.ui.transportRenewal

import android.content.Context
import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.mountcarmelschools.R
import com.mountcarmelschools.base.McopBaseViewModel
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.staffProfile.GetStudentDetailFromAdmissioNO
import com.mountcarmelschools.di.data.streamSelection.StreamSelectionPostData
import com.mountcarmelschools.di.data.transport.TransportRenewalPostData
import com.mountcarmelschools.di.data.transport.TransportRenewalResponse
import com.mountcarmelschools.di.networking.NoConnectivityException
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.di.networking.RetrofitClient
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class TransportRenewalViewModel : McopBaseViewModel() {

    /*

 CHeck admission No
  */

    val liveAdmissionNumberConfirmation =
        MutableLiveData<ResponseStatus<GetStudentDetailFromAdmissioNO>>()

    fun callCheckAdmissionNumber(
        context: Context, authToken: String, admissionNo: String
    ) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = TransportRenewalRepository().checkAdmissionNumber(
                    authToken = authToken, admission = admissionNo,
                )
                withContext(Dispatchers.Main) {
                    onAdmissionNumberResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }


    private fun onAdmissionNumberResponse(
        context: Context, response: Response<GetStudentDetailFromAdmissioNO>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true) liveAdmissionNumberConfirmation.postValue(
                    ResponseStatus.Success(
                        it
                    )
                )
                else liveAdmissionNumberConfirmation.postValue(
                    ResponseStatus.Error(
                        responseMessage = it.message
                            ?: context.getString(R.string.unable_to_fetch_information)
                    )
                )

            } ?: liveAdmissionNumberConfirmation.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveAdmissionNumberConfirmation.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }


    /*

--------------------------------------------- Update Stream Selection DATA-------------------------------------------------------------
  */

    val liveDataUpdateRenewalData = MutableLiveData<ResponseStatus<CommonResponse>>()


    fun callUpdateTransportRenewal(
        context: Context, authToken: String, data: TransportRenewalPostData
    ) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = TransportRenewalRepository().updateRenewalForm(
                    authToken = authToken, data = data
                )
                withContext(Dispatchers.Main) {
                    onUpdateTransportRenewalResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun onUpdateTransportRenewalResponse(
        context: Context, response: Response<CommonResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true) liveDataUpdateRenewalData.postValue(
                    ResponseStatus.Success(
                        it
                    )
                )
                else liveDataUpdateRenewalData.postValue(
                    ResponseStatus.Error(
                        responseMessage = it.message
                            ?: context.getString(R.string.unable_to_fetch_information)
                    )
                )

            } ?: liveDataUpdateRenewalData.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataUpdateRenewalData.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }




    /*

--------------------------------------------- GET TRANSPORT RENEWAL-------------------------------------------------------------
*/

    val liveDataGetTransportRenewal = MutableLiveData<ResponseStatus<TransportRenewalResponse>>()


    fun callTransportRenewal(
        context: Context, authToken: String, id: String
    ) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = TransportRenewalRepository().getTransportRenewal(
                    authToken = authToken, id = id
                )
                withContext(Dispatchers.Main) {
                    onGetTransportRenewalResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun onGetTransportRenewalResponse(
        context: Context, response: Response<TransportRenewalResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true) liveDataGetTransportRenewal.postValue(
                    ResponseStatus.Success(
                        it
                    )
                )
                else liveDataGetTransportRenewal.postValue(
                    ResponseStatus.Error(
                        responseMessage = it.message
                            ?: context.getString(R.string.unable_to_fetch_information)
                    )
                )

            } ?: liveDataGetTransportRenewal.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataGetTransportRenewal.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }

}