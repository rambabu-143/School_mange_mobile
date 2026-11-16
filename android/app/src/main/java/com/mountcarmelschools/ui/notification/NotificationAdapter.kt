package com.mountcarmelschools.ui.notification

import android.annotation.SuppressLint
import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.notificationHistory.StaffNotificationHistoryResponse
import com.mountcarmelschools.utlis.LayoutedTextView
import com.mountcarmelschools.utlis.Utils

class NotificationAdapter(
        private val mContext: Context,
        var itemsTopic: ArrayList<StaffNotificationHistoryResponse.Data?>?,
        private val notificationInterface: NotificationInterface

) :
        RecyclerView.Adapter<NotificationAdapter.ViewHolder>() {

    class ViewHolder(inflater: LayoutInflater, parent: ViewGroup) :
            RecyclerView.ViewHolder(inflater.inflate(R.layout.row_notification, parent, false)) {
        private var mTitleView: LayoutedTextView? = null
        private var readMoreText: ImageView? = null
        private var mDate: TextView? = null


        init {
            mTitleView = itemView.findViewById(R.id.tv_Name)
            readMoreText = itemView.findViewById(R.id.readImage)
            mDate = itemView.findViewById(R.id.tv_date)
        }

        @SuppressLint("SetTextI18n")

        fun bind(items: StaffNotificationHistoryResponse.Data?, mContext: Context) {

            mTitleView?.text = items?.smsText
            /*  val parentWidth = 0 // assumes this is known/can be found
              mTitleView?.measure(
                  View.MeasureSpec.makeMeasureSpec(parentWidth, View.MeasureSpec.EXACTLY),
                  View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED)
              )*/

            if (items!!.notifications != null&& items.notifications?.size!! > 0 && items.notifications.get(0)!!.readFlag) {
                readMoreText?.setImageResource(R.drawable.ic_notification_read)
            } else {
                readMoreText?.setImageResource(R.drawable.ic_notification_colored)

            }


            mDate?.text = Utils.formattedDateFromString(
                    "", "dd-MM-yyyy '|' hh:mm a",
                    items?.createdAt
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

    override fun getItemCount(): Int {
        return itemsTopic!!.size
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        holder.bind(itemsTopic?.get(position), mContext)

        holder.itemView.setOnClickListener {

            notificationInterface.showDialog(itemsTopic?.get(position))

        }

    }

    public fun updateData(items: List<StaffNotificationHistoryResponse.Data?>) {

        itemsTopic!!.clear()
        itemsTopic!!.addAll(items)

        notifyDataSetChanged()
    }


}
