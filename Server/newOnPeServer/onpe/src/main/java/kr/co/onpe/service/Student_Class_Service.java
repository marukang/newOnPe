package kr.co.onpe.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.co.onpe.dao.Student_Class_DAO;
import kr.co.onpe.vo.Class_Community_Comment_VO;
import kr.co.onpe.vo.Class_Community_List_VO;
import kr.co.onpe.vo.Class_Community_VO;
import kr.co.onpe.vo.Content_List_Admin_VO;
import kr.co.onpe.vo.Content_List_VO;
import kr.co.onpe.vo.FAQ_VO;
import kr.co.onpe.vo.Notice_List_VO;
import kr.co.onpe.vo.Student_Message_List_VO;
import kr.co.onpe.vo.Student_Message_VO;

@Service
public class Student_Class_Service {
	
	@Inject
    private Student_Class_DAO student_Class_DAO;
	
	
	/* ############################################################ Method #################################################################### */
	
	/* 존재하는 클래스인지 확인 */
    public boolean Get_Class_Code(String class_code) {
    	return student_Class_DAO.Get_Class_Code(class_code);
    }
    
	/* 클래스 참여인원 늘리기 */
    public boolean Update_Class_People_Count_Up(String class_code) {
    	return student_Class_DAO.Update_Class_People_Count_Up(class_code);
    }
    
	/* 클래스 참여인원 줄이기 */
    public boolean Update_Class_People_Count_Down(String class_code) {
    	return student_Class_DAO.Update_Class_People_Count_Down(class_code);
    }
    
    /* 클래스 임장하기 */
    public String Get_Class_Unit_List(String class_code) {
    	return student_Class_DAO.Get_Class_Unit_List(class_code);
    }

    /* 컨텐츠 목록 하나 가져오기 */
    public Content_List_VO Get_Content_List(String content_code) {
    	return student_Class_DAO.Get_Content_List(content_code);
    }
    
}
