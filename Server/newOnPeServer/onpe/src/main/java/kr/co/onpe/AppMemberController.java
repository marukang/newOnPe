package kr.co.onpe;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
import kr.co.onpe.service.Student_Information_Service;
import kr.co.onpe.vo.Common_Message_VO;
import kr.co.onpe.vo.Notice_List_VO;
import kr.co.onpe.vo.Push_List_VO;
import kr.co.onpe.vo.Student_Information_VO;
import net.coobird.thumbnailator.Thumbnailator;

/* APP 사용자용 백엔드 ( push동의 상태 변경 ) */

@Controller
@RequestMapping("/app/member/*")
public class AppMemberController{
	
	private static final Logger logger = LoggerFactory.getLogger(AppMemberController.class);
	
	/* 사용자 정보 테이블(student_information) 테이블 관련 서비스 */
	@Inject
	private Student_Information_Service student_information_service;
	
	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
    @Resource(name="Student_Profile_uploadPath")
    String Student_Profile_uploadPath;
	
	
	/* 사용자 push동의 상태 변경 */
	@ResponseBody
	@RequestMapping(value = "/push_agreement_change", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String push_agreement_change(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String student_push_agreement = request.getParameter("student_push_agreement");	// 1: 동의 , 0: 비동의
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && student_push_agreement != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				if(student_push_agreement.equals("1") || student_push_agreement.equals("0")) {
					
					boolean return_qry = student_information_service.Student_Change_Push_Agreement(student_id, student_push_agreement);
					
					if(return_qry) {
						object.addProperty("success", "success_change"); // 상태 변경 성공
						object.addProperty("student_token", student_token);
						return gson.toJson(object);	
					}else {
						object.addProperty("fail", "server_error");	// 상태 변경 실패
						return gson.toJson(object);	
					}
					
				}else {
					object.addProperty("fail", "student_push_agreement");	//푸시값에 0,1제외한 다른값이 왔을 경우
					return gson.toJson(object);					
				}
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}

	/* 사용자 학급정보 변경 */
	@ResponseBody
	@RequestMapping(value = "/class_information_change", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String class_information_change(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String student_level = request.getParameter("student_level");
		String student_class = request.getParameter("student_class");
		String student_number = request.getParameter("student_number");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && student_level != null && student_class != null && student_number != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				boolean return_qry = student_information_service.Student_Change_Class_Information(student_id, student_level, student_class, student_number);
				
				if(return_qry) {
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

	/* 사용자 기초정보 변경 */
	@ResponseBody
	@RequestMapping(value = "/default_information_change", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String default_information_change(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String student_content = request.getParameter("student_content");
		String student_tall = request.getParameter("student_tall");
		String student_weight = request.getParameter("student_weight");
		String student_age = request.getParameter("student_age");
		String student_sex = request.getParameter("student_sex");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && student_content != null && student_tall != null && student_weight != null && student_age != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				if(student_sex != null) {
					
					if(student_sex.equals("m") || student_sex.equals("f")) {
						boolean return_qry = student_information_service.Student_Change_Default_Information(student_id, student_content, student_tall, student_weight, student_age, student_sex);
						
						if(return_qry) {
							object.addProperty("success", "success_change"); // 변경 성공
							object.addProperty("student_token", student_token);
							return gson.toJson(object);	
						}else {
							object.addProperty("fail", "server_error");	// 변경 실패
							return gson.toJson(object);	
						}
						
					}else {
						object.addProperty("fail", "student_sex");	// 변경 실패
						return gson.toJson(object);	
					}
					
				}else {
					boolean return_qry = student_information_service.Student_Change_Default_Information(student_id, student_content, student_tall, student_weight, student_age, null);
					
					if(return_qry) {
						object.addProperty("success", "success_change"); // 변경 성공
						object.addProperty("student_token", student_token);
						return gson.toJson(object);	
					}else {
						object.addProperty("fail", "server_error");	// 변경 실패
						return gson.toJson(object);	
					}
					
				}
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}

	/* 사용자 프로필 이미지 변경 */
	@ResponseBody
	@RequestMapping(value = "/profile_change", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String profile_change(Locale locale, HttpServletRequest request, MultipartFile file) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();

		System.out.println(file.getName());
		
		if(student_id != null && student_token != null && !file.isEmpty()) {
			
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
					
					File target = new File(Student_Profile_uploadPath, student_id + ".jpg");	//jpg로 통일
			        
			        //경로 생성
			        if ( ! new File(Student_Profile_uploadPath).exists()) {
			        	new File(Student_Profile_uploadPath).mkdirs();
			    	}
			        
			        //파일 복사
			        try {
			        	FileCopyUtils.copy(file.getBytes(), target);
			        	System.out.println(file);
			        	
		            	try {
		            		
		            		// 썸네일 이미지로 변환
		            		if(target.exists()) {
		            			FileOutputStream thumbnail = new FileOutputStream(target);
		            			Thumbnailator.createThumbnail(file.getInputStream(), thumbnail, 250, 250);
		            			thumbnail.close();
		            		}
		            		
		    				boolean return_qry = student_information_service.Student_Change_Profile_Image(student_id, "/resources/student_profile/" + student_id + ".jpg");
		    				
		    				if(return_qry) {
		    					object.addProperty("success", "success_change"); // 변경 성공
		    					object.addProperty("student_token", student_token);
		    					return gson.toJson(object);	
		    				}else {
		    					object.addProperty("fail", "server_error");	// 변경 실패
		    					return gson.toJson(object);	
		    				}
		    				
		    			} catch (IOException e) {
		    				e.printStackTrace();
		            		object.addProperty("fail", "server_error");
		            		return gson.toJson(object);
		    			}
			        	
			        } catch(Exception e) {
			        	e.printStackTrace();
			    		object.addProperty("fail", "server_error");
			    		return gson.toJson(object);
			        }
			        
			        
				}else {
		    		object.addProperty("fail", "not_image");
		    		return gson.toJson(object);
				}
				
			}
		}
		
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}

	/* 사용자 비밀번호 변경 */
	@ResponseBody
	@RequestMapping(value = "/password_information_change", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String password_information_change(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String student_password_before = request.getParameter("student_password_before");
		String student_password_new = request.getParameter("student_password_new");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		if(student_id != null && student_token != null && student_password_before != null && student_password_new != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				try {
					
					String sha256pw_before = kr.co.onpe.common.common.sha256(student_password_before);
					
					Student_Information_VO student_information = student_information_service.Student_Information_for_Login(student_id, sha256pw_before);
					
					if(student_information != null) {
						
						if(kr.co.onpe.common.common.passwordCheck(student_password_new)){	//비밀번호 정규식 확인
							
							/* 비밀번호 암호화 */
							try {
								String sha256pw = kr.co.onpe.common.common.sha256(student_password_new);
							
								if(student_information_service.Student_Change_Password_By_Id(student_id, sha256pw)) {
									
									object.addProperty("success", "success_change"); // 변경 성공
									object.addProperty("student_token", student_token);
									return gson.toJson(object);	
									
								}else {
									object.addProperty("fail", "server_error");
									return gson.toJson(object);	
								}
								
							} catch (NoSuchAlgorithmException e) {	//SHA256 변환 실패
								e.printStackTrace();
								object.addProperty("fail", "server_error");
								return gson.toJson(object);	
							}
							
						}else {
							object.addProperty("fail", "unvalid_password");
							return gson.toJson(object);	
						}
						
					}else {
						object.addProperty("fail", "student_password_before");	// 기존 비밀번호 틀림
						return gson.toJson(object);	
					}
					
				} catch (NoSuchAlgorithmException e) {
					e.printStackTrace();
					object.addProperty("fail", "server_error");
					return gson.toJson(object);	
				}			
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}
	
	
	
	/* 사용자 회원탈퇴 */
	@ResponseBody
	@RequestMapping(value = "/student_resign", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String student_resign(Locale locale, HttpServletRequest request) {
		
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		String student_password = request.getParameter("student_password");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();		
		
		if(student_id != null && student_token != null && student_password != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				try {
					
					String sha256pw = kr.co.onpe.common.common.sha256(student_password);
					
					Student_Information_VO student_information = student_information_service.Student_Information_for_Login(student_id, sha256pw);
					
					if(student_information != null) {
						
						if(student_information_service.Student_Resign(student_id)) {
							object.addProperty("success", "success_resign");
						}else {
							object.addProperty("fail", "fail_resign");
						}
						return gson.toJson(object);
						
					}else {
						object.addProperty("fail", "student_password");	// 기존 비밀번호 틀림
						return gson.toJson(object);	
					}
					
				} catch (NoSuchAlgorithmException e) {
					e.printStackTrace();
					object.addProperty("fail", "server_error");
					return gson.toJson(object);	
				}			
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}
	
	
	
	/* 전체 공지사항, 개별 공지사항, 메시지함 가져오기 */
	@ResponseBody
	@RequestMapping(value = "/get_my_news", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String get_my_news(Locale locale, HttpServletRequest request) {
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		String type = request.getParameter("type");
		String student_id = request.getParameter("student_id");
		String student_token = request.getParameter("student_token");
		
		if(type != null && student_id != null && student_token != null) {
			
			student_token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", student_token);
			if(student_token.equals("fail")) {
				object.addProperty("fail", "token_authentication_fail");	// 사용자 아이디와 토큰 내부 아이디 불일치
				return gson.toJson(object);
			}else if(student_token.equals("expired")) {
				object.addProperty("fail", "token_expired");	//토큰 만료시간 지남
				return gson.toJson(object);
			}else {
				
				if(type.equals("message")) {
					
					if(student_information_service.Update_Student_News_State(student_id)) {
						try {
							List<Common_Message_VO> message = student_information_service.Get_Common_Message(student_id);
							ObjectMapper mapper = new ObjectMapper();
							Map<String, Object> data = new HashMap<String, Object>();
							data.put("success", message);
							data.put("student_token", student_token);
							return mapper.writeValueAsString(data);
						} catch (JsonProcessingException e) {
							object.addProperty("fail", "server_error");
							return gson.toJson(object);
						}
					}else {
						object.addProperty("fail", "server_error");
						return gson.toJson(object);
					}
					
				}else if(type.equals("notice")) {
					
					String class_code = request.getParameter("class_code");
					
					if(class_code != null) {
						
						if(student_information_service.Update_Student_News_State(student_id)) {
							try {
								List<Notice_List_VO> notice = student_information_service.Get_Notice_List(class_code);
								ObjectMapper mapper = new ObjectMapper();
								Map<String, Object> data = new HashMap<String, Object>();
								data.put("success", notice);
								data.put("student_token", student_token);
								return mapper.writeValueAsString(data);
							} catch (JsonProcessingException e) {
								object.addProperty("fail", "server_error");
								return gson.toJson(object);
							}
						}else {
							object.addProperty("fail", "server_error");
							return gson.toJson(object);
						}
					}else {
						object.addProperty("fail", "access_denied");
						return gson.toJson(object);	
					}
					
				}else if(type.equals("push")) {
					if(student_information_service.Update_Student_News_State(student_id)) {
						try {
							List<Push_List_VO> push = student_information_service.Get_Push_List();
							ObjectMapper mapper = new ObjectMapper();
							Map<String, Object> data = new HashMap<String, Object>();
							data.put("success", push);
							data.put("student_token", student_token);
							return mapper.writeValueAsString(data);
						} catch (JsonProcessingException e) {
							object.addProperty("fail", "server_error");
							return gson.toJson(object);
						}
					}else {
						object.addProperty("fail", "server_error");
						return gson.toJson(object);
					}				
				}else {
					object.addProperty("fail", "access_denied");
					return gson.toJson(object);
				}
				
			}			
		}else {
			object.addProperty("fail", "access_denied");
			return gson.toJson(object);
		}
	}
}
