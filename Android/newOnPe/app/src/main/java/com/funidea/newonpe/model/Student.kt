package com.funidea.newonpe.model

import com.google.gson.annotations.SerializedName
import org.json.JSONArray

open class Student : BaseModel()
{
    //FCM TOKEN
    @SerializedName("fcm_token")
    var fcm_token : String = ""
    //학생 아이디
    @SerializedName("student_id")
    var student_id : String =""
    //학생 이름
    @SerializedName("student_name")
    var student_name : String =""
    //학생 이메일
    @SerializedName("student_email")
    var student_email : String =""
    //학생 핸드폰 번호
    @SerializedName("student_phone")
    var student_phone : String =""
    //푸시 동의
    @SerializedName("student_push_agreement")
    var student_push_agreement : String =""
    //이메일 인증
    @SerializedName("student_email_agreement")
    var student_email_agreement : String =""

    @SerializedName("student_message_agreement")
    var student_message_agreement : String =""
    //학생 프로필 사진
    @SerializedName("student_image_url")
    var student_image_url : String =""
    //학생 자기소개
    @SerializedName("student_content")
    var student_content : String =""
    //학생 키
    @SerializedName("student_tall")
    var student_tall : String =""
    //학생 몸무게
    @SerializedName("student_weight")
    var student_weight : String =""
    //학생 나이
    @SerializedName("student_age")
    var student_age : String =""
    //학생 성별
    @SerializedName("student_sex")
    var student_sex : String =""
    //학생 학교 명
    @SerializedName("student_school")
    var student_school : String =""
    //학생 학년
    @SerializedName("student_level")
    var student_level : String =""
    //학생 반
    @SerializedName("student_class")
    var student_class : String =""
    //학생 번호
    @SerializedName("student_number")
    var student_number : String =""
    //학생 가입 상태
    @SerializedName("student_state")
    var student_state : String =""
    //새소식
    @SerializedName("news_state")
    var news_state : String =""
    //메세지 여부
    @SerializedName("new_messgae_state")
    var new_messgae_state : String =""
    //클래스 코드
    @SerializedName("student_classcode")
    var student_classcode : String =""
    //가입일자
    @SerializedName("student_create_date")
    var student_create_date : String =""
    //최근 로그인
    @SerializedName("student_recent_join_date")
    var student_recent_join_date : String =""
    //토큰
    @SerializedName("access_token")
    var access_token : String =""
    //클래스 코드
    @SerializedName("student_class_code")
    var student_class_code : String =""
    //최신 운동 일자
    @SerializedName("student_recent_exercise_date")
    var student_recent_exercise_date : String = ""
    //유저 평가 기록
    @SerializedName("user_evaluation_JSONArray")
    var user_evaluation_JSONArray = JSONArray()
    //유저 과제 기록
    @SerializedName("user_task_JSONArray")
    var user_task_JSONArray = JSONArray()
    //유저 실습 기록
    @SerializedName("user_practice_JSONArray")
    var user_practice_JSONArray = JSONArray()
    //유저 그룹 명
    @SerializedName("class_unit_group_name")
    var class_unit_group_name : String =""

    @SerializedName("student_login_type")
    var student_login_type : String =""

    //유저 선택 클래스 코드
    @SerializedName("select_class_code_str")
    var select_class_code_str : String =""
    //유저 선택 클래스 네임
    @SerializedName("select_class_name_str")
    var select_class_name_str : String =""
    //유저 클래스 코드 값 List
    var student_class_code_key_Array = ArrayList<String>()
    //유저 클래스 네임 값 List
    var student_class_code_value_Array = ArrayList<String>()
}