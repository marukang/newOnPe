package com.funidea.utils

import java.text.SimpleDateFormat
import java.util.*

//현재 사용 안함
class get_Time
{


    companion object {

        //시간 데이터
        // 현재시간을 msec 으로 구한다.
        var now = System.currentTimeMillis()

        // 현재시간을 date 변수에 저장한다.
        var date = Date(now)

        // 시간을 나타냇 포맷을 정한다 ( yyyy/MM/dd 같은 형태로 변형 가능 )
        var sdfNow = SimpleDateFormat("yyyy-MM-dd")

        // nowDate 변수에 값을 저장한다.
        var formatDate = sdfNow.format(date)


        var sdfNow1 = SimpleDateFormat("yyyyMMddHHmmss")

        var formatDate2 = sdfNow1.format(date)

    }

}