package kr.co.onpe.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.co.onpe.dao.Web_Admin_Management_DAO;
import kr.co.onpe.dao.Web_Teacher_Index_DAO;
import kr.co.onpe.vo.Admin_Notice_VO;
import kr.co.onpe.vo.Curriculum_Unit_List_Class_VO;
import kr.co.onpe.vo.Exercise_Category_VO;
import kr.co.onpe.vo.Popup_List_VO;
import kr.co.onpe.vo.Push_List_VO;
import kr.co.onpe.vo.Student_Information_VO;
import kr.co.onpe.vo.Student_Message_VO;
import kr.co.onpe.vo.Teacher_Information_Management_VO;

@Service
public class Web_Teacher_Index_Service {
    
	@Inject
    private Web_Teacher_Index_DAO web_Teacher_DAO;
	
    /* 공지사항 목록 개수 가져오기 */
    public String Get_Admin_Notice_Count(String keyword) {
    	return web_Teacher_DAO.Get_Admin_Notice_Count(keyword);
    }
    
    /* 공지사항 목록 가져오기 */
    public List<Admin_Notice_VO> Get_Admin_Notice_List(String keyword, String page) {
    	return web_Teacher_DAO.Get_Admin_Notice_List(keyword, page);
    }
    
    /* 팝업 목록 가져오기 */
    public List<Popup_List_VO> Get_Popup_List(String today) {
    	return web_Teacher_DAO.Get_Popup_List(today);
    }
    
    /* 답변안한 메세지 목록 존재 확인 */
    public boolean Get_Student_Message_List_None_Reply(List<String> message_class_code) {
    	return web_Teacher_DAO.Get_Student_Message_List_None_Reply(message_class_code);
    }
    
    /* 메세지 목록 개수 가져오기 */
    public String Get_Student_Message_Count(List<String> message_class_code, String keyword) {
    	return web_Teacher_DAO.Get_Student_Message_Count(message_class_code, keyword);
    }
    
    /* 메세지 목록 가져오기 */
    public List<Student_Message_VO> Get_Student_Message_List(List<String> message_class_code, String page, String keyword) {
    	return web_Teacher_DAO.Get_Student_Message_List(message_class_code, page, keyword);
    }
    
    /*메세지 삭제하기*/
    public boolean Delete_Student_Message(List<String> message_number) {
    	return web_Teacher_DAO.Delete_Student_Message(message_number);
    }
    
    /* 메세지 답신하기 */
    public boolean Update_Student_Message(String message_comment, String message_teacher_name, String message_teacher_id, String message_comment_date, String message_number) {
    	return web_Teacher_DAO.Update_Student_Message(message_comment, message_teacher_name, message_teacher_id, message_comment_date, message_number);
    }
    
    /* 메인 오늘의수업 개수 */
    public String Get_Today_Curriculum_Unit_List_Class_Count(List<String> class_code, String today) {
    	return web_Teacher_DAO.Get_Today_Curriculum_Unit_List_Class_Count(class_code, today);
    }
    
    /* 메인 오늘의수업 */
    public List<Curriculum_Unit_List_Class_VO> Get_Today_Curriculum_Unit_List_Class(List<String> class_code, String today, String page) {
    	return web_Teacher_DAO.Get_Today_Curriculum_Unit_List_Class(class_code, today, page);
    }
    
    /* 학생정보 불러오기 */
    public List<Map<String, String>> Get_Student_Information(List<String> class_code, String student_level, String student_class){
    	return web_Teacher_DAO.Get_Student_Information(class_code, student_level, student_class);
    }
    
    /* 메세지 전송 */
    public boolean Send_Common_Message(String teacher_id, String teacher_name, String message_content, String target_id, String message_date) {
    	return web_Teacher_DAO.Send_Common_Message(teacher_id, teacher_name, message_content, target_id, message_date);
    }
    
    /* 학생 새소식 업데이트 */
    public void Update_Student_News_State(String target_id) {
    	web_Teacher_DAO.Update_Student_News_State(target_id);
    }
}
