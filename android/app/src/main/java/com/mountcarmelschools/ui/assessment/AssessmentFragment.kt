package com.mountcarmelschools.ui.assessment

import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.TextUtils
import android.view.View
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.lifecycle.Observer
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentAssessmentBinding
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.ui.notice.NoticeAdapterForStudent
import com.mountcarmelschools.utlis.Utils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import java.io.BufferedInputStream
import java.net.HttpURLConnection
import java.net.URL


class AssessmentFragment : BaseFragment<FragmentAssessmentBinding, AssessmentViewModel>() {


    private lateinit var mContext: Context


    companion object {
        fun newInstance() = AssessmentFragment()
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }


    override fun getLayoutID() = R.layout.fragment_assessment


    override fun getViewModel() = AssessmentViewModel::class.java


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {

        super.onViewCreated(view, savedInstanceState)


        val userType = Utils.getUserType(mContext)

        (mContext as DashboardActivity).setHeaderText(arguments?.getString("from"))


        if (userType.equals("1")) {

            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.blue_background
                )
            )
        } else if (userType.equals("2") || userType.equals("3")) {
            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.fourth_background
                )
            )

        } else
            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.parent_background
                )
            )

        if (arguments?.getString("from").equals("Date Sheet")) {
            getDateSheet()
            dataBinding.mainLayout.visibility = View.GONE
            dataBinding.recyclerView.visibility = View.VISIBLE

        }else if (arguments?.getString("from").equals("NewsLetter") || arguments?.getString("from").equals("Chronicles") ) {
            dataBinding.mainLayout.visibility = View.VISIBLE
            dataBinding.recyclerView.visibility = View.GONE

            setPDF(arguments?.getString("data").toString())

        }else {
            dataBinding.mainLayout.visibility = View.VISIBLE
            dataBinding.recyclerView.visibility = View.GONE

            getAssessmentRecord()
        }
        settingStudentListRecyclerView()
    }

    private fun getDateSheet() {


        viewModel.getDateSheet(Utils.getAccessToken(mContext), Utils.getUserId(mContext)).observe(

            viewLifecycleOwner, Observer {
                dataBinding.progressBar.visibility = View.GONE

                if (it.status!! && it.data != null) {
                    if (it.status) {

                        val noticeAdapter = NoticeAdapterForStudent(mContext, it.data, it.path!!)

                        dataBinding.recyclerView.adapter = noticeAdapter
                    } else {

                        showErrorToast(it.message!!, mContext)

                    }
                } else {
                    showErrorToast(it.message!!, mContext)
                }
            }
        )

    }


    private fun getAssessmentRecord() {


        viewModel.getAssessment(Utils.getAccessToken(mContext), Utils.getUserId(mContext)).observe(

            viewLifecycleOwner, Observer {

                dataBinding.progressBar.visibility = View.GONE

                if (it.status!! && it.data != null) {
                    if (!TextUtils.isEmpty(it.data!!.assessmentRecord)) {


                        setPDF(it.data.assessmentRecord!!)

                    } else
                        showErrorToast(it.message!!, mContext)
                } else {
                    showErrorToast(it.message!!, mContext)
                }
            }
        )


    }


    private fun settingStudentListRecyclerView() {
        dataBinding.recyclerView.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        dataBinding.recyclerView.hasFixedSize()

    }


    private fun setPDF(assessmentRecord: String) {
        CoroutineScope(Job()).launch(Dispatchers.IO) {
            val url = URL(assessmentRecord)
            val connection = url.openConnection() as HttpURLConnection
            if (connection.responseCode == 200) {
                val inputStream = BufferedInputStream(connection.inputStream)
                lifecycleScope.launch {
                    dataBinding.pdfView.fromStream(inputStream)
                        .onLoad {
                            Handler(Looper.getMainLooper()).post {
                                dataBinding.progressBar.visibility = View.GONE
                            }
                        }
                        .onError{ error ->
                            Handler(Looper.getMainLooper()).post {
                                dataBinding.progressBar.visibility = View.GONE

                                Toast.makeText(context, "Error: ${error.message}", Toast.LENGTH_SHORT).show()
                            }
                        }
                        .load()
                }
            }
            else{

                Handler(Looper.getMainLooper()).post {
                    dataBinding.progressBar.visibility = View.GONE

                    Toast.makeText(context, "Invalid Pdf", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }

}