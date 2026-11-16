package com.mountcarmelschools.ui.gallery

import android.content.Context
import android.os.Bundle
import androidx.core.content.ContextCompat
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentGalleryBinding
import com.mountcarmelschools.di.data.gallery.GalleryResponse
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.DATE_OF_ADMISSION
import com.mountcarmelschools.utlis.SharedPreferenceUtils
import com.mountcarmelschools.utlis.Utils

class GalleryFragment : BaseFragment<FragmentGalleryBinding, GalleryViewModel>() {

    private lateinit var mContext: Context

    lateinit var mGalleryAdapter: GalleryAdapter
    lateinit var admissionDate :String

    companion object {
        fun newInstance() = GalleryFragment()
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Gallerie")
    }


    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        settingGalleryRecyclerView()
        admissionDate = SharedPreferenceUtils.getInstance(mContext)?.getStringValue(DATE_OF_ADMISSION,"")!!
            getGalleryList()
    }

    override fun getLayoutID() = R.layout.fragment_gallery

    override fun getViewModel() = GalleryViewModel::class.java

    private fun settingGalleryRecyclerView() {
        dataBinding.rvGallery.layoutManager =
            LinearLayoutManager(mContext, LinearLayoutManager.VERTICAL, false)
        dataBinding.rvGallery.hasFixedSize()


        val userType = Utils.getUserType(mContext)

        if (userType.equals("1")) {

            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.blue_background
                )
            )
        } else if (userType.equals("2") || userType.equals("3")) {
            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.fourth_background
                )
            )

        } else
            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.parent_background
                )
            )
    }


    private fun getGalleryList() {
        (mContext as DashboardActivity).showProgress()

        viewModel.getGallery(Utils.getAccessToken(mContext),SharedPreferenceUtils.getInstance(mContext)?.getStringValue(DATE_OF_ADMISSION,"")!!)
        .observe(

            viewLifecycleOwner, Observer {
                (mContext as DashboardActivity).hideProgress()


                it.data?. let { it1 ->

                    mGalleryAdapter = GalleryAdapter(mContext,
                        it.data as List<GalleryResponse.Data>,
                            it.path.toString()
                    )
                    dataBinding.rvGallery.adapter = mGalleryAdapter
                }
            }
        )

    }


}

