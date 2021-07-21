package com.funidea.newonpe.page

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment

abstract class CommonFragment(var resourceLayoutId : Int) : Fragment() {

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
}