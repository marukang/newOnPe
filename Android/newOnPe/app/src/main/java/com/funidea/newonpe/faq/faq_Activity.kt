package com.funidea.newonpe.faq

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.funidea.utils.Custom_Toast.Companion.custom_toast
import com.funidea.utils.save_SharedPreferences.Companion.save_shard
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.newonpe.R
import com.funidea.newonpe.SplashActivity.Companion.serverConnection
import kotlinx.android.synthetic.main.activity_faq.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException


/** FAQ(자주 묻는 질문)
 *
 * 자주 묻는 질문(FAQ) 클래스
 *
 */

class faq_Activity : AppCompatActivity() {


    lateinit var faqAdapter: faq_Adapter
    val faqItem = ArrayList<faq_Item>()



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_faq)


        get_faq(student_id, access_token)

        faqAdapter = faq_Adapter(this, faqItem)


        faq_recyclerview.adapter = faqAdapter

        faqAdapter.setonItemClickListener(object : faq_Adapter.onItemClickListener{
            override fun item_click(position: Int) {

                val intent = Intent(this@faq_Activity, faq_answer_Activity::class.java)

                //넘버
                intent.putExtra("number", faqItem.get(position).number)
                //제목
                intent.putExtra("title", faqItem.get(position).title)
                //카테고리
                intent.putExtra("category", faqItem.get(position).category)
                //내용
                intent.putExtra("content", faqItem.get(position).content)

                startActivity(intent)
                overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

            }



        })


        //뒤로가기 버튼
        faq_back_button.setOnClickListener(back_button)

        //사이드 메뉴 버튼
        faq_side_menu_button.setOnClickListener(side_menu_button)

        //사이드 메뉴 셋팅
        var v : View = side_menu_layout_faq
        com.funidea.utils.side_menu_layout.side_menu_setting_test(faq_drawerlayout,v, this)

    }


    //사이드 메뉴(햄버거)버튼
    val side_menu_button = View.OnClickListener{
        faq_drawerlayout.openDrawer(faq_child_drawerlayout)
    }
    override fun onStop() {
        super.onStop()

        faq_drawerlayout.closeDrawer(faq_child_drawerlayout)
    }



    //서버서에서 faq 목록 가져오기
    fun get_faq(student_id : String, student_token : String)
    {
        serverConnection!!.get_student_faq(student_id,student_token).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())



                    var i : Iterator<String>
                    i =  result.keys()


                    if(!i.next().equals("fail"))
                    {

                        //토큰 갱신
                        access_token = result.getString("student_token")

                        save_shard(this@faq_Activity, access_token)


                        var faq_jsonarray : JSONArray

                        faq_jsonarray = result.getJSONArray("success")

                        for(i in 0 until faq_jsonarray.length())
                        {
                            var faq_jsonObject : JSONObject

                            faq_jsonObject = faq_jsonarray.getJSONObject(i)

                            var faq_number = faq_jsonObject.getString("faq_number")
                            var faq_title = faq_jsonObject.getString("faq_title")
                            var faq_content = faq_jsonObject.getString("faq_content")
                            var faq_date = faq_jsonObject.getString("faq_date")
                            var faq_type = faq_jsonObject.getString("faq_type")

                            faqItem.add(faq_Item(faq_number, faq_title, faq_type, faq_content, faq_date))
                        }


                        faqAdapter.notifyDataSetChanged()

                    }
                    //실패 시
                    else
                    {
                        custom_toast(this@faq_Activity, "인터넷 연결 상태를 확인해주세요.")

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