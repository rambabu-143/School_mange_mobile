package com.mountcarmelschools.ui.home

import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.widget.TextView
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.R
import com.mountcarmelschools.ui.attendance.attendancesummary.AttendanceSummaryFragment
import com.mountcarmelschools.ui.attendance.studentattendance.AttendanceFragment
import com.mountcarmelschools.ui.calendar.SchoolCalendarFragment
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.ui.disciplinary.forstaff.DisciplinaryForStaffFragment
import com.mountcarmelschools.ui.disciplinary.forstudent.DisciplinaryCardFragment
import com.mountcarmelschools.ui.fees.FeeFragment
import com.mountcarmelschools.ui.homework.HomeworkFragment
import com.mountcarmelschools.ui.message.MessageFragment
import com.mountcarmelschools.ui.myTeacher.MyTeacherFragment
import com.mountcarmelschools.ui.profile.ProfileFragment
import com.mountcarmelschools.ui.setting.SettingFragment
import com.mountcarmelschools.ui.staffHomework.assignHomework.AssignHomeworkFragment
import com.mountcarmelschools.ui.staffHomework.assignedHomeworkList.AssignedHomeworkListFragment
import com.mountcarmelschools.ui.webviewScreen.WebViewScreenFragment
import com.mountcarmelschools.ui.welcome.WelcomeActivity
import com.mountcarmelschools.ui.wise.WiseFragment
import com.mountcarmelschools.utlis.SharedPreferenceUtils
import com.mountcarmelschools.utlis.Utils

class HomeViewModel : ViewModel() {

    fun onSetting(view: View) {
        Utils.replaceFragment(
            view.context,
            R.id.fl_dashboardContainer,
            SettingFragment(),
            "SettingFragment"
        )
    }

    fun onProfile(view: View) {
        Utils.replaceFragment(
            view.context,
            R.id.fl_dashboardContainer,
            ProfileFragment(),
            "ProfileFragment"
        )
    }

    fun handleActionNeededViewPress(view: View) {
        var currentYearSession = (view.context as? DashboardActivity)?.currentYear
        val years = currentYearSession?.split("-")
        if (years != null && years.size == 2) {
            val startYear = years.getOrNull(0)?.trim()?.toIntOrNull()
            val endYear = years.getOrNull(1)?.trim()?.toIntOrNull()
            if (startYear != null && endYear != null) {
                currentYearSession = "${startYear+1}-${endYear+1}"
            }
        }

        val transportRequestURL = "https://mountcarmelschool.com/parent/transport-request/request-form-app/${Utils.getUserId(view.context)}"

        Utils.replaceFragment(
            view.context,
            R.id.fl_dashboardContainer,
            WebViewScreenFragment.newInstance(
                "Transport Request ($currentYearSession)",
                transportRequestURL,
            ),
            "WebViewScreenFragment"
        )
    }

   /* fun onAssessmentRecord(view: View) {

        if (Utils.getUserType(view.context).equals(
                "4",
                true
            )
        ) {
            Utils.replaceFragment(
                view.context,
                R.id.fl_dashboardContainer,
                NoticeFragment(),
                "NoticeFragment"
            )
        } else {
            val fragment = AssessmentFragment()

            val bundle = Bundle()
            bundle.putString("from", "Assessment Record")


            fragment.arguments = bundle

            Utils.replaceFragment(
                view.context,
                R.id.fl_dashboardContainer,
                fragment,
                "AssessmentFragment"
            )
        }


    }*/

    fun onMessage(view: View) {
        Utils.replaceFragment(
            view.context,
            R.id.fl_dashboardContainer,
            MessageFragment(),
            "MessageFragment"
        )
    }

    fun onLogout(view: View) {
        openAlertDialog(view)

    }

    private fun openAlertDialog(view : View) {
        val dialogBuilder = AlertDialog.Builder(view.context)
        val inflater = (view.context).getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val dialogView: View = inflater.inflate(R.layout.logout_dialog, null)
        dialogBuilder.setView(dialogView)

        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()

        val cancel = dialogView.findViewById(R.id.btn_cancel) as TextView
        val logout = dialogView.findViewById(R.id.btn_continue) as TextView

        cancel.setOnClickListener {
            dialog.dismiss()
        }

        logout.setOnClickListener {
            dialog.dismiss()
            val intent = Intent(view.context, WelcomeActivity::class.java)
            SharedPreferenceUtils.getInstance(view.context)?.clear()
            (view.context).startActivity(intent)
        }


    }

    fun onAttendance(view: View) {
        Utils.replaceFragment(
            view.context,
            R.id.fl_dashboardContainer,
            AttendanceFragment(),
            "AttendanceFragment"
        )
    }

    fun onWISE(view: View) {
        Utils.replaceFragment(
            view.context,
            R.id.fl_dashboardContainer,
            WiseFragment(),
            "WiseFragment"
        )

    }

    fun onAssignHomework(view: View) {
        Utils.replaceFragment(
            view.context,
            R.id.fl_dashboardContainer,
            AssignHomeworkFragment(),
            "AssignHomeworkFragment"
        )
    }

    fun onHomework(view: View) {
        if (Utils.getUserType(view.context).equals("4", true)) {
            // Staff
            Utils.replaceFragment(
                view.context,
                R.id.fl_dashboardContainer,
                AssignedHomeworkListFragment(),
                "StaffHomeworkFragment"
            )
        } else {
            // Parent / Senior / Junior
            Utils.replaceFragment(
                view.context,
                R.id.fl_dashboardContainer,
                HomeworkFragment(),
                "HomeworkFragment"
            )
        }
    }

    fun onSchoolCalendar(view: View) {
        if (Utils.getUserType(view.context).equals("4", true)) {
            Utils.replaceFragment(
                view.context,
                R.id.fl_dashboardContainer,
                AttendanceSummaryFragment(),
                "AttendanceSummaryFragment"
            )
        } else {

                Utils.replaceFragment(
                        view.context,
                        R.id.fl_dashboardContainer,
                        SchoolCalendarFragment(),
                        "SchoolCalendarFragment"
                )
        }
    }

    fun onTimeTable(view: View) {
        if (Utils.getUserType(view.context).equals("4", true)) {
            Utils.replaceFragment(
                view.context,
                R.id.fl_dashboardContainer,
                DisciplinaryForStaffFragment(),
                "DisciplinaryForStaffFragment"
            )
        } else {

            Utils.replaceFragment(
                view.context,
                R.id.fl_dashboardContainer,
                DisciplinaryCardFragment(),
                "DisciplinaryCardFragment"
            )
          //  Toast.makeText(view.context, "Coming Soon!!!", Toast.LENGTH_SHORT).show()

        }
    }

    fun onTeacher(view: View) {
        if (Utils.getUserType(view.context).equals("4", true)) {
            Utils.replaceFragment(
                view.context,
                R.id.fl_dashboardContainer,
                FeeFragment(),
                "FeeFragment"
            )

        } else {
            Utils.replaceFragment(
                    view.context,
                    R.id.fl_dashboardContainer,
                    MyTeacherFragment(),
                    "MyTeacherFragment"
            )
        }
    }
}
