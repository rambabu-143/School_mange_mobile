package com.mountcarmelschools.ui.wise

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.google.gson.Gson
import com.mountcarmelschools.di.data.CheckCurrentTermResponse
import com.mountcarmelschools.di.data.classList.ClassListDropDownResponse
import com.mountcarmelschools.di.data.scann.ScanAPiResponse
import com.mountcarmelschools.di.data.scann.ScanPostData
import com.mountcarmelschools.di.data.staff.wiseStudentList.WiseListFromClassResponse
import com.mountcarmelschools.di.data.staff.wiseStudentList.WiseStudentListResponse
import com.mountcarmelschools.di.data.wise.wiseRes.WiseResponseForStudent
import com.mountcarmelschools.di.data.wise.wiseRes.wisepostdata.WisePostDataForApi
import com.mountcarmelschools.di.networking.RetrofitClient
import org.json.JSONArray
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response


class WiseViewModel : ViewModel() {
    /*
   Get wise
    */


    var studentWiseLiveList: MutableLiveData<WiseResponseForStudent>? = null

    fun getWise(authToken: String, sectionId: String): LiveData<WiseResponseForStudent> {
        studentWiseLiveList = MutableLiveData()

        getWiseResponse(authToken, sectionId)
        return studentWiseLiveList!!
    }

    private fun getWiseResponse(authToken: String, sectionId: String) {

        val responseCall: Call<WiseResponseForStudent?>? =
            RetrofitClient.apiService.getWise(authToken, sectionId)

        responseCall?.enqueue(object : Callback<WiseResponseForStudent?> {
            override fun onResponse(
                call: Call<WiseResponseForStudent?>,
                response: Response<WiseResponseForStudent?>
            ) {

                studentWiseLiveList?.value = response.body()


            }

            override fun onFailure(
                call: Call<WiseResponseForStudent?>,
                t: Throwable
            ) {
            }
        })
    }


//--------------- End Wise -------------------------//}


    /*
Get Student from Date Range
*/
    var studentWiseResonseDate: MutableLiveData<WiseStudentListResponse>? = null

    fun getWiseStudentListFromDate(
        authToken: String,
        id: String,
        startDate: String,
        endDate: String
    ): LiveData<WiseStudentListResponse> {
        if (studentWiseResonseDate == null) {
            studentWiseResonseDate = MutableLiveData()
        }

        getWiseStudentListFromDateResponse(authToken, id, startDate, endDate)
        return studentWiseResonseDate!!
    }

    private fun getWiseStudentListFromDateResponse(
        authToken: String,
        standardID: String,
        startDate: String,
        endDate: String
    ) {

        val responseCall: Call<WiseStudentListResponse?>? =
            RetrofitClient.apiService.getWiseStudentFromDate(
                authToken,
                standardID,
                startDate,
                endDate
            )

        responseCall?.enqueue(object : Callback<WiseStudentListResponse?> {
            override fun onResponse(
                call: Call<WiseStudentListResponse?>,
                response: Response<WiseStudentListResponse?>
            ) {
                if (response.isSuccessful) {

                    studentWiseResonseDate?.value = response.body()

                }

            }

            override fun onFailure(
                call: Call<WiseStudentListResponse?>,
                t: Throwable
            ) {
            }
        })
    }

    //---------------  Get Student from Date Range-------------------------//


    /*
Get Student Wise
*/
    var studentWiseList: MutableLiveData<WiseListFromClassResponse>? = null

    fun getWiseStudentList(
        authToken: String,
        id: String
    ): LiveData<WiseListFromClassResponse> {
        if (studentWiseList == null) {
            studentWiseList = MutableLiveData()
        }

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

    //---------------   Get Student Wise -------------------------//


    /*
  Get wise
   */


    var getUpdateStudentWise: MutableLiveData<WiseResponseForStudent>? = null

    fun getUpdateStudentWise(
        authToken: String,
        data: ArrayList<WisePostDataForApi>
    ): LiveData<WiseResponseForStudent> {
        getUpdateStudentWise = MutableLiveData()

        getWiseUpdateResponse(authToken, data)
        return getUpdateStudentWise!!
    }

    private fun getWiseUpdateResponse(authToken: String, data: ArrayList<WisePostDataForApi>) {

        val json = Gson().toJson(data)

        val array = JSONArray(json)
        val responseCall: Call<WiseResponseForStudent?>? =
            RetrofitClient.apiService.updateWiseCard(authToken, data)

        responseCall?.enqueue(object : Callback<WiseResponseForStudent?> {
            override fun onResponse(
                call: Call<WiseResponseForStudent?>,
                response: Response<WiseResponseForStudent?>
            ) {

                getUpdateStudentWise?.value = response.body()


            }

            override fun onFailure(
                call: Call<WiseResponseForStudent?>,
                t: Throwable
            ) {
                Log.e("error", t.localizedMessage)
            }
        })
    }


//--------------- End Wise -------------------------//}

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
 Get  Scan Response`
  */
    var scanResult: MutableLiveData<ScanAPiResponse>? = null


    fun getScan(
        authToken: String, data: ScanPostData
    ): LiveData<ScanAPiResponse> {
        scanResult = MutableLiveData()
        getScanResponseResponse(authToken, data)
        return scanResult!!
    }


    private fun getScanResponseResponse(
        authToken: String, data: ScanPostData

    ) {
        val responseCall: Call<ScanAPiResponse?>? =
            RetrofitClient.apiService.getScanResponse(authToken, data)
        responseCall?.enqueue(object : Callback<ScanAPiResponse?> {
            override fun onResponse(
                call: Call<ScanAPiResponse?>,
                response: Response<ScanAPiResponse?>
            ) {

                scanResult?.value = response.body()
            }

            override fun onFailure(
                call: Call<ScanAPiResponse?>,
                t: Throwable
            ) {

                Log.e("", t.localizedMessage)
            }
        })
    }

    /*
   Get wise
    */


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


//--------------- End Wise -------------------------//}


}
