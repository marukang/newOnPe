package com.funidea.newonpe

import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import java.lang.Exception

abstract class CommonActivity : AppCompatActivity()
{


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        try
        {
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


}