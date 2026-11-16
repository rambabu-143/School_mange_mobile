package com.mountcarmelschools.ui.profile.parent

import android.annotation.SuppressLint
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.studentDetail.SingleStudentDetail

class ParentAdapter(
    private val mContext: Context,
    private val list: List<SingleStudentDetail.Data.Relation?>,
    private val commonInterface: ParentInterface,
    private val selectedList: ArrayList<String>,
    private val isParent: Boolean

) :
    RecyclerView.Adapter<ParentAdapter.ViewHolder>() {

    class ViewHolder(inflater: LayoutInflater, parent: ViewGroup) :
        RecyclerView.ViewHolder(inflater.inflate(R.layout.adapter_parent, parent, false)) {
        private var fatherName: TextView = itemView.findViewById(R.id.fatherName)
        private var fatherQualification: TextView = itemView.findViewById(R.id.fatherQualification)
        private var fatherOccupation: TextView = itemView.findViewById(R.id.fatherOccupation)
        private var fatherOrganisation: TextView = itemView.findViewById(R.id.fatherOrganisation)
        private var fatherDesignation: TextView = itemView.findViewById(R.id.fatherDesignation)
        private var fatherPanNo: TextView = itemView.findViewById(R.id.fatherPanNo)
        private var fatherAddress: TextView = itemView.findViewById(R.id.fatherAddress)
        private var fatherEmail: TextView = itemView.findViewById(R.id.fatherEmail)
        private var fatherPhoneNo: TextView = itemView.findViewById(R.id.fatherPhoneNo)
        private var fatherMobileNo: TextView = itemView.findViewById(R.id.fatherMobileNo)
        private var parentTitle: TextView = itemView.findViewById(R.id.parentTitle)
        private var fatherEditIcon: ImageButton = itemView.findViewById(R.id.fatherEditIcon)


        @SuppressLint("SetTextI18n")
        fun bind(
            realationShip: SingleStudentDetail.Data.Relation,
            commonInterface: ParentInterface,
            selectedList: ArrayList<String>,
            isParent: Boolean
        ) {
            fatherName.text = realationShip.name

            if (isParent) {
                fatherEditIcon.visibility = View.VISIBLE
            } else {
                fatherEditIcon.visibility = View.GONE

            }

            parentTitle.text = realationShip.relation

            fatherPanNo.text = "Pan No : " + realationShip.pancard
            fatherEmail.text = "Email : " + realationShip.email
            fatherMobileNo.text = "Mobile No : " + realationShip.mobile

            if (realationShip.qualificationId != null) {
                fatherQualification.text =
                    "Qualification : " + realationShip.qualificationId.qualification
            } else {
                fatherQualification.text =
                    "Qualification : "
            }


            if (realationShip.occupationId != null) {
                if (realationShip.occupationId.occupationName!!.lowercase().equals("others")
                    || realationShip.occupationId.occupationName!!.lowercase().equals("other"))
                {
                    fatherOccupation.text =
                        "Occupation : " + realationShip
                            .otherOccupation
                }
                else{
                    if (realationShip.occupationChildId != null &&
                        !realationShip.occupationChildId.occupationChildName.equals("")
                    ) {
                        if (realationShip.occupationChildId.occupationChildName!!
                                .lowercase().equals("others")
                            || realationShip.occupationId.occupationName!!.lowercase().equals("other")
                        )
                        {
                            fatherOccupation.text =
                                "Occupation : " + realationShip.occupationId.occupationName + "," +
                                        realationShip.otherOccupation.toString()
                        }
                        else{
                            fatherOccupation.text =
                                "Occupation : " + realationShip.occupationId.occupationName + "," +
                                        realationShip.occupationChildId.occupationChildName
                        }

                    } else {
                        fatherOccupation.text =
                            "Occupation : " + realationShip
                                .occupationId!!.occupationName
                    }
                }

            } else {

                fatherOccupation.text =
                    "Occupation : "
            }


            if (realationShip.organization != null) {
                fatherOrganisation.text =
                    "Organisation Name : " + realationShip.organization
            } else {
                fatherOrganisation.text =
                    "Organisation Name : "
            }

            if (realationShip.designation != null) {
                fatherDesignation.text = "Designation : " + realationShip.designation

            } else {
                fatherDesignation.text = "Designation : "
            }



            if (realationShip.office_Address != null) {
                fatherAddress.text = "Office Address : " + realationShip.office_Address

            } else {
                fatherAddress.text = "Office Address : "
            }


            if (realationShip.officePhone != null) {
                fatherPhoneNo.text = "Office Phone No : " + realationShip.officePhone

            } else {
                fatherPhoneNo.text = "Office Phone No : "
            }

            fatherEditIcon.setOnClickListener {
                commonInterface.editParent(realationShip.relation.toString(), realationShip)
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

    override fun getItemCount(): Int = list.size


    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        holder.bind(list[position]!!, commonInterface, selectedList, isParent)


    }

    public fun updateValue(selectedValue: ArrayList<String>, clear: Boolean) {
        if (clear) {
            selectedList.clear()
        }
        selectedList.addAll(selectedValue)

        notifyDataSetChanged()
    }

}
