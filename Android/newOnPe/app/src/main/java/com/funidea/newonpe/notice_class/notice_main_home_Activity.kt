package com.funidea.newonpe.notice_class

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.funidea.utils.side_menu_layout.Companion.side_menu_setting_test
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.activity_notice_main_home.*
import kotlinx.android.synthetic.main.activity_notice_main_home.side_menu_layout


/** 새소식 Main 화면
 *
 *  새소식 - 전체 공지, 클래스 공지, 선생님 쪽지 Fragment 를 담는 메인 Activity 입니다.
 *
 *
 */

class notice_main_home_Activity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_notice_main_home)


        //사이드 메뉴
        //사이드 메뉴 세팅
        var v : View = side_menu_layout

        side_menu_setting_test(notice_main_home_drawerview, v, this)


        //전체 공지 Fragment
        val allNoticeFragment = all_notice_fragment()
        //클래스 공지사항 Fragment
        val classNoticeFragment = class_notice_fragment()
        //선생님 메세지 공지사항 Fragment
        val messageNoticeFragment = message_notice_fragment()

        //ViewPager Adapter
        val sectionPageAdapter = SectionPageAdapter(supportFragmentManager)


        sectionPageAdapter.addFragment(allNoticeFragment, "전체 공지사항")
        sectionPageAdapter.addFragment(classNoticeFragment, "클래스 공지사항")
        sectionPageAdapter.addFragment(messageNoticeFragment, "선생님 메세지")

        notice_container!!.adapter = sectionPageAdapter

        notice_tab.setupWithViewPager(notice_container)
        //뒤로 가기 버튼
        notice_main_home_back_button.setOnClickListener(back_button)
        //햄버거 버튼
        notice_main_home_side_button.setOnClickListener(side_menu_button)
    }

    //사이드 메뉴(햄버거)버튼
    val side_menu_button = View.OnClickListener {

        notice_main_home_drawerview.openDrawer(notice_main_home_child_drawerview)

    }

    override fun onStop() {
        super.onStop()

        notice_main_home_drawerview.closeDrawer(notice_main_home_child_drawerview)
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