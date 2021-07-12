package com.funidea.newonpe.notice_class

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.activity_show_notice_message.*

/** 새소식 상세 보기 Class
 *
 * 전체공지, 클래스 공지, 선생님 쪽지 내용을 상세 보기 할 수 있는 Class 입니다.
 *
 * 전체 공지, 클래스 공지, 선생님 쪽지 리스트 중 상세 보기를 원하는 View를 클릭하면
 *
 * 해당 화면으로 이동해 상세 조회가 가능합니다.
 *
 */

class show_notice_message_Activity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_show_notice_message)


        //상세 보기 할 내용 가져오기
        var get_intent = intent

        var get_type = get_intent.getStringExtra("type").toString()
        var get_user_name = get_intent.getStringExtra("user_name").toString()
        var get_user_id = get_intent.getStringExtra("user_id").toString()
        var get_title = get_intent.getStringExtra("title").toString()
        var get_content = get_intent.getStringExtra("content").toString()
        var get_write_date = get_intent.getStringExtra("write_date").toString()
        var get_show_community_number = get_intent.getStringExtra("show_community_number").toString()

        if(get_type.equals("선생님메세지"))
        {
            show_notice_title_textview.visibility = View.GONE
            show_notice_message_weight.visibility = View.VISIBLE
            show_notice_write_textview.setText("선생님 : ")

        }


        //메세지,공지사항,클래스 공지사항 자세히보기 Top Title
        show_notice_top_title_textview.setText(get_type)
        //제목
        show_notice_title_textview.setText(get_title)
        //작성자
        show_notice_user_name_textview.setText(get_user_name)
        //작성날짜
        show_notice_write_date_textview.setText(get_write_date)
        //작성 내용
        show_notice_content_textview.setText(get_content)



        //뒤로가기 버튼
        show_notice_message_back_button.setOnClickListener(back_button)
        //확인 버튼
        show_notice_message_confirm_button.setOnClickListener(back_button)


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