package kr.co.onpe.dao;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import kr.co.onpe.vo.Curriculum_Unit_List_Class_VO;

/* 사용자 커리큘럼 관련 DAO */

@Repository
public class Student_Curriculum_DAO {

	 @Inject
	 private SqlSessionTemplate sqlSession;
	    
	// 매퍼 식별 값
	private String namespace = "kr.co.mappers.StudentCurriculumMapper";
	
	
	/* ############################################################ Method #################################################################### */

	/* 차시(단원)별 클래스 수업 입장하기 == 만약 수업타입이 1:(맞춤형 수업)일 때는 그룹이므로 여러개의 레코드가 반환된다. , 만약 수업타입이 0:(전체형 수업)일 때는 그룹이 아니므로 하나의 레코드가 반환된다. */
    public List<Curriculum_Unit_List_Class_VO> Get_Student_Curriculum(String class_code, String unit_code) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
		data.put("class_code", class_code);
		data.put("unit_code", unit_code);
    	
    	return sqlSession.selectList(namespace + ".Get_Student_Curriculum", data);
    }
    
    
    /* 수업참여 확인하기 (학생번호를 해당 차시별 수업<curriculum_unit_list_class>의 content_participation 컬럼의 JSON 배열에 추가한다.) */
    public boolean Update_Student_Curriculum_Participation(String unit_class_type, String content_participation, String class_code, String unit_code, String unit_group_name) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
		data.put("unit_class_type", unit_class_type);
		data.put("content_participation", content_participation);
		data.put("class_code", class_code);
		data.put("unit_code", unit_code);
		
		if(unit_class_type.equals("1")) {
			data.put("unit_group_name", unit_group_name);	
		}
		
		if(sqlSession.update(namespace + ".Update_Student_Curriculum_Participation", data) == 1) {
			return true;
		}else {
			return false;
		}
    }
    
    /* 최종 과제 제출하기 (학생번호를 해당 차시별 수업<curriculum_unit_list_class>의 content_submit_task 컬럼의 JSON 배열에 추가한다.) */
    public boolean Update_Student_Curriculum_Submit_Task(String unit_class_type, String content_submit_task, String class_code, String unit_code, String unit_group_name, String student_id) {
    	
    	HashMap<String, String> data = new HashMap<String, String>();
		data.put("unit_class_type", unit_class_type);
		data.put("content_submit_task", content_submit_task);
		data.put("class_code", class_code);
		data.put("unit_code", unit_code);
		data.put("student_id", student_id);
		
		if(unit_class_type.equals("1")) {
			data.put("unit_group_name", unit_group_name);	
		}
		
		if(sqlSession.update(namespace + ".Update_Student_Curriculum_Submit_Task", data) == 1) {
			return true;
		}else {
			return false;
		}
    }
    
    /* 해당 차시의 현재 참여중인 사용자 번호를 불러온다. */
    public String Get_Student_Curriculum_Participation(String unit_group_name, String unit_code, String class_code, String unit_class_type) {
    	HashMap<String, String> data = new HashMap<String, String>();
		data.put("unit_code", unit_code);
		data.put("class_code", class_code);
		if(unit_class_type.equals("1")) {
			data.put("unit_group_name", unit_group_name);	
		}
		return sqlSession.selectOne(namespace + ".Get_Student_Curriculum_Participation", data);
    }
    
    /* 해당 차시의 현재 과제를 제출한 사용자 번호를 불러온다. */
    public String Get_Student_Curriculum_Submit_Task(String unit_group_name, String unit_code, String class_code, String unit_class_type) {
    	HashMap<String, String> data = new HashMap<String, String>();
		data.put("unit_code", unit_code);
		data.put("class_code", class_code);
		if(unit_class_type.equals("1")) {
			data.put("unit_group_name", unit_group_name);	
		}
		return sqlSession.selectOne(namespace + ".Get_Student_Curriculum_Submit_Task", data);
    }
}
