package com.funidea.newonpe.page.home.class_community_board

import android.app.AlertDialog
import android.content.Intent
import android.os.Bundle
import android.text.Html
import android.text.TextUtils
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.funidea.utils.CustomToast
import com.funidea.utils.change_date_value.Companion.change_time
import com.funidea.utils.change_date_value.Companion.change_time_include_second
import com.funidea.utils.SimpleSharedPreferences.Companion.saveAccessToken
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.utils.set_User_info.Companion.student_name
import com.funidea.utils.side_menu_layout.Companion.side_menu_setting_test
import com.funidea.newonpe.R
import com.funidea.newonpe.model.FileItem
import com.funidea.newonpe.page.home.show_photo_Activity
import com.funidea.newonpe.page.login.LoginPage.Companion.baseURL
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import kotlinx.android.synthetic.main.activity_class_community_board.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException

/* 커뮤니티 글 상세보기 페이지
 *
 * 커뮤니티에서 글 리스트 중 클릭해 들어온 경우 상세 보기 페이지
 *
 * 작성 된 커뮤니티 글을 볼 수 있으며, 달린 댓글과 첨부파일 등을 확인할 수 있습니다.
 *
 */

class class_community_board_Activity : AppCompatActivity() {

    //첨부파일
    lateinit var boardFileAdapter: board_file_Adapter
    var get_file_Array = ArrayList<FileItem>()
    //댓글
    lateinit var boardCommentAdapter: board_comment_Adapter
    var boardCommentItem = ArrayList<board_comment_Item>()

    //게시글 번호
    var get_board_number : String =""

    //제목
    var get_title : String = ""
    //내용
    var get_content : String = ""
    //날짜
    var get_date : String = ""

    //첨부 이미지 1
    var community_file1 : String = ""
    //첨부 이미지 2
    var community_file2 : String = ""


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_class_community_board)

        //받아오기
        val intent = intent

        //번호
        get_board_number = intent.getStringExtra("number").toString()

        boardFileAdapter = board_file_Adapter(this, get_file_Array)
        boardCommentAdapter = board_comment_Adapter(this, boardCommentItem)

        board_comment_recyclerview.adapter = boardCommentAdapter


        //뒤로가기 버튼
        community_board_back_button.setOnClickListener(back_button)
        //댓글 등록하기 버튼
        community_board_comment_confirm_button_textview.setOnClickListener(upload_comment)
        //사이드 메뉴 버튼
        community_board_side_menu_button.setOnClickListener(side_menu_button)
        //리스트로 돌아가기 버튼
        community_board_list_button_textview.setOnClickListener(back_button)
        //수정 버튼
        community_board_edit_button_textview.setOnClickListener(edit_button)
        //삭제 버튼
        community_board_delete_button_textview.setOnClickListener(delete_button)

        community_board_file_list_linearlayout.visibility = View.GONE
        community_board_file_1_linearlayout.visibility = View.GONE
        community_board_file_2_linearlayout.visibility = View.GONE

        community_board_file_1_linearlayout.setOnClickListener(show_photo_button_1)
        community_board_file_2_linearlayout.setOnClickListener(show_photo_button_2)

        //첨부파일 클릭 리스너
        boardFileAdapter.setonItemClickListener(object  : board_file_Adapter.onItemClickListener{
            override fun item_click(position: Int) {

                //파일 URL을 가져와서 바꿔준다!
                get_file_Array.get(position).file_url

            }
        })
        //코맨트 리스너
        boardCommentAdapter.setonItemClickListener(object : board_comment_Adapter.onItemClickListener{
            override fun item_delete(position: Int) {

                //정말 삭제하시겠습니까 라는 AlertDialog 생성
                val builder = AlertDialog.Builder(this@class_community_board_Activity)
                builder.setMessage("정말로 삭제하시겠습니까?")
                builder.setPositiveButton("확인") { dialogInterface, i ->

                    //서버로 삭제 안내 해주기
                    delete_student_community_comment_list(get_board_number, boardCommentItem.get(position).comment_number, position)
                    dialogInterface.dismiss()
                }
                builder.setNegativeButton("취소") { dialogInterface, i ->
                    dialogInterface.dismiss()
                }
                val dialog: AlertDialog = builder.create()
                dialog.show()
            }

        })

        //사이드 메뉴
        var v : View = side_menu_layout_board
        side_menu_setting_test(class_community_board_drawerlayout,v, this)
    }

    override fun onResume() {
        super.onResume()

       //내부 내용 불러오기
       get_student_community(get_board_number)

        //코멘트 수가 0 이 아니라면 날리고 다시 해주기
        if(boardCommentItem.size!=0)
        {
            boardCommentItem.clear()
        }
       //코멘트 불러오기
       get_student_community_comment_list(get_board_number)
    }
    //사진 보여주기
    val show_photo_button_1 = View.OnClickListener {

        val intent = Intent(this, show_photo_Activity::class.java)
        intent.putExtra("community_file", community_file1)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

    }
    val show_photo_button_2 = View.OnClickListener {

        val intent = Intent(this, show_photo_Activity::class.java)
        intent.putExtra("community_file", community_file2)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

    }

    //댓글 불러오기
    fun get_student_community_comment_list(community_number : String )
    {
        serverConnectionSpec!!.get_student_community_comment_list(student_id, access_token, community_number).enqueue(object : Callback<ResponseBody> {
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
                          saveAccessToken(this@class_community_board_Activity, access_token)

                          var comment_jsonarray : JSONArray
                          comment_jsonarray = result.getJSONArray("success")


                          for(i in 0 until comment_jsonarray.length())
                          {
                              var comment_jsonObject : JSONObject

                              comment_jsonObject = comment_jsonarray.getJSONObject(i)



                              var comment_number = comment_jsonObject.getString("comment_number")
                              var comment_community_number = comment_jsonObject.getString("comment_community_number")
                              var comment_id = comment_jsonObject.getString("comment_id")
                              var comment_name = comment_jsonObject.getString("comment_name")
                              var comment_content = comment_jsonObject.getString("comment_content")
                              var comment_date = change_time_include_second(comment_jsonObject.getString("comment_date"))



                              if(comment_id.equals(student_id))
                              {
                                  boardCommentItem.add(board_comment_Item(comment_number,comment_community_number, comment_id,comment_name, comment_content, comment_date, 1))
                              }
                              else
                              {
                                  boardCommentItem.add(board_comment_Item(comment_number,comment_community_number, comment_id,comment_name, comment_content, comment_date, 0))
                              }
                          }

                          boardCommentAdapter.notifyDataSetChanged()

                      }
                      //실패 시
                      else
                      {
                          CustomToast.show(this@class_community_board_Activity, "인터넷 연결 상태를 확인해주세요.")

                      }


                } catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {


                CustomToast.show(this@class_community_board_Activity, "인터넷 연결 상태를 확인해주세요.")

            }
        })
    }

    //게시글 상세 정보 가져오기
    fun get_student_community(community_number : String )
    {
        serverConnectionSpec!!.get_student_community(student_id, access_token, community_number).enqueue(object : Callback<ResponseBody> {
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

                        saveAccessToken(this@class_community_board_Activity, access_token)

                        var success_value : JSONObject

                        success_value = result.getJSONObject("success")

                        //타이틀
                        community_board_title_textview.setText(success_value.getString("community_title"))
                        //내용
                        var html_value = success_value.getString("community_text").toString()
                        Log.d("값보기", "onResponse:"+html_value)
                        if(html_value.contains("& lt;")||
                                html_value.contains("& gt;"))
                        {
                            //Log.d("값보기", "onResponse:"+html_value)

                            webview_test.settings.javaScriptEnabled = true


                            webview_test.getSettings().setUseWideViewPort(true);// wide viewport를 사용하도록 설정
                            webview_test.getSettings().setLoadWithOverviewMode(true);// 컨텐츠가 웹뷰보다 클 경우 스크린 크기에 맞게 조정
                            webview_test.setBackgroundColor(0)
                            //글자 크기 설정
                            webview_test.getSettings().textZoom = 300

                            //html 변환 해주기
                            html_value = html_value.replace("& lt;", "<")
                            html_value = html_value.replace("& gt;", ">")
                            //이미지에 주소값 넣어주기
                            html_value = html_value.replace("src=\"", "src="+"\""+baseURL)


                            webview_test.visibility = View.VISIBLE
                            webview_test.loadData(html_value, "text/html", "UTF-8")

                            community_board_content_textview.visibility = View.GONE

                            community_board_content_textview.setText(Html.fromHtml(html_value))

                        }
                        else
                        {
                            community_board_content_textview.setText(success_value.getString("community_text"))
                        }


                        //유저 이름
                        community_board_user_name_textview.setText(success_value.getString("community_name"))
                        //날짜
                        community_board_write_date_textview.setText(change_time(success_value.getString("community_date")))


                        //제목
                        get_title= success_value.getString("community_title")
                        //내용
                        get_content = success_value.getString("community_text")
                        //날짜
                        get_date  = change_time(success_value.getString("community_date"))



                        //첨부파일 1
                        if(!success_value.getString("community_file1").equals("null"))
                        {
                            community_file1 = success_value.getString("community_file1")
                            community_board_file_list_linearlayout.visibility = View.VISIBLE
                            community_board_file_1_linearlayout.visibility = View.VISIBLE
                            community_board_file_1_name_textview.setText(community_file1)
                        }
                        else
                        {
                            community_file1 = ""
                            community_board_file_1_linearlayout.visibility = View.GONE
                        }
                        //첨부파일 2
                        if(!success_value.getString("community_file2").equals("null"))
                        {
                            community_file2 = success_value.getString("community_file2")
                            community_board_file_list_linearlayout.visibility = View.VISIBLE
                            community_board_file_2_linearlayout.visibility = View.VISIBLE
                            community_board_file_2_name_textview.setText(community_file2)
                        }
                        else
                        {   community_file2 = ""
                            community_board_file_2_linearlayout.visibility = View.GONE
                        }

                        //삭제, 수정 버튼 활성화
                        val write_user_id = success_value.getString("community_id")

                        if(!write_user_id.equals(student_id))
                        {
                            community_board_edit_button_textview.visibility = View.GONE
                            community_board_delete_button_textview.visibility = View.GONE
                        }
                        else
                        {
                            community_board_edit_button_textview.visibility = View.VISIBLE
                            community_board_delete_button_textview.visibility = View.VISIBLE
                        }

                    }

                    else
                    {

                        CustomToast.show(this@class_community_board_Activity, "인터넷 연결 상태를 확인해주세요.")


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
                CustomToast.show(this@class_community_board_Activity, "인터넷 연결 상태를 확인해주세요.")

            }
        })
    }

    //댓글 작성
    fun create_student_community_comment_list(community_number : String, comment_content : String )
    {
        serverConnectionSpec!!.create_student_community_comment_list(student_id, access_token, student_name, community_number, comment_content).enqueue(object : Callback<ResponseBody> {
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

                        saveAccessToken(this@class_community_board_Activity, access_token)


                        if(boardCommentItem.size!=0)
                        {
                            boardCommentItem.clear()

                            boardCommentAdapter.notifyDataSetChanged()

                        }
                        //코멘트 불러오기
                        get_student_community_comment_list(get_board_number)


                    }
                    //실패 시
                    else
                    {
                        CustomToast.show(this@class_community_board_Activity, "인터넷 연결 상태를 확인해주세요.")

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

    //댓글 삭제
    fun delete_student_community_comment_list(community_number : String, comment_number : String , position : Int)
    {
        serverConnectionSpec!!.delete_student_community_comment_list(student_id, access_token, community_number, comment_number).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())


                    var i : Iterator<String>
                    i =  result.keys()

                    if(!i.next().equals("fail"))
                    {

                        access_token = result.getString("student_token")
                        saveAccessToken(this@class_community_board_Activity, access_token)
                        boardCommentItem.removeAt(position)
                        boardCommentAdapter.notifyItemRemoved(position)
                        boardCommentAdapter.notifyItemRangeChanged(position, boardCommentItem.size)
                    }
                    //실패 시
                    else
                    {
                        CustomToast.show(this@class_community_board_Activity, "인터넷 연결 상태를 확인해주세요.")

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
                CustomToast.show(this@class_community_board_Activity, "인터넷 연결 상태를 확인해주세요.")

            }
        })
    }

    //편집 버튼
    val edit_button = View.OnClickListener {

        val intent = Intent(this, class_community_edit_Activity::class.java)

        //넘버
        intent.putExtra("number", get_board_number)
        //유저 이름
        intent.putExtra("user_name", student_name)
        //제목
        intent.putExtra("title", get_title)
        //내용
        intent.putExtra("content", get_content)
        //날짜
        intent.putExtra("write_date", get_date)
        //첨부파일 1
        intent.putExtra("community_file1", community_file1)
        //첨부파일 2
        intent.putExtra("community_file2", community_file2)


        startActivity(intent)

        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

    }

    //삭제 버튼
    val delete_button = View.OnClickListener {


        //정말 삭제하시겠습니까 라는 AlertDialog 생성
        val builder = AlertDialog.Builder(this)
        builder.setMessage("정말로 삭제하시겠습니까?")
        builder.setPositiveButton("확인") { dialogInterface, i ->

            //삭제
            //게시글 삭제(서버)
            delete_student_community(get_board_number)
            dialogInterface.dismiss()
        }
        builder.setNegativeButton("취소") { dialogInterface, i ->
            dialogInterface.dismiss()
        }
        val dialog: AlertDialog = builder.create()
        dialog.show()

    }


    //댓글등록 버튼
    val upload_comment = View.OnClickListener {

        if(!TextUtils.isEmpty(community_board_input_comment_edittext.text.toString())){

        var input_text = community_board_input_comment_edittext.text.toString()

        create_student_community_comment_list(get_board_number,input_text)


        community_board_input_comment_edittext.text.clear()
        community_board_input_comment_edittext.clearFocus()


        }
        else{

            Toast.makeText(this, "댓글을 입력해주세요.", Toast.LENGTH_SHORT).show()
            community_board_input_comment_edittext.requestFocus()
        }
        //댓글 작성 시 서버로 올려주기
    }

    //사이드 메뉴(햄버거)버튼
    val side_menu_button = View.OnClickListener{
        class_community_board_drawerlayout.openDrawer(class_community_board_child_drawerlayout)
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

        class_community_board_drawerlayout.closeDrawer(class_community_board_child_drawerlayout)
    }

    //게시글 삭제
    fun delete_student_community(community_number : String)
    {
        serverConnectionSpec!!.delete_student_community(student_id, access_token, community_number).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())


                    var i : Iterator<String>
                    i =  result.keys()

                    if(!i.next().equals("fail"))
                    {


                        access_token = result.getString("student_token")
                        saveAccessToken(this@class_community_board_Activity, access_token)
                        CustomToast.show(this@class_community_board_Activity, "게시글이 삭제되었습니다.")
                        finish()
                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


                    }
                    //실패 시
                    else
                    {
                        CustomToast.show(this@class_community_board_Activity, "인터넷 연결 상태를 확인해주세요.")

                    }


                } catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {


                CustomToast.show(this@class_community_board_Activity, "인터넷 연결 상태를 확인해주세요.")

            }
        })
    }

}