package com.mountcarmelschools.ui.commonAdapter

import android.annotation.SuppressLint
import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.classList.ClassListDropDownResponse

class StudentStandardAdapter(
        private val mContext: Context,
        private val list: List<ClassListDropDownResponse.Data?>?,
        private val commonInterface: CommonInterface,
        private val selectedList: ArrayList<String?>
) :
    RecyclerView.Adapter<StudentStandardAdapter.ViewHolder>() {

    class ViewHolder(inflater: LayoutInflater, parent: ViewGroup) :
        RecyclerView.ViewHolder(inflater.inflate(R.layout.adapter_checkbox, parent, false)) {
        private var mTitleView: TextView? = null
        private var mParentLayout: ConstraintLayout? = null
        private var mCheckBox: ImageView? = null


        init {
            mTitleView = itemView.findViewById(R.id.text)
            mParentLayout = itemView.findViewById(R.id.parentLayout)
            mCheckBox = itemView.findViewById(R.id.checkBox)
        }

        @SuppressLint("SetTextI18n")
        fun bind(
                list: ClassListDropDownResponse.Data?,
                commonInterface: CommonInterface,
                selectedList: ArrayList<String?>
        ) {

            mTitleView?.text =
                    list?.standardId!!.name.toString() + " " + list?.sectionId!!.name.toString()

            if (selectedList.contains(list?._id.toString())) {
                mCheckBox?.setImageResource(R.drawable.ic_baseline_check_box)

            } else {
                mCheckBox?.setImageResource(R.drawable.ic_check_box_outline)

            }



            mParentLayout?.setOnClickListener {

                commonInterface.selectClass(list?._id.toString())

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

    override fun getItemCount(): Int = list!!.size


    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        holder.bind(
            list?.get(position), commonInterface,
            selectedList
        )

    }

    public fun updateValue(selectedValue: ArrayList<String>, clear: Boolean) {
        if (clear) {
            selectedList.clear()
        }
        selectedList.addAll(selectedValue)

        notifyDataSetChanged()
    }

}
