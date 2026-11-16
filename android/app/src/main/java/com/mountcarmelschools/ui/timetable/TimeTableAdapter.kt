package com.mountcarmelschools.ui.timetable

import android.content.Context
import androidx.core.content.ContextCompat
import com.mountcarmelschools.di.loginData.LoginResponse
import com.mountcarmelschools.base.BaseRecyclerAdapter
import com.mountcarmelschools.databinding.RowTimeTableBinding
import com.mountcarmelschools.di.data.timeTable.CustomTimeTableResponse
import com.mountcarmelschools.utlis.Utils
import com.mountcarmelschools.R

class TimeTableAdapter(
    private val mContext: Context,

    private val list: List<CustomTimeTableResponse>
) :
    BaseRecyclerAdapter<LoginResponse, RowTimeTableBinding>() {

    override fun getLayoutInflater() = R.layout.row_time_table

    override fun getItemCount(): Int {
        return list.size
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun getItemViewType(position: Int): Int {
        return position
    }

    override fun onBindViewHolder(
        holder: Companion.BaseViewHolder<RowTimeTableBinding>,
        position: Int
    ) {
        if (list.get(position).subject.equals("Morning Assembly")) {
            dataBinding.cvType.background =
                ContextCompat.getDrawable(mContext, R.drawable.blue_time_table_background)
            dataBinding.tvPeriod.text = "M"
        } else if (list.get(position).subject.equals("Lunch Break")) {
            dataBinding.cvType.background =
                ContextCompat.getDrawable(mContext, R.drawable.yellow_background)
            dataBinding.tvPeriod.text = "L"
        } else {
            dataBinding.tvPeriod.text = "$position"
        }

        dataBinding.tvSubject.text = list.get(position).subject
        dataBinding.time.text = list.get(position).startTime + " - " + list.get(position).endTime






        if (Utils.getUserType(mContext).equals(
                "1",
                true
            )
        ) {

            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.blue_background
                )
            )
        }

    }

}
