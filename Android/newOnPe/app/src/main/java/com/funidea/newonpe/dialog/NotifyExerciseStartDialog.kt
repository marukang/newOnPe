package com.funidea.newonpe.dialog

import android.content.Context
import android.graphics.Color
import android.view.View
import com.funidea.utils.CustomToast.Companion.show
import com.funidea.newonpe.R
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.android.synthetic.main.pose_exercise_start_bottom_dialog_item.*

/** 처음 운동을 시작하려고 할때 주의 사항 안내 및 동의사항에 대한 안내 BottomDialog
 *
 */
class NotifyExerciseStartDialog(context: Context) : BottomSheetDialog(context) {


    var exercise_confirm_Listener : ExerciseConfirmListener? =null

    var exercise_precautions_1 : Boolean = false
    var exercise_precautions_2 : Boolean = false
    var exercise_precautions_3 : Boolean = false
    var exercise_precautions_4 : Boolean = false
    var exercise_precautions_5 : Boolean = false
    var exercise_precautions_6 : Boolean = false
    var exercise_precautions_7 : Boolean = false


    interface ExerciseConfirmListener
    {
        fun select_confirm(select : String?)

    }

    fun setExerciseConfirmListener(exercise_confirm_Listener : ExerciseConfirmListener)
    {
        this.exercise_confirm_Listener = exercise_confirm_Listener
    }

    init {
        val view: View = layoutInflater.inflate(R.layout.pose_exercise_start_bottom_dialog_item, null)
        setContentView(view)

        exercise_start_check_textview_1.setOnClickListener {

            if(exercise_precautions_1)
            {
                exercise_precautions_1 = false
                exercise_start_check_textview_1.setBackgroundResource(R.drawable.view_main_color_in_white_round_edge)
                exercise_start_check_textview_1.setTextColor(Color.parseColor("#3378fd"))
                check_value()
            }
            else
            {
                exercise_precautions_1 = true
                exercise_start_check_textview_1.setBackgroundResource(R.drawable.view_main_color_round_button)
                exercise_start_check_textview_1.setTextColor(Color.parseColor("#ffffff"))
                check_value()
            }


        }
        exercise_start_check_textview_2.setOnClickListener {

            if(exercise_precautions_2)
            {
                exercise_precautions_2 = false
                exercise_start_check_textview_2.setBackgroundResource(R.drawable.view_main_color_in_white_round_edge)
                exercise_start_check_textview_2.setTextColor(Color.parseColor("#3378fd"))
                check_value()
            }
            else
            {
                exercise_precautions_2 = true
                exercise_start_check_textview_2.setBackgroundResource(R.drawable.view_main_color_round_button)
                exercise_start_check_textview_2.setTextColor(Color.parseColor("#ffffff"))
                check_value()
            }

        }
        exercise_start_check_textview_3.setOnClickListener {


            if(exercise_precautions_3)
            {
                exercise_precautions_3 = false
                exercise_start_check_textview_3.setBackgroundResource(R.drawable.view_main_color_in_white_round_edge)
                exercise_start_check_textview_3.setTextColor(Color.parseColor("#3378fd"))
                check_value()
            }
            else
            {
                exercise_precautions_3 = true
                exercise_start_check_textview_3.setBackgroundResource(R.drawable.view_main_color_round_button)
                exercise_start_check_textview_3.setTextColor(Color.parseColor("#ffffff"))
                check_value()
            }
        }
        exercise_start_check_textview_4.setOnClickListener {


            if(exercise_precautions_4)
            {
                exercise_precautions_4 = false
                exercise_start_check_textview_4.setBackgroundResource(R.drawable.view_main_color_in_white_round_edge)
                exercise_start_check_textview_4.setTextColor(Color.parseColor("#3378fd"))
                check_value()
            }
            else
            {
                exercise_precautions_4 = true
                exercise_start_check_textview_4.setBackgroundResource(R.drawable.view_main_color_round_button)
                exercise_start_check_textview_4.setTextColor(Color.parseColor("#ffffff"))
                check_value()
            }
        }
        exercise_start_check_textview_5.setOnClickListener {


            if(exercise_precautions_5)
            {
                exercise_precautions_5 = false
                exercise_start_check_textview_5.setBackgroundResource(R.drawable.view_main_color_in_white_round_edge)
                exercise_start_check_textview_5.setTextColor(Color.parseColor("#3378fd"))
                check_value()
            }
            else
            {
                exercise_precautions_5 = true
                exercise_start_check_textview_5.setBackgroundResource(R.drawable.view_main_color_round_button)
                exercise_start_check_textview_5.setTextColor(Color.parseColor("#ffffff"))
                check_value()
            }
        }

        exercise_start_check_textview_6.setOnClickListener {


            if(exercise_precautions_6)
            {
                exercise_precautions_6 = false
                exercise_start_check_textview_6.setBackgroundResource(R.drawable.view_main_color_in_white_round_edge)
                exercise_start_check_textview_6.setTextColor(Color.parseColor("#3378fd"))
                check_value()
            }
            else
            {
                exercise_precautions_6 = true
                exercise_start_check_textview_6.setBackgroundResource(R.drawable.view_main_color_round_button)
                exercise_start_check_textview_6.setTextColor(Color.parseColor("#ffffff"))
                check_value()
            }
        }

        exercise_start_check_textview_7.setOnClickListener {


            if(exercise_precautions_7)
            {
                exercise_precautions_7 = false
                exercise_start_check_textview_7.setBackgroundResource(R.drawable.view_main_color_in_white_round_edge)
                exercise_start_check_textview_7.setTextColor(Color.parseColor("#3378fd"))
                check_value()
            }
            else
            {
                exercise_precautions_7 = true
                exercise_start_check_textview_7.setBackgroundResource(R.drawable.view_main_color_round_button)
                exercise_start_check_textview_7.setTextColor(Color.parseColor("#ffffff"))
                check_value()
            }
        }

        exercise_start_check_confirm_textview.setOnClickListener {

            if(exercise_precautions_1&&
                    exercise_precautions_2&&
                    exercise_precautions_3&&
                    exercise_precautions_4&&
                    exercise_precautions_5&&
                    exercise_precautions_6&&
                    exercise_precautions_7 ){
            exercise_confirm_Listener?.select_confirm("1")
            }
            else
            {
                show(context, "운동을 시작하기 위해선 체크리스트를 모두 체크해야합니다.")
            }
        }




    }

    fun check_value()
    {
        if(exercise_precautions_1&&
           exercise_precautions_2&&
           exercise_precautions_3&&
           exercise_precautions_4&&
           exercise_precautions_5
        )
        {
            exercise_start_check_confirm_textview.setBackgroundResource(R.drawable.view_main_color_round_button)
            exercise_start_check_confirm_textview.setTextColor(Color.parseColor("#ffffff"))

        }
        else
        {
            exercise_start_check_confirm_textview.setBackgroundResource(R.drawable.view_main_color_in_white_round_edge)
            exercise_start_check_confirm_textview.setTextColor(Color.parseColor("#3378fd"))
        }


    }
}
