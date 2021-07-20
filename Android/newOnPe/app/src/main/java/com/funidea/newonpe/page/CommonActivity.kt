package com.funidea.newonpe.page

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.funidea.newonpe.dialog.CommonDialog
import com.funidea.newonpe.model.CurrentLoginStudent
import java.lang.Exception
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
}