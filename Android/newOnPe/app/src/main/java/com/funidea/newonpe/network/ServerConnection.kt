@file:Suppress("NAME_SHADOWING")

package com.funidea.newonpe.network

import android.text.TextUtils
import android.util.Log
import android.widget.Toast
import com.funidea.newonpe.model.CurrentLoginStudent
import com.funidea.newonpe.model.Student
import com.funidea.newonpe.model.Subject
import com.funidea.newonpe.network.NetworkConstants.BASE_URL
import com.funidea.newonpe.services.MyFirebaseMessagingService
import com.funidea.utils.CustomToast
import com.funidea.utils.save_SharedPreferences
import com.funidea.utils.set_User_info
import com.google.gson.Gson
import okhttp3.MediaType
import okhttp3.MultipartBody
import okhttp3.RequestBody
import okhttp3.ResponseBody
import org.json.JSONArray
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
                try
                {
                    if (response.isSuccessful)
                    {
                        val student = response.body()
                        val studentId = student?.student_id

                        if (!TextUtils.isEmpty(studentId))
                        {
                            callback(1, student)
                        }
                        else
                        {
                            callback(-1, null)
                        }
                    }
                    else
                    {
                        callback(-2, null)
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

            override fun onFailure(call: Call<Student>, response: Throwable)
            {
                callback(-3, response)
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
                        val student = response.body()
                        val studentId = student?.student_id

                        if (!TextUtils.isEmpty(studentId))
                        {
                            callback(1, student)
                        }
                        else
                        {
                            callback(-1, null)
                        }
                    }
                    else
                    {
                        callback(-2, null)
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
                try
                {
                    if (response.isSuccessful)
                    {
                        val student = response.body()
                        val studentId = student?.student_id
                        Log.d("woozie", "++ snsLogin studentId = ${studentId}")
                        if (!TextUtils.isEmpty(studentId))
                        {
                            callback(1, student)
                        }
                        else
                        {
                            callback(-1, null)
                        }
                    }
                    else
                    {
                        callback(-2, null)
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

            override fun onFailure(call: Call<Student>, response: Throwable)
            {
                callback(-3, response)
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
                callback(false)
            }
        })
    }

    fun searchId(student_name : String, phoneNumber : String, callback: (Boolean, String?) -> Unit)
    {
        mServerConnectionSpec?.find_id(student_name, phoneNumber)?.enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try
                {
                    val result = JSONObject(response.body()!!.string())

                    val i : Iterator<String> = result.keys()
                    if (i.next() == "success")
                    {
                        val studentId = result.getString("student_id")

                        callback(true, studentId)
                    }
                    else
                    {
                        callback(false, null)
                    }
                }
                catch (e : Exception)
                {
                    e.printStackTrace()

                    callback(false, null)
                }
            }

            override fun onFailure(p0: Call<ResponseBody>, p1: Throwable)
            {
                callback(false, null)
            }
        })
    }

    fun searchPassword(student_id : String, student_name : String, phoneNumber : String, callback: (Boolean, String?, String?) -> Unit)
    {
        mServerConnectionSpec?.find_pw(student_id, student_name, phoneNumber)?.enqueue(object : Callback<ResponseBody> {

            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try
                {
                    val result = JSONObject(response.body()!!.string())

                    val i : Iterator<String> = result.keys()
                    if (i.next() == "success")
                    {
                        val authenticationCode = result.getString("authenticationCode")
                        val studentEmail = result.getString("student_email")

                        callback(true, authenticationCode, studentEmail)
                    }
                    else
                    {
                        callback(false, null, null)
                    }
                }
                catch (e : Exception)
                {
                    e.printStackTrace()

                    callback(false, null, null)
                }
            }

            override fun onFailure(p0: Call<ResponseBody>, p1: Throwable)
            {
                callback(false, null, null)
            }

        })
    }

    fun changePassword(student_email: String?, student_password: String, authenticationCode : String, callback: (Boolean) -> Unit)
    {
        mServerConnectionSpec?.find_change_pw(student_email, student_password, authenticationCode)?.enqueue(object : Callback<ResponseBody> {

            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try
                {
                    val result = JSONObject(response.body()!!.string())

                    val i : Iterator<String> = result.keys()
                    if (i.next() == "success")
                    {
                        callback(true)
                    }
                    else
                    {
                        val message = result.getString("fail")

                        Log.d("debug", " ++ changePassword fail message = $message")

                        callback(false)
                    }
                }
                catch (e : Exception)
                {
                    e.printStackTrace()

                    callback(false)
                }
            }

            override fun onFailure(p0: Call<ResponseBody>, p1: Throwable)
            {
                callback(false)
            }

        })
    }

    fun updateClassCode(classCode : String, callback: (Boolean, String?) -> Unit)
    {
        val studentId = CurrentLoginStudent.root?.student_id
        val accessToken = CurrentLoginStudent.root?.access_token

        mServerConnectionSpec?.student_class_update(studentId, accessToken, classCode)?.enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try
                {
                    val result = JSONObject(response.body()!!.string())
                    Log.d("woozie", "++ updateClassCode result = ${result.toString()}")
                    val i : Iterator<String> = result.keys()
                    if (i.next() == "success" || i.next() == "student_token")
                    {
                        val accessToken : String = result.getString("student_token")

                        callback(true, accessToken)
                    }
                    else
                    {
                        callback(false, null)
                    }
                }
                catch (e : Exception)
                {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable)
            {
                callback(false, null)
            }

        })
    }

    fun getStudentClassList(callback: (Boolean, String?, ArrayList<Subject>?) -> Unit)
    {
        val studentId = CurrentLoginStudent.root?.student_id
        val accessToken = CurrentLoginStudent.root?.access_token

        mServerConnectionSpec?.get_class_unit_list(studentId, accessToken)?.enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try
                {
                    val result = JSONObject(response.body()!!.string())

                    val i : Iterator<String> = result.keys()
                    if (i.next() == "student_token")
                    {
                        val accessToken : String = result.getString("student_token")
                        val array : JSONArray = result.getJSONArray("success")

                        val gson = Gson()
                        val subjectList : ArrayList<Subject> = arrayListOf()

                        for (i in 0 until array.length())
                        {
                            val json = array[i]
                            val subject : Subject = gson.fromJson(json.toString(), Subject::class.java)
                            subjectList.add(subject)
                        }
                        callback(true, accessToken, subjectList)
                    }
                    else
                    {
                        callback(false, null, null)
                    }
                }
                catch (e : Exception)
                {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable)
            {
                callback(false, null, null)
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