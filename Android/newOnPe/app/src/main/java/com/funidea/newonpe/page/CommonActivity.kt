package com.funidea.newonpe.page

import android.content.Context
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import com.funidea.newonpe.dialog.CommonDialog
import com.funidea.newonpe.model.CurrentLoginStudent
import com.funidea.newonpe.page.pose.PoseActivity
import java.util.*

abstract class CommonActivity : AppCompatActivity()
{

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        try
        {
            CurrentLoginStudent.addObserver { p0, p1 ->

            }

            init(savedInstanceState)
        }
        catch (e : Exception)
        {
            e.printStackTrace()
        }
    }

    protected abstract fun init(savedInstanceState: Bundle?)

    override fun onResume() {
        super.onResume()
    }

    override fun onPause() {
        super.onPause()
    }

    fun showDialog(vararg messages : String?, buttonCount : CommonDialog.ButtonCount = CommonDialog.ButtonCount.ONE, listener : ((confirmed : Boolean) -> Unit)? = null)
    {
        val dialog = CommonDialog(this, *messages, buttonCount = buttonCount)
        dialog.setOnDismissListener {
            if (listener != null) {
                listener(dialog.mConfirmed)
            }
        }
        dialog.show()
    }

    protected open fun replaceFragment(containerId: Int, fragment: Fragment) {
        try {
            val tag = fragment.javaClass.simpleName
            val fragmentTransaction = this.supportFragmentManager.beginTransaction()
            fragmentTransaction.replace(containerId, fragment, tag)
            fragmentTransaction.addToBackStack(tag)
            fragmentTransaction.commitAllowingStateLoss()
        } catch (var5: java.lang.Exception) {
            var5.printStackTrace()
        }
    }

    protected open fun replaceFragment(containerId: Int, fragment: Fragment?, tag: String?)
    {
        try
        {
            val fragmentTransaction = this.supportFragmentManager.beginTransaction()
            fragmentTransaction.replace(containerId, fragment!!, tag)
            fragmentTransaction.addToBackStack(tag)
            fragmentTransaction.commitAllowingStateLoss()
        }
        catch (var5: java.lang.Exception) {
            var5.printStackTrace()
        }
    }

    protected open fun addFragmentStack(containerId: Int, fragment: Fragment)
    {
        try
        {
            val tag = fragment.javaClass.simpleName
            val fragmentTransaction = this.supportFragmentManager.beginTransaction()
            fragmentTransaction.add(containerId, fragment, tag)
            fragmentTransaction.addToBackStack(tag)
            fragmentTransaction.commitAllowingStateLoss()
        }
        catch (var5: java.lang.Exception)
        {
            var5.printStackTrace()
        }
    }

    protected open fun addFragmentStack(containerId: Int, fragment: Fragment?, tag: String?) {
        try
        {
            val fragmentTransaction = this.supportFragmentManager.beginTransaction()
            fragmentTransaction.add(containerId, fragment!!, tag)
            fragmentTransaction.addToBackStack(tag)
            fragmentTransaction.commitAllowingStateLoss()
        }
        catch (var5: java.lang.Exception)
        {
            var5.printStackTrace()
        }
    }

    protected open fun popBackFragmentStack() {
        this.supportFragmentManager.popBackStack()
    }

    protected open fun popBackFragmentStack(tag: String?) {
        this.supportFragmentManager.popBackStack(tag, 1)
    }

    protected open fun getVisibleTopFragmentCount(): Int {
        val fragmentList = this.supportFragmentManager.fragments
        return fragmentList.size ?: 0
    }

    protected open fun getVisibleTopFragment(): Fragment? {
        val fragmentList = this.supportFragmentManager.fragments
        val fragmentListSize = fragmentList.size
        for (i in fragmentListSize - 1 downTo -1 + 1)
        {
            val fragment = fragmentList[i]
            if (fragment.isVisible)
            {
                return fragment
            }
        }
        return null
    }

    protected open fun requestRuntimePermissions()
    {
        val allNeededPermissions: MutableList<String> = ArrayList()
        for (permission in getRequiredPermissions()) {
            if (!isPermissionGranted(this, permission!!)) {
                allNeededPermissions.add(permission)
            }
        }
        if (allNeededPermissions.isNotEmpty())
        {
            ActivityCompat.requestPermissions(this, allNeededPermissions.toTypedArray(), 1)
        }
    }

    protected open fun getRequiredPermissions(): Array<String?>
    {
        return try {
            val info = this.packageManager
                .getPackageInfo(this.packageName, PackageManager.GET_PERMISSIONS)
            val ps = info.requestedPermissions
            if (ps != null && ps.isNotEmpty()) {
                ps
            } else {
                arrayOfNulls(0)
            }
        } catch (e: java.lang.Exception) {
            arrayOfNulls(0)
        }
    }

    protected open fun isPermissionGranted(context: Context, permission: String): Boolean
    {
        if (ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED)
        {
            return true
        }
        return false
    }

    protected open fun isAllPermissionsGranted(): Boolean
    {
        for (permission in getRequiredPermissions())
        {
            if (!isPermissionGranted(this, permission!!)) {
                return false
            }
        }
        return true
    }
}