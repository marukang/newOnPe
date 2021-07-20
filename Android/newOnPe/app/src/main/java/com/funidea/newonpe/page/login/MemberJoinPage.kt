package com.funidea.newonpe.page.login

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.util.Log
import android.util.Patterns
import android.view.View
import android.view.View.OnFocusChangeListener
import android.widget.Toast
import com.funidea.utils.CustomToast.Companion.show
import com.funidea.newonpe.R
import com.funidea.newonpe.dialog.CommonDialog
import com.funidea.newonpe.model.CurrentLoginStudent
import com.funidea.newonpe.network.ServerConnection
import com.funidea.newonpe.page.CommonActivity
import com.funidea.newonpe.page.setting.PersonalAgreementPage
import com.funidea.newonpe.page.setting.terms_of_user_information_agreement_Activity
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import kotlinx.android.synthetic.main.activity_join_page.*
import okhttp3.ResponseBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException
import java.util.regex.Pattern

/** 회원 가입 Class
 *
 * 사용자 회원가입을 위한 Page이며, 해당 페이지에서
 * 사용자는 아이디, 비밀번호, 이름, 전화번호(선택), 이메일, 이메일 인증, 푸시 동의 등을 설정하게 되며
 * 회원가입을 진행하는 클래스이다.
 *
 */

@Suppress("NULLABILITY_MISMATCH_BASED_ON_JAVA_ANNOTATIONS")
class MemberJoinPage : CommonActivity() {

    companion object
    {
        const val CALL = 9998
    }

    private var mIsConfirmedId : Boolean = false // 중복되는 아이디 인지 여부를 알려주는 값
    private var mIsNameChecked : Boolean = false // 본인 인증이 되었는지 여부를 알려주는 값
    private var mIsEmailCodeConfirmed : Boolean = false // 정상적인 이메일인지 여부를 나타내는 인증값
    private var mEmailAuthCode : String = ""
    private var mStudentPushAgreement : String = "n"
    private var mInsertedStudentName : String? = ""
    private var mInsertedStudentBirthDate : String? = ""
    private var mInsertedStudentPhoneNumber : String? = ""

    private val mTextWatcherInsertedID: TextWatcher = object : TextWatcher { //아이디 확인을 위한 TextWatcher
        //입력되는 텍스트에 변화가 있을 때
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int)
        {
            mIsConfirmedId = false

            join_page_check_id_textview.isSelected = TextUtils.isEmpty(s)
            join_page_check_id_textview.text = "중복확인"

            // if (!TextUtils.isEmpty(s) && !Pattern.matches("^(?=.*\\d)(?=.*[a-zA-Z]).{4,12}$", s))
            if (!TextUtils.isEmpty(s) && !Patterns.EMAIL_ADDRESS.matcher(s).matches())
            {
                join_page_id_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                join_page_input_id_textview.setTextColor(Color.parseColor("#FF0000"))
                join_page_check_id_textview.isSelected = true
            }
            else
            {
                join_page_id_linearlayout.setBackgroundResource(
                    if (TextUtils.isEmpty(s))
                        R.drawable.selector_registration_form else R.drawable.view_main_color_2_round_button)
                join_page_input_id_textview.setTextColor(Color.parseColor("#3378fd"))
                join_page_check_id_textview.isSelected = TextUtils.isEmpty(s)
            }

            //가입 버튼 활성화 클래스
            updateJoinButtonAvailability()
        }
        // 입력이 끝났을 때
        override fun afterTextChanged(arg0: Editable)
        {

        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int)
        {
            // 입력하기 전에
        }
    }

    private var mTextWatcherInsertedPassword: TextWatcher = object : TextWatcher
    {
        override fun beforeTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {

        }

        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {
            // 특수문자를 포함하는 경우
            // !Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$", charSequence)

            //비밀번호는 영어 대&소문자로 구성되며 8자리에서 16자리로 이루어진다.
            // if (!Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,16}$", charSequence)) //사용이 불가능한 경우
            if (!Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,16}$", charSequence))
            {
                join_page_input_pw_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                join_page_input_pw_textview.setTextColor(Color.parseColor("#FF0000"))

                password_warning_message.visibility = View.VISIBLE
            }
            else
            {
                join_page_input_pw_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                join_page_input_pw_textview.setTextColor(Color.parseColor("#3378fd"))

                password_warning_message.visibility = View.GONE
            }
        }

        override fun afterTextChanged(editable: Editable)
        {

        }
    }

    //정규 표현식을 이용해 입력 된 PW와 PW 확인을 비교해서 알려준다.
    //앞서 입력한 PW와 PW 재입력 확인을 위한 TextWatcher
    private var mTextWatcherPasswordDifference: TextWatcher = object : TextWatcher
    {
        override fun beforeTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int)
        {

        }

        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int)
        {
            //앞서 입력한 PW와 같지 않은 경우
            if (!isPasswordDoubleChecked())
            {
                join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                join_page_input_pw_confirm_textview.setTextColor(Color.parseColor("#FF0000"))
                password_warning_message2.visibility = View.VISIBLE
            }
            else
            {
                join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                join_page_input_pw_confirm_textview.setTextColor(Color.parseColor("#3378fd"))
                password_warning_message2.visibility = View.GONE
            }

            //가입 버튼 활성화 클래스
            updateJoinButtonAvailability()
        }

        override fun afterTextChanged(editable: Editable) {

        }
    }

    //이름 정규 표현식
    //이름 입력 확인을 위한 TextWatcher
    private val mTextWatcherInsertedName: TextWatcher = object : TextWatcher
    {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            // 입력되는 텍스트에 변화가 있을 때

            //아래와 같이 한글 외에 것이 포함된 경우
            if (!Pattern.matches("^[ㄱ-ㅎㅏ-ㅣ가-힣].{0,8}", s))
            {
                join_page_input_name_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                join_page_input_name_textview.setTextColor(Color.parseColor("#FF0000"))
            }
            else
            {

                //자음만을 입력하는 것을 방지
                //자음+모음으로 이루어진 글자로 2~8글자 사이가 아닐 경우
                if (!Pattern.matches("^[가-힣].{1,8}", s))
                {
                    join_page_input_name_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                    join_page_input_name_textview.setTextColor(Color.parseColor("#FF0000"))
                }
                else
                {
                    join_page_input_name_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                    join_page_input_name_textview.setTextColor(Color.parseColor("#3378fd"))
                }
            }

            //가입 버튼 활성화 클래스
            updateJoinButtonAvailability()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }
    //이메일 입력 확인을 위한 TextWatcher
    private val mTextWatcherInsertedEmailAddress: TextWatcher = object : TextWatcher
    {
        override fun beforeTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {

            if (!Patterns.EMAIL_ADDRESS.matcher(charSequence).matches())
            {
                join_page_input_email_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                join_page_input_email_textview.setTextColor(Color.parseColor("#FF0000"))
                join_page_check_email_textview.setTextColor(Color.parseColor("#FF0000"))
            }
            else
            {
                join_page_input_email_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                join_page_input_email_textview.setTextColor(Color.parseColor("#3378fd"))
                join_page_check_email_textview.setTextColor(Color.parseColor("#FF0000"))
            }

            //가입 버튼 활성화 클래스
            updateJoinButtonAvailability()
        }

        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {
            //특수문자를 포함하는 경우
            //!Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$", charSequence)

            //이메일이 양식에 맞는 지 확인한다.
            //이메일 양식에 일치하지 않는 경우
            if (!isRegularFormatEmailAddress())
            {
                join_page_input_email_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                join_page_input_email_textview.setTextColor(Color.parseColor("#FF0000"))
                join_page_check_email_textview.setTextColor(Color.parseColor("#FF0000"))
            }
            else
            {
                join_page_input_email_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                join_page_input_email_textview.setTextColor(Color.parseColor("#3378fd"))
                join_page_check_email_textview.setTextColor(Color.parseColor("#FF0000"))
            }

            //가입 버튼 활성화 클래스
            updateJoinButtonAvailability()
        }

        override fun afterTextChanged(editable: Editable)
        {

        }
    }
    // 핸드폰 번호 입력 확인을 위한 TextWatcher
    private val mTextWatcherInsertedPhoneNumber: TextWatcher = object : TextWatcher
    {
        private var mBeforeLength = 0
        private var mAfterLength = 0

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            mBeforeLength = s.length
        }

        @SuppressLint("SetTextI18n")
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if (TextUtils.isEmpty(s))
            {
                sending_sms_auth_code.isSelected = true
                return
            }

            //해당 문자 선택하기.
            //ex 가나다라(라고 쓴 경우) 3번째(3-1=2 // 0 , 1, 2로해서)를 선택하게 되면 다가 나옴.
            val inputChar = s[s.length - 1]

            //delete함수(삭제 시작점, 삭제 끝점)
            if (inputChar != '-' && (inputChar < '0' || inputChar > '9')) {
                join_page_input_phone_edittext.text.delete(s.length - 1, s.length)
                sending_sms_auth_code.isSelected = true
                return
            }
            mAfterLength = s.length

            // 삭제 중
            if (mBeforeLength > mAfterLength)
            {
                // 삭제 중에 마지막에 -는 자동으로 지우기
                if (s.toString().endsWith("-"))
                {
                    join_page_input_phone_edittext.setText(s.toString().substring(0, s.length - 1))
                }
            }
            else if (mBeforeLength < mAfterLength)
            {
                //총 길이가 4이고, "-"라는 문자열이 존재하지 않을 때,
                //ex String aa = 12345; 가정
                //subSequence - 해당 부분의 문자열을 추출해준다. (0, 3) 일 경우 1,2,3 발췌
                //substring - 시작점부터 문자열을 뽑아낸다.(3, aa.length()) 일 경우 4,5를 가져온다.
                //indexof에 값이 존재하지 않으면 '-1'로 반환한다.
                if (mAfterLength == 4 && s.toString().indexOf("-") < 0)
                {
                    val phoneNumber = s.toString().subSequence(0, 3).toString() + "-" + s.toString().substring(3, s.length)
                    join_page_input_phone_edittext.setText(phoneNumber)
                }
                else if (mAfterLength == 9)
                {
                    val phoneNumber = s.toString().subSequence(0, 8).toString() + "-" + s.toString().substring(8, s.length)
                    join_page_input_phone_edittext.setText(phoneNumber)
                }
            }

            if (s.length == 13)
            {
                join_page_input_phone_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)
                join_page_input_phone_textview.setTextColor(Color.parseColor("#3378fd"))
                sending_sms_auth_code.isSelected = false
            }
            else
            {
                join_page_input_phone_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                join_page_input_phone_textview.setTextColor(Color.parseColor("#404040"))
                sending_sms_auth_code.isSelected = true
            }

            join_page_input_phone_edittext.setSelection(join_page_input_phone_edittext.length())
        }

        override fun afterTextChanged(s: Editable)
        {
            // 생략
        }
    }

    //이메일 인증코드 확인
    private var mEmailCodeTextWatcher: TextWatcher = object : TextWatcher {

        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(!TextUtils.isEmpty(s))
            {
                if (join_page_input_email_code_confirm_edittext.length() == 6)
                {
                    join_page_input_email_code_textview.setTextColor(Color.parseColor("#3378fd"))
                    join_page_check_email_code_textview.setTextColor(Color.parseColor("#FF0000"))
                    join_page_input_email_code_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)
                }
                else if(join_page_input_email_code_confirm_edittext.length() <= 5)
                {
                    join_page_check_email_code_textview.setTextColor(Color.parseColor("#FF0000"))
                    join_page_input_email_code_textview.setTextColor(Color.parseColor("#FF0000"))
                    join_page_input_email_code_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                }

            }
            else
            {
                join_page_check_email_code_textview.setTextColor(Color.parseColor("#9f9f9f"))
                join_page_input_email_code_textview.setTextColor(Color.parseColor("#9f9f9f"))
                join_page_input_email_code_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)
            }
        }

        override fun afterTextChanged(arg0: Editable)
        {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int)
        {
            // 입력하기 전에
        }
    }

    //전체 동의 버튼
    private val mAlLAgreementButtonAction = View.OnClickListener {

        if (join_page_checkbox_all.isChecked)
        {
            join_page_checkbox_1.isChecked = true
            join_page_checkbox_2.isChecked = true
            join_page_checkbox_3.isChecked = true
            join_page_checkbox_4.isChecked = true
        }
        else
        {
            join_page_checkbox_1.isChecked = false
            join_page_checkbox_2.isChecked = false
            join_page_checkbox_3.isChecked = false
            join_page_checkbox_4.isChecked = false
        }

        updateJoinButtonAvailability()
    }

    private val mClickActionOfTermAgreement = View.OnClickListener {

        val intent = Intent(this, terms_of_user_information_agreement_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }

    private val mClickActionOfPersonalInfo = View.OnClickListener {

        val intent = Intent(this, PersonalAgreementPage::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }

    private val mClickActionSMSAuth = View.OnClickListener {

        val intent = Intent(this, SMSAuthPage::class.java)
        startActivityForResult(intent, SMSAuthPage.CALL)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }

    //email 중복 확인
    private val mClickActionOfDuplicatedEmailAddress = View.OnClickListener {

        if(isRegularFormatEmailAddress())
        {

            var get_email_address =  join_page_input_email_edittext.text.toString()
            get_email_address = get_email_address.trim()

            // checkDuplicatedEmailAddress(get_email_address)

          /*  //서버에서 중복 확인 해줄 것
            email_confirm_check = true
            Toast.makeText(this,"중복 확인이 완료되었습니다. 해당 이메일에서 인증코드를 확인 후 입력 해주세요.", Toast.LENGTH_SHORT).show()
            join_page_check_email_textview.setTextColor(Color.parseColor("#3378fd"))*/
        }
        else
        {
            Toast.makeText(this,"이메일을 양식에 맞게 입력해주세요.", Toast.LENGTH_SHORT).show()
        }

    }

    //email 인증코드 확인 버튼
    private val mClickActionOfEmailAuth = View.OnClickListener {

        if(isRegularFormatEmailAddress())
        {

            if (mEmailAuthCode == join_page_input_email_code_confirm_edittext.text.toString())
            {
                //인증코드 확인해주기
                Toast.makeText(this,"인증코드 확인이 완료되었습니다.", Toast.LENGTH_SHORT).show()
                join_page_check_email_code_textview.setTextColor(Color.parseColor("#3378fd"))
                mIsEmailCodeConfirmed = true
            }
            else
            {
                Toast.makeText(this,"인증코드 다시 확인해주세요.", Toast.LENGTH_SHORT).show()
            }

        }
        else
        {
            Toast.makeText(this,"이메일을 양식 혹은 중복검사를 진행해주세요.", Toast.LENGTH_SHORT).show()

        }

        updateJoinButtonAvailability()
    }
    //아이디 중복 확인 버튼
    private val mConfirmDuplicatedIdAction = View.OnClickListener {

        if (isRegularFormatId())
        {
            checkDuplicatedId(join_page_input_id_edittext.text.toString())
        }
        else
        {
            Toast.makeText(this,"영어+숫자 (4자리~12자리)로 구성 된 아이디로 입력 해주세요.", Toast.LENGTH_SHORT).show()
        }

        updateJoinButtonAvailability()
    }

    /**
     * 이용약관 클릭 시 isAllCheck()라는 값을 return 받는다.
     * 받은 값에 따라서 all_agreement_checkbox의 체크 여부를 결정해준다.
     */
    private val onCheckBoxClickListener = View.OnClickListener {

        join_page_checkbox_all.isChecked = isAllChecked()

        updateJoinButtonAvailability()
    }

    override fun init(savedInstanceState: Bundle?)
    {
        mIsNameChecked = true
        mIsEmailCodeConfirmed = true
        // ============================================================

        setContentView(R.layout.activity_join_page)

        join_page_personal_info_agreement_textview.setOnClickListener(mClickActionOfPersonalInfo) //개인정보 이용 동의
        join_page_terms_of_user_info_agree.setOnClickListener(mClickActionOfTermAgreement) //온체육 서비스 이용 약관 동의

        //전체 선택 버튼
        join_page_checkbox_all.setOnClickListener(mAlLAgreementButtonAction)
        join_page_checkbox_1.setOnClickListener(onCheckBoxClickListener); //선택버튼
        join_page_checkbox_2.setOnClickListener(onCheckBoxClickListener);
        join_page_checkbox_3.setOnClickListener(onCheckBoxClickListener);
        join_page_checkbox_4.setOnClickListener(onCheckBoxClickListener);
        join_page_back_button.setOnClickListener{
            onBackPressed()
        }
        join_page_check_id_textview.isSelected = true

        join_page_input_id_edittext.addTextChangedListener(mTextWatcherInsertedID) //아이디 입력
        join_page_check_id_textview.setOnClickListener(mConfirmDuplicatedIdAction) //아이디 중복확인 버튼
        join_page_input_pw_edittext.addTextChangedListener(mTextWatcherInsertedPassword) //비밀번호 입력
        join_page_input_pw_edittext.onFocusChangeListener = OnFocusChangeListener { _, gainFocus -> //비밀번호 edittext 포커스

            val insertedPassword1 = join_page_input_pw_edittext.text.toString()

            if (gainFocus)
            {
                when {
                    TextUtils.isEmpty(insertedPassword1) -> {
                        join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.selector_registration_form)
                    }

                    isPasswordDoubleChecked() -> {
                        join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                    }

                    else -> {
                        join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                    }
                }
            }
        }

        join_page_input_pw_confirm_edittext.addTextChangedListener(mTextWatcherPasswordDifference) //비밀번호 입력 확인
        join_page_input_pw_confirm_edittext.onFocusChangeListener = OnFocusChangeListener { _, gainFocus ->

            val insertedPassword2 = join_page_input_pw_confirm_edittext.text.toString()

            if (gainFocus)
            {
                when {
                    TextUtils.isEmpty(insertedPassword2) -> {
                        join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.selector_registration_form)
                    }

                    isPasswordDoubleChecked() -> {
                        join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                    }

                    else -> {
                        join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                    }
                }
            }
        }

        join_page_input_name_edittext.addTextChangedListener(mTextWatcherInsertedName) //이름 입력
        join_page_input_phone_edittext.addTextChangedListener(mTextWatcherInsertedPhoneNumber) //핸드폰 입력
        join_page_input_email_edittext.addTextChangedListener(mTextWatcherInsertedEmailAddress) //이메일 입력
        join_page_check_email_textview.setOnClickListener(mClickActionOfDuplicatedEmailAddress) //이메일 중복확인
        join_page_input_email_code_confirm_edittext.addTextChangedListener(mEmailCodeTextWatcher) //인증번호 입력
        join_page_check_email_code_textview.setOnClickListener(mClickActionOfEmailAuth) //인증번호 확인 버튼
        sending_sms_auth_code.isSelected = true
        sending_sms_auth_code.setOnClickListener(mClickActionSMSAuth)

        join_page_confirm_textview.setOnClickListener {
            //회원가입 버튼
            val popupTitle = resources.getString(R.string.registration_marketing_popup_title)
            val popupMessage = resources.getString(R.string.registration_marketing_popup_message)
            val popupSubMessage = resources.getString(R.string.registration_marketing_popup_sub_message)

            showDialog(popupTitle, popupMessage, popupSubMessage)
            {
                mStudentPushAgreement = if (it) "y" else "n"

                tryRegistration()
            }
        }

        updateJoinButtonAvailability()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        when (requestCode)
        {
            SMSAuthPage.CALL ->
            {
                val userData = data?.getStringExtra("user")
                if (!TextUtils.isEmpty(userData))
                {
                    val json = JSONObject(userData)

                    mInsertedStudentName = json.getString("name")
                    mInsertedStudentPhoneNumber = json.getString("phone")
                    mInsertedStudentPhoneNumber = mInsertedStudentPhoneNumber?.replace("-", "")
                    mInsertedStudentBirthDate = json.getString("birthday")

                    sending_sms_auth_code.isSelected = false
                    sending_sms_auth_code.text = "본인인증 완료"

                    updateJoinButtonAvailability()
                }
            }

            ProfileRegistrationPage.CALL ->
            {
                setResult(RESULT_OK)
                onBackPressed()
            }
        }
    }

    override fun onBackPressed()
    {
        super.onBackPressed()
        overridePendingTransition(R.anim.anim_slide_in_left, R.anim.anim_slide_out_right)
    }

    private fun updateJoinButtonAvailability()
    {
        var joinButtonAvailability = true
        joinButtonAvailability = joinButtonAvailability && mIsConfirmedId
        joinButtonAvailability = joinButtonAvailability && isRegularFormatId()
        joinButtonAvailability = joinButtonAvailability && isRegularFormatPassword()
        joinButtonAvailability = joinButtonAvailability && !TextUtils.isEmpty(mInsertedStudentName)

        join_page_confirm_textview.setBackgroundResource(if (joinButtonAvailability) R.color.main_color else R.color.gray)
        join_page_confirm_textview.isEnabled = joinButtonAvailability
    }

    private fun isRegularFormatId() : Boolean
    {
        val insertedId = join_page_input_id_edittext.text.toString()
        // return !TextUtils.isEmpty(insertedId) && Pattern.matches("^(?=.*\\d)(?=.*[a-zA-Z]).{4,12}$", insertedId)
        return !TextUtils.isEmpty(insertedId) && Patterns.EMAIL_ADDRESS.matcher(insertedId).matches()
    }

    private fun isRegularFormatPassword() : Boolean
    {
        val insertPassword = join_page_input_pw_edittext.text.toString()
        return !TextUtils.isEmpty(insertPassword) && Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,16}$", insertPassword)
    }

    private fun isRegularFormatEmailAddress() : Boolean
    {
        val insertEmailAddress = join_page_input_email_edittext.text.toString()
        return !TextUtils.isEmpty(insertEmailAddress) && Patterns.EMAIL_ADDRESS.matcher(insertEmailAddress).matches()
    }

    private fun isPasswordDoubleChecked() : Boolean
    {
        val insertedPassword1 = join_page_input_pw_edittext.text.toString()
        val insertedPassword2 = join_page_input_pw_confirm_edittext.text.toString()

        return (!TextUtils.isEmpty(insertedPassword1) && insertedPassword1 == insertedPassword2)
    }

    //체크 여부를 확인해서 모든 체크박스가 체크가 되어 있다면, true 값을 반환하고 아닐 경우 false 값을 반환한다.
    //ex ) A ? B : C ; 라고 생각했을 때 A가 참이면 B를 리턴, 거짓이면 C를 리턴한다.
    private fun isAllChecked(): Boolean {
        return join_page_checkbox_1.isChecked
                && join_page_checkbox_2.isChecked
                && join_page_checkbox_3.isChecked
                && join_page_checkbox_4.isChecked
    }

    //아이디 중복 검사
    private fun checkDuplicatedId(student_id : String)
    {
        ServerConnection.checkDuplicatedId(student_id) { responseCode ->

            when (responseCode)
            {
                -2 ->
                {
                    join_page_id_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)

                    mIsConfirmedId = false

                    showDialog("알림", "아이디 중복 확인중 오류가 발생하였습니다. 다시 시도하여 주세요", buttonCount = CommonDialog.ButtonCount.ONE)
                }

                -1 ->
                {
                    join_page_id_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)

                    mIsConfirmedId = false

                    showDialog("알림", "중복되는 아이디가 있습니다", buttonCount = CommonDialog.ButtonCount.ONE)
                }

                1 ->
                {
                    mIsConfirmedId = true

                    showDialog("알림", "사용 가능한 아이디 입니다.", buttonCount = CommonDialog.ButtonCount.ONE) {
                        join_page_check_id_textview.text = "확인완료"
                    }
                }
            }

            updateJoinButtonAvailability()
        }
    }

    //회원 가입
    private fun tryRegistration()
    {
        val insertedId = join_page_input_id_edittext.text.toString()
        val insertedPassword = join_page_input_pw_confirm_edittext.text.toString()

        ServerConnection.tryRegistration(insertedId, mInsertedStudentName!!, insertedPassword, mInsertedStudentPhoneNumber!!, mStudentPushAgreement) { isSuccess ->

            if (isSuccess)
            {
                val preferences = getSharedPreferences("user_info", Context.MODE_PRIVATE)
                val editor = preferences.edit()

                editor.putString("user_id", CurrentLoginStudent.root!!.student_id)
                editor.putString("user_access_token", CurrentLoginStudent.root!!.access_token)
                editor.commit()

                val intent = Intent(this, ProfileRegistrationPage::class.java)
                startActivityForResult(intent, ProfileRegistrationPage.CALL)
                overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
            }
            else
            {
                showDialog("알림", "회원가입 중 에러가 발생하였습니다. 잠시 후 다시 시도하여 주시기 바랍니다", buttonCount = CommonDialog.ButtonCount.ONE)
            }
        }
    }
}

