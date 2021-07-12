package kr.co.onpe.service;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.co.onpe.dao.Web_Teacher_Progress_DAO;
import kr.co.onpe.vo.Class_Community_Comment_VO;
import kr.co.onpe.vo.Class_Community_VO;
import kr.co.onpe.vo.Class_List_VO;
import kr.co.onpe.vo.Class_Record_VO;
import kr.co.onpe.vo.Curriculum_Unit_List_Class_VO;
import kr.co.onpe.vo.Student_Information_VO;

@Service
public class Web_Teacher_Progress_Service {
    
	@Inject
    private Web_Teacher_Progress_DAO web_Teacher_DAO;
	
	
	/* 클래스 목록 가져오기 */
	public List<String> Get_Class_Code_By_Id(String teacher_id){
		return web_Teacher_DAO.Get_Class_Code_By_Id(teacher_id);
	}
	
	/* 클래스 목록 가져오기(전체) */
	public Class_List_VO Get_Class_List_By_Class_Code(String class_code){
		return web_Teacher_DAO.Get_Class_List_By_Class_Code(class_code);
	}
	
	/* 클래스, 차시별 데이터 가져오기 */
	public List<Curriculum_Unit_List_Class_VO> Get_Curriculum_Unit_List_Class(List<String> class_code){
		return web_Teacher_DAO.Get_Curriculum_Unit_List_Class(class_code);
	}
	
	/* 하나의 차시 데이터 가져오기 */
	public List<Curriculum_Unit_List_Class_VO> Get_Curriculum_Unit_List_Class_One(String class_code, String unit_code){
		return web_Teacher_DAO.Get_Curriculum_Unit_List_Class_One(class_code, unit_code);
	}
	
	/* 하나의 차시별 기록 데이터 가져오기(학생 목록) */
	public List<Class_Record_VO> Get_Student_Class_Record_List(String class_code, String unit_code, String page, List<String> id_list){
		return web_Teacher_DAO.Get_Student_Class_Record_List(class_code, unit_code, page, id_list);
	}
	
	/* 하나의 차시별 기록 데이터 가져오기(전체) */
	public List<Class_Record_VO> Get_Student_Class_Record_List_All(String class_code, String unit_code){
		return web_Teacher_DAO.Get_Student_Class_Record_List_All(class_code, unit_code);
	}
	
	/* 하나의 차시별 기록 데이터 개수 가져오기(학생 목록) */
	public String Get_Student_Class_Record_List_Count(String class_code, String unit_code, List<String> id_list){
		return web_Teacher_DAO.Get_Student_Class_Record_List_Count(class_code, unit_code, id_list);
	}
	
	/* 학생 점수평가 기록 */
	public boolean Update_Student_Class_Record_Evaluation(String evaluation_type_1, String evaluation_type_2, String evaluation_type_3, String unit_code, String class_code, String student_id) {
		return web_Teacher_DAO.Update_Student_Class_Record_Evaluation(evaluation_type_1, evaluation_type_2, evaluation_type_3, unit_code, class_code, student_id);
	}
	
	/* 내 보유 클래스 개수 가져오기 */
	public String Get_My_Class_List_Count(String teacher_id, String class_grade, String class_group, String class_semester, String keyword) {
		return web_Teacher_DAO.Get_My_Class_List_Count(teacher_id, class_grade, class_group, class_semester, keyword);
	}
	
	/* 내 보유 클래스 가져오기 */
	public List<Class_List_VO> Get_My_Class_List(String teacher_id, String class_grade, String class_group, String class_semester, String keyword, String page) {
		return web_Teacher_DAO.Get_My_Class_List(teacher_id, class_grade, class_group, class_semester, keyword, page);
	}
	
	/*내 커리큘럼 가져오기*/
	public List<Curriculum_Unit_List_Class_VO> Get_My_Curriculum_Unit_List_Class_One(String class_code, String unit_code) {
		return web_Teacher_DAO.Get_My_Curriculum_Unit_List_Class_One(class_code, unit_code);
	}
	
	/* 내 클래스코드 목록에 해당하는 게시물 목록 개수 가져오기 */
	public String Get_Class_Community_List_Count(List<String> class_code, String option, String keyword) {
		return web_Teacher_DAO.Get_Class_Community_List_Count(class_code, option, keyword);
	}
	
	/* 내 클래스코드 목록에 해당하는 게시물 목록 가져오기 */
	public List<Class_Community_VO> Get_Class_Community_List(List<String> class_code, String option, String keyword, String page) {
		return web_Teacher_DAO.Get_Class_Community_List(class_code, option, keyword, page);
	}
	
	/* 게시물 하나 가져오기 */
	public Class_Community_VO Get_Class_Community_One(String community_number) {
		return web_Teacher_DAO.Get_Class_Community_One(community_number);
	}
	
	/* 게시물 하나 가져오기(내꺼) */
	public Class_Community_VO Get_My_Class_Community_One(String community_number, String teacher_id) {
		return web_Teacher_DAO.Get_My_Class_Community_One(community_number, teacher_id);
	}
	
	/* 게시물 댓글 목록 가져오기 */
	public List<Class_Community_Comment_VO> Get_Class_Community_Comment_List(String community_number) {
		return web_Teacher_DAO.Get_Class_Community_Comment_List(community_number);
	}
	
	/* 게시물 작성하기 */
	public boolean Create_Class_Community(String community_class_code, String community_id, String community_name, String community_title, String community_text, String community_date) {
		return web_Teacher_DAO.Create_Class_Community(community_class_code, community_id, community_name, community_title, community_text, community_date);
	}
	
	/* 게시물 수정하기 */
	public boolean Update_Class_Community(String community_class_code, String community_title, String community_text, String community_number, String community_id) {
		return web_Teacher_DAO.Update_Class_Community(community_class_code, community_title, community_text, community_number, community_id);
	}
	
	/* 게시물 삭제하기 */
	public boolean Delete_Class_Community(String community_number, String community_id) {
		return web_Teacher_DAO.Delete_Class_Community(community_number, community_id);
	}
	
	/* 게시물 댓글 작성하기 */
	public boolean Create_Class_Community_Comment(String comment_community_number, String comment_id, String comment_name, String comment_content, String comment_date) {
		return web_Teacher_DAO.Create_Class_Community_Comment(comment_community_number, comment_id, comment_name, comment_content, comment_date);
	}
	
	/* 게시물 댓글 삭제하기 */
	public boolean Delete_Class_Community_Comment(String comment_number, String comment_id) {
		return web_Teacher_DAO.Delete_Class_Community_Comment(comment_number, comment_id);
	}
	
	/* 게시글 댓글수 증가 */
	public void Update_Class_Community_Count_Up(String community_number) {
		web_Teacher_DAO.Update_Class_Community_Count_Up(community_number);
	}
	
	/* 게시글 댓글수 감소 */
	public void Update_Class_Community_Count_Down(String community_number) {
		web_Teacher_DAO.Update_Class_Community_Count_Down(community_number);
	}
	
	/* 내 보유 클래스 개수 가져오기(마감관리) */
	public String Get_My_Class_List_Count_For_DeadLine(String teacher_id, String class_grade, String class_group, String class_semester, String keyword, String today) {
		return web_Teacher_DAO.Get_My_Class_List_Count_For_DeadLine(teacher_id, class_grade, class_group, class_semester, keyword, today);
	}
	
	/* 내 보유 클래스 가져오기(마감관리) */
	public List<Class_List_VO> Get_My_Class_List_For_DeadLine(String teacher_id, String class_grade, String class_group, String class_semester, String keyword, String page, String today) {
		return web_Teacher_DAO.Get_My_Class_List_For_DeadLine(teacher_id, class_grade, class_group, class_semester, keyword, page, today);
	}
	
	/* 마감처리 */
	public boolean DeadLine_Work(String teacher_id, String class_code) {
		return web_Teacher_DAO.DeadLine_Work(teacher_id, class_code);
	}
	
	/* 공지사항 보낼 학생 토큰 가져오기 */
	public List<Student_Information_VO> Get_Student_Tokens_For_Noti(String class_code){
		return web_Teacher_DAO.Get_Student_Tokens_For_Noti(class_code);
	}
	
	/* 학생 새소식 업데이트 */
	public void Update_Student_News_State(List<String> student_id) {
		web_Teacher_DAO.Update_Student_News_State(student_id);
	}
	
	/* 공지사항 목록 업데이트 */
	public boolean Create_Notice_List(String class_code, String title, String content, String date, String id, String name) {
		return web_Teacher_DAO.Create_Notice_List(class_code, title, content, date, id, name);
	}
}
