package com.mountcarmelschools.ui.timetable

import android.annotation.SuppressLint
import android.content.Context
import android.view.View
import com.mountcarmelschools.di.loginData.LoginResponse
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseRecyclerAdapter
import com.mountcarmelschools.databinding.RowDayBinding

class DaysAdapter(
    private val mContext: Context,
    private val day: Array<String>,
    private var selectedPosition: Int,

    private val mInterface: TimeTableInterface

) :
    BaseRecyclerAdapter<LoginResponse, RowDayBinding>() {


    override fun getItemCount(): Int {
        return day.size

    }

    @SuppressLint("ResourceAsColor")
    override fun onBindViewHolder(
        holder: Companion.BaseViewHolder<RowDayBinding>,
        position: Int
    ) {

        dataBinding.parentLayout.setOnClickListener {
            mInterface.selectedValue(position)

        }
        dataBinding.tvDay.text = day[position]

        if (selectedPosition == position) {

            dataBinding.textView.visibility = View.VISIBLE
        } else {
            dataBinding.textView.visibility = View.GONE

        }
    }

    override fun getLayoutInflater() = R.layout.row_day


}
