package com.mountcarmelschools.ui.disciplinary.forstudent

import android.annotation.SuppressLint
import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.disciplinaryCard.DisciplinaryCardResponse


class DisciplinaryCardAdapter(
    private var mContext: Context,
    private var mList: ArrayList<DisciplinaryCustomList>,
    private var mInterface: Disciplinary,
    private var  data: DisciplinaryCardResponse.Data?
) : RecyclerView.Adapter<DisciplinaryCardAdapter.ViewHolder>() {

    class ViewHolder(inflater: LayoutInflater, parent: ViewGroup) :
        RecyclerView.ViewHolder(
            inflater.inflate(
                R.layout.adapter_disciplinay_card,
                parent,
                false
            )
        ) {
        private var mTotal: TextView? = null
        private var mCardName: TextView? = null
        private var mCardView: CardView? = null
        private var mCardImageView: ImageView? = null

        init {
           // mTotal = itemView.findViewById(R.id.total)
            mCardView = itemView.findViewById(R.id.cardColor)
            mCardName = itemView.findViewById(R.id.cardName)
            mCardImageView = itemView.findViewById(R.id.cardImage)
        }

        @SuppressLint("SetTextI18n")

        fun bind(
            item: DisciplinaryCustomList,
            context: Context,
            data: DisciplinaryCardResponse.Data?
        ) {

            //mTotal?.text = item.count
            mCardName?.text = item.cardName +" \n ("+item.count+") "

            mCardView?.setBackgroundTintList(context.getResources().getColorStateList(item.color));

            if(item.cardName=="WARNING CARD")
            {
                mCardImageView?.setImageDrawable(ContextCompat.getDrawable(context,R.drawable.pink_card))
            }
            else if (item.cardName=="TARDY CARD")
            {
                mCardImageView?.setImageDrawable(ContextCompat.getDrawable(context,R.drawable.yellow_card))

            }
            else if (item.cardName=="RED CARD")
            {
                mCardImageView?.setImageDrawable(ContextCompat.getDrawable(context,R.drawable.red_card))

            }


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

    override fun getItemCount(): Int = mList.size


    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        holder.bind(mList.get(position), mContext, data)

        holder.itemView.setOnClickListener {
            mInterface.onClick(mList[position],data)
        }

    }

}



