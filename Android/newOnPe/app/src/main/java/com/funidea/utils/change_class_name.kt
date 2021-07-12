package com.funidea.utils

import android.content.Context

/**
 * 클래스 이름 추출
 *
 * 클래스 코드 입력 시
 * 입력한 클래스 코드에서 학교 이름을 추출해준다.
 *
 */

class change_class_name()
{

    companion object {


        fun input_change_class_name(context: Context ,input_class_code: String): String {

            if (input_class_code.contains("_")) {

                val split_class_code = input_class_code.split("_")

                var school_name = split_class_code[0]

                var class_info: String = split_class_code[1]

                var class_grade: String = class_info[0].toString()

                var class_group: String = class_info[1].toString()+class_info[2].toString()

                var class_semester: String = class_info[3].toString()

                if (class_semester.equals("1")) class_semester = "1학기"
                else if (class_semester.equals("2")) class_semester = "2학기"
                else if (class_semester.equals("3")) class_semester = "봄방학학기"
                else if (class_semester.equals("4")) class_semester = "여름방학학기"
                else if (class_semester.equals("5")) class_semester = "겨울방학학기"
                else if (class_semester.equals("6")) class_semester = "기타학기"

                var sum_str = school_name + class_grade + "학년" + class_group + "반" + class_semester


                return sum_str


            } else {
                //custom_toast(context, "클래스코드 양식에 맞추어 다시 입력해주세요.")

                return ""
            }
        }


    }
}