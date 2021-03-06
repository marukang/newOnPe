package kr.co.onpe.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import kr.co.onpe.vo.Common_Message_VO;
import kr.co.onpe.vo.Notice_List_VO;
import kr.co.onpe.vo.Push_List_VO;
import kr.co.onpe.vo.Student_Information_VO;

/* 사용자 정보 테이블(student_information) 테이블 관련 DAO */

@Repository
public class Student_Information_DAO {

    @Inject
    private SqlSessionTemplate sqlSession;
    
	// 매퍼 식별 값
	private String namespace = "kr.co.mappers.StudentInformationMapper";
	
	/* ############################################################ Method #################################################################### */
	
	/* 앱 사용자 로그인 ( 매개변수 id , pw(sha256) ) */
    public Student_Information_VO Student_Information_for_Login(String student_id, String student_password) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
		data.put("student_id", student_id);
		data.put("student_password", student_password);
    	
    	Student_Information_VO user = sqlSession.selectOne(namespace + ".Get_Student_information", data);

        return user;
    }
    
    /* 앱 사용자 회원탈퇴 */
	public boolean Student_Resign(String student_id) {
		HashMap<String, String> data = new HashMap<String, String>();
		data.put("student_id", student_id);
		if(sqlSession.update(namespace + ".Student_Resign", data) == 1) {
			return true;
		}else {
			return false;
		}
	}
    
    public Student_Information_VO Student_Information_for_Auto_login(String student_id) {
    	return sqlSession.selectOne(namespace + ".Get_Student_information_auto", student_id);
    }
    public Student_Information_VO Student_Information_for_Auto_login(String student_id, String loginType) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
		data.put("student_id", student_id);
		data.put("student_login_type", loginType);
    	
    	return sqlSession.selectOne(namespace + ".Get_Student_information_sns_auto", data);
    }
    
    /* 앱 사용자 아이디 중복확인 */
    public String Id_Overlap_Check(String student_id) {
    	return sqlSession.selectOne(namespace + ".Get_Student_id", student_id);
    }
    
    
    /* 앱 사용자 최근 접속일 업데이트 */
    public void Update_student_recent_join_date(String student_id, String time_number) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
		data.put("student_id", student_id);
		data.put("time_number", time_number);
		
		sqlSession.update(namespace + ".Update_student_recent_join_date", data);
    }
    
    /* 앱 사용자 이메일 중복확인 */
    public String Email_Overlap_Check(String student_email) {
    	return sqlSession.selectOne(namespace + ".Get_Student_email", student_email);
    }
    
    /* 사용자 이메일 인증코드 발급 */
    public boolean Create_Student_Email_Authentication_Code(String email, String authentication_code) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("email", email);
    	data.put("authentication_code", authentication_code);
    	sqlSession.delete(namespace + ".Delete_Student_Email_Authentication_Code", email);
    	if(sqlSession.insert(namespace + ".Create_Student_Email_Authentication_Code", data) == 1) {
    		return true;
    	}
    	return false;
    }
    
    /* 사용자 이메일 인증코드 검증 */
    public boolean Student_Email_Authentication_Code_Check(String email, String authentication_code) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("email", email);
    	data.put("authentication_code", authentication_code);
    	String email_success_str = sqlSession.selectOne(namespace + ".Student_Email_Authentication_Code_Check", data);
    	if(email_success_str != null) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 사용자 이메일 인증코드 삭제 */
    public void Delete_Student_Email_Authentication_Code(String email) {    	
    	sqlSession.delete(namespace + ".Delete_Student_Email_Authentication_Code", email);
    }
    
    /* 회원가입 */
    public boolean Create_Student_Information(String student_id, String student_name, String student_password, String student_email, String student_push_agreement, String student_create_date, String student_phone) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("student_name", student_name);
    	data.put("student_password", student_password);
    	data.put("student_email", student_email);
    	data.put("student_push_agreement", student_push_agreement);
    	data.put("student_create_date", student_create_date);
    	data.put("student_phone", student_phone);
    	System.out.println(data);
    	
    	if(sqlSession.insert(namespace + ".Create_Student_Information", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 회원가입 */
    public boolean Create_Student_SNSInformation(String student_id, String student_name, String student_password, String student_email, String student_push_agreement, String student_create_date, String student_phone, String student_token, String student_login_type) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("student_name", student_name);
    	data.put("student_password", student_password);
    	data.put("student_email", student_email);
    	data.put("student_push_agreement", student_push_agreement);
    	data.put("student_create_date", student_create_date);
    	data.put("student_phone", student_phone);
    	data.put("student_token", student_token);
    	data.put("student_login_type", student_login_type);
    	System.out.println(data);
    	
    	if(sqlSession.insert(namespace + ".Create_Student_SNS_Information", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 아이디찾기 */
    public String Student_Find_Id(String student_name, String student_email) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_name", student_name);
    	data.put("student_email", student_email);
    	return sqlSession.selectOne(namespace + ".Student_Find_Id", data);
    }
    
    /* 비밀번호 찾기 ( 존재하는 계정인지 확인 ) */
    public boolean Student_Find_Pw(String student_id, String student_name, String student_email) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("student_name", student_name);
    	data.put("student_email", student_email);
    	
    	String getEmail = sqlSession.selectOne(namespace + ".Student_Find_Pw", data);
    	
    	if(getEmail != null) {
    		return true;
    	}else {
    		return false;
    	}
    	
    }
    
    /* 비밀번호 변경 */
    public boolean Student_Change_Pw(String student_email, String student_password) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_email", student_email);
    	data.put("student_password", student_password);
    	
    	if(sqlSession.update(namespace + ".Student_Change_Pw", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 사용자 PUSH 상태 변경 */
    public boolean Student_Change_Push_Agreement(String student_id, String student_push_agreement) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("student_push_agreement", student_push_agreement);
    	
    	if(sqlSession.update(namespace + ".Student_Change_Push_Agreement", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 사용자 학급정보 변경 */
    public boolean Student_Change_Class_Information(String student_id, String student_level, String student_class, String student_number) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("student_level", student_level);
    	data.put("student_class", student_class);
    	data.put("student_number", student_number);
    	
    	if(sqlSession.update(namespace + ".Student_Change_Class_Information", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 사용자 기초정보 변경 */
    public boolean Student_Change_Default_Information(String student_id, String student_content, String student_tall, String student_weight, String student_age, String student_sex) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("student_content", student_content);
    	data.put("student_tall", student_tall);
    	data.put("student_weight", student_weight);
    	data.put("student_age", student_age);
    	data.put("student_sex", student_sex);
    	
    	if(sqlSession.update(namespace + ".Student_Change_Default_Information", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 사용자 프로필이미지 변경 */
    public boolean Student_Change_Profile_Image(String student_id, String student_image_url) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("student_image_url", student_image_url);
    	
    	if(sqlSession.update(namespace + ".Student_Change_Profile_Image", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 사용자 비밀번호 변경 */
    public boolean Student_Change_Password_By_Id(String student_id, String student_password) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("student_password", student_password);
    	
    	if(sqlSession.update(namespace + ".Student_Change_Password_By_Id", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 사용자 클래스코드목록 변경 */
    public boolean Student_Change_Class(String student_id, String student_classcode, String student_school, String class_code) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("student_classcode", student_classcode);
    	data.put("student_school", student_school);
    	data.put("class_code", class_code);
    	
    	if(sqlSession.update(namespace + ".Student_Change_Class", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    
    /* FCM 토큰 업데이트 */
    public void Update_Student_Token(String student_id, String student_token) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("student_token", student_token);
    	sqlSession.update(namespace + ".Update_Student_Token", data);
    }
    
    /* 전체 공지사항 가져오기 */
    public List<Push_List_VO> Get_Push_List(){
    	return sqlSession.selectList(namespace + ".Get_Push_List");
    }
    
    /* 개별 공지사항 가져오기 */
    public List<Notice_List_VO> Get_Notice_List(String class_code){
    	return sqlSession.selectList(namespace + ".Get_Notice_List", class_code);
    }
    
    /* 메시지함 가져오기 */
    public List<Common_Message_VO> Get_Common_Message(String student_id){
    	return sqlSession.selectList(namespace + ".Get_Common_Message", student_id);
    }
    
    /* 새소식 상태변경 */
    public boolean Update_Student_News_State(String student_id) 
    {
    	if(sqlSession.update(namespace + ".Update_Student_News_State", student_id) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    
    
    
    
    
    
    
}
