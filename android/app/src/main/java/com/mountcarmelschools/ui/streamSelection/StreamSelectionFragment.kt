package com.mountcarmelschools.ui.streamSelection

import android.annotation.SuppressLint
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.widget.ArrayAdapter
import androidx.lifecycle.Observer
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentStreamSelectionBinding
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.streamSelection.StreamSelectionPostData
import com.mountcarmelschools.di.data.streamSelection.StreamSelectionResponse
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.di.networking.ResponseStatusError
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils
import java.text.SimpleDateFormat

class StreamSelectionFragment :
    BaseFragment<FragmentStreamSelectionBinding, StreamSelectionViewModel>() {


    lateinit var mContext: Context

    val mAdapterList = ArrayList<StreamSelectionResponse.Data?>()

    var mCombinationId = ""
    var mSubject1Id = ""
    var mSubject2Id = ""
    var mSubject3Id = ""
    var mSubject4Id = ""
    var mSubject5Id = ""
    var mSubject6Id = ""
    var mPdfFile = ""
    var mIsAdditionSubject = false


    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Stream Selection")

    }

    override fun getLayoutID(): Int {

        return R.layout.fragment_stream_selection
    }

    override fun getViewModel(): Class<StreamSelectionViewModel> {

        return StreamSelectionViewModel::class.java

    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        dataBinding.streamSelectionViewModel = viewModel

        initObserver()

        val sdf = SimpleDateFormat("dd-MM-yyyy HH:mm")
        val sdf1 = SimpleDateFormat("dd-MM-yyyy | hh:mm a")


        val endDate = sdf.parse((mContext as DashboardActivity).mStreamEndDate)


        val date = sdf1.format(endDate)

        dataBinding.submissionDate.setText("Last date of submission: $date")

        dataBinding.textView3.setOnClickListener {
            try {
                try {
                    Utils.openPdf("Stream Selection", mPdfFile, mContext)

                } catch (e: ActivityNotFoundException) {
                    val uri = Uri.parse(mPdfFile)
                    // Chrome is probably not installed
                    // OR not selected as default browser OR if no Browser is selected as default browser
                    val i = Intent(Intent.ACTION_VIEW, uri)
                    i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(i)
                }
            } catch (ex: Exception) {

            }
        }

        dataBinding.btnUpdate.setOnClickListener {
            if (dataBinding.selectSubjectTextView1.text.toString() == "Select Subject") {
                showSuccessToast("Please select subject 1", mContext)
            } else if (dataBinding.selectSubjectTextView2.text.toString() == "Select Subject") {
                showSuccessToast("Please select subject 2", mContext)
            } else if (dataBinding.selectSubjectTextView3.text.toString() == "Select Subject") {
                showSuccessToast("Please select subject 3", mContext)
            } else if (dataBinding.selectSubjectTextView4.text.toString() == "Select Subject") {
                showSuccessToast("Please select subject 4", mContext)
            } else if (dataBinding.selectSubjectTextView5.text.toString() == "Select Subject") {
                showSuccessToast("Please select subject 5", mContext)
            } else {
                updateAPI()
            }


        }
        /* if ((mContext as DashboardActivity).mStreamSelectionData!!.data != null) {
             if (
                 (mContext as DashboardActivity).mStreamSelectionData!!.data!!.combinationId != null
             ) {

                 dataBinding.buttonLayout.visibility = View.GONE

                 dataBinding.combinationDropDown.setText((mContext as DashboardActivity).mStreamSelectionData!!.data?.combinationId!!.combinationName)


                 for (sub in (mContext as DashboardActivity).mStreamSelectionData!!.data?.combinationId?.subject1!!) {
                     if (sub!!.id!! == (mContext as DashboardActivity).mStreamSelectionData!!.data?.subject1) {
                         dataBinding.selectSubjectTextView1.setText(sub.subjectName)
                         dataBinding.selectSubjectTextView1.isFocusable = false;
                         dataBinding.selectSubjectTextView1.isFocusableInTouchMode = false;
                     }
                 }

                 for (sub in (mContext as DashboardActivity).mStreamSelectionData!!.data?.combinationId?.subject2!!) {
                     if (sub!!.id!! == (mContext as DashboardActivity).mStreamSelectionData!!.data?.subject2) {
                         dataBinding.selectSubjectTextView2.setText(sub.subjectName)
                         dataBinding.selectSubjectTextView2.isFocusable = false;
                         dataBinding.selectSubjectTextView2.isFocusableInTouchMode = false;
                     }
                 }

                 for (sub in (mContext as DashboardActivity).mStreamSelectionData!!.data?.combinationId?.subject3!!) {
                     if (sub!!.id!! == (mContext as DashboardActivity).mStreamSelectionData!!.data?.subject3) {
                         dataBinding.selectSubjectTextView3.setText(sub.subjectName)
                         dataBinding.selectSubjectTextView3.isFocusable = false;
                         dataBinding.selectSubjectTextView3.isFocusableInTouchMode = false;
                     }
                 }
                 for (sub in (mContext as DashboardActivity).mStreamSelectionData!!.data?.combinationId?.subject4!!) {
                     if (sub!!.id!! == (mContext as DashboardActivity).mStreamSelectionData!!.data?.subject4) {
                         dataBinding.selectSubjectTextView4.setText(sub.subjectName)
                         dataBinding.selectSubjectTextView4.isFocusable = false;
                         dataBinding.selectSubjectTextView4.isFocusableInTouchMode = false;
                     }
                 }
                 for (sub in (mContext as DashboardActivity).mStreamSelectionData!!.data?.combinationId?.subject5!!) {
                     if (sub!!.id!! == (mContext as DashboardActivity).mStreamSelectionData!!.data?.subject5) {
                         dataBinding.selectSubjectTextView5.setText(sub.subjectName)
                         dataBinding.selectSubjectTextView5.isFocusable = false;
                         dataBinding.selectSubjectTextView5.isFocusableInTouchMode = false;
                     }
                 }

                 for (sub in (mContext as DashboardActivity).mStreamSelectionData!!.data?.combinationId?.subject6!!) {
                     if (sub!!.id!! == (mContext as DashboardActivity).mStreamSelectionData!!.data?.subject6) {
                         dataBinding.selectSubjectTextView6.setText(sub.subjectName)
                         dataBinding.selectSubjectTextView6.isFocusable = false;
                         dataBinding.selectSubjectTextView6.isFocusableInTouchMode = false;
                     }
                 }

                 dataBinding.edtRemark.setText((mContext as DashboardActivity).mStreamSelectionData!!.data?.remark)
                 dataBinding.edtRemark.isFocusable = false;
                 dataBinding.edtRemark.isFocusableInTouchMode = false;

             }

         } else {
         }*/
        getStreamSelectionResponse()

    }

    private fun updateAPI() {


        val data = StreamSelectionPostData(
            mCombinationId,
            dataBinding.selectSubjectTextView6.text.toString() != "Select Subject",
            dataBinding.edtRemark.text.toString(),
            Utils.getStudentID(mContext),
            mSubject1Id,
            mSubject2Id,
            mSubject3Id,
            mSubject4Id,
            mSubject5Id,
            mSubject6Id

        )

        (mContext as DashboardActivity).showProgress()
        viewModel.callUpdateStreamSelection(
            requireContext(), Utils.getAccessToken(mContext), data
        )

    }

    private fun initObserver() {

        viewModel.liveDataNetworkError.observe(viewLifecycleOwner, observerError)
        viewModel.liveDataStreamSelection.observe(viewLifecycleOwner, observerGetSelfAwareness)
        viewModel.liveDataUpdateStreamSelection.observe(
            viewLifecycleOwner, observerUpdateStreamSelectionResponse
        )


    }


    private fun getStreamSelectionResponse() {
        (mContext as DashboardActivity).showProgress()
        viewModel.callGetStreamSelection(
            requireContext(),
            Utils.getAccessToken(mContext),
            (mContext as DashboardActivity).mBranchCodeForStreamSelection,
            Utils.getYearSession(mContext)
        )
    }

    private val observerGetSelfAwareness =
        Observer<ResponseStatus<StreamSelectionResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {

                    mPdfFile = responseStatus.response.eligibilityCriteria.toString()
                    dataBinding.edtRemark.setText((mContext as DashboardActivity).mStreamSelectionData!!.data?.remark)
                    updateUi(responseStatus.response.data!!)

                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }


    private val observerUpdateStreamSelectionResponse =
        Observer<ResponseStatus<CommonResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {
                    (mContext as DashboardActivity).supportFragmentManager.popBackStack()
                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }

    override val observerError = Observer<ResponseStatusError> {
        (mContext as DashboardActivity).hideProgress()

        when (it) {

            is ResponseStatusError.NoInternetError -> {
                showSuccessToast(getString(R.string.check_internet_connection), requireContext())
            }

            is ResponseStatusError.TechnicalError -> {
                showSuccessToast(it.errorMessageCode.toString(), requireContext())
            }

            is ResponseStatusError.ErrorResponseError -> {
            }
        }
    }

    private fun updateUi(response: List<StreamSelectionResponse.Data?>) {
        val combinationList: MutableList<String> = ArrayList()
        val combinationListId: MutableList<String> = ArrayList()

        for (data in response) {
            combinationList.add(data!!.combinationName.toString())
            combinationListId.add(data.id.toString())
        }
        val adapter: ArrayAdapter<String> = ArrayAdapter(
            mContext, android.R.layout.simple_list_item_1, android.R.id.text1, combinationList
        )

        dataBinding.combinationDropDown.setAdapter(adapter)


        if ((mContext as DashboardActivity).mStreamSelectionData!!.data != null) {

            if ((mContext as DashboardActivity).mStreamSelectionData!!.data?.combinationId != null) {

                for ((index, item) in combinationList.withIndex()) {
                    if (item.equals((mContext as DashboardActivity).mStreamSelectionData!!.data?.combinationId!!.combinationName)) {
                        dataBinding.combinationDropDown.setText(
                            dataBinding.combinationDropDown.adapter.getItem(index).toString(), false
                        )
                        mCombinationId =
                            (mContext as DashboardActivity).mStreamSelectionData!!.data?.combinationId!!.id.toString()

                        updateData(response[index], false)

                    }

                }
            } else {
                mCombinationId = combinationListId[0]

                dataBinding.combinationDropDown.setText(
                    dataBinding.combinationDropDown.adapter.getItem(0).toString(), false
                )

                updateData(response[0],false)

            }
        } else {
            mCombinationId = combinationListId[0]

            dataBinding.combinationDropDown.setText(
                dataBinding.combinationDropDown.adapter.getItem(0).toString(), false
            )

            updateData(response[0],false)

        }




        mAdapterList.addAll(response)


        dataBinding.combinationDropDown.setOnItemClickListener { _, _, position, _ ->

            updateData(response[position] , true)

            mCombinationId = combinationListId[position]
            dataBinding.edtRemark.setText("")

        }


    }

    private fun updateData(data: StreamSelectionResponse.Data?, isUpdate: Boolean) {


        dataBinding.selectSubjectTextView1.text = null
        dataBinding.selectSubjectTextView2.text = null
        dataBinding.selectSubjectTextView3.text = null
        dataBinding.selectSubjectTextView4.text = null
        dataBinding.selectSubjectTextView5.text = null
        dataBinding.selectSubjectTextView6.text = null

        updateDataForSubject1(data!!.subject1,isUpdate)
        updateDataForSubject2(data.subject2,isUpdate)
        updateDataForSubject3(data.subject3,isUpdate)
        updateDataForSubject4(data.subject4,isUpdate)
        updateDataForSubject5(data.subject5,isUpdate)
        updateDataForSubject6(data.subject6,isUpdate)

    }

    private fun updateDataForSubject6(
        subject6: List<StreamSelectionResponse.Data.Subject6?>?,
        isUpdate: Boolean
    ) {
        val combinationList = ArrayList<String>()
        val combinationListId = ArrayList<String>()
        combinationList.add("Select Subject")
        combinationListId.add("0")
        for (value in subject6!!) {
            combinationList.add(value!!.subjectName!!)
            combinationListId.add(value.id!!)
        }
        val adapter: ArrayAdapter<String> = ArrayAdapter(
            mContext /*context*/,
            android.R.layout.simple_list_item_1,
            android.R.id.text1,
            combinationList
        )

        dataBinding.selectSubjectTextView6.setAdapter(adapter)

        if ((mContext as DashboardActivity).mStreamSelectionData!!.data != null && !isUpdate) {

            if ((mContext as DashboardActivity).mStreamSelectionData!!.data?.subject6 != null) {
                for ((index, item) in combinationListId.withIndex()) {
                    if (item == (mContext as DashboardActivity).mStreamSelectionData!!.data?.subject6
                    ) {
                        dataBinding.selectSubjectTextView6.setText(
                            dataBinding.selectSubjectTextView6.adapter.getItem(index).toString(),
                            false
                        )
                        mSubject6Id = combinationListId[index]
                    }
                }
            } else {
                dataBinding.selectSubjectTextView6.setText(
                    dataBinding.selectSubjectTextView6.adapter.getItem(0).toString(), false
                )
            }
        } else {
            dataBinding.selectSubjectTextView6.setText(
                dataBinding.selectSubjectTextView6.adapter.getItem(0).toString(), false
            )
        }


        dataBinding.selectSubjectTextView6.setOnItemClickListener { _, _, pos, _ ->
            mSubject6Id = combinationListId[pos]

        }
    }

    private fun updateDataForSubject5(
        subject5: List<StreamSelectionResponse.Data.Subject5?>?,
        isUpdate: Boolean
    ) {

        val combinationList = ArrayList<String>()
        val combinationListId = ArrayList<String>()
        combinationList.add("Select Subject")
        combinationListId.add("0")

        for (value in subject5!!) {
            combinationList.add(value!!.subjectName!!)
            combinationListId.add(value.id!!)
        }
        val adapter: ArrayAdapter<String> = ArrayAdapter(
            mContext /*context*/,
            android.R.layout.simple_list_item_1,
            android.R.id.text1,
            combinationList
        )

        dataBinding.selectSubjectTextView5.setAdapter(adapter)

        if ((mContext as DashboardActivity).mStreamSelectionData!!.data != null && !isUpdate ) {

            if ((mContext as DashboardActivity).mStreamSelectionData!!.data?.subject5 != null) {
                for ((index, item) in combinationListId.withIndex()) {
                    if (item == (mContext as DashboardActivity).mStreamSelectionData!!.data?.subject5
                    ) {
                        dataBinding.selectSubjectTextView5.setText(
                            dataBinding.selectSubjectTextView5.adapter.getItem(index).toString(),
                            false
                        )
                        mSubject5Id = combinationListId[index]
                    }
                }
            } else {
                dataBinding.selectSubjectTextView5.setText(
                    dataBinding.selectSubjectTextView5.adapter.getItem(0).toString(), false
                )
            }
        } else {
            dataBinding.selectSubjectTextView5.setText(
                dataBinding.selectSubjectTextView5.adapter.getItem(0).toString(), false
            )
        }


        dataBinding.selectSubjectTextView5.setOnItemClickListener { _, _, pos, _ ->
            mSubject5Id = combinationListId[pos]

        }
    }

    private fun updateDataForSubject4(
        subject4: List<StreamSelectionResponse.Data.Subject4?>?,
        isUpdate: Boolean
    ) {
        val combinationList = ArrayList<String>()
        val combinationListId = ArrayList<String>()
        combinationList.add("Select Subject")
        combinationListId.add("0")

        for (value in subject4!!) {
            combinationList.add(value!!.subjectName!!)
            combinationListId.add(value.id!!)
        }
        val adapter: ArrayAdapter<String> = ArrayAdapter(
            mContext /*context*/,
            android.R.layout.simple_list_item_1,
            android.R.id.text1,
            combinationList
        )

        dataBinding.selectSubjectTextView4.setAdapter(adapter)

        if ((mContext as DashboardActivity).mStreamSelectionData!!.data != null && !isUpdate ) {

            if ((mContext as DashboardActivity).mStreamSelectionData!!.data?.subject4 != null) {
                for ((index, item) in combinationListId.withIndex()) {
                    if (item == (mContext as DashboardActivity).mStreamSelectionData!!.data?.subject4
                    ) {
                        dataBinding.selectSubjectTextView4.setText(
                            dataBinding.selectSubjectTextView4.adapter.getItem(index).toString(),
                            false
                        )
                        mSubject4Id = combinationListId[index]
                    }
                }
            } else {
                dataBinding.selectSubjectTextView4.setText(
                    dataBinding.selectSubjectTextView4.adapter.getItem(0).toString(), false
                );
            }
        } else {
            dataBinding.selectSubjectTextView4.setText(
                dataBinding.selectSubjectTextView4.adapter.getItem(0).toString(), false
            );
        }

        dataBinding.selectSubjectTextView4.setOnItemClickListener { _, _, pos, _ ->
            mSubject4Id = combinationListId[pos]

        }
    }

    private fun updateDataForSubject3(
        subject3: List<StreamSelectionResponse.Data.Subject3?>?,
        isUpdate: Boolean
    ) {
        val combinationList = ArrayList<String>()
        val combinationListId = ArrayList<String>()
        combinationList.add("Select Subject")
        combinationListId.add("0")

        for (value in subject3!!) {
            combinationList.add(value!!.subjectName!!)
            combinationListId.add(value.id!!)
        }
        val adapter: ArrayAdapter<String> = ArrayAdapter(
            mContext /*context*/,
            android.R.layout.simple_list_item_1,
            android.R.id.text1,
            combinationList
        )

        dataBinding.selectSubjectTextView3.setAdapter(adapter)

        if ((mContext as DashboardActivity).mStreamSelectionData!!.data != null && !isUpdate) {

            if ((mContext as DashboardActivity).mStreamSelectionData!!.data?.subject3 != null) {
                for ((index, item) in combinationListId.withIndex()) {
                    if (item == (mContext as DashboardActivity).mStreamSelectionData!!.data?.subject3
                    ) {
                        dataBinding.selectSubjectTextView3.setText(
                            dataBinding.selectSubjectTextView3.adapter.getItem(index).toString(),
                            false
                        )
                        mSubject3Id = combinationListId[index]
                    }
                }
            } else {

                dataBinding.selectSubjectTextView3.setText(
                    dataBinding.selectSubjectTextView3.adapter.getItem(0).toString(), false
                );

            }
        } else {

            dataBinding.selectSubjectTextView3.setText(
                dataBinding.selectSubjectTextView3.adapter.getItem(0).toString(), false
            );

        }
        dataBinding.selectSubjectTextView3.setOnItemClickListener { _, _, pos, _ ->
            mSubject3Id = combinationListId[pos]

        }
    }

    private fun updateDataForSubject2(
        subject2: List<StreamSelectionResponse.Data.Subject2?>?,
        isUpdate: Boolean
    ) {

        val combinationList = ArrayList<String>()
        val combinationListId = ArrayList<String>()
        combinationList.add("Select Subject")
        combinationListId.add("0")

        for (value in subject2!!) {
            combinationList.add(value!!.subjectName!!)
            combinationListId.add(value.id!!)
        }
        val adapter: ArrayAdapter<String> = ArrayAdapter(
            mContext /*context*/,
            android.R.layout.simple_list_item_1,
            android.R.id.text1,
            combinationList
        )

        dataBinding.selectSubjectTextView2.setAdapter(adapter)


        if ((mContext as DashboardActivity).mStreamSelectionData!!.data != null && !isUpdate) {

            if ((mContext as DashboardActivity).mStreamSelectionData!!.data?.subject2 != null) {
                for ((index, item) in combinationListId.withIndex()) {
                    if (item == (mContext as DashboardActivity).mStreamSelectionData!!.data?.subject2
                    ) {
                        dataBinding.selectSubjectTextView2.setText(
                            dataBinding.selectSubjectTextView2.adapter.getItem(index).toString(),
                            false
                        )
                        mSubject2Id = combinationListId[index]
                    }
                }
            } else {
                dataBinding.selectSubjectTextView2.setText(
                    dataBinding.selectSubjectTextView2.adapter.getItem(0).toString(), false
                );
            }
        } else {
            dataBinding.selectSubjectTextView2.setText(
                dataBinding.selectSubjectTextView2.adapter.getItem(0).toString(), false
            )
        }

        dataBinding.selectSubjectTextView2.setOnItemClickListener { _, _, pos, _ ->
            mSubject2Id = combinationListId[pos]

        }
    }

    private fun updateDataForSubject1(
        subject1: List<StreamSelectionResponse.Data.Subject1?>?,
        isUpdate: Boolean
    ) {

        val combinationList = ArrayList<String>()
        val combinationListId = ArrayList<String>()
        combinationList.add("Select Subject")
        combinationListId.add("0")

        for (value in subject1!!) {
            combinationList.add(value!!.subjectName!!)
            combinationListId.add(value.id!!)
        }
        val adapter: ArrayAdapter<String> = ArrayAdapter(
            mContext /*context*/,
            android.R.layout.simple_list_item_1,
            android.R.id.text1,
            combinationList
        )

        dataBinding.selectSubjectTextView1.setAdapter(adapter)



        if ((mContext as DashboardActivity).mStreamSelectionData!!.data != null && !isUpdate ) {

            if ((mContext as DashboardActivity).mStreamSelectionData!!.data?.subject1 != null) {
                for ((index, item) in combinationListId.withIndex()) {
                    if (item == (mContext as DashboardActivity).mStreamSelectionData!!.data?.subject1
                    ) {
                        dataBinding.selectSubjectTextView1.setText(
                            dataBinding.selectSubjectTextView1.adapter.getItem(index).toString(),
                            false
                        )
                        mSubject1Id = combinationListId[index]
                    }
                }
            } else {
                dataBinding.selectSubjectTextView1.setText(
                    dataBinding.selectSubjectTextView1.adapter.getItem(0).toString(), false
                );
            }
        } else {
            dataBinding.selectSubjectTextView1.setText(
                dataBinding.selectSubjectTextView1.adapter.getItem(0).toString(), false
            );

        }

        dataBinding.selectSubjectTextView1.setOnItemClickListener { _, _, pos, _ ->
            mSubject1Id = combinationListId[pos]

        }

    }


}