package kr.co.onpe.dao;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import kr.co.onpe.vo.Class_Community_Comment_VO;
import kr.co.onpe.vo.Class_Community_VO;
import kr.co.onpe.vo.Class_List_VO;
import kr.co.onpe.vo.Class_Record_VO;
import kr.co.onpe.vo.Curriculum_Unit_List_Class_VO;
import kr.co.onpe.vo.Student_Information_VO;

@Repository
public class Web_Teacher_Progress_DAO {

	@Inject
	 private SqlSessionTemplate sqlSession;
	    
	// 매퍼 식별 값
	private String namespace = "kr.co.mappers.TeacherProgressMapper";

	/* 클래스 목록 가져오기(클래스코드) */
	public List<String> Get_Class_Code_By_Id(String teacher_id){
		return sqlSession.selectList(namespace + ".Get_Class_Code_By_Id", teacher_id);
	}
	
	/* 클래스 목록 가져오기(전체) */
	public Class_List_VO Get_Class_List_By_Class_Code(String class_code){
		return sqlSession.selectOne(namespace + ".Get_Class_List_By_Class_Code", class_code);
	}
	
    /* 클래스, 차시별 데이터 가져오기 */
	public List<Curriculum_Unit_List_Class_VO> Get_Curriculum_Unit_List_Class(List<String> class_code){
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
		return sqlSession.selectList(namespace + ".Get_Curriculum_Unit_List_Class", data);
	}
	
	/* 하나의 차시 데이터 가져오기 */
	public List<Curriculum_Unit_List_Class_VO> Get_Curriculum_Unit_List_Class_One(String class_code, String unit_code){
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
    	data.put("unit_code", unit_code);
		return sqlSession.selectList(namespace + ".Get_Curriculum_Unit_List_Class_One", data);
	}
	
	/* 하나의 차시별 기록 데이터 가져오기(학생 목록) */
	public List<Class_Record_VO> Get_Student_Class_Record_List(String class_code, String unit_code, String page, List<String> id_list){
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
    	data.put("unit_code", unit_code);
    	data.put("page", Integer.parseInt(page));
    	if(id_list != null) {
    		data.put("id_list", id_list);	
    	}
		return sqlSession.selectList(namespace + ".Get_Student_Class_Record_List", data);
	}
	
	/* 하나의 차시별 기록 데이터 가져오기(전체) */
	public List<Class_Record_VO> Get_Student_Class_Record_List_All(String class_code, String unit_code){
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
    	data.put("unit_code", unit_code);
    	
    	return sqlSession.selectList(namespace + ".Get_Student_Class_Record_List_All", data);
	}
	
	/* 하나의 차시별 기록 데이터 개수 가져오기(학생 목록) */
	public String Get_Student_Class_Record_List_Count(String class_code, String unit_code, List<String> id_list){
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
    	data.put("unit_code", unit_code);
    	if(id_list != null) {
    		data.put("id_list", id_list);	
    	}
		return sqlSession.selectOne(namespace + ".Get_Student_Class_Record_List_Count", data);
	}
	
	/* 학생 점수평가 기록 */
	public boolean Update_Student_Class_Record_Evaluation(String evaluation_type_1, String evaluation_type_2, String evaluation_type_3, String unit_code, String class_code, String student_id) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
    	data.put("unit_code", unit_code);
    	data.put("student_id", student_id);
    	data.put("evaluation_type_1", evaluation_type_1);
    	data.put("evaluation_type_2", evaluation_type_2);
    	data.put("evaluation_type_3", evaluation_type_3);
    	if(sqlSession.update(namespace + ".Update_Student_Class_Record_Evaluation", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
	}
	
	/* 내 보유 클래스 개수 가져오기 */
	public String Get_My_Class_List_Count(String teacher_id, String class_grade, String class_group, String class_semester, String keyword) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("teacher_id", teacher_id);
    	data.put("class_grade", class_grade);
    	data.put("class_group", class_group);
    	data.put("class_semester", class_semester);
    	data.put("keyword", keyword);
		return sqlSession.selectOne(namespace + ".Get_My_Class_List_Count", data);
	}
	
	/* 내 보유 클래스 가져오기 */
	public List<Class_List_VO> Get_My_Class_List(String teacher_id, String class_grade, String class_group, String class_semester, String keyword, String page) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("teacher_id", teacher_id);
    	data.put("class_grade", class_grade);
    	data.put("class_group", class_group);
    	data.put("class_semester", class_semester);
    	data.put("keyword", keyword);
    	data.put("page", Integer.parseInt(page));
		return sqlSession.selectList(namespace + ".Get_My_Class_List", data);
	}
	
	/*내 커리큘럼 가져오기*/
	public List<Curriculum_Unit_List_Class_VO> Get_My_Curriculum_Unit_List_Class_One(String class_code, String unit_code) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
    	data.put("unit_code", unit_code);
		return sqlSession.selectList(namespace + ".Get_My_Curriculum_Unit_List_Class_One", data);
	}
	
	
	
	/* 내 클래스코드 목록에 해당하는 게시물 목록 개수 가져오기 */
	public String Get_Class_Community_List_Count(List<String> class_code, String option, String keyword) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
    	data.put("option", option);
    	data.put("keyword", keyword);
    	return sqlSession.selectOne(namespace + ".Get_Class_Community_List_Count", data);
	}
	
	/* 내 클래스코드 목록에 해당하는 게시물 목록 가져오기 */
	public List<Class_Community_VO> Get_Class_Community_List(List<String> class_code, String option, String keyword, String page) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
    	data.put("option", option);
    	data.put("keyword", keyword);
    	data.put("page", Integer.parseInt(page));
    	return sqlSession.selectList(namespace + ".Get_Class_Community_List", data);
	}
	
	/* 게시물 하나 가져오기 */
	public Class_Community_VO Get_Class_Community_One(String community_number) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("community_number", community_number);
    	return sqlSession.selectOne(namespace + ".Get_Class_Community_One", data);
	}
	
	/* 게시물 하나 가져오기(내꺼) */
	public Class_Community_VO Get_My_Class_Community_One(String community_number, String teacher_id) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("community_number", community_number);
    	data.put("teacher_id", teacher_id);
    	return sqlSession.selectOne(namespace + ".Get_My_Class_Community_One", data);
	}
	
	/* 게시물 댓글 목록 가져오기 */
	public List<Class_Community_Comment_VO> Get_Class_Community_Comment_List(String community_number) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("community_number", community_number);
    	return sqlSession.selectList(namespace + ".Get_Class_Community_Comment_List", data);
	}
	
	/* 게시물 작성하기 */
	public boolean Create_Class_Community(String community_class_code, String community_id, String community_name, String community_title, String community_text, String community_date) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("community_class_code", community_class_code);
    	data.put("community_id", community_id);
    	data.put("community_name", community_name);
    	data.put("community_title", community_title);
    	data.put("community_text", community_text);
    	data.put("community_date", community_date);
    	if(sqlSession.insert(namespace + ".Create_Class_Community", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
	}
	
	/* 게시물 수정하기 */
	public boolean Update_Class_Community(String community_class_code, String community_title, String community_text, String community_number, String community_id) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("community_class_code", community_class_code);
    	data.put("community_title", community_title);
    	data.put("community_text", community_text);
    	data.put("community_number", community_number);
    	data.put("community_id", community_id);
    	if(sqlSession.update(namespace + ".Update_Class_Community", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
	}
	
	/* 게시물 삭제하기 */
	public boolean Delete_Class_Community(String community_number, String community_id) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("community_number", community_number);
    	data.put("community_id", community_id);
    	if(sqlSession.delete(namespace + ".Delete_Class_Community", data) > 0) {
    		return true;
    	}else {
    		return false;
    	}
	}
	
	/* 게시물 댓글 작성하기 */
	public boolean Create_Class_Community_Comment(String comment_community_number, String comment_id, String comment_name, String comment_content, String comment_date) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("comment_community_number", comment_community_number);
    	data.put("comment_id", comment_id);
    	data.put("comment_name", comment_name);
    	data.put("comment_content", comment_content);
    	data.put("comment_date", comment_date);
    	if(sqlSession.insert(namespace + ".Create_Class_Community_Comment", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
	}
	
	/* 게시물 댓글 삭제하기 */
	public boolean Delete_Class_Community_Comment(String comment_number, String comment_id) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("comment_number", comment_number);
    	data.put("comment_id", comment_id);
    	if(sqlSession.delete(namespace + ".Delete_Class_Community_Comment", data) > 0) {
    		return true;
    	}else {
    		return false;
    	}
	}
	
	/* 게시글 댓글수 증가 */
	public void Update_Class_Community_Count_Up(String community_number) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("community_number", community_number);
		sqlSession.delete(namespace + ".Update_Class_Community_Count_Up", data);
	}
	
	/* 게시글 댓글수 감소 */
	public void Update_Class_Community_Count_Down(String community_number) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("community_number", community_number);
		sqlSession.delete(namespace + ".Update_Class_Community_Count_Down", data);
	}
	
	/* 내 보유 클래스 개수 가져오기(마감관리) */
	public String Get_My_Class_List_Count_For_DeadLine(String teacher_id, String class_grade, String class_group, String class_semester, String keyword, String today) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("teacher_id", teacher_id);
    	data.put("class_grade", class_grade);
    	data.put("class_group", class_group);
    	data.put("class_semester", class_semester);
    	data.put("keyword", keyword);
    	data.put("today", Integer.parseInt(today));
		return sqlSession.selectOne(namespace + ".Get_My_Class_List_Count_For_DeadLine", data);
	}
	
	/* 내 보유 클래스 가져오기(마감관리) */
	public List<Class_List_VO> Get_My_Class_List_For_DeadLine(String teacher_id, String class_grade, String class_group, String class_semester, String keyword, String page, String today) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("teacher_id", teacher_id);
    	data.put("class_grade", class_grade);
    	data.put("class_group", class_group);
    	data.put("class_semester", class_semester);
    	data.put("keyword", keyword);
    	data.put("page", Integer.parseInt(page));
    	data.put("today", Integer.parseInt(today));
		return sqlSession.selectList(namespace + ".Get_My_Class_List_For_DeadLine", data);
	}
	
	/* 마감처리 */
	public boolean DeadLine_Work(String teacher_id, String class_code) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("teacher_id", teacher_id);
    	data.put("class_code", class_code);
    	if(sqlSession.delete(namespace + ".DeadLine_Work", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
	}
	
	/* 공지사항 보낼 학생 토큰 가져오기 */
	public List<Student_Information_VO> Get_Student_Tokens_For_Noti(String class_code){
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
		return sqlSession.selectList(namespace + ".Get_Student_Tokens_For_Noti", data);
	}
	
	/* 학생 새소식 업데이트 */
	public void Update_Student_News_State(List<String> student_id) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("student_id", student_id);
    	sqlSession.update(namespace + ".Update_Student_News_State", data);
	}
	
	/* 공지사항 목록 업데이트 */
	public boolean Create_Notice_List(String class_code, String title, String content, String date, String id, String name) {
		HashMap<String, Object> data = new HashMap<String, Object>();
    	data.put("class_code", class_code);
    	data.put("title", title);
    	data.put("content", content);
    	data.put("date", date);
    	data.put("id", id);
    	data.put("name", name);
    	if(sqlSession.insert(namespace + ".Create_Notice_List", data) == 1) {
    		return true;
    	}else {
    		return false;
    	}
	}
}
