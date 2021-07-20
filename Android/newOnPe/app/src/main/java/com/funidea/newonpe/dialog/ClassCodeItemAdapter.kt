package com.funidea.newonpe.dialog

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.class_code_dialog_recyclerview_item.view.*

/* class_code_dialog의 Recyclerview Adapter Class
*
*/

class ClassCodeItemAdapter(context: Context, classCodeItems : ArrayList<ClassCodeItem>?)
    : RecyclerView.Adapter<ClassCodeItemAdapter.ViewHolder>() {

    private val classCodeItems: ArrayList<ClassCodeItem>?

    private val context: Context

    private var mListener: onItemClickListener? = null

    interface onItemClickListener {
        fun item_click(position: Int)
    }

    fun setonItemClickListener(listener: onItemClickListener?) {
        mListener = listener
    }


    init {
        this.classCodeItems = classCodeItems
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {

        //학급 커뮤니티 게시글 번호(혹은 공지사항 표시)
        val class_code_dialog_parent_layout = itemView.class_code_dialog_parent_layout

        val class_code_dialog_name_textview = itemView.class_code_dialog_name_textview

        val class_code_dialog_check_imageview = itemView.class_code_dialog_check_imageview



        init {

            //상품 넘기기
            class_code_dialog_parent_layout.setOnClickListener {
                if (mListener != null) {
                    val position = adapterPosition
                    if (position != RecyclerView.NO_POSITION) {
                        mListener.item_click(position)
                    }

                }
            }


        }
    }


    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): ViewHolder {

        val view: View = LayoutInflater.from(viewGroup.context)
            .inflate(R.layout.class_code_dialog_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: ClassCodeItem = classCodeItems!![position]

        viewHolder.class_code_dialog_name_textview.setText(position_item.class_name)

        if(position_item.class_select_value==1)
        {
            viewHolder.class_code_dialog_check_imageview.visibility = View.VISIBLE
        }
        else
        {
            viewHolder.class_code_dialog_check_imageview.visibility = View.GONE
        }

        //viewHolder.board_file_name_textview.setText(position_item.file_name)

    }


    override fun getItemCount(): Int {
        return classCodeItems?.size ?: 0
    }
}