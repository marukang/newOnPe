package kr.co.onpe.dao;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import kr.co.onpe.vo.Admin_Notice_VO;
import kr.co.onpe.vo.Admin_Qna_VO;
import kr.co.onpe.vo.Exercise_Category_VO;
import kr.co.onpe.vo.FAQ_VO;
import kr.co.onpe.vo.Popup_List_VO;
import kr.co.onpe.vo.Push_List_VO;
import kr.co.onpe.vo.Student_Information_VO;
import kr.co.onpe.vo.Teacher_Information_Management_VO;

@Repository
public class Web_Admin_Management_DAO {

	@Inject
	 private SqlSessionTemplate sqlSession;
	    
	// 매퍼 식별 값
	private String namespace = "kr.co.mappers.AdminMapper";
	
    /* 선생 수 불러오기 */
    public String Get_Teachers_Count(String keyword, String option) {
    	
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("keyword", keyword);
    	data.put("option", option);
    	
    	return sqlSession.selectOne(namespace + ".Get_Teachers_Count", data);
    }
    
    /* 학생 수 불러오기 */
    public String Get_Students_Count(String keyword, String option) {
    	
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("keyword", keyword);
    	data.put("option", option);
    	
    	return sqlSession.selectOne(namespace + ".Get_Students_Count", data);
    }
    
    /* 선생 목록 불러오기 */
    public List<Teacher_Information_Management_VO> Get_Teachers_List(String keyword, String option, String page){
    	
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("keyword", keyword);
    	data.put("option", option);
    	data.put("page", Integer.parseInt(page));
    	
    	return sqlSession.selectList(namespace + ".Get_Teachers_List", data);
    }
    
    /* 학생 목록 불러오기 */
    public List<Student_Information_VO> Get_Students_List(String keyword, String option, String page){
    	
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("keyword", keyword);
    	data.put("option", option);
    	data.put("page", Integer.parseInt(page));
    	
    	return sqlSession.selectList(namespace + ".Get_Students_List", data);
    }
    
    /* 선생 한명 정보 불러오기 */
    public Teacher_Information_Management_VO Get_Teacher_Information(String teacher_id) {
    	return sqlSession.selectOne(namespace + ".Get_Teacher_Information", teacher_id);
    }
    
    /* 학생 한명 정보 불러오기 */
    public Student_Information_VO Get_Student_Information(String student_id) {
    	return sqlSession.selectOne(namespace + ".Get_Student_Information", student_id);
    }
    
    /* 선생 탈퇴시킬 때 */
    public boolean Teacher_Delete_Information(String teacher_id) {
    	if(sqlSession.update(namespace + ".Teacher_Delete_Information", teacher_id) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 학생 탈퇴시킬 때 */
    public boolean Student_Delete_Information(String student_id) {
    	if(sqlSession.update(namespace + ".Student_Delete_Information", student_id) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 선생 이메일 중복 검증 */
    public String Get_Teacher_Email_For_Modify(String teacher_email) {
    	return sqlSession.selectOne(namespace + ".Get_Teacher_Email_For_Modify", teacher_email);
    }
    
    /* 학생 이메일 중복 검증 */
    public String Get_Student_Email_For_Modify(String student_email) {
    	return sqlSession.selectOne(namespace + ".Get_Student_Email_For_Modify", student_email);
    }
    
    /* 선생 폰번호 중복 검증 */
    public String Get_Teacher_Phone_For_Modify(String teacher_phone) {
    	return sqlSession.selectOne(namespace + ".Get_Teacher_Phone_For_Modify", teacher_phone);
    }
    
    /* 선생 회원정보 변경할 때 */
    public boolean Teacher_Modify_Information(String teacher_id, String teacher_password, String teacher_name, String teacher_birth, String teacher_sex, String teacher_school, 
    		String teacher_email, String teacher_phone, String teacher_email_agreement, String teacher_message_agreement) {
    	
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("teacher_id", teacher_id);
    	if(teacher_password != null) {
    		data.put("teacher_password", teacher_password);	
    	}
    	data.put("teacher_name", teacher_name);
    	data.put("teacher_birth", teacher_birth);
    	data.put("teacher_sex", teacher_sex);
    	data.put("teacher_school", teacher_school);
    	data.put("teacher_email", teacher_email);
    	data.put("teacher_phone", teacher_phone);
    	data.put("teacher_email_agreement", teacher_email_agreement);
    	data.put("teacher_message_agreement", teacher_message_agreement);
    	
    	if(sqlSession.update(namespace + ".Teacher_Modify_Information", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 학생 회원정보 변경할 때 */
    public boolean Student_Modify_Information(String student_password, String student_age, String student_email, String student_email_agreement, String student_id, 
    		String student_name, String student_phone, String student_push_agreement, String student_school, String student_sex) {
    	
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	if(student_password != null) {
    		data.put("student_password", student_password);	
    	}
    	data.put("student_age", student_age);
    	data.put("student_email", student_email);
    	data.put("student_email_agreement", student_email_agreement);
    	data.put("student_id", student_id);
    	data.put("student_name", student_name);
    	data.put("student_phone", student_phone);
    	data.put("student_push_agreement", student_push_agreement);
    	data.put("student_school", student_school);
    	data.put("student_sex", student_sex);
    	
    	if(sqlSession.update(namespace + ".Student_Modify_Information", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 학생 회원 등록하기 */
    public boolean Student_Insert_Information(String student_id, String student_name, String student_password, String student_email, String student_phone, 
    		String student_age, String student_sex, String student_school, String student_email_agreement, String student_push_agreement, String student_create_date) {
    	
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("student_id", student_id);
    	data.put("student_name", student_name);
    	data.put("student_password", student_password);
    	data.put("student_email", student_email);
    	data.put("student_phone", student_phone);
    	data.put("student_age", student_age);
    	data.put("student_sex", student_sex);
    	data.put("student_school", student_school);
    	data.put("student_email_agreement", student_email_agreement);
    	data.put("student_push_agreement", student_push_agreement);
    	data.put("student_create_date", student_create_date);
    	if(sqlSession.insert(namespace + ".Student_Insert_Information", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 조회된 종목 개수 가져오기 */
    public String Get_Exercise_Count(String exercise_name, String exercise_category, String exercise_area, String keyword) {
    	
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	if(exercise_name != null) {
    		data.put("exercise_name", exercise_name);
    	}
    	if(exercise_category != null) {
    		data.put("exercise_category", exercise_category);
    	}
    	if(exercise_area != null) {
    		data.put("exercise_area", exercise_area);
    	}
    	if(keyword != null) {
    		data.put("keyword", keyword);
    	}
    	return sqlSession.selectOne(namespace + ".Get_Exercise_Count", data);
    }
    
    /* 종목 리스트 조회 */    
    public List<Exercise_Category_VO> Get_Exercise_List(String exercise_name, String exercise_category, String exercise_area, String keyword, String page) {
    	
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	if(exercise_name != null) {
    		data.put("exercise_name", exercise_name);
    	}
    	if(exercise_category != null) {
    		data.put("exercise_category", exercise_category);
    	}
    	if(exercise_area != null) {
    		data.put("exercise_area", exercise_area);
    	}
    	if(keyword != null) {
    		data.put("keyword", keyword);
    	}
    	data.put("page", Integer.parseInt(page));
    	
    	return sqlSession.selectList(namespace + ".Get_Exercise_List", data); 
    }
    
    /* 종목 조회 */    
    public Exercise_Category_VO Get_Exercise(String exercise_code) {
    	return sqlSession.selectOne(namespace + ".Get_Exercise", exercise_code); 
    }
    
    /* 종목 수정 or 추가 */
    public boolean Modify_or_Create_Exercise(String mode, String exercise_code, String exercise_name, String exercise_category, String exercise_type, String exercise_area, String exercise_detail_name, String exercise_count, String exercise_time, String exercise_url, String exercise_level) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	if(mode.equals("modify")) {
    		data.put("exercise_code", exercise_code);    		
    	}
    	data.put("exercise_name", exercise_name);
    	data.put("exercise_category", exercise_category);
    	data.put("exercise_type", exercise_type);
    	data.put("exercise_area", exercise_area);
    	data.put("exercise_detail_name", exercise_detail_name);
    	data.put("exercise_count", exercise_count);
    	data.put("exercise_time", exercise_time);
    	data.put("exercise_url", exercise_url);
    	data.put("exercise_level", exercise_level);
    	
    	if(mode.equals("modify")) {
    		
    		if(sqlSession.update(namespace + ".Modify_Exercise", data) == 1) {
        		return true;
        	}else {
        		return false;
        	}
    		
    	}else if(mode.equals("create")) {
    		
    		if(sqlSession.insert(namespace + ".Create_Exercise", data) == 1) {
        		return true;
        	}else {
        		return false;
        	}
    		
    	}else {
    		return false;
    	}
    	
    }
    
    
    
    
    
    /* 조회된 팝업 개수 가져오기 */
    public String Get_Popup_Count(String popup_use, String keyword) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("popup_use", popup_use);
    	data.put("keyword", keyword);
    	return sqlSession.selectOne(namespace + ".Get_Popup_Count", data);
    }
    
    /* 조회된 팝업 목록 가져오기 */
    public List<Popup_List_VO> Get_Popup_List(String popup_use, String keyword, String page) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("popup_use", popup_use);
    	data.put("keyword", keyword);
    	data.put("page", Integer.parseInt(page));
    	return sqlSession.selectList(namespace + ".Get_Popup_List", data);
    }
    
    /* 조회된 팝업 하나 가져오기 */
    public Popup_List_VO Get_Popup(String popup_number) {
    	return sqlSession.selectOne(namespace + ".Get_Popup", popup_number);
    }
    
    /* 팝업 수정 or 등록 */
    public boolean Modify_or_Create_Popup(String popup_name, String popup_content, String popup_x_size, String popup_y_size, String popup_x_location, String popup_y_location, String popup_start_date, String popup_end_date, String popup_create_date, String popup_attachments, String popup_use, String popup_number, String mode) {
    	
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("popup_name", popup_name);
    	data.put("popup_content", popup_content);
    	data.put("popup_x_size", popup_x_size);
    	data.put("popup_y_size", popup_y_size);
    	data.put("popup_x_location", popup_x_location);
    	data.put("popup_y_location", popup_y_location);
    	data.put("popup_start_date", popup_start_date);
    	data.put("popup_end_date", popup_end_date);
    	if(popup_attachments != null) {
    		data.put("popup_attachments", popup_attachments);	
    	}
    	data.put("popup_use", popup_use);
    	
    	if(mode.equals("modify")) {
    		data.put("popup_number", popup_number);
    		if(sqlSession.update(namespace + ".Modify_Popup", data) == 1) {
        		return true;
        	}else {
        		return false;
        	}
    		
    	}else if(mode.equals("create")) {
    		data.put("popup_create_date", popup_create_date);
    		if(sqlSession.insert(namespace + ".Create_Popup", data) == 1) {
        		return true;
        	}else {
        		return false;
        	}
    		
    	}else {
    		return false;
    	}
    }
    
    
    
    
    
    
    
    /* 조회된 푸시 개수 가져오기 */
    public String Get_Push_Count(String option, String keyword) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	if(option != null) {
    		if(option.equals("제목")) {
        		data.put("option", "push_title");	
        	}else if(option.equals("내용")) {
        		data.put("option", "push_content");
        	}	
    	}
    	if(keyword != null) {
    		data.put("keyword", keyword);	
    	}
    	return sqlSession.selectOne(namespace + ".Get_Push_Count", data);
    }
    
    /* 조회된 푸시 목록 가져오기 */
    public List<Push_List_VO> Get_Push_List(String option, String keyword, String page) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	if(option != null) {
    		if(option.equals("제목")) {
        		data.put("option", "push_title");	
        	}else if(option.equals("내용")) {
        		data.put("option", "push_content");
        	}
    	}
    	if(keyword != null) {
    		data.put("keyword", keyword);	
    	}
    	data.put("page", Integer.parseInt(page));
    	return sqlSession.selectList(namespace + ".Get_Push_List", data);
    }
    
    /* 조회된 푸시 하나 가져오기 */
    public Push_List_VO Get_Push(String push_number) {
    	return sqlSession.selectOne(namespace + ".Get_Push", push_number);
    }
    
    /* 푸시 수정 or 등록 */
    public boolean Modify_or_Create_Push(String push_title, String push_content, String push_reservation_time, String push_create_date, String push_state, String push_number, String mode) {
    	
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	
    	data.put("push_title", push_title);
    	data.put("push_content", push_content);
    	data.put("push_reservation_time", push_reservation_time);
    	
    	if(mode.equals("modify")) {
    		data.put("push_number", push_number);
    		if(sqlSession.update(namespace + ".Modify_Push", data) == 1) {
        		return true;
        	}else {
        		return false;
        	}
    		
    	}else if(mode.equals("create")) {
    		data.put("push_create_date", push_create_date);
    		data.put("push_state", push_state);
    		if(sqlSession.insert(namespace + ".Create_Push", data) == 1) {
    			sqlSession.insert(namespace + ".Update_Student_News_State");
        		return true;
        	}else {
        		return false;
        	}
    		
    	}else {
    		return false;
    	}
    }
    
    /* 푸시 삭제하기 */
    public boolean Delete_Push(String push_number) {
    	if(sqlSession.update(namespace + ".Delete_Push", push_number) == 1) {
    		return true;
    	}
    	return false;
    }
    
    /* 학생 토큰가져오기 */
    public List<String> Get_Student_Token(){
    	return sqlSession.selectList(namespace + ".Get_Student_Token");
    }
    
    
    
    /* 하나 공지사항 정보 가져오기 */
    public Admin_Notice_VO Get_Admin_Notice_One(String admin_notice_number) {
    	return sqlSession.selectOne(namespace + ".Get_Admin_Notice_One", admin_notice_number);
    }
    
    /* 공지사항 등록하기 */
    public boolean Create_Admin_Notice(String admin_notice_title, String admin_notice_content, String admin_notice_date) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("admin_notice_title", admin_notice_title);
    	data.put("admin_notice_content", admin_notice_content);
    	data.put("admin_notice_date", admin_notice_date);
    	if(sqlSession.insert(namespace + ".Create_Admin_Notice", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 공지사항 수정하기 */
    public boolean Update_Admin_Notice(String admin_notice_title, String admin_notice_content, String admin_notice_number) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("admin_notice_title", admin_notice_title);
    	data.put("admin_notice_content", admin_notice_content);
    	data.put("admin_notice_number", admin_notice_number);
    	if(sqlSession.update(namespace + ".Update_Admin_Notice", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
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
    
    /* FAQ 등록하기 */
    public boolean Create_Admin_FAQ(String faq_title, String faq_content, String faq_date, String faq_type) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("faq_title", faq_title);
    	data.put("faq_content", faq_content);
    	data.put("faq_date", faq_date);
    	data.put("faq_type", faq_type);
    	if(sqlSession.insert(namespace + ".Create_Admin_FAQ", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* FAQ 수정하기 */
    public boolean Update_Admin_FAQ(String faq_title, String faq_content, String faq_number, String faq_type) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("faq_title", faq_title);
    	data.put("faq_content", faq_content);
    	data.put("faq_number", faq_number);
    	data.put("faq_type", faq_type);
    	if(sqlSession.update(namespace + ".Update_Admin_FAQ", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
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
    public Admin_Qna_VO Get_Admin_Qna_One(String question_number) {
    	return sqlSession.selectOne(namespace + ".Get_Admin_Qna_One", question_number);
    }
    
    /* Q&A 답변하기 */
    public boolean Answer_Admin_Qna(String question_comment, String question_comment_date, String question_number) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("question_comment", question_comment);
    	data.put("question_comment_date", question_comment_date);
    	data.put("question_number", question_number);
    	if(sqlSession.update(namespace + ".Answer_Admin_Qna", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* Q&A 목록 개수 가져오기 */
    public String Get_Admin_Qna_List_Count(String keyword, String option, String answer) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("keyword", keyword);
    	data.put("option", option);
    	data.put("answer", answer);
    	return sqlSession.selectOne(namespace + ".Get_Admin_Qna_List_Count", data);
    }
    
    /* Q&A 목록 가져오기 */
    public List<Admin_Qna_VO> Get_Admin_Qna_List(String keyword, String option, String answer, String page) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("keyword", keyword);
    	data.put("option", option);
    	data.put("answer", answer);
    	data.put("page", Integer.parseInt(page));
    	return sqlSession.selectList(namespace + ".Get_Admin_Qna_List", data);
    }
    
}
