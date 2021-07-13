package com.funidea.newonpe.page.login

import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import android.widget.Toast
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.activity_add_user_info.*

/** 사용자의 추가정보 [자기소개, 키, 몸무게, 나이]를 입력 클래스  - 현재 사용안함
 *
 */
class MemberDetailedInfoPage : AppCompatActivity() {

    var sex_value : Int = 0
    var user_introduction_value : Boolean = false
    var user_height_value : Boolean = false
    var user_weight_value : Boolean = false
    var user_age_value : Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_add_user_info)


        //자기소개 관련
        add_user_info_input_introduction_edittext.addTextChangedListener(introduction_textWatcher)
        //키
        add_user_info_input_height_edittext.addTextChangedListener(height_textWatcher)
        //몸무게
        add_user_info_input_weight_edittext.addTextChangedListener(weight_textWatcher)
        //나이
        add_user_info_input_age_edittext.addTextChangedListener(age_textWatcher)

        //성별
        add_user_info_male_textview.setOnClickListener(select_male)
        add_user_info_female_textview.setOnClickListener(select_female)

        //저장하기 버튼
        join_page_confirm_textview.setOnClickListener(confirm_button)

        //뒤로가기 버튼
        add_user_info_back_button.setOnClickListener(back_button)
    }

    //확인 버튼
    val confirm_button = View.OnClickListener {

        if(!user_introduction_value||!user_height_value||!user_weight_value||!user_age_value||sex_value==0)
        {
            if(!user_introduction_value){
                Toast.makeText(this, "좌우명를 입력해주세요.", Toast.LENGTH_SHORT).show()
                add_user_info_input_introduction_edittext.requestFocus()
            }
            else if(!user_height_value){
                Toast.makeText(this, "키를 입력해주세요.", Toast.LENGTH_SHORT).show()
                add_user_info_input_height_edittext.requestFocus()
            }
            else if(!user_weight_value){
                Toast.makeText(this, "몸무게를 입력해주세요.", Toast.LENGTH_SHORT).show()
                add_user_info_input_weight_edittext.requestFocus()
            }
            else if(!user_age_value){
                Toast.makeText(this, "나이를 입력해주세요.", Toast.LENGTH_SHORT).show()
                add_user_info_input_age_edittext.requestFocus()
            }
            else if(sex_value==0){
                Toast.makeText(this, "성별을 선택해주세요.", Toast.LENGTH_SHORT).show()

            }


        }
        else
        {
           //Toast.makeText(this, "서버 전송", Toast.LENGTH_SHORT).show()

//            val intent = Intent(this, join_complete_Activity::class.java)
//            startActivity(intent)
//            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
        }

    }


    //뒤로 가기 버튼
    val back_button = View.OnClickListener {
        onBackPressed()
    }

    override fun onBackPressed()
    {
        super.onBackPressed()
        overridePendingTransition(R.anim.anim_slide_in_left, R.anim.anim_slide_out_right)
    }

    //남성 선택
    val select_male = View.OnClickListener {

        add_user_info_male_textview.setBackgroundResource(R.drawable.view_main_color_round_edge)
        add_user_info_male_textview.setTextColor(Color.parseColor("#3378fd"))
        add_user_info_sex_textview.setTextColor(Color.parseColor("#3378fd"))

        add_user_info_female_textview.setBackgroundResource(R.drawable.view_gray_color_round_edge)
        add_user_info_female_textview.setTextColor(Color.parseColor("#9f9f9f"))

        sex_value = 1

        check_value()
    }
    //여성 선택
    val select_female = View.OnClickListener {

        add_user_info_female_textview.setBackgroundResource(R.drawable.view_main_color_round_edge)
        add_user_info_female_textview.setTextColor(Color.parseColor("#3378fd"))
        add_user_info_sex_textview.setTextColor(Color.parseColor("#3378fd"))

        add_user_info_male_textview.setBackgroundResource(R.drawable.view_gray_color_round_edge)
        add_user_info_male_textview.setTextColor(Color.parseColor("#9f9f9f"))

        sex_value = 2

        check_value()
    }



    //자기소개 텍스트 입력 감지
    var introduction_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(add_user_info_input_introduction_edittext.length()>0)
                {
                    add_user_info_input_introduction_textview.setTextColor(Color.parseColor("#3378fd"))
                    add_user_info_input_introduction_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)
                    user_introduction_value = true


                }
                else if(add_user_info_input_introduction_edittext.length()<=0)
                {
                    add_user_info_input_introduction_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    add_user_info_input_introduction_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                    user_introduction_value = false
                }
            }
            else
            {
                add_user_info_input_introduction_textview.setTextColor(Color.parseColor("#9f9f9f"))
                add_user_info_input_introduction_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                user_introduction_value = false

            }

            check_value()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }
    //유저 키 입력
    var height_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(add_user_info_input_height_edittext.length()>0)
                {
                    add_user_info_input_height_textview.setTextColor(Color.parseColor("#3378fd"))
                    add_user_info_input_height_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)

                    user_height_value = true
                }
                else if(add_user_info_input_height_edittext.length()<=0)
                {
                    add_user_info_input_height_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    add_user_info_input_height_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                    user_height_value = false
                }
            }
            else
            {
                add_user_info_input_height_textview.setTextColor(Color.parseColor("#9f9f9f"))
                add_user_info_input_height_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                user_height_value = false
            }

            check_value()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }
    //유저 몸무게 입력
    var weight_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(add_user_info_input_weight_edittext.length()>0)
                {
                    add_user_info_input_weight_textview.setTextColor(Color.parseColor("#3378fd"))
                    add_user_info_input_weight_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)

                    user_weight_value = true
                }
                else if(add_user_info_input_weight_edittext.length()<=0)
                {
                    add_user_info_input_weight_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    add_user_info_input_weight_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                    user_weight_value = false
                }
            }
            else
            {
                add_user_info_input_weight_textview.setTextColor(Color.parseColor("#9f9f9f"))
                add_user_info_input_weight_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                user_weight_value = false
            }

            check_value()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }
    //유저 나이 입력
    var age_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(add_user_info_input_age_edittext.length()>0)
                {
                    add_user_info_input_age_textview.setTextColor(Color.parseColor("#3378fd"))
                    add_user_info_input_age_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)

                    user_age_value = true
                }
                else if(add_user_info_input_age_edittext.length()<=0)
                {
                    add_user_info_input_age_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    add_user_info_input_age_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                    user_age_value = false

                }
            }
            else
            {
                add_user_info_input_age_textview.setTextColor(Color.parseColor("#9f9f9f"))
                add_user_info_input_age_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                user_age_value = false
            }

            check_value()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }

    //버튼 활성화
    fun check_value()
    {

        if(!user_introduction_value||!user_height_value||!user_weight_value||!user_age_value||sex_value==0)
        {
            join_page_confirm_textview.setBackgroundColor(Color.parseColor("#9f9f9f"))
        }
        else
        {
            join_page_confirm_textview.setBackgroundColor(Color.parseColor("#3378fd"))
        }

    }
}