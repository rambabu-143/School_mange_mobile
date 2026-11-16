package com.mountcarmelschools.ui.disciplinary

import android.annotation.SuppressLint
import android.content.Context
import android.os.Parcelable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.viewpager.widget.PagerAdapter
import com.mountcarmelschools.R
import com.mountcarmelschools.ui.disciplinary.forstudent.DisciplinaryCustomList
import com.mountcarmelschools.utlis.Utils

interface Listener {
    public fun close()
}

class DisciplinaryAdapter(
    private val context: Context,
    private val list: DisciplinaryCustomList,
    private val check: Int, private val listener: Listener
) : PagerAdapter() {

    var selected_pos = 0
    public fun updateSelectedPos(selected_pos: Int) {
        this.selected_pos = selected_pos
        notifyDataSetChanged()
    }

    private val inflater: LayoutInflater = LayoutInflater.from(context)

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
        return list.data.size
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


    @SuppressLint("SetTextI18n")
    override fun instantiateItem(view: ViewGroup, position: Int): Any {
        /* val myImageLayout =
             LayoutInflater.from(context).inflate(R.layout.row_wise_dialog, view, false)

         val myImage =
             myImageLayout.findViewById<ImageView>(R.id.cl_wise_background)

 //        myImage.setImageResource(images.get(position));
 //        close.setOnClickListener { (context as Activity).onBackPressed() }
         return myImageLayout*/

        val myImageLayout =
            inflater.inflate(R.layout.disciplinary_wise_card, view, false)

        val header =
            myImageLayout.findViewById<TextView>(R.id.header)
        val reason =
            myImageLayout.findViewById<TextView>(R.id.reason)
        val actionTaken =
            myImageLayout.findViewById<TextView>(R.id.actionTaken)
        val housingPoint =
            myImageLayout.findViewById<TextView>(R.id.housingPoint)
        val date =
            myImageLayout.findViewById<TextView>(R.id.date)
        val issuedTo = myImageLayout.findViewById<TextView>(R.id.issuedTo)
        val issuedBy = myImageLayout.findViewById<TextView>(R.id.issuedBY)
        val colorBg = myImageLayout.findViewById<RelativeLayout>(R.id.colorBg)
        val sudo_view =
            myImageLayout.findViewById<View>(R.id.sudo_view)

//        val view_bottom = myImageLayout.findViewById<View>(R.id.view_bottom)
//        val view_ = myImageLayout.findViewById<View>(R.id.view_)
//
//        if(selected_pos == position)
//            view_.visibility = View.VISIBLE
//        else
//            view_.visibility = View.GONE

        val reasonOne = if (list.data[position].reason == "Any other reason")  "" else list.data[position].reason
        val comma=(if (list.data[position].reason == "Any other reason" || list.data[position].reasonOther == "") "" else " , ")
        val otherReason =(if (list.data[position].reasonOther != "") list.data[position].reasonOther  else "");
        reason.text = reasonOne+comma+otherReason
        actionTaken.text = list.data.get(position).actionTaken
        issuedTo.text = list.data.get(position).issuedTo
        housingPoint.text = list.data.get(position).housePoint
        issuedBy.text = list.data.get(position).staffName

        colorBg.setBackgroundColor(ContextCompat.getColor(context, list.color));

        date.text = Utils.formattedDateFromString(
            "",
            "dd-MM-yyyy",
            list.data.get(position).issueDate
        )

        //        set image
        when (check) {
            0 -> {
                header.setText("WARNING CARD")

            }
            1 -> {

                header.text = "TARDY CARD"

            }
            2 -> {
                header.text = "RED CARD"

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

}