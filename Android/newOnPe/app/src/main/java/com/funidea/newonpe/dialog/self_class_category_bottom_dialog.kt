package com.funidea.newonpe.dialog

import android.content.Context
import android.view.View
import com.funidea.newonpe.dialog.class_code_dialog_Utils.self_class_bottom_dialog_Adapter
import com.funidea.newonpe.dialog.class_code_dialog_Utils.self_class_bottom_dialog_Item
import com.funidea.newonpe.R
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.android.synthetic.main.self_class_bottom_dialog.*

//셀프 체육 수업 카테고리 BottomDialog
//현재 사용 안함


class self_class_category_bottom_dialog(context: Context, selfClassBottomDialogItem : ArrayList<self_class_bottom_dialog_Item>) : BottomSheetDialog(context) {


    var get_self_class_listener : selfClassListener? =null
    var get_selfClassBottomDialogItem = ArrayList<self_class_bottom_dialog_Item>()

    lateinit var selfClassBottomDialogAdapter: self_class_bottom_dialog_Adapter


    interface selfClassListener
    {
        fun select_class_name_value(select_code_name : String, select_position : Int?)

    }

    fun setselfClassListener(get_self_class_listener : selfClassListener)
    {
        this.get_self_class_listener = get_self_class_listener
    }

    init {
        val view: View = layoutInflater.inflate(R.layout.self_class_bottom_dialog, null)
        setContentView(view)

        get_selfClassBottomDialogItem = selfClassBottomDialogItem

        selfClassBottomDialogAdapter = self_class_bottom_dialog_Adapter(context, get_selfClassBottomDialogItem)

        self_class_bottom_dialog_recyclerview.adapter = selfClassBottomDialogAdapter

        selfClassBottomDialogAdapter.setonItemClickListener(object  : self_class_bottom_dialog_Adapter.onItemClickListener
        {
            override fun item_click(position: Int) {

                get_self_class_listener?.select_class_name_value(get_selfClassBottomDialogItem.get(position).self_class_string, position)
            }

        }
        )

       /* selfClassBottomDialogAdapter.setonItemClickListener(object : class_code_dialog_Adapter.onItemClickListener
        {
            override fun item_click(position: Int) {


                get_self_class_listener?.select_code_value(get_selfClassBottomDialogItem.get(position).class_name,get_selfClassBottomDialogItem.get(position).class_code, position)

                dismiss()
            }

        })*/

    }
}
