package com.funidea.newonpe.my_page.agreement

import android.os.Bundle
import android.text.method.ScrollingMovementMethod
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.activity_personal_information_agreement.*

/** 서비스 이용 약관 화면
 *
 *   서비스 이용 약관 보여질 화면 입니다.
 */

class personal_information_agreement_Activity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_personal_information_agreement)


        agreement_1_textview.setMovementMethod(ScrollingMovementMethod())
        agreement_2_textview.setMovementMethod(ScrollingMovementMethod())
        personal_info_agreement_back_button.setOnClickListener(back_button)
        personal_info_agreement_confirm_button.setOnClickListener(back_button)
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