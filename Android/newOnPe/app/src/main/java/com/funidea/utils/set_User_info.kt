package com.funidea.utils

import org.json.JSONArray
import org.json.JSONObject

/* 서버에서 받아온 Data에서 유저 정보를 추출 및 저장해둔다.
*
*
* */
class set_User_info
{



    companion object {

        //FCM TOKEN
        @JvmStatic var fcm_token : String = ""
        //학생 아이디
        @JvmStatic var student_id : String =""
        //학생 이름
        @JvmStatic var student_name : String =""
        //학생 이메일
        @JvmStatic var student_email : String =""
        //학생 핸드폰 번호
        @JvmStatic var student_phone : String =""
        //푸시 동의
        @JvmStatic var student_push_agreement : String =""
        //이메일 인증
        @JvmStatic var student_email_agreement : String =""
        @JvmStatic var student_message_agreement : String =""
        //학생 프로필 사진
        @JvmStatic var student_image_url : String =""
        //학생 자기소개
        @JvmStatic var student_content : String =""
        //학생 키
        @JvmStatic var student_tall : String =""
        //학생 몸무게
        @JvmStatic var student_weight : String =""
        //학생 나이
        @JvmStatic var student_age : String =""
        //학생 성별
        @JvmStatic var student_sex : String =""
       //학생 학교 명
        @JvmStatic var student_school : String =""
       //학생 학년
        @JvmStatic var student_level : String =""
       //학생 반
        @JvmStatic var student_class : String =""
       //학생 번호
        @JvmStatic var student_number : String =""
       //학생 가입 상태
        @JvmStatic var student_state : String =""
       //새소식
        @JvmStatic var news_state : String =""
       //메세지 여부
        @JvmStatic var new_messgae_state : String =""
       //클래스 코드
        @JvmStatic var student_classcode : String =""
       //가입일자
        @JvmStatic var student_create_date : String =""
        //최근 로그인
        @JvmStatic var student_recent_join_date : String =""
        //토큰
        @JvmStatic var access_token : String =""
        //클래스 코드
        @JvmStatic var student_class_code : String =""
        //최신 운동 일자
        @JvmStatic var student_recent_exercise_date : String = ""
        //유저 평가 기록
        @JvmStatic var user_evaluation_JSONArray = JSONArray()
        //유저 과제 기록
        @JvmStatic var user_task_JSONArray = JSONArray()
        //유저 실습 기록
        @JvmStatic var user_practice_JSONArray = JSONArray()
        //유저 그룹 명
        @JvmStatic var class_unit_group_name : String =""

        @JvmStatic var student_login_type : String =""

        //유저 선택 클래스 코드
        var select_class_code_str : String =""
        //유저 선택 클래스 네임
        var select_class_name_str : String =""
        //유저 클래스 코드 값 List
        var student_class_code_key_Array = ArrayList<String>()
        //유저 클래스 네임 값 List
        var student_class_code_value_Array = ArrayList<String>()

        //로그아웃 시 기존 정보 초기화
        fun set_clear()
        {
            fcm_token = ""
            student_id =""
            student_name =""
            student_email =""
            student_phone =""
            student_push_agreement  =""
            student_email_agreement  =""
            student_message_agreement  =""
            student_image_url  =""
            student_content  =""
            student_tall  =""
            student_weight  =""
            student_age  =""
            student_sex  =""
            student_school  =""
            student_level  =""
            student_class  =""
            student_number  =""
            student_state  =""
            news_state  =""
            new_messgae_state  =""
            student_classcode  =""
            student_create_date  =""
            student_recent_join_date  =""
            access_token  =""
            student_class_code  =""
            select_class_code_str  =""
            select_class_name_str  =""
            student_recent_exercise_date = ""
            student_class_code_key_Array.clear()
            student_class_code_value_Array.clear()
        }
    }


    //유저 정보 수정
    fun set_user_info(result_value: JSONObject )
    {
        student_id = result_value.getString("student_id")
        student_name = result_value.getString("student_name")
        student_email = result_value.getString("student_email")
        if(!result_value.isNull("student_phone")) student_phone = result_value.getString("student_phone")
        student_push_agreement = result_value.getString("student_push_agreement")
        student_email_agreement = result_value.getString("student_email_agreement")
        student_message_agreement = result_value.getString("student_message_agreement")
        if(!result_value.isNull("student_image_url")) student_image_url = result_value.getString("student_image_url")
        if(!result_value.isNull("student_content"))student_content = result_value.getString("student_content")
        if(!result_value.isNull("student_tall"))student_tall = result_value.getString("student_tall")
        if(!result_value.isNull("student_weight"))student_weight = result_value.getString("student_weight")
        if(!result_value.isNull("student_age"))student_age = result_value.getString("student_age")
        student_sex = result_value.getString("student_sex")
        if(!result_value.isNull("student_school"))student_school = result_value.getString("student_school")
        if(!result_value.isNull("student_level"))student_level = result_value.getString("student_level")
        if(!result_value.isNull("student_class"))student_class = result_value.getString("student_class")
        if(!result_value.isNull("student_number"))student_number = result_value.getString("student_number")
        student_state = result_value.getString("student_state")
        news_state = result_value.getString("news_state")
        new_messgae_state = result_value.getString("new_messgae_state")
        student_classcode = result_value.getString("student_classcode")
        student_create_date = result_value.getString("student_create_date")
        student_recent_join_date = result_value.getString("student_recent_join_date")
        access_token = result_value.getString("access_token")
        student_recent_exercise_date = result_value.getString("student_recent_exercise_date")


        if(!result_value.isNull("student_classcode")){

        student_class_code = result_value.getString("student_classcode")



        var class_code_JSONArray = JSONArray(student_class_code)

        if(student_class_code_key_Array.size!=0)
        {
                student_class_code_key_Array.clear()
        }
        if(student_class_code_value_Array.size!=0)
        {
            student_class_code_value_Array.clear()
        }


        for(i in 0 until class_code_JSONArray.length())
        {

            var j : Iterator<String>

            j = JSONObject(class_code_JSONArray.get(i).toString()).keys()

            var jsonObject = JSONObject(class_code_JSONArray.get(i).toString())

            student_class_code_value_Array.add(jsonObject.getString(j.next()))

        }

        for(i in 0 until class_code_JSONArray.length())
        {



            var j : Iterator<String>

            j = JSONObject(class_code_JSONArray.get(i).toString()).keys()

           if(j.hasNext())
           {


               student_class_code_key_Array.add(j.next())
           }

        }

        }

    }



}