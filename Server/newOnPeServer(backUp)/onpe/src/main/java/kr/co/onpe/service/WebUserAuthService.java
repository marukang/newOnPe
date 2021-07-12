package kr.co.onpe.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import kr.co.onpe.dao.WebUserAuthDAO;
import kr.co.onpe.vo.Teacher_Information_VO;

public class WebUserAuthService implements UserDetailsService{

	@Autowired
    private WebUserAuthDAO userAuthDAO;
	
	@Override
	public Teacher_Information_VO loadUserByUsername(String teacher_id) throws UsernameNotFoundException {
        Teacher_Information_VO user = userAuthDAO.getUserById(teacher_id);
        if(user==null) {
            throw new UsernameNotFoundException(teacher_id);
        }
        return user;
	}
	
    /* 아이디 찾기 */
    public String Teacher_Find_Id(String teacher_name, String teacher_email) {
    	return userAuthDAO.Teacher_Find_Id(teacher_name, teacher_email);
    }
    
    /* 비밀번호 찾기( 존재하는 아이디인지 확인 ) */
    public boolean Teacher_Find_Id_For_Pw(String teacher_id, String teacher_email) {
    	return userAuthDAO.Teacher_Find_Id_For_Pw(teacher_id, teacher_email);
    }
    
    /* 비밀번호 변경 */
    public boolean Teacher_Change_Pw(String teacher_id, String teacher_password) {
    	return userAuthDAO.Teacher_Change_Pw(teacher_id, teacher_password);
    }
    
    /* 아이디 중복검사 */
    public boolean Teacher_Id_Overlap(String teacher_id) {
    	return userAuthDAO.Teacher_Id_Overlap(teacher_id);
    }
    
    /* 이메일 중복검사 */
    public boolean Teacher_Email_Overlap(String teacher_email) {
    	return userAuthDAO.Teacher_Email_Overlap(teacher_email);
    }
    
    /* 핸드폰번호 중복검사 */
    public boolean Teacher_Phone_Overlap(String teacher_phone) {
    	return userAuthDAO.Teacher_Phone_Overlap(teacher_phone);
    }
    
    /* 회원가입 */
    public boolean Teacher_Sign_Up(String teacher_id, String teacher_name, String teacher_password, String teacher_email, 
    		String teacher_phone, String teacher_birth, String teacher_sex, String teacher_school, String teacher_join_date, String teacher_email_agreement, String teacher_message_agreement) {
    	return userAuthDAO.Teacher_Sign_Up(teacher_id, teacher_name, teacher_password, teacher_email, teacher_phone, teacher_birth, teacher_sex, teacher_school, teacher_join_date, teacher_email_agreement, teacher_message_agreement);
    }
    
    /* 접속일 업데이트 */
    public void Teacher_Update_Jodin_Date(String teacher_recent_join_date, String teacher_id) {
    	userAuthDAO.Teacher_Update_Jodin_Date(teacher_recent_join_date, teacher_id);
    }
    
    /* 회원정보 변경 전 비밀번호 확인 */
    public boolean Teacher_Password_Check(String teacher_id, String teacher_password) {
    	return userAuthDAO.Teacher_Password_Check(teacher_id, teacher_password);
    }
    
    /* 회원정보 변경 */
    public boolean Teacher_Modify_Information(String teacher_id, String change_password, String teacher_password, String teacher_email, String teacher_phone, String teacher_email_agreement, String teacher_message_agreement) {
    	return userAuthDAO.Teacher_Modify_Information(teacher_id, change_password, teacher_password, teacher_email, teacher_phone, teacher_email_agreement, teacher_message_agreement);
    }
    
    /* 학교정보 변경 */
    public boolean Teacher_School_Change(String teacher_id, String school_name) {
    	return userAuthDAO.Teacher_School_Change(teacher_id, school_name);
    }
    
    /* 학교명 불러오기 */
    public List<String> Get_School_List(String school_name){
    	return userAuthDAO.Get_School_List(school_name);
    }
	
    /* 보유 클래스코드 불러오기 */
    public List<String> Get_Classcode_List(String teacher_id){
    	return userAuthDAO.Get_Classcode_List(teacher_id);
    }
}
