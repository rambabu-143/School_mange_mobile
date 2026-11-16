package com.mountcarmelschools.ui.assignment

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import com.mountcarmelschools.di.loginData.LoginResponse
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseRecyclerAdapter
import com.mountcarmelschools.databinding.RowSubjectBinding
import com.mountcarmelschools.di.data.assignment.AssignementForAdapter
import com.mountcarmelschools.utlis.Utils


class AssignmentAdapter(
    private val mContext: Context,
    val subjectList: List<AssignementForAdapter?>?,
    val path: String,
    val from: String
) :
    BaseRecyclerAdapter<LoginResponse, RowSubjectBinding>() {


    override fun getItemCount(): Int {
        return subjectList?.size!!
    }

    override fun onBindViewHolder(
        holder: Companion.BaseViewHolder<RowSubjectBinding>,
        position: Int
    ) {
        dataBinding.tvSubject.text = subjectList?.get(position)!!.subjectName
        dataBinding.tvDate.text = Utils.formattedDateFromString(
            "",
            "dd-MM-yyyy",
            subjectList.get(position)!!.date
        )

        dataBinding.parentLayout.setOnClickListener {
            try {
                try {
                    Utils.openPdf(from, path + subjectList.get(position)!!.attachments, mContext)

                } catch (e: ActivityNotFoundException) {
                    val uri = Uri.parse(path + subjectList.get(position)!!.attachments)
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

    override fun getLayoutInflater() = R.layout.row_subject

}
