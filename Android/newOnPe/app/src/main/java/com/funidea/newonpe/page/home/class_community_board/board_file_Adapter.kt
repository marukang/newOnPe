package com.funidea.newonpe.page.home.class_community_board

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.class_community_board_file_recyclerview_item.view.*

/** 커뮤니티의 게시글 및 클래스의 첨부파일의 RecyclerView Adapter
 *
 * 관련 Class - class_community_board_Activity , class_unit_Activity
 */
class board_file_Adapter(context: Context, boardFileItem : ArrayList<board_file_Item>?)
    : RecyclerView.Adapter<board_file_Adapter.ViewHolder>() {

    private val boardFileItem: ArrayList<board_file_Item>?

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
        this.boardFileItem = boardFileItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {

        //학급 커뮤니티 게시글 번호(혹은 공지사항 표시)
        val board_file_parent_linearlayout = itemView.board_file_parent_linearlayout

        val board_file_name_textview = itemView.board_file_name_textview



        init {

            //상품 넘기기
            board_file_parent_linearlayout.setOnClickListener {
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
            .inflate(R.layout.class_community_board_file_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: board_file_Item = boardFileItem!![position]

        viewHolder.board_file_name_textview.setText(position_item.file_name)

    }


    override fun getItemCount(): Int {
        return boardFileItem?.size ?: 0
    }
}