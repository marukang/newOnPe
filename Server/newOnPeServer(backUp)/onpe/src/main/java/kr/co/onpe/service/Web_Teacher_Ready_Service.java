package kr.co.onpe.service;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.co.onpe.dao.Student_Information_DAO;
import kr.co.onpe.dao.Web_Teacher_Ready_DAO;
import kr.co.onpe.vo.Auto_Curriculum_List_VO;
import kr.co.onpe.vo.Class_List_VO;
import kr.co.onpe.vo.Content_List_VO;
import kr.co.onpe.vo.Curriculum_Unit_List_Class_VO;
import kr.co.onpe.vo.Exercise_Category_VO;
import kr.co.onpe.vo.Student_Information_VO;

@Service
public class Web_Teacher_Ready_Service {
    
	@Inject
    private Web_Teacher_Ready_DAO web_Teacher_DAO;
	
	/*  (클래스 링크생성)보유 클래스 목록 가져오기 [아이디, 년도, 학기 를 통해 조회] */
	public List<Class_List_VO> Get_Class_List_For_Create_Link(String teacher_id, String class_year, String class_semester, String class_grade, String class_group) {
    	return web_Teacher_DAO.Get_Class_List_For_Create_Link(teacher_id, class_year, class_semester, class_grade, class_group);
    }
	
    /* (클래스 링크생성)클래스 최초 생성 */
    public boolean Create_Class_List_For_Create_Link(String teacher_id, String class_code, String class_year, String class_semester, String class_grade, String class_group, String class_people_count, String class_people_max_count) {
    	return web_Teacher_DAO.Create_Class_List_For_Create_Link(teacher_id, class_code, class_year, class_semester, class_grade, class_group, class_people_count, class_people_max_count);
    }
    
    /* (클래스 링크생성)클래스 삭제 */
    public boolean Delete_Class_List_For_Create_Link(String class_code) {
    	return web_Teacher_DAO.Delete_Class_List_For_Create_Link(class_code);
    }
    
    /* 보유클래스 개수가져오기 */
    public String Get_Class_List_Count_For_Management(String teacher_id, String class_grade, String class_group, String class_start_date, String class_end_date, String keyword) {
    	return web_Teacher_DAO.Get_Class_List_Count_For_Management(teacher_id, class_grade, class_group, class_start_date, class_end_date, keyword);
    }
    
    /* 클래스 하나 가져오기 */
    public Class_List_VO Get_Class_List_For_Management_Detail(String teacher_id, String class_code) {
    	return web_Teacher_DAO.Get_Class_List_For_Management_Detail(teacher_id, class_code);
    }
    
    /* 보유클래스 가져오기 */
    public List<Class_List_VO> Get_Class_List_For_Management(String teacher_id, String class_grade, String class_group, String class_start_date, String class_end_date, String keyword, String page) {
    	return web_Teacher_DAO.Get_Class_List_For_Management(teacher_id, class_grade, class_group, class_start_date, class_end_date, keyword, page);
    }
    
    /* 클래스 수정 */
    public boolean Update_Class_List_For_Management(String teacher_id, String class_code, String class_people_max_count, String class_name, String class_start_date, String class_end_date, String class_project_submit_type, String class_unit_list) {
    	return web_Teacher_DAO.Update_Class_List_For_Management(teacher_id, class_code, class_people_max_count, class_name, class_start_date, class_end_date, class_project_submit_type, class_unit_list);
    }
    
    /*커리큘럼 자동완성 목록 가져오기*/
    public List<Auto_Curriculum_List_VO> Get_Auto_Make_Curriculum(String class_level, String class_grade, String class_semester, String keyword_option, String keyword, String sort, String page) {
    	return web_Teacher_DAO.Get_Auto_Make_Curriculum(class_level, class_grade, class_semester, keyword_option, keyword, sort, page);
    }
    
    /*커리큘럼 자동완성 목록 개수 가져오기*/
    public String Get_Auto_Make_Curriculum_Count(String class_level, String class_grade, String class_semester, String keyword_option, String keyword) {
    	return web_Teacher_DAO.Get_Auto_Make_Curriculum_Count(class_level, class_grade, class_semester, keyword_option, keyword);
    }
    
    /* 커리큘럼 자동완성 하나 가져오기 */
    public Auto_Curriculum_List_VO Get_Auto_Make_Curriculum_One(String curriculum_code) {
    	return web_Teacher_DAO.Get_Auto_Make_Curriculum_One(curriculum_code);
    }
    
    /* 차시별(단원별) 리스트 가져오기( 커리큘럼 자동완성 ) */
    public List<Curriculum_Unit_List_Class_VO> Get_Curriculum_Unit_List_Class_For_Auto_Make(List<String> unit_code){
    	return web_Teacher_DAO.Get_Curriculum_Unit_List_Class_For_Auto_Make(unit_code);
    }
    
    /* 차시별(단원별) 리스트 생성( 커리큘럼 자동완성 ) */
    public boolean Create_Curriculum_Unit_List_Class_For_Auto_Make(List<Curriculum_Unit_List_Class_VO> unit_code){
    	return web_Teacher_DAO.Create_Curriculum_Unit_List_Class_For_Auto_Make(unit_code);
    }
    
    /* 커리큘럼 리셋 */
    public void Reset_Curriculum_Unit_List_Class(String teacher_id, String class_code) {
    	web_Teacher_DAO.Reset_Curriculum_Unit_List_Class(teacher_id, class_code);
    }
    
    /* 단일 커리큘럼 리스트 불러오기 */
    public List<Curriculum_Unit_List_Class_VO> Get_Curriculum_Unit_LIst_Class(String unit_code, String class_code){
    	return web_Teacher_DAO.Get_Curriculum_Unit_LIst_Class(unit_code, class_code);
    }
    
    /* 커리큘럼 수정 (전체) */
    public boolean Update_Curriculum_Unit_List_Class_ALL(String unit_class_type, String unit_group_name, String unit_group_id_list, String unit_class_name, String unit_class_text, String unit_start_date, String unit_end_date, String unit_youtube_url, String unit_content_url, String unit_attached_file, String content_code_list, String content_home_work, String content_test, String content_evaluation_type, String unit_code, String class_code) {
    	return web_Teacher_DAO.Update_Curriculum_Unit_List_Class_ALL(unit_class_type, unit_group_name, unit_group_id_list, unit_class_name, unit_class_text, unit_start_date, unit_end_date, unit_youtube_url, unit_content_url, unit_attached_file, content_code_list, content_home_work, content_test, content_evaluation_type, unit_code, class_code);
    }
    
    /* 커리큘럼 수정(일정수정) */
    public boolean Update_Curriculum_Unit_List_Class_Date(String unit_start_date, String unit_end_date, String unit_code, String class_code) {
    	return web_Teacher_DAO.Update_Curriculum_Unit_List_Class_Date(unit_start_date, unit_end_date, unit_code, class_code);
    }
    
    /* 커리큘럼 생성 */
    public boolean Create_Curriculum_Unit_List_Class(String unit_code, String class_code, String unit_class_type, String unit_group_name, String unit_group_id_list, String unit_class_name, String unit_class_text, String unit_start_date, String unit_end_date, String unit_youtube_url, String unit_content_url, String unit_attached_file, String content_code_list, String content_home_work, String content_test, String content_evaluation_type) {
    	return web_Teacher_DAO.Create_Curriculum_Unit_List_Class(unit_code, class_code, unit_class_type, unit_group_name, unit_group_id_list, unit_class_name, unit_class_text, unit_start_date, unit_end_date, unit_youtube_url, unit_content_url, unit_attached_file, content_code_list, content_home_work, content_test, content_evaluation_type);
    }
    
    /* 커리큘럼 삭제 */
    public boolean Delete_Curriculum_Unit_List_Class(String unit_code, String class_code) {
    	return web_Teacher_DAO.Delete_Curriculum_Unit_List_Class(unit_code, class_code);
    }
    
    /* 커리큘럼 다중생성 */
    public boolean Create_Curriculum_Unit_List_Class_List(List<Curriculum_Unit_List_Class_VO> list) {
    	return web_Teacher_DAO.Create_Curriculum_Unit_List_Class_List(list);
    }
    
    /* 이전 클래스 정보 가져오기(이전수업 불러오기 기능) */
    public Class_List_VO Get_Class_List_For_Auto_Create(String teacher_id){
    	return web_Teacher_DAO.Get_Class_List_For_Auto_Create(teacher_id);
    }
    
    /* 이전 클래스의 커리큘럼 목록 불러오기 (이전수업 불러오기 기능) */
    public List<Curriculum_Unit_List_Class_VO> Get_Curriculum_Unit_List_For_Auto_Create(String class_code){
    	return web_Teacher_DAO.Get_Curriculum_Unit_List_For_Auto_Create(class_code);
    }
    
    /* 추천조합에 사용되는 종목명 목록 불러오기 */
    public List<String> Get_Content_List_Content_Name_List(){
    	return web_Teacher_DAO.Get_Content_List_Content_Name_List();
    }
    
    /* 추천조합에 사용되는 대분류 목록 불러오기 */
    public List<String> Get_Content_List_Content_Category_List(){
    	return web_Teacher_DAO.Get_Content_List_Content_Category_List();
    }
    
    /* 추천조합 목록 개수 가져오기 */
    public String Get_Content_List_Count(String content_name, String content_category, String option, String keyword, String sort){
    	return web_Teacher_DAO.Get_Content_List_Count(content_name, content_category, option, keyword, sort);
    }
    
    /* 추천조합 목록 가져오기 */
    public List<Content_List_VO> Get_Content_List(String content_name, String content_category, String option, String keyword, String sort, String page){
    	return web_Teacher_DAO.Get_Content_List(content_name, content_category, option, keyword, sort, page);
    }
    
    /*내 컨텐츠 불러오기*/
    public Content_List_VO Get_Content_List_Mine(String content_code, String teacher_id){
    	return web_Teacher_DAO.Get_Content_List_Mine(content_code, teacher_id);
    }
    
    /* 내 컨텐츠의 운동 불러오기 */
    public Exercise_Category_VO Get_Exercise_Category_Mine(String exercise_code){
    	return web_Teacher_DAO.Get_Exercise_Category_Mine(exercise_code);
    }
    
    
    /* 운동 Object 불러오기 */
    public List<Exercise_Category_VO> Get_Exercise_Category_One(String exercise_name, String exercise_category, String exercise_detail_name){
    	return web_Teacher_DAO.Get_Exercise_Category_One(exercise_name, exercise_category, exercise_detail_name);
    }
    
    /* 운동 종목이름 불러오기 */
    public List<String> Get_Exercise_Category_Exercise_Name(){
    	return web_Teacher_DAO.Get_Exercise_Category_Exercise_Name();
    }
    
    /* 운동 대분류 불러오기 */
    public List<String> Get_Exercise_Category_Exercise_Category(String exercise_name){
    	return web_Teacher_DAO.Get_Exercise_Category_Exercise_Category(exercise_name);
    }
    
    /* 운동 동작명 불러오기 */
    public List<String> Get_Exercise_Category_Exercise_Detail_Name(String exercise_name, String exercise_category){
    	return web_Teacher_DAO.Get_Exercise_Category_Exercise_Detail_Name(exercise_name, exercise_category);
    }
    
    /* 컨텐츠 리스트 만들기 */
    public boolean Create_Content_List(String content_code, String content_value, String content_title, String content_name, String content_category, String teacher_id, 
    		String content_class_level, String content_class_grade, String content_write_date, String content_number_list, String content_name_list, String content_cateogry_list, 
    		String content_type_list, String content_area_list, String content_detail_name_list, String content_count_list, String content_time, String content_url, String content_level_list) {
    	return web_Teacher_DAO.Create_Content_List(content_code, content_value, content_title, content_name, content_category, teacher_id, content_class_level, content_class_grade, content_write_date, content_number_list, content_name_list, content_cateogry_list, content_type_list, content_area_list, content_detail_name_list, content_count_list, content_time, content_url, content_level_list);
    }
	
	/* 컨텐츠 업데이트 */
    public boolean Update_Content_List(String content_title, String content_name, String content_category, String content_number_list, String content_name_list, 
    		String content_cateogry_list, String content_type_list, String content_area_list, String content_detail_name_list, String content_count_list, 
    		String content_time, String content_url, String content_level_list, String content_code, String teacher_id) {
    	return web_Teacher_DAO.Update_Content_List(content_title, content_name, content_category, content_number_list, content_name_list, content_cateogry_list, content_type_list, content_area_list, content_detail_name_list, content_count_list, content_time, content_url, content_level_list, content_code, teacher_id);
    }
    
    /* 학급 구성관리(학생수 조회) */
    public String Get_Student_Information_For_Student_Management_Count(String student_level, String student_class, String option, String keyword, List<String> class_code) {
    	return web_Teacher_DAO.Get_Student_Information_For_Student_Management_Count(student_level, student_class, option, keyword, class_code);
    }
    
    /* 학급 구성관리(학생 조회) */
    public List<Student_Information_DAO> Get_Student_Information_For_Student_Management(String student_level, String student_class, String option, String keyword, String page, List<String> class_code) {
    	return web_Teacher_DAO.Get_Student_Information_For_Student_Management(student_level, student_class, option, keyword, page, class_code);
    }
    
    
    /* 학생 학급정보 수정하기 */
    public boolean Update_Student_Information_By_Teacher(String student_school, String student_level, String student_class, String student_number, String student_id) {
    	return web_Teacher_DAO.Update_Student_Information_By_Teacher(student_school, student_level, student_class, student_number, student_id);
    }
    
    
    /* 학생 탈퇴시키기 */
    public boolean Delete_Student_Information_By_Teacher(String student_id) {
    	return web_Teacher_DAO.Delete_Student_Information_By_Teacher(student_id);
    }
    
    
    /* 이메일중복검사 ( 중복이라면 true ) */
    public boolean Get_Student_email(String student_email) {
    	return web_Teacher_DAO.Get_Student_email(student_email);
    }
    
    /* 사용자 존재여부, 아이디 중복여부에 사용할 쿼리 ( 중복이라면 true ) */
    public boolean Get_Student_id(String student_id) {
    	return web_Teacher_DAO.Get_Student_id(student_id);
    }
    
    /* 학생 회원가입 시키기 */
    public boolean Create_Student_Information(String student_id, String student_name, String student_password, String student_email, String student_phone, 
    		String student_email_agreement, String student_message_agreement, String student_age, String student_sex, String student_school, String student_level, String student_class, 
    		String student_number, String student_create_date) {
    	return web_Teacher_DAO.Create_Student_Information(student_id, student_name, student_password, student_email, student_phone, 
    			student_email_agreement, student_message_agreement, student_age, student_sex, student_school, student_level, student_class, student_number, student_create_date);
    }
    
    /* 링크생성페이지에서 학급정원 변경 */
    public boolean Change_Class_People_Max_Count(String class_people_max_count, String teacher_id, String class_code) {
    	return web_Teacher_DAO.Change_Class_People_Max_Count(class_people_max_count, teacher_id, class_code);
    }
    
    /* 운동 종목명 불러오기 ( 커리큘럼 셋팅 ) */
    public Content_List_VO Get_Content_List_For_Curriculum(String content_code) {
    	return web_Teacher_DAO.Get_Content_List_For_Curriculum(content_code);
    }
    
    /* 클래스에 참여중인 학생 불러오기 ( 그룹셋팅에서 사용 ) */
    public List<Student_Information_VO> Get_Student_List_In_Class(String class_code){
    	return web_Teacher_DAO.Get_Student_List_In_Class(class_code);
    }
    
    
}
