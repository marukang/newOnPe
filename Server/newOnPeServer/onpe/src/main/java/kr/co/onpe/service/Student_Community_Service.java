package kr.co.onpe.service;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.co.onpe.dao.Student_Community_DAO;
import kr.co.onpe.vo.Class_Community_Comment_VO;
import kr.co.onpe.vo.Class_Community_List_VO;
import kr.co.onpe.vo.Class_Community_VO;
import kr.co.onpe.vo.Content_List_Admin_VO;
import kr.co.onpe.vo.FAQ_VO;
import kr.co.onpe.vo.Notice_List_VO;
import kr.co.onpe.vo.Student_Message_List_VO;
import kr.co.onpe.vo.Student_Message_VO;

@Service
public class Student_Community_Service {
	
	@Inject
    private Student_Community_DAO student_Community_DAO;
	
	
	/* ############################################################ Method #################################################################### */
	
	/* 앱사용자 메세지 전송 */
	public boolean Send_Student_Message(String message_class_code, String message_title, String message_text, String message_date, String message_id, String message_name) {
		return student_Community_DAO.Send_Student_Message(message_class_code, message_title, message_text, message_date, message_id, message_name);
    }
	
	/* 앱사용자 메세지목록 가져오기 */
    public List<Student_Message_List_VO> Get_Student_Message_List(String message_id, String message_class_code){    	
    	return student_Community_DAO.Get_Student_Message_List(message_id, message_class_code);
    }
    
    /* 앱사용자 메세지 가져오기 */
    public Student_Message_VO Get_Student_Message(String message_id, String message_number){    	
    	return student_Community_DAO.Get_Student_Message(message_id, message_number);
    }
    
    /* 앱사용자 메세지 수정 */
    public boolean Update_Student_Message(String message_id, String message_number, String message_title, String message_text) {
    	return student_Community_DAO.Update_Student_Message(message_id, message_number, message_title, message_text);
    }
    
    /* 앱사용자 메세지 삭제 */
    public boolean Delete_Student_Message(String message_id, String message_number) {
    	return student_Community_DAO.Delete_Student_Message(message_id, message_number);
    }
    
    /* 앱사용자 FAQ 목록 가져오기 */
    public List<FAQ_VO> Get_FAQ(){
    	return student_Community_DAO.Get_FAQ();
    }
    
    /* 앱사용자 콘텐츠관 목록 가져오기 */
    public List<Content_List_Admin_VO> Get_Content_List_Admin(){
    	return student_Community_DAO.Get_Content_List_Admin();
    }
    
    
    
    
    
    
    
    
    
    /* 소식 목록 가져오기 */
    public List<Notice_List_VO> Get_Notice_List(String notice_class_code){
    	return student_Community_DAO.Get_Notice_List(notice_class_code);
    }
    
    /* 학급 커뮤니티 리스트 가져오기 */
    public List<Class_Community_List_VO> Get_Class_Community_List(String community_class_code){
    	return student_Community_DAO.Get_Class_Community_List(community_class_code);
    }
    
    /* 학급 커뮤니티 하나 가져오기 */
    public Class_Community_VO Get_Class_Community(String community_number){
    	return student_Community_DAO.Get_Class_Community(community_number);
    }
    
    /* 학급 커뮤니티 내꺼 하나 가져오기 */
    public Class_Community_VO Get_My_Class_Community(String community_number, String community_id){
    	return student_Community_DAO.Get_My_Class_Community(community_number, community_id);
    }
    
    /* 학급 커뮤니티 작성 */
    public boolean Create_Class_Community(String community_class_code, String community_id, String community_name, String community_title, String community_text, String community_date, String community_file1, String community_file2){
    	return student_Community_DAO.Create_Class_Community(community_class_code, community_id, community_name, community_title, community_text, community_date, community_file1, community_file2);
    }
    
    /* 학급 커뮤니티 삭제(id + community_number) */
    public boolean Delete_Class_Community(String community_number, String community_id) {
    	return student_Community_DAO.Delete_Class_Community(community_number, community_id);
    }
    
    /* 학급 커뮤니티 수정(id + community_number), 댓글수 증가 or 감소 */
    public boolean Update_Class_Community(String community_number, String community_id, String community_title, String community_text, String community_file1, String community_file2) {
    	return student_Community_DAO.Update_Class_Community(community_number, community_id, community_title, community_text, community_file1, community_file2);
    }
    
    /* 학급 커뮤니티 파일 실제소유중인지 확인 */
    public boolean Class_Community_Is_Your_File(String community_number, String community_id, String community_file) {
    	return student_Community_DAO.Class_Community_Is_Your_File(community_number, community_id, community_file);
    }
    
    /* 학급 커뮤니티 댓글 리스트 가져오기 */
    public List<Class_Community_Comment_VO> Get_Class_Community_Comment(String comment_community_number){
    	return student_Community_DAO.Get_Class_Community_Comment(comment_community_number);
    }
    
    /* 학급 커뮤니티 댓글 작성 */
    public boolean Create_Class_Community_Comment(String comment_community_number, String comment_id, String comment_name, String comment_content, String comment_date){
    	return student_Community_DAO.Create_Class_Community_Comment(comment_community_number, comment_id, comment_name, comment_content, comment_date);
    }
    
    /* 학급 커뮤니티 댓글 삭제(id + community_number) */
    public boolean Delete_Class_Community_Comment(String comment_number, String comment_id, String comment_community_number) {
    	return student_Community_DAO.Delete_Class_Community_Comment(comment_number, comment_id, comment_community_number);
    }
    
}
