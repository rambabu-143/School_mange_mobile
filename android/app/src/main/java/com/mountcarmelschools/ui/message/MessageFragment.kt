package com.mountcarmelschools.ui.message

import android.app.Dialog
import android.content.Context
import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentMessageBinding
import com.mountcarmelschools.di.data.notificationHistory.NotificationPostData
import com.mountcarmelschools.di.data.staff.sms.SmsResponse
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils

class MessageFragment : BaseFragment<FragmentMessageBinding, MessageFragmentViewModel>(),
    MessageInterface {
    override fun getLayoutID(): Int {
        return R.layout.fragment_message
    }

    lateinit var mContext: Context
    lateinit var messageAdapter: MessageAdapter

    var responseList = ArrayList<SmsResponse.Data?>()

    override fun getViewModel(): Class<MessageFragmentViewModel> {

        return MessageFragmentViewModel::class.java
    }

    companion object {
        fun newInstance() = MessageFragment()
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        settingSearchRecyclerView()

        val userType = Utils.getUserType(mContext)

        if (userType.equals("1")) {

            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.blue_background
                )
            )
            getMessageDetailForStudent()
        } else if (userType.equals("2") || userType.equals("3")) {
            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.fourth_background
                )
            )
            getMessageDetailForStudent()
        } else {
            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.parent_background
                )
            )
            getMessageDetail()

        }
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Messages")

    }

    private fun settingSearchRecyclerView() {
        responseList = ArrayList()

        dataBinding.recyclerView.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        dataBinding.recyclerView.hasFixedSize()
        messageAdapter = MessageAdapter(mContext, ArrayList(), this)
        dataBinding.recyclerView.adapter = messageAdapter
    }

    private fun getMessageDetail() {

        (mContext as DashboardActivity).showProgress()

        viewModel.getMessageDetail(Utils.getAccessToken(mContext), Utils.getUserId(mContext))
            .observe(

                viewLifecycleOwner, Observer {
                    (mContext as DashboardActivity).hideProgress()
                    /*   dataBinding.recyclerView.adapter =
                           MessageAdapter(mContext, it.data, this)*/

                    if (it.status!!) {

                        responseList.addAll(it.data!!)
                        messageAdapter.updateData(it.data!!)
                    } else {
                        showErrorToast(it.message!!, mContext)

                    }

                })
    }


    private fun getMessageDetailForStudent() {

        (mContext as DashboardActivity).showProgress()

        viewModel.getMessageDetailForStudent(
            Utils.getAccessToken(mContext),
            Utils.getUserId(mContext),
            Utils.getSectionId(mContext)
        )
            .observe(

                viewLifecycleOwner, Observer {
                    (mContext as DashboardActivity).hideProgress()


                    if (it.status!!) {

                        responseList.addAll(it.data!!)

                        messageAdapter.updateData(it.data!!)


                    } else {

                        showErrorToast(it.message!!, mContext)
                    }
                })
    }

    private fun showDialog() {


    }

    override fun showDialog(data: SmsResponse.Data?) {
        val dialog = Dialog(mContext)
        dialog.setContentView(R.layout.dialog_message)

        dialog.show()
        val textView = dialog.findViewById<TextView>(R.id.text);
        val date = dialog.findViewById<TextView>(R.id.date);

        textView.text = data!!.smsText

        date.text = Utils.formattedDateFromString(
            "", "dd-MM-yyyy '|' hh:mm a",
            data?.createdAt

        )

        val window = dialog.window!!

        window!!.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)



        for (i in 0..responseList.size - 1) {

            if (responseList.get(i)!!.equals(data)) {

                if (responseList.get(i)!!.mobiles != null && responseList.get(i)!!.mobiles.size > 0) {

                    responseList.get(i)!!.mobiles[0]!!.readFlag = true
                } else {
                    responseList.get(i)!!.mobiles =
                        listOf(SmsResponse.Data.Mobile(true, "", "", ""))
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

                messageAdapter.updateData(responseList)

               // updateNotificationCount()

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

                messageAdapter.updateData(responseList)
              //  updateNotificationCount()
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
