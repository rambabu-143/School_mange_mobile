package com.mountcarmelschools.ui.holidayHomework

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import com.mountcarmelschools.di.loginData.LoginResponse
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseRecyclerAdapter
import com.mountcarmelschools.databinding.AdapterNoticeBinding
import com.mountcarmelschools.di.data.holidayHomeWork.HolidayHomeWorkResponse
import com.mountcarmelschools.utlis.Utils

class HolidayHomeWorkAdapter(
        private val mContext: Context,
        private val list: List<HolidayHomeWorkResponse.Data?>?,
        private val mPath: String
) :
    BaseRecyclerAdapter<LoginResponse, AdapterNoticeBinding>() {

    override fun getItemCount(): Int {
        return list?.size!!
    }

    override fun onBindViewHolder(
        holder: Companion.BaseViewHolder<AdapterNoticeBinding>,
        position: Int
    ) {

        dataBinding.title.text = list?.get(position)?.title
        dataBinding.date.text = Utils.formattedDateFromString(
            "", "dd-MM-yyyy '|' hh:mm a",
            list?.get(position)?.createdAt
        )
        dataBinding.parentLayout.setOnClickListener {

            try {
                try {
                    /*    val uri = Uri.parse("googlechrome://navigate?url=" + mPath + "/" + (list?.get(position)!!.attachments?.get(0)!!))
                        val i = Intent(Intent.ACTION_VIEW, uri)
                        i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        mContext.startActivity(i)*/

                    Utils.openPdf(
                        "Holiday Homework",
                        "$mPath/" + (list?.get(position)!!.attachments?.get(0)!!),
                        mContext
                    )

                } catch (e: ActivityNotFoundException) {
                    val uri = Uri.parse(mPath + "/" + (list?.get(position)!!.attachments?.get(0)!!))
                    // Chrome is probably not installed
                    // OR not selected as default browser OR if no Browser is selected as default browser
                    val i = Intent(Intent.ACTION_VIEW, uri)
                    i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    mContext.startActivity(i)
                }
            } catch (ex: Exception) {

            }
        }


    }

    override fun getLayoutInflater() = R.layout.adapter_notice

}
