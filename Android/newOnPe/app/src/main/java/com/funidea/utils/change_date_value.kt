package com.funidea.utils

/**
 * 날짜 데이터 변경
 *
 * 서버로 부터 받아온 날짜 데이터값을 양식에 맞추어 재변경한다.
 *
 * ex) 20210309174422 -> 2021-03-09-17:44:22
 *
 */

class change_date_value
{

    companion object {


        fun change_month_time(time: String): String {
            val change_time: String
            return if (time != "" && time.length == 14 && time != "null") {
                val years = time.substring(0, 4)
                val month = time.substring(4, 6)
                val day = time.substring(6, 8)

                change_time = "$years-$month-$day"

                change_time
            }
            else if(time != "" && time.length == 12 && time != "null")
            {
                val years = time.substring(0, 4)
                val month = time.substring(4, 6)
                val day = time.substring(6, 8)

                change_time = "$years-$month-$day"
                change_time
            }
            else {
                change_time = ""
                change_time
            }
        }


        fun change_time(time: String): String {
            val change_time: String
            return if (time != "" && time.length == 14 && time != "null") {
                val years = time.substring(0, 4)
                val month = time.substring(4, 6)
                val day = time.substring(6, 8)
                val hour = time.substring(8, 10)
                val minute = time.substring(10, 12)
                val second = time.substring(12, 14)
                change_time = "$years-$month-$day"
                change_time
            } else {
                change_time = ""
                change_time
            }
        }
        fun change_time_include_second(time: String): String {
            val change_time: String
            return if (time != "" && time.length == 14 && time != "null") {
                val years = time.substring(0, 4)
                val month = time.substring(4, 6)
                val day = time.substring(6, 8)
                val hour = time.substring(8, 10)
                val minute = time.substring(10, 12)
                val second = time.substring(12, 14)
                change_time = "$years-$month-$day $hour:$minute:$second"
                change_time
            } else {
                change_time = ""
                change_time
            }
        }
    }
}