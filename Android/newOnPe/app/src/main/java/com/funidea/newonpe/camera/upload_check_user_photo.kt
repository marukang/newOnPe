package com.funidea.newonpe.camera

import android.net.Uri
import android.util.Log
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.newonpe.page.pose.PoseActivity.photo_capture_value
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import okhttp3.MediaType
import okhttp3.MultipartBody
import okhttp3.RequestBody
import okhttp3.ResponseBody
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File
import java.util.ArrayList

class upload_check_user_photo
{

    companion object{
    @JvmName("get_file") fun get_file(folderPath : String, file_name : String, class_code : String, unit_code : String, send_file_name :String)
    {
        //var filepath : Uri? = null

       // filepath = Uri.fromFile(file)

        var mArrayUri = ArrayList<Uri>()
        Log.d("확인", "get_file: "+folderPath+file_name+class_code+unit_code)
        Log.d("확인", "get_file: "+send_file_name)
        mArrayUri.add(Uri.parse(folderPath+file_name))

        change_user_profile_image(mArrayUri, class_code, unit_code, send_file_name)
    }



    fun change_user_profile_image(paths: List<Uri>, class_code : String , class_unit_code : String, file_name : String) {
        val list : MutableList<MultipartBody.Part> = ArrayList()
        var i = 0
        //paths 가 null값일때 기존 이미지파일 파일 넣어주기.!!! 어레이로 넣기
        for (uri in paths) {

            //very important files[]
            val imageRequest = prepareFilePart("file", uri)
            Log.d("결과보기", "change_user_profile_image:"+uri + paths + imageRequest)

            list.add(imageRequest)
            i++
        }
        val request_id : RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), student_id)
        val request_token: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), access_token)
        val request_class_code: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), class_code)
        val request_unit_code: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), class_unit_code)
        val request_file_name: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), file_name)


        serverConnectionSpec!!.update_student_record_image_confirmation(request_id, request_token,request_class_code,request_unit_code, request_file_name, list).enqueue(object : Callback<ResponseBody?> {
            override fun onResponse(call: Call<ResponseBody?>, response: Response<ResponseBody?>) {

                try{
                    val result = JSONObject(response.body()!!.string())

                    Log.d("결과", "onResponse: "+result)
                    photo_capture_value = 1
                }
                catch (t : KotlinNullPointerException)
                {
                    Log.d("결과", "onResponse: "+t)

                }

               // mArrayUri.clear()
            }

            override fun onFailure(call: Call<ResponseBody?>, t: Throwable) {

                Log.d("결과", "onResponse: "+t)
                Log.d("결과", "onResponse: "+call)
            }
        })
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

    }
}