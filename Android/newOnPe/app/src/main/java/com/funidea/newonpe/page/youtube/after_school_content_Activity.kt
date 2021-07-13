package com.funidea.newonpe.page.youtube

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.funidea.utils.side_menu_layout.Companion.side_menu_setting_test

import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.activity_after_school_content.*

/**
 *  방과 후 활동 컨텐츠 메뉴 클래스
 *
 * 방과 후 활동에서 메뉴를 선택하는 화면을 나타내는 클래스
 *
 * 사용자는 해당 화면에서 메뉴를 선택해 다음 화면으로 이동한다.
 *
 */

class after_school_content_Activity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_after_school_content)

        //사이드 메뉴
        var v : View = side_menu_layout_after_school_content
        side_menu_setting_test(after_school_content_drawerlayout, v, this)

        //사이드 메뉴 셋팅
        after_school_content_menu_button.setOnClickListener(side_menu_button)
        //유튜브 콘텐츠관 이동 버튼
        after_school_content_youtube_button.setOnClickListener(youtube_content_button)
        //뒤로가기 버튼
        after_school_content_back_button.setOnClickListener(back_button)
    }


    //사이드 메뉴(햄버거)버튼
    val side_menu_button = View.OnClickListener{
        after_school_content_drawerlayout.openDrawer(after_school_content_child_drawerlayout)
    }

    //유튜브 콘텐츠관 이동 버튼
    val youtube_content_button = View.OnClickListener {

        val intent = Intent(this, after_school_youtube_content_Activity::class.java)
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

    override fun onStop() {
        super.onStop()

        after_school_content_drawerlayout.closeDrawer(after_school_content_child_drawerlayout)
    }

}