package kr.co.onpe.service;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.co.onpe.dao.Student_Curriculum_DAO;
import kr.co.onpe.vo.Curriculum_Unit_List_Class_VO;

/* 사용자 커리큘럼 관련 서비스 */

@Service
public class Student_Curriculum_Service {
	
	@Inject
    private Student_Curriculum_DAO student_Curriculum_DAO;
	
	
	/* ############################################################ Method #################################################################### */
	
	/* 차시(단원)별 클래스 수업 입장하기 == 만약 수업타입이 1:(맞춤형 수업)일 때는 그룹이므로 여러개의 레코드가 반환된다. , 만약 수업타입이 0:(전체형 수업)일 때는 그룹이 아니므로 하나의 레코드가 반환된다. */
    public List<Curriculum_Unit_List_Class_VO> Get_Student_Curriculum(String class_code, String unit_code) {
    	return student_Curriculum_DAO.Get_Student_Curriculum(class_code, unit_code);
    }
    
    
    /* 수업참여 확인하기 (학생번호를 해당 차시별 수업<curriculum_unit_list_class>의 content_participation 컬럼의 JSON 배열에 추가한다.) */
    public boolean Update_Student_Curriculum_Participation(String unit_class_type, String content_participation, String class_code, String unit_code, String unit_group_name) {
    	return student_Curriculum_DAO.Update_Student_Curriculum_Participation(unit_class_type, content_participation, class_code, unit_code, unit_group_name);
    }
    
    /* 최종 과제 제출하기 (학생번호를 해당 차시별 수업<curriculum_unit_list_class>의 content_submit_task 컬럼의 JSON 배열에 추가한다.) */
    public boolean Update_Student_Curriculum_Submit_Task(String unit_class_type, String content_submit_task, String class_code, String unit_code, String unit_group_name, String student_id) {
    	return student_Curriculum_DAO.Update_Student_Curriculum_Submit_Task(unit_class_type, content_submit_task, class_code, unit_code, unit_group_name, student_id);
    }
    
    /* 맞춤형 수업일 경우 해당 차시의 현재 참여중인 사용자 번호를 불러온다. */
    public String Get_Student_Curriculum_Participation(String unit_group_name, String unit_code, String class_code, String unit_class_type) {
    	return student_Curriculum_DAO.Get_Student_Curriculum_Participation(unit_group_name, unit_code, class_code, unit_class_type);
    }
    
    /* 맞춤형 수업일 경우 해당 차시의 현재 과제를 제출한 사용자 번호를 불러온다. */
    public String Get_Student_Curriculum_Submit_Task(String unit_group_name, String unit_code, String class_code, String unit_class_type) {
    	return student_Curriculum_DAO.Get_Student_Curriculum_Submit_Task(unit_group_name, unit_code, class_code, unit_class_type);
    }
}
