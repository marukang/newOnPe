package com.funidea.newonpe.page.faq

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.activity_faq_answer.*

/** FAQ [자주 묻는 질문] - 상세 확인 페이지[faq 답변 보기]
 *
 * 자주 묻는 질문 화면리스트에서 자주 묻는 질문에 대한 상세 답변을 보는 페이지
 *
 */

class faq_answer_Activity : AppCompatActivity() {

    var get_number : String = ""
    var get_title : String = ""
    var get_category : String = ""
    var get_content : String = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_faq_answer)

        val intent = intent

        //번호
        get_number = intent.getStringExtra("number").toString()
        //타이틀
        get_title = intent.getStringExtra("title").toString()
        //카테고리
        get_category = intent.getStringExtra("category").toString()
        //내용
        get_content = intent.getStringExtra("content").toString()

        //타이틀
        faq_answer_title_textview.setText(get_title)
        //카테고리
        faq_answer_category_textview.setText(get_category)
        //내용
        faq_answer_content_textview.setText(get_content)

        //뒤로가기 버튼
        faq_answer_back_button.setOnClickListener(back_button)


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