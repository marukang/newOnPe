package com.funidea.utils

import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.text.TextUtils
import android.util.Base64
import java.lang.Exception
import java.security.MessageDigest

object Utility {

    fun getPhoneNumberWithHyphen(src : String?) : String?
    {
        if (!TextUtils.isEmpty(src))
        {
            return when (src?.length) {
                8 -> {
                    src.replaceFirst("^([0-9]{4})([0-9]{4})$", "$1-$2");
                }
                12 -> {
                    src.replaceFirst("(^[0-9]{4})([0-9]{4})([0-9]{4})$", "$1-$2-$3")
                }
                else -> {
                    src!!.replaceFirst("(^02|[0-9]{3})([0-9]{3,4})([0-9]{4})$", "$1-$2-$3");
                }
            }
        }

        return null
    }


    @SuppressLint("PackageManagerGetSignatures")
    fun getKeyHashBase64(context : Context): String?
    {
        var packageInfo : PackageInfo? = null

        try
        {
            packageInfo = context.packageManager.getPackageInfo(context.packageName, PackageManager.GET_SIGNATURES)
        }
        catch (e : Exception)
        {
            e.printStackTrace()
        }

        if (packageInfo != null)
        {
            for (signature in packageInfo.signatures)
            {
                try
                {
                    val messageDigest : MessageDigest = MessageDigest.getInstance("SHA")
                    messageDigest.update(signature.toByteArray())
                    return Base64.encodeToString(messageDigest.digest(), Base64.DEFAULT)
                }
                catch (e : Exception)
                {
                    e.printStackTrace()
                }
            }
        }

        return null
    }
}