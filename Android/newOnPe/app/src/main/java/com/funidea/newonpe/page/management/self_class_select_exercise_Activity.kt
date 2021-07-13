package com.funidea.newonpe.page.management


import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.funidea.utils.CustomToast.Companion.show
import com.funidea.newonpe.dialog.class_code_dialog_Utils.self_class_bottom_dialog_Item
import com.funidea.newonpe.dialog.self_class_exercise_name_bottom_dialog
import com.funidea.newonpe.R

import kotlinx.android.synthetic.main.activity_self_class_select_exercise.*


/** 셀프 체육 수업 선택 화면
 *
 *  셀프 체육 수업 화면이며, 해당 화면에서 사용자는 자신이 원하는 운동을 선택해 조합 할 수 있으며,
 *  운동을 조합하거나, 결과를 확인할 수 있는 페이지로 이동할 수 있습니다 .
 *  현재 사용 X
 *
 */



class self_class_select_exercise_Activity : AppCompatActivity() {

    var select_exercise_name_value : Boolean = false
    var select_exercise_detail_name_value : Boolean = false
    var select_category_value : Boolean = false

    var select_button_value : Boolean = false

    lateinit var selfClassListAdapter: self_class_list_Adapter
    var selfClassListItem = ArrayList<self_class_list_Item>()

    //종목
    var exercise_name_Array = ArrayList<self_class_bottom_dialog_Item>()
    var exercise_name_str : String =""
    //대분류
    var exercise_category_Array = ArrayList<self_class_bottom_dialog_Item>()
    var exercise_category_str : String = ""
    //동작명
    var exercise_detail_name_Array = ArrayList<self_class_bottom_dialog_Item>()
    var exercise_detail_name_str : String = ""


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_self_class_select_exercise)

        //운동 추가 버튼
        select_exercise_add_button_layout.setOnClickListener(add_exercise_button)
        //종목 추가 버튼
        select_exercise_name_layout.setOnClickListener(select_exercise_name_button)
        //대분류 추가 버튼
        select_exercise_category_layout.setOnClickListener(select_exercise_category_button)
        //동작명 추가 버튼
        select_exercise_detail_name_layout.setOnClickListener(select_exercise_detail_name_button)
        //수업 시작 버튼
        self_class_start_button_textview.setOnClickListener(self_class_start_button)


        selfClassListAdapter = self_class_list_Adapter(this, selfClassListItem)

        selfClassListAdapter.setonItemClickListener(object  : self_class_list_Adapter.onItemClickListener
        {
            override fun item_click(position: Int) {

            }

            override fun item_delete(position: Int) {

                selfClassListItem.removeAt(position)
                selfClassListAdapter.notifyItemRemoved(position)
                selfClassListAdapter.notifyItemRangeChanged(position, selfClassListItem.size)

                check_self_class_list()
            }


        })

        selfClassListItem.add(self_class_list_Item("실습형 수업","경쟁","[농구]","[공 다루기]","[공 다루기 동작]"))

        self_class_select_exercise_recyclerview.adapter = selfClassListAdapter

        //임시 데이터
        exercise_name_Array.add(self_class_bottom_dialog_Item("농구"))
        exercise_name_Array.add(self_class_bottom_dialog_Item("축구"))
        exercise_name_Array.add(self_class_bottom_dialog_Item("배구"))
        exercise_name_Array.add(self_class_bottom_dialog_Item("야구"))
        exercise_name_Array.add(self_class_bottom_dialog_Item("족구"))

        exercise_category_Array.add(self_class_bottom_dialog_Item("공던지기"))
        exercise_category_Array.add(self_class_bottom_dialog_Item("패스트슛"))
        exercise_category_Array.add(self_class_bottom_dialog_Item("패스트드리블"))
        exercise_category_Array.add(self_class_bottom_dialog_Item("공바운드"))
        exercise_category_Array.add(self_class_bottom_dialog_Item("롱패스"))
        exercise_category_Array.add(self_class_bottom_dialog_Item("스루패스"))

        exercise_detail_name_Array.add(self_class_bottom_dialog_Item("동작1"))
        exercise_detail_name_Array.add(self_class_bottom_dialog_Item("동작2"))
        exercise_detail_name_Array.add(self_class_bottom_dialog_Item("동작3"))
        exercise_detail_name_Array.add(self_class_bottom_dialog_Item("동작4"))
    }


    //운동 종목 추가 버튼
    val select_exercise_name_button = View.OnClickListener {
        


        val selfClassExerciseNameBottomDialog = self_class_exercise_name_bottom_dialog(this, exercise_name_Array)

        selfClassExerciseNameBottomDialog.show()

        selfClassExerciseNameBottomDialog.setselfClassListener(object  : self_class_exercise_name_bottom_dialog.selfClassListener
        {
            override fun select_class_name_value(select_code_name: String, select_position: Int?) {

                //custom_toast(this@self_class_select_exercise_Activity, select_code_name)
                selfClassExerciseNameBottomDialog.dismiss()
                select_exercise_name_textview.setText(select_code_name)
                select_exercise_name_value = true
                select_exercise_category_layout.setBackgroundResource(R.drawable.view_main_color_round_edge)
                select_exercise_category_textview.setTextColor(Color.parseColor("#3378fd"))
                select_exercise_category_arrow_imageview.setImageResource(R.drawable.main_color_down_arrow)
                exercise_name_str = select_code_name
            }

        }
        )

    }
    //운동 대분류 추가 버튼
    val select_exercise_category_button  = View.OnClickListener {

        if(select_exercise_name_value==true){
        
        val selfClassExerciseNameBottomDialog = self_class_exercise_name_bottom_dialog(this, exercise_category_Array)

        selfClassExerciseNameBottomDialog.show()

        selfClassExerciseNameBottomDialog.setselfClassListener(object  : self_class_exercise_name_bottom_dialog.selfClassListener
        {
            override fun select_class_name_value(select_code_name: String, select_position: Int?) {

                //custom_toast(this@self_class_select_exercise_Activity, select_code_name)
                selfClassExerciseNameBottomDialog.dismiss()
                select_exercise_category_textview.setText(select_code_name)
                select_category_value = true
                select_exercise_detail_name_layout.setBackgroundResource(R.drawable.view_main_color_round_edge)
                select_exercise_detail_name_textview.setTextColor(Color.parseColor("#3378fd"))
                select_exercise_detail_name_arrow_imageview.setImageResource(R.drawable.main_color_down_arrow)
                exercise_category_str = select_code_name
            }

        }
        )
        }
        else
        {
            show(this, "종목을 선택해주세요.")
        }
    }
    //운동 동작명 추가 버튼
    val select_exercise_detail_name_button = View.OnClickListener {

        if(select_category_value==true){

        val selfClassExerciseNameBottomDialog = self_class_exercise_name_bottom_dialog(this, exercise_detail_name_Array)

        selfClassExerciseNameBottomDialog.show()

        selfClassExerciseNameBottomDialog.setselfClassListener(object  : self_class_exercise_name_bottom_dialog.selfClassListener
        {
            override fun select_class_name_value(select_code_name: String, select_position: Int?) {

                //custom_toast(this@self_class_select_exercise_Activity, select_code_name)
                selfClassExerciseNameBottomDialog.dismiss()
                select_exercise_detail_name_textview.setText(select_code_name)
                select_exercise_detail_name_value = true
                exercise_detail_name_str = select_code_name

                check_add_exercise_button_state()
            }

        }
        )

        }else{

            show(this, "대분류를 선택해주세요.")
        }
    }

    //추가하기 버튼 활성화 여부
    fun check_add_exercise_button_state()
    {
        if(select_exercise_detail_name_value)
        {
            select_exercise_add_button_layout.setBackgroundResource(R.drawable.view_main_color_round_button)
            select_button_value = true
        }
        else
        {
            select_exercise_add_button_layout.setBackgroundResource(R.drawable.view_gray_color_2_round_edge)
            select_button_value = false

        }

    }


    //운동 추가 버튼
    val add_exercise_button = View.OnClickListener {

        if(select_button_value&&select_category_value&&select_exercise_name_value&&select_exercise_detail_name_value)
        {
            selfClassListItem.add(self_class_list_Item("실습형 수업","경쟁","["+exercise_name_str+"]","["+exercise_category_str+"]",
                                            "["+exercise_detail_name_str+"]"))

            selfClassListAdapter.notifyDataSetChanged()

            select_exercise_name_value = false
            select_exercise_detail_name_value= false
            select_category_value = false
            select_button_value = false

            exercise_name_str = ""
            exercise_category_str = ""
            exercise_detail_name_str = ""

            select_exercise_name_textview.setText("종목")

            select_exercise_category_textview.setText("대분류")
            select_exercise_category_layout.setBackgroundResource(R.drawable.view_gray_color_round_edge)
            select_exercise_category_textview.setTextColor(Color.parseColor("#9f9f9f"))
            select_exercise_category_arrow_imageview.setImageResource(R.drawable.gray_color_down_arrow)

            select_exercise_detail_name_textview.setText("동작명")
            select_exercise_detail_name_layout.setBackgroundResource(R.drawable.view_gray_color_round_edge)
            select_exercise_detail_name_textview.setTextColor(Color.parseColor("#9f9f9f"))
            select_exercise_detail_name_arrow_imageview.setImageResource(R.drawable.gray_color_down_arrow)

            check_add_exercise_button_state()


            check_self_class_list()
        }
        else
        {
            show(this, "운동을 정확하게 선택해주세요.")

        }

    }
    val self_class_start_button = View.OnClickListener {

        if(selfClassListItem.size!=0)
        {
            show(this, "운동 가능 ")
        }
        else
        {
         show(this, "시작할 운동 종목이 없습니다")
        }

    }

    fun check_self_class_list()
    {
        if(selfClassListItem.size!=0)
        {
            self_class_start_button_textview.setBackgroundResource(R.drawable.view_main_color_round_button)
        }
        else
        {

            self_class_start_button_textview.setBackgroundResource(R.drawable.view_gray_color_2_round_edge)
        }

    }

}