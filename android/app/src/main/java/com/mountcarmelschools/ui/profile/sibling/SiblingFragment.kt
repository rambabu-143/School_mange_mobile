package com.mountcarmelschools.ui.profile.sibling

import android.annotation.SuppressLint
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentSiblingBinding
import com.mountcarmelschools.ui.dashboard.DashboardActivity

class SiblingFragment : BaseFragment<FragmentSiblingBinding, SiblingFragmentViewModel>() {

    private lateinit var mContext: Context

    override fun getLayoutID(): Int {

        return R.layout.fragment_sibling
    }

    override fun getViewModel() = SiblingFragmentViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }


    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Sibling")

    }

    @SuppressLint("SetTextI18n")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val studentDetailData = (mContext as DashboardActivity).studentDetail.data

        for (siblingList in studentDetailData!!.siblings!!) {
            val child: View =
                LayoutInflater.from(mContext).inflate(R.layout.adapter_child_view, null)

            val imageView = child.findViewById<ImageView>(R.id.profileImage)
            val name = child.findViewById<TextView>(R.id.name)
            val className = child.findViewById<TextView>(R.id.className)
            val admission = child.findViewById<TextView>(R.id.admission)

            Glide.with(this)
                .load(siblingList?.siblingId?.profilePic)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .error(R.drawable.default_image)
                .into(imageView)
            name.text = siblingList?.siblingId?.name
            admission.text = siblingList?.siblingId?.admissionNo
            className.text =
                siblingList?.siblingId?.standardId?.name + "-" + siblingList?.siblingId?.sectionId?.name


            dataBinding.linearLayout.addView(child)
        }
    }
}