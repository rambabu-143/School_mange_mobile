package com.mountcarmelschools.ui.gallery

import android.app.Activity
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.RelativeLayout
import androidx.viewpager.widget.PagerAdapter
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.gallery.GalleryResponse
import com.mountcarmelschools.ui.attachment.TouchImageView

class FullImageAdapter(
    private val context: Context,
    private val images: List<GalleryResponse.Data.Images>,
    private val path: String?
) : PagerAdapter() {
    private val inflater: LayoutInflater
    override fun destroyItem(
        container: ViewGroup,
        position: Int,
        `object`: Any
    ) {
        container.removeView(`object` as View)
    }

    override fun getCount(): Int {
        return images.size
    }

    override fun instantiateItem(view: ViewGroup, position: Int): Any {
        val myImageLayout =
            inflater.inflate(R.layout.row_full_image, view, false)
        val myImage =
            myImageLayout.findViewById<TouchImageView>(R.id.img_banner)
        val close = myImageLayout.findViewById<RelativeLayout>(R.id.close)
        Glide.with(context)
                .load(path + "/" + (images.get(position).filename))
                .disallowHardwareConfig()
                .error(R.drawable.place_holder_image)
                .fitCenter() //.transition(withCrossFade())
                .diskCacheStrategy(DiskCacheStrategy.DATA)
                .placeholder(R.drawable.place_holder_image)
                .into(myImage)



        view.addView(myImageLayout, 0)
        close.setOnClickListener { (context as Activity).onBackPressed() }
        return myImageLayout
    }

    override fun isViewFromObject(
        view: View,
        `object`: Any
    ): Boolean {
        return view == `object`
    }

    init {
        inflater = LayoutInflater.from(context)
    }
}