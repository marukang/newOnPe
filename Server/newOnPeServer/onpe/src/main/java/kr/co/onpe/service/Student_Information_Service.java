package kr.co.onpe.service;


import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.co.onpe.dao.Student_Information_DAO;
import kr.co.onpe.vo.Common_Message_VO;
import kr.co.onpe.vo.Notice_List_VO;
import kr.co.onpe.vo.Push_List_VO;
import kr.co.onpe.vo.Student_Information_VO;

/* 사용자 정보 테이블(student_information) 테이블 관련 서비스 */

@Service
public class Student_Information_Service {
	
	@Inject
    private Student_Information_DAO Student_information_DAO;
	
	
	
	
	/* ############################################################ Method #################################################################### */
	
	/* 앱 사용자 로그인 ( 매개변수 id , pw(sha256) ) */
	public Student_Information_VO Student_Information_for_Login(String student_id, String student_password){
		try {
			Student_Information_VO user = Student_information_DAO.Student_Information_for_Login(student_id, student_password);
	        if(user==null) {
	        	//System.out.println("널임");
	            //throw new UsernameNotFoundException(student_id);
	        }
	        return user;
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	/* 앱 사용자 회원탈퇴 */
	public boolean Student_Resign(String student_id) {
		return Student_information_DAO.Student_Resign(student_id);
	}
	
	/* 앱 사용자 로그인 ( 토큰로그인, 자동로그인 ) */
	public Student_Information_VO Student_Information_for_Auto_login(String student_id) {
    	return Student_information_DAO.Student_Information_for_Auto_login(student_id);
    }
	/* 앱 사용자 SNS 로그인 ( 토큰로그인, 자동로그인 ) */
	public Student_Information_VO Student_Information_for_Auto_login(String student_id, String loginType) {
    	return Student_information_DAO.Student_Information_for_Auto_login(student_id, loginType);
    }

	/* 앱 사용자 아이디 중복확인 */
	public boolean Id_Overlap_Check(String is_student_id) {
		String student_id = Student_information_DAO.Id_Overlap_Check(is_student_id);
		if(student_id == null) {
			return false;
		}else {
			return true;
		}
	}
	
	
	/* 앱 사용자 최근 접속일 업데이트 */
	public void Update_student_recent_join_date(String student_id, String time_number) {
		Student_information_DAO.Update_student_recent_join_date(student_id, time_number);
	}
	
    /* 앱 사용자 이메일 중복확인 */
    public boolean Email_Overlap_Check(String is_student_email) {
		String student_email = Student_information_DAO.Email_Overlap_Check(is_student_email);
		if( student_email == null) {
			//중복아님
			return false;
		}else {
			return true;
		}
    }
	
    /* 사용자 이메일 인증코드 발급 */
    public boolean Create_Student_Email_Authentication_Code(String email, String authentication_code) {
    	boolean result = Student_information_DAO.Create_Student_Email_Authentication_Code(email, authentication_code);
    	return result;
    }
    
    /* 사용자 이메일 인증코드 검증 */
    public boolean Student_Email_Authentication_Code_Check(String email, String authentication_code) {
    	boolean result = Student_information_DAO.Student_Email_Authentication_Code_Check(email, authentication_code);
    	return result;
    }
    
    /* 사용자 이메일 인증코드 삭제 */
    public void Delete_Student_Email_Authentication_Code(String email) {
    	Student_information_DAO.Delete_Student_Email_Authentication_Code(email);
    }
    
    /* 회원가입 */
    public boolean Create_Student_Information(String student_id, String student_name, String student_password, String student_email, String student_push_agreement, String student_create_date, String student_phone, String device_token) {
    	return Student_information_DAO.Create_Student_Information(student_id, student_name, student_password, student_email, student_push_agreement, student_create_date, student_phone, device_token);
    }
    /* 회원가입 (SNS로그인) */
    public boolean Create_Student_snsInformation(String student_id, String student_password, String student_email, String student_push_agreement, String student_create_date, String student_phone, String student_token, String student_login_type) {
    	return Student_information_DAO.Create_Student_SNSInformation(student_id, student_password, student_email, student_push_agreement, student_create_date, student_phone, student_token, student_login_type);
    }
  
    /* 아이디찾기 */
    public String Student_Find_Id(String student_name, String student_phone) {
    	return Student_information_DAO.Student_Find_Id(student_name, student_phone);
    }
    
    public String Student_Find_Email(String student_id) {
    	return Student_information_DAO.Student_Find_Email(student_id);
    }
    
    public boolean Student_Find_Pw(String student_id, String student_name, String student_phone) {
    	return Student_information_DAO.Student_Find_Pw(student_id, student_name, student_phone);
    }
    
    /* 비밀번호 찾기 ( 존재하는 계정인지 확인 ) */
    public boolean Student_Find_Pw_withEmail(String student_id, String student_name, String student_email) {
    	return Student_information_DAO.Student_Find_Pw_withEmail(student_id, student_name, student_email);
    }
    
    /* 비밀번호 변경 */
    public boolean Student_Change_Pw(String student_email, String student_password) {
    	return Student_information_DAO.Student_Change_Pw(student_email, student_password);
    }
    
    
    
    /* 사용자 PUSH 상태 변경 */
    public boolean Student_Change_Push_Agreement(String student_id, String student_push_agreement) {
    	return Student_information_DAO.Student_Change_Push_Agreement(student_id, student_push_agreement);
    }
    
    /* 사용자 학급정보 변경 */
    public boolean Student_Change_Class_Information(String student_id, String student_level, String student_class, String student_number) {
    	return Student_information_DAO.Student_Change_Class_Information(student_id, student_level, student_class, student_number);
    }
    
    /* 사용자 기초정보 변경 */
    public boolean Student_Change_Default_Information(String student_id, String student_content, String student_tall, String student_weight, String student_age, String student_sex) {
    	return Student_information_DAO.Student_Change_Default_Information(student_id, student_content, student_tall, student_weight, student_age, student_sex);
    }
    
    /* 사용자 프로필이미지 변경 */
    public boolean Student_Change_Profile_Image(String student_id, String student_name, String student_image_url) {
    	return Student_information_DAO.Student_Change_Profile_Image(student_id, student_name, student_image_url);
    }
    
    /* 사용자 비밀번호 변경 */
    public boolean Student_Change_Password_By_Id(String student_id, String student_password) {
    	return Student_information_DAO.Student_Change_Password_By_Id(student_id, student_password);
    }
    
    
    /* 사용자 클래스코드목록 변경 */
    public boolean Student_Change_Class(String student_id, String student_school, String class_code) {
    	return Student_information_DAO.Student_Change_Class(student_id, student_school, class_code);
    }
    
    /* FCM 토큰 업데이트 */
    public void Update_Student_Token(String student_id, String student_token) {
    	Student_information_DAO.Update_Student_Token(student_id, student_token);
    }
    
    /* 전체 공지사항 가져오기 */
    public List<Push_List_VO> Get_Push_List(){
    	return Student_information_DAO.Get_Push_List();
    }
    
    /* 개별 공지사항 가져오기 */
    public List<Notice_List_VO> Get_Notice_List(String class_code){
    	return Student_information_DAO.Get_Notice_List(class_code);
    }
    
    /* 메시지함 가져오기 */
    public List<Common_Message_VO> Get_Common_Message(String student_id){
    	return Student_information_DAO.Get_Common_Message(student_id);
    }
    
    /* 새소식 상태변경 */
    public boolean Update_Student_News_State(String student_id) {
    	return Student_information_DAO.Update_Student_News_State(student_id);
    }
}
