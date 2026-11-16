package com.mountcarmelschools.ui.profile.parent

import android.content.Context
import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.mountcarmelschools.R
import com.mountcarmelschools.base.McopBaseViewModel
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.studentprofile.*
import com.mountcarmelschools.di.networking.NoConnectivityException
import com.mountcarmelschools.di.networking.ResponseStatus
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.RequestBody
import retrofit2.Response

class ParentFragmentViewModel : McopBaseViewModel() {

    /*
    GET ALL Qualification
     */
    val liveDataGetQualification = MutableLiveData<ResponseStatus<QualificationResponse>>()
    fun callAllQualificationResponse(context: Context, authToken: String) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = ParentRepository().getQualification(
                    authToken = authToken
                )
                withContext(Dispatchers.Main) {
                    getAllQualificationResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun getAllQualificationResponse(
        context: Context,
        response: Response<QualificationResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveDataGetQualification.postValue(ResponseStatus.Success(it))
                else
                    liveDataGetQualification.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveDataGetQualification.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataGetQualification.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }


    /*
    GET ALL Occupation Response
     */


    val liveDataGetOccupationCategory = MutableLiveData<ResponseStatus<GetAllOccupationResponse>>()

    fun callAllOccupationCategoryResponse(context: Context, authToken: String) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = ParentRepository().getOccupation(
                    authToken = authToken
                )
                withContext(Dispatchers.Main) {
                    getAllOccupationCategoryResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun getAllOccupationCategoryResponse(
        context: Context,
        response: Response<GetAllOccupationResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveDataGetOccupationCategory.postValue(ResponseStatus.Success(it))
                else
                    liveDataGetOccupationCategory.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveDataGetOccupationCategory.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataGetOccupationCategory.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }


    /*
    GET ALL Sub Occupation categoty Response
     */


    val liveDataGetOccupationSubCategory =
        MutableLiveData<ResponseStatus<GetAllSubCategoryResponse>>()

    fun callAllOccupationSubCategoryResponse(context: Context, authToken: String) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = ParentRepository().getSubCategoryOccupation(
                    authToken = authToken
                )
                withContext(Dispatchers.Main) {
                    getAllOccupationSubCategoryResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun getAllOccupationSubCategoryResponse(
        context: Context,
        response: Response<GetAllSubCategoryResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveDataGetOccupationSubCategory.postValue(ResponseStatus.Success(it))
                else
                    liveDataGetOccupationSubCategory.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveDataGetOccupationSubCategory.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataGetOccupationSubCategory.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }

    /*
    Update Parent Profile
     */


    val liveUpdateProfile = MutableLiveData<ResponseStatus<CommonResponse>>()

    fun callForUpdateProfile(
        context: Context,
        authToken: String,
        id: String,
        params: RequestBody
    ) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = ParentRepository().updateParentProfile(
                    authToken = authToken, id = id, params
                )
                withContext(Dispatchers.Main) {
                    getUpdateResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun getUpdateResponse(
        context: Context,
        response: Response<CommonResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveUpdateProfile.postValue(ResponseStatus.Success(it))
                else
                    liveUpdateProfile.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveUpdateProfile.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveUpdateProfile.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }


}