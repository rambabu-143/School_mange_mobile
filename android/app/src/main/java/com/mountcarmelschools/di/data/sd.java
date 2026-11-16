package com.mountcarmelschools.di.data;

public class sd {

    /*package com.mountcarmelschool.com.carmel.mountschool.ui.gallery

import android.content.Context
import android.os.Bundle
import androidx.core.content.ContextCompat
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import com.mountcarmelschool.com.carmel.mountschool.R
import com.mountcarmelschool.com.carmel.mountschool.base.BaseFragment
import com.mountcarmelschool.com.carmel.mountschool.databinding.FragmentGalleryBinding
import com.mountcarmelschool.com.carmel.mountschool.di.data.gallery.GalleryResponse
import com.mountcarmelschool.com.carmel.mountschool.ui.dashboard.DashboardActivity
import com.mountcarmelschool.com.carmel.mountschool.utlis.Utils

class GalleryFragment : BaseFragment<FragmentGalleryBinding, GalleryViewModel>() {

    private lateinit var mContext: Context

    lateinit  var mGalleryAdapter: GalleryAdapter
    companion object {
        fun newInstance() = GalleryFragment()
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Gallery")
    }

    private val galleryImages =
        arrayOf(
            R.drawable.gallery_image_1,
            R.drawable.gallery_image_2,
            R.drawable.gallery_image_1,
            R.drawable.gallery_image_2
        )

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        settingGalleryRecyclerView()

        getGalleryList()
    }

    override fun getLayoutID() = R.layout.fragment_gallery

    override fun getViewModel() = GalleryViewModel::class.java

    private fun settingGalleryRecyclerView() {
        dataBinding.rvGallery.layoutManager =
            LinearLayoutManager(mContext, LinearLayoutManager.VERTICAL, false)
        dataBinding.rvGallery.hasFixedSize()

        mGalleryAdapter = GalleryAdapter(mContext, listOf())

        dataBinding.rvGallery.adapter = mGalleryAdapter

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


        viewModel.getGallery(Utils.getAccessToken(mContext)).observe(
            viewLifecycleOwner, Observer {

                it.path?.let { it1 -> mGalleryAdapter.updateAdapter(it.data , it1) }
            }
        )

    }
}



     */
}
