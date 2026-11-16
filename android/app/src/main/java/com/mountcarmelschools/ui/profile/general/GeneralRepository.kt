package com.mountcarmelschools.ui.profile.general

import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.motherTongue.MotherTongueResponse
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessResponse
import com.mountcarmelschools.di.data.studentprofile.*
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Response

class GeneralRepository {
    suspend fun getMotherTongue(authToken: String): Response<MotherTongueResponse> {
        return RetrofitClient.apiService.getMotherTongue(authToken)
    }

    suspend fun updateProfile(
        authToken: String,
        id: String,
        params: GeneralPostData
    ): Response<CommonResponse> {
        return RetrofitClient.apiService.updateUserProfile(authToken, id, params)
    }

   suspend fun updateResidentialProfile(
        authToken: String,
        id: String,
        params: ResidentialPostDataUpdated
    ): Response<CommonResponse> {
        return RetrofitClient.apiService.updateUserResidentialProfile(authToken, id, params)
    }


    suspend fun getAllCities(authToken: String): Response<GetAllCitiesResponse> {
        return RetrofitClient.apiService.getAllCity(authToken)
    }

    suspend fun getAllState(authToken: String): Response<GetAllStateResponse> {
        return RetrofitClient.apiService.getAllState(authToken)
    }

}