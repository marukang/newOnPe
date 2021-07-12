package kr.co.onpe;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import kr.co.onpe.security.JwtTokenProvider;
import kr.co.onpe.service.Student_Class_Service;
import kr.co.onpe.service.Student_Information_Service;
import kr.co.onpe.vo.Content_List_VO;

@Controller
@RequestMapping("/app/class/*")
public class AppClassController {

	private static final Logger logger = LoggerFactory.getLogger(AppClassController.class);
	
	/* 사용자 정보 테이블(student_information) 테이블 관련 서비스 */
	@Inject
	private Student_Information_Service student_information_service;
	
	/* 클래스 목록관련 서비스 */
	@Inject
	private Student_Class_Service student_class_service;
	
	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
	
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
	
	/* 학생 신규 클래스 추가 ( 업데이트 ) */
	@ResponseBody
	@RequestMapping(value = "/student_class_update", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String student_class_update(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String student_classcode = request.getParameter("student_classcode");	//JSON Array를 받아야함
		String class_code = request.getParameter("class_code");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && student_classcode != null && class_code != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				if(student_class_service.Get_Class_Code(class_code)) {
					
					// 클래스 참여 인원수+
					if(student_class_service.Update_Class_People_Count_Up(class_code)) {
						
						String student_school = class_code.split("_")[0];
						
						if(student_information_service.Student_Change_Class(student_id, student_classcode, student_school, class_code)) {
							
							object.addProperty("success", "success_change");
							object.addProperty("student_token", student_token);
							return gson.toJson(object);	
							
						}else {
							
							//학생 신규 클래스추가에 실패시 참여인원-
							student_class_service.Update_Class_People_Count_Down(class_code);
							
							object.addProperty("fail", "server_error");	// 실패
							return gson.toJson(object);	
						}
						
					}else {
						object.addProperty("fail", "server_error");	// 실패
						return gson.toJson(object);	
					}
					
				}else {
					// 이미 클래스가 꽉찼거나 클래스가 없는경우
					object.addProperty("fail", "none_class");
					return gson.toJson(object);
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	/* 클래스 입장 ( class_unit_list 컬럼 가져오기 ) */
	@ResponseBody
	@RequestMapping(value = "/get_class_unit_list", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String get_class_unit_list(Locale locale, HttpServletRequest request) {
		
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

				/* class_code에 해당하는 class_list테이블의 class_unit_list 컬럼값 반환 */
				String result = student_class_service.Get_Class_Unit_List(class_code);
				
				if(result != null) {
					object.addProperty("success", result);
					object.addProperty("student_token", student_token);
					return gson.toJson(object);	
				}else {
					object.addProperty("fail", "none_class_unit_list");	// 해당 클래스가 없을때
					return gson.toJson(object);	
				}		
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	/* 컨텐츠 가져오기 */
	@ResponseBody
	@RequestMapping(value = "/get_content_list", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String get_content_list(Locale locale, HttpServletRequest request) {
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String content_code = request.getParameter("content_code");
		
		ObjectMapper obm  = new ObjectMapper();
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && content_code != null) {
		
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				Content_List_VO result = (Content_List_VO)student_class_service.Get_Content_List(content_code);
				if(result == null) {
					object.addProperty("fail", "none_content");
					return gson.toJson(object);
				}else {
					try {
						object.addProperty("success", obm.writeValueAsString(result));
						object.addProperty("student_token", student_token);
						return gson.toJson(object);	
					} catch (JsonProcessingException e) {
						object.addProperty("fail", "server_error");	// 실패
						return gson.toJson(object);
					}
				}
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	
	
	
	
}
