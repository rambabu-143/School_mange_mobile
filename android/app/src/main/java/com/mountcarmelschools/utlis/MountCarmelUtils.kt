package com.mountcarmelschools.utlis

import com.mountcarmelschools.R

class MountCarmelUtils {


    companion object {

        const val assignments = "Assignments"
        const val syllabus = "Syllabus"
        const val date_sheet = "Date Sheet"
        const val holiday_homework = "Holiday Homework"
        const val fee = "Fee"
        const val self_awareness = "Self Awareness"
        const val setting = "Settings"
        const val privacy_policy = "Privacy Policy"
        const val email_group = "Email Group"
        const val staff_attendance = "My Attendance"
        const val time_table = "Time Table"
        const val stream_selection = "Stream Selection"
        const val transport_renewal = "Transport Renewal"
        const val term_attendance = "Term Attendance"
        const val chronicles = "Chronicles"
        const val news_letter = "NewsLetter"
        const val id_Card = "ID Card"

        fun getDrawerIconsAndLabel(
            userType: String,
            currentStandard: String,
            isParent: Boolean,
            showSelfAwareness: Boolean,
            showStreamSelection: Boolean,
            showTransportRenewal: Boolean,
            showIdCard: Boolean,
        ): LinkedHashMap<String, Int> {

            val drawerHashMap: LinkedHashMap<String, Int> = LinkedHashMap()

            if (userType == "1") {
                //Junior student

                if (isParent) {

                    drawerHashMap[assignments] = R.drawable.ic_parent_assignments
                    drawerHashMap[syllabus] = R.drawable.ic_parent_syllabus
                    drawerHashMap[date_sheet] = R.drawable.ic_parent_date_sheet
                    drawerHashMap[holiday_homework] = R.drawable.ic_parent_holiday
                    drawerHashMap[fee] = R.drawable.fee
                    if (containStandard(currentStandard) && showSelfAwareness) {
                        drawerHashMap[self_awareness] = R.drawable.self_awareness
                    }
                    if (showTransportRenewal) {
                        drawerHashMap[transport_renewal] = R.drawable.bus

                    }
                    drawerHashMap[chronicles] = R.drawable.chronicle3
                    drawerHashMap[news_letter] = R.drawable.news_letter3
                    drawerHashMap[privacy_policy] = R.drawable.ic_staff_notice
                    if (showIdCard) {
                        drawerHashMap[id_Card] = R.drawable.id_card
                    }

                    drawerHashMap[setting] = R.drawable.ic_3rd_setting


                } else {

                    drawerHashMap[assignments] = R.drawable.ic_3rd_assignments
                    drawerHashMap[syllabus] = R.drawable.ic_3rd_syllabus
                    drawerHashMap[date_sheet] = R.drawable.ic_3rd_date_sheet
                    drawerHashMap[holiday_homework] = R.drawable.ic_3rd_holiday_homework
                    if (containStandard(currentStandard) && showSelfAwareness) {
                        drawerHashMap[self_awareness] = R.drawable.streamselection
                    }


                    drawerHashMap[chronicles] = R.drawable.chronicle3
                    drawerHashMap[news_letter] = R.drawable.news_letter3
                    drawerHashMap[privacy_policy] = R.drawable.ic_staff_notice
                    if (showIdCard) {
                        drawerHashMap[id_Card] = R.drawable.id_card
                    }

                    drawerHashMap[setting] = R.drawable.ic_3rd_setting

                }

            } else if (userType == "2") {
                //Senior Student
                if (isParent) {
                    drawerHashMap[assignments] = R.drawable.ic_parent_assignments
                    drawerHashMap[syllabus] = R.drawable.ic_parent_syllabus
                    drawerHashMap[date_sheet] = R.drawable.ic_parent_date_sheet
                    drawerHashMap[holiday_homework] = R.drawable.ic_parent_holiday
                    drawerHashMap[fee] = R.drawable.fee

                    if (containStandard(currentStandard) && showSelfAwareness) {
                        drawerHashMap[self_awareness] = R.drawable.self_awareness
                    }
                    if (isTenthStandard(currentStandard) && showStreamSelection) {
                        drawerHashMap[stream_selection] = R.drawable.streamselection

                    }
                    if (showTransportRenewal) {
                        drawerHashMap[transport_renewal] = R.drawable.bus

                    }

                    drawerHashMap[chronicles] = R.drawable.chronicle3
                    drawerHashMap[news_letter] = R.drawable.news_letter3
                    drawerHashMap[privacy_policy] = R.drawable.ic_staff_notice
                    if (showIdCard) {
                        drawerHashMap[id_Card] = R.drawable.id_card
                    }

                    drawerHashMap[setting] = R.drawable.ic_3rd_setting

                } else {
                    drawerHashMap[assignments] = R.drawable.ic_12th_assignments
                    drawerHashMap[syllabus] = R.drawable.ic_12th_syllabus
                    drawerHashMap[date_sheet] = R.drawable.ic_12th_date_sheet
                    drawerHashMap[holiday_homework] = R.drawable.ic_12th_holiday_homework
                    if (containStandard(currentStandard) && showSelfAwareness) {
                        drawerHashMap[self_awareness] = R.drawable.self_awareness
                    }

                    if (isTenthStandard(currentStandard) && showStreamSelection) {
                        drawerHashMap[stream_selection] = R.drawable.streamselection

                    }

                    drawerHashMap[chronicles] = R.drawable.chronicle3
                    drawerHashMap[news_letter] = R.drawable.news_letter3
                    drawerHashMap[privacy_policy] = R.drawable.ic_staff_notice
                    if (showIdCard) {
                        drawerHashMap[id_Card] = R.drawable.id_card
                    }


                    drawerHashMap[setting] = R.drawable.ic_3rd_setting


                }
            } else if (userType == "3") {
                //Parent
                drawerHashMap[assignments] = R.drawable.ic_parent_assignments
                drawerHashMap[syllabus] = R.drawable.ic_parent_syllabus
                drawerHashMap[date_sheet] = R.drawable.ic_parent_date_sheet
                drawerHashMap[holiday_homework] = R.drawable.ic_parent_holiday
                if (containStandard(currentStandard) && showSelfAwareness) {
                    drawerHashMap[self_awareness] = R.drawable.self_awareness
                }

                if (isTenthStandard(currentStandard) && showStreamSelection) {
                    drawerHashMap[stream_selection] = R.drawable.streamselection

                }
                drawerHashMap[fee] = R.drawable.fee
                if (showTransportRenewal) {
                    drawerHashMap[transport_renewal] = R.drawable.bus

                }

                drawerHashMap[chronicles] = R.drawable.chronicle3
                drawerHashMap[news_letter] = R.drawable.news_letter3
                drawerHashMap[privacy_policy] = R.drawable.ic_staff_notice
                if (showIdCard) {
                    drawerHashMap[id_Card] = R.drawable.id_card
                }

                drawerHashMap[setting] = R.drawable.ic_3rd_setting


            } else if (userType == "4") {
                //Staff
                drawerHashMap[staff_attendance] = R.drawable.ic_staff_mark_attendance
                drawerHashMap[time_table] = R.drawable.ic_staff_time_table
                drawerHashMap[email_group] = R.drawable.ic_staff_email_group
                drawerHashMap[term_attendance] = R.drawable.ic_staff_attendance_day
                drawerHashMap[chronicles] = R.drawable.chronicle3
                drawerHashMap[news_letter] = R.drawable.news_letter3
                drawerHashMap[privacy_policy] = R.drawable.ic_staff_notice
                drawerHashMap[setting] = R.drawable.ic_3rd_setting
            }


            return drawerHashMap;
        }

        private fun containStandard(value: String): Boolean {
            return when (value) {
                "IV", "iv" -> true
                "V", "v" -> true
                "VI", "vi" -> true
                "VII", "vii" -> true
                "VIII", "viii" -> true
                else -> false
            }

        }

        private fun isTenthStandard(value: String): Boolean {
            return when (value) {
                "X", "x" -> true
                else -> false
            }

        }


        fun convertRomanToInt(s: String): Int {
            var total = 0
            for (i in s.indices) {
                val s1 = value(s[i])
                total = if (i + 1 < s.length) {
                    val s2 = value(s[i + 1])
                    if (s1 >= s2) {
                        total + s1
                    } else {
                        total - s1
                    }
                } else {
                    total + s1
                }
            }
            return total
        }

        fun value(r: Char): Int {
            if (r == 'I') return 1
            if (r == 'V') return 5
            if (r == 'X') return 10
            if (r == 'L') return 50
            if (r == 'C') return 100
            if (r == 'D') return 500
            return if (r == 'M') 1000 else -1
        }

    }
}