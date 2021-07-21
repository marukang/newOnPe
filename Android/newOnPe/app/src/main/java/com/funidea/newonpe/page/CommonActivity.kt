package com.funidea.newonpe.page

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import com.funidea.newonpe.dialog.CommonDialog
import com.funidea.newonpe.model.CurrentLoginStudent

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

    fun showDialog(vararg messages : String?, buttonCount : CommonDialog.ButtonCount = CommonDialog.ButtonCount.TWO, listener : (confirmed : Boolean) -> Unit)
    {
        val dialog = CommonDialog(this, *messages, buttonCount = buttonCount)
        dialog.setOnDismissListener {
            listener(dialog.mConfirmed)
        }
        dialog.show()
    }

    fun showDialog(vararg messages : String?, buttonCount : CommonDialog.ButtonCount = CommonDialog.ButtonCount.TWO)
    {
        val dialog = CommonDialog(this, *messages, buttonCount = buttonCount)
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
}