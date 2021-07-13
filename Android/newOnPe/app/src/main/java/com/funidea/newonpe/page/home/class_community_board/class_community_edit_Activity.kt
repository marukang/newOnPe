package com.funidea.newonpe.page.home.class_community_board

import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.ImageDecoder
import android.net.Uri
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.text.TextUtils
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.core.content.FileProvider
import com.bumptech.glide.RequestManager
import com.funidea.utils.CustomToast
import com.funidea.utils.save_SharedPreferences
import com.funidea.utils.set_User_info
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.utils.set_User_info.Companion.student_name
import com.funidea.newonpe.dialog.picture_dialog
import com.funidea.newonpe.R
import com.funidea.newonpe.page.login.SplashActivity.Companion.serverConnection
import kotlinx.android.synthetic.main.activity_class_community_edit.*
import okhttp3.MediaType
import okhttp3.MultipartBody
import okhttp3.RequestBody
import okhttp3.ResponseBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList

/**학급 커뮤니티에서 글을 편집하는 Class
 *
 * 학급 커뮤니티에서 자신이 작성한 글을 편집할 수 있습니다.
 *
 * 자신이 작성한 글의 제목, 내용, 첨부한 사진 등을 변경하여 다시 업로드 할 수 있습니다.
 *
 */

class class_community_edit_Activity : AppCompatActivity() {

    //==============앨범 접근================
    private var isPermission = true
    val REQUEST_IMAGE_CAPTURE = 1  //카메라 사진 촬영 요청 코드 *임의로 값 입력
    lateinit var currentPhotoPath : String //문자열 형태의 사진 경로값 (초기값을 null로 시작하고 싶을 때 - lateinti var)
    val REQUEST_IMAGE_PICK = 10
    //==============================
    //activity가 destroyed 됐을 때 글라이드가 호출되는 경우의 오류 방지
    lateinit var mGlideRequestManager : RequestManager
    //이미지 파일 경로 (프로필 이미지 등록 시)
    var filepath : Uri? = null


    var file_name_Array = ArrayList<String>()
    var mArrayUri = java.util.ArrayList<Uri>()
    var class_code_number : String =""
    var class_community_edit_title = ""
    var class_community_edit_content = ""
    var class_community_edit_date = ""
    var class_community_edit_community_file1 :String = ""
    var class_community_edit_community_file2 : String= ""

    var insert_file_1 : String=""
    var insert_file_2 : String =""

    var delete_file_1 =""
    var delete_file_2 =""

    //시간 데이터
    // 현재시간을 msec 으로 구한다.
    val now = System.currentTimeMillis()
    // 현재시간을 date 변수에 저장한다.
    val date = Date(now)
    // 시간을 나타냇 포맷을 정한다 ( yyyy/MM/dd 같은 형태로 변형 가능 )
    val sdfNow = SimpleDateFormat("yyyyMMddHHmmss")
    // nowDate 변수에 값을 저장한다.
    val formatDate = sdfNow.format(date)

    var select_value : Int = 0

    var community_edit_value : Int = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_class_community_edit)


        var get_Intent = intent

        class_code_number = get_Intent.getStringExtra("number").toString()
        class_community_edit_title = get_Intent.getStringExtra("title").toString()
        class_community_edit_content = get_Intent.getStringExtra("content").toString()
        class_community_edit_date = get_Intent.getStringExtra("write_date").toString()
        class_community_edit_community_file1 = get_Intent.getStringExtra("community_file1").toString()
        class_community_edit_community_file2 = get_Intent.getStringExtra("community_file2").toString()

        Log.d("값보기", "onCreate:"+class_community_edit_community_file1)
        Log.d("값보기", "onCreate:"+class_community_edit_community_file2)

        //뒤로가기 버튼
        class_community_edit_back_button.setOnClickListener(back_button)
        //첨부파일 버튼
        //class_community_edit_add_file_button_textview.setOnClickListener(add_file_button)
        //글쓰기 버튼
        class_community_edit_text_confirm_button.setOnClickListener(edit_confirm_button)
        //작성자 이름
        class_community_edit_user_name_textview.setText(student_name)
        //타이틀
        class_community_edit_input_title_edittext.setText(class_community_edit_title)
        //내용
        class_community_edit_input_content_edittext.setText(class_community_edit_content)
        //작성일
        class_community_edit_user_date_textview.setText(class_community_edit_date)


        //파일 추가 버튼1
        community_edit_file_1_linearlayout.setOnClickListener(add_file_button_1)
        //파일 추가 버튼2
        community_edit_file_2_linearlayout.setOnClickListener(add_file_button_2)

        //community_edit_file_1_linearlayout.visibility = View.GONE
        //community_edit_file_2_linearlayout.visibility = View.GONE
        community_edit_file_1_delete_button_textview.visibility = View.GONE
        community_edit_file_2_delete_button_textview.visibility = View.GONE

        if(!class_community_edit_community_file1.equals("")&&!class_community_edit_community_file1.equals("null")){
            community_edit_file_1_linearlayout.visibility = View.VISIBLE
            community_edit_file_1_delete_button_textview.visibility = View.VISIBLE
            community_edit_file_1_name_textview.setText(class_community_edit_community_file1)

            class_community_edit_community_file1 = class_community_edit_community_file1.replace("/resources/community_file/","")
        }
        if(!class_community_edit_community_file2.equals("")&&!class_community_edit_community_file2.equals("null")){
            community_edit_file_2_linearlayout.visibility = View.VISIBLE
            community_edit_file_2_delete_button_textview.visibility = View.VISIBLE
            community_edit_file_2_name_textview.setText(class_community_edit_community_file2)
            class_community_edit_community_file2 = class_community_edit_community_file2.replace("/resources/community_file/","")

        }


        community_edit_file_1_delete_button_textview.setOnClickListener(community_file_delete_button_1)
        community_edit_file_2_delete_button_textview.setOnClickListener(community_file_delete_button_2)
    }


    //첨부파일 삭제 버튼
    val community_file_delete_button_1 = View.OnClickListener {

        community_edit_file_1_name_textview.setText("파일을 첨부해주세요.")
        community_edit_file_1_delete_button_textview.visibility = View.GONE

        if(delete_file_1.isEmpty())
        {
            delete_file_1 = class_community_edit_community_file1
            class_community_edit_community_file1 = ""
            Log.d("실행 첫번쨰11", ""+delete_file_1)
        }
        else
        {
            class_community_edit_community_file1 = ""
            Log.d("실행 두번째22", ""+delete_file_1)
        }


        if(mArrayUri.size==1)
        {
            mArrayUri.removeAt(0)



        }
        else if(mArrayUri.size==2)
        {
            mArrayUri.removeAt(0)
            community_edit_file_1_linearlayout.visibility  = View.GONE
            delete_file_1 = class_community_edit_community_file1
            class_community_edit_community_file1 = ""
        }
        else if(!class_community_edit_community_file1.isEmpty())
        {
            delete_file_1 = class_community_edit_community_file1
            class_community_edit_community_file1 = ""
            community_edit_file_1_linearlayout.visibility  = View.GONE
        }
       /* else
        {
            Custom_Toast.custom_toast(this, "삭제할 파일이 없습니다.")

        }

        Log.d("파일삭제 확인", ":"+mArrayUri.size + mArrayUri.toString())*/
    }
    val community_file_delete_button_2 = View.OnClickListener {

        community_edit_file_2_name_textview.setText("파일을 첨부해주세요.")
        community_edit_file_2_delete_button_textview.visibility = View.GONE

        if(delete_file_2.isEmpty())
        {
            delete_file_2 = class_community_edit_community_file2
            class_community_edit_community_file2 = ""

        }
        else
        {
            class_community_edit_community_file2 = ""

        }

        if(mArrayUri.size==1)
        {

            mArrayUri.removeAt(0)
            community_edit_file_2_linearlayout.visibility  = View.GONE
            delete_file_2 = class_community_edit_community_file2
            class_community_edit_community_file2 = ""
        }
        else if(mArrayUri.size==2)
        {

            mArrayUri.removeAt(1)
            community_edit_file_2_linearlayout.visibility  = View.GONE
            delete_file_2 = class_community_edit_community_file2
            class_community_edit_community_file2 = ""
        }
        else if(!class_community_edit_community_file2.isEmpty())
        {

            delete_file_2 = class_community_edit_community_file2
            class_community_edit_community_file2 = ""
            community_edit_file_2_linearlayout.visibility  = View.GONE
        }


        Log.d("파일삭제 확인", ":"+mArrayUri.size + mArrayUri.toString())
    }


    //글쓰기 확인 버튼
    val edit_confirm_button = View.OnClickListener {

        if(TextUtils.isEmpty(class_community_edit_input_title_edittext.text.toString())||
                TextUtils.isEmpty(class_community_edit_input_content_edittext.text.toString()))
        {
            if(TextUtils.isEmpty(class_community_edit_input_title_edittext.text.toString()))
            {
                CustomToast.show(this, "제목을 입력해주세요.")
            }
            else
            {
                CustomToast.show(this, "내용을 입력해주세요.")
            }
        }
        else
        {
            if(community_edit_value==0){

            community_edit_value = 1

            var title = class_community_edit_input_title_edittext.text.toString()
            var content = class_community_edit_input_content_edittext.text.toString()
            Log.d("결과!!", student_id+class_code_number+title+content+mArrayUri+ access_token)
            send_student_message(class_code_number, title, content, mArrayUri)

            }

            }
    }


    //파일 추가 버튼
    val add_file_button_1 = View.OnClickListener {

        select_value = 1

        val pictureDialog = picture_dialog(this)

        pictureDialog.show()

        pictureDialog.setImageSelectListener(object : picture_dialog.ImageSelectListener{
            override fun select_image_value(select: String?) {
                pictureDialog.dismiss()
                if(select.equals("0"))
                {
                    if (isPermission) takeCapture()
                    else Toast.makeText(applicationContext, resources.getString(R.string.permission_2), Toast.LENGTH_LONG).show()
                }
                else
                {
                    if (isPermission) getPhotoFromMyGallary()
                    else Toast.makeText(applicationContext, resources.getString(R.string.permission_2), Toast.LENGTH_LONG).show()
                }
            }
        })

    }

    val add_file_button_2 = View.OnClickListener {

        select_value = 2


        val pictureDialog = picture_dialog(this)

        pictureDialog.show()

        pictureDialog.setImageSelectListener(object : picture_dialog.ImageSelectListener{
            override fun select_image_value(select: String?) {
                pictureDialog.dismiss()
                if(select.equals("0"))
                {
                    if (isPermission) takeCapture()
                    else Toast.makeText(applicationContext, resources.getString(R.string.permission_2), Toast.LENGTH_LONG).show()
                }
                else
                {
                    if (isPermission) getPhotoFromMyGallary()
                    else Toast.makeText(applicationContext, resources.getString(R.string.permission_2), Toast.LENGTH_LONG).show()
                }
            }
        })

    }
    //앨범 접근하기
    private fun getPhotoFromMyGallary() {
        Intent(Intent.ACTION_PICK).apply{
            type = "image/*"
            startActivityForResult(this,REQUEST_IMAGE_PICK)
        }
    }

    //기본 카메라 앱을 사용해서 사진 촬영
    private fun takeCapture() {
        //기본 카메라 앱 실행
        Intent(MediaStore.ACTION_IMAGE_CAPTURE).also { takePictureIntent ->
            takePictureIntent.resolveActivity(packageManager)?.also {
                val photoFile : File? = try{
                    createImageFile()
                }catch (e:Exception){
                    null
                }
                photoFile?.also {
                    val photoURI : Uri = FileProvider.getUriForFile(this, "com.funidea.newonpe.provider", it)
                    takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI)
                    startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE)
                }
            }
        }
    }
    //이미지 파일 생성
    private fun createImageFile(): File {
        val timestamp : String = SimpleDateFormat("yyyyMMdd_HHmmss").format(Date())
        val storageDir : File? = getExternalFilesDir(Environment.DIRECTORY_PICTURES)
        return File.createTempFile("JPEG_${timestamp}_",".jpeg",storageDir).apply {
            currentPhotoPath = absolutePath
        }
    }

    //앨범 사진 가져오기 & 촬영한 사진 가져오기 ActivityResult
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if(requestCode == REQUEST_IMAGE_CAPTURE && resultCode == Activity.RESULT_OK){
            val bitmap : Bitmap
            val file = File(currentPhotoPath)
            if(Build.VERSION.SDK_INT < 28){//안드로이드 9.0 보다 버전이 낮을 경우
                bitmap = MediaStore.Images.Media.getBitmap(contentResolver,Uri.fromFile(file))
                filepath = Uri.fromFile(file)


            }else{//안드로이드 9.0 보다 버전이 높을 경우
                val decode = ImageDecoder.createSource(
                        this.contentResolver,
                        Uri.fromFile(file)
                )
                bitmap = ImageDecoder.decodeBitmap(decode)
                filepath = Uri.fromFile(file)



            }
            //갤러리에 사진 저장
            savePhoto(bitmap)
        }

        if(requestCode == REQUEST_IMAGE_PICK && resultCode == Activity.RESULT_OK){
            // signup_profile_imageview.setImageURI(data?.data)
            //1. 앨범사진 선택 - 해당 부분에 서버로 사진 보내주는 코드 넣기
            filepath = data?.data

            getRealPathFromURI(filepath)

            //Log.d("결과서버가냐?", "onActivityResult: "+filepath.toString())
            Log.d("결과서버가냐?1313", "onActivityResult: "+getRealPathFromURI(filepath))
            mArrayUri.add(Uri.parse(getRealPathFromURI(filepath)))
            //change_user_profile_image(mArrayUri)
            if(mArrayUri.size!=0)
            {
                if(select_value==1)
                {
                    community_edit_file_1_linearlayout.visibility = View.VISIBLE
                    community_edit_file_1_delete_button_textview.visibility = View.VISIBLE
                    community_edit_file_1_name_textview.setText(getRealPathFromURI(filepath))
                    insert_file_1 = formatDate+"_"+ student_id+"_"+"0.jpg"
                    class_community_edit_community_file1 = insert_file_1
                }
                else if(select_value==2)
                {
                    community_edit_file_2_linearlayout.visibility = View.VISIBLE
                    community_edit_file_2_delete_button_textview.visibility = View.VISIBLE
                    community_edit_file_2_name_textview.setText(getRealPathFromURI(filepath))
                    insert_file_2 = formatDate+"_"+ student_id+"_"+"1.jpg"
                    class_community_edit_community_file2 = insert_file_2
                }



            }

            Log.d("파일추가(갤러리)", "savePhoto:"+mArrayUri.toString())
        }
    }

    fun getRealPathFromURI(contentUri: Uri?): String? {
        val proj = arrayOf(MediaStore.Images.Media.DATA)
        val cursor = contentResolver.query(contentUri!!, proj, null, null, null)
        cursor!!.moveToNext()
        val path = cursor.getString(cursor.getColumnIndex(MediaStore.MediaColumns.DATA))
        val uri = Uri.fromFile(File(path))
        Log.d("경로", "getRealPathFromURI(), path : $uri")
        cursor.close()
        return path
    }

    //갤러리에 저장
    private fun savePhoto(bitmap: Bitmap) {
        //사진 폴더에 저장하기 위한 경로 선언
        val folderPath = Environment.getExternalStorageDirectory().absolutePath + "/DCIM/Camera/"
        Log.d("파일경로확인", "savePhoto:"+folderPath)
        val timestamp : String = SimpleDateFormat("yyyyMMdd_HHmmss").format(Date())
        val fileName = "${timestamp}.jpg"
        val folder = File(folderPath)
        if(!folder.isDirectory){//해당 경로에 폴더가 존재하지
            folder.mkdir() // make directory의 줄임말로 해당경로에 폴더 자동으로
        }
        //실제적인 저장 처리
        val out = FileOutputStream(folderPath + fileName)
        bitmap.compress(Bitmap.CompressFormat.JPEG, 30, out)
        Toast.makeText(this,"사진이 앨범에 저장되었습니다.", Toast.LENGTH_SHORT).show()


        //getRealPathFromURI(filepath)

        Log.d("결과서버가냐?", "onActivityResult: "+folderPath+fileName)
        //Log.d("결과서버가냐?", "onActivityResult: "+getRealPathFromURI(filepath))
        mArrayUri.add(Uri.parse(folderPath+fileName))
        //change_user_profile_image(mArrayUri)
        if(mArrayUri.size!=0)
        {
            if(select_value==1)
            {
                community_edit_file_1_linearlayout.visibility = View.VISIBLE
                community_edit_file_1_delete_button_textview.visibility = View.VISIBLE
                community_edit_file_1_name_textview.setText(folderPath+fileName)
                insert_file_1 = formatDate+"_"+ student_id+"_"+"0.jpg"
                class_community_edit_community_file1 = insert_file_1
            }
            else if(select_value==2)
            {
                community_edit_file_2_linearlayout.visibility = View.VISIBLE
                community_edit_file_2_delete_button_textview.visibility = View.VISIBLE
                community_edit_file_2_name_textview.setText(folderPath+fileName)
                insert_file_2 =formatDate+"_"+ student_id+"_"+"1.jpg"
                class_community_edit_community_file2 = insert_file_2
            }

            Log.d("파일추가(사진찍기)", "savePhoto:"+mArrayUri.toString())
        }
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


    fun send_student_message(class_code : String, community_title : String, community_text : String, paths: List<Uri>)
    {

        val list : MutableList<MultipartBody.Part> = java.util.ArrayList()

        var i = 0
        //paths 가 null값일때 기존 이미지파일 파일 넣어주기.!!! 어레이로 넣기
        Log.d("차례대로1", "send_student_message: "+list.size)

        for (uri in paths) {

            //very important files[]
            val imageRequest = prepareFilePart("community_new_file[]", uri)

            list.add(imageRequest)
            i++
        }
        Log.d("차례대로2", "send_student_message: "+list.size+insert_file_1+insert_file_2)

        if(list.size==1)
        {
            if(!insert_file_2.isEmpty())
            {
                insert_file_1 = insert_file_2
            }

            if(!delete_file_2.isEmpty())
            {
                delete_file_1 = delete_file_2
            }
        }


        val request_id: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), student_id)
        val request_token: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), access_token)
        val request_class_code: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), class_code)
        val request_title: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), community_title)
        val request_content: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), community_text)
        val community_file_name1: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), class_community_edit_community_file1)
        val community_file_name2: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), class_community_edit_community_file2)
        val community_insert_file_name1: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), insert_file_1)
        val community_insert_file_name2: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), insert_file_2)
        val community_delete_file_name1: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), delete_file_1)
        val community_delete_file_name2: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), delete_file_2)
        //val request_name_Array: List<RequestBody> = RequestBody.create(MediaType.parse("Multipart/form-data"), community_file_name_Array)


        Log.d("차례대로3", "send_student_message: ")
        serverConnection!!.update_student_community(request_id, request_token, request_class_code, request_title,request_content,community_file_name1,community_file_name2,list, community_insert_file_name1, community_insert_file_name2, community_delete_file_name1, community_delete_file_name2).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {

                Log.d("차례대로4", "send_student_message: ")
                try {
                    val result = JSONObject(response.body()!!.string())

                    Log.d("결과!", "onResponse:"+result)

                    var i : Iterator<String>
                    i =  result.keys()

                    if(!i.next().equals("fail"))
                    {
                        community_edit_value = 0

                        //토큰 갱신
                        access_token = result.getString("student_token")

                        save_SharedPreferences.save_shard(this@class_community_edit_Activity, set_User_info.access_token)

                        CustomToast.show(this@class_community_edit_Activity, "정상적으로 수정 되었습니다.")

                        finish()
                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


                    }
                    //실패 시
                    else
                    {
                        CustomToast.show(this@class_community_edit_Activity, "인터넷 연결 상태를 확인해주세요.")
                    }

                }
                catch (t : KotlinNullPointerException)
                {
                    t.printStackTrace()
                    CustomToast.show(this@class_community_edit_Activity, "서버와 연결이 불 안정합니다.")
                    Log.d("결과!!NullPoint", "onResponse:"+"null")
                }
                catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {


                CustomToast.show(this@class_community_edit_Activity, "인터넷 연결 상태를 확인해주세요.")

            }
        })
    }


    private fun prepareFilePart(partName: String, fileUri: Uri): MultipartBody.Part {
        // https://github.com/iPaulPro/aFileChooser/blob/master/aFileChooser/src/com/ipaulpro/afilechooser/utils/FileUtils.java
        // use the FileUtils to get the actual file by uri
        val file = File(fileUri.toString())
        //compress the image using Compressor lib
        // create RequestBody instance from file
        val requestFile = RequestBody.create(MediaType.parse("image/*"), file)
        // MultipartBody.Part is used to send also the actual file name
        return MultipartBody.Part.createFormData(partName, file.name, requestFile)
    }
}