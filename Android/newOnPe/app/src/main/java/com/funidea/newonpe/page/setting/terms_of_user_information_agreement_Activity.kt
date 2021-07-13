package com.funidea.newonpe.page.setting

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.method.ScrollingMovementMethod
import android.view.View
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.activity_terms_of_user_information_agreement.*

/** 개인정보처리방침 화면
 *
 *  개인정보처리방침이 보여질 화면 입니다.
 */

class terms_of_user_information_agreement_Activity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_terms_of_user_information_agreement)

        user_info_agreement_textview.setMovementMethod(ScrollingMovementMethod())

        terms_of_user_info_agreement_confirm_button.setOnClickListener(back_button)
        terms_of_user_info_agreement_back_button.setOnClickListener(back_button)
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