package com.funidea.newonpe.dialog

import android.content.Context
import android.text.TextUtils
import android.view.View
import com.funidea.utils.Custom_Toast.Companion.custom_toast
import com.funidea.newonpe.R
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.android.synthetic.main.input_password_for_resign_bottom_dialog.*

/** 신규 클래스 등록  Bottom Dialog
 *
 * 신규 클래스를 등록하는 Bottom Dialog
 *
 * 학생이 신규 클래스를 등록하고자 할 때 신규수업 버튼 클릭을 통해 보여지는 Bottom Dialog
 *
 */


class input_password_for_resign_bottom_dialog(context: Context) : BottomSheetDialog(context) {


    var get_pass_word_Listener : InputPasswordListener? =null
    val place_type_array = ArrayList<String>()



    interface InputPasswordListener
    {
        fun input_password(input_password : String?)

    }

    fun setInputPasswordListener(get_pass_word_Listener : InputPasswordListener)
    {
        this.get_pass_word_Listener = get_pass_word_Listener
    }

    init {
        val view: View = layoutInflater.inflate(R.layout.input_password_for_resign_bottom_dialog, null)
        setContentView(view)



        input_pass_word_confirm_button.setOnClickListener {

            if(!TextUtils.isEmpty(input_pass_word_edittext.text.toString()))
            {

            get_pass_word_Listener?.input_password(input_pass_word_edittext.text.toString())

            dismiss()

            }
            else
            {
                custom_toast(context, "비밀번호를 올바르게 입력해주세요.")
                dismiss()

            }

        }

    }
}


