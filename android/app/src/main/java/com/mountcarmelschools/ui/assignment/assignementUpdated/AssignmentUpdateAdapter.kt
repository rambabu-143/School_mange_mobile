package com.mountcarmelschools.ui.assignment.assignementUpdated

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.net.Uri
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.Filter
import android.widget.Filterable
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.assignment.AssignmentUpdateResponse
import com.mountcarmelschools.utlis.Utils


class AssignmentUpdateAdapter(
        private val mContext: Context,
        val subjectList: List<AssignmentUpdateResponse.Data?>?,
        val path: String
) :
        RecyclerView.Adapter<AssignmentUpdateAdapter.ViewHolder>(), Filterable {


    private var mListFiltered = ArrayList<AssignmentUpdateResponse.Data?>()

    init {
        mListFiltered.clear()
        mListFiltered.addAll(subjectList!!)
    }

    class ViewHolder(inflater: LayoutInflater, parent: ViewGroup) :
            RecyclerView.ViewHolder(inflater.inflate(R.layout.row_subject, parent, false)) {
        private var tvDate: TextView? = null
        private var tvSubject: TextView? = null
        private var parentLayout: CardView? = null


        init {
            tvSubject = itemView.findViewById(R.id.tv_subject)
            tvDate = itemView.findViewById(R.id.tv_date)
            parentLayout = itemView.findViewById(R.id.parentLayout)

        }

        @SuppressLint("SetTextI18n")
        fun bind(list: AssignmentUpdateResponse.Data?, mContext: Context, path: String) {


            tvSubject!!.setText(list?.title)

            tvDate!!.text = Utils.formattedDateFromString(
                    "",
                    "dd-MM-yyyy",
                    list?.createdAt
            )

            parentLayout!!.setOnClickListener {

                if (list?.attachments!!.size > 1) {

                    var list1 = ArrayList<String>()
                    //for ()
                    var value = 1;
                    for (data in list.attachments!!) {
                        list1.add("File $value")
                        value++
                    }

                    val array: Array<String> = list1.toTypedArray()

                    val builder = AlertDialog.Builder(mContext)
                    builder.setTitle("Choose file")

                    builder.setItems(array, object : DialogInterface.OnClickListener {
                        override fun onClick(dialog: DialogInterface?, which: Int) {
                            openUrl(path + list.attachments?.get(which), mContext)
                        }

                    })


                    val dialog: AlertDialog = builder.create()
                    dialog.show()
                } else {
                    openUrl(path + list.attachments?.get(0), mContext)
                }

            }


        }

        private fun openUrl(url: String, mContext: Context) {
            try {
                try {
                    /*val uri = Uri.parse("googlechrome://navigate?url=$url")
                    val i = Intent(Intent.ACTION_VIEW, uri)
                    i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    mContext.startActivity(i)*/
                    Utils.openPdf("Assignment", url, mContext)
                } catch (e: ActivityNotFoundException) {
                    val uri = Uri.parse(url)
                    // Chrome is probably not installed
                    // OR not selected as default browser OR if no Browser is selected as default browser
                    val i = Intent(Intent.ACTION_VIEW, uri)
                    i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    mContext.startActivity(i)
                }
            } catch (ex: Exception) {

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

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(mListFiltered.get(position), mContext, path)

    }

    override fun getItemCount(): Int {
        return mListFiltered?.size!!
    }


    override fun getFilter(): Filter {

        return object : Filter() {
            override fun performFiltering(charSequence: CharSequence): FilterResults {
                val charString = charSequence.toString()
                if (charString.isEmpty()) {
                    mListFiltered.clear()
                    mListFiltered.addAll(subjectList!!)
                } else {
                    val filteredList: MutableList<AssignmentUpdateResponse.Data?> =
                            java.util.ArrayList<AssignmentUpdateResponse.Data?>()
                    for (row in subjectList!!) {

                        // name match condition. this might differ depending on your requirement
                        // here we are looking for name or phone number match
                        if (row?.title!!.toLowerCase().contains(charString.toLowerCase())) {
                            filteredList.add(row)
                        }
                    }
                    mListFiltered.clear()
                    mListFiltered.addAll(filteredList)

                }
                val filterResults = FilterResults()
                filterResults.values = mListFiltered
                return filterResults
            }

            override fun publishResults(
                    charSequence: CharSequence,
                    filterResults: FilterResults
            ) {
                mListFiltered =
                        filterResults.values as java.util.ArrayList<AssignmentUpdateResponse.Data?>
                notifyDataSetChanged()
            }
        }
    }

}
