package com.mountcarmelschools.ui.gallery

import android.content.Context
import android.os.Bundle
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.di.loginData.LoginResponse
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.google.gson.Gson
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseRecyclerAdapter
import com.mountcarmelschools.databinding.AllGalleryAdapterBinding
import com.mountcarmelschools.databinding.RowAllGalleryBinding
import com.mountcarmelschools.di.data.gallery.GalleryResponse
import com.mountcarmelschools.utlis.Utils


class GalleryAllAdapter(
    private val mContext: Context,
    private val galleryImages: List<GalleryResponse.Data.Images>,
    private val path: String,
    private val name: String

) : BaseRecyclerAdapter<LoginResponse, AllGalleryAdapterBinding>() {

    override fun getItemCount(): Int {
        return galleryImages.size
    }

    inner class MyViewHolder(val binding: RowAllGalleryBinding) :
        RecyclerView.ViewHolder(binding.root) {
    }

    override fun onBindViewHolder(
        holder: Companion.BaseViewHolder<AllGalleryAdapterBinding>,
        position: Int
    ) {

        Glide.with(mContext)
            .load(path+ (galleryImages.get(position).filename))
            .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
            .into(dataBinding.ivImages)
        dataBinding.ivImages.setOnClickListener {
            val bundle = Bundle()
            val json = Gson().toJson(galleryImages)  // To JSON
            bundle.putString("json", json)
            bundle.putString("path", path)
            bundle.putString("name", name)
            bundle.putInt("position", position)

            val fragment = FullImage()
            fragment.arguments = bundle

            Utils.replaceFragment(
                mContext,
                R.id.fl_dashboardContainer,
                fragment,
                "FullImage"
            )
        }
    }

    override fun getLayoutInflater() = R.layout.all_gallery_adapter
}