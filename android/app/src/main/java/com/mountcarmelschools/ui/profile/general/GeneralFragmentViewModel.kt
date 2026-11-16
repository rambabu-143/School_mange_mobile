package com.mountcarmelschools.ui.profile.general

import android.content.Context
import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseViewModel
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.motherTongue.MotherTongueResponse
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessResponse
import com.mountcarmelschools.di.data.studentprofile.*
import com.mountcarmelschools.di.networking.NoConnectivityException
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.ui.parentlogin.ParentNavigator
import com.mountcarmelschools.ui.selfAwareness.SelfAwarenessRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Response

class GeneralFragmentViewModel : BaseViewModel<ParentNavigator>()
{
    /*

    GET Mother Tongue DATA
     */

    val liveDataGetMotherTongue = MutableLiveData<ResponseStatus<MotherTongueResponse>>()

    fun callMotherTongueResponse(context: Context, authToken: String) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = GeneralRepository().getMotherTongue(
                    authToken = authToken
                )
                withContext(Dispatchers.Main) {
                    callMotherTongueResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun callMotherTongueResponse(
        context: Context,
        response: Response<MotherTongueResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveDataGetMotherTongue.postValue(ResponseStatus.Success(it))
                else
                    liveDataGetMotherTongue.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveDataGetMotherTongue.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataGetMotherTongue.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }


    /*

Update General Information  DATA
 */

    val liveDataUpdateProfile = MutableLiveData<ResponseStatus<CommonResponse>>()

    fun updateProfile(context: Context, authToken: String, id:String, params: GeneralPostData) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = GeneralRepository().updateProfile(
                    authToken = authToken, id = id ,params =params
                )
                withContext(Dispatchers.Main) {
                    callUpdateProfile(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun callUpdateProfile(
        context: Context,
        response: Response<CommonResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveDataUpdateProfile.postValue(ResponseStatus.Success(it))
                else
                    liveDataUpdateProfile.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveDataUpdateProfile.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataUpdateProfile.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }


    /*

Update Residential Information  DATA
 */

    val liveDataUpdateResidentialProfile = MutableLiveData<ResponseStatus<CommonResponse>>()

    fun updateResidentailProfile(context: Context, authToken: String, id:String, params: ResidentialPostDataUpdated) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = GeneralRepository().updateResidentialProfile(
                    authToken = authToken, id = id ,params =params
                )
                withContext(Dispatchers.Main) {
                    callUpdateResidentailProfile(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun callUpdateResidentailProfile(
        context: Context,
        response: Response<CommonResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveDataUpdateResidentialProfile.postValue(ResponseStatus.Success(it))
                else
                    liveDataUpdateResidentialProfile.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveDataUpdateResidentialProfile.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataUpdateResidentialProfile.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }

    /*
    GET ALL CITY
     */


    val liveDataGetAllCities = MutableLiveData<ResponseStatus<GetAllCitiesResponse>>()

    fun callAllCitiesResponse(context: Context, authToken: String) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = GeneralRepository().getAllCities(
                    authToken = authToken
                )
                withContext(Dispatchers.Main) {
                    getAllCitiesResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun getAllCitiesResponse(
        context: Context,
        response: Response<GetAllCitiesResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveDataGetAllCities.postValue(ResponseStatus.Success(it))
                else
                    liveDataGetAllCities.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveDataGetAllCities.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataGetAllCities.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }





    /*
    GET ALL State
     */


    val liveDataGetAllState = MutableLiveData<ResponseStatus<GetAllStateResponse>>()

    fun callAllStateResponse(context: Context, authToken: String) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = GeneralRepository().getAllState(
                    authToken = authToken
                )
                withContext(Dispatchers.Main) {
                    getAllStateResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun getAllStateResponse(
        context: Context,
        response: Response<GetAllStateResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveDataGetAllState.postValue(ResponseStatus.Success(it))
                else
                    liveDataGetAllState.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveDataGetAllState.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataGetAllState.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }


}