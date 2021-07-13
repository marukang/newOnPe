package com.funidea.newonpe.page.management

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.funidea.newonpe.page.faq.faq_Activity
import com.funidea.newonpe.R
import com.funidea.newonpe.page.youtube.after_school_content_Activity
import com.funidea.newonpe.page.home.class_community_board.class_community_Activity
import com.funidea.newonpe.page.main.MainHomeActivity
import com.funidea.newonpe.page.setting.my_page_Activity
import com.funidea.newonpe.page.setting.SettingPage
import com.funidea.newonpe.page.main.side_menu_class_Adapter
import kotlinx.android.synthetic.main.activity_self_class.*
import kotlinx.android.synthetic.main.activity_side_menu.*
import kotlinx.android.synthetic.main.activity_side_menu.view.*

/** Self 체육 수업 Class
 *  현재는 사용 중 X
 *
 *  관리자가 선정한 '오늘의 수업' 혹은
 *  사용자가 직접 조합해서 운동을 진행할 수 있는 '셀프 운동 조합' 화면으로
 *  이동할 수 있는 Menu가 보여지는 View
 *
 */

class self_class_Activity : AppCompatActivity() {




    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_self_class)

        self_class_back_button.setOnClickListener(back_button)

        //나만의 조합 만들기 수업
        self_class_custom_class_linearlayout.setOnClickListener(custom_class)


        //사이드 메뉴 버튼
        self_class_side_menu_button.setOnClickListener(side_menu_button)
        //사이드 메뉴 셋팅
        side_menu_setting()
    }

    //사이드 메뉴 셋팅
    fun side_menu_setting()
    {
        //View v = (View)findViewById(R.id.side_menu_layout);

        var v : View = self_class_child_drawerlayout
        var sideMenuClassAdapter: side_menu_class_Adapter
        var side_menu_class_value : Int = 0
        //사이드 메뉴 어댑터 및 리사이클러뷰
        sideMenuClassAdapter = side_menu_class_Adapter(this, MainHomeActivity.sideMenuClassItem)
        var side_menu_class_recyclerview = v.side_menu_class_recyclerview
        side_menu_class_recyclerview.adapter  = sideMenuClassAdapter
        side_menu_class_recyclerview.visibility= View.GONE

        var side_menu_class_button = v.side_menu_class_button
        side_menu_class_button.setOnClickListener{

            if(side_menu_class_value==0)
            {
                side_menu_class_value = 1
                side_menu_class_recyclerview.visibility = View.VISIBLE
                side_menu_class_imageview.setImageResource(R.drawable.side_menu_up_image)
            }
            else
            {
                side_menu_class_value = 0
                side_menu_class_recyclerview.visibility = View.GONE
                side_menu_class_imageview.setImageResource(R.drawable.side_menu_down_image)
            }
        }

        //마이페이지
        val side_menu_my_page_button_textview = v.side_menu_my_page_button_textview
        side_menu_my_page_button_textview.setOnClickListener {
            val intent = Intent(this, my_page_Activity::class.java)
            startActivity(intent)
            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

        }

        //셀프 체육 수업
        val side_menu_self_class_button_textview = v.side_menu_self_class_button_textview
        side_menu_self_class_button_textview.setOnClickListener{
            val intent = Intent(this, after_school_content_Activity::class.java)
            startActivity(intent)
            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

        }

        //방과 후 학교 버튼
        val side_menu_after_school_button_textview = v.side_menu_after_school_button_textview
        side_menu_after_school_button_textview.setOnClickListener{
            val intent = Intent(this, after_school_content_Activity::class.java)
            startActivity(intent)
            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

        }

        //커뮤니티 버튼
        val side_menu_community_button_textview = v.side_menu_community_button_textview
        side_menu_community_button_textview.setOnClickListener {
            val intent = Intent(this, class_community_Activity::class.java)
            startActivity(intent)
            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

        }


        //자주 묻는 질문
        val side_menu_faq_button_textview = v.side_menu_faq_button_textview
        side_menu_faq_button_textview.setOnClickListener{

            val intent = Intent(this, faq_Activity::class.java)
            startActivity(intent)
            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

        }
        //사이드 메뉴 환경 설정
        val side_menu_setting_button_textview = v.side_menu_setting_button_textview
        side_menu_setting_button_textview.setOnClickListener {

            val intent = Intent(this, SettingPage::class.java)
            startActivity(intent)
            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

        }


    }

    //사이드 메뉴(햄버거)버튼
    val side_menu_button = View.OnClickListener{
        self_class_drawerlayout.openDrawer(self_class_child_drawerlayout)
    }
    override fun onStop() {
        super.onStop()

        self_class_drawerlayout.closeDrawer(self_class_child_drawerlayout)
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

    //직접조합 운동
    //현재 사용 X
    var custom_class = View.OnClickListener {

        val intent = Intent(this, self_class_select_exercise_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


    }


}