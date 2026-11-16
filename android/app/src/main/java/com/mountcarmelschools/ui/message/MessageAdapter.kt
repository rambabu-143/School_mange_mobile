package com.mountcarmelschools.ui.message

import android.annotation.SuppressLint
import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.staff.sms.SmsResponse
import com.mountcarmelschools.utlis.LayoutedTextView
import com.mountcarmelschools.utlis.Utils


class MessageAdapter(
        private val mContext: Context,
        private var items: ArrayList<SmsResponse.Data?>,
        private val messageInterface: MessageInterface

) : RecyclerView.Adapter<MessageAdapter.ViewHolder>() {

    class ViewHolder(inflater: LayoutInflater, parent: ViewGroup) :
        RecyclerView.ViewHolder(inflater.inflate(R.layout.adapter_message, parent, false)) {
        private var mTitleView: LayoutedTextView? = null
        private var readMoreText: ImageView? = null
        private var mDate: TextView? = null


        init {
            mTitleView = itemView.findViewById(R.id.tv_Name)
            readMoreText = itemView.findViewById(R.id.readImage)
            mDate = itemView.findViewById(R.id.tv_date)
        }

        @SuppressLint("SetTextI18n")

        fun bind(items: SmsResponse.Data?, mContext: Context) {

            mTitleView?.text = items?.smsText
            /*  val parentWidth = 0 // assumes this is known/can be found
              mTitleView?.measure(
                  View.MeasureSpec.makeMeasureSpec(parentWidth, View.MeasureSpec.EXACTLY),
                  View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED)
              )*/


            if (items!!.mobiles != null && items.mobiles?.size!! > 0 && items.mobiles?.get(0) != null && items.mobiles.get(
                    0
                )?.readFlag!!
            ) {
                readMoreText?.setImageResource(R.drawable.ic_message_read)
            } else {
                readMoreText?.setImageResource(R.drawable.ic_message_colored)

            }
            mDate?.text = Utils.formattedDateFromString(
                "", "dd-MM-yyyy '|' hh:mm a",
                items.createdAt
            )


        }
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun getItemViewType(position: Int): Int {
        return position
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        return ViewHolder(inflater, parent)
    }

    override fun getItemCount(): Int = items!!.size


    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        holder.bind(items.get(position), mContext)

        holder.itemView.setOnClickListener {

            messageInterface.showDialog(items.get(position))

        }

    }

    public fun updateData(list: List<SmsResponse.Data?>) {
        items.clear()
        items.addAll(list)

        notifyDataSetChanged()

    }


}



