package com.funidea.newonpe.login.search_id_pw

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.funidea.newonpe.R
import com.funidea.newonpe.login.login_page_Activity
import kotlinx.android.synthetic.main.activity_id_search.*
import kotlinx.android.synthetic.main.activity_id_search_complete.*


/** ID 찾기 완료 Class
 *
 * 사용자가 ID를 분실한 경우 이름과 이메일을 통해 ID를 조회하고
 * 일치하는 ID가 있을 경우 해당 클래스에서 ID 결과를 보여준다.
 *
 * */

class id_search_complete_Activity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_id_search_complete)

        var getIntent = intent

        //찾기 결과 아이디 값
        id_search_complete_user_id_textview.setText(getIntent.getStringExtra("search_id"))

        //뒤로 가기 버튼
        id_search_complete_back_button.setOnClickListener(back_button)

        //로그인하러 가기 버튼
        id_search_complete_login_button_textview.setOnClickListener(login_button)
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
        finish()
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }
}