package com.funidea.newonpe.page.notice

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.notice_recyclerview_item.view.*

/** notice Adapter
 *
 * all_notice_fragment, class_notice_fragment, message_notice_fragment 의 3개의 새소식에서
 * 소식 리스트를 보여주는 RecyclerView의 Adapter
 */

class notice_Adapter(context: Context, noticeItem : ArrayList<notice_Item>?)
    : RecyclerView.Adapter<notice_Adapter.ViewHolder>()
{

    private val noticeItem : ArrayList<notice_Item>?

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
        this.noticeItem = noticeItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!)
    {

        //공지사항 게시글 번호(혹은 공지사항 표시)
        val notice_recyclerview_number_textview = itemView.notice_recyclerview_number_textview
        //공지사항 게시글 타이틀
        val notice_recyclerview_title_textview = itemView.notice_recyclerview_title_textview
        //공지사항 글 작성자 이름
        val notice_recyclerview_user_name_textview = itemView.notice_recyclerview_user_name_textview
        //공지사항 글 작성 일자
        val  notice_recyclerview_write_date_textview = itemView.notice_recyclerview_write_date_textview
        //부모 레이아웃
        val notice_recyclerview_parent_linearlayout = itemView.notice_recyclerview_parent_linearlayout
        //이름 및 날짜 사이의 Dot View
        val notice_recyclerview_side_textview = itemView.notice_recyclerview_side_textview


         init {

            //상품 넘기기
             notice_recyclerview_parent_linearlayout.setOnClickListener {
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
            .inflate(R.layout.notice_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }



    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int)
    {

        val  position_item : notice_Item = noticeItem!![position]

        //넘버
        viewHolder.notice_recyclerview_number_textview.setText(position_item.show_community_number)
        //제목
        viewHolder.notice_recyclerview_title_textview.setText(position_item.title)
        //유저이름
        viewHolder.notice_recyclerview_user_name_textview.setText(position_item.user_name)
        //날짜 데이터
        viewHolder.notice_recyclerview_write_date_textview.setText(position_item.write_date)

        if(position_item.user_name.equals(""))
        {

            viewHolder.notice_recyclerview_side_textview.visibility = View.GONE
        }


    }


    override fun getItemCount(): Int {
        return noticeItem?.size ?: 0
    }




}