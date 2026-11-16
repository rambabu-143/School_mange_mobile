package com.mountcarmelschools.ui.staffHomework.assignHomework

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.config.ServerTimeResponse
import com.mountcarmelschools.di.data.staff.assignHomework.ClassHomeworkPostData
import com.mountcarmelschools.di.data.staff.assignHomework.StandardSectionListResponse
import com.mountcarmelschools.di.data.staff.assignHomework.StudentsHomeworkPostData
import com.mountcarmelschools.di.data.staff.assignHomework.StudentsListResponse
import com.mountcarmelschools.di.data.staff.assignHomework.SubjectListPostData
import com.mountcarmelschools.di.data.staff.assignHomework.SubjectListResponse
import com.mountcarmelschools.di.data.staff.assignHomework.UploadHomeworkAttachmentResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody.Companion.asRequestBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File

class AssignHomeworkViewModel : ViewModel() {
    companion object {
        const val TAG = "AssignHomeworkViewModel"
    }

    /**
     * Server time
     */
    var serverTimeMutableLiveData: MutableLiveData<ServerTimeResponse>? = null

    fun getServerTime(authToken: String): LiveData<ServerTimeResponse> {
        val data: MutableLiveData<ServerTimeResponse> = MutableLiveData()
        serverTimeMutableLiveData = data

        getServerTimeResponse(authToken)
        return data
    }

    private fun getServerTimeResponse(
        authToken: String,
    ) {
        val responseCall: Call<ServerTimeResponse> = RetrofitClient.apiService.getServerTime(authToken)

        responseCall.enqueue(object : Callback<ServerTimeResponse?> {
            override fun onResponse(
                call: Call<ServerTimeResponse?>,
                response: Response<ServerTimeResponse?>
            ) {
                if (response.isSuccessful) {
                    serverTimeMutableLiveData?.value = response.body()
                }
            }

            override fun onFailure(
                call: Call<ServerTimeResponse?>,
                t: Throwable
            ) {}
        })
    }

    /**
     * Standard and Section List
     */
    var standardSectionListMutableLiveData: MutableLiveData<StandardSectionListResponse>? = null

    fun getStandardSectionList(authToken: String): LiveData<StandardSectionListResponse> {
        val data: MutableLiveData<StandardSectionListResponse> = MutableLiveData()
        standardSectionListMutableLiveData = data

        getStandardSectionListResponse(authToken)
        return data
    }

    private fun getStandardSectionListResponse(
        authToken: String,
    ) {
        val responseCall: Call<StandardSectionListResponse> = RetrofitClient.apiService.getStandardSectionList(authToken)

        responseCall.enqueue(object : Callback<StandardSectionListResponse?> {
            override fun onResponse(
                call: Call<StandardSectionListResponse?>,
                response: Response<StandardSectionListResponse?>
            ) {
                if (response.isSuccessful) {
                    standardSectionListMutableLiveData?.value = response.body()
                }
            }

            override fun onFailure(
                call: Call<StandardSectionListResponse?>,
                t: Throwable
            ) {}
        })
    }

    /**
     * Subject List
     */
    var subjectListMutableLiveData: MutableLiveData<SubjectListResponse>? = null

    fun getSubjectListByStandardSection(authToken: String, postData: SubjectListPostData): LiveData<SubjectListResponse> {
        val data: MutableLiveData<SubjectListResponse> = MutableLiveData()
        subjectListMutableLiveData = data

        getSubjectListByStandardSectionResponse(authToken, postData)
        return data
    }

    private fun getSubjectListByStandardSectionResponse(
        authToken: String,
        data: SubjectListPostData,
    ) {
        val responseCall: Call<SubjectListResponse> = RetrofitClient.apiService.getSubjectListByStandardSection(authToken, data)

        responseCall.enqueue(object : Callback<SubjectListResponse?> {
            override fun onResponse(
                call: Call<SubjectListResponse?>,
                response: Response<SubjectListResponse?>
            ) {
                if (response.isSuccessful) {
                    subjectListMutableLiveData?.value = response.body()
                }
            }

            override fun onFailure(
                call: Call<SubjectListResponse?>,
                t: Throwable
            ) {}
        })
    }

    /**
     * Student List
     */
    var studentsListMutableLiveData: MutableLiveData<StudentsListResponse>? = null

    fun getStudentsList(authToken: String, standardSectionId: String): LiveData<StudentsListResponse> {
        val data: MutableLiveData<StudentsListResponse> = MutableLiveData()
        studentsListMutableLiveData = data

        getStudentsListResponse(authToken, standardSectionId)
        return data
    }

    private fun getStudentsListResponse(
        authToken: String,
        standardSectionId: String,
    ) {
        val responseCall: Call<StudentsListResponse> = RetrofitClient.apiService.getStudentListForStandardSection(authToken, standardSectionId)

        responseCall.enqueue(object : Callback<StudentsListResponse?> {
            override fun onResponse(
                call: Call<StudentsListResponse?>,
                response: Response<StudentsListResponse?>
            ) {
                if (response.isSuccessful) {
                    studentsListMutableLiveData?.value = response.body()
                }
            }

            override fun onFailure(
                call: Call<StudentsListResponse?>,
                t: Throwable
            ) {}
        })
    }

    /**
     * Upload Homework Attachment
     */
    var homeworkAttachmentMutableLiveData: MutableLiveData<UploadHomeworkAttachmentResponse>? = null

    fun uploadHomeworkAttachment(
        authToken: String,
        type: String,
        file: File
    ): LiveData<UploadHomeworkAttachmentResponse> {
        val data: MutableLiveData<UploadHomeworkAttachmentResponse> = MutableLiveData()
        homeworkAttachmentMutableLiveData = data

        uploadHomeworkAttachmentResponse(authToken, type, file)
        return data
    }

    private fun uploadHomeworkAttachmentResponse(
        authToken: String,
        type: String,
        file: File
    ) {
        val filePart = MultipartBody.Part.createFormData(
            "attachment",
            file.name,
            file.asRequestBody(type.toMediaTypeOrNull())
        )

        val responseCall: Call<UploadHomeworkAttachmentResponse> =
            RetrofitClient.apiService.uploadHomeworkAttachment(
                authToken, filePart
            )

        responseCall.enqueue(object : Callback<UploadHomeworkAttachmentResponse?> {
            override fun onResponse(
                call: Call<UploadHomeworkAttachmentResponse?>,
                response: Response<UploadHomeworkAttachmentResponse?>
            ) {
                if (response.body() != null && response.body()?.status!!) {
                    homeworkAttachmentMutableLiveData?.value = response.body()
                } else {
                    Log.d(TAG, "Upload homework assignment onResponse: " + response.body()?.message!!)
                }
            }

            override fun onFailure(
                call: Call<UploadHomeworkAttachmentResponse?>,
                t: Throwable
            ) {
                val uploadHomeworkAttachmentResponse = UploadHomeworkAttachmentResponse(
                    false,
                    t.localizedMessage,
                    null,
                    null,
                    null,
                    null,
                )
                homeworkAttachmentMutableLiveData?.value = uploadHomeworkAttachmentResponse
                Log.d(TAG, "Upload homework assignment onFailure: " + t.message)
            }
        })
    }

    /**
     * Submit Homework
     */
    var homeworkSubmitMutableLiveData: MutableLiveData<CommonResponse>? = null

    fun submitHomework(
        authToken: String,
        students: List<String>,
        standardSectionId: String,
        homeworkText: String,
        subjectId: String,
        date: String,
        attachmentUri: String?,
    ): LiveData<CommonResponse> {
        val data: MutableLiveData<CommonResponse> = MutableLiveData()
        homeworkSubmitMutableLiveData = data

        submitHomeworkResponse(
            authToken,
            students,
            standardSectionId,
            homeworkText,
            subjectId,
            date,
            attachmentUri,
        )
        return data
    }

    private fun submitHomeworkResponse(
        authToken: String,
        students: List<String>,
        standardSectionId: String,
        homeworkText: String,
        subjectId: String,
        date: String,
        attachmentUri: String?,
    ) {
        val responseCall: Call<CommonResponse> = if (students.isEmpty()) {
             RetrofitClient.apiService.submitHomework(
                authToken,
                postData = ClassHomeworkPostData(
                    standardSectionId = standardSectionId,
                    text = homeworkText,
                    subjectId = subjectId,
                    date = date,
                    attachment = attachmentUri,
                )
            )
        } else {
            RetrofitClient.apiService.submitHomework(
                authToken,
                postData = StudentsHomeworkPostData(
                    students = students,
                    selectedSectionId = standardSectionId,
                    text = homeworkText,
                    subjectId = subjectId,
                    date = date,
                    attachment = attachmentUri,
                )
            )
        }

        responseCall.enqueue(object : Callback<CommonResponse?> {
            override fun onResponse(
                call: Call<CommonResponse?>,
                response: Response<CommonResponse?>
            ) {
                if (response.isSuccessful) {
                    homeworkSubmitMutableLiveData?.value = response.body()
                } else {
                    homeworkSubmitMutableLiveData?.value = CommonResponse(status = false, "Unable to assign homework. Please try again and contact admin if the error continuous!")
                }
            }

            override fun onFailure(
                call: Call<CommonResponse?>,
                t: Throwable
            ) {
                homeworkSubmitMutableLiveData?.value = CommonResponse(status = false, "Unable to assign homework. Please try again and contact admin if the error continuous!")
            }
        })
    }
}