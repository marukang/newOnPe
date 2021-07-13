package com.funidea.newonpe.page.home

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.funidea.utils.side_menu_layout.Companion.side_menu_setting_test

import com.funidea.newonpe.R
import com.funidea.newonpe.page.home.class_community_board.class_community_Activity
import com.funidea.newonpe.page.message.class_message_Activity
import kotlinx.android.synthetic.main.activity_after_school_community.*

/** Class_community_menu_Activity Class
 * 사용자가 main_home 에서 커뮤니티 버튼을 클릭해서 이동 시
 * 해당 화면에서 메세지 혹은 커뮤니티로 이동할 수 있는 Menu 화면입니다.
 *
 */

class class_community_menu_Activity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_after_school_community)
        //사이드 메뉴 세팅
        var v : View = side_menu_layout_after_school_community
        side_menu_setting_test(after_school_community_drawerlayout,v, this)

        //뒤로 가기 버튼
        after_school_community_back_button.setOnClickListener(back_button)
        //사이드 메뉴 버튼
        after_school_community_side_menu_button.setOnClickListener(side_menu_button)

        //커뮤니티 화면  이동 버튼
        community_button_linearlayout.setOnClickListener(community_button)
        //메세지 화면 이동 버튼
        message_button_linearlayout.setOnClickListener(message_button)
    }

    //커뮤니티 화면으로 이동하기
    val community_button = View.OnClickListener {

        val intent = Intent(this, class_community_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }

    //메세지 화면으로 이동하기
    val message_button = View.OnClickListener {

        val intent = Intent(this, class_message_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }


    //사이드 메뉴(햄버거)버튼
    val side_menu_button = View.OnClickListener{
        after_school_community_drawerlayout.openDrawer(after_school_community_child_drawerlayout)
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

    override fun onStop() {
        super.onStop()

        after_school_community_drawerlayout.closeDrawer(after_school_community_child_drawerlayout)
    }
}