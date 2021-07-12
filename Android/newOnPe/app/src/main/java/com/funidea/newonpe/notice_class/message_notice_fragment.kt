package com.funidea.newonpe.notice_class

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.funidea.utils.change_date_value
import com.funidea.utils.save_SharedPreferences
import com.funidea.utils.set_User_info
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.newonpe.R
import com.funidea.newonpe.notice_class.notice_recyclerview_utils.notice_Adapter
import com.funidea.newonpe.notice_class.notice_recyclerview_utils.notice_Item
import com.funidea.newonpe.SplashActivity
import kotlinx.android.synthetic.main.fragment_message_notice.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException

/** message_notice_fragment
 *
 * 선생님이 보낸 메세지(쪽지)를 보여줄 Fragment
 *
 * 선생님이 학생 개개인에게 보낸 쪽지를 확인 할 수 있는 Fragment이다.
 *
 */


// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val ARG_PARAM1 = "param1"
private const val ARG_PARAM2 = "param2"


class message_notice_fragment : Fragment() {
    // TODO: Rename and change types of parameters
    private var param1: String? = null
    private var param2: String? = null


    lateinit var messageNoticeAdapter: notice_Adapter
    var messageNoticeItem = ArrayList<notice_Item>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            param1 = it.getString(ARG_PARAM1)
            param2 = it.getString(ARG_PARAM2)
        }


    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_message_notice, container, false)
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)


        messageNoticeAdapter = notice_Adapter(activity!!, messageNoticeItem)

        message_notice_recyclerview.adapter = messageNoticeAdapter


        messageNoticeAdapter.setonItemClickListener(object : notice_Adapter.onItemClickListener{
            override fun item_click(position: Int) {


                val intent = Intent(activity!!, show_notice_message_Activity::class.java)

                intent.putExtra("type", "선생님메세지")
                intent.putExtra("number", messageNoticeItem.get(position).number)
                intent.putExtra("user_id", messageNoticeItem.get(position).user_id)
                intent.putExtra("user_name", messageNoticeItem.get(position).show_community_number)
                intent.putExtra("title", messageNoticeItem.get(position).title)
                intent.putExtra("content", messageNoticeItem.get(position).content)
                intent.putExtra("write_date", messageNoticeItem.get(position).write_date)
                intent.putExtra("show_community_number", messageNoticeItem.get(position).show_community_number)

                startActivity(intent)
                activity!!.overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)



            }

        })
    }


    override fun onResume() {
        super.onResume()

        get_my_news("message")
    }


    //클래스 추가하기
    fun get_my_news(type : String)
    {

        SplashActivity.serverConnection!!.get_my_news(set_User_info.student_id, set_User_info.access_token,  type).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    Log.d("공지조회_메세지", "onResponse:"+result)

                    if(messageNoticeItem.size!=0)
                    {
                        messageNoticeItem.clear()
                    }


                    var i : Iterator<String>
                    i =  result.keys()

                    //Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {
                        //토큰 갱신
                        access_token = result.getString("student_token")

                        save_SharedPreferences.save_shard(activity!!, set_User_info.access_token)


                        var all_notice_JSONArray : JSONArray

                        all_notice_JSONArray = result.getJSONArray("success")

                        if(all_notice_JSONArray.length()!=0) {

                            for (i in 0 until all_notice_JSONArray.length()) {
                                var notice_jsonObject: JSONObject

                                notice_jsonObject = all_notice_JSONArray.getJSONObject(i)

                                var message_number = notice_jsonObject.getString("message_number")
                                var id = notice_jsonObject.getString("id")
                                var name = notice_jsonObject.getString("name")
                                var message_content = notice_jsonObject.getString("message_content")
                                var target_id = notice_jsonObject.getString("target_id")
                                var message_date = notice_jsonObject.getString("message_date")


                                messageNoticeItem.add(notice_Item(message_number, id, "", message_content,  change_date_value.change_month_time(message_date), message_content,name+" 선생님"))
                            }


                            messageNoticeAdapter.notifyDataSetChanged()
                        }

                    }
                    //실패 시
                    else
                    {
                        var fail_result_value = result.getString("fail")


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


    companion object {


    }
}