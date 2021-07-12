package kr.co.onpe.service;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.co.onpe.dao.Web_Admin_Management_DAO;
import kr.co.onpe.vo.Admin_Notice_VO;
import kr.co.onpe.vo.Admin_Qna_VO;
import kr.co.onpe.vo.Exercise_Category_VO;
import kr.co.onpe.vo.FAQ_VO;
import kr.co.onpe.vo.Popup_List_VO;
import kr.co.onpe.vo.Push_List_VO;
import kr.co.onpe.vo.Student_Information_VO;
import kr.co.onpe.vo.Teacher_Information_Management_VO;

@Service
public class Web_Admin_Management_Service {
    
	@Inject
    private Web_Admin_Management_DAO web_Admin_Management_DAO;
	
    /* 선생 수 불러오기 */
    public String Get_Teachers_Count(String keyword, String option) {
    	return web_Admin_Management_DAO.Get_Teachers_Count(keyword, option);
    }
    
    /* 학생 수 불러오기 */
    public String Get_Students_Count(String keyword, String option) {
    	return web_Admin_Management_DAO.Get_Students_Count(keyword, option);
    }
    
    /* 선생 목록 불러오기 */
    public List<Teacher_Information_Management_VO> Get_Teachers_List(String keyword, String option, String page){
    	return web_Admin_Management_DAO.Get_Teachers_List(keyword, option, page);
    }
    
    /* 학생 목록 불러오기 */
    public List<Student_Information_VO> Get_Students_List(String keyword, String option, String page){
    	return web_Admin_Management_DAO.Get_Students_List(keyword, option, page);
    }
    
    /* 선생 한명 정보 불러오기 */
    public Teacher_Information_Management_VO Get_Teacher_Information(String teacher_id) {
    	return web_Admin_Management_DAO.Get_Teacher_Information(teacher_id);
    }
    
    /* 학생 한명 정보 불러오기 */
    public Student_Information_VO Get_Student_Information(String student_id) {
    	return web_Admin_Management_DAO.Get_Student_Information(student_id);
    }
    
    /* 선생 탈퇴시킬 때 */
    public boolean Teacher_Delete_Information(String teacher_id) {
    	return web_Admin_Management_DAO.Teacher_Delete_Information(teacher_id);
    }
    
    /* 학생 탈퇴시킬 때 */
    public boolean Student_Delete_Information(String student_id) {
    	return web_Admin_Management_DAO.Student_Delete_Information(student_id);
    }
    
    /* 선생 이메일 중복 검증 */
    public String Get_Teacher_Email_For_Modify(String teacher_email) {
    	return web_Admin_Management_DAO.Get_Teacher_Email_For_Modify(teacher_email);
    }
    
    /* 학생 이메일 중복 검증 */
    public String Get_Student_Email_For_Modify(String student_email) {
    	return web_Admin_Management_DAO.Get_Student_Email_For_Modify(student_email);
    }
    
    /* 선생 폰번호 중복 검증 */
    public String Get_Teacher_Phone_For_Modify(String teacher_phone) {
    	return web_Admin_Management_DAO.Get_Teacher_Phone_For_Modify(teacher_phone);
    }
    
    /* 선생 회원정보 변경할 때 */
    public boolean Teacher_Modify_Information(String teacher_id, String teacher_password, String teacher_name, String teacher_birth, String teacher_sex, String teacher_school, 
    		String teacher_email, String teacher_phone, String teacher_email_agreement, String teacher_message_agreement) {
    	return web_Admin_Management_DAO.Teacher_Modify_Information(teacher_id, teacher_password, teacher_name, teacher_birth, teacher_sex, teacher_school, teacher_email, teacher_phone, teacher_email_agreement, teacher_message_agreement);
    }
    
    /* 학생 회원정보 변경할 때 */
    public boolean Student_Modify_Information(String student_password, String student_age, String student_email, String student_email_agreement, String student_id, 
    		String student_name, String student_phone, String student_push_agreement, String student_school, String student_sex) {
    	return web_Admin_Management_DAO.Student_Modify_Information(student_password, student_age, student_email, student_email_agreement, student_id, student_name, student_phone, student_push_agreement, student_school, student_sex);
    }
    
    /* 학생 회원 등록하기 */
    public boolean Student_Insert_Information(String student_id, String student_name, String student_password, String student_email, String student_phone, 
    		String student_age, String student_sex, String student_school, String student_email_agreement, String student_push_agreement, String student_create_date) {
    	return web_Admin_Management_DAO.Student_Insert_Information(student_id, student_name, student_password, student_email, student_phone, student_age, student_sex, student_school, student_email_agreement, student_push_agreement, student_create_date);
    }
    
    /* 조회된 종목 개수 가져오기 */
    public String Get_Exercise_Count(String exercise_name, String exercise_category, String exercise_area, String keyword) {
    	return web_Admin_Management_DAO.Get_Exercise_Count(exercise_name, exercise_category, exercise_area, keyword);
    }
    
    /* 종목 리스트 조회 */    
    public List<Exercise_Category_VO> Get_Exercise_List(String exercise_name, String exercise_category, String exercise_area, String keyword, String page) {
    	return web_Admin_Management_DAO.Get_Exercise_List(exercise_name, exercise_category, exercise_area, keyword, page);
    }
    
    /* 종목 조회 */    
    public Exercise_Category_VO Get_Exercise(String exercise_code) {
    	return web_Admin_Management_DAO.Get_Exercise(exercise_code); 
    }
    
    /* 종목 수정 or 추가 */
    public boolean Modify_or_Create_Exercise(String mode, String exercise_code, String exercise_name, String exercise_category, String exercise_type, String exercise_area, String exercise_detail_name, String exercise_count, String exercise_time, String exercise_url, String exercise_level) {
    	return web_Admin_Management_DAO.Modify_or_Create_Exercise(mode, exercise_code, exercise_name, exercise_category, exercise_type, exercise_area, exercise_detail_name, exercise_count, exercise_time, exercise_url, exercise_level);
    }
    
    
    
    /* 조회된 팝업 개수 가져오기 */
    public String Get_Popup_Count(String popup_use, String keyword) {
    	return web_Admin_Management_DAO.Get_Popup_Count(popup_use, keyword);
    }
    
    /* 조회된 팝업 목록 가져오기 */
    public List<Popup_List_VO> Get_Popup_List(String popup_use, String keyword, String page) {
    	return web_Admin_Management_DAO.Get_Popup_List(popup_use, keyword, page);
    }
    
    /* 조회된 팝업 하나 가져오기 */
    public Popup_List_VO Get_Popup(String popup_number) {
    	return web_Admin_Management_DAO.Get_Popup(popup_number);
    }
    
    /* 팝업 수정 or 등록 */
    public boolean Modify_or_Create_Popup(String popup_name, String popup_content, String popup_x_size, String popup_y_size, String popup_x_location, String popup_y_location, String popup_start_date, String popup_end_date, String popup_create_date, String popup_attachments, String popup_use, String popup_number, String mode) {
    	return web_Admin_Management_DAO.Modify_or_Create_Popup(popup_name, popup_content, popup_x_size, popup_y_size, popup_x_location, popup_y_location, popup_start_date, popup_end_date, popup_create_date, popup_attachments, popup_use, popup_number, mode);
    }
    
    
    
    /* 조회된 팝업 개수 가져오기 */
    public String Get_Push_Count(String option, String keyword) {
    	return web_Admin_Management_DAO.Get_Push_Count(option, keyword);
    }
    
    /* 조회된 팝업 목록 가져오기 */
    public List<Push_List_VO> Get_Push_List(String option, String keyword, String page) {
    	return web_Admin_Management_DAO.Get_Push_List(option, keyword, page);
    }
    
    /* 조회된 팝업 하나 가져오기 */
    public Push_List_VO Get_Push(String push_number) {
    	return web_Admin_Management_DAO.Get_Push(push_number);
    }
    
    /* 팝업 수정 or 등록 */
    public boolean Modify_or_Create_Push(String push_title, String push_content, String push_reservation_time, String push_create_date, String push_state, String push_number, String mode) {
    	return web_Admin_Management_DAO.Modify_or_Create_Push(push_title, push_content, push_reservation_time, push_create_date, push_state, push_number, mode);
    }
    
    /* 푸시 삭제하기 */
    public boolean Delete_Push(String push_number) {
    	return web_Admin_Management_DAO.Delete_Push(push_number);
    }
    
    /* 학생 토큰가져오기 */
    public List<String> Get_Student_Token(){
    	return web_Admin_Management_DAO.Get_Student_Token();
    }
    
    /* 하나 공지사항 정보 가져오기 */
    public Admin_Notice_VO Get_Admin_Notice_One(String admin_notice_number) {
    	return web_Admin_Management_DAO.Get_Admin_Notice_One(admin_notice_number);
    }
    
    /* 공지사항 등록하기 */
    public boolean Create_Admin_Notice(String admin_notice_title, String admin_notice_content, String admin_notice_date) {
    	return web_Admin_Management_DAO.Create_Admin_Notice(admin_notice_title, admin_notice_content, admin_notice_date);
    }
    
    /* 공지사항 수정하기 */
    public boolean Update_Admin_Notice(String admin_notice_title, String admin_notice_content, String admin_notice_number) {
    	return web_Admin_Management_DAO.Update_Admin_Notice(admin_notice_title, admin_notice_content, admin_notice_number);
    }
    
    /* 공지사항 목록 개수 가져오기 */
    public String Get_Admin_Notice_List_Count(String keyword, String option) {
    	return web_Admin_Management_DAO.Get_Admin_Notice_List_Count(keyword, option);
    }
    
    /* 공지사항 목록 가져오기 */
    public List<Admin_Notice_VO> Get_Admin_Notice_List(String keyword, String option, String page) {
    	return web_Admin_Management_DAO.Get_Admin_Notice_List(keyword, option, page);
    }
    
    
    
    /* 하나 FAQ 정보 가져오기 */
    public FAQ_VO Get_Admin_FAQ_One(String faq_number) {
    	return web_Admin_Management_DAO.Get_Admin_FAQ_One(faq_number);
    }
    
    /* FAQ 등록하기 */
    public boolean Create_Admin_FAQ(String faq_title, String faq_content, String faq_date, String faq_type) {
    	return web_Admin_Management_DAO.Create_Admin_FAQ(faq_title, faq_content, faq_date, faq_type);
    }
    
    /* FAQ 수정하기 */
    public boolean Update_Admin_FAQ(String faq_title, String faq_content, String faq_number, String faq_type) {
    	return web_Admin_Management_DAO.Update_Admin_FAQ(faq_title, faq_content, faq_number, faq_type);
    }
    
    /* FAQ 목록 개수 가져오기 */
    public String Get_Admin_FAQ_List_Count(String keyword, String option) {
    	return web_Admin_Management_DAO.Get_Admin_FAQ_List_Count(keyword, option);
    }
    
    /* FAQ 목록 가져오기 */
    public List<FAQ_VO> Get_Admin_FAQ_List(String keyword, String option, String page) {
    	return web_Admin_Management_DAO.Get_Admin_FAQ_List(keyword, option, page);
    }
    
    
    
    
    
    /* 하나 Q&A 정보 가져오기 */
    public Admin_Qna_VO Get_Admin_Qna_One(String question_number) {
    	return web_Admin_Management_DAO.Get_Admin_Qna_One(question_number);
    }
    
    /* Q&A 답변하기 */
    public boolean Answer_Admin_Qna(String question_comment, String question_comment_date, String question_number) {
    	return web_Admin_Management_DAO.Answer_Admin_Qna(question_comment, question_comment_date, question_number);
    }
    
    /* Q&A 목록 개수 가져오기 */
    public String Get_Admin_Qna_List_Count(String keyword, String option, String answer) {
    	return web_Admin_Management_DAO.Get_Admin_Qna_List_Count(keyword, option, answer);
    }
    
    /* Q&A 목록 가져오기 */
    public List<Admin_Qna_VO> Get_Admin_Qna_List(String keyword, String option, String answer, String page) {
    	return web_Admin_Management_DAO.Get_Admin_Qna_List(keyword, option, answer, page);
    }
    
}
