package kr.co.onpe.service;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.co.onpe.dao.Student_Information_DAO;
import kr.co.onpe.dao.Web_Teacher_Ready_DAO;
import kr.co.onpe.dao.Web_Teacher_Service_DAO;
import kr.co.onpe.vo.Admin_Notice_VO;
import kr.co.onpe.vo.Admin_Qna_VO;
import kr.co.onpe.vo.Auto_Curriculum_List_VO;
import kr.co.onpe.vo.Class_List_VO;
import kr.co.onpe.vo.Content_List_VO;
import kr.co.onpe.vo.Curriculum_Unit_List_Class_VO;
import kr.co.onpe.vo.Exercise_Category_VO;
import kr.co.onpe.vo.FAQ_VO;

@Service
public class Web_Teacher_Service_Service {
    
	@Inject
    private Web_Teacher_Service_DAO web_Teacher_DAO;
	
	/* 하나의 공지사항 정보 가져오기 */
    public Admin_Notice_VO Get_Admin_Notice_One(String admin_notice_number) {
    	return web_Teacher_DAO.Get_Admin_Notice_One(admin_notice_number);
    }
    
    /* 공지사항 목록 개수 가져오기 */
    public String Get_Admin_Notice_List_Count(String keyword, String option) {
    	return web_Teacher_DAO.Get_Admin_Notice_List_Count(keyword, option);
    }
    
    /* 공지사항 목록 가져오기 */
    public List<Admin_Notice_VO> Get_Admin_Notice_List(String keyword, String option, String page) {
    	return web_Teacher_DAO.Get_Admin_Notice_List(keyword, option, page);
    }
    
    /* 하나 FAQ 정보 가져오기 */
    public FAQ_VO Get_Admin_FAQ_One(String faq_number) {
    	return web_Teacher_DAO.Get_Admin_FAQ_One(faq_number);
    }
    
    /* FAQ 목록 개수 가져오기 */
    public String Get_Admin_FAQ_List_Count(String keyword, String option) {
    	return web_Teacher_DAO.Get_Admin_FAQ_List_Count(keyword, option);
    }
    
    /* FAQ 목록 가져오기 */
    public List<FAQ_VO> Get_Admin_FAQ_List(String keyword, String option, String page) {
    	return web_Teacher_DAO.Get_Admin_FAQ_List(keyword, option, page);
    }
    
    
    /* 하나 Q&A 정보 가져오기 */
    public Admin_Qna_VO Get_Admin_Qna_One(String question_number, String teacher_id) {
    	return web_Teacher_DAO.Get_Admin_Qna_One(question_number, teacher_id);
    }
    
    /* Q&A 목록 개수 가져오기 */
    public String Get_Admin_Qna_List_Count(String answer, String teacher_id) {
    	return web_Teacher_DAO.Get_Admin_Qna_List_Count(answer, teacher_id);
    }
    
    /* Q&A 목록 가져오기 */
    public List<Admin_Qna_VO> Get_Admin_Qna_List(String answer, String teacher_id, String page) {
    	return web_Teacher_DAO.Get_Admin_Qna_List(answer, teacher_id, page);
    }
    
    /* Q&A 생성 */
    public boolean Create_Admin_Qna(String question_date, String question_id, String question_name, String question_belong, 
    		String question_phonenumber, String question_title, String question_type, String question_content, String question_image_content) {
    	return web_Teacher_DAO.Create_Admin_Qna(question_date, question_id, question_name, question_belong, question_phonenumber, question_title, question_type, question_content, question_image_content);
    }
    
    /* Q&A 수정 */
    public boolean Update_Admin_Qna(String question_image_content, String question_number, String teacher_id, String question_title, String question_content) {
    	return web_Teacher_DAO.Update_Admin_Qna(question_image_content, question_number, teacher_id, question_title, question_content);
    }
    
    /* Q&A 삭제 */
    public boolean Delete_Admin_Qna(String question_number, String teacher_id) {
    	return web_Teacher_DAO.Delete_Admin_Qna(question_number, teacher_id);
    }
    
}
