package com.funidea.newonpe.home.class_result

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.class_result_state_recyclerview_item.view.*


/** Class_result_Activity 에서 상단의 수업 참여 여부를 나타내주는 RecyclerView Adapter
 *
 *
 */


class class_result_state_Adapter(context: Context, classResultStateItem : ArrayList<class_result_state_Item>?)
    : RecyclerView.Adapter<class_result_state_Adapter.ViewHolder>() {

    private val classResultStateItem: ArrayList<class_result_state_Item>?

    private val context: Context

    private var mListener: onItemClickListener? = null

    interface onItemClickListener {
        fun item_click(position: Int)
        //fun item_delete(position: Int)
    }

    fun setonItemClickListener(listener: onItemClickListener?) {
        mListener = listener
    }


    init {
        this.classResultStateItem = classResultStateItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {

        //학급 커뮤니티 게시글 번호(혹은 공지사항 표시)
        val class_result_state_recyclerview_item = itemView.class_result_state_recyclerview_item

       // val board_file_name_textview = itemView.board_file_name_textview



        init {




        }
    }


    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): ViewHolder {

        val view: View = LayoutInflater.from(viewGroup.context)
            .inflate(R.layout.class_result_state_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: class_result_state_Item = classResultStateItem!![position]

        var input_text = position_item.result_name + " : " + position_item.result_value

        viewHolder.class_result_state_recyclerview_item.setText(input_text)

        //viewHolder.board_file_name_textview.setText(position_item.file_name)

    }


    override fun getItemCount(): Int {
        return classResultStateItem?.size ?: 0
    }
}