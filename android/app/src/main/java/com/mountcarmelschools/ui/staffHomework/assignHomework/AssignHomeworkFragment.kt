package com.mountcarmelschools.ui.staffHomework.assignHomework

import android.app.Activity
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.OpenableColumns
import android.util.Log
import android.view.View
import android.webkit.MimeTypeMap
import android.widget.AdapterView
import android.widget.ArrayAdapter
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.widget.doOnTextChanged
import androidx.lifecycle.lifecycleScope
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentAssignHomeworkBinding
import com.mountcarmelschools.di.data.staff.assignHomework.StandardSectionListResponse
import com.mountcarmelschools.di.data.staff.assignHomework.StudentsListResponse
import com.mountcarmelschools.di.data.staff.assignHomework.SubjectListPostData
import com.mountcarmelschools.di.data.staff.assignHomework.SubjectListResponse
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.ui.staffHomework.assignHomework.bottomSheetStudents.StudentsListBottomSheet
import com.mountcarmelschools.utlis.Utils
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File
import java.io.FileOutputStream
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

class AssignHomeworkFragment : BaseFragment<FragmentAssignHomeworkBinding, AssignHomeworkViewModel>() {
    private lateinit var context: Context

    // Constants
    private val MAX_SIZE_IN_BYTES = 2 * 1024 * 1024 // 2 MB

    // Data
    private var classList: List<StandardSectionListResponse.StandardSectionData>? = null
    private var subjectsList: List<SubjectListResponse.SubjectData>? = null
    private var sortedStudentsList: List<StudentsListResponse.StudentData>? = null
    private var assigneeTypeList: List<String>? = null

    // States
    /**
     * date string format: DD-MM-YYYY
    */
    private var homeworkDate: String? = null // DD-MM-YYYY
    private var selectedStandardSectionId: String? = null
    private var selectedStandardId: String? = null
    private var standardSectionText: String? = null
    private var selectedSubjectId: String? = null
    private var isAssigningToWholeClass: Boolean? = null
    private var selectedStudentIds: MutableList<String> = mutableListOf()

    // Register Launcher
    private val launcher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
        dataBinding.attachmentError?.visibility = View.GONE

        if (result.resultCode == Activity.RESULT_OK) {
            result.data?.data?.let { fileUri ->
                Log.d("AssignHomeworkFragment", "selected file uri -> $fileUri")
                val fileSizeFromUri = getFileSizeFromUri(fileUri)
                if (fileSizeFromUri != null && fileSizeFromUri > MAX_SIZE_IN_BYTES) {
                    dataBinding.attachmentError?.apply {
                        visibility = View.VISIBLE
                        text = "File size should be equal or less than 2MB"
                    }
                    return@let
                }
                val fileMimeFromUri = getFileMimeTypeFromUri(fileUri)
                viewLifecycleOwner.lifecycleScope.launch {
                    val fileToUpload = uriToFile(fileUri, context)

                    if (fileToUpload != null) {
                        if (fileToUpload.length() > MAX_SIZE_IN_BYTES) {
                            // Handle file too large
                            dataBinding.attachmentError?.apply {
                                visibility = View.VISIBLE
                                text = "File size shoule be equal or less than 2MB"
                            }
                        } else {
                            uploadHomeworkFile(fileToUpload, fileMimeFromUri)
                        }
                    } else {
                        showErrorToast("Unable to create temporary file from selected file. Please contact admin!", context)
                    }
                }
            }
        }
    }

    override fun getLayoutID() = R.layout.fragment_assign_homework

    override fun getViewModel() = AssignHomeworkViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        this.context = context
    }

    override fun onResume() {
        super.onResume()
        (context as DashboardActivity).setHeaderText("Assign Homework")
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        configureHomeworkDate()

        configureClassesUI()

        configureSubjectsUI()

        configureAssigneeTypeUI()

        configureStudentSelectionButton()

        configureHomeworkContentTextInput()

        configureHomeworkAttachmentUI()

        configureHomeworkSubmitButton()
    }

    private fun configureHomeworkDate() {
        val currentLocalDate = Calendar.getInstance().time
        setHomeworkDate(currentLocalDate)

        viewModel
            .getServerTime(Utils.getAccessToken(context))
            .observe(viewLifecycleOwner) { serverTimeRes ->
                try {
                    val serverDateString = serverTimeRes?.todayDate // YYYY-MM-DD

                    if (serverDateString != null) {
                        val serverDateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                        val serverDate = serverDateFormat.parse(serverDateString)

                        if (serverDate != null) {
                            setHomeworkDate(serverDate)
                        }
                    }
                } catch (error: Exception) {
                    error.localizedMessage?.let { Log.e("AssignHomeworkFragment", it) }
                }
            }
    }

    private fun setHomeworkDate(date: Date) {
        val dataDateFormat = SimpleDateFormat("dd-MM-yyyy", Locale.getDefault())
        homeworkDate = dataDateFormat.format(date)

        val uiDateFormat = SimpleDateFormat("dd MMM, yyyy", Locale.getDefault())
        dataBinding.homeworkDateTextView.text = String.format(resources.getString(R.string.assign_homework_date_label), uiDateFormat.format(date))
    }

    private fun configureClassesUI() {
        dataBinding.selectClassInput.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View?,
                position: Int,
                id: Long
            ) {
                onSelectedClassChange(position)
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {
                onSelectedClassChange(-1)
            }
        }

        fetchAndConfigureClassList()
    }

    private fun configureSubjectsUI() {
        dataBinding.selectSubjectInput.adapter = ArrayAdapter(
            context,
            R.layout.selected_text_view_black,
            listOf("Select")
        )
        dataBinding.selectSubjectInput.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View?,
                position: Int,
                id: Long
            ) {
                onSelectedSubjectChange(position)
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {
                onSelectedSubjectChange(-1)
            }
        }
    }

    private fun configureAssigneeTypeUI() {
        dataBinding.selectAssigneeTypeInput.adapter = ArrayAdapter(
            context,
            R.layout.selected_text_view_black,
            listOf("Select")
        )
        dataBinding.selectAssigneeTypeInput.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View?,
                position: Int,
                id: Long
            ) {
                onSelectedAssigneeTypeChange(position)
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {
                onSelectedAssigneeTypeChange(-1)
            }
        }
    }

    private fun configureStudentSelectionButton() {
        dataBinding.selectStudentsButton.setOnClickListener {
            val studentsList = sortedStudentsList

            if (studentsList == null) {
                dataBinding.selectStudentsError.visibility = View.VISIBLE
                dataBinding.selectStudentsError.text = "Students list is not available. Please contact admin!"
            } else {
                dataBinding.selectStudentsError.visibility = View.GONE

                val studentsListBottomSheet = StudentsListBottomSheet()
                studentsListBottomSheet.setData(
                    "Students of Class $standardSectionText",
                    studentsList,
                    selectedStudentIds
                )
                studentsListBottomSheet.setOnDoneClickListener {  selectedIds ->
                    selectedStudentIds.clear()
                    selectedStudentIds.addAll(selectedIds)

                    updateSelectStudentButtonText()
                }
                studentsListBottomSheet.show(childFragmentManager, StudentsListBottomSheet::class.java.simpleName)
            }
        }
    }

    private fun configureHomeworkContentTextInput() {
        dataBinding.homeworkContentCharCounter.text = String.format(
            resources.getString(R.string.homework_content_char_counter),
            dataBinding.homeworkContentInputField.text.length.toString(),
            "300"
        )

        dataBinding.homeworkContentInputField.doOnTextChanged { charSeq, _, _, _ ->
            charSeq?.length.let { count ->
                dataBinding.homeworkContentError.visibility = View.GONE
                dataBinding.homeworkContentCharCounter.text = String.format(
                    resources.getString(R.string.homework_content_char_counter),
                    count.toString(),
                    "300"
                )
            }
        }
    }

    private fun configureHomeworkSubmitButton() {
        dataBinding.submitButton.setOnClickListener {
            val homeworkDate = homeworkDate
            if (homeworkDate.isNullOrEmpty()) {
                showErrorToast("Homework date not set, screen is not usable. Please contact admin!", context)
                return@setOnClickListener
            }
            val selectedStandardSectionId = selectedStandardSectionId
            if (selectedStandardSectionId.isNullOrEmpty()) {
                dataBinding.selectClassError.visibility = View.VISIBLE
                dataBinding.selectClassError.text = "Please select standard and section"
                return@setOnClickListener
            }
            val selectedSubjectId = selectedSubjectId
            if (selectedSubjectId.isNullOrEmpty()) {
                dataBinding.selectSubjectError.visibility = View.VISIBLE
                dataBinding.selectSubjectError.text = "Please select subject"
                return@setOnClickListener
            }
            val isAssigningToWholeClass = isAssigningToWholeClass
            if (isAssigningToWholeClass == null) {
                dataBinding.assigneeTypeError.visibility = View.VISIBLE
                dataBinding.assigneeTypeError.text = "Please select asignee type"
                return@setOnClickListener
            }
            val selectedStudentIds = selectedStudentIds
            if (isAssigningToWholeClass == false && selectedStudentIds.isEmpty()) {
                dataBinding.selectStudentsError.visibility = View.VISIBLE
                dataBinding.selectStudentsError.text = "Please select students"
                return@setOnClickListener
            }
            val homeworkContent = dataBinding.homeworkContentInputField.text.toString()
            if (homeworkContent.isEmpty()) {
                dataBinding.homeworkContentError.visibility = View.VISIBLE
                dataBinding.homeworkContentError.text = "Please enter homework content"
                return@setOnClickListener
            }
            val attachmentFileName = viewModel.homeworkAttachmentMutableLiveData?.value?.fileName

            (context as DashboardActivity).showProgress() // show loader

            viewModel.submitHomework(
                authToken = Utils.getAccessToken(context),
                students = selectedStudentIds,
                standardSectionId = selectedStandardSectionId,
                homeworkText = homeworkContent,
                subjectId = selectedSubjectId,
                date = homeworkDate,
                attachmentUri = attachmentFileName,
            ).observe(viewLifecycleOwner) { commonRes ->
                (context as DashboardActivity).hideProgress() // hide loader

                val response = commonRes ?: return@observe

                if (response.status == true) {
                    showSuccessToast("Homework assigned successfully", context)
                    resetForm()
                } else if (response.message != null) {
                    showErrorToast(response.message, context)
                }
            }
        }
    }

    private fun configureHomeworkAttachmentUI() {
        dataBinding.pickImageContainer.setOnClickListener {
            val intent = Intent(Intent.ACTION_PICK)
            intent.type = "image/*"
            launcher.launch(intent)
        }

        dataBinding.pickFileContainer.setOnClickListener {
            val intent = Intent(Intent.ACTION_OPEN_DOCUMENT)
            intent.addCategory(Intent.CATEGORY_OPENABLE)
            intent.type = "*/*" // Specify MIME types if needed
            intent.putExtra(Intent.EXTRA_MIME_TYPES, arrayOf(
                "text/csv", // .csv
                "text/markdown", // .md
                "application/vnd.openxmlformats-officedocument.wordprocessingml.document", // .docx
                "application/msword", // .doc
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", // .xlsx
                "application/vnd.ms-excel", // .xlsx
                "application/vnd.openxmlformats-officedocument.presentationml.presentation", // .pptx
                "application/vnd.ms-powerpoint", // .ppt
                "text/plain", // .txt
                "application/pdf",
                "application/rtf",
                "image/jpeg",
                "image/jpg",
                "image/png"
            ))
            launcher.launch(intent)
        }

        dataBinding.deleteUploadedFile.setOnClickListener {
            showAttachmentUploadView()
        }
    }

    private fun resetForm() {
        configureHomeworkDate()

        dataBinding.selectAssigneeTypeInput.setSelection(0)

        // reset homework content text and its character counter
        dataBinding.homeworkContentInputField.text.clear()

        // clear upload data
        showAttachmentUploadView()
    }

    private fun updateSelectStudentButtonText() {
        dataBinding.selectStudentsButton.text = if (selectedStudentIds.isEmpty()) {
            "Select Students"
        } else {
            "${selectedStudentIds.size} ${if (selectedStudentIds.size > 1) {
                "Students"
            } else {
                "Student"
            }} Selected"
        }
    }

    private fun onSelectedSubjectChange(selectedPosition: Int) {
        dataBinding.selectSubjectError.visibility = View.GONE

        selectedSubjectId = subjectsList?.getOrNull(selectedPosition - 1)?.id
    }

    private fun onSelectedClassChange(selectedPosition: Int) {
        dataBinding.selectClassError.visibility = View.GONE

        val position = selectedPosition - 1

        val selectedClass = classList?.getOrNull(position)

        if (selectedClass == null && position >= 0) {
            showErrorToast("`null` value at selected position. Please contact Admin!", context)
        }

        val standardId = selectedClass?.standardId?.id
        val standardSectionId = selectedClass?.id

        if (standardId == null && position >= 0) {
            showErrorToast("No standard Id available in selected item. Please contact Admin!", context)
        } else if (standardSectionId == null && position >= 0) {
            showErrorToast("No standard section Id available in selected item. Please contact Admin!", context)
        }

        selectedStandardId = standardId
        selectedStandardSectionId = standardSectionId

        standardSectionText = "${selectedClass?.standard} ${selectedClass?.section}"

        // clear selected subject id, subject list, and ui selection
        subjectsList = null
        selectedSubjectId = null
        dataBinding.selectSubjectInput.adapter = ArrayAdapter(
            context,
            R.layout.selected_text_view_black,
            listOf("Select")
        )

        // clear student list, selected student list
        sortedStudentsList = null
        dataBinding.selectAssigneeTypeInput.adapter = ArrayAdapter(
            context,
            R.layout.selected_text_view_black,
            listOf("Select")
        )

        // Update data as per selected class
        if (selectedStandardId != null && selectedStandardSectionId != null) {
            fetchAndConfigureSubjectList()
            fetchStudentList()
        }
    }

    private fun onSelectedAssigneeTypeChange(selectedPosition: Int) {
        dataBinding.assigneeTypeError.visibility = View.GONE

        val selectedAssigneeType = assigneeTypeList?.getOrNull(selectedPosition - 1)

        isAssigningToWholeClass = if (selectedAssigneeType == null) {
            null
        } else {
            selectedAssigneeType == "Whole Class"
        }
        selectedStudentIds.clear()
        dataBinding.selectStudentsView.visibility = if (isAssigningToWholeClass == false) { View.VISIBLE } else { View.GONE }
        updateSelectStudentButtonText()
        dataBinding.selectStudentsError.visibility = View.GONE
    }

    private fun showAttachmentUploadView() {
        dataBinding.uploadingView?.visibility = View.GONE

        dataBinding.uploadedView?.visibility = View.GONE
        viewModel.homeworkAttachmentMutableLiveData = null

        dataBinding.uploadView?.visibility = View.VISIBLE
    }

    private fun showAttachmentUploadingView() {
        dataBinding.uploadView?.visibility = View.GONE
        dataBinding.uploadedView?.visibility = View.GONE
        dataBinding.uploadingView?.visibility = View.VISIBLE
    }

    private fun showAttachmentUploadedView(fileName: String) {
        dataBinding.uploadView?.visibility = View.GONE
        dataBinding.uploadingView?.visibility = View.GONE

        dataBinding.uploadedFileName?.text = fileName
        dataBinding.uploadedView?.visibility = View.VISIBLE
    }

    private fun fetchAndConfigureSubjectList() {
        val selectedStandardSectionId = this.selectedStandardSectionId
        val selectedStandardId = this.selectedStandardId
        if (selectedStandardSectionId.isNullOrEmpty() || selectedStandardId.isNullOrEmpty()) {
            showErrorToast("Please select standard section!", context)
            return
        }
        val data = SubjectListPostData(
            standardSectionId = selectedStandardSectionId,
            standardId = listOf(selectedStandardId)
        )
        (context as DashboardActivity).showProgress() // show loader

        viewModel.getSubjectListByStandardSection(
            authToken = Utils.getAccessToken(context),
            postData = data,
        ).observe(viewLifecycleOwner) { subjectListRes ->
//            (context as DashboardActivity).hideProgress() // hide loader
            val subjectListResponse = subjectListRes ?: return@observe

            if (subjectListResponse.status == true) {
                if (subjectListResponse.data.isNullOrEmpty()) {
                    showErrorToast("Subject list is not available for selected Standard and Section. Please contact admin!", context)
                } else {
                    val subjectsList = subjectListResponse.data

                    this.subjectsList = subjectsList

                    // Setting Adapter to Subject Picker
                    val subjectsNameList = subjectsList.mapNotNull { subject -> subject.subjectName }.toMutableList()
                    subjectsNameList.add(0, "Select")
                    dataBinding.selectSubjectInput.setAdapter(ArrayAdapter(
                        context,
                        R.layout.selected_text_view_black,
                        subjectsNameList
                    ))
                }
            } else if (subjectListResponse.message != null) {
                showErrorToast(subjectListResponse.message, context)
            }
        }
    }

    private fun fetchStudentList() {
        val selectedStandardSectionId = this.selectedStandardSectionId
        if (selectedStandardSectionId.isNullOrEmpty()) {
            showErrorToast("Please select standard section!", context)
            return
        }
        (context as DashboardActivity).showProgress() // show loader

        viewModel.getStudentsList(
            authToken = Utils.getAccessToken(context),
            standardSectionId = selectedStandardSectionId
        ).observe(viewLifecycleOwner) { studentsListRes ->
            (context as DashboardActivity).hideProgress() // hide loader

            selectedStudentIds.clear()

            val assigneeTypes = mutableListOf("Whole Class")

            val studentsListResponse = studentsListRes ?: run {
                assigneeTypeList = assigneeTypes

                val adapterList = mutableListOf("Select")
                adapterList.addAll(assigneeTypes)
                dataBinding.selectAssigneeTypeInput.setAdapter(ArrayAdapter(
                    context,
                    R.layout.selected_text_view_black,
                    adapterList
                ))

                return@observe
            }

            if (studentsListResponse.status == true) {
                val sortedStudents = studentsListResponse.data?.sortedBy { it.name }
                sortedStudentsList = sortedStudents

                if (studentsListResponse.data.isNullOrEmpty()) {
                    showErrorToast("Students list is not available for selected Standard and Section. Please contact admin!", context)
                } else {
                    assigneeTypes.add("Selected Students")
                }
            } else if (studentsListResponse.message != null) {
                showErrorToast(studentsListResponse.message, context)
            }
            assigneeTypeList = assigneeTypes
            val adapterList = mutableListOf("Select")
            adapterList.addAll(assigneeTypes)
            dataBinding.selectAssigneeTypeInput.setAdapter(ArrayAdapter(
                context,
                R.layout.selected_text_view_black,
                adapterList
            ))
        }
    }

    private fun fetchAndConfigureClassList() {
        (context as DashboardActivity).showProgress() // show loader

        viewModel.getStandardSectionList(authToken = Utils.getAccessToken(context))
            .observe(viewLifecycleOwner) { standardSectionListRes ->
            (context as DashboardActivity).hideProgress() // hide loader

            val standardSectionListResponse = standardSectionListRes ?: return@observe

            if (standardSectionListResponse.status == true) {
                if (standardSectionListResponse.data.isNullOrEmpty()) {
                    showErrorToast("No class is assigned to you. Please contact admin!", context)
                } else {
                    val classList = standardSectionListResponse.data

                    this.classList = classList

                    // Setting Adapter to Class Picker
                    val classNameList = classList.mapNotNull { standardSection ->
                        "${standardSection.standard} ${standardSection.section}"
                    }.toMutableList()
                    classNameList.add(0, "Select")
                    dataBinding.selectClassInput.setAdapter(ArrayAdapter(
                        context,
                        R.layout.selected_text_view_black,
                        classNameList
                    ))
                }
            } else if (standardSectionListResponse.message != null) {
                showErrorToast(standardSectionListResponse.message, context)
            }
        }
    }

    private fun uploadHomeworkFile(file: File, mimeType: String?) {
        showAttachmentUploadingView()

        viewModel.uploadHomeworkAttachment(
            authToken = Utils.getAccessToken(context),
            type = mimeType ?: file.extension,
            file = file
        ).observe(viewLifecycleOwner) { uploadAttachmentRes ->
            deleteFile(file)

            if (uploadAttachmentRes.status != true || uploadAttachmentRes.fileName.isNullOrEmpty()) {
                showErrorToast(
                    uploadAttachmentRes.message ?: "Something went wrong while uploading file. Please try again!",
                    context
                )
                showAttachmentUploadView()
            } else {
                val filename = uploadAttachmentRes.originalName ?: uploadAttachmentRes.fileName
                showAttachmentUploadedView(filename)
            }
        }
    }

    // Utilities
    private fun deleteFile(file: File) {
        try {
            file.delete()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private suspend fun uriToFile(uri: Uri, context: Context): File? = withContext(Dispatchers.IO) {
        val file = File(context.cacheDir, getFileNameFromUri(uri) ?: "${System.currentTimeMillis()}.tmp")
        try {
            context.contentResolver.openInputStream(uri)?.use { inputStream ->
                FileOutputStream(file).use { outputStream ->
                    inputStream.copyTo(outputStream)
                }
            }
            return@withContext file
        } catch (e: Exception) {
            e.printStackTrace()
            return@withContext null
        }
    }

    private fun getFileNameFromUri(uri: Uri): String? {
        var name: String? = null
        val cursor = context.contentResolver.query(uri, null, null, null, null)
        cursor?.use {
            if (it.moveToFirst()) {
                val columnIndex = it.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                if (columnIndex >= 0) {
                    name = it.getString(columnIndex)
                }
            }
        }
        return name
    }

    private fun getFileSizeFromUri(uri: Uri): Long? {
        var fileSize: Long? = null
        val cursor = context.contentResolver.query(uri, null, null, null, null)
        cursor?.use {
            if (it.moveToFirst()) {
                val sizeIndex = it.getColumnIndex(OpenableColumns.SIZE)
                if (sizeIndex >= 0) {
                    fileSize = it.getLong(sizeIndex)
                }
            }
        }
        return fileSize
    }

    private fun getFileMimeTypeFromUri(uri: Uri): String? {
        var mimeType: String? = if (uri.scheme == ContentResolver.SCHEME_CONTENT) {
            context.contentResolver.getType(uri)
        } else {
            null
        }
        if (mimeType == null) {
            // For file URIs, use the file extension
            val fileExtension = MimeTypeMap.getFileExtensionFromUrl(uri.toString())
            mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(fileExtension.lowercase())
        }
        return mimeType
    }
}