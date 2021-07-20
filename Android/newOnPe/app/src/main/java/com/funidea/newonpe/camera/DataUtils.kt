package com.funidea.newonpe.camera

import org.json.JSONObject
import java.lang.Exception

class DataUtils {

    companion object
    {
        fun getStringFromJson(jsonObject: JSONObject , key : String) : String?
        {
            return try {
                jsonObject.getString(key)
            } catch (e : Exception) {
                e.printStackTrace()

                "";
            }
        }
    }
}