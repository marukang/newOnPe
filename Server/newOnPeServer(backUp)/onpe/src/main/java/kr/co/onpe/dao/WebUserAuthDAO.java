package kr.co.onpe.dao;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.onpe.vo.Teacher_Information_VO;

@Repository("userAuthDAO")
public class WebUserAuthDAO {
    
    @Autowired
    private SqlSessionTemplate sqlSession;
 
	// 매퍼
	private String namespace = "kr.co.mappers.TeacherInformationMapper";
    
    public Teacher_Information_VO getUserById(String teacher_id) {
    	Teacher_Information_VO user = sqlSession.selectOne(namespace + ".Get_Teacher_information", teacher_id);
    	if(user == null) {
    		System.out.println("조회된 사용자가 없습니다.");
    	}
        return user;
    }
    
    /* 아이디 찾기 */
    public String Teacher_Find_Id(String teacher_name, String teacher_email) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("teacher_name", teacher_name);
    	data.put("teacher_email", teacher_email);
    	
    	return sqlSession.selectOne(namespace + ".Teacher_Find_Id", data);
    }
    
    /* 비밀번호 찾기( 존재하는 아이디인지 확인 ) */
    public boolean Teacher_Find_Id_For_Pw(String teacher_id, String teacher_email) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("teacher_id", teacher_id);
    	data.put("teacher_email", teacher_email);
    	
    	if(sqlSession.selectOne(namespace + ".Teacher_Find_Id_For_Pw", data) != null) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 비밀번호 변경 */
    public boolean Teacher_Change_Pw(String teacher_id, String teacher_password) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("teacher_id", teacher_id);
    	data.put("teacher_password", teacher_password);
    	
    	if(sqlSession.update(namespace + ".Teacher_Change_Pw", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 아이디 중복검사 */
    public boolean Teacher_Id_Overlap(String teacher_id) {
    	if(sqlSession.selectOne(namespace + ".Teacher_Id_Overlap", teacher_id) != null) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 이메일 중복검사 */
    public boolean Teacher_Email_Overlap(String teacher_email) {
    	if(sqlSession.selectOne(namespace + ".Teacher_Email_Overlap", teacher_email) != null) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 핸드폰번호 중복검사 */
    public boolean Teacher_Phone_Overlap(String teacher_phone) {
    	if(sqlSession.selectOne(namespace + ".Teacher_Phone_Overlap", teacher_phone) != null) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 회원가입 */
    public boolean Teacher_Sign_Up(String teacher_id, String teacher_name, String teacher_password, String teacher_email, 
    		String teacher_phone, String teacher_birth, String teacher_sex, String teacher_school, String teacher_join_date, String teacher_email_agreement, String teacher_message_agreement) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("teacher_id", teacher_id);
    	data.put("teacher_name", teacher_name);
    	data.put("teacher_password", teacher_password);
    	data.put("teacher_email", teacher_email);
    	data.put("teacher_phone", teacher_phone);
    	data.put("teacher_birth", teacher_birth);
    	data.put("teacher_sex", teacher_sex);
    	data.put("teacher_school", teacher_school);
    	data.put("teacher_join_date", teacher_join_date);
    	data.put("teacher_message_agreement", teacher_message_agreement);
    	data.put("teacher_email_agreement", teacher_email_agreement);
    	
    	if(sqlSession.insert(namespace + ".Teacher_Sign_Up", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 접속일 업데이트 */
    public void Teacher_Update_Jodin_Date(String teacher_recent_join_date, String teacher_id) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("teacher_recent_join_date", teacher_recent_join_date);
    	data.put("teacher_id", teacher_id);
    	
    	sqlSession.update(namespace + ".Teacher_Update_Jodin_Date", data);
    	
    }
    
    /* 회원정보 변경 전 비밀번호 확인 */
    public boolean Teacher_Password_Check(String teacher_id, String teacher_password) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("teacher_id", teacher_id);
    	data.put("teacher_password", teacher_password);
    	
    	if(sqlSession.selectOne(namespace + ".Teacher_Password_Check", data) != null) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 회원정보 변경 */
    public boolean Teacher_Modify_Information(String teacher_id, String change_password, String teacher_password, String teacher_email, String teacher_phone, String teacher_email_agreement, String teacher_message_agreement) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("teacher_id", teacher_id);
    	data.put("change_password", change_password);
    	data.put("teacher_email", teacher_email);
		data.put("teacher_phone", teacher_phone);
		data.put("teacher_email_agreement", teacher_email_agreement);
		data.put("teacher_message_agreement", teacher_message_agreement);
    	if(change_password.equals("y")) {
    		data.put("teacher_password", teacher_password);
    	}
    	
    	if(sqlSession.update(namespace + ".Teacher_Modify_Information", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 학교명 불러오기 */
    public List<String> Get_School_List(String keyword){
    	return sqlSession.selectList(namespace + ".Get_School_List", keyword);
    }
    
    /* 보유 클래스코드 불러오기 */
    public List<String> Get_Classcode_List(String teacher_id){
    	return sqlSession.selectList(namespace + ".Get_Classcode_List", teacher_id);
    }
    
    /* 학교정보 변경 */
    public boolean Teacher_School_Change(String teacher_id, String school_name) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("teacher_id", teacher_id);
    	data.put("teacher_school", school_name);
    	if(sqlSession.update(namespace + ".Teacher_School_Change", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    
    
    
    
    
}
