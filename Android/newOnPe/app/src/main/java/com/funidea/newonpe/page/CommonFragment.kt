package com.funidea.newonpe.page

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.funidea.newonpe.dialog.CommonDialog

abstract class CommonFragment(private var resourceLayoutId : Int) : Fragment() {

    lateinit var mFragmentView :View

    final override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View?
    {
        mFragmentView = layoutInflater.inflate(resourceLayoutId, null)

        try
        {
            init(inflater, container, savedInstanceState)
        }
        catch (e : Exception)
        {
            e.printStackTrace()
        }

        return mFragmentView
    }

    protected abstract fun init(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?)

    protected fun <T : View> findViewById(resourceId : Int) : T
    {
        return mFragmentView.findViewById(resourceId)
    }

    protected open fun inflateView(resourceId: Int, parent: ViewGroup?): View
    {
        return LayoutInflater.from(context).inflate(resourceId, parent, false)
    }

    fun showDialog(vararg messages : String?, buttonCount : CommonDialog.ButtonCount = CommonDialog.ButtonCount.ONE, listener : ((confirmed : Boolean) -> Unit)? = null)
    {
        val dialog = CommonDialog(context!!, *messages, buttonCount = buttonCount)
        dialog.setOnDismissListener {
            if (listener != null) {
                listener(dialog.mConfirmed)
            }
        }
        dialog.show()
    }
}