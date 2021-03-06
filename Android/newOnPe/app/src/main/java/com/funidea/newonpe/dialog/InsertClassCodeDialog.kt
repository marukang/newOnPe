package com.funidea.newonpe.dialog

import android.content.Context
import android.view.View
import com.funidea.newonpe.R
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.android.synthetic.main.class_code_dialog.*

/** 클래스 코드 변경 관련 Bottom Dialog
 *
 * 사용자 클래스 수업 이용 시 중간에 클래스를 변경하고자 할때 보여질 BottomDialog
 */

class InsertClassCodeDialog(context: Context, classCodeItems : ArrayList<ClassCodeItem>) : BottomSheetDialog(context) {


    var get_class_code_listener : classCodeSelectListener? =null
    var get_classCodeDialogItem = ArrayList<ClassCodeItem>()

    lateinit var classCodeItemAdapter: ClassCodeItemAdapter


    interface classCodeSelectListener
    {
        fun select_code_value(select_code_name : String,select_code : String , select_position : Int?)

    }

    fun setclassCodeSelectListener(get_class_code_listener : classCodeSelectListener)
    {
        this.get_class_code_listener = get_class_code_listener
    }

    init {
        val view: View = layoutInflater.inflate(R.layout.class_code_dialog, null)
        setContentView(view)

        get_classCodeDialogItem = classCodeItems

        classCodeItemAdapter = ClassCodeItemAdapter(context, get_classCodeDialogItem)

        class_code_dialog_recyclerview.adapter = classCodeItemAdapter

        classCodeItemAdapter.setonItemClickListener(object : ClassCodeItemAdapter.onItemClickListener
        {
            override fun item_click(position: Int) {


                get_class_code_listener?.select_code_value(get_classCodeDialogItem.get(position).class_name,get_classCodeDialogItem.get(position).class_code, position)

                dismiss()
            }

        })

    }
}
