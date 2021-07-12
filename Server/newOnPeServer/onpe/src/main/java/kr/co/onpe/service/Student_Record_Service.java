package kr.co.onpe.service;

import java.util.HashMap;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.co.onpe.dao.Student_Record_DAO;
import kr.co.onpe.vo.Class_Record_VO;

@Service
public class Student_Record_Service {
	
	@Inject
    private Student_Record_DAO student_Record_DAO;
	
	
	/* ############################################################ Method #################################################################### */
	
	/* 수업 현황 조회 */
    public Class_Record_VO Get_Student_Class_Record(String student_id, String unit_code, String class_code) {
    	return student_Record_DAO.Get_Student_Class_Record(student_id, unit_code, class_code);
    }
    
    /* 수업 현황 최초 insert */
    public boolean Create_Stundet_Class_Record(String unit_code, String class_code, String student_id, String student_name, String student_grade, String student_group, String student_number, String student_participation, String student_practice) {
    	return student_Record_DAO.Create_Stundet_Class_Record(unit_code, class_code, student_id, student_name, student_grade, student_group, student_number, student_participation, student_practice);
    }
    
	/* 학생 수업 실습 기록하기 */
    public boolean Update_Student_Class_Record_Class_Practice(String student_id, String unit_code, String class_code, String class_practice) {
    	return student_Record_DAO.Update_Student_Class_Record_Class_Practice(student_id, unit_code, class_code, class_practice);
    }
    
    /* 학생 최근 운동시간 업데이트 */
    public boolean Update_Student_Recent_Exercise_Date(String student_id, String student_recent_exercise_date) {
    	return student_Record_DAO.Update_Student_Recent_Exercise_Date(student_id, student_recent_exercise_date);
    }
    
    /* 학생 과제 실습 기록하기 */
    public boolean Update_Student_Class_Record_Task_Practice(String student_id, String unit_code, String class_code, String task_practice) {
    	return student_Record_DAO.Update_Student_Class_Record_Task_Practice(student_id, unit_code, class_code, task_practice);
    }
    
    /* 학생 평가 실습 기록하기 */
    public boolean Update_Student_Class_Record_Evaluation_Practice(String student_id, String unit_code, String class_code, String evaluation_practice) {
    	return student_Record_DAO.Update_Student_Class_Record_Evaluation_Practice(student_id, unit_code, class_code, evaluation_practice);
    }
    
    /* 학생 본인확인 이미지 올리기 */
    public boolean Update_Student_Class_Record_Image_Confirmation(String student_id, String unit_code, String class_code, String image_confirmation) {
    	return student_Record_DAO.Update_Student_Class_Record_Image_Confirmation(student_id, unit_code, class_code, image_confirmation);
    }
    
    /* 학생 과제 제출방법 가져오기 */
    public String Get_Class_Project_Submit_Type(String class_code) {
    	return student_Record_DAO.Get_Class_Project_Submit_Type(class_code);
    }
    
    /* 학생 운동시간 기록 */
    public boolean Update_Curriculum_Use_Time(String class_code, String unit_code, String content_use_time, String unit_group_name) {
    	return student_Record_DAO.Update_Curriculum_Use_Time(class_code, unit_code, content_use_time, unit_group_name);
    }
    
}
