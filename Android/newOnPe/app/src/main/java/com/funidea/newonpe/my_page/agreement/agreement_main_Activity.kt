package com.funidea.newonpe.my_page.agreement

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.activity_agreement_main.*

/** 서비스 이용 관련 약관을 List 형태로 보여주는 Class
 *
 * 서비스 이용약관, 개인정보 처리 방침 상세 보기를 위한 List 화면
 *
 */


class agreement_main_Activity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_agreement_main)


        //서비스 이용약관
        personal_agreement_button_linearlayout.setOnClickListener(personal_agreement)
        //개인정보 처리 방침
        terms_of_user_information_agreement_button_linearlayout.setOnClickListener(terms_of_user_information_agreement)
        //뒤로 가기 버튼
        agreement_back_button.setOnClickListener(back_button)


    }

    //서비스 이용약관
    val personal_agreement = View.OnClickListener {

        val intent = Intent(this, personal_information_agreement_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


    }
    //개인정보 처리 방침
    val terms_of_user_information_agreement = View.OnClickListener {

        val intent = Intent(this, terms_of_user_information_agreement_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


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


}