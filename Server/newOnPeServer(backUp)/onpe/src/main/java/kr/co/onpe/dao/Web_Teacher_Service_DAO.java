package kr.co.onpe.dao;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import kr.co.onpe.vo.Admin_Notice_VO;
import kr.co.onpe.vo.Admin_Qna_VO;
import kr.co.onpe.vo.FAQ_VO;

@Repository
public class Web_Teacher_Service_DAO {
	
	@Inject
	 private SqlSessionTemplate sqlSession;
	    
	// 매퍼 식별 값
	private String namespace = "kr.co.mappers.TeacherServiceMapper";
	
	/* 하나의 공지사항 정보 가져오기 */
    public Admin_Notice_VO Get_Admin_Notice_One(String admin_notice_number) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("admin_notice_number", admin_notice_number);
    	
    	return sqlSession.selectOne(namespace + ".Get_Admin_Notice_One", data);
    }
    
    /* 공지사항 목록 개수 가져오기 */
    public String Get_Admin_Notice_List_Count(String keyword, String option) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("keyword", keyword);
    	data.put("option", option);
    	return sqlSession.selectOne(namespace + ".Get_Admin_Notice_List_Count", data);
    }
    
    /* 공지사항 목록 가져오기 */
    public List<Admin_Notice_VO> Get_Admin_Notice_List(String keyword, String option, String page) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("keyword", keyword);
    	data.put("option", option);
    	data.put("page", Integer.parseInt(page));
    	return sqlSession.selectList(namespace + ".Get_Admin_Notice_List", data);
    }
    
    /* 하나 FAQ 정보 가져오기 */
    public FAQ_VO Get_Admin_FAQ_One(String faq_number) {
    	return sqlSession.selectOne(namespace + ".Get_Admin_FAQ_One", faq_number);
    }
    
    /* FAQ 목록 개수 가져오기 */
    public String Get_Admin_FAQ_List_Count(String keyword, String option) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("keyword", keyword);
    	data.put("option", option);
    	return sqlSession.selectOne(namespace + ".Get_Admin_FAQ_List_Count", data);
    }
    
    /* FAQ 목록 가져오기 */
    public List<FAQ_VO> Get_Admin_FAQ_List(String keyword, String option, String page) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("keyword", keyword);
    	data.put("option", option);
    	data.put("page", Integer.parseInt(page));
    	return sqlSession.selectList(namespace + ".Get_Admin_FAQ_List", data);
    }
    
    
    
    /* 하나 Q&A 정보 가져오기 */
    public Admin_Qna_VO Get_Admin_Qna_One(String question_number, String teacher_id) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("question_number", question_number);
    	data.put("teacher_id", teacher_id);
    	return sqlSession.selectOne(namespace + ".Get_Admin_Qna_One", data);
    }
    
    /* Q&A 목록 개수 가져오기 */
    public String Get_Admin_Qna_List_Count(String answer, String teacher_id) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("answer", answer);
    	data.put("teacher_id", teacher_id);
    	return sqlSession.selectOne(namespace + ".Get_Admin_Qna_List_Count", data);
    }
    
    /* Q&A 목록 가져오기 */
    public List<Admin_Qna_VO> Get_Admin_Qna_List(String answer, String teacher_id, String page) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("answer", answer);
    	data.put("teacher_id", teacher_id);
    	data.put("page", Integer.parseInt(page));
    	return sqlSession.selectList(namespace + ".Get_Admin_Qna_List", data);
    }
    
    /* Q&A 생성 */
    public boolean Create_Admin_Qna(String question_date, String question_id, String question_name, String question_belong, 
    		String question_phonenumber, String question_title, String question_type, String question_content, String question_image_content) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("question_date", question_date);
    	data.put("question_id", question_id);
    	data.put("question_name", question_name);
    	data.put("question_belong", question_belong);
    	data.put("question_phonenumber", question_phonenumber);
    	data.put("question_title", question_title);
    	data.put("question_type", question_type);
    	data.put("question_content", question_content);
    	data.put("question_image_content", question_image_content);
    	
    	if(sqlSession.insert(namespace + ".Create_Admin_Qna", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* Q&A 수정 */
    public boolean Update_Admin_Qna(String question_image_content, String question_number, String teacher_id, String question_title, String question_content) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("question_number", question_number);
    	data.put("teacher_id", teacher_id);
    	data.put("question_title", question_title);
    	data.put("question_image_content", question_image_content);
    	data.put("question_content", question_content);
    	
    	if(sqlSession.update(namespace + ".Update_Admin_Qna", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* Q&A 삭제 */
    public boolean Delete_Admin_Qna(String question_number, String teacher_id) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("question_number", question_number);
    	data.put("teacher_id", teacher_id);
    	if(sqlSession.delete(namespace + ".Delete_Admin_Qna", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
}
