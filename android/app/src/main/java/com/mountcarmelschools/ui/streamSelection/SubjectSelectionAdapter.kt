package com.mountcarmelschools.ui.streamSelection

import android.annotation.SuppressLint
import android.content.Context
import android.widget.ArrayAdapter
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseRecyclerAdapter
import com.mountcarmelschools.databinding.ItemSubjectAdapterBinding
import com.mountcarmelschools.di.data.streamSelection.StreamSelectionResponse
import com.mountcarmelschools.di.loginData.LoginResponse
import okhttp3.internal.notifyAll

class SubjectSelectionAdapter(
    private val mContext: Context,
    private val mSelectedList: ArrayList<StreamSelectionResponse.Data?>,
    private var mPosition: Int,
    private var mTotalCount: Int
) :
    BaseRecyclerAdapter<LoginResponse, ItemSubjectAdapterBinding>() {
    override fun getLayoutInflater(): Int {

        return R.layout.item_subject_adapter
    }

    override fun onBindViewHolder(
        holder: Companion.BaseViewHolder<ItemSubjectAdapterBinding>,
        position: Int
    ) {
        if (position in 0..4) {
            dataBinding.selectSubject.hint=""
            dataBinding.selectSubject.hint = "" + (position + 1) + ") Select subject"

        } else {
            dataBinding.selectSubject.hint = "" + (position + 1) + ") Select Additional subject"

        }
        dataBinding.selectSubject.id = position;

        when (position) {
            0 -> {
                val combinationList = ArrayList<String>()
                val combinationListId = ArrayList<String>()
                for (value in mSelectedList[mPosition]!!.subject1!!) {
                    combinationList.add(value!!.subjectName!!)
                    combinationListId.add(value.id!!)
                }
                updateDate(combinationList, combinationListId)
            }
            1 -> {
                val combinationList = ArrayList<String>()
                val combinationListId = ArrayList<String>()
                for (value in mSelectedList[mPosition]!!.subject2!!) {
                    combinationList.add(value!!.subjectName!!)
                    combinationListId.add(value.id!!)
                }
                updateDate(combinationList, combinationListId)
            }
            2 -> {
                val combinationList = ArrayList<String>()
                val combinationListId = ArrayList<String>()
                for (value in mSelectedList[mPosition]!!.subject3!!) {
                    combinationList.add(value!!.subjectName!!)
                    combinationListId.add(value.id!!)
                }
                updateDate(combinationList, combinationListId)
            }
            3 -> {
                val combinationList = ArrayList<String>()
                val combinationListId = ArrayList<String>()
                for (value in mSelectedList[mPosition]!!.subject4!!) {
                    combinationList.add(value!!.subjectName!!)
                    combinationListId.add(value.id!!)
                }
                updateDate(combinationList, combinationListId)
            }
            4 -> {
                val combinationList = ArrayList<String>()
                val combinationListId = ArrayList<String>()
                for (value in mSelectedList[mPosition]!!.subject5!!) {
                    combinationList.add(value!!.subjectName!!)
                    combinationListId.add(value.id!!)
                }
                updateDate(combinationList, combinationListId)
            }
            5 -> {
                val combinationList = ArrayList<String>()
                val combinationListId = ArrayList<String>()
                for (value in mSelectedList[mPosition]!!.subject6!!) {
                    combinationList.add(value!!.subjectName!!)
                    combinationListId.add(value.id!!)
                }
                updateDate(combinationList, combinationListId)
            }
        }

    }

    private fun updateDate(combinationList: List<String>, combinationListId: List<String>) {


        val adapter: ArrayAdapter<String> = ArrayAdapter(
            mContext /*context*/,
            android.R.layout.simple_list_item_1, android.R.id.text1, combinationList
        )

        dataBinding.selectSubjectTextView.setAdapter(adapter)
        dataBinding.selectSubjectTextView.setText(
            dataBinding.selectSubjectTextView.adapter.getItem(0).toString(), false
        );

    }


    override fun getItemCount(): Int {
        return mTotalCount
    }

    @SuppressLint("NotifyDataSetChanged")
    fun updatePosition(p1: Int, count: Int) {
        mPosition = p1
        mTotalCount = count
        notifyDataSetChanged()
    }


}




