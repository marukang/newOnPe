package com.funidea.newonpe.page.home.class_community_board

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.class_community_comment_recyclerview_item.view.*

/** 커뮤니티의 게시글의 댓글을 보여주는 RecyclerView의 Adapter
 *
 */

class board_comment_Adapter(context: Context, boardCommentItem: ArrayList<board_comment_Item>?)
    : RecyclerView.Adapter<board_comment_Adapter.ViewHolder>() {

    private val boardCommentItem: ArrayList<board_comment_Item>?

    private val context: Context

    private var mListener: onItemClickListener? = null

    interface onItemClickListener {
        //fun item_click(position: Int)
        fun item_delete(position: Int)
    }

    fun setonItemClickListener(listener: onItemClickListener?) {
        mListener = listener
    }


    init {
        this.boardCommentItem = boardCommentItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {

        //학급 커뮤니티 게시글 번호(혹은 공지사항 표시)
        val comment_user_name_textview = itemView.comment_user_name_textview
        val comment_write_date_textview = itemView.comment_write_date_textview
        val comment_user_comment = itemView.comment_user_comment
        val comment_delete_button_textview = itemView.comment_delete_button_textview



        init {

            //상품 넘기기
            comment_delete_button_textview.setOnClickListener {
                if (mListener != null) {
                    val position = adapterPosition
                    if (position != RecyclerView.NO_POSITION) {
                        mListener.item_delete(position)
                    }

                }
            }


        }
    }


    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): ViewHolder {

        val view: View = LayoutInflater.from(viewGroup.context)
            .inflate(R.layout.class_community_comment_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: board_comment_Item = boardCommentItem!![position]

        viewHolder.comment_user_name_textview.setText(position_item.user_name)
        viewHolder.comment_write_date_textview.setText(position_item.write_date)
        viewHolder.comment_user_comment.setText(position_item.user_comment)

        if(position_item.comment_value==0)
        {
            viewHolder.comment_delete_button_textview.visibility = View.GONE
        }
        else
        {
            viewHolder.comment_delete_button_textview.visibility = View.VISIBLE
        }


    }


    override fun getItemCount(): Int {
        return boardCommentItem?.size ?: 0
    }
}