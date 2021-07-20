package com.funidea.utils

import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.util.Base64
import java.lang.Exception
import java.security.MessageDigest

object Utility {

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