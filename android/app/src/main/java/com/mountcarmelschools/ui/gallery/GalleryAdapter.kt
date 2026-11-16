package com.mountcarmelschools.ui.gallery

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.Toast
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.google.gson.Gson
import com.mountcarmelschools.R
import com.mountcarmelschools.databinding.RowGalleryBinding
import com.mountcarmelschools.di.data.gallery.GalleryResponse.Data
import com.mountcarmelschools.utlis.Utils


class GalleryAdapter(
        private val mContext: Context,
        private var mGalleryImagesList: List<Data>,
        private val mPath:String
) : RecyclerView.Adapter<GalleryAdapter.MyViewHolder>() {


    override fun getItemCount(): Int {
        return mGalleryImagesList.size
    }

    inner class MyViewHolder(val binding: RowGalleryBinding) :
        RecyclerView.ViewHolder(binding.root) {
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val view = DataBindingUtil.inflate<RowGalleryBinding>(
            LayoutInflater.from(mContext),
            R.layout.row_gallery,
            parent,
            false
        )
        return MyViewHolder(view)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {


            val bundle = Bundle()
            val json = Gson().toJson(mGalleryImagesList.get(position).images)  // To JSON
            bundle.putString("json", json)
            bundle.putString("path", mPath)
            bundle.putString("name", mGalleryImagesList.get(position).eventName)
            val fragment = GalleryAllFragment()
            fragment.arguments = bundle

            holder.binding.clTripImage.setOnClickListener {
                if (mGalleryImagesList.get(position).images.size >  0) {

                    Utils.replaceFragment(
                    mContext,
                    R.id.fl_dashboardContainer,
                    fragment,
                    "GalleryAllFragment"
                )
                } else {

                    Toast.makeText(mContext,"No Images Found", Toast.LENGTH_SHORT).show()

                }
            }




        holder.binding.tvTrip.text = mGalleryImagesList.get(position).eventName

        holder.binding.tvTripDate.text = Utils.formattedDateFromString(
                "",
                "dd-MM-yyyy",
                mGalleryImagesList.get(position).evenDate
        )


        for (i in 0..mGalleryImagesList.get(position).images.size - 1) {

            val myLayout: View = LayoutInflater.from(mContext)
                    .inflate(R.layout.inflater_image, holder.binding.ivImages, false)

               val imageView = myLayout.findViewById(R.id.imageView) as ImageView;
            imageView.scaleType = ImageView.ScaleType.CENTER

            Log.d("ttaaag", "onBindViewHolder: $mPath${mGalleryImagesList.get(position).images.get(i).filename}")
            Glide.with(mContext)
                    .load(mPath+(mGalleryImagesList[position].images.get(i).filename))
                    .into(imageView)


            imageView.setOnClickListener {

                if (mGalleryImagesList.get(position).images.size > 0) {
                    val bundle = Bundle()
                    val json = Gson().toJson(mGalleryImagesList.get(position).images)  // To JSON
                    bundle.putString("json", json)
                    bundle.putString("path", mPath)
                    bundle.putString("name", mGalleryImagesList.get(position).eventName)
                    bundle.putInt("position", i)
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
            holder.binding.ivImages.addView(myLayout)

        }

        /*      var imagePosition: Int = 0;
              for (Photo in mGalleryImagesList.get(position).photos!!) {

                  imagePosition++

              }*/

    }

}