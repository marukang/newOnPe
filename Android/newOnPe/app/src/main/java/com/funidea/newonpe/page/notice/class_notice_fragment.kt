package com.funidea.newonpe.page.notice

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
import com.funidea.utils.set_User_info.Companion.select_class_code_str
import com.funidea.utils.set_User_info.Companion.select_class_name_str
import com.funidea.newonpe.dialog.InsertClassCodeDialog
import com.funidea.newonpe.dialog.ClassCodeItem
import com.funidea.newonpe.R
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import kotlinx.android.synthetic.main.fragment_class_notice.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException


/** class_notice_fragment
 *
 * 클래스 공지사항이 보여지는 곳이다.
 *
 * 각 클래스 별로 선생님이 공지한 내용을 확인 할 수 있으며, 상단 클래스 변경을 통해 자신이 원하는 클래스의
 * 공지사항을 확인할 수 있다.
 *
 */

class class_notice_fragment : Fragment() {

    // TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private val ARG_PARAM1 = "param1"
    private val ARG_PARAM2 = "param2"

    // TODO: Rename and change types of parameters
    private var param1: String? = null
    private var param2: String? = null

    var class_code_default_position : Int = 0
    var classCodeDialogItem = ArrayList<ClassCodeItem>()
    var class_code_number : String =""

    lateinit var classNoticeAdapter: notice_Adapter
    var ClassNoticeItem = ArrayList<notice_Item>()



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
        return inflater.inflate(R.layout.fragment_class_notice, container, false)
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        class_code_number = select_class_code_str

        classNoticeAdapter = notice_Adapter(activity!!, ClassNoticeItem)

        class_notice_recyclerview.adapter = classNoticeAdapter


        classNoticeAdapter.setonItemClickListener(object : notice_Adapter.onItemClickListener{
            override fun item_click(position: Int) {


                val intent = Intent(activity!!, show_notice_message_Activity::class.java)

                intent.putExtra("type", "클래스공지사항")
                intent.putExtra("number", ClassNoticeItem.get(position).number)
                intent.putExtra("user_id", ClassNoticeItem.get(position).user_id)
                intent.putExtra("user_name", ClassNoticeItem.get(position).user_name)
                intent.putExtra("title", ClassNoticeItem.get(position).title)
                intent.putExtra("content", ClassNoticeItem.get(position).content)
                intent.putExtra("write_date", ClassNoticeItem.get(position).write_date)
                intent.putExtra("show_community_number", ClassNoticeItem.get(position).show_community_number)

                startActivity(intent)
                activity!!.overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)



            }

        })



        class_notice_class_code_name_textview.setText(select_class_name_str)

        if(set_User_info.student_class_code_key_Array.size!=0)
        {
            for(i in set_User_info.student_class_code_key_Array.indices)
            {
                if(set_User_info.student_class_code_key_Array.get(i).equals(set_User_info.select_class_code_str))
                {
                    classCodeDialogItem.add(ClassCodeItem(set_User_info.student_class_code_value_Array.get(i), set_User_info.student_class_code_key_Array.get(i),1))
                    class_code_default_position = i
                    //임의 값
                    class_code_number = set_User_info.student_class_code_key_Array.get(i)
                }
                else
                {
                    classCodeDialogItem.add(ClassCodeItem(set_User_info.student_class_code_value_Array.get(i), set_User_info.student_class_code_key_Array.get(i),0))
                }

            }

        }

        class_notice_class_code_button_linearlayout.setOnClickListener(change_class_code)
    }

    val change_class_code = View.OnClickListener {

        val classCodeDialog = InsertClassCodeDialog(activity!!, classCodeDialogItem)

        classCodeDialog.show()

        classCodeDialog.setclassCodeSelectListener(object : InsertClassCodeDialog.classCodeSelectListener{
            override fun select_code_value(select_code_name: String, select_code: String, select_position: Int?) {

                classCodeDialog.dismiss()

                classCodeDialogItem.set(select_position!!, classCodeDialogItem[select_position]).class_select_value = 1
                classCodeDialogItem.set(class_code_default_position, classCodeDialogItem[class_code_default_position]).class_select_value = 0
                class_code_default_position = select_position
                class_notice_class_code_name_textview.setText(select_code_name)


                class_code_number = select_code


                get_my_news("notice", class_code_number)
                //get_class_community_list(class_code_number)

            }

        })

    }


    override fun onResume() {
        super.onResume()

        get_my_news("notice", class_code_number)
    }

    //클래스 추가하기
    fun get_my_news(type : String, class_code : String)
    {

        serverConnectionSpec!!.get_my_news_in_class(set_User_info.student_id, set_User_info.access_token,type, class_code).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    Log.d("공지조회_클래스", "onResponse:"+result)

                    var i : Iterator<String>
                    i =  result.keys()

                    //Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {
                        if(ClassNoticeItem.size!=0)
                        {
                            ClassNoticeItem.clear()
                            classNoticeAdapter.notifyDataSetChanged()
                        }

                        //토큰 갱신
                        set_User_info.access_token = result.getString("student_token")

                        save_SharedPreferences.save_shard(activity!!, set_User_info.access_token)


                        var class_notice_JSONArray : JSONArray

                        class_notice_JSONArray = result.getJSONArray("success")

                        if(class_notice_JSONArray.length()!=0) {

                            var all_notice_size = class_notice_JSONArray.length()

                            for (i in 0 until class_notice_JSONArray.length()) {
                                var notice_jsonObject: JSONObject

                                notice_jsonObject = class_notice_JSONArray.getJSONObject(i)

                                var notice_number = notice_jsonObject.getString("notice_number")
                                var notice_id = notice_jsonObject.getString("notice_id")
                                var notice_name = notice_jsonObject.getString("notice_name")
                                var notice_title = notice_jsonObject.getString("notice_title")
                                var notice_content = notice_jsonObject.getString("notice_content")
                                var notice_date = notice_jsonObject.getString("notice_date")

                                ClassNoticeItem.add(notice_Item(notice_number, notice_id, notice_name, notice_content,  change_date_value.change_month_time(notice_date), notice_title, all_notice_size.toString()))

                                all_notice_size = all_notice_size - 1
                            }


                            classNoticeAdapter.notifyDataSetChanged()
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