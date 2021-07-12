package com.funidea.newonpe.notice_class

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.funidea.utils.*
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.newonpe.R
import com.funidea.newonpe.notice_class.notice_recyclerview_utils.notice_Adapter
import com.funidea.newonpe.notice_class.notice_recyclerview_utils.notice_Item
import com.funidea.newonpe.SplashActivity.Companion.serverConnection
import kotlinx.android.synthetic.main.fragment_all_notice.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException
import kotlin.collections.ArrayList


// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val ARG_PARAM1 = "param1"
private const val ARG_PARAM2 = "param2"


/** all_notice_fragment
 *
 * 전체 공지사항을 보여줄 Fragment
 *
 * 새소식 입장 시 가장 먼저 보여지는 전체 공지사항이며,
 *
 * 관리자(선생님X)가 공지한 내용이 보여진다.
 */

class all_notice_fragment : Fragment() {
    // TODO: Rename and change types of parameters
    private var param1: String? = null
    private var param2: String? = null


    lateinit var noticeAdapter: notice_Adapter
    var allNoticeItem = ArrayList<notice_Item>()



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
        return inflater.inflate(R.layout.fragment_all_notice, container, false)
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)


        noticeAdapter = notice_Adapter(activity!!, allNoticeItem)
        all_notice_recyclerview.adapter = noticeAdapter

        noticeAdapter.setonItemClickListener(object : notice_Adapter.onItemClickListener{
            override fun item_click(position: Int) {


                val intent = Intent(activity!!, show_notice_message_Activity::class.java)

                intent.putExtra("type", "전체공지사항")
                intent.putExtra("number", allNoticeItem.get(position).number)
                intent.putExtra("user_id", allNoticeItem.get(position).user_id)
                intent.putExtra("user_name", allNoticeItem.get(position).user_name)
                intent.putExtra("title", allNoticeItem.get(position).title)
                intent.putExtra("content", allNoticeItem.get(position).content)
                intent.putExtra("write_date", allNoticeItem.get(position).write_date)
                intent.putExtra("show_community_number", allNoticeItem.get(position).show_community_number)

                startActivity(intent)
                activity!!.overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)



            }

        })

    }


    override fun onResume() {
        super.onResume()

        get_my_news("push")
    }

    //클래스 추가하기
    fun get_my_news(type : String)
    {

        serverConnection!!.get_my_news(student_id, access_token,  type).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    Log.d("전체공지조회", "onResponse:"+result)

                    var i : Iterator<String>
                    i =  result.keys()

                    //Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {
                        //토큰 갱신
                        access_token = result.getString("student_token")

                        save_SharedPreferences.save_shard(activity!!, access_token)


                        var all_notice_JSONArray : JSONArray

                        all_notice_JSONArray = result.getJSONArray("success")

                        if(all_notice_JSONArray.length()!=0) {

                            for (i in 0 until all_notice_JSONArray.length()) {
                                var notice_jsonObject: JSONObject

                                notice_jsonObject = all_notice_JSONArray.getJSONObject(i)

                                var push_number = notice_jsonObject.getString("push_number")
                                var push_title = notice_jsonObject.getString("push_title")
                                var push_content = notice_jsonObject.getString("push_content")
                                var push_create_date = notice_jsonObject.getString("push_create_date")
                                var push_state = notice_jsonObject.getString("push_state")

                                allNoticeItem.add(notice_Item(push_number, "", "관리자", push_title,  change_date_value.change_month_time(push_create_date), push_content, "공지사항"))
                            }


                            noticeAdapter.notifyDataSetChanged()
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