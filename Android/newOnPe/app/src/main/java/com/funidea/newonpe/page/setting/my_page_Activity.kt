package com.funidea.newonpe.page.setting

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.ImageDecoder
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.FileProvider
import com.bumptech.glide.Glide
import com.bumptech.glide.RequestManager
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.funidea.utils.CustomToast.Companion.show
import com.funidea.utils.SimpleSharedPreferences.Companion.saveAccessToken
import com.funidea.utils.set_User_info
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.student_age
import com.funidea.utils.set_User_info.Companion.student_class
import com.funidea.utils.set_User_info.Companion.student_content
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.utils.set_User_info.Companion.student_level
import com.funidea.utils.set_User_info.Companion.student_number
import com.funidea.utils.set_User_info.Companion.student_sex
import com.funidea.utils.set_User_info.Companion.student_tall
import com.funidea.utils.set_User_info.Companion.student_weight
import com.funidea.utils.side_menu_layout.Companion.side_menu_setting_test
import com.funidea.newonpe.dialog.NotifyUserInfoChangedDialog
import com.funidea.newonpe.dialog.SelectPictureDialog
import com.funidea.newonpe.R
import com.funidea.newonpe.page.login.LoginPage
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import com.gun0912.tedpermission.PermissionListener
import com.gun0912.tedpermission.TedPermission
import kotlinx.android.synthetic.main.activity_my_page.*
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
import java.util.regex.Pattern

/** 마이 페이지 Class
 *
 * 유저의 신체정보, 학교 정보, 비밀번호 등을 변경할 수 있는 페이지
 *
 */

class my_page_Activity : AppCompatActivity() {


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



    //마이페이지 각 버튼 on/off
    var class_info_boolean : Boolean = true
    var user_info_boolean : Boolean = true
    var change_pw_boolean : Boolean = true

    //비밀번호 변경
    var pw_check : Boolean = false
    var new_pw_check : Boolean = false
    var new_pw_double_check : Boolean = false
    var input_pw : String = ""
    //비밀번호 변경 관련 끝

    //기초 정보 관리
    var user_introduction_value : Boolean = false
    var user_height_value : Boolean = true
    var user_weight_value : Boolean = true
    var user_age_value : Boolean = true
    //기초 정보 관리 끝

    //학급정보 관리
    var user_grade_value : Boolean = false
    var user_class_value : Boolean = false
    var user_number_value : Boolean = false
    //학급정보 관리 끝
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_my_page)
        //퍼미션 체크
        tedPermission()

        //사이드 메뉴
        var v : View = side_menu_layout_my_page
        side_menu_setting_test(my_page_drawerview, v, this)

        //학급정보관리 활성화
        my_page_class_info_button_linearlayout.setOnClickListener(class_info_visibility_button)
        change_class_info()
        //학급정보관리 변경 버튼
        my_page_class_info_confirm_button_textview.setOnClickListener(change_class_info_button)


        //기초정보관리 활성화
        my_page_user_info_button_linearlayout.setOnClickListener(user_info_visibility_button)
        change_user_info()
        //기초정보관리 변경 버튼
        my_page_user_info_confirm_button_textview.setOnClickListener(change_user_info_button)
        //유저 프로필 변경 버튼
        my_page_user_info_profile_change_textview.setOnClickListener(change_user_profile_button)

        //비밀번호변경 활성화
        my_page_change_pw_button_linearlayout.setOnClickListener(change_pw_visibility_button)
        change_password()
        //비밀번호 변경 버튼
        my_page_change_pw_confirm_button_textview.setOnClickListener(change_pw_button)

        //뒤로가기 버튼
        my_page_back_button.setOnClickListener(back_button)
        //사이드 메뉴 버튼
        my_page_side_menu_button.setOnClickListener(side_menu_button)


        //유저 이미지 가져오기
        Glide.with(this).load(LoginPage.baseURL + set_User_info.student_image_url)
                .diskCacheStrategy(DiskCacheStrategy.NONE)
                .skipMemoryCache(true)
                .centerCrop()
                .placeholder(R.drawable.user_profile)
                .into(my_page_user_info_profile_imageview)



        user_info_setting()
    }

    //사이드 메뉴 버튼
    val side_menu_button = View.OnClickListener {
        my_page_drawerview.openDrawer(my_page_child_drawerview)

    }

    override fun onStop() {
        super.onStop()

        my_page_drawerview.closeDrawer(my_page_child_drawerview)
    }

    fun user_info_setting()
    {
        my_page_change_grade_edittext.setText(student_level)
        my_page_change_class_edittext.setText(student_class)
        my_page_change_number_edittext.setText(student_number)

        //자기 소개
        my_page_user_info_input_introduction_edittext.setText(student_content)
        //키
        my_page_user_info_input_height_edittext.setText(student_tall)
        //몸무게
        my_page_user_info_input_weight_edittext.setText(student_weight)
        //나이
        my_page_user_info_input_age_edittext.setText(student_age)

        if(student_sex.equals("m"))
        {
            my_page_user_info_male_textview.setTextColor(Color.parseColor("#3378fd"))
            my_page_user_info_male_textview.setBackgroundResource(R.drawable.view_main_color_round_edge)
        }
        else if(student_sex.equals("f"))
        {
            my_page_user_info_female_textview.setTextColor(Color.parseColor("#3378fd"))
            my_page_user_info_female_textview.setBackgroundResource(R.drawable.view_main_color_round_edge)
        }

    }



    //학급정보관리 클릭리스너
    val class_info_visibility_button = View.OnClickListener {

        if(class_info_boolean)
        {
            class_info_boolean = false
            my_page_class_info_linearlayout.visibility =View.VISIBLE
            my_page_class_info_button_imageview.setImageResource(R.drawable.ic_main_color_up_button)
        }
        else
        {
            class_info_boolean = true
            my_page_class_info_linearlayout.visibility =View.GONE
            my_page_class_info_button_imageview.setImageResource(R.drawable.main_color_down_button)
        }

    }
    //기초정보관리 클릭리스너
    val user_info_visibility_button = View.OnClickListener {





        if(user_info_boolean)
        {
            user_info_boolean = false
            my_page_user_info_linearlayout.visibility =View.VISIBLE
            my_page_user_info_button_imageview.setImageResource(R.drawable.ic_main_color_up_button)
        }
        else
        {
            user_info_boolean = true
            my_page_user_info_linearlayout.visibility =View.GONE
            my_page_user_info_button_imageview.setImageResource(R.drawable.main_color_down_button)
        }
    }
    //비밀번호변경 관리 클릭리스너
    val change_pw_visibility_button = View.OnClickListener {
        if(change_pw_boolean)
        {
            change_pw_boolean = false
            my_page_change_pw_linearlayout.visibility =View.VISIBLE
            my_page_change_pw_button_imageview.setImageResource(R.drawable.ic_main_color_up_button)
        }
        else
        {
            change_pw_boolean = true
            my_page_change_pw_linearlayout.visibility =View.GONE
            my_page_change_pw_button_imageview.setImageResource(R.drawable.main_color_down_button)
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
    //==================학급 정보 관리 관련 시작===================================================
    val change_class_info_button = View.OnClickListener {

        if(!user_grade_value||!user_class_value||!user_number_value)
        {
            if(!user_grade_value){
                Toast.makeText(this, "학년을 입력해주세요.", Toast.LENGTH_SHORT).show()
                my_page_change_grade_edittext.requestFocus()
            }
            else if(!user_class_value){
                Toast.makeText(this, "반을 입력해주세요.", Toast.LENGTH_SHORT).show()
                my_page_change_class_edittext.requestFocus()
            }
            else if(!user_number_value){
                Toast.makeText(this, "번호를 입력해주세요.", Toast.LENGTH_SHORT).show()
                my_page_change_number_edittext.requestFocus()
            }

        }
        else
        {
            //Toast.makeText(this, "서버 전송", Toast.LENGTH_SHORT).show()


            var student_level_str = my_page_change_grade_edittext.text.toString()
            var student_class_str = my_page_change_class_edittext.text.toString()
            var student_number_str = my_page_change_number_edittext.text.toString()


            class_information_change(student_level_str, student_class_str, student_number_str)


        }
    }
    fun change_class_info()
    {
        //학년
        my_page_change_grade_edittext.addTextChangedListener(grade_textWatcher)
        //학급
        my_page_change_class_edittext.addTextChangedListener(class_textWatcher)
        //번호
        my_page_change_number_edittext.addTextChangedListener(number_textWatcher)

    }
    //학년
    var grade_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(my_page_change_grade_edittext.length()>0)
                {
                    my_page_change_grade_textview.setTextColor(Color.parseColor("#3378fd"))
                    my_page_change_grade_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)

                    user_grade_value = true
                }
                else if(my_page_change_grade_edittext.length()<=0)
                {
                    my_page_change_grade_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    my_page_change_grade_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                    user_grade_value = false

                }
            }
            else
            {
                my_page_change_grade_textview.setTextColor(Color.parseColor("#9f9f9f"))
                my_page_change_grade_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                user_grade_value = false
            }

            class_info_check_value()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }
    //학급
    var class_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(my_page_change_class_edittext.length()>0)
                {
                    my_page_change_class_textview.setTextColor(Color.parseColor("#3378fd"))
                    my_page_change_class_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)

                    user_class_value = true
                }
                else if(my_page_change_class_edittext.length()<=0)
                {
                    my_page_change_class_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    my_page_change_class_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                    user_class_value = false

                }
            }
            else
            {
                my_page_change_class_textview.setTextColor(Color.parseColor("#9f9f9f"))
                my_page_change_class_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                user_class_value = false
            }

            class_info_check_value()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }
    //번호
    var number_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(my_page_change_number_edittext.length()>0)
                {
                    my_page_change_number_textview.setTextColor(Color.parseColor("#3378fd"))
                    my_page_change_number_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)

                    user_number_value = true
                }
                else if(my_page_change_number_edittext.length()<=0)
                {
                    my_page_change_number_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    my_page_change_number_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                    user_number_value = false

                }
            }
            else
            {
                my_page_change_number_textview.setTextColor(Color.parseColor("#9f9f9f"))
                my_page_change_number_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                user_number_value = false
            }

            class_info_check_value()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }


    //버튼 활성화
    fun class_info_check_value()
    {

        if(!user_grade_value||!user_class_value||!user_number_value)
        {
            my_page_class_info_confirm_button_textview.setBackgroundResource(R.drawable.view_dark_gray_color_round_edge)
        }
        else
        {
            my_page_class_info_confirm_button_textview.setBackgroundResource(R.drawable.view_main_color_round_button)
        }

    }
    //==========================================================================================
    //==================기초 정보 관리 관련 시작====================================================

    //유저 프로필 사진 변경 버튼
    val change_user_profile_button = View.OnClickListener {

        val pictureDialog = SelectPictureDialog(this)

        pictureDialog.show()

        pictureDialog.setImageSelectListener(object : SelectPictureDialog.ImageSelectListener{
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

//                change_user_profile_imageview.setImageBitmap(bitmap)
                mGlideRequestManager = Glide.with(this)
                mGlideRequestManager.load(Uri.fromFile(file))
                        .centerCrop()
                        .placeholder(R.drawable.user_profile)
                        .into(my_page_user_info_profile_imageview)



            }else{//안드로이드 9.0 보다 버전이 높을 경우
                val decode = ImageDecoder.createSource(
                        this.contentResolver,
                        Uri.fromFile(file)
                )
                bitmap = ImageDecoder.decodeBitmap(decode)
                filepath = Uri.fromFile(file)

//                change_user_profile_imageview.setImageBitmap(bitmap)
                mGlideRequestManager = Glide.with(this)
                mGlideRequestManager.load(Uri.fromFile(file))
                        .diskCacheStrategy(DiskCacheStrategy.NONE)
                        .skipMemoryCache(true)
                        .centerCrop()
                        .placeholder(R.drawable.user_profile)
                        .into(my_page_user_info_profile_imageview)


            }
            //갤러리에 사진 저장
            savePhoto(bitmap)
        }

        if(requestCode == REQUEST_IMAGE_PICK && resultCode == Activity.RESULT_OK){
            // signup_profile_imageview.setImageURI(data?.data)
            //1. 앨범사진 선택 - 해당 부분에 서버로 사진 보내주는 코드 넣기
            filepath = data?.data

            mGlideRequestManager = Glide.with(this)
            mGlideRequestManager.load(data?.data)
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .skipMemoryCache(true)
                    .centerCrop()
                    .placeholder(R.drawable.user_profile)
                    .into(my_page_user_info_profile_imageview)

            getRealPathFromURI(filepath)


            mArrayUri.add(Uri.parse(getRealPathFromURI(filepath)))
            change_user_profile_image(mArrayUri)

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

    var mArrayUri = ArrayList<Uri>()

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
        bitmap.compress(Bitmap.CompressFormat.JPEG, 50, out)
        Toast.makeText(this,"사진이 앨범에 저장되었습니다.",Toast.LENGTH_SHORT).show()


        //getRealPathFromURI(filepath)


        mArrayUri.add(Uri.parse(folderPath+fileName))
        change_user_profile_image(mArrayUri)

    }


    fun change_user_profile_image(paths: List<Uri>) {
        val list : MutableList<MultipartBody.Part> = ArrayList()
        var i = 0
        //paths 가 null값일때 기존 이미지파일 파일 넣어주기.!!! 어레이로 넣기
        for (uri in paths) {

            //very important files[]
            val imageRequest = prepareFilePart("file", uri)


            list.add(imageRequest)
            i++
        }
        val request_id: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), student_id)
        val request_token: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), access_token)
//
//        serverConnectionSpec!!.profile_change(request_id, request_token, list).enqueue(object : Callback<ResponseBody?> {
//            override fun onResponse(call: Call<ResponseBody?>, response: Response<ResponseBody?>) {
//
//               try{
//
//
//                   val result = JSONObject(response.body()!!.string())
//
//
//                   var i : Iterator<String>
//                   i =  result.keys()
//
//
//                   if(i.next().equals("success"))
//                   {
//                       access_token = result.getString("student_token")
//                       save_SharedPreferences.save_shard(this@my_page_Activity, access_token)
//                       show(this@my_page_Activity, "프로필 사진이 변경되었습니다.")
//
//                       if(student_image_url.equals("")|| student_image_url.equals("null"))
//                       {
//                           student_image_url = "/resources/student_profile/"+ student_id+".jpg"
//                       }
//
//                   }
//                   else
//                   {
//                       Toast.makeText(this@my_page_Activity,"변경에 실패하였습니다.\n인터넷 상태를 다시 확인해주세요.", Toast.LENGTH_SHORT).show()
//                   }
//
//
//               }
//               catch (t : KotlinNullPointerException)
//               {
//                   Log.d("결과", "onResponse: "+t)
//
//               }
//
//                mArrayUri.clear()
//            }
//
//            override fun onFailure(call: Call<ResponseBody?>, t: Throwable) {
//
//                Log.d("결과", "onResponse: "+t)
//                Log.d("결과", "onResponse: "+call)
//            }
//        })
    }


    //이미지 전환
    private fun prepareFilePart(partName: String, fileUri: Uri): MultipartBody.Part {
        // https://github.com/iPaulPro/aFileChooser/blob/master/aFileChooser/src/com/ipaulpro/afilechooser/utils/FileUtils.java
        // use the FileUtils to get the actual file by uri
        val file = File(fileUri.toString())
        //compress the image using Compressor lib

        // create RequestBody instance from file
        val requestFile = RequestBody.create(
                MediaType.parse("image/*"),
                file)

        // MultipartBody.Part is used to send also the actual file name
        return MultipartBody.Part.createFormData(partName, file.name, requestFile)
    }


    val change_user_info_button = View.OnClickListener {

        if(!user_introduction_value||!user_height_value||!user_weight_value||!user_age_value)
        {
            if(!user_introduction_value){
                Toast.makeText(this, "좌우명을 입력해주세요.", Toast.LENGTH_SHORT).show()
                my_page_user_info_input_introduction_edittext.requestFocus()
            }
            else if(!user_height_value){
                Toast.makeText(this, "키를 입력해주세요.", Toast.LENGTH_SHORT).show()
                my_page_user_info_input_height_edittext.requestFocus()
            }
            else if(!user_weight_value){
                Toast.makeText(this, "몸무게를 입력해주세요.", Toast.LENGTH_SHORT).show()
                my_page_user_info_input_weight_edittext.requestFocus()
            }
            else if(!user_age_value){
                Toast.makeText(this, "나이를 입력해주세요.", Toast.LENGTH_SHORT).show()
                my_page_user_info_input_age_edittext.requestFocus()
            }



        }
        else
        {

            var student_content_str =  my_page_user_info_input_introduction_edittext.text.toString()
            //수정 전 - 기존 온체육 학생 키, 몸무게, 나이 입력
          /*  var student_tall_str =  my_page_user_info_input_height_edittext.text.toString()
            var student_weight_str =  my_page_user_info_input_weight_edittext.text.toString()
            var student_age_str =  my_page_user_info_input_age_edittext.text.toString()*/
            //변경 후 - 온체육 학생 키, 몸무게, 나이 받지 않음에 따라 더미데이터를 서버로 보냄.
            var student_tall_str =  "180"
            var student_weight_str =  "70"
            var student_age_str =  "20"


            user_information_change(student_content_str, student_tall_str, student_weight_str, student_age_str)
        }
    }


    fun change_user_info()
    {
        //자기소개 관련
        my_page_user_info_input_introduction_edittext.addTextChangedListener(introduction_textWatcher)
        //키
        //my_page_user_info_input_height_edittext.addTextChangedListener(height_textWatcher)
        //몸무게
        //my_page_user_info_input_weight_edittext.addTextChangedListener(weight_textWatcher)
        //나이
        //my_page_user_info_input_age_edittext.addTextChangedListener(age_textWatcher)

    }

    //자기소개 텍스트 입력 감지
    var introduction_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(my_page_user_info_input_introduction_edittext.length()>0)
                {
                    my_page_user_info_input_introduction_textview.setTextColor(Color.parseColor("#3378fd"))
                    my_page_user_info_input_introduction_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)
                    user_introduction_value = true


                }
                else if(my_page_user_info_input_introduction_edittext.length()<=0)
                {
                    my_page_user_info_input_introduction_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    my_page_user_info_input_introduction_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                    user_introduction_value = false
                }
            }
            else
            {
                my_page_user_info_input_introduction_textview.setTextColor(Color.parseColor("#9f9f9f"))
                my_page_user_info_input_introduction_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                user_introduction_value = false

            }

            user_info_check_value()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }
    //유저 키 입력
    var height_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(my_page_user_info_input_height_edittext.length()>0)
                {
                    my_page_user_info_input_height_textview.setTextColor(Color.parseColor("#3378fd"))
                    my_page_user_info_input_height_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)

                    user_height_value = true
                }
                else if(my_page_user_info_input_height_edittext.length()<=0)
                {
                    my_page_user_info_input_height_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    my_page_user_info_input_height_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                    user_height_value = false
                }
            }
            else
            {
                my_page_user_info_input_height_textview.setTextColor(Color.parseColor("#9f9f9f"))
                my_page_user_info_input_height_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                user_height_value = false
            }

            user_info_check_value()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }
    //유저 몸무게 입력
    var weight_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(my_page_user_info_input_weight_edittext.length()>0)
                {
                    my_page_user_info_input_weight_textview.setTextColor(Color.parseColor("#3378fd"))
                    my_page_user_info_input_weight_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)

                    user_weight_value = true
                }
                else if(my_page_user_info_input_weight_edittext.length()<=0)
                {
                    my_page_user_info_input_weight_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    my_page_user_info_input_weight_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                    user_weight_value = false
                }
            }
            else
            {
                my_page_user_info_input_weight_textview.setTextColor(Color.parseColor("#9f9f9f"))
                my_page_user_info_input_weight_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                user_weight_value = false
            }

            user_info_check_value()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }
    //유저 나이 입력
    var age_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(my_page_user_info_input_age_edittext.length()>0)
                {
                    my_page_user_info_input_age_textview.setTextColor(Color.parseColor("#3378fd"))
                    my_page_user_info_input_age_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)

                    user_age_value = true
                }
                else if(my_page_user_info_input_age_edittext.length()<=0)
                {
                    my_page_user_info_input_age_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    my_page_user_info_input_age_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                    user_age_value = false

                }
            }
            else
            {
                my_page_user_info_input_age_textview.setTextColor(Color.parseColor("#9f9f9f"))
                my_page_user_info_input_age_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                user_age_value = false
            }

            user_info_check_value()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }

    //버튼 활성화
    fun user_info_check_value()
    {

        if(!user_introduction_value||!user_height_value||!user_weight_value||!user_age_value)
        {
            my_page_user_info_confirm_button_textview.setBackgroundResource(R.drawable.view_dark_gray_color_round_edge)
        }
        else
        {
            my_page_user_info_confirm_button_textview.setBackgroundResource(R.drawable.view_main_color_round_button)


        }

    }

    //==================기초 정보 관리 관련 끝=====================================================

    //==================비밀번호 변경 관련 시작====================================================
    //비밀번호 변경
    val change_pw_button = View.OnClickListener {

        if(!new_pw_check||!new_pw_double_check||!pw_check)
        {
            if(!pw_check)
            {
                Toast.makeText(this, "비밀번호를 양식에 맞추어 다시 입력해주세요.", Toast.LENGTH_SHORT).show()
                my_page_pw_edittext.requestFocus()

            }
            else if(!new_pw_check)
            {
                Toast.makeText(this, "비밀번호를 양식에 맞추어 다시 입력해주세요.", Toast.LENGTH_SHORT).show()
                my_page_new_pw_edittext.requestFocus()
            }
            else if(!new_pw_double_check)
            {
                Toast.makeText(this, "재확인 비밀번호를 다시 확인해주세요.", Toast.LENGTH_SHORT).show()
                my_page_new_pw_confirm_edittext.requestFocus()
            }

        }
        else
        {
            if(my_page_new_pw_edittext.text.toString().equals(my_page_new_pw_confirm_edittext.text.toString()))
            {
                my_page_change_pw_confirm_button_textview.setBackgroundColor(Color.parseColor("#3378fd"))
                //Toast.makeText(this, "서버로 간드앗", Toast.LENGTH_SHORT).show()
                var password_before_str = my_page_pw_edittext.text.toString()
                var password_new_str = my_page_new_pw_edittext.text.toString()

                password_information_change(password_before_str, password_new_str)
            }
            else
            {
                my_page_change_pw_confirm_button_textview.setBackgroundColor(Color.parseColor("#9f9f9f"))
                Toast.makeText(this, "재확인 비밀번호를 다시 확인해주세요.", Toast.LENGTH_SHORT).show()
                my_page_new_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                my_page_new_pw_confirm_textview.setTextColor(Color.parseColor("#FF0000"))
                new_pw_double_check = false
                my_page_new_pw_confirm_edittext.requestFocus()
            }

        }
    }

    //비밀번호 변경
    fun change_password()
    {
        //현재 비밀번호
        my_page_pw_edittext.addTextChangedListener(input_pw_check_textWatcher)
        //변경 비밀번호
        my_page_new_pw_edittext.addTextChangedListener(input_new_pw_check_textWatcher)
        //변경 비밀번호 확인
        my_page_new_pw_confirm_edittext.addTextChangedListener(input_new_pw_double_check_textWatcher)

    }

    //정규 표현식을 이용해 PW 입력을 확인한다.
    //PW 입력 확인을 위한 TextWatcher
    var input_pw_check_textWatcher: TextWatcher = object : TextWatcher {
        override fun beforeTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {}
        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {
            //특수문자를 포함하는 경우
            //!Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$", charSequence)

            //비밀번호는 영어 대&소문자로 구성되며 8자리에서 16자리로 이루어진다.
            //사용이 불가능한 경우
            if (!Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,16}$", charSequence)) {
                my_page_pw_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                my_page_pw_textview.setTextColor(Color.parseColor("#FF0000"))

                pw_check = false
            }
            else
            {
                my_page_pw_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                my_page_pw_textview.setTextColor(Color.parseColor("#3378fd"))

                pw_check = true
                //
                // Toast.makeText(getApplicationContext(), input_pw+"", Toast.LENGTH_SHORT).show();
            }


            pw_check_value()
            Log.d("확인", "onTextChanged:"+input_pw)
        }

        override fun afterTextChanged(editable: Editable) {}
    }

    //정규 표현식을 이용해 PW 입력을 확인한다.
    //PW 입력 확인을 위한 TextWatcher
    var input_new_pw_check_textWatcher: TextWatcher = object : TextWatcher {
        override fun beforeTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {}
        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {
            //특수문자를 포함하는 경우
            //!Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$", charSequence)

            //비밀번호는 영어 대&소문자로 구성되며 8자리에서 16자리로 이루어진다.
            //사용이 불가능한 경우
            if (!Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,16}$", charSequence)) {
                my_page_new_pw_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                my_page_new_pw_textview.setTextColor(Color.parseColor("#FF0000"))

                new_pw_check = false
            }
            else
            {
                my_page_new_pw_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                my_page_new_pw_textview.setTextColor(Color.parseColor("#3378fd"))

                new_pw_check = true
                //
                // Toast.makeText(getApplicationContext(), input_pw+"", Toast.LENGTH_SHORT).show();
            }

            input_pw  = my_page_new_pw_edittext.text.toString()
            pw_check_value()
            Log.d("확인", "onTextChanged:"+input_pw)
        }

        override fun afterTextChanged(editable: Editable) {}
    }

    //정규 표현식을 이용해 입력 된 PW와 PW 확인을 비교해서 알려준다.
    //앞서 입력한 PW와 PW 재입력 확인을 위한 TextWatcher
    var input_new_pw_double_check_textWatcher: TextWatcher = object : TextWatcher {
        override fun beforeTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {}
        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {


            //Toast.makeText(getApplicationContext(), charSequence.toString()+"", Toast.LENGTH_SHORT).show();

            //앞서 입력한 PW와 같은지 비교를 한다.

            //앞서 입력한 PW와 같지 않은 경우
            if (charSequence.toString() != input_pw || input_pw == "") {
                my_page_new_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                my_page_new_pw_confirm_textview.setTextColor(Color.parseColor("#FF0000"))
                new_pw_double_check = false

            } else if (charSequence.toString() == input_pw) {
                my_page_new_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                my_page_new_pw_confirm_textview.setTextColor(Color.parseColor("#3378fd"))
                new_pw_double_check = true
            }

            //가입 버튼 활성화 클래스
            pw_check_value()
        }
        override fun afterTextChanged(editable: Editable) {}
    }

    //패스워드 체크
    fun pw_check_value()
    {
        if(!pw_check||!new_pw_check||!new_pw_double_check)
        {
            my_page_change_pw_confirm_button_textview.setBackgroundResource(R.drawable.view_dark_gray_color_round_edge)
        }
        else
        {
            if(my_page_new_pw_edittext.text.toString().equals(my_page_new_pw_confirm_edittext.text.toString()))
            {
                my_page_change_pw_confirm_button_textview.setBackgroundResource(R.drawable.view_main_color_round_button)
            }
            else
            {
                my_page_change_pw_confirm_button_textview.setBackgroundResource(R.drawable.view_main_color_round_button)
            }

        }

    }

    //==================비밀번호 변경 관련 끝=====================================================
    //카메라 접근 권한
    private fun tedPermission() {
        val permissionListener: PermissionListener = object : PermissionListener {
            override fun onPermissionGranted() {
                // 권한 요청 성공
                isPermission = true
            }

            override fun onPermissionDenied(deniedPermissions: List<String>) {

                // 권한 요청 거절
                isPermission = false
            }
        }
        TedPermission.with(this)
                .setPermissionListener(permissionListener)
                .setRationaleMessage(resources.getString(R.string.permission_2))
                .setDeniedMessage(resources.getString(R.string.permission_1))
                .setPermissions(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO)
                .check()
    }


    //학급 정보 변경
    fun class_information_change(student_level_str: String?, student_class_str: String?, student_number_str : String ? ) {

        serverConnectionSpec!!.class_information_change(student_id, student_level_str, student_class_str, student_number_str,access_token)
                .enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>) {
                try {
                    val result = JSONObject(response.body()!!.string())

                    var i : Iterator<String>
                    i =  result.keys()

                    Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {

                        var student_token = result.getString("student_token")

                        //토큰 재 갱신
                        access_token = student_token

                        saveAccessToken(this@my_page_Activity, student_token)

                        val confirmDialog = NotifyUserInfoChangedDialog(this@my_page_Activity)

                       confirmDialog.show()

                        student_level = student_level_str.toString()
                        student_class = student_class_str.toString()
                        student_number = student_number_str.toString()


                    }
                    else{

                        show(this@my_page_Activity, "올바른 접근이 아닙니다. 다시 변경해주세요.")
                    }

                } catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {


                show(this@my_page_Activity, "인터넷 연결 상태를 다시 확인해주세요.")
            }
        })
    }

    //유저 정보 변경
    fun user_information_change(student_content_str: String?, student_tall_str: String?,
                                student_weight_str: String?, student_age_str:String?) {


        serverConnectionSpec!!.user_information_change(student_id, access_token, student_content_str, student_tall_str,student_weight_str, student_age_str)
                .enqueue(object : Callback<ResponseBody> {
                    override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>) {
                        try {
                            val result = JSONObject(response.body()!!.string())
                            var result_value = result.toString()

                            Log.d("학생정보 결과값", "onResponse:"+result_value)

                            var i : Iterator<String>
                            i =  result.keys()

                            Log.d("결과", "onResponse:"+result)
                            if(!i.next().equals("fail"))
                            {

                                var student_token = result.getString("student_token")

                                //토큰 재 갱신
                                access_token = student_token

                                saveAccessToken(this@my_page_Activity, student_token)

                                val confirmDialog = NotifyUserInfoChangedDialog(this@my_page_Activity)

                                confirmDialog.show()

                                student_content = student_content_str.toString()
                                student_tall =  student_tall_str.toString()
                                student_weight = student_weight_str.toString()
                                student_age = student_age_str.toString()
                            }
                            else{

                                show(this@my_page_Activity, "올바른 접근이 아닙니다. 다시 변경해주세요.")
                            }

                        } catch (e: JSONException) {
                            e.printStackTrace()
                        } catch (e: IOException) {
                            e.printStackTrace()
                        }
                    }

                    override fun onFailure(call: Call<ResponseBody>, t: Throwable) {


                        show(this@my_page_Activity, "인터넷 연결 상태를 다시 확인해주세요.")
                    }
                })
    }

    //비밀번호 변경
    fun password_information_change(student_password_before: String?, student_password_new: String? ) {

        serverConnectionSpec!!.password_information_change(student_id, access_token, student_password_before, student_password_new)
                .enqueue(object : Callback<ResponseBody> {
                    override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>) {
                        try {
                            val result = JSONObject(response.body()!!.string())

                            var i : Iterator<String>
                            i =  result.keys()

                            Log.d("결과", "onResponse:"+result)
                            if(!i.next().equals("fail"))
                            {

                                var student_token = result.getString("student_token")

                                //토큰 재 갱신
                                access_token = student_token

                                saveAccessToken(this@my_page_Activity, student_token)

                                val confirmDialog = NotifyUserInfoChangedDialog(this@my_page_Activity)

                                confirmDialog.show()
                            }
                            else{

                                show(this@my_page_Activity, "올바른 접근이 아닙니다. 다시 변경해주세요.")
                            }

                        } catch (e: JSONException) {
                            e.printStackTrace()
                        } catch (e: IOException) {
                            e.printStackTrace()
                        }
                    }

                    override fun onFailure(call: Call<ResponseBody>, t: Throwable) {


                        show(this@my_page_Activity, "인터넷 연결 상태를 다시 확인해주세요.")
                    }
                })
    }

}