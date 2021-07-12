package com.funidea.newonpe.dialog

import android.content.Context
import android.view.View
import com.funidea.newonpe.R
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.android.synthetic.main.confirm_bottom_dialog.*

/** 사용자 정보 변경 시 보여질 Bottom Dialog
 *
 *  사용자가 정보를 변경하면 변경되었다는 문구와 함께 보여지는 BottomDialog
 */

class confirm_dialog(context: Context) : BottomSheetDialog(context) {


    var get_image_select_Listener : ImageSelectListener? =null
    val place_type_array = ArrayList<String>()



    interface ImageSelectListener
    {
        fun select_image_value(select : String?)

    }

    fun setImageSelectListener(get_image_select_Listener : ImageSelectListener)
    {
        this.get_image_select_Listener = get_image_select_Listener
    }

    init {
        val view: View = layoutInflater.inflate(R.layout.confirm_bottom_dialog, null)
        setContentView(view)

        bottom_dialog_confirm_button.setOnClickListener {

            dismiss()

        }

    }
}


