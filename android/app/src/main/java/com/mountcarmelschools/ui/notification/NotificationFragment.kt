package com.mountcarmelschools.ui.notification

import android.app.Dialog
import android.content.Context
import android.os.Bundle
import android.view.ViewGroup
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentNotificationBinding
import com.mountcarmelschools.di.data.notificationHistory.NotificationPostData
import com.mountcarmelschools.di.data.notificationHistory.StaffNotificationHistoryResponse
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils

class NotificationFragment : BaseFragment<FragmentNotificationBinding, NotificationViewModel>(),
    NotificationInterface {

    companion object {
        fun newInstance() = NotificationFragment()
    }

    private lateinit var mContext: Context

    lateinit var notificationAdapter: NotificationAdapter

    var responseList = ArrayList<StaffNotificationHistoryResponse.Data?>()

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun getLayoutID() = R.layout.fragment_notification

    override fun getViewModel() = NotificationViewModel::class.java


    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        val userType = Utils.getUserType(mContext)

        if (userType.equals("1")) {

            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.blue_background
                )
            )
            getStudentNotificationHistory()
        } else if (userType.equals("2") || userType.equals("3")) {
            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.fourth_background
                )
            )
            getStudentNotificationHistory()

        } else {
            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.parent_background
                )
            )

            getStaffNotificationHistory()
        }
        settingSearchRecyclerView()


    }

    private fun getStaffNotificationHistory() {

        (mContext as DashboardActivity).showProgress()
        viewModel.getNotificationListForStaff(
            Utils.getAccessToken(mContext),
            Utils.getUserId(mContext)
        ).observe(
            viewLifecycleOwner, androidx.lifecycle.Observer {
                (mContext as DashboardActivity).hideProgress()

                if (it.status!!) {

                    if (it.data != null) {

                        responseList.addAll(it.data)

                        /*    dataBinding.rvNotificationList.adapter =
                                NotificationAdapter(mContext!!, it.data, this)*/
                        notificationAdapter.updateData(it.data)

                    }
                } else {
                    showErrorToast(it.message!!, mContext)

                }

            }
        )
    }


    private fun getStudentNotificationHistory() {

        (mContext as DashboardActivity).showProgress()
        viewModel.getStudentListNotification(
            Utils.getAccessToken(mContext),
            Utils.getUserId(mContext)
        ).observe(
            viewLifecycleOwner, androidx.lifecycle.Observer {
                (mContext as DashboardActivity).hideProgress()

                if (it.status!!) {
                    if (it.data != null) {

                        responseList.addAll(it.data)
                        /*  dataBinding.rvNotificationList.adapter =
                              NotificationAdapter(mContext!!, it.data, this)*/
                        notificationAdapter.updateData(it.data)
                    }
                } else {
                    showErrorToast(it.message!!, mContext)

                }


            }
        )
    }


    private fun settingSearchRecyclerView() {
        responseList = ArrayList()
        dataBinding.rvNotificationList.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        dataBinding.rvNotificationList.hasFixedSize()
        notificationAdapter = NotificationAdapter(mContext!!, ArrayList(), this)
        dataBinding.rvNotificationList.adapter = notificationAdapter


    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Notification")

    }

    override fun showDialog(data: StaffNotificationHistoryResponse.Data?) {

        val dialog = Dialog(mContext)
        dialog.setContentView(R.layout.dialog_message)

        dialog.show()
        var textView = dialog.findViewById<TextView>(R.id.text);
        var date = dialog.findViewById<TextView>(R.id.date);

        textView.text = data!!.smsText

        date.text = Utils.formattedDateFromString(
            "", "dd-MM-yyyy '|' hh:mm a",
            data.createdAt
        )

        val window = dialog.window!!

        window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)

        for (i in 0..responseList.size - 1) {

            if (responseList.get(i)!!.equals(data)) {


                if (responseList.get(i)!!.notifications != null && responseList.get(i)!!.notifications!!.size > 0) {

                    responseList.get(i)!!.notifications[0]!!.readFlag = true
                } else {
                    responseList.get(i)!!.notifications = listOf(
                        StaffNotificationHistoryResponse.Data.Notification(
                            true, listOf(), "", "", ""
                        )
                    )
                }

            }


        }

        if (Utils.getUserType(mContext).equals("4")) {

            updateStaffNotification(data.id.toString())

        } else {

            updateStudentNotification(data.id.toString())

        }

    }


    private fun updateStudentNotification(id: String) {

        var notificationPostData = NotificationPostData(true)
        viewModel.updateStudentNotification(
            Utils.getAccessToken(mContext), id,
            Utils.getUserId(mContext), notificationPostData
        ).observe(
            viewLifecycleOwner, androidx.lifecycle.Observer {

                if (it.status!!) {
                    notificationAdapter.updateData(responseList)
                    updateNotificationCount()


                } else {
                    showErrorToast(it.message!!, mContext)

                }
            }
        )
    }

    private fun updateStaffNotification(id: String) {

        var notificationPostData = NotificationPostData(true)
        viewModel.updateStaffNotification(
            Utils.getAccessToken(mContext), id,
            Utils.getUserId(mContext), notificationPostData
        ).observe(
            viewLifecycleOwner, androidx.lifecycle.Observer {

                if (it.status!!) {
                    notificationAdapter.updateData(responseList)
                    updateNotificationCount()
                } else {
                    showErrorToast(it.message!!, mContext)

                }
            }
        )
    }


    fun updateNotificationCount() {
        if (mContext is DashboardActivity) {

            if (Utils.isStaff(mContext)) {
                (mContext as DashboardActivity).getNotificationCount()
            } else {
                (mContext as DashboardActivity).getStudentNotificationCount()
            }
        }

    }

}
