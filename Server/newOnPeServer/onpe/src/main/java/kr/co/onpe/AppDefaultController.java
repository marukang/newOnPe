package kr.co.onpe;

import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Properties;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.apache.http.util.TextUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import kr.co.onpe.security.JwtTokenProvider;
import kr.co.onpe.service.Student_Information_Service;
import kr.co.onpe.vo.Student_Information_VO;

/* APP 사용자용 백엔드 ( 로그인, 회원가입, 아이디찾기, 비밀번호 찾기, 아이디 중복 확인, 이메일 인증, 토큰로그인 ) */

@Controller
@RequestMapping("/app/*")
public class AppDefaultController {
	
	private static final Logger logger = LoggerFactory.getLogger(AppDefaultController.class);
	
	/* root-context.xml에 등록한 Bean 호출 ( 의존성 주입 **Autowired ) */
	@Autowired
	@Resource(name="mailSender")
	private JavaMailSender mailSender;
	
	/* 사용자 정보 테이블(student_information) 테이블 관련 서비스 */
	@Inject
	private Student_Information_Service student_information_service;
	
	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
	
	/* 앱 로그인시도시 사용자 정보 조회(비밀번호 암호화 사용) 및 access token을 신규 발급하여 사용자 정보와 함께 반환해준다. */
	@ResponseBody
	@RequestMapping(value = "/sns_login", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String sns_login(Locale locale, HttpServletRequest request) 
	{
		ObjectMapper obm  = new ObjectMapper();
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		String student_id = request.getParameter("student_id");
		String accessToken = request.getParameter("student_token");
		String fcmtoken = request.getParameter("fcmtoken");
		String loginType = request.getParameter("loginType");
		
		String student_email = request.getParameter("student_email");
		String student_push_agreement = request.getParameter("student_push_agreement");
		String student_phone_number = request.getParameter("student_phone_number");

		System.out.println(">> (staging) snsLogin 사용자 아디 : " + student_id);
		System.out.println(">> (staging) snsLogin 사용자 accessToken : " + accessToken);
		System.out.println(">> (staging) snsLogin 사용자 fcmtoken : " + fcmtoken);
		System.out.println(">> (staging) snsLogin 사용자 loginType : " + loginType);
		System.out.println(">> (staging) snsLogin 사용자 student_phone_number : " + student_phone_number);
		System.out.println(">> (staging) snsLogin -----------------------");
		
		//토큰 로그인 ( 자동로그인 )
		if (!TextUtils.isEmpty(accessToken)) 
		{
			accessToken = jwtTokenProvider.TokenCheck(student_id, "STUDENT", accessToken);
			System.out.println(">> snsLogin 사용자 accessToken 결과 : " + accessToken);
			
			if (accessToken.equals("fail")) 
			{
				object.addProperty("fail", "token_authentication_fail");
				return gson.toJson(object);
			} 
			else if(accessToken.equals("expired")) 
			{
				object.addProperty("fail", "token_expired");
				return gson.toJson(object);
			} 
			else 
			{
				Student_Information_VO student_information = student_information_service.Student_Information_for_Auto_login(student_id);
				student_information.access_token = accessToken;
				student_information_service.Update_Student_Token(student_id, fcmtoken);
				
				try 
				{
					String returnStr = obm.writeValueAsString(student_information);
					
					return returnStr;
				} 
				catch (JsonProcessingException e) 
				{
					e.printStackTrace();
					object.addProperty("fail", "server_error");
					
					return gson.toJson(object);
				}								
			}
		}
		else if(!TextUtils.isEmpty(student_id)) 
		{
			
			try // upsert 를 통해 가입
			{
				/* 현재 시간 */
				Date time = new Date();
				
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat ( "yyyyMMddHHmmss");
				simpleDateFormat.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				String time_number = simpleDateFormat.format(time);
				
				if (!student_information_service.Id_Overlap_Check(student_id)) 
				{
				
					boolean result = student_information_service.Create_Student_snsInformation(student_id, "N/A", student_email, student_push_agreement, time_number, student_phone_number, fcmtoken, loginType);
					
					if (result)
					{
						String createdToken = jwtTokenProvider.createToken(student_id, "STUDENT");
						
						Student_Information_VO student_information = student_information_service.Student_Information_for_Auto_login(student_id, loginType);
						student_information.access_token = createdToken;
						System.out.println(">> snsLogin 사용자 (1) returnStr : " + obm.writeValueAsString(student_information));
						System.out.println(">> snsLogin 사용자 (1) createdToken : " + createdToken);
						System.out.println(">> snsLogin -----------------------");
						return obm.writeValueAsString(student_information);
					}
					else
					{
						object.addProperty("fail", "server_error");
						return gson.toJson(object);	
					}
				}
				else 
				{
					String createdToken = jwtTokenProvider.createToken(student_id, "STUDENT");
					
					Student_Information_VO student_information = student_information_service.Student_Information_for_Auto_login(student_id, loginType);
					student_information.access_token = createdToken;
					System.out.println(">> snsLogin 사용자 (2) returnStr : " + obm.writeValueAsString(student_information));
					System.out.println(">> snsLogin 사용자 (2) createdToken : " + createdToken);
					System.out.println(">> snsLogin -----------------------");
					return obm.writeValueAsString(student_information);									
				}
			}
			catch (Exception e) 
			{
				e.printStackTrace();
				System.out.println(">> (staging) snsLogin error (2) ");
				
				object.addProperty("fail", "server_error");
				return gson.toJson(object);
			}
		}
		object.addProperty("fail", "access_denied");
		
		System.out.println(">> (staging) snsLogin error (3) ");
		
		return gson.toJson(object);	
	}
	
	/* 앱 로그인시도시 사용자 정보 조회(비밀번호 암호화 사용) 및 access token을 신규 발급하여 사용자 정보와 함께 반환해준다. */
	@ResponseBody
	@RequestMapping(value = "/login", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String login(Locale locale, HttpServletRequest request) {
		
		ObjectMapper obm  = new ObjectMapper();
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		String student_id = request.getParameter("student_id");
		String student_password = request.getParameter("student_password");
		String token = request.getParameter("student_token");
		String fcmtoken = request.getParameter("fcmtoken");
		
		System.out.println(">> (staging) login 사용자 아디 : " + student_id);
		System.out.println(">> (staging) login 사용자 비번 : " + student_password);
		System.out.println(">> (staging) login 사용자 token : " + token);
		System.out.println(">> (staging) login 사용자 fcmtoken : " + fcmtoken);
		System.out.println(">> (staging) login -----------------------");

		//토큰 로그인 ( 자동로그인 )
		if (!TextUtils.isEmpty(token)) 
		{
			token = jwtTokenProvider.TokenCheck(student_id, "STUDENT", token);
			
			if (token.equals("fail")) 
			{
				object.addProperty("fail", "token_authentication_fail");
				return gson.toJson(object);
			} 
			else if(token.equals("expired")) 
			{
				object.addProperty("fail", "token_expired");
				return gson.toJson(object);
			} 
			else 
			{
				Student_Information_VO student_information = student_information_service.Student_Information_for_Auto_login(student_id);
				student_information.access_token = token;
				student_information_service.Update_Student_Token(student_id, fcmtoken);
				
				System.out.println(">> (staging) login 사용자 student_login_type : " + student_information.student_login_type);
				System.out.println(">> (staging) login -----------------------");
				try 
				{
					String returnStr = obm.writeValueAsString(student_information);
					return returnStr;
				} 
				catch (JsonProcessingException e) 
				{
					e.printStackTrace();
					object.addProperty("fail", "server_error");
					return gson.toJson(object);
				}								
			}
		}
		else if(student_id != null && student_password != null) 
		{
			//매개변수 확인
			try 
			{
				String sha256pw = kr.co.onpe.common.common.sha256(student_password);
				//sha256 변환 성공여부 확인
				if(!sha256pw.equals("fail")) 
				{
//					System.out.println("사용자 아디 : " + student_id);
//					System.out.println("사용자 비번 : " + student_password);
//					System.out.println("사용자 비번암호화 : " + sha256pw);
					try {
						Student_Information_VO student_information = student_information_service.Student_Information_for_Login(student_id, sha256pw);
						
						//DB에 사용자 정보가 있는지 확인
						if (student_information != null) 
						{
							String createToken = jwtTokenProvider.createToken(student_id, "STUDENT");
							
							//토큰 정상 발급되었는지 확인
							if (!createToken.equals("fail")) 
							{
								student_information.access_token = createToken;
								student_information_service.Update_Student_Token(student_id, fcmtoken);
								String returnStr = obm.writeValueAsString(student_information);
								return returnStr;									
							}else {
//								System.out.println("토큰발급 실패");
								
								object.addProperty("fail", "token_issue");
								return gson.toJson(object);
							}
						}else {
//							System.out.println("사용자 없음");
							object.addProperty("fail", "null_user");
							return gson.toJson(object);
						}
						
					} catch (Exception e) {
						 e.printStackTrace();
						 object.addProperty("fail", "server_error");
						 return gson.toJson(object);
					}
				}
				
			} catch (Exception e) {
				e.printStackTrace();
				object.addProperty("fail", "server_error");
				return gson.toJson(object);
			}
		}
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);		
	}

	
	/* 사용자 중복확인 체크 존재한다면 y 없다면 n */
	@ResponseBody
	@RequestMapping(value = "/id_overlap_check", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String id_overlap_check(Locale locale, HttpServletRequest request) {
		String student_id = request.getParameter("student_id");
		
		System.out.println(">> (staging) id_overlap_check 사용자 student_id : " + student_id);
		System.out.println(">> (staging) id_overlap_check -----------------------");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		if(student_id != null) {
			boolean result =  student_information_service.Id_Overlap_Check(student_id);
			
			System.out.println(">> (staging) id_overlap_check result : " + result);
			System.out.println(">> (staging) id_overlap_check -----------------------");
			
			if (result) 
			{
				object.addProperty("success", "y");
				return gson.toJson(object);
			}
			else 
			{
				object.addProperty("success", "n");
				return gson.toJson(object);
			}
			
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}

	/* 이메일 인증코드 발급 ( 매개변수로 전달받은 이메일로 코드 전송 ) */
	@ResponseBody
	@RequestMapping(value = "/email_authentication", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String send_mail(Locale locale, HttpServletRequest request) {
		
		String email = request.getParameter("student_email");
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		//////////////////////////////////////// 메일전송 테스트 ////////////////////////////////////////
		/*
		 * < 로직 >
		 * 1. 이메일 인증신청이 올 경우 DB에 받는사람 email과 인증번호를 저장한다.
		 * 2. 인증번호가 포함된 이메일을 받는사람에게 보낸다.
		 * 3. 회원가입 신청이 올 경우 해당 DB에 받는사람 email로 조회 후 저장된 인증번호화 넘어온 인증번호를 체크한다.
		 * 4. DB에 저장된 인증번호화 넘어온 인증번호가 같을 경우에는 회원가입을 진행한다. 만약 인증번호가 다를 경우에는 회원가입을 진행하지 않는다. 
		*/
		
		if(email != null) {
			if(kr.co.onpe.common.common.isValidEmail(email)) {
				if(!student_information_service.Email_Overlap_Check(email)) {
					
					// 메일 제목
					String subject = "온체육 회원가입 인증번호";
					// 보내는 사람
					String from ="온체육 <complexionco@naver.com>";
					// 받는 사람
					String to = email;
					// 인증 번호
					String certinumber = kr.co.onpe.common.common.numberGen(6,1);
					
					// 인증받을 이메일과 인증번호를 DB에 저장한다.
					boolean queryResult = student_information_service.Create_Student_Email_Authentication_Code(to, certinumber);
					
					if(queryResult) {
						try {
							// 메일 내용 넣을 객체와, 이를 도와주는 Helper 객체 생성
							MimeMessage mail = mailSender.createMimeMessage();
				            MimeMessageHelper mailHelper = new MimeMessageHelper(mail,true,"UTF-8");

							// 메일 내용을 채워줌
							mailHelper.setFrom(from);	// 보내는 사람 셋팅
							mailHelper.setTo(to);		// 받는 사람 셋팅
							mailHelper.setSubject(subject);	// 제목 셋팅
							mailHelper.setText("<div style='width:100%; padding:20px 0; text-align:center;'><div style='vertical-align:center; display:inline-block; width:200px; padding:30px 5px;'>" +
									"<div style='float:left; width:100%; text-align:center; font-size:22px; font-weight:bold;'>온체육 이메일 인증</div>" +
									"<div style='float:left; margin:10px 0; border-top:3px solid; width:100%; height:1px;'></div>" +
									"<div style='float:left; width:100%; text-align:center; font-size:18px; font-weight:bold;'>인증번호 : "+ certinumber +"</div></div></div>", true);	// 내용 셋팅

							// 메일 전송
							mailSender.send(mail);
							
							object.addProperty("success", certinumber);
							return gson.toJson(object);
							
						} catch(Exception e) {
							e.printStackTrace();
							object.addProperty("fail", "server_error");
							return gson.toJson(object);
						}
					}else {
						object.addProperty("fail", "server_error");
						return gson.toJson(object);
					}
					
				}else {
					object.addProperty("fail", "email_overlap");
					return gson.toJson(object);
				}
			}else {
				object.addProperty("fail", "unvalid_email");
				return gson.toJson(object);
			}
		}		
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}

	/* 사용자 회원가입 ( 아이디, 이름, 비밀번호, 이메일, 인증번호, 푸쉬동의(y,n) */
	@ResponseBody
	@RequestMapping(value = "/sign_up", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String sign_up(Locale locale, HttpServletRequest request) {
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		/*
		 * 전달받은 인증번호와 이메일로 email_authentication을 조회해야함
		 *  - 조회한 결과가 null일 경우 메일 인증로직을 거치지 않았기 때문에 access denied
		 *  - 조회한 결과의 인증코드와 전달받은 POST 매개변수 인증코드가 같지 않을경우 access denied
		 * 
		 * */
		
		String student_id = request.getParameter("student_id");
		String student_name = request.getParameter("student_name");
		String student_password = request.getParameter("student_password");
		String student_email = request.getParameter("student_email");
		String authentication_code = request.getParameter("authentication_code");
		String student_push_agreement = request.getParameter("student_push_agreement");
		String student_device_token = request.getParameter("student_device_token");
		String student_phone_number = request.getParameter("student_phone_number");
		
		System.out.println(">> (staging) sign_up 사용자 student_id : " + student_id);
		System.out.println(">> (staging) sign_up 사용자 student_name : " + student_name);
		System.out.println(">> (staging) sign_up 사용자 student_password : " + student_password);
		System.out.println(">> (staging) sign_up 사용자 student_email : " + student_email);
		System.out.println(">> (staging) sign_up 사용자 authentication_code : " + authentication_code);
		System.out.println(">> (staging) sign_up 사용자 student_push_agreement : " + student_push_agreement);
		System.out.println(">> (staging) sign_up 사용자 student_device_token : " + student_device_token);
		System.out.println(">> (staging) sign_up 사용자 student_phone_number : " + student_phone_number);
		System.out.println(">> (staging) sign_up -----------------------");
		
		if (student_phone_number != null && student_phone_number.length() > 0) 
		{
			if(student_phone_number.length() < 10) 
			{
				object.addProperty("fail", "student_phone_length");
				return gson.toJson(object);	
			}
		}
		else 
		{
			student_phone_number = null;
		}
		
		/* 전달받은 매개변수가 전부 null이 아니어야 하며 푸쉬 수신동의는 y또는 n이어야 한다. */
		if(student_id != null && student_name != null && student_password != null && student_email != null && authentication_code != null && (student_push_agreement.equals("y") || student_push_agreement.equals("n"))) {
			// INSERT 하기 전 검증해야할 3가지
			// 1. 아이디 중복확인 및 문자열 길이 체크 ( 4 ~ 12 자리 )
			// 2. 이름 문자열 길이 체크
			// 3. 패스워드 정규식 검증 및 sha256 변환 ( 영어 + 숫자 + 특수문자를 포함한 6 ~ 12 자리 )
			// 4. 이메일 및 인증코드 검증
			// 5. 핸드폰번호 13자리 맞는지 검증
			
			if(student_id.length() > 3 && student_id.length() < 25) {	//아이디 문자열 길이 확인
				
				if(!student_information_service.Id_Overlap_Check(student_id)) {	//아이디 중복확인
					
					if(student_name.length() > 1 && student_name.length() < 10) {	//이름 문자열 길이 확인
						
						if(kr.co.onpe.common.common.passwordCheck(student_password)){	//비밀번호 정규식 확인
							
							if(kr.co.onpe.common.common.isValidEmail(student_email)) {	//이메일 정규식 확인
								
								if(!student_information_service.Email_Overlap_Check(student_email)) {	//이메일 중복검사 확인
									
									if("N/A".equals(authentication_code) || student_information_service.Student_Email_Authentication_Code_Check(student_email, authentication_code)) {	//이메일 인증코드 검증
										
										/* 비밀번호 암호화 */
										try {
											String sha256pw = kr.co.onpe.common.common.sha256(student_password);
											
											/* DB에 넣을 데이터로 정제 ( 푸쉬동의여부 ) */
											String push_agreement = "";
											if(student_push_agreement.equals("y")) {
												push_agreement = "1";
											}else {
												push_agreement = "0";
											}
											
											/* 현재 시간 */
											SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
											format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
											Date time = new Date();
											String time_number = format.format(time);
											
											if (student_information_service.Create_Student_Information(student_id, student_name, sha256pw, student_email, push_agreement, time_number, student_phone_number, student_device_token)) {
												student_information_service.Delete_Student_Email_Authentication_Code(student_email);
												
												String createdToken = jwtTokenProvider.createToken(student_id, "STUDENT");
												
												Student_Information_VO student_information = student_information_service.Student_Information_for_Auto_login(student_id, "E");
												student_information.access_token = createdToken;
												ObjectMapper objectMapper  = new ObjectMapper();
												
												object.addProperty("success", "success_create");
												object.addProperty("student", objectMapper.writeValueAsString(student_information));
												return gson.toJson(object);
											}else {
												object.addProperty("fail", "server_error");
												return gson.toJson(object);										
											}
											
										} 
										catch (NoSuchAlgorithmException e) //SHA256 변환 실패
										{	
											e.printStackTrace();
											object.addProperty("fail", "server_error");
											return gson.toJson(object);	
										} 
										catch (JsonProcessingException e) {
											
											e.printStackTrace();
											object.addProperty("fail", "server_error");
											return gson.toJson(object);	
										}
										
									}else {
										object.addProperty("fail", "authentication_code");
										return gson.toJson(object);
									}
									
								}else {
									object.addProperty("fail", "email_overlap");
									return gson.toJson(object);									
								}								
								
							}else {
								object.addProperty("fail", "unvalid_email");
								return gson.toJson(object);
							}
							
						}else {
							object.addProperty("fail", "unvalid_password");
							return gson.toJson(object);	
						}
						
					}else {
						object.addProperty("fail", "student_name_length");
						return gson.toJson(object);	
					}
					
				}else {
					object.addProperty("fail", "student_id_overlap");
					return gson.toJson(object);					
				}
				
			}else {
				object.addProperty("fail", "student_id_length");
				return gson.toJson(object);
			}			
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}
	
	/* 사용자 아이디 찾기 */
	@ResponseBody
	@RequestMapping(value = "/find_id", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String find_id(Locale locale, HttpServletRequest request) {
		/* 이름, 이메일로 사용자 아이디 조회 */
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		String student_name = request.getParameter("student_name");
		String student_phone = request.getParameter("student_phone_number");

		System.out.println(">> (staging) find_id 사용자 student_name : " + student_name);
		System.out.println(">> (staging) find_id 사용자 student_phone : " + student_phone);
		System.out.println(">> (staging) find_id -----------------------");
		
		if (student_name != null && student_phone != null) //전달받은 데이터 확인
		{	
			try
			{
				student_name = student_name.replace(" ", "");
				
				System.out.println(">> (staging) find_id 사용자 student_name : " + student_name);
				System.out.println(">> (staging) find_id -----------------------");
				
				String get_id = student_information_service.Student_Find_Id(student_name, student_phone);
				
				System.out.println(">> (staging) find_id 사용자 get_id : " + get_id);
				System.out.println(">> (staging) find_id -----------------------");
				if (get_id != null) 
				{
					object.addProperty("success", get_id);
					object.addProperty("student_id", get_id);
					return gson.toJson(object);
				}
				else 
				{	//조회 사용자 없음
					object.addProperty("fail", "null_user");
					return gson.toJson(object);
				}
				
			}
			catch(Exception e)
			{
				e.printStackTrace();
				
				object.addProperty("fail", "error");
				return gson.toJson(object);
			}
		}
		
		object.addProperty("fail", "access_denied");
		
		return gson.toJson(object);
	}
	
	/* 사용자 아이디 찾기 */
	@ResponseBody
	@RequestMapping(value = "/find_pw", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String find_pw(Locale locale, HttpServletRequest request) {
		/* 이름, 이메일로 사용자 아이디 조회 */
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		String student_id = request.getParameter("student_id");
		String student_name = request.getParameter("student_name");
		String student_phone = request.getParameter("student_phone_number");

		System.out.println(">> (staging) find_pw 사용자 student_id : " + student_id);
		System.out.println(">> (staging) find_pw 사용자 student_name : " + student_name);
		System.out.println(">> (staging) find_pw 사용자 student_phone : " + student_phone);
		System.out.println(">> (staging) find_pw -----------------------");
		
		if (!TextUtils.isEmpty(student_id) && !TextUtils.isEmpty(student_name) && !TextUtils.isEmpty(student_phone)) //전달받은 데이터 확인
		{	
			try
			{
				student_name = student_name.replace(" ", "");
				
				if (student_information_service.Student_Find_Pw(student_id, student_name, student_phone))
				{
					String authenticationCode = kr.co.onpe.common.common.numberGen(6,1);
					String studentEmail = student_information_service.Student_Find_Email(student_id);
					
					if(student_information_service.Create_Student_Email_Authentication_Code(studentEmail, authenticationCode)) 
					{
						object.addProperty("success", student_id);
						object.addProperty("student_email", studentEmail);
						object.addProperty("authenticationCode", authenticationCode);
						return gson.toJson(object);
					}
					else
					{
						object.addProperty("fail", "server_error");
						return gson.toJson(object);
					}
				}
				else
				{
					object.addProperty("fail", "null_user");
					return gson.toJson(object);
				}	
			}
			catch(Exception e)
			{
				e.printStackTrace();
				
				object.addProperty("fail", "error");
				return gson.toJson(object);
			}
		}
		
		object.addProperty("fail", "access_denied");
		
		return gson.toJson(object);
	}
	
	/* 사용자 비밀번호 찾기 */
	@ResponseBody
	@RequestMapping(value = "/find_pw_withEmail", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String find_pw_withEmail(Locale locale, HttpServletRequest request) {
		/*이름 + 아이디 + 이메일 주소 확인 후 해당 이메일 주소로 이메일 보내기*/
		
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		String student_id = request.getParameter("student_id");
		String student_name = request.getParameter("student_name");
		String student_email = request.getParameter("student_email");
		
		if(student_id != null && student_name != null && student_email != null) {	//전달받은 데이터 확인

			if(kr.co.onpe.common.common.isValidEmail(student_email)) {	//이메일 정규식 체크
				
				if(student_information_service.Student_Find_Pw_withEmail(student_id, student_name, student_email)) {
					
					// 메일 제목
					String subject = "온체육 비밀번호찾기 인증번호";
					// 보내는 사람
					String from ="온체육 <complexionco@naver.com>";
					// 받는 사람
					String to = student_email;
					// 인증 번호
					String certinumber = kr.co.onpe.common.common.numberGen(6,1);
					
					// 인증받을 이메일과 인증번호를 DB에 저장한다.
					boolean queryResult = student_information_service.Create_Student_Email_Authentication_Code(to, certinumber);
					
					if(queryResult) 
					{
						try {
							// 메일 내용 넣을 객체와, 이를 도와주는 Helper 객체 생성
							MimeMessage mail = mailSender.createMimeMessage();
				            MimeMessageHelper mailHelper = new MimeMessageHelper(mail,true,"UTF-8");

							// 메일 내용을 채워줌
							mailHelper.setFrom(from);	// 보내는 사람 셋팅
							mailHelper.setTo(to);		// 받는 사람 셋팅
							mailHelper.setSubject(subject);	// 제목 셋팅
							mailHelper.setText("<div style='width:100%; padding:20px 0; text-align:center;'><div style='vertical-align:center; display:inline-block; width:200px; padding:30px 5px;'>" +
									"<div style='float:left; width:100%; text-align:center; font-size:22px; font-weight:bold;'>온체육 이메일 인증</div>" +
									"<div style='float:left; margin:10px 0; border-top:3px solid; width:100%; height:1px;'></div>" +
									"<div style='float:left; width:100%; text-align:center; font-size:18px; font-weight:bold;'>인증번호 : "+ certinumber +"</div></div></div>", true);	// 내용 셋팅

							// 메일 전송
							mailSender.send(mail);
							
							object.addProperty("success", certinumber);
							return gson.toJson(object);
							
						} catch(Exception e) {
							e.printStackTrace();
							object.addProperty("fail", "server_error");
							return gson.toJson(object);
						}
					}
					else 
					{
						object.addProperty("fail", "server_error");
						return gson.toJson(object);
					}
					
				}else {
					object.addProperty("fail", "null_user");
					return gson.toJson(object);
				}
				
			}else {
				object.addProperty("fail", "unvalid_email");
				return gson.toJson(object);
			}
			
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}
	
	/* 사용자 비밀번호 찾기 완료 ( 비밀번호 변경 ) */
	@ResponseBody
	@RequestMapping(value = "/find_change_pw", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String find_change_pw(Locale locale, HttpServletRequest request) {
		/*이메일 주소 + 인증번호 확인 후 전달받은 비밀번호로 해당 아이디의 비밀번호 변경*/
		Gson gson = new Gson();
		JsonObject object = new JsonObject();
		
		String student_email = request.getParameter("student_email");
		String student_password = request.getParameter("student_password");
		String authentication_code = request.getParameter("authentication_code");
		
		System.out.println(">> (staging) find_change_pw 사용자 student_email : " + student_email);
		System.out.println(">> (staging) find_change_pw 사용자 student_password : " + student_password);
		System.out.println(">> (staging) find_change_pw 사용자 authentication_code : " + authentication_code);
		System.out.println(">> (staging) find_change_pw -----------------------");
		
		if(student_email != null && student_password != null && authentication_code != null) {	//전달받은 데이터 확인

			if(kr.co.onpe.common.common.isValidEmail(student_email)) {	//이메일 정규식 체크
				
				if(student_information_service.Student_Email_Authentication_Code_Check(student_email, authentication_code)) {	//이메일 인증코드 검증
					
					/* 비밀번호 암호화 */
					try 
					{
						String sha256pw = kr.co.onpe.common.common.sha256(student_password);
					
						if (student_information_service.Student_Change_Pw(student_email, sha256pw)) 
						{
							student_information_service.Delete_Student_Email_Authentication_Code(student_email);
							System.out.println(">> (staging) find_change_pw success_change !! ");
							System.out.println(">> (staging) find_change_pw -----------------------");
							
							object.addProperty("success", "success_change");
							return gson.toJson(object);
							
						}
						else 
						{
							object.addProperty("fail", "server_error");
							return gson.toJson(object);	
						}
						
					} catch (NoSuchAlgorithmException e) {	//SHA256 변환 실패
						e.printStackTrace();
						object.addProperty("fail", "server_error");
						return gson.toJson(object);	
					}
					
				}else {
					object.addProperty("fail", "authentication_code");
					return gson.toJson(object);
				}
				
			}else {
				object.addProperty("fail", "unvalid_email");
				return gson.toJson(object);
			}
		}
		
		object.addProperty("fail", "access_denied");
		return gson.toJson(object);
	}
}
