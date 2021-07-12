package kr.co.onpe.dao;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import kr.co.onpe.vo.Auto_Curriculum_List_VO;
import kr.co.onpe.vo.Class_List_VO;
import kr.co.onpe.vo.Content_List_VO;
import kr.co.onpe.vo.Curriculum_Unit_List_Class_VO;
import kr.co.onpe.vo.Exercise_Category_VO;
import kr.co.onpe.vo.Student_Information_VO;

@Repository
public class Web_Teacher_Ready_DAO {

	@Inject
	 private SqlSessionTemplate sqlSession;
	    
	// 매퍼 식별 값
	private String namespace = "kr.co.mappers.TeacherClassMapper";
	
    /*  (클래스 링크생성)보유 클래스 목록 가져오기 [아이디, 년도, 학기 를 통해 조회] */
    public List<Class_List_VO> Get_Class_List_For_Create_Link(String teacher_id, String class_year, String class_semester, String class_grade, String class_group) {
    	
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("teacher_id", teacher_id);
    	data.put("class_year", class_year);
    	data.put("class_semester", class_semester);
    	data.put("class_grade", class_grade);
    	data.put("class_group", class_group);
    	
    	return sqlSession.selectList(namespace + ".Get_Class_List_For_Create_Link", data);
    }
    
    /* (클래스 링크생성)클래스 최초 생성 */
    public boolean Create_Class_List_For_Create_Link(String teacher_id, String class_code, String class_year, String class_semester, String class_grade, String class_group, String class_people_count, String class_people_max_count) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("teacher_id", teacher_id);
    	data.put("class_code", class_code);
    	data.put("class_year", class_year);
    	data.put("class_semester", class_semester);
    	data.put("class_grade", class_grade);
    	data.put("class_group", class_group);
    	data.put("class_people_count", class_people_count);
    	data.put("class_people_max_count", class_people_max_count);
    	data.put("class_name", class_grade+"학년 "+class_group+"반 "+class_semester+"학기 수업");
    	
    	if(sqlSession.insert(namespace + ".Create_Class_List_For_Create_Link", data) == 1) {
    		return true;
    	}
    	
    	return false;
    }
    
    /* (클래스 링크생성)클래스 삭제 */
    public boolean Delete_Class_List_For_Create_Link(String class_code) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
    	
    	if(sqlSession.delete(namespace + ".Delete_Class_List_For_Create_Link", data) > 0) {
    		return true;
    	}
    	
    	return false;
    }
    
    
    /* 보유클래스 개수가져오기 */
    public String Get_Class_List_Count_For_Management(String teacher_id, String class_grade, String class_group, String class_start_date, String class_end_date, String keyword) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("teacher_id", teacher_id);
    	if(class_grade != null) {
    		data.put("class_grade", class_grade);	
    	}
    	if(class_group != null) {
    		data.put("class_group", class_group);	
    	}
    	if(class_start_date != null && class_end_date != null) {
    		data.put("class_start_date", Integer.parseInt(class_start_date));
    		data.put("class_end_date", Integer.parseInt(class_end_date));
    	}
    	if(keyword != null) {
    		data.put("keyword", keyword);	
    	}
    	
    	return sqlSession.selectOne(namespace + ".Get_Class_List_Count_For_Management", data);
    	
    }
    
    /* 클래스 하나 가져오기 */
    public Class_List_VO Get_Class_List_For_Management_Detail(String teacher_id, String class_code) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("teacher_id", teacher_id);
    	data.put("class_code", class_code);
    	return sqlSession.selectOne(namespace + ".Get_Class_List_For_Management_Detail", data);
    }
    
    
    /* 보유클래스 가져오기 */
    public List<Class_List_VO> Get_Class_List_For_Management(String teacher_id, String class_grade, String class_group, String class_start_date, String class_end_date, String keyword, String page) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("teacher_id", teacher_id);
    	if(class_grade != null) {
    		data.put("class_grade", class_grade);	
    	}
    	if(class_group != null) {
    		data.put("class_group", class_group);	
    	}
    	if(class_start_date != null && class_end_date != null) {
    		data.put("class_start_date", Integer.parseInt(class_start_date));
    		data.put("class_end_date", Integer.parseInt(class_end_date));
    	}
    	if(keyword != null) {
    		data.put("keyword", keyword);	
    	}
    	data.put("page", Integer.parseInt(page));
    	
    	return sqlSession.selectList(namespace + ".Get_Class_List_For_Management", data);
    }
    
    
    /* 클래스 수정 */
    public boolean Update_Class_List_For_Management(String teacher_id, String class_code, String class_people_max_count, String class_name, String class_start_date, String class_end_date, String class_project_submit_type, String class_unit_list) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("teacher_id", teacher_id);
    	data.put("class_code", class_code);
    	data.put("class_people_max_count", class_people_max_count);
    	data.put("class_name", class_name);
    	data.put("class_start_date", class_start_date);
    	data.put("class_end_date", class_end_date);
    	data.put("class_project_submit_type", class_project_submit_type);
    	data.put("class_unit_list", class_unit_list);
    	
    	if(sqlSession.update(namespace + ".Update_Class_List_For_Management", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /*커리큘럼 자동완성 목록 가져오기*/
    public List<Auto_Curriculum_List_VO> Get_Auto_Make_Curriculum(String class_level, String class_grade, String class_semester, String keyword_option, String keyword, String sort, String page) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_level", class_level);
    	data.put("class_grade", class_grade);
    	data.put("class_semester", class_semester);
    	data.put("keyword_option", keyword_option);
    	data.put("keyword", keyword);
    	data.put("sort", sort);
    	data.put("page", Integer.parseInt(page));
    	
    	return sqlSession.selectList(namespace + ".Get_Auto_Make_Curriculum", data);
    }
    
    /*커리큘럼 자동완성 목록 개수 가져오기*/
    public String Get_Auto_Make_Curriculum_Count(String class_level, String class_grade, String class_semester, String keyword_option, String keyword) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_level", class_level);
    	data.put("class_grade", class_grade);
    	data.put("class_semester", class_semester);
    	data.put("keyword_option", keyword_option);
    	data.put("keyword", keyword);
    	
    	return sqlSession.selectOne(namespace + ".Get_Auto_Make_Curriculum_Count", data);
    }
    
    /* 커리큘럼 자동완성 하나 가져오기 */
    public Auto_Curriculum_List_VO Get_Auto_Make_Curriculum_One(String curriculum_code) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("curriculum_code", curriculum_code);
    	return sqlSession.selectOne(namespace + ".Get_Auto_Make_Curriculum_One", data);
    }
    
    /* 차시별(단원별) 리스트 가져오기( 커리큘럼 자동완성 ) */
    public List<Curriculum_Unit_List_Class_VO> Get_Curriculum_Unit_List_Class_For_Auto_Make(List<String> unit_code){
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("unit_code", unit_code);
    	return sqlSession.selectList(namespace + ".Get_Curriculum_Unit_List_Class_For_Auto_Make", data);
    }
    
    /* 차시별(단원별) 리스트 생성( 커리큘럼 자동완성 ) */
    public boolean Create_Curriculum_Unit_List_Class_For_Auto_Make(List<Curriculum_Unit_List_Class_VO> unit_code){
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("list", unit_code);
    	int result = sqlSession.insert(namespace + ".Create_Curriculum_Unit_List_Class_For_Auto_Make", data);
    	if(result > 0) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 커리큘럼 리셋 */
    public void Reset_Curriculum_Unit_List_Class(String teacher_id, String class_code) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("teacher_id", teacher_id);
    	data.put("class_code", class_code);
    	data.put("class_unit_list", null);
    	sqlSession.delete(namespace + ".Reset_Curriculum_Unit_List_Class", data);
    }
    
    
    /* 단일 커리큘럼 리스트 불러오기 */
    public List<Curriculum_Unit_List_Class_VO> Get_Curriculum_Unit_LIst_Class(String unit_code, String class_code){
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("unit_code", unit_code);
    	data.put("class_code", class_code);
    	return sqlSession.selectList(namespace + ".Get_Curriculum_Unit_LIst_Class", data);
    }
    
    /* 커리큘럼 수정 (전체) */
    public boolean Update_Curriculum_Unit_List_Class_ALL(String unit_class_type, String unit_group_name, String unit_group_id_list, String unit_class_name, String unit_class_text, String unit_start_date, String unit_end_date, String unit_youtube_url, String unit_content_url, String unit_attached_file, String content_code_list, String content_home_work, String content_test, String content_evaluation_type, String unit_code, String class_code) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("unit_class_type", unit_class_type);
    	data.put("unit_group_name", unit_group_name);
    	data.put("unit_group_id_list", unit_group_id_list);
    	data.put("unit_class_name", unit_class_name);
    	data.put("unit_class_text", unit_class_text);
    	data.put("unit_start_date", unit_start_date);
    	data.put("unit_end_date", unit_end_date);
    	if(unit_youtube_url != null) {
    		data.put("unit_youtube_url", unit_youtube_url);	
    	}
    	if(unit_content_url != null) {
    		data.put("unit_content_url", unit_content_url);	
    	}
    	data.put("unit_attached_file", unit_attached_file);
    	data.put("content_code_list", content_code_list);
    	data.put("content_home_work", content_home_work);
    	data.put("content_test", content_test);
    	data.put("content_evaluation_type", content_evaluation_type);
    	data.put("unit_code", unit_code);
    	data.put("class_code", class_code);
    	
    	if(sqlSession.update(namespace + ".Update_Curriculum_Unit_List_Class_ALL", data) > 0) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 커리큘럼 수정(일정수정) */
    public boolean Update_Curriculum_Unit_List_Class_Date(String unit_start_date, String unit_end_date, String unit_code, String class_code) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("unit_start_date", unit_start_date);
    	data.put("unit_end_date", unit_end_date);
    	data.put("unit_code", unit_code);
    	data.put("class_code", class_code);
    	
    	if(sqlSession.update(namespace + ".Update_Curriculum_Unit_List_Class_Date", data) > 0) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 커리큘럼 생성 */
    public boolean Create_Curriculum_Unit_List_Class(String unit_code, String class_code, String unit_class_type, String unit_group_name, String unit_group_id_list, String unit_class_name, String unit_class_text, String unit_start_date, String unit_end_date, String unit_youtube_url, String unit_content_url, String unit_attached_file, String content_code_list, String content_home_work, String content_test, String content_evaluation_type) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("unit_class_type", unit_class_type);
    	data.put("unit_group_name", unit_group_name);
    	data.put("unit_group_id_list", unit_group_id_list);
    	data.put("unit_class_name", unit_class_name);
    	data.put("unit_class_text", unit_class_text);
    	data.put("unit_start_date", unit_start_date);
    	data.put("unit_end_date", unit_end_date);
    	if(unit_youtube_url != null) {
    		data.put("unit_youtube_url", unit_youtube_url);	
    	}
    	if(unit_content_url != null) {
    		data.put("unit_content_url", unit_content_url);	
    	}
    	data.put("unit_attached_file", unit_attached_file);
    	data.put("content_code_list", content_code_list);
    	data.put("content_home_work", content_home_work);
    	data.put("content_test", content_test);
    	data.put("content_evaluation_type", content_evaluation_type);
    	data.put("unit_code", unit_code);
    	data.put("class_code", class_code);
    	
    	if(sqlSession.insert(namespace + ".Create_Curriculum_Unit_List_Class", data) > 0) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 커리큘럼 삭제 */
    public boolean Delete_Curriculum_Unit_List_Class(String unit_code, String class_code) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("unit_code", unit_code);
    	data.put("class_code", class_code);
    	if(sqlSession.delete(namespace + ".Delete_Curriculum_Unit_List_Class", data) > 0) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    
    /* 커리큘럼 다중생성 */
    public boolean Create_Curriculum_Unit_List_Class_List(List<Curriculum_Unit_List_Class_VO> list) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("list", list);
    	int result = sqlSession.insert(namespace + ".Create_Curriculum_Unit_List_Class_List", data);
    	if(result > 0) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 이전 클래스 정보 가져오기(이전수업 불러오기 기능) */
    public Class_List_VO Get_Class_List_For_Auto_Create(String teacher_id){
    	return sqlSession.selectOne(namespace + ".Get_Class_List_For_Auto_Create", teacher_id);
    }
    
    /* 이전 클래스의 커리큘럼 목록 불러오기 (이전수업 불러오기 기능) */
    public List<Curriculum_Unit_List_Class_VO> Get_Curriculum_Unit_List_For_Auto_Create(String class_code){
    	return sqlSession.selectList(namespace + ".Get_Curriculum_Unit_List_For_Auto_Create", class_code);
    }
    
    /* 추천조합에 사용되는 종목명 목록 불러오기 */
    public List<String> Get_Content_List_Content_Name_List(){
    	return sqlSession.selectList(namespace + ".Get_Content_List_Content_Name_List");
    }
    
    /* 추천조합에 사용되는 대분류 목록 불러오기 */
    public List<String> Get_Content_List_Content_Category_List(){
    	return sqlSession.selectList(namespace + ".Get_Content_List_Content_Category_List");
    }
    
    /* 추천조합 목록 개수 가져오기 */
    public String Get_Content_List_Count(String content_name, String content_category, String option, String keyword, String sort){
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("content_name", content_name);
    	data.put("content_category", content_category);
    	data.put("option", option);
    	data.put("keyword", keyword);
    	data.put("sort", sort);
    	return sqlSession.selectOne(namespace + ".Get_Content_List_Count", data);
    }
    
    /* 추천조합 목록 가져오기 */
    public List<Content_List_VO> Get_Content_List(String content_name, String content_category, String option, String keyword, String sort, String page){
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("content_name", content_name);
    	data.put("content_category", content_category);
    	data.put("option", option);
    	data.put("keyword", keyword);
    	data.put("sort", sort);
    	data.put("page", Integer.parseInt(page));
    	return sqlSession.selectList(namespace + ".Get_Content_List", data);
    }
    
    /*내 컨텐츠 불러오기*/
    public Content_List_VO Get_Content_List_Mine(String content_code, String teacher_id){
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("content_code", content_code);
    	data.put("teacher_id", teacher_id);
    	return sqlSession.selectOne(namespace + ".Get_Content_List_Mine", data);
    }
    
    /* 내 컨텐츠의 운동 불러오기 */
    public Exercise_Category_VO Get_Exercise_Category_Mine(String exercise_code){
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("exercise_code", exercise_code);
    	return sqlSession.selectOne(namespace + ".Get_Exercise_Category_Mine", data);
    }
    
    
    /* 운동 Object 불러오기 */
    public List<Exercise_Category_VO> Get_Exercise_Category_One(String exercise_name, String exercise_category, String exercise_detail_name){
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("exercise_name", exercise_name);
    	data.put("exercise_category", exercise_category);
    	data.put("exercise_detail_name", exercise_detail_name);
    	return sqlSession.selectList(namespace + ".Get_Exercise_Category_One", data);
    }
    
    /* 운동 종목이름 불러오기 */
    public List<String> Get_Exercise_Category_Exercise_Name(){
    	return sqlSession.selectList(namespace + ".Get_Exercise_Category_Exercise_Name");
    }
    
    /* 운동 대분류 불러오기 */
    public List<String> Get_Exercise_Category_Exercise_Category(String exercise_name){
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("exercise_name", exercise_name);
    	return sqlSession.selectList(namespace + ".Get_Exercise_Category_Exercise_Category", data);
    }
    
    /* 운동 동작명 불러오기 */
    public List<String> Get_Exercise_Category_Exercise_Detail_Name(String exercise_name, String exercise_category){
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("exercise_name", exercise_name);
    	data.put("exercise_category", exercise_category);
    	return sqlSession.selectList(namespace + ".Get_Exercise_Category_Exercise_Detail_Name", data);
    }
    
    /* 컨텐츠 리스트 만들기 */
    public boolean Create_Content_List(String content_code, String content_value, String content_title, String content_name, String content_category, String teacher_id, 
    		String content_class_level, String content_class_grade, String content_write_date, String content_number_list, String content_name_list, String content_cateogry_list, 
    		String content_type_list, String content_area_list, String content_detail_name_list, String content_count_list, String content_time, String content_url, String content_level_list) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("content_code", content_code);
    	data.put("content_value", content_value);
    	data.put("content_title", content_title);
    	data.put("content_name", content_name);
    	data.put("content_category", content_category);
    	data.put("teacher_id", teacher_id);
    	data.put("content_class_level", content_class_level);
    	data.put("content_class_grade", content_class_grade);
    	data.put("content_write_date", content_write_date);
    	data.put("content_number_list", content_number_list);
    	data.put("content_name_list", content_name_list);
    	data.put("content_cateogry_list", content_cateogry_list);
    	data.put("content_type_list", content_type_list);
    	data.put("content_area_list", content_area_list);
    	data.put("content_detail_name_list", content_detail_name_list);
    	data.put("content_count_list", content_count_list);
    	data.put("content_time", content_time);
    	data.put("content_url", content_url);
    	data.put("content_level_list", content_level_list);
    	if(sqlSession.insert(namespace + ".Create_Content_List", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
	
	/* 컨텐츠 업데이트 */
    public boolean Update_Content_List(String content_title, String content_name, String content_category, String content_number_list, String content_name_list, 
    		String content_cateogry_list, String content_type_list, String content_area_list, String content_detail_name_list, String content_count_list, 
    		String content_time, String content_url, String content_level_list, String content_code, String teacher_id) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("content_code", content_code);
    	data.put("content_title", content_title);
    	data.put("teacher_id", teacher_id);
    	data.put("content_category", content_category);
    	data.put("content_number_list", content_number_list);
    	data.put("content_name_list", content_name_list);
    	data.put("content_cateogry_list", content_cateogry_list);
    	data.put("content_type_list", content_type_list);
    	data.put("content_area_list", content_area_list);
    	data.put("content_detail_name_list", content_detail_name_list);
    	data.put("content_count_list", content_count_list);
    	data.put("content_time", content_time);
    	data.put("content_url", content_url);
    	data.put("content_level_list", content_level_list);
    	if(sqlSession.update(namespace + ".Update_Content_List", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    
    
    
    /* 학급 구성관리(학생수 조회) */
    public String Get_Student_Information_For_Student_Management_Count(String student_level, String student_class, String option, String keyword, List<String> class_code) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("student_level", student_level);
    	data.put("student_class", student_class);
    	data.put("option", option);
    	data.put("keyword", keyword);
    	data.put("class_code", class_code);
    	return sqlSession.selectOne(namespace + ".Get_Student_Information_For_Student_Management_Count", data);
    }
    
    /* 학급 구성관리(학생 조회) */
    public List<Student_Information_DAO> Get_Student_Information_For_Student_Management(String student_level, String student_class, String option, String keyword, String page, List<String> class_code) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("student_level", student_level);
    	data.put("student_class", student_class);
    	data.put("option", option);
    	data.put("keyword", keyword);
    	data.put("page", Integer.parseInt(page));
    	data.put("class_code", class_code);
    	return sqlSession.selectList(namespace + ".Get_Student_Information_For_Student_Management", data);
    }
    
    /* 학생 학급정보 수정하기 */
    public boolean Update_Student_Information_By_Teacher(String student_school, String student_level, String student_class, String student_number, String student_id) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("student_school", student_school);
    	data.put("student_level", student_level);
    	data.put("student_class", student_class);
    	data.put("student_number", student_number);
    	data.put("student_id", student_id);
    	
    	if(sqlSession.update(namespace + ".Update_Student_Information_By_Teacher", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    
    /* 학생 탈퇴시키기 */
    public boolean Delete_Student_Information_By_Teacher(String student_id) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("student_id", student_id);
    	
    	if(sqlSession.update(namespace + ".Delete_Student_Information_By_Teacher", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 이메일중복검사 ( 중복이라면 true ) */
    public boolean Get_Student_email(String student_email) {
    	String result = sqlSession.selectOne(namespace + ".Get_Student_email", student_email);
    	if(result == null) {
    		return false;
    	}else {
    		return true;
    	}
    }
    
    /* 사용자 존재여부, 아이디 중복여부에 사용할 쿼리 ( 중복이라면 true ) */
    public boolean Get_Student_id(String student_id) {
    	String result = sqlSession.selectOne(namespace + ".Get_Student_id", student_id);
    	if(result == null) {
    		return false;
    	}else {
    		return true;
    	}
    }
    
    /* 학생 회원가입 시키기 */
    public boolean Create_Student_Information(String student_id, String student_name, String student_password, String student_email, String student_phone, 
    		String student_email_agreement, String student_message_agreement, String student_age, String student_sex, String student_school, String student_level, String student_class, 
    		String student_number, String student_create_date) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("student_id", student_id);
    	data.put("student_name", student_name);
    	data.put("student_password", student_password);
    	data.put("student_email", student_email);
    	data.put("student_phone", student_phone);
    	data.put("student_email_agreement", student_email_agreement);
    	data.put("student_message_agreement", student_message_agreement);
    	data.put("student_age", student_age);
    	data.put("student_sex", student_sex);
    	data.put("student_school", student_school);
    	data.put("student_level", student_level);
    	data.put("student_class", student_class);
    	data.put("student_number", student_number);
    	data.put("student_create_date", student_create_date);
    	
    	if(sqlSession.insert(namespace + ".Create_Student_Information", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 링크생성페이지에서 학급정원 변경 */
    public boolean Change_Class_People_Max_Count(String class_people_max_count, String teacher_id, String class_code) {
    	HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_people_max_count", class_people_max_count);
    	data.put("teacher_id", teacher_id);
    	data.put("class_code", class_code);
    	
    	if(sqlSession.update(namespace + ".Change_Class_People_Max_Count", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
    }
    
    /* 운동 종목명 불러오기 ( 커리큘럼 셋팅 ) */
    public Content_List_VO Get_Content_List_For_Curriculum(String content_code) {
    	return sqlSession.selectOne(namespace + ".Get_Content_List_For_Curriculum", content_code);
    }
    
    /* 클래스에 참여중인 학생 불러오기 ( 그룹셋팅에서 사용 ) */
    public List<Student_Information_VO> Get_Student_List_In_Class(String class_code){
    	return sqlSession.selectList(namespace + ".Get_Student_List_In_Class", class_code);
    }
    
}
