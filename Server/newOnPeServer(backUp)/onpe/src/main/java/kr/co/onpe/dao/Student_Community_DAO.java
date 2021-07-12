package kr.co.onpe.dao;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import kr.co.onpe.vo.Class_Community_Comment_VO;
import kr.co.onpe.vo.Class_Community_List_VO;
import kr.co.onpe.vo.Class_Community_VO;
import kr.co.onpe.vo.Content_List_Admin_VO;
import kr.co.onpe.vo.FAQ_VO;
import kr.co.onpe.vo.Notice_List_VO;
import kr.co.onpe.vo.Student_Message_List_VO;
import kr.co.onpe.vo.Student_Message_VO;

/* 사용자 메세지, qna, 커뮤니티 테이블 관련 DAO */

@Repository
public class Student_Community_DAO {

	 @Inject
	 private SqlSessionTemplate sqlSession;
	    
	// 매퍼 식별 값
	private String namespace = "kr.co.mappers.StudentCommunityMapper";
	
	
	/* ############################################################ Method #################################################################### */
	
    /* 앱사용자 메세지 전송 */
    public boolean Send_Student_Message(String message_class_code, String message_title, String message_text, String message_date, String message_id, String message_name) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("message_class_code", message_class_code);
    	data.put("message_title", message_title);
    	data.put("message_text", message_text);
    	data.put("message_date", message_date);
    	data.put("message_id", message_id);
    	data.put("message_name", message_name);
    	
    	if(sqlSession.insert(namespace + ".Send_Student_Message", data) == 1) {
    		return true;
    	}
    	
    	return false;
    }
    
    /* 앱사용자 메세지 목록 가져오기 */
    public List<Student_Message_List_VO> Get_Student_Message_List(String message_id, String message_class_code){
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("message_id", message_id);
    	data.put("message_class_code", message_class_code);
    	
    	return sqlSession.selectList(namespace + ".Get_Student_Message_List", data);
    	
    }
    
    /* 앱사용자 메세지 가져오기 */
    public Student_Message_VO Get_Student_Message(String message_id, String message_number){
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("message_id", message_id);
    	data.put("message_number", message_number);
    	
    	return sqlSession.selectOne(namespace + ".Get_Student_Message", data);
    	
    }
    
    /* 앱사용자 메세지 수정 */
    public boolean Update_Student_Message(String message_id, String message_number, String message_title, String message_text) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("message_id", message_id);
    	data.put("message_number", message_number);
    	data.put("message_title", message_title);
    	data.put("message_text", message_text);
    	
    	if(sqlSession.update(namespace + ".Update_Student_Message", data) == 1) {
    		return true;
    	}
    	return false;
    }
    
    /* 앱사용자 메세지 삭제 */
    public boolean Delete_Student_Message(String message_id, String message_number) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("message_id", message_id);
    	data.put("message_number", message_number);
    	
    	if(sqlSession.update(namespace + ".Delete_Student_Message", data) == 1) {
    		return true;
    	}
    	return false;
    }
    
    /* 앱사용자 FAQ 목록 가져오기 */
    public List<FAQ_VO> Get_FAQ(){
    	return sqlSession.selectList(namespace + ".Get_FAQ");
    }
    
    /* 앱사용자 콘텐츠관 목록 가져오기 */
    public List<Content_List_Admin_VO> Get_Content_List_Admin(){
    	return sqlSession.selectList(namespace + ".Get_Content_List_Admin");
    }
    
    
    
    
    
    
    
    
    
    
    
    /* 소식 목록 가져오기 */
    public List<Notice_List_VO> Get_Notice_List(String notice_class_code){
    	return sqlSession.selectList(namespace + ".Get_Notice_List", notice_class_code);
    }
    
    /* 학급 커뮤니티 리스트 가져오기 */
    public List<Class_Community_List_VO> Get_Class_Community_List(String community_class_code){
    	return sqlSession.selectList(namespace + ".Get_Class_Community_List", community_class_code);
    }
    
    /* 학급 커뮤니티 작성 */
    public boolean Create_Class_Community(String community_class_code, String community_id, String community_name, String community_title, String community_text, String community_date, String community_file1, String community_file2){
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("community_class_code", community_class_code);
    	data.put("community_id", community_id);
    	data.put("community_name", community_name);
    	data.put("community_title", community_title);
    	data.put("community_text", community_text);
    	data.put("community_date", community_date);
    	data.put("community_file1", community_file1);
    	data.put("community_file2", community_file2);
    	
    	if(sqlSession.insert(namespace + ".Create_Class_Community", data) == 1) {
    		return true;
    	}
    	
    	return false;
    }
    
    
    /* 학급 커뮤니티 삭제(id + community_number) */
    public boolean Delete_Class_Community(String community_number, String community_id) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("community_number", community_number);
    	data.put("community_id", community_id);
    	
    	if(sqlSession.delete(namespace + ".Delete_Class_Community", data) == 1) {
    		sqlSession.delete(namespace + ".Delete_Class_Community_Comment_By_Community", community_number);
    		return true;
    	}
    	
    	return false;
    }
    
    /* 학급 커뮤니티 수정(id + community_number), 댓글수 증가 or 감소 */
    public boolean Update_Class_Community(String community_number, String community_id, String community_title, String community_text, String community_file1, String community_file2) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("community_number", community_number);
    	data.put("community_id", community_id);
    	data.put("community_title", community_title);
    	data.put("community_text", community_text);
    	data.put("community_file1", community_file1);
    	data.put("community_file2", community_file2);
    	
    	if(sqlSession.update(namespace + ".Update_Class_Community", data) == 1) {
    		return true;
    	}
    	
    	return false;
    }
    
    /* 학급 커뮤니티 파일 실제소유중인지 확인 */
    public boolean Class_Community_Is_Your_File(String community_number, String community_id, String community_file) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("community_number", community_number);
    	data.put("community_id", community_id);
    	data.put("community_file", community_file);
    	
    	String result = sqlSession.selectOne(namespace + ".Class_Community_Is_Your_File", data);
    	if(result != null) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 학급 커뮤니티 댓글 리스트 가져오기 */
    public List<Class_Community_Comment_VO> Get_Class_Community_Comment(String comment_community_number){
    	return sqlSession.selectList(namespace + ".Get_Class_Community_Comment", comment_community_number);
    }
    
    /* 학급 커뮤니티 하나 가져오기 */
    public Class_Community_VO Get_Class_Community(String community_number){
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("community_number", community_number);
    	
    	return sqlSession.selectOne(namespace + ".Get_Class_Community", data);
    }
    
    /* 학급 커뮤니티 내꺼 하나 가져오기 */
    public Class_Community_VO Get_My_Class_Community(String community_number, String community_id){
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("community_number", community_number);
    	data.put("community_id", community_id);
    	
    	return sqlSession.selectOne(namespace + ".Get_My_Class_Community", data);
    }
    
    
    /* 학급 커뮤니티 댓글 작성 */
    public boolean Create_Class_Community_Comment(String comment_community_number, String comment_id, String comment_name, String comment_content, String comment_date){
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("comment_community_number", comment_community_number);
    	data.put("comment_id", comment_id);
    	data.put("comment_name", comment_name);
    	data.put("comment_content", comment_content);
    	data.put("comment_date", comment_date);
    	
    	if(sqlSession.insert(namespace + ".Create_Class_Community_Comment", data) == 1) {
    		sqlSession.update(namespace + ".Update_Class_Community_Comment_Number_Up", comment_community_number);
    		return true;
    	}
    	
    	return false;
    }
    
    /* 학급 커뮤니티 댓글 삭제(id + community_number) */
    public boolean Delete_Class_Community_Comment(String comment_number, String comment_id, String comment_community_number) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("comment_number", comment_number);
    	data.put("comment_id", comment_id);
    	
    	if(sqlSession.delete(namespace + ".Delete_Class_Community_Comment", data) == 1) {
    		sqlSession.update(namespace + ".Update_Class_Community_Comment_Number_Down", comment_community_number);
    		return true;
    	}
    	
    	return false;
    }
}
