package com.funidea.newonpe.page.login


import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.os.CountDownTimer
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.activity_pw_search_input_code.*
import java.util.*


/** PW 찾기 인증 코드 입력
 *
 * PW를 찾기를 통해 자신의 이메일을 통해 전송 된 인증코드를 입력하는 부분입니다.
 * 해당 부분에서 인증코드를 입력하고 완료한 경우 다음 화면에서 새로운 비밀번호를 설정할 수 있습니다.
 *
 */

class EmailAuthenticationPage : AppCompatActivity() {

    //카운트 다운 타이머 관련 함수
    private val START_TIME_IN_MILLIS: Long = 300000
    //private val START_TIME_IN_MILLIS: Long = 64000
    private var mCountDownTimer: CountDownTimer? = null
    private var mTimerRunning = false
    private var mTimeLeftInMillis = START_TIME_IN_MILLIS

    var confirm_code : String=""
    var input_email : String =""
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_pw_search_input_code)

        var getIntent = intent

        input_email = getIntent.getStringExtra("input_email").toString()
        confirm_code = getIntent.getStringExtra("confirm_code").toString()



        
        //카운트 타이머
        startTimer()

        pw_search_input_code_back_button.setOnClickListener(back_button)
        pw_search_input_code_confirm_button.setOnClickListener(confirm_button)

        input_code_edittext_1.addTextChangedListener(next_focus_1)
        input_code_edittext_2.addTextChangedListener(next_focus_2)
        input_code_edittext_3.addTextChangedListener(next_focus_3)
        input_code_edittext_4.addTextChangedListener(next_focus_4)
        input_code_edittext_5.addTextChangedListener(next_focus_5)
        input_code_edittext_6.addTextChangedListener(next_focus_6)

    }

    //아이디 체크
    var next_focus_1: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(input_code_edittext_1.length()>0)
                {
                    input_code_edittext_1.setBackgroundResource(R.drawable.view_main_color_round_edge)
                    input_code_edittext_2.requestFocus()
                }
                else if(input_code_edittext_1.length()<=0)
                {
                    input_code_edittext_1.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                }

            }
            else
            {
                input_code_edittext_1.setBackgroundResource(R.drawable.view_gray_color_round_edge)
            }

            check_value()
        }

        override fun afterTextChanged(arg0: Editable) { // 입력이 끝났을 때
             }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) { // 입력하기 전에
        }
    }
    var next_focus_2: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(input_code_edittext_2.length()>0)
                {
                    input_code_edittext_2.setBackgroundResource(R.drawable.view_main_color_round_edge)
                    input_code_edittext_3.requestFocus()
                }
                else if(input_code_edittext_2.length()<=0)
                {
                    input_code_edittext_2.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                }

            }
            else
            {
                input_code_edittext_2.setBackgroundResource(R.drawable.view_gray_color_round_edge)
            }

            check_value()

        }

        override fun afterTextChanged(arg0: Editable) { // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) { // 입력하기 전에
        }
    }
    var next_focus_3: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(input_code_edittext_3.length()>0)
                {
                    input_code_edittext_3.setBackgroundResource(R.drawable.view_main_color_round_edge)
                    input_code_edittext_4.requestFocus()
                }
                else if(input_code_edittext_3.length()<=0)
                {
                    input_code_edittext_3.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                }

            }
            else
            {
                input_code_edittext_3.setBackgroundResource(R.drawable.view_gray_color_round_edge)
            }

            check_value()

        }

        override fun afterTextChanged(arg0: Editable) { // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) { // 입력하기 전에
        }
    }
    var next_focus_4: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(input_code_edittext_4.length()>0)
                {
                    input_code_edittext_4.setBackgroundResource(R.drawable.view_main_color_round_edge)
                    input_code_edittext_5.requestFocus()
                }
                else if(input_code_edittext_4.length()<=0)
                {
                    input_code_edittext_4.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                }

            }
            else
            {
                input_code_edittext_4.setBackgroundResource(R.drawable.view_gray_color_round_edge)
            }

            check_value()
        }

        override fun afterTextChanged(arg0: Editable) { // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) { // 입력하기 전에
        }
    }
    var next_focus_5: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(input_code_edittext_5.length()>0)
                {
                    input_code_edittext_5.setBackgroundResource(R.drawable.view_main_color_round_edge)
                    input_code_edittext_6.requestFocus()
                }
                else if(input_code_edittext_5.length()<=0)
                {
                    input_code_edittext_5.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                }

            }
            else
            {
                input_code_edittext_5.setBackgroundResource(R.drawable.view_gray_color_round_edge)
            }

            check_value()

        }

        override fun afterTextChanged(arg0: Editable) { // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) { // 입력하기 전에
        }
    }
    var next_focus_6: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(input_code_edittext_6.length()>0)
                {
                    input_code_edittext_6.setBackgroundResource(R.drawable.view_main_color_round_edge)

                }
                else if(input_code_edittext_6.length()<=0)
                {
                    input_code_edittext_6.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                }

            }
            else
            {
                input_code_edittext_6.setBackgroundResource(R.drawable.view_gray_color_round_edge)
            }
            check_value()
        }

        override fun afterTextChanged(arg0: Editable) { // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) { // 입력하기 전에
        }
    }
    //확인 버튼
    val confirm_button = View.OnClickListener {

        if (input_code_edittext_1.length() != 1 ||
            input_code_edittext_2.length() != 1 ||
            input_code_edittext_3.length() != 1 ||
            input_code_edittext_4.length() != 1 ||
            input_code_edittext_5.length() != 1 ||
            input_code_edittext_6.length() != 1)
        {
            pw_search_input_code_confirm_button.setBackgroundColor(Color.parseColor("#9f9f9f"))

            Toast.makeText(this, "인증 번호를 정확히 입력해주세요.", Toast.LENGTH_SHORT).show()
        }
        else
        {
            pw_search_input_code_confirm_button.setBackgroundColor(Color.parseColor("#3378fd"))

            val confirm_code_value = input_code_edittext_1.text.toString()+input_code_edittext_2.text.toString()+input_code_edittext_3.text.toString()+input_code_edittext_4.text.toString()+input_code_edittext_5.text.toString()+input_code_edittext_6.text.toString()

            if(confirm_code_value.equals(confirm_code))
            {
                Toast.makeText(this, "인증번호가 확인되었습니다.", Toast.LENGTH_SHORT).show()
                val intent = Intent(this, ChangePasswordPage::class.java)
                intent.putExtra("confirm_code", confirm_code)
                intent.putExtra("input_email", input_email)
                startActivity(intent)
                finish()
                overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

            }
            else
            {
                Toast.makeText(this, "인증번호가 틀립니다.", Toast.LENGTH_SHORT).show()
            }



        }
    }


    //뒤로 가기 버튼
    val back_button = View.OnClickListener {
        onBackPressed()
    }

    override fun onBackPressed()
    {
        super.onBackPressed()
        overridePendingTransition(R.anim.anim_slide_in_left, R.anim.anim_slide_out_right)
    }

    fun check_value() {

        if (input_code_edittext_1.length() != 1 ||
            input_code_edittext_2.length() != 1 ||
            input_code_edittext_3.length() != 1 ||
            input_code_edittext_4.length() != 1 ||
            input_code_edittext_5.length() != 1 ||
            input_code_edittext_6.length() != 1)
        {
            pw_search_input_code_confirm_button.setBackgroundColor(Color.parseColor("#9f9f9f"))
        }
        else
        {
            pw_search_input_code_confirm_button.setBackgroundColor(Color.parseColor("#3378fd"))
        }
    }

    private fun startTimer() {
        mCountDownTimer = object : CountDownTimer(mTimeLeftInMillis, 1000) {
            override fun onTick(millisUntilFinished: Long) {
                mTimeLeftInMillis = millisUntilFinished
                updateCountDownText()
            }

            override fun onFinish() {
                mTimerRunning = false

                Toast.makeText(this@EmailAuthenticationPage, "입력 시간이 종료되었습니다.\n이전 화면으로 돌아갑니다.", Toast.LENGTH_SHORT).show()
                finish()
            }
        }.start()
        mTimerRunning = true

    }

    private fun updateCountDownText() {
        val minutes = (mTimeLeftInMillis / 1000).toInt() / 60
        val seconds = (mTimeLeftInMillis / 1000).toInt() % 60
        val timeLeftFormatted: String =
            java.lang.String.format(Locale.getDefault(), "%02d:%02d", minutes, seconds)

        if(mTimeLeftInMillis<=60000)
        {
           countdown_textview.setTextColor(Color.parseColor("#ff0000"))
        }
        countdown_textview.setText(timeLeftFormatted)
    }

}