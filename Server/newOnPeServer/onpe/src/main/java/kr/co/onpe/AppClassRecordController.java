package kr.co.onpe;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import kr.co.onpe.security.JwtTokenProvider;
import kr.co.onpe.service.Student_Record_Service;
import kr.co.onpe.vo.Class_Record_VO;

@Controller
@RequestMapping("/app/record/*")
public class AppClassRecordController {

	private static final Logger logger = LoggerFactory.getLogger(AppClassRecordController.class);
	
	/* 학생 수업 기록관련 서비스 */
	@Inject
	private Student_Record_Service student_record_service;
	
	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
	/* 사용자 운동 이미지의 저장 경로 */
    @Resource(name="Student_Image_Confirmation_uploadPath")
    String Student_Image_Confirmation_uploadPath;
    
	/*
	 * ------------------- 공통 -------------------
	 * 
	 * student_id ( 사용자 아이디 )
	 * student_token ( 사용자 access token )
	 * 위 두개를 받아서 jwtTokenProvider클래스의 TokenCheck로 토큰 유효성 검증을 거친다.
	 *  - 사용자 아이디와 토큰 소유자 아이디가 일치하지 않을시 "fail"이 반환된다.
	 *  - 토큰 만료시간이 지났을 경우 "expired"가 반환된다.
	 *  
	 *  토큰 유효성 검증을 정상적으로 마칠 경우 신규 토큰이 발급된다.
	 *  따라서 사용자에게 신규토큰을 반환한다.
	 * */
	
	/* 학생 수업 현황 조회하기 */
	@ResponseBody
	@RequestMapping(value = "/get_student_class_record", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String student_class_update(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String class_code = request.getParameter("class_code");
		String unit_code = request.getParameter("unit_code");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && unit_code != null && class_code != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				/*
				 * 학생 수업현황을 조회하여 존재할시 토큰과 함께 JSON 형태로 반환한다.
				 * 학생 수업현황이 존재하지 않을시 "none_record"를 JSON 형태로 반환한다.
				 * */
				
				Class_Record_VO student_class_record = student_record_service.Get_Student_Class_Record(student_id, unit_code, class_code);
				
				if(student_class_record != null) {
					
					try {
						ObjectMapper obm  = new ObjectMapper();						
						Map<String, Object> data = new HashMap<String, Object>();
						
						data.put("success", student_class_record);
						data.put("student_token", student_token);
						
						return obm.writeValueAsString(data);
						
					} catch (JsonProcessingException e) {
						object.addProperty("fail", "server_error");	// 실패
						return gson.toJson(object);
					}
					
				}else {
					
					object.addProperty("fail", "none_record");
					return gson.toJson(object);
					
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	
	/* 과제 제출방법 조회하기 */
	@ResponseBody
	@RequestMapping(value = "/get_class_project_submit_type", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String get_class_project_submit_type(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String class_code = request.getParameter("class_code");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && class_code != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				/*
				 * 과제 제출방법을 조회하여 존재할시 토큰과 함께 JSON 형태로 반환한다.
				 * 과제 제출방법이 존재하지 않을시 "none_record"를 JSON 형태로 반환한다.
				 * */
				
				String submit_data = student_record_service.Get_Class_Project_Submit_Type(class_code);
				
				if(submit_data != null) {
					
					try {
						ObjectMapper obm  = new ObjectMapper();						
						Map<String, Object> data = new HashMap<String, Object>();
						
						data.put("success", submit_data);
						data.put("student_token", student_token);
						
						return obm.writeValueAsString(data);
						
					} catch (JsonProcessingException e) {
						object.addProperty("fail", "server_error");	// 실패
						return gson.toJson(object);
					}
					
				}else {
					
					object.addProperty("fail", "none_record");
					return gson.toJson(object);
					
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	
	/* 
	 * 학생 수업 현황 최초 생성하기 
	 * 학생이 수업에 참여할시 생성된다.  
	 * */
	
	@ResponseBody
	@RequestMapping(value = "/create_student_class_record", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String create_student_class_record(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String unit_code = request.getParameter("unit_code");
		String class_code = request.getParameter("class_code");
		String student_name = request.getParameter("student_name");
		String student_grade = request.getParameter("student_grade");
		String student_group = request.getParameter("student_group");
		String student_number = request.getParameter("student_number");
		String student_participation = request.getParameter("student_participation");
		String student_practice = request.getParameter("student_practice");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && unit_code != null && class_code != null && student_name != null && student_grade != null && student_group != null && student_number != null && student_participation != null && student_practice != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				Class_Record_VO student_class_record = student_record_service.Get_Student_Class_Record(student_id, unit_code, class_code);
				
				/*
				 * 테이블 insert를 진행하여 성공, 실패 유무와 토큰을 함께 JSON 형태로 반환한다.
				 * 만약 이미 생성된 레코드가 존재할시 "overlap_record"를 JSON 형태로 반환한다.
				 * */
				
				if(student_class_record == null) {
					
					boolean result = student_record_service.Create_Stundet_Class_Record(unit_code, class_code, student_id, student_name, student_grade, student_group, student_number, student_participation, student_practice);
					
					if(result) {
						object.addProperty("success", "success_create");
						object.addProperty("student_token", student_token);
						return gson.toJson(object);
					}else {
						object.addProperty("fail", "server_error");
						return gson.toJson(object);
					}
				}else {
					object.addProperty("fail", "overlap_record");
					return gson.toJson(object);
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/*
	 * 하단은 수업중 평가, 과제, 실습의 기록에 대한 백엔드이다.
	 * */
	
	
	/* 학생 수업 실습 기록하기 */
	@ResponseBody
	@RequestMapping(value = "/update_student_record_class_practice", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String update_student_record_class_practice(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String class_code = request.getParameter("class_code");
		String unit_code = request.getParameter("unit_code");
		String class_practice = request.getParameter("class_practice");
		String content_use_time = request.getParameter("content_use_time");
		String unit_group_name = request.getParameter("unit_group_name");
		if(unit_group_name != null && unit_group_name.length() < 2) {
			unit_group_name = null;
		}
		
		SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
		format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
		Date time = new Date();
		String time_number = format.format(time);
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(content_use_time != null && student_id != null && student_token != null && unit_code != null && class_code != null && class_practice != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				boolean result = student_record_service.Update_Student_Class_Record_Class_Practice(student_id, unit_code, class_code, class_practice);
				
				if(result) {
					
					student_record_service.Update_Student_Recent_Exercise_Date(student_id, time_number);
					student_record_service.Update_Curriculum_Use_Time(class_code, unit_code, content_use_time, unit_group_name);
					
					object.addProperty("success", "success_change");
					object.addProperty("student_token", student_token);
					return gson.toJson(object);	
					
				}else {
					object.addProperty("fail", "none_record");
					return gson.toJson(object);
				}				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	
	/* 학생 과제 실습 기록하기 */
	@ResponseBody
	@RequestMapping(value = "/update_student_record_task_practice", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String update_student_record_task_practice(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String class_code = request.getParameter("class_code");
		String unit_code = request.getParameter("unit_code");
		String task_practice = request.getParameter("task_practice");
		String content_use_time = request.getParameter("content_use_time");
		String unit_group_name = request.getParameter("unit_group_name");
		if(unit_group_name != null && unit_group_name.length() < 2) {
			unit_group_name = null;
		}
		
		SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
		format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
		Date time = new Date();
		String time_number = format.format(time);
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(content_use_time != null && student_id != null && student_token != null && unit_code != null && class_code != null && task_practice != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				boolean result = student_record_service.Update_Student_Class_Record_Task_Practice(student_id, unit_code, class_code, task_practice);
				
				if(result) {
					
					
					student_record_service.Update_Student_Recent_Exercise_Date(student_id, time_number);
					student_record_service.Update_Curriculum_Use_Time(class_code, unit_code, content_use_time, unit_group_name);
					
					object.addProperty("success", "success_change");
					object.addProperty("student_token", student_token);
					return gson.toJson(object);	
					
				}else {
					object.addProperty("fail", "none_record");
					return gson.toJson(object);
				}				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	
	/* 학생 평가 실습 기록하기 */
	@ResponseBody
	@RequestMapping(value = "/update_student_record_evaluation_practice", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String update_student_record_evaluation_practice(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String class_code = request.getParameter("class_code");
		String unit_code = request.getParameter("unit_code");
		String evaluation_practice = request.getParameter("evaluation_practice");
		String content_use_time = request.getParameter("content_use_time");
		String unit_group_name = request.getParameter("unit_group_name");
		if(unit_group_name != null && unit_group_name.length() < 2) {
			unit_group_name = null;
		}
		
		SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
		format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
		Date time = new Date();
		String time_number = format.format(time);
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(content_use_time != null && student_id != null && student_token != null && unit_code != null && class_code != null && evaluation_practice != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				boolean result = student_record_service.Update_Student_Class_Record_Evaluation_Practice(student_id, unit_code, class_code, evaluation_practice);
				
				if(result) {
					
					student_record_service.Update_Student_Recent_Exercise_Date(student_id, time_number);
					student_record_service.Update_Curriculum_Use_Time(class_code, unit_code, content_use_time, unit_group_name);
					
					object.addProperty("success", "success_change");
					object.addProperty("student_token", student_token);
					return gson.toJson(object);	
					
				}else {
					object.addProperty("fail", "none_record");
					return gson.toJson(object);
				}				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	
	/* 학생 본인확인 이미지 올리기 */
	@ResponseBody
	@RequestMapping(value = "/update_student_record_image_confirmation", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String update_student_record_image_confirmation(Locale locale, HttpServletRequest request, MultipartFile file) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String class_code = request.getParameter("class_code");
		String unit_code = request.getParameter("unit_code");
		String image_file_name = request.getParameter("image_file_name");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && !file.isEmpty() && class_code != null && unit_code != null && image_file_name != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				String fileName = file.getOriginalFilename();	//파일명 긁어오기 ( 확장자 체크 )
				
				//확장자 체크
				if(kr.co.onpe.common.common.checkImageType(fileName)) {
					
					File target = new File(Student_Image_Confirmation_uploadPath, image_file_name + ".jpg");	//jpg로 통일
			        
			        //경로 생성
			        if ( ! new File(Student_Image_Confirmation_uploadPath).exists()) {
			        	new File(Student_Image_Confirmation_uploadPath).mkdirs();
			    	}
			        
			        //파일 복사
			        try {
			        	FileCopyUtils.copy(file.getBytes(), target);
			        	
	    				boolean return_qry = student_record_service.Update_Student_Class_Record_Image_Confirmation(student_id, unit_code, class_code, "/resources/image_confirmation/" + image_file_name + ".jpg");
	    				
	    				if(return_qry) {
	    					object.addProperty("success", "success_change"); //완료
	    					object.addProperty("student_token", student_token);
	    					return gson.toJson(object);	
	    				}else {
	    					
	    					//파일 삭제
	    					
	    					File delete_file = new File("/resources/image_confirmation/" + image_file_name + ".jpg");
							if(delete_file.exists()) {
								delete_file.delete();							
							}
							
	    					object.addProperty("fail", "none_record");	//DB에 없을 때
	    					return gson.toJson(object);	
	    				}
			        	
			        } catch(Exception e) {
			        	e.printStackTrace();
			    		object.addProperty("fail", "server_error");	//실패
			    		return gson.toJson(object);
			        }
			        
				}else {
		    		object.addProperty("fail", "not_image");	//이미지파일이 아닐경우
		    		return gson.toJson(object);
				}
				
			}
		}		
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}
	
}
