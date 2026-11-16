package com.mountcarmelschools.ui.calendar

import android.content.Context
import androidx.core.content.ContextCompat
import com.mountcarmelschools.di.loginData.LoginResponse
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseRecyclerAdapter
import com.mountcarmelschools.databinding.RowSchoolEventBinding

class SchoolEventAdapter(
    private val mContext: Context,
    private val dateString: ArrayList<String>,
    private val name: ArrayList<String>,
    private val color: ArrayList<Int>
) :
    BaseRecyclerAdapter<LoginResponse, RowSchoolEventBinding>() {


    override fun getItemCount(): Int {
        return dateString.size
    }

    override fun onBindViewHolder(
        holder: Companion.BaseViewHolder<RowSchoolEventBinding>,
        position: Int
    ) {
        dataBinding.date.text = dateString.get(position)

        dataBinding.tvEventType.text = name.get(position)

        dataBinding.date.setTextColor(ContextCompat.getColor(mContext,color.get(position)))

    }

    override fun getLayoutInflater() = R.layout.row_school_event

}
