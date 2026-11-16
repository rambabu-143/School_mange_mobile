package com.mountcarmelschools.ui.dashboard

import android.content.Context
import androidx.core.content.ContextCompat
import com.mountcarmelschools.di.loginData.LoginResponse
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseRecyclerAdapter
import com.mountcarmelschools.databinding.RowNavigationBinding
import com.mountcarmelschools.utlis.Utils

class DashboardNavigationAdapter(
    private val mContext: Context,
    private val mHashMap: LinkedHashMap<String, Int>,
    private val listener: DashboardNavigator

) :
    BaseRecyclerAdapter<LoginResponse, RowNavigationBinding>() {


    override fun getItemCount(): Int {
        return mHashMap.size
    }

    override fun onBindViewHolder(
        holder: Companion.BaseViewHolder<RowNavigationBinding>,
        position: Int
    ) {
        if (Utils.getUserType(mContext).equals("2") || Utils.getUserType(mContext)
                .equals("3") || Utils.getUserType(mContext).equals("4")
        ) {
            dataBinding.parentLayout.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.white
                )
            )
        }
        dataBinding.tvMsgLabel.text = mHashMap.keys.elementAt(position)
        dataBinding.ivImages.setImageResource(mHashMap.getValue(mHashMap.keys.elementAt(position)))
        dataBinding.parentLayout.setOnClickListener {

            listener.itemClick(position, mHashMap.keys.elementAt(position))
        }
    }

    override fun getLayoutInflater() = R.layout.row_navigation

    fun click(position: Int) {
    }
}
