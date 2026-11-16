package com.mountcarmelschools.ui

import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import com.mountcarmelschools.R
import java.util.*


class Testing : AppCompatActivity() {

    val pinkDateList: List<String> = Arrays.asList(
        "2019-01-01",
        "2019-01-03", "2019-01-04", "2019-01-05", "2019-01-06"
    )
    val grayDateList: List<String> = Arrays.asList(
        "2019-01-09", "2019-01-10", "2019-01-11",
        "2019-01-24", "2019-01-25", "2019-01-26", "2019-01-27", "2019-01-28", "2019-01-29"
    )

    val DATE_FORMAT = "yyyy-MM-dd"

    var pink = 0
    var gray = 1

    private val markedDates: ArrayList<Date>? = null

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_testing)




    }

}