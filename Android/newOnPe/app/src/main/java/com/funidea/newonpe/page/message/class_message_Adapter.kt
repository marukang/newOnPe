package com.funidea.newonpe.page.message

import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.utils.set_User_info.Companion.student_name
import com.funidea.newonpe.R

import kotlinx.android.synthetic.main.class_message_recyclerview_item.view.*

/** Class message Adapter
 *
 *  message 내역을 보여주는 RecyclerView 의 Adapter
 *
 *  선생님께 보낸 메세지 내역을 나타내 주는 Recyclerview 의 Adapter class 입니다.
 */
class class_message_Adapter(context: Context, classMessageItem: ArrayList<class_message_Item>?)
    : RecyclerView.Adapter<class_message_Adapter.ViewHolder>()
{

    private val classMessageItem : ArrayList<class_message_Item>?

    private val context : Context

    private var mListener: onItemClickListener? = null

    interface onItemClickListener {
        fun item_click(position: Int)
        //fun item_delete(position: Int)
    }

    fun setonItemClickListener(listener: onItemClickListener?) {
        mListener = listener
    }


    init
    {
        this.classMessageItem = classMessageItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!)
    {

        //메세지 게시글 번호(혹은 공지사항 표시)
        val message_recyclerview_number_textview = itemView.message_recyclerview_number_textview
        //메세지 커뮤니티 게시글 타이틀
        val message_recyclerview_title_textview = itemView.message_recyclerview_title_textview
        //메세지 커뮤니티 글 작성자 이름
        val message_recyclerview_user_name_textview = itemView.message_recyclerview_user_name_textview
        //메세지 커뮤니티 글 작성 일자
        val  message_recyclerview_write_date_textview = itemView.message_recyclerview_write_date_textview

        val message_recyclerview_parent_linearlayout = itemView.message_recyclerview_parent_linearlayout

        val message_recyclerview_answer_state_textview = itemView.message_recyclerview_answer_state_textview

         init {

            //상품 넘기기
             message_recyclerview_parent_linearlayout.setOnClickListener {
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
            .inflate(R.layout.class_message_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }



    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int)
    {

        val  position_item : class_message_Item = classMessageItem!![position]

        //넘버
        viewHolder.message_recyclerview_number_textview.setText(position_item.show_number)
        //제목
        viewHolder.message_recyclerview_title_textview.setText(position_item.title)
        //유저이름
        viewHolder.message_recyclerview_user_name_textview.setText(student_name)
        //날짜 데이터
        viewHolder.message_recyclerview_write_date_textview.setText(position_item.write_date)

        if(position_item.message_state_value==0)
        {
            viewHolder.message_recyclerview_answer_state_textview.setText("미답변")
            viewHolder.message_recyclerview_answer_state_textview.setBackgroundResource(R.drawable.view_gray_color_round_edge)
            viewHolder.message_recyclerview_answer_state_textview.setTextColor(Color.parseColor("#9f9f9f"))
        }
        else
        {
           viewHolder.message_recyclerview_answer_state_textview.setText("답변완료")
           viewHolder.message_recyclerview_answer_state_textview.setBackgroundResource(R.drawable.view_main_color_round_edge)
           viewHolder.message_recyclerview_answer_state_textview.setTextColor(Color.parseColor("#3378fd"))
        }


    }


    override fun getItemCount(): Int {
        return classMessageItem?.size ?: 0
    }




}