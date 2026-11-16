package com.mountcarmelschools.ui.transportRenewal

import com.google.android.gms.common.internal.service.Common
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessResponse
import com.mountcarmelschools.di.data.staffProfile.GetStudentDetailFromAdmissioNO
import com.mountcarmelschools.di.data.streamSelection.StreamSelectionPostData
import com.mountcarmelschools.di.data.streamSelection.StreamSelectionResponse
import com.mountcarmelschools.di.data.transport.TransportRenewalPostData
import com.mountcarmelschools.di.data.transport.TransportRenewalResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Response

class TransportRenewalRepository {

    suspend fun checkAdmissionNumber( authToken: String, admission: String): Response<GetStudentDetailFromAdmissioNO> {
        return RetrofitClient.apiService.checkValidAdmissionNoUpdated(authToken,admission)
    }

    suspend fun updateRenewalForm(authToken: String, data: TransportRenewalPostData): Response<CommonResponse> {
        return RetrofitClient.apiService.updateTransportRenewal(authToken,data)
    }


    suspend fun getTransportRenewal(authToken: String, id: String): Response<TransportRenewalResponse> {
        return RetrofitClient.apiService.getTransportRenewal(authToken,id)
    }
}