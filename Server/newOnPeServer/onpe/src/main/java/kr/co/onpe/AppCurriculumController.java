package kr.co.onpe;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

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
import com.google.gson.reflect.TypeToken;

import kr.co.onpe.security.JwtTokenProvider;
import kr.co.onpe.service.Student_Curriculum_Service;

@Controller
@RequestMapping("/app/curriculum/*")
public class AppCurriculumController {
	
	private static final Logger logger = LoggerFactory.getLogger(AppCurriculumController.class);
	
	/* 차시별 커리큘럼 관련 서비스 */
	@Inject
	private Student_Curriculum_Service student_curriculum_service;
	
	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
	
	
	/* 차시(단원)별 클래스 수업 입장하기 == 만약 수업타입이 1:(맞춤형 수업)일 때는 그룹이므로 여러개의 레코드가 반환된다. , 만약 수업타입이 0:(전체형 수업)일 때는 그룹이 아니므로 하나의 레코드가 반환된다. */
	@ResponseBody
	@RequestMapping(value = "/student_get_curriculum", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String student_get_curriculum(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String class_code = request.getParameter("class_code");
		String unit_code = request.getParameter("unit_code");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && class_code != null && unit_code != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				List Curriculum_Unit_List_Class_VO = student_curriculum_service.Get_Student_Curriculum(class_code, unit_code);
				
				if(Curriculum_Unit_List_Class_VO.size() > 0) {
					
					try {
						
						ObjectMapper mapper = new ObjectMapper();
						
						Map<String, Object> data = new HashMap<String, Object>();
						data.put("success", Curriculum_Unit_List_Class_VO);
						data.put("student_token", student_token);
						
						return mapper.writeValueAsString(data);
					} catch (JsonProcessingException e) {
						object.addProperty("fail", "server_error");
						return gson.toJson(object);
					}
					
				}else {
					object.addProperty("fail", "none_curriculum");
					return gson.toJson(object);
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}
	
	
	
	/* 수업참여 확인하기 (학생번호를 해당 차시별 수업<curriculum_unit_list_class>의 content_participation 컬럼의 JSON 배열에 추가한다.) */
	@ResponseBody
	@RequestMapping(value = "/student_update_participation", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String student_update_participation(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String class_code = request.getParameter("class_code");
		String unit_code = request.getParameter("unit_code");
		String student_number = request.getParameter("student_number");
		String unit_class_type = request.getParameter("unit_class_type");
		String unit_group_name = request.getParameter("unit_group_name");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && class_code != null && unit_code != null && student_number != null && unit_class_type != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				String student_participation = student_curriculum_service.Get_Student_Curriculum_Participation(unit_group_name, unit_code, class_code, unit_class_type);
				
				List<String> student_participation_list = gson.fromJson(student_participation, new TypeToken<List<String>>(){}.getType());
				String jsonarray = null;
				if(student_participation_list != null) {
					if(student_participation_list.contains(student_id)) {
						
						//이미 해당 차시에 존재하는 번호일 경우
						object.addProperty("fail", "already_exist");
						return gson.toJson(object);
						
					}else {
						
						student_participation_list.add(student_id);
						jsonarray = gson.toJson(student_participation_list);
						
					}
				}else {
					student_participation_list = new ArrayList<String>();
					student_participation_list.add(student_id);
					jsonarray = gson.toJson(student_participation_list);
					
				}
				
				boolean result = student_curriculum_service.Update_Student_Curriculum_Participation(unit_class_type, jsonarray, class_code, unit_code, unit_group_name);
				
				if(result) {
					
					object.addProperty("success", "success_change");
					object.addProperty("student_token", student_token);
					return gson.toJson(object);	
					
				}else {
					object.addProperty("fail", "none_curriculum");
					return gson.toJson(object);
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}
	
	
	
	
	
	
	
	
	
	
	/* 최종 과제 제출하기 (학생번호를 해당 차시별 수업<curriculum_unit_list_class>의 content_submit_task 컬럼의 JSON 배열에 추가한다.) */
	@ResponseBody
	@RequestMapping(value = "/student_update_submit_task", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String student_update_submit_task(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String class_code = request.getParameter("class_code");
		String unit_code = request.getParameter("unit_code");
		String student_number = request.getParameter("student_number");
		String unit_class_type = request.getParameter("unit_class_type");
		String unit_group_name = request.getParameter("unit_group_name");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && class_code != null && unit_code != null && student_number != null && unit_class_type != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				String student_participation = student_curriculum_service.Get_Student_Curriculum_Participation(unit_group_name, unit_code, class_code, unit_class_type);
				List<String> student_participation_list = gson.fromJson(student_participation, new TypeToken<List<String>>(){}.getType());
				
				if(student_participation_list != null) {
					
					if(student_participation_list.contains(student_id)) {
						
						String student_submit_task = student_curriculum_service.Get_Student_Curriculum_Submit_Task(unit_group_name, unit_code, class_code, unit_class_type);
						
						List<String> student_submit_task_list = gson.fromJson(student_submit_task, new TypeToken<List<String>>(){}.getType());
						String jsonarray = null;
						
						
						if(student_submit_task_list != null) {
							if(student_submit_task_list.contains(student_id)) {
								
								//이미 해당 차시에 과제를 제출했을 때
								object.addProperty("fail", "already_submit_task");
								return gson.toJson(object);
								
							}else {
								
								student_submit_task_list.add(student_id);
								jsonarray = gson.toJson(student_submit_task_list);
								
							}
						}else {
							student_submit_task_list = new ArrayList<String>();
							student_submit_task_list.add(student_id);
							jsonarray = gson.toJson(student_submit_task_list);
						}
						
						boolean result = student_curriculum_service.Update_Student_Curriculum_Submit_Task(unit_class_type, jsonarray, class_code, unit_code, unit_group_name, student_id);
						
						if(result) {
							
							object.addProperty("success", "success_change");
							object.addProperty("student_token", student_token);
							return gson.toJson(object);	
							
						}else {
							object.addProperty("fail", "none_curriculum");
							return gson.toJson(object);
						}
						
						
					}else {
						
						// 이 사용자는 해당 차시에 참여중인 학생이 아님
						object.addProperty("fail", "none_exist");
						return gson.toJson(object);
						
					}
						
				}else {
					
					//해당 차시에 참여중인 사람이 없음 또는 해당하는 차시가 없음
					object.addProperty("fail", "none_curriculum");
					return gson.toJson(object);
					
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}