package kr.co.onpe;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import kr.co.onpe.security.JwtTokenProvider;
import kr.co.onpe.service.Student_Community_Service;
import kr.co.onpe.vo.Class_Community_VO;
import kr.co.onpe.vo.Student_Message_VO;

@Controller
@RequestMapping("/app/community/*")
public class AppCommunityController {

	private static final Logger logger = LoggerFactory.getLogger(AppCommunityController.class);
	
	/* 사용자 정보 테이블(student_information) 테이블 관련 서비스 */
	@Inject
	private Student_Community_Service student_information_service;
	
	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
	/* 커뮤니티에 사용될 이미지들 or PDF들의 저장경로 */
    @Resource(name="Student_Community_uploadPath")
    String Student_Community_uploadPath;
    
    
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
    
	
	/* 사용자 메세지목록 가져오기 */
	@ResponseBody
	@RequestMapping(value = "/get_student_message_list", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String get_student_message_List(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String student_class_code = request.getParameter("student_class_code");	
		
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();

		if(student_id != null && student_token != null && student_class_code != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				List student_message_objs =	student_information_service.Get_Student_Message_List(student_id, student_class_code);		

				ObjectMapper mapper = new ObjectMapper();
				
				try { 
					
					Map<String, Object> data = new HashMap<String, Object>();
					data.put("success", student_message_objs);
					data.put("student_token", student_token);
					
					return mapper.writeValueAsString(data);
					
				} catch (JsonProcessingException e) {
					e.printStackTrace();
					object.addProperty("fail", "server_error");
					return gson.toJson(object);
				}
			}
			
		}
		
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}
	
	/* 사용자 메세지 가져오기 */
	@ResponseBody
	@RequestMapping(value = "/get_student_message", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String get_student_message(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String message_number = request.getParameter("message_number");
		
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();

		if(student_id != null && student_token != null && message_number != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				Student_Message_VO student_message_objs = student_information_service.Get_Student_Message(student_id, message_number);		

				ObjectMapper mapper = new ObjectMapper();
				
				try { 
					
					Map<String, Object> data = new HashMap<String, Object>();
					data.put("success", student_message_objs);
					data.put("student_token", student_token);
					
					return mapper.writeValueAsString(data);
					
				} catch (JsonProcessingException e) {
					e.printStackTrace();
					object.addProperty("fail", "server_error");
					return gson.toJson(object);
				}
			}
			
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}
	
	/* 사용자 메세지 전송 */
	@ResponseBody
	@RequestMapping(value = "/send_student_message", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String send_student_message(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String student_name = request.getParameter("student_name");
		String student_class_code = request.getParameter("student_class_code");
		String student_message_title = request.getParameter("student_message_title");
		String student_message_text = request.getParameter("student_message_text");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();

		if(student_id != null && student_token != null && student_name != null && student_class_code != null && student_message_title != null && student_message_text != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
				format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date time = new Date();
				String time_number = format.format(time);
				
				boolean result = student_information_service.Send_Student_Message(student_class_code, student_message_title, student_message_text, time_number, student_id, student_name);
				
				if(result) {
					object.addProperty("success", "success_send"); // 성공
					object.addProperty("student_token", student_token);
					return gson.toJson(object);	
				}else {
					object.addProperty("fail", "server_error");	// 실패
					return gson.toJson(object);	
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	/* 사용자 메세지 수정 */
	@ResponseBody
	@RequestMapping(value = "/update_student_message", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String update_student_message(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String student_message_title = request.getParameter("student_message_title");
		String student_message_text = request.getParameter("student_message_text");
		String student_message_number = request.getParameter("student_message_number");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();

		if(student_id != null && student_token != null && student_message_title != null && student_message_text != null && student_message_number != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				boolean result = student_information_service.Update_Student_Message(student_id, student_message_number, student_message_title, student_message_text);
				
				if(result) {
					object.addProperty("success", "success_change"); // 성공
					object.addProperty("student_token", student_token);
					return gson.toJson(object);	
				}else {
					object.addProperty("fail", "server_error");	// 실패
					return gson.toJson(object);	
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	/* 사용자 메세지 삭제 */
	@ResponseBody
	@RequestMapping(value = "/delete_student_message", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String delete_student_message(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String student_message_number = request.getParameter("student_message_number");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();

		if(student_id != null && student_token != null && student_message_number != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				boolean result = student_information_service.Delete_Student_Message(student_id, student_message_number);
				
				if(result) {
					object.addProperty("success", "success_delete"); // 성공
					object.addProperty("student_token", student_token);
					return gson.toJson(object);	
				}else {
					object.addProperty("fail", "server_error");	// 실패
					return gson.toJson(object);	
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	/* 사용자 FAQ 목록 가져오기 */
	@ResponseBody
	@RequestMapping(value = "/get_student_faq", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String get_student_faq(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();

		if(student_id != null && student_token != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				List student_faq_objs =	student_information_service.Get_FAQ();		

				ObjectMapper mapper = new ObjectMapper();
				
				try { 
					
					Map<String, Object> data = new HashMap<String, Object>();
					data.put("success", student_faq_objs);
					data.put("student_token", student_token);
					
					return mapper.writeValueAsString(data);
					
				} catch (JsonProcessingException e) {
					e.printStackTrace();
					object.addProperty("fail", "server_error");
					return gson.toJson(object);
				}
			}
			
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}

	/* 사용자 콘텐츠관 목록 가져오기 */
	@ResponseBody
	@RequestMapping(value = "/get_student_content_list_admin", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String get_student_content_list_admin(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();

		if(student_id != null && student_token != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				List student_faq_objs =	student_information_service.Get_Content_List_Admin();		

				ObjectMapper mapper = new ObjectMapper();
				
				try { 
					
					Map<String, Object> data = new HashMap<String, Object>();
					data.put("success", student_faq_objs);
					data.put("student_token", student_token);
					
					return mapper.writeValueAsString(data);
					
				} catch (JsonProcessingException e) {
					e.printStackTrace();
					object.addProperty("fail", "server_error");
					return gson.toJson(object);
				}
			}
			
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}
	
	/* 사용자 소식목록 가져오기 */
	@ResponseBody
	@RequestMapping(value = "/get_student_notice_list", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String get_student_notice_list(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String student_class_code = request.getParameter("student_class_code");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && student_class_code != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				List student_message_objs =	student_information_service.Get_Notice_List(student_class_code);		

				ObjectMapper mapper = new ObjectMapper();
				
				try { 
					
					Map<String, Object> data = new HashMap<String, Object>();
					data.put("success", student_message_objs);
					data.put("student_token", student_token);
					
					return mapper.writeValueAsString(data);
					
				} catch (JsonProcessingException e) {
					e.printStackTrace();
					object.addProperty("fail", "server_error");
					return gson.toJson(object);
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}

	
	/* 학급 커뮤니티 리스트 가져오기 */
	@ResponseBody
	@RequestMapping(value = "/get_student_community_list", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String get_student_community_list(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String student_class_code = request.getParameter("student_class_code");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && student_class_code != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				List student_message_objs =	student_information_service.Get_Class_Community_List(student_class_code);		

				ObjectMapper mapper = new ObjectMapper();
				
				try { 
					
					Map<String, Object> data = new HashMap<String, Object>();
					data.put("success", student_message_objs);
					data.put("student_token", student_token);
					
					return mapper.writeValueAsString(data);
					
				} catch (JsonProcessingException e) {
					e.printStackTrace();
					object.addProperty("fail", "server_error");
					return gson.toJson(object);
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}

	
	/* 학급 커뮤니티 하나 가져오기 */
	@ResponseBody
	@RequestMapping(value = "/get_student_community", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String get_student_community(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String community_number = request.getParameter("community_number");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && community_number != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				Class_Community_VO student_message_objs = student_information_service.Get_Class_Community(community_number);		

				ObjectMapper mapper = new ObjectMapper();
				
				try { 
					
					Map<String, Object> data = new HashMap<String, Object>();
					data.put("success", student_message_objs);
					data.put("student_token", student_token);
					
					return mapper.writeValueAsString(data);
					
				} catch (JsonProcessingException e) {
					e.printStackTrace();
					object.addProperty("fail", "server_error");
					return gson.toJson(object);
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	
	
	/* 학급 커뮤니티 작성 */
	@ResponseBody
	@RequestMapping(value = "/create_student_community", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String create_student_community(Locale locale, MultipartHttpServletRequest request) {
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String student_class_code = request.getParameter("student_class_code");
		String student_name = request.getParameter("student_name");
		String community_title = request.getParameter("community_title");
		String community_text = request.getParameter("community_text");
		SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
		format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
		Date time = new Date();
		String community_date = format.format(time);
		String community_file_name[] = request.getParameterValues("community_file_name");
		String community_file1 = null;
		String community_file2 = null;
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && student_class_code != null && student_name != null && community_title != null && community_text != null) {
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				try {
					List<MultipartFile> fileList = request.getFiles("community_file[]");
					if(fileList.size() != 0) {
						if(fileList.get(0).getSize() != 0){
							for(MultipartFile this_file : fileList) {
								String fileName = this_file.getOriginalFilename();
								System.out.println("파일명 : " + fileName);
								//확장자 체크 ( IMAGE or PDF )
								if(!kr.co.onpe.common.common.checkImageorPdfType(fileName)) {
						    		object.addProperty("fail", "not_image_or_pdf");
						    		return gson.toJson(object);
								}
							}
							
							
							int fileNameIndex = 0;
							for(MultipartFile this_file : fileList) {
								
								File target = new File(Student_Community_uploadPath, community_file_name[fileNameIndex]);	//파일명
								
								//경로 생성
						        if ( ! new File(Student_Community_uploadPath).exists()) {
						        	new File(Student_Community_uploadPath).mkdirs();
						    	}
						        
						        //파일 복사
						        try {
						            FileCopyUtils.copy(this_file.getBytes(), target);
						            
						            if(fileNameIndex == 0) {
						            	community_file1 = "/resources/community_file/" + community_file_name[fileNameIndex];
						            }else if(fileNameIndex == 1){
						            	community_file2 = "/resources/community_file/" + community_file_name[fileNameIndex];
						            }
						            
						        } catch(Exception e) {
						            e.printStackTrace();
						    		object.addProperty("fail", "server_error");
						    		return gson.toJson(object);
						        }
								
								fileNameIndex++;
							}
						}
					}
					
				}catch(Exception e) {
					System.out.println(e);
				}
				
				
				boolean return_qry = student_information_service.Create_Class_Community(student_class_code, student_id, student_name, community_title, community_text, community_date, community_file1, community_file2);
				
				if(return_qry) {
					object.addProperty("success", "success_create"); // 변경 성공
					object.addProperty("student_token", student_token);
					return gson.toJson(object);	
				}else {
					object.addProperty("fail", "server_error");	// 변경 실패
					return gson.toJson(object);	
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	/* 학급 커뮤니티 삭제(id + community_number) */
	@ResponseBody
	@RequestMapping(value = "/delete_student_community", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String delete_student_community(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String community_number = request.getParameter("community_number");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();

		if(student_id != null && student_token != null && community_number != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				try {
					Class_Community_VO class_community = student_information_service.Get_My_Class_Community(community_number, student_id);
					String file1 = class_community.getCommunity_file1();
					String file2 = class_community.getCommunity_file2();
					if(file1 != null) {
						File delete_file = new File(file1);
						if(delete_file.exists()) {
							delete_file.delete();							
						}	
					}
					
					if(file2 != null) {
						File delete_file = new File(file2);
						if(delete_file.exists()) {
							delete_file.delete();							
						}	
					}
					
					boolean result = student_information_service.Delete_Class_Community(community_number, student_id);
					
					if(result) {
						object.addProperty("success", "success_delete"); // 성공
						object.addProperty("student_token", student_token);
						return gson.toJson(object);	
					}else {
						object.addProperty("fail", "server_error");	// 실패
						return gson.toJson(object);	
					}
				}catch(Exception e) {
					System.out.println(e);
				}				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	/* 학급 커뮤니티 수정(id + community_number), 댓글수 증가 or 감소 */
	@ResponseBody
	@RequestMapping(value = "/update_student_community", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String update_student_community(Locale locale, MultipartHttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String community_title = request.getParameter("community_title");
		String community_text = request.getParameter("community_text");
		String community_number = request.getParameter("community_number");
		
		String community_file1 = request.getParameter("community_file1"); //community_file1 컬럼에 들어갈 파일명
		if(community_file1 != null && community_file1.length() > 3) {
			community_file1 = "/resources/community_file/" + community_file1;
		}else {
			community_file1 = null;
		}
		String community_file2 = request.getParameter("community_file2"); //community_file2 컬럼에 들어갈 파일명
		if(community_file2 != null && community_file2.length() > 3) {
			community_file2 = "/resources/community_file/" + community_file2;
		}else {
			community_file2 = null;
		}
		
		String community_file_insert_name[] = request.getParameterValues("community_file_insert_name");	//신규 파일 이름
		String community_file_delete_name[] = request.getParameterValues("community_file_delete_name");	//삭제시킬 파일명
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		
		// 파일을 실제 소유하고있는지 확인
		if(community_file_delete_name != null) {
			for(int x=0;x<community_file_delete_name.length;x++) {
				if(community_file_delete_name[x].length() > 3) {
					if(!student_information_service.Class_Community_Is_Your_File(community_number, student_id, "/resources/community_file/" +community_file_delete_name[x])) {
						object.addProperty("fail", "is_not_yours");
						return gson.toJson(object);	
					}					
				}
			}
		}
		
		if(student_id != null && student_token != null&& community_title != null && community_text != null && community_number != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				try {
					List<MultipartFile> fileList = request.getFiles("community_new_file[]");
					if(fileList.size() != 0) {
						if(fileList.get(0).getSize() != 0){
							for(MultipartFile this_file : fileList) {
								String fileName = this_file.getOriginalFilename();
								//확장자 체크 ( IMAGE or PDF )
								if(!kr.co.onpe.common.common.checkImageorPdfType(fileName)) {
						    		object.addProperty("fail", "not_image_or_pdf");
						    		return gson.toJson(object);
								}
							}
						}
						
						int fileNameIndex = 0;
						for(MultipartFile this_file : fileList) {
							
							if(community_file_insert_name[fileNameIndex] != null && community_file_insert_name[fileNameIndex].length() > 3) {
								File target = new File(Student_Community_uploadPath, community_file_insert_name[fileNameIndex]);	//파일명
								
								//경로 생성
						        if ( ! new File(Student_Community_uploadPath).exists()) {
						        	new File(Student_Community_uploadPath).mkdirs();
						    	}
						        
						        //파일 복사
						        try {
						            FileCopyUtils.copy(this_file.getBytes(), target);
						            
						        } catch(Exception e) {
						            e.printStackTrace();
						    		object.addProperty("fail", "server_error");
						    		return gson.toJson(object);
						        }
								
								fileNameIndex++;
							}
							

						}
						
					}
				}catch(Exception e){
					System.out.println(e);
				}
				
				boolean return_qry = student_information_service.Update_Class_Community(community_number, student_id, community_title, community_text, community_file1, community_file2);
				
				if(return_qry) {
					/* db변경됬으니 삭제파일이 존재하다면 삭제하기 */
					if(community_file_delete_name != null) {
						for(int x=0;x<community_file_delete_name.length;x++) {
							if(community_file_delete_name[x].length() > 3) {
								File delete_file = new File(Student_Community_uploadPath + "/" + community_file_delete_name[x]);
								if(delete_file.exists()) {
									delete_file.delete();							
								}	
							}
						}
					}
					
					object.addProperty("success", "success_change"); // 변경 성공
					object.addProperty("student_token", student_token);
					
					return gson.toJson(object);	
				}else {
					object.addProperty("fail", "server_error");	// 변경 실패
					return gson.toJson(object);	
				}
				
			}
		}
		
		
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	
	
	/* 학급 커뮤니티 댓글 리스트 가져오기 */
	@ResponseBody
	@RequestMapping(value = "/get_student_community_comment_list", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String get_student_community_comment_list(Locale locale, HttpServletRequest request) {		
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String community_number = request.getParameter("community_number");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && community_number != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				List student_message_objs =	student_information_service.Get_Class_Community_Comment(community_number);		

				ObjectMapper mapper = new ObjectMapper();
				
				try { 
					
					Map<String, Object> data = new HashMap<String, Object>();
					data.put("success", student_message_objs);
					data.put("student_token", student_token);
					
					return mapper.writeValueAsString(data);
					
				} catch (JsonProcessingException e) {
					e.printStackTrace();
					object.addProperty("fail", "server_error");
					return gson.toJson(object);
				}
				
			}
		}
		
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	/* 학급 커뮤니티 댓글 작성 */
	@ResponseBody
	@RequestMapping(value = "/create_student_community_comment_list", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String create_student_community_comment_list(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String student_name = request.getParameter("student_name");
		String community_number = request.getParameter("community_number");
		String comment_content = request.getParameter("comment_content");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();

		if(student_id != null && student_token != null && student_name != null && comment_content != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
				format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date time = new Date();
				String time_number = format.format(time);
				
				boolean result = student_information_service.Create_Class_Community_Comment(community_number, student_id, student_name, comment_content, time_number);
				
				if(result) {
					object.addProperty("success", "success_create"); // 성공
					object.addProperty("student_token", student_token);
					return gson.toJson(object);	
				}else {
					object.addProperty("fail", "server_error");	// 실패
					return gson.toJson(object);	
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
	
	/* 학급 커뮤니티 댓글 삭제(id + community_number + comment_number) */
	@ResponseBody
	@RequestMapping(value = "/delete_student_community_comment_list", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String delete_student_community_comment_list(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String comment_number = request.getParameter("comment_number");
		String community_number = request.getParameter("community_number");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();

		if(student_id != null && student_token != null && comment_number != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				boolean result = student_information_service.Delete_Class_Community_Comment(comment_number, student_id, community_number);
				
				if(result) {
					object.addProperty("success", "success_delete"); // 성공
					object.addProperty("student_token", student_token);
					return gson.toJson(object);	
				}else {
					object.addProperty("fail", "server_error");	// 실패
					return gson.toJson(object);	
				}
				
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
		
	}
}
