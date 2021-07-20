package com.funidea.newonpe.dialog

import android.content.Context
import android.view.View
import com.funidea.newonpe.R
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.android.synthetic.main.confirm_bottom_dialog.bottom_dialog_confirm_button
import kotlinx.android.synthetic.main.input_new_class_code_bottom_dialog.*

/** 신규 클래스 등록  Bottom Dialog
 *
 * 신규 클래스를 등록하는 Bottom Dialog
 *
 * 학생이 신규 클래스를 등록하고자 할 때 신규수업 버튼 클릭을 통해 보여지는 Bottom Dialog
 *
 */


class RegisterNewClassDialog(context: Context) : BottomSheetDialog(context) {


    var get_new_class_code_Listener : InputNewClassCodeListener? =null
    val place_type_array = ArrayList<String>()



    interface InputNewClassCodeListener
    {
        fun input_code(input_code : String?)

    }

    fun setInputNewClassCodeListener(get_new_class_code_Listener : InputNewClassCodeListener)
    {
        this.get_new_class_code_Listener = get_new_class_code_Listener
    }

    init {
        val view: View = layoutInflater.inflate(R.layout.input_new_class_code_bottom_dialog, null)
        setContentView(view)



        bottom_dialog_confirm_button.setOnClickListener {

            get_new_class_code_Listener?.input_code(input_new_class_code_edittext.text.toString())

            dismiss()

        }

    }
}


