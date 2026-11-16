package com.mountcarmelschools.ui.disciplinary.forstaff

import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.disciplinaryCard.DisciplinaryPostDataItem
import com.mountcarmelschools.di.data.disciplinaryCard.GetReasonListResponse
import com.mountcarmelschools.di.data.scann.ScanAPiResponse
import com.mountcarmelschools.di.data.scann.ScanPostData
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Response

class DisciplinaryForStaffRepository {
    suspend fun getDisciplinaryData( authToken: String, data: ScanPostData): Response<ScanAPiResponse> {
        return RetrofitClient.apiService.getScanResponseDisciplinary(authToken,data)
    }

    suspend fun provideDisciplinaryData( authToken: String, data: ArrayList<DisciplinaryPostDataItem>): Response<CommonResponse> {
        return RetrofitClient.apiService.provideDisciplinary(authToken,data)
    }
  suspend fun getReasonList( authToken: String, data: String): Response<GetReasonListResponse> {
        return RetrofitClient.apiService.getReasonForDisciplinary(authToken,data)
    }

}