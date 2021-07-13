package com.funidea.newonpe.page.youtube

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import com.funidea.utils.change_date_value.Companion.change_time
import com.funidea.utils.save_SharedPreferences
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.utils.side_menu_layout.Companion.side_menu_setting_test
import com.funidea.newonpe.R
import com.funidea.newonpe.page.login.SplashActivity.Companion.serverConnection
import kotlinx.android.synthetic.main.activity_after_school_youtube_content.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException

/**
 * 콘텐츠 관 클래스
 *
 * 방과 후 활동에서 관리자가 올린 컨텐츠 youtube 를 보여준다.
 *
 */

class after_school_youtube_content_Activity : AppCompatActivity() {


    lateinit var youtubeContentAdapter: youtube_content_Adapter

    var youtubeContentItem = ArrayList<youtube_content_Item>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_after_school_youtube_content)

        //사이드 메뉴 세팅
        var v : View = side_menu_layout_after_school_youtube_content
        side_menu_setting_test(after_school_youtube_content_drawerlayout,v, this)


        youtubeContentAdapter = youtube_content_Adapter(this, youtubeContentItem)


        youtube_content_recyclerview.adapter = youtubeContentAdapter

        //사이드 메뉴 버튼
        youtube_content_menu_button.setOnClickListener(side_menu_button)
        //뒤로 가기 버튼
        youtube_content_back_button.setOnClickListener(back_button)

        student_class_code()
    }

    fun student_class_code()
    {
        serverConnection!!.get_student_content_list_admin(student_id, access_token).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    Log.d("결과", "onResponse:"+result)

                    var i : Iterator<String>
                    i =  result.keys()

                    Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {
                        Log.d("결과", "onResponse:"+result)
                        //토큰 갱신
                        access_token = result.getString("student_token")

                        save_SharedPreferences.save_shard(this@after_school_youtube_content_Activity, access_token)


                        var youtube_jsonarray : JSONArray

                        youtube_jsonarray = result.getJSONArray("success")



                        for(i in 0 until youtube_jsonarray.length())
                        {
                            var faq_jsonObject : JSONObject

                            faq_jsonObject = youtube_jsonarray.getJSONObject(i)

                            var content_number = faq_jsonObject.getString("content_number")
                            var content_id = faq_jsonObject.getString("content_id")
                            var content_youtube_url = faq_jsonObject.getString("content_youtube_url")
                            var content_date = change_time(faq_jsonObject.getString("content_date"))


                            youtubeContentItem.add(youtube_content_Item(content_number, content_id,  content_date, content_youtube_url))

                        }

                        //Log.d("로그확인", "onResponse:"+youtube_jsonarray.size)

                        youtubeContentAdapter.notifyDataSetChanged()

                    }
                    //실패 시
                    else
                    {
                        //Custom_Toast.custom_toast(this@faq_Activity, "인터넷 연결 상태를 확인해주세요.")

                    }



                } catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {

                Log.d("실패", "onResponse: "+t)
                Log.d("실패", "onResponse: "+call)

            }
        })


    }

    //사이드 메뉴(햄버거)버튼
    val side_menu_button = View.OnClickListener{
        after_school_youtube_content_drawerlayout.openDrawer(after_school_youtube_content_child_drawerlayout)
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

        after_school_youtube_content_drawerlayout.closeDrawer(after_school_youtube_content_child_drawerlayout)

    }
}