package com.mountcarmelschools.ui.childList

import android.annotation.SuppressLint
import android.content.Context
import com.mountcarmelschools.di.loginData.LoginResponse
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseRecyclerAdapter
import com.mountcarmelschools.databinding.AdapterChildViewBinding
import com.mountcarmelschools.di.data.login.LoginResponseFromApi


class ChildListAdapter(
    private val mContext: Context,
    private val mList: List<LoginResponseFromApi.User.Student>,
    private val mPath: String
) :
    BaseRecyclerAdapter<LoginResponse, AdapterChildViewBinding>() {
    override fun getLayoutInflater(): Int {
        return R.layout.adapter_child_view
    }

    override fun getItemCount(): Int {

        return mList.size
    }

    @SuppressLint("SetTextI18n")
    override fun onBindViewHolder(
        holder: Companion.BaseViewHolder<AdapterChildViewBinding>,
        position: Int
    ) {

        Glide.with(mContext)
            .load(mPath + mList.get(position).studentId!!.profilePic)
            .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
            .error(R.drawable.default_image)
            .into(dataBinding.profileImage)
        dataBinding.name.text = mList.get(position).studentId!!.name
        dataBinding.admission.text = mList.get(position).studentId!!.admissionNo
        dataBinding.className.text =
            mList.get(position).studentId!!.standardId?.name + mList.get(position)?.studentId!!.sectionId?.name

    }


}