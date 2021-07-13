package com.funidea.newonpe.page.home.class_community_board

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.class_community_recyclerview_item.view.*

/** 커뮤니티에서 글 목록을 보여주는 RecyclerView 의 Adapter
 *
 */

class class_community_Adapter(context: Context, classCommunityItem: ArrayList<class_community_Item>?)
    : RecyclerView.Adapter<class_community_Adapter.ViewHolder>()
{

    private val classCommunityItem : ArrayList<class_community_Item>?

    private val context : Context

    private var mListener: onItemClickListener? = null

    interface onItemClickListener {
        fun item_click(position: Int)

    }

    fun setonItemClickListener(listener: onItemClickListener?) {
        mListener = listener
    }


    init
    {
        this.classCommunityItem = classCommunityItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!)
    {

        //학급 커뮤니티 게시글 번호(혹은 공지사항 표시)
        val community_recyclerview_number_textview = itemView.community_recyclerview_number_textview
        //학급 커뮤니티 게시글 타이틀
        val community_recyclerview_title_textview = itemView.community_recyclerview_title_textview
        //학급 커뮤니티 글 작성자 이름
        val community_recyclerview_user_name_textview = itemView.community_recyclerview_user_name_textview
        //학급 커뮤니티 글 작성 일자
        val  community_recyclerview_write_date_textview = itemView.community_recyclerview_write_date_textview
        //학급 커뮤니티 조회수
        //val community_recyclerview_number_of_views_textview = itemView.community_recyclerview_number_of_views_textview
        //코맨트 수
        val community_recyclerview_comment_count_textview = itemView.community_recyclerview_comment_count_textview

        val community_recyclerview_parent_linearlayout = itemView.community_recyclerview_parent_linearlayout


         init {

            //상품 넘기기
             community_recyclerview_parent_linearlayout.setOnClickListener {
                if(mListener!=null)
                {
                    val position = adapterPosition
                    if (position != RecyclerView.NO_POSITION) {
                        mListener.item_click(position)
                    }

                }
            }



        }
    }


    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): ViewHolder
    {

        val view: View = LayoutInflater.from(viewGroup.context)
            .inflate(R.layout.class_community_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }



    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int)
    {

        val  position_item : class_community_Item = classCommunityItem!![position]

        //넘버
        viewHolder.community_recyclerview_number_textview.setText(position_item.show_community_number)
        //제목
        viewHolder.community_recyclerview_title_textview.setText(position_item.title)
        //유저이름
        viewHolder.community_recyclerview_user_name_textview.setText(position_item.user_name)
        //날짜 데이터
        viewHolder.community_recyclerview_write_date_textview.setText(position_item.write_date)
        //댓글 수
        viewHolder.community_recyclerview_comment_count_textview.setText(position_item.comment_count.toString())
        //조회 수
        //viewHolder.community_recyclerview_number_of_views_textview.setText(position_item.number_of_views.toString())

    }


    override fun getItemCount(): Int {
        return classCommunityItem?.size ?: 0
    }




}