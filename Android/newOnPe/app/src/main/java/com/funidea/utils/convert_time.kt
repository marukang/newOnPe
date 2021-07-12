package com.funidea.utils


/**
 *  시간 변경 클래스
 *
 *  서버 또는 시간 데이터 값을
 *  분과 초로 나누어서 표기해준다.
 *
 */
class convert_time
{
    companion object {

        fun set_convert_time (get_time : Int) : String
        {
            val total_time_minute: Int = get_time / 60
            val total_time_second: Int = get_time % 60

            val total_time_minute_str = Integer.toString(total_time_minute)
            val total_time_second_str = Integer.toString(total_time_second)

            val convert_time  = total_time_minute_str +"분 " + total_time_second_str+"초"

            return convert_time

        }


    }

}