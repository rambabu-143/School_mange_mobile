package com.mountcarmelschools.ui.profile.parent

import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.motherTongue.MotherTongueResponse
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessResponse
import com.mountcarmelschools.di.data.studentprofile.*
import com.mountcarmelschools.di.networking.RetrofitClient
import okhttp3.RequestBody
import retrofit2.Response

class ParentRepository {
    suspend fun updateParentProfile(
        authToken: String,
        id: String,
        params: RequestBody
    ): Response<CommonResponse> {
        return RetrofitClient.apiService.updateParentData(authToken, id, params)
    }

    suspend fun getOccupation(authToken: String): Response<GetAllOccupationResponse> {
        return RetrofitClient.apiService.getOccupation(authToken)
    }

    suspend fun getSubCategoryOccupation(authToken: String): Response<GetAllSubCategoryResponse> {
        return RetrofitClient.apiService.getSubCategoryOccupation(authToken)
    }

    suspend fun getQualification(authToken: String): Response<QualificationResponse> {
        return RetrofitClient.apiService.getQualification(authToken)
    }

}