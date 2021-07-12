package kr.co.onpe.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import kr.co.onpe.vo.Admin_Notice_VO;
import kr.co.onpe.vo.Curriculum_Unit_List_Class_VO;
import kr.co.onpe.vo.Popup_List_VO;
import kr.co.onpe.vo.Student_Message_VO;

@Repository
public class Web_Teacher_Index_DAO {

	@Inject
	 private SqlSessionTemplate sqlSession;
	    
	// 매퍼 식별 값
	private String namespace = "kr.co.mappers.TeacherDefaultMapper";
	
    /* 공지사항 목록 개수 가져오기 */
    public String Get_Admin_Notice_Count(String keyword) {
    	
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("keyword", keyword);
    	return sqlSession.selectOne(namespace + ".Get_Admin_Notice_Count", data);
    }
    
    /* 공지사항 목록 가져오기 */
    public List<Admin_Notice_VO> Get_Admin_Notice_List(String keyword, String page) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("keyword", keyword);
    	data.put("page", Integer.parseInt(page));
    	
    	return sqlSession.selectList(namespace + ".Get_Admin_Notice_List", data);
    }
    
    /* 팝업 목록 가져오기 */
    public List<Popup_List_VO> Get_Popup_List(String today) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("today", Integer.parseInt(today));
    	
    	return sqlSession.selectList(namespace + ".Get_Popup_List", data);
    }
    
    /* 답변안한 메세지 목록 존재 확인 */
    public boolean Get_Student_Message_List_None_Reply(List<String> message_class_code) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("message_class_code", message_class_code);
    	List<Student_Message_VO> mg = sqlSession.selectList(namespace + ".Get_Student_Message_List_None_Reply", data); 
    	if(mg != null && mg.size() > 0) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 메세지 목록 개수 가져오기 */
    public String Get_Student_Message_Count(List<String> message_class_code, String keyword) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("keyword", keyword);
    	data.put("message_class_code", message_class_code);
    	return sqlSession.selectOne(namespace + ".Get_Student_Message_Count", data);
    }
    
    /* 메세지 목록 가져오기 */
    public List<Student_Message_VO> Get_Student_Message_List(List<String> message_class_code, String page, String keyword) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("message_class_code", message_class_code);
    	data.put("keyword", keyword);
    	data.put("page", Integer.parseInt(page));
    	return sqlSession.selectList(namespace + ".Get_Student_Message_List", data);
    }
    
    /*메세지 삭제하기*/
    public boolean Delete_Student_Message(List<String> message_number) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("message_number", message_number);
    	
    	if(sqlSession.delete(namespace + ".Delete_Student_Message", data) != 0) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 메세지 답신하기 */
    public boolean Update_Student_Message(String message_comment, String message_teacher_name, String message_teacher_id, String message_comment_date, String message_number) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("message_comment", message_comment);
    	data.put("message_teacher_name", message_teacher_name);
    	data.put("message_teacher_id", message_teacher_id);
    	data.put("message_comment_date", message_comment_date);
    	data.put("message_number", message_number);
    	
    	if(sqlSession.delete(namespace + ".Update_Student_Message", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 메인 오늘의수업 개수 */
    public String Get_Today_Curriculum_Unit_List_Class_Count(List<String> class_code, String today) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
    	data.put("today", Long.parseLong(today));
    	return sqlSession.selectOne(namespace + ".Get_Today_Curriculum_Unit_List_Class_Count", data);
    }
    
    /* 메인 오늘의수업 */
    public List<Curriculum_Unit_List_Class_VO> Get_Today_Curriculum_Unit_List_Class(List<String> class_code, String today, String page) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
    	data.put("today", Long.parseLong(today));
    	data.put("page", Integer.parseInt(page));
    	return sqlSession.selectList(namespace + ".Get_Today_Curriculum_Unit_List_Class", data);
    }
    
    /* 학생정보 불러오기 */
    public List<Map<String, String>> Get_Student_Information(List<String> class_code, String student_level, String student_class){
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
    	data.put("student_level", student_level);
    	data.put("student_class", student_class);
    	
    	return sqlSession.selectList(namespace+".Get_Student_Information", data);
    }
    
    /* 메세지 전송 */
    public boolean Send_Common_Message(String teacher_id, String teacher_name, String message_content, String target_id, String message_date) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("teacher_id", teacher_id);
    	data.put("teacher_name", teacher_name);
    	data.put("message_content", message_content);
    	data.put("target_id", target_id);
    	data.put("message_date", message_date);
    	if(sqlSession.delete(namespace + ".Send_Common_Message", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 학생 새소식 업데이트 */
    public void Update_Student_News_State(String target_id) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("target_id", target_id);
    	sqlSession.delete(namespace + ".Update_Student_News_State", data);
    }
}
