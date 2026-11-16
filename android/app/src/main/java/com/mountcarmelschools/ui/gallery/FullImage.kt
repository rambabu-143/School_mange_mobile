package com.mountcarmelschools.ui.gallery

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.viewpager.widget.ViewPager
import com.google.gson.Gson
import com.mountcarmelschools.R
import com.mountcarmelschools.databinding.FragmentFullmageBinding
import com.mountcarmelschools.di.data.gallery.GalleryResponse
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import java.util.*

class FullImage : Fragment() {
    private var mContext: Context? = null
    var viewPager: ViewPager? = null
    private var currentPage = 0
    private val XMENArray = ArrayList<Int>()
    var dataBinding: FragmentFullmageBinding? = null

    var path: String = ""
    var position: Int = 0

    lateinit var photos: List<GalleryResponse.Data.Images>

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

    override fun onResume() {
        super.onResume()
    }


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        dataBinding =
            DataBindingUtil.inflate(inflater, R.layout.fragment_fullmage, container, false)
        dataBinding?.lifecycleOwner = this


        photos = Gson().fromJson(        // Back to another variable
            arguments?.getString("json"), Array<GalleryResponse.Data.Images>::class.java
        ).toList()

        path = arguments?.getString("path").toString()

        position = arguments?.getInt("position")!!

        (mContext as DashboardActivity).setHeaderText(arguments?.getString("name").toString())

        init()

        return dataBinding?.root

    }

    private fun init() {
        val bundle: Bundle = arguments!!
        val pos = bundle.getInt("position")
        Log.d("Postion", pos.toString() + "")
        dataBinding?.viewpager?.setAdapter(
            FullImageAdapter(
                mContext!!,
                photos,
                path
            )
        )

         dataBinding?.viewpager!!.setCurrentItem(pos)
        /*      // Auto start of viewpager
              val handler = Handler()
              val Update = Runnable {
                  if (currentPage == galleryImages.size) {
                      currentPage = 0
                  }
                  viewPager?.setCurrentItem(currentPage++, true)
              }
              val swipeTimer = Timer()
              swipeTimer.schedule(object : TimerTask() {
                  override fun run() {
                      handler.post(Update)
                  }
              }, 100000, 100000)*/
    }

}