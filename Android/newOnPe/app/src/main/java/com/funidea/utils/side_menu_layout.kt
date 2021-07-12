package com.funidea.utils

import android.app.ActivityOptions
import android.content.Context
import android.content.Intent
import android.view.View
import androidx.drawerlayout.widget.DrawerLayout
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.funidea.utils.change_date_value.Companion.change_time
import com.funidea.utils.set_User_info.Companion.student_name
import com.funidea.utils.set_User_info.Companion.student_recent_exercise_date
import com.funidea.newonpe.faq.faq_Activity
import com.funidea.newonpe.R
import com.funidea.newonpe.after_school_class.after_school_content_Activity
import com.funidea.newonpe.home.class_community_board.class_community_Activity
import com.funidea.newonpe.main_home.MainHomeActivity.Companion.sideMenuClassItem
import com.funidea.newonpe.message.class_message_Activity
import com.funidea.newonpe.my_page.my_page_Activity
import com.funidea.newonpe.my_page.setting_Activity
import com.funidea.newonpe.main_home.side_menu_class_Adapter
import com.funidea.newonpe.SplashActivity
import kotlinx.android.synthetic.main.activity_side_menu.view.*

/** 햄버거 버튼 레이아웃 클래스
 *
 * 햄버거 버튼 클릭 시 보여질 화면
 */

class side_menu_layout
{


    companion object {

        fun side_menu_setting_test(drawerLayout: DrawerLayout,v: View, context: Context)
        {

            var side_menu_class_value : Int = 0
            //View v = (View)findViewById(R.id.side_menu_layout);

            var v : View = v



            //사이드 메뉴 어댑터 및 리사이클러뷰
            var sideMenuClassAdapter = side_menu_class_Adapter(context, sideMenuClassItem)
            var side_menu_class_recyclerview = v.side_menu_class_recyclerview
            side_menu_class_recyclerview.adapter  = sideMenuClassAdapter
            side_menu_class_recyclerview.visibility= View.GONE

            var side_menu_class_button = v.side_menu_class_button
            side_menu_class_button.setOnClickListener{

                if(side_menu_class_value==0)
                {
                    side_menu_class_value = 1
                    side_menu_class_recyclerview.visibility = View.VISIBLE
                    v.side_menu_class_imageview.setImageResource(R.drawable.side_menu_up_image)
                }
                else
                {
                    side_menu_class_value = 0
                    side_menu_class_recyclerview.visibility = View.GONE
                    v.side_menu_class_imageview.setImageResource(R.drawable.side_menu_down_image)
                }
            }

            var side_menu_back_button = v.side_menu_back_button

            side_menu_back_button.setOnClickListener{

                drawerLayout.closeDrawers()
            }

            //마이페이지
            val side_menu_my_page_button_textview = v.side_menu_my_page_button_textview
            side_menu_my_page_button_textview.setOnClickListener {
                val intent = Intent(context, my_page_Activity::class.java)
                //context.startActivity(intent)
                //overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
                val bundle = ActivityOptions.makeCustomAnimation(context, R.anim.anim_slide_in_right, R.anim.anim_slide_out_left).toBundle()
                context.startActivity(intent, bundle)

            }


            //셀프 체육 수업
            val side_menu_self_class_button_textview = v.side_menu_self_class_button_textview
            side_menu_self_class_button_textview.setOnClickListener{

                /*val intent = Intent(context, self_class_Activity::class.java)
                val bundle = ActivityOptions.makeCustomAnimation(context, R.anim.anim_slide_in_right, R.anim.anim_slide_out_left).toBundle()
                context.startActivity(intent, bundle)*/
                val intent = Intent(context, after_school_content_Activity::class.java)
                val bundle = ActivityOptions.makeCustomAnimation(context, R.anim.anim_slide_in_right, R.anim.anim_slide_out_left).toBundle()
                context.startActivity(intent, bundle)

            }
            //방과 후 학교 버튼
            val side_menu_after_school_button_textview = v.side_menu_after_school_button_textview
            side_menu_after_school_button_textview.setOnClickListener{

                val intent = Intent(context, after_school_content_Activity::class.java)
                val bundle = ActivityOptions.makeCustomAnimation(context, R.anim.anim_slide_in_right, R.anim.anim_slide_out_left).toBundle()
                context.startActivity(intent, bundle)
            }

            //커뮤니티 버튼
            val side_menu_community_button_textview = v.side_menu_community_button_textview
            side_menu_community_button_textview.setOnClickListener {
                val intent = Intent(context, class_community_Activity::class.java)
                val bundle = ActivityOptions.makeCustomAnimation(context, R.anim.anim_slide_in_right, R.anim.anim_slide_out_left).toBundle()
                context.startActivity(intent, bundle)
            }


            //자주 묻는 질문
            val side_menu_faq_button_textview = v.side_menu_faq_button_textview
            side_menu_faq_button_textview.setOnClickListener{

                val intent = Intent(context, faq_Activity::class.java)
                val bundle = ActivityOptions.makeCustomAnimation(context, R.anim.anim_slide_in_right, R.anim.anim_slide_out_left).toBundle()
                context.startActivity(intent, bundle)
            }
            //사이드 메뉴 환경 설정
            val side_menu_setting_button_textview = v.side_menu_setting_button_textview
            side_menu_setting_button_textview.setOnClickListener {

                val intent = Intent(context, setting_Activity::class.java)
                val bundle = ActivityOptions.makeCustomAnimation(context, R.anim.anim_slide_in_right, R.anim.anim_slide_out_left).toBundle()
                context.startActivity(intent, bundle)
            }

            val side_menu_message_button_textview = v.side_menu_message_button_textview
            side_menu_message_button_textview.setOnClickListener{

                val intent = Intent(context, class_message_Activity::class.java)
                val bundle = ActivityOptions.makeCustomAnimation(context, R.anim.anim_slide_in_right, R.anim.anim_slide_out_left).toBundle()
                context.startActivity(intent, bundle)

            }


            v.side_menu_user_name_textview.setText(student_name)

            v.side_menu_student_recent_excercise_date_textview.setText(change_time(student_recent_exercise_date))



            Glide.with(context).load(SplashActivity.baseURL + set_User_info.student_image_url)
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .skipMemoryCache(true)
                    .centerCrop()
                    .placeholder(R.drawable.user_profile)
                    .into(v.side_menu_user_profile_imageview)


        }

    }

}