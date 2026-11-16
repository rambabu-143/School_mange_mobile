package com.mountcarmelschools.ui.profile.staff.editProfile

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.staffProfile.*
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class EditStaffProfileViewModel : ViewModel() {


    /*
Get City List
*/

    var cityList: MutableLiveData<GetAllCityResponse>? = null

    fun getAllCity(
        authToken: String,
    ): LiveData<GetAllCityResponse> {
        if (cityList == null) {
            cityList = MutableLiveData()
        }

        getAllCityResponse(authToken)
        return cityList!!
    }

    private fun getAllCityResponse(
        authToken: String
    ) {

        val responseCall: Call<GetAllCityResponse> =
            RetrofitClient.apiService.getAllCities(authToken)

        responseCall.enqueue(object : Callback<GetAllCityResponse?> {
            override fun onResponse(
                call: Call<GetAllCityResponse?>,
                response: Response<GetAllCityResponse?>
            ) {
                if (response.isSuccessful) {

                    cityList?.value = response.body()

                }

            }

            override fun onFailure(
                call: Call<GetAllCityResponse?>,
                t: Throwable
            ) {
            }
        })
    }


    /*
Get All Department List
*/

    var departmentList: MutableLiveData<GetAllDepartmentResponse>? = null

    fun getAllDepartment(
        authToken: String,
    ): LiveData<GetAllDepartmentResponse> {
        if (departmentList == null) {
            departmentList = MutableLiveData()
        }

        getAllDepartmentResponse(authToken)

        return departmentList!!
    }

    private fun getAllDepartmentResponse(
        authToken: String
    ) {

        val responseCall: Call<GetAllDepartmentResponse> =
            RetrofitClient.apiService.getAllDepartment(authToken)

        responseCall.enqueue(object : Callback<GetAllDepartmentResponse?> {
            override fun onResponse(
                call: Call<GetAllDepartmentResponse?>,
                response: Response<GetAllDepartmentResponse?>
            ) {
                if (response.isSuccessful) {

                    departmentList?.value = response.body()

                }

            }

            override fun onFailure(
                call: Call<GetAllDepartmentResponse?>,
                t: Throwable
            ) {
            }
        })
    }


    /*
Get All Staff Room List
*/

    var staffRoomList: MutableLiveData<GetStaffRoomList>? = null

    fun getAllStaff(
        authToken: String,
    ): LiveData<GetStaffRoomList> {
        if (staffRoomList == null) {
            staffRoomList = MutableLiveData()
        }

        getAllStaffResponse(authToken)

        return staffRoomList!!
    }

    private fun getAllStaffResponse(
        authToken: String
    ) {

        val responseCall: Call<GetStaffRoomList> =
            RetrofitClient.apiService.getAllStaffRoom(authToken)

        responseCall.enqueue(object : Callback<GetStaffRoomList?> {
            override fun onResponse(
                call: Call<GetStaffRoomList?>,
                response: Response<GetStaffRoomList?>
            ) {
                if (response.isSuccessful) {

                    staffRoomList?.value = response.body()
                }
            }

            override fun onFailure(
                call: Call<GetStaffRoomList?>,
                t: Throwable
            ) {
            }
        })
    }


    /*
check Admission no
*/

    var responseData: MutableLiveData<GetStudentDetailFromAdmissioNO>? = null

    fun checkAdmissionNo(
        authToken: String,
        admissionNo: String
    ): LiveData<GetStudentDetailFromAdmissioNO> {
        if (responseData == null) {
            responseData = MutableLiveData()
        }

        checkAdmissionNoResponse(authToken, admissionNo)

        return responseData!!
    }

    private fun checkAdmissionNoResponse(
        authToken: String,
        admissionNo: String
    ) {

        val responseCall: Call<GetStudentDetailFromAdmissioNO> =
            RetrofitClient.apiService.checkValidAdmissionNo(authToken, admissionNo)

        responseCall.enqueue(object : Callback<GetStudentDetailFromAdmissioNO?> {
            override fun onResponse(
                call: Call<GetStudentDetailFromAdmissioNO?>,
                response: Response<GetStudentDetailFromAdmissioNO?>
            ) {
                if (response.isSuccessful) {

                    responseData?.value = response.body()
                }
            }

            override fun onFailure(
                call: Call<GetStudentDetailFromAdmissioNO?>,
                t: Throwable
            ) {
            }
        })
    }


    /*
 Update Profile
*/

    var mUpdateProfile: MutableLiveData<CommonResponse>? = null

    fun updateProfile(
        authToken: String,
        id: String,
        data: UpdateProfilePostData?
    ): LiveData<CommonResponse> {
        if (mUpdateProfile == null) {
            mUpdateProfile = MutableLiveData()
        }

        updateProfileResponse(authToken, id, data!!)

        return mUpdateProfile!!
    }

    private fun updateProfileResponse(
        authToken: String,
        id: String,
        data: UpdateProfilePostData
    ) {

        val responseCall: Call<CommonResponse> =
            RetrofitClient.apiService.updateProfile(authToken, id, data)

        responseCall.enqueue(object : Callback<CommonResponse?> {
            override fun onResponse(
                call: Call<CommonResponse?>,
                response: Response<CommonResponse?>
            ) {
                if (response.isSuccessful) {

                    mUpdateProfile?.value = response.body()
                }
            }

            override fun onFailure(
                call: Call<CommonResponse?>,
                t: Throwable
            ) {
            }
        })
    }


}