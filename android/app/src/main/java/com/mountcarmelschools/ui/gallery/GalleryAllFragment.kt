package com.mountcarmelschools.ui.gallery

import android.content.Context
import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.GridLayoutManager
import com.google.gson.Gson
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.GalleryAllFragmentBinding
import com.mountcarmelschools.di.data.gallery.GalleryResponse
import com.mountcarmelschools.ui.dashboard.DashboardActivity


class GalleryAllFragment : BaseFragment<GalleryAllFragmentBinding, GalleryAllViewModel>() {

    companion object {
        fun newInstance() = GalleryAllFragment()
    }

    lateinit var photos: List<GalleryResponse.Data.Images>
    var path: String = ""


    private lateinit var mContext: Context

    override fun getLayoutID() = R.layout.gallery_all_fragment

    override fun getViewModel() = GalleryAllViewModel::class.java

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        photos = Gson().fromJson(        // Back to another variable
            arguments?.getString("json"), Array<GalleryResponse.Data.Images>::class.java
        ).toList()
        path = arguments?.getString("path").toString()

        (mContext as DashboardActivity).setHeaderText(arguments?.getString("name").toString())

        settingAllGalleryRecyclerView()

    }

    override fun onResume() {
        super.onResume()
    }


    private fun settingAllGalleryRecyclerView() {
        dataBinding.rvAllGallery.layoutManager = GridLayoutManager(mContext, 3)
        dataBinding.rvAllGallery.hasFixedSize()
        dataBinding.rvAllGallery.adapter =
            GalleryAllAdapter(mContext, photos, path, arguments?.getString("name").toString())
    }

}
