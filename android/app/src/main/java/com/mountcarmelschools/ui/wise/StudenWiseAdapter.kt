package com.mountcarmelschools.ui.wise

import android.content.Context
import android.os.Parcelable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.viewpager.widget.PagerAdapter
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.wise.wiseRes.WiseList
import com.mountcarmelschools.utlis.Utils

interface Listener{
    public fun close()
}

class StudenWiseAdapter(
    private val context: Context,
    private val list: List<WiseList>,
    private val check: Int, private val listener: Listener
) : PagerAdapter() {

    var selected_pos = 0
    public fun updateSelectedPos(selected_pos: Int){
        this.selected_pos = selected_pos
        notifyDataSetChanged()
    }

    private val inflater: LayoutInflater

    override fun destroyItem(
        container: ViewGroup,
        position: Int,
        objects: Any
    ) {
        container.removeView(objects as View)
    }


    override fun getItemPosition(`object`: Any): Int {
        return POSITION_NONE
    }

    override fun getCount(): Int {
        return list.size
    }

    /*override fun setPrimaryItem(
        container: ViewGroup,
        position: Int,
        `object`: Any
    ) {
        super.setPrimaryItem(container, position, `object`)

            if (container is DynamicHeightViewPager) {
                val cardView = `object` as LinearLayout
               // cardView.findViewById<View>(R.id.view_bottom).visibility = View.VISIBLE
                container.measureCurrentView(cardView)
            }

    }*/



    override fun instantiateItem(view: ViewGroup, position: Int): Any {
        /* val myImageLayout =
             LayoutInflater.from(context).inflate(R.layout.row_wise_dialog, view, false)

         val myImage =
             myImageLayout.findViewById<ImageView>(R.id.cl_wise_background)

 //        myImage.setImageResource(images.get(position));
 //        close.setOnClickListener { (context as Activity).onBackPressed() }
         return myImageLayout*/

        val myImageLayout =
            inflater.inflate(R.layout.row_wise_dialog, view, false)
        val myImage =
            myImageLayout.findViewById<ImageView>(R.id.cl_wise_background)

        val header =
            myImageLayout.findViewById<TextView>(R.id.header)
        val reason =
            myImageLayout.findViewById<TextView>(R.id.reason)
        val date =
            myImageLayout.findViewById<TextView>(R.id.date)
        val name =
            myImageLayout.findViewById<TextView>(R.id.name)
        val sudo_view =
            myImageLayout.findViewById<View>(R.id.sudo_view)

        val view_bottom = myImageLayout.findViewById<View>(R.id.view_bottom)
        val view_ = myImageLayout.findViewById<View>(R.id.view_)

        if(selected_pos == position)
            view_.visibility = View.VISIBLE
        else
            view_.visibility = View.GONE

        reason.text = list.get(position).reason
        name.text = list.get(position).staffName

        date.text = Utils.formattedDateFromString(
            "",
            "dd-MM-yyyy",
            list.get(position).wiseDate
        )

        //        set image
        when (check) {
            1 -> {
                myImage.setImageResource(R.mipmap.worthy_icon)
                header.text = "Worthy"

            }
            2 -> {

                header.text = "Intellect"

                myImage.setImageResource(R.mipmap.intellect_background)
            }
            3 -> {
                header.text = "Stature"

                myImage.setImageResource(R.mipmap.startuc_background)
            }
            4 -> {
                header.text = "Emotion"

                myImage.setImageResource(R.mipmap.emotion_background)
            }
        }
        //myImage.setImageResource(details.get(position));

        sudo_view.setOnClickListener {
            listener.close()
        }
        view.addView(myImageLayout, 0)
        return myImageLayout

    }

    override fun restoreState(state: Parcelable?, loader: ClassLoader?) {}

    override fun saveState(): Parcelable? {
        return null
    }

    override fun isViewFromObject(
        view: View,
        objects: Any
    ): Boolean {
        return view == objects
    }

    init {
        inflater = LayoutInflater.from(context)
    }

}