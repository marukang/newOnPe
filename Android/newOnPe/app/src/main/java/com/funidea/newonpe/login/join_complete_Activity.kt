package com.funidea.newonpe.login

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.activity_join_complete.*

/** 가입 완료 클래스
 *
 * 사용자가 자신의 가입 정보를 완료하면 가입 완료 시
 * 가입이 완료되었음을 보여준다.
 *
 * 해당 화면에서 확인 버튼을 눌러 다음 로그인 화면으로 이동하게 된다.
 *
 */

class join_complete_Activity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_join_complete)


        //뒤로 가기 버튼
        join_complete_back_button.setOnClickListener(back_button)
        //로그인 버튼
        join_complete_login_button.setOnClickListener(login_button)
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

    //로그인 버튼
    val login_button = View.OnClickListener {
        val intent = Intent(this, login_page_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }
}