package com.mountcarmelschools.ui.classlist

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.mountcarmelschools.R
import com.mountcarmelschools.databinding.RowStaffAttendanceBinding
import com.mountcarmelschools.di.data.classList.ClassListResponse

class ClassListAdapter(
    private val mContext: Context,
    private val list: List<ClassListResponse.Data?>?,
    private val mPath: String,
    private val mInterface: ClassListInterface
) :
        RecyclerView.Adapter<ClassListAdapter.MyViewHolder>()
{

    override fun getItemCount(): Int {
        return list?.size!!
    }

    inner class MyViewHolder(val binding: RowStaffAttendanceBinding) :
            RecyclerView.ViewHolder(binding.root) {
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val view = DataBindingUtil.inflate<RowStaffAttendanceBinding>(
                LayoutInflater.from(mContext),
                R.layout.row_staff_attendance,
                parent,
                false
        )
        return MyViewHolder(view)
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun getItemViewType(position: Int): Int {
        return position
    }

    override fun onBindViewHolder(
        holder: MyViewHolder,
        position: Int
    ) {

        holder.binding.tvSerialNo.text = (position + 1).toString()
        holder.binding.tvStudentName.text = list?.get(position)?.name

        Glide.with(mContext)
            .load(mPath + list?.get(position)?.profilePic)
            .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
            .error(R.drawable.default_image)
            .into(holder.binding.ivStudentImage)

        holder.binding.tvStudentRollNo.text = list?.get(position)?.admissionNo

        holder.binding.cbFirstHalf.visibility = View.GONE
        holder.binding.cbSecondHalf.visibility = View.GONE
        holder.binding.parentLayout.setOnClickListener {
            mInterface.selectedClassList(list?.get(position));
        }

    }


}
