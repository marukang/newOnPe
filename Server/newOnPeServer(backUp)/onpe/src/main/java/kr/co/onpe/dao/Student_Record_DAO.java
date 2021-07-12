package kr.co.onpe.dao;

import java.util.HashMap;

import javax.inject.Inject;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import kr.co.onpe.vo.Class_Record_VO;

/* 사용자 기록관련(수업 시차) */

@Repository
public class Student_Record_DAO {

	 @Inject
	 private SqlSessionTemplate sqlSession;
	    
	// 매퍼 식별 값
	private String namespace = "kr.co.mappers.StudentClassRecordMapper";
	
	
	/* ############################################################ Method #################################################################### */

	/* 수업 현황 조회 */
    public Class_Record_VO Get_Student_Class_Record(String student_id, String unit_code, String class_code) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("unit_code", unit_code);
    	data.put("class_code", class_code);
    	
    	return sqlSession.selectOne(namespace + ".Get_Student_Class_Record", data);
    }
    
    /* 수업 현황 최초 insert */
    public boolean Create_Stundet_Class_Record(String unit_code, String class_code, String student_id, String student_name, String student_grade, String student_group, String student_number, String student_participation, String student_practice) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("unit_code", unit_code);
    	data.put("class_code", class_code);
    	data.put("student_id", student_id);
    	data.put("student_name", student_name);
    	data.put("student_grade", student_grade);
    	data.put("student_group", student_group);
    	data.put("student_number", student_number);
    	data.put("student_participation", student_participation);
    	data.put("student_practice", student_practice);
    	
    	if(sqlSession.insert(namespace + ".Create_Stundet_Class_Record", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
	/* 학생 수업 실습 기록하기 */
    public boolean Update_Student_Class_Record_Class_Practice(String student_id, String unit_code, String class_code, String class_practice) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("unit_code", unit_code);
    	data.put("class_code", class_code);
    	data.put("class_practice", class_practice);
    	
    	if(sqlSession.update(namespace + ".Update_Student_Class_Record_Class_Practice", data) == 1) {
    		return true;
    	}
    	
    	return false;
    }
    
    /* 학생 최근 운동시간 업데이트 */
    public boolean Update_Student_Recent_Exercise_Date(String student_id, String student_recent_exercise_date) {
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("student_recent_exercise_date", student_recent_exercise_date);
    	
    	if(sqlSession.update(namespace + ".Update_Student_Recent_Exercise_Date", data) == 1) {
    		return true;
    	}
    	return false;
    }
    
    /* 학생 과제 실습 기록하기 */
    public boolean Update_Student_Class_Record_Task_Practice(String student_id, String unit_code, String class_code, String task_practice) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("unit_code", unit_code);
    	data.put("class_code", class_code);
    	data.put("task_practice", task_practice);
    	
    	if(sqlSession.update(namespace + ".Update_Student_Class_Record_Task_Practice", data) == 1) {
    		return true;
    	}
    	
    	return false;
    }
    
    /* 학생 평가 실습 기록하기 */
    public boolean Update_Student_Class_Record_Evaluation_Practice(String student_id, String unit_code, String class_code, String evaluation_practice) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("unit_code", unit_code);
    	data.put("class_code", class_code);
    	data.put("evaluation_practice", evaluation_practice);
    	
    	if(sqlSession.update(namespace + ".Update_Student_Class_Record_Evaluation_Practice", data) == 1) {
    		return true;
    	}
    	
    	return false;
    }
    
    /* 학생 본인확인 이미지 올리기 */
    public boolean Update_Student_Class_Record_Image_Confirmation(String student_id, String unit_code, String class_code, String image_confirmation) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
    	data.put("student_id", student_id);
    	data.put("unit_code", unit_code);
    	data.put("class_code", class_code);
    	data.put("image_confirmation", image_confirmation);
    	
    	if(sqlSession.update(namespace + ".Update_Student_Class_Record_Image_Confirmation", data) == 1) {
    		return true;
    	}
    	
    	return false;
    }
    
    /* 학생 과제 제출방법 가져오기 */
    public String Get_Class_Project_Submit_Type(String class_code) {
    	return sqlSession.selectOne(namespace + ".Get_Class_Project_Submit_Type", class_code);
    }
    
    /* 학생 운동시간 기록 */
    public boolean Update_Curriculum_Use_Time(String class_code, String unit_code, String content_use_time, String unit_group_name) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
    	data.put("unit_code", unit_code);
    	data.put("content_use_time", Integer.parseInt(content_use_time));
    	if(unit_group_name != null) {
    		data.put("unit_group_name", unit_group_name);	
    	}
    	if(sqlSession.update(namespace + ".Update_Curriculum_Use_Time", data) == 1) {
    		return true;
    	}
    	return false;
    }
	
}
