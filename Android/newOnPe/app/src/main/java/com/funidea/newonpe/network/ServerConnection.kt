package com.funidea.newonpe.network

import android.util.Log
import android.widget.Toast
import com.funidea.newonpe.model.CurrentLoginStudent
import com.funidea.newonpe.model.Student
import com.funidea.newonpe.network.NetworkConstants.BASE_URL
import com.funidea.newonpe.services.MyFirebaseMessagingService
import com.funidea.utils.CustomToast
import com.funidea.utils.save_SharedPreferences
import com.funidea.utils.set_User_info
import okhttp3.MediaType
import okhttp3.MultipartBody
import okhttp3.RequestBody
import okhttp3.ResponseBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.io.IOException
import java.lang.Exception

object ServerConnection : NetworkConstants
{
    @JvmStatic private val mRetrofit: Retrofit = Retrofit.Builder()
        .baseUrl(BASE_URL)
        .addConverterFactory(GsonConverterFactory.create())
        .build()
    @JvmStatic private var mServerConnectionSpec: ServerConnectionSpec? =  mRetrofit.create(
        ServerConnectionSpec::class.java)

    fun login(id: String?, password : String?, callback: (Int, Any?) -> Unit)
    {
        val deviceToken = MyFirebaseMessagingService.mDeviceToken

        mServerConnectionSpec?.login(id, password, deviceToken)?.enqueue(object : Callback<Student> {
            override fun onResponse(call: Call<Student>, response: Response<Student>)
            {
                if (response.isSuccessful)
                {
                    callback(1, response.body())
                }
                else
                {
                    callback(-2, null)
                }
            }

            override fun onFailure(call: Call<Student>, response: Throwable) {
                callback(-1, response)
            }
        })
    }

    fun autoLogin(studentId : String, accessToken : String, callback: (Int, Any?) -> Unit)
    {
        mServerConnectionSpec?.auto_login(studentId, accessToken, accessToken)?.enqueue(object : Callback<Student> {
            override fun onResponse(call: Call<Student>, response: Response<Student>)
            {
                try
                {
                    if (response.isSuccessful)
                    {
                        callback(1, response.body())
                    }
                    else
                    {
                        callback(-1, null)
                    }
                }
                catch (e : Exception)
                {
                    e.printStackTrace()

                    callback(-2, null)
                }
            }

            override fun onFailure(call: Call<Student>, response: Throwable)
            {
                callback(-3, null)
            }
        })
    }


    fun snsLogin(user_id: String?, student_token: String?, fcmToken: String?, loginType : String?, student_email : String?, student_push_agreement : String?, student_phone_number : String?, callback: (Int, Any?) -> Unit)
    {
        mServerConnectionSpec?.auto_sns_login(user_id, student_token, fcmToken, loginType, student_email, student_push_agreement, student_phone_number)?.enqueue(object : Callback<Student> {
            override fun onResponse(call: Call<Student>, response: Response<Student>)
            {
                if (response.isSuccessful)
                {
                    callback(1, response.body())
                }
                else
                {
                    callback(-2, response)
                }
            }

            override fun onFailure(call: Call<Student>, response: Throwable)
            {
                callback(-1, response)
            }
        })
    }

    fun checkDuplicatedId(student_id : String, callback: (Int) -> Unit)
    {
        mServerConnectionSpec?.id_overlap_check(student_id)?.enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try
                {
                    val result = JSONObject(response.body()!!.string())
                    val resultValue = result.getString("success")
                    Log.d("debug", "++ checkDuplicatedId result = ${result.toString()}")
                    if (resultValue.equals("n"))
                    {
                        callback(1)
                    }
                    else if (resultValue.equals("y"))
                    {
                        callback(-1)
                    }
                }
                catch (e: JSONException)
                {
                    e.printStackTrace()
                }
                catch (e: IOException)
                {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, response: Throwable)
            {
                callback(-2)
            }
        })
    }

    fun tryRegistration(student_id : String, student_name : String, student_password : String,
                        student_phone: String, student_push_agreement : String, callback: (Boolean) -> Unit)
    {
        val deviceToken = MyFirebaseMessagingService.mDeviceToken

        mServerConnectionSpec?.sign_up(student_id, student_name, student_password, deviceToken, student_phone, student_id, "N/A", student_push_agreement)?.enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try
                {
                    val result = JSONObject(response.body()!!.string())
                    Log.d("debug", "++ tryRegistration result = ${result.toString()}")
                    val i : Iterator<String> = result.keys()
                    if (i.next() == "success")
                    {
                        val studentJson = JSONObject(result.getString("student"))
                        val student = Student()
                        student.student_id = studentJson.getString("student_id")
                        student.student_email = studentJson.getString("student_email")
                        student.student_login_type = "E"
                        student.access_token = studentJson.getString("access_token")
                        student.fcm_token = deviceToken
                        student.student_name = studentJson.getString("student_name")
                        student.student_phone = studentJson.getString("student_phone")

                        CurrentLoginStudent.root = student

                        callback(true)
                    }
                    else
                    {
                        callback(false)
                    }
                }
                catch (e : Exception)
                {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, response: Throwable)
            {
                Log.d("debug", "++ tryRegistration onFailure ")

                callback(false)
            }
        })
    }

    fun uploadProfileImage(student_id : String, student_name : String ,student_token : String, list : MutableList<MultipartBody.Part>, callback: (Boolean) -> Unit)
    {
        val requestId: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), student_id)
        val requestName: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), student_name)
        val requestToken: RequestBody = RequestBody.create(MediaType.parse("Multipart/form-data"), student_token)

        mServerConnectionSpec?.profile_change(requestId, requestName, requestToken, list)?.enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try
                {
                    val result = JSONObject(response.body()!!.string())

                    val i : Iterator<String> = result.keys()
                    if (i.next() == "success")
                    {
                        CurrentLoginStudent.root?.access_token = result.getString("student_token")
                        CurrentLoginStudent.root?.student_name = result.getString("student_name")

                        callback(true)
                    }
                    else
                    {
                        callback(false)
                    }
                }
                catch (e : Exception)
                {
                    e.printStackTrace()
                }
            }

            override fun onFailure(p0: Call<ResponseBody>, p1: Throwable)
            {
                callback(false)
            }
        })
    }
}