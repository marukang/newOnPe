package kr.co.onpe;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.security.NoSuchAlgorithmException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.UUID;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.mail.Session;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import kr.co.onpe.common.Fcm_Util;
import kr.co.onpe.security.JwtTokenProvider;
import kr.co.onpe.service.Student_Information_Service;
import kr.co.onpe.service.WebUserAuthService;
import kr.co.onpe.service.Web_Admin_Management_Service;
import kr.co.onpe.service.Web_Teacher_Index_Service;
import kr.co.onpe.thread.email_authentication_sendMailThread;
import kr.co.onpe.thread.sendMailThread;
import kr.co.onpe.thread.sendMailThread_find_id;
import kr.co.onpe.vo.Admin_Notice_VO;
import kr.co.onpe.vo.Popup_List_VO;
import kr.co.onpe.vo.SmarteditorVO;
import kr.co.onpe.vo.Teacher_Information_VO;

@Controller
@RequestMapping("/")
public class WebDefaultController {
	
	/* 로그인, 회원가입, 아이디찾기, 비밀번호찾기, 아이디찾기 완료, 비밀번호찾기 완료 */
	/* 아이디찾기 완료와 비밀번호찾기 완료는 세션을통해 컨트롤 한다. */
	/* 시큐리티 설정을 할 때 로그인, 회원가입, 아이디찾기, 비밀번호찾기 페이지는 누구나 접근가능하도록 설정한다. */
	
	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
	/* root-context.xml에 등록한 Bean 호출 ( 의존성 주입 **Autowired ) */
	@Autowired
	private JavaMailSender mailSender;
	
	/* 선생 정보 테이블(teacher_information) 테이블 관련 서비스 */
	@Inject
	private WebUserAuthService webUserAuthService;
	
	@Inject
	private Student_Information_Service student_information_service;
	
	@Inject
	private Web_Teacher_Index_Service web_Teacher_Service;
	
	@Resource(name = "workExecutor")
	private ThreadPoolTaskExecutor workExecutor;
	
	private static final Logger logger = LoggerFactory.getLogger(WebDefaultController.class);
	
	
	
	
	@RequestMapping(value="/photoUpload", method=RequestMethod.POST)
	public String photoUpload(HttpServletRequest request, SmarteditorVO vo, HttpSession session){
		if(session.getAttribute("teacher_id") == null || session.getAttribute("teacher_token") == null || session.getAttribute("admin_auth") == null) {
			return "redirect:/logout";
		}else {
			String token = (String)session.getAttribute("teacher_token");
			String sessionUid = (String)session.getAttribute("teacher_id");
			String sessionUAuth = (String)session.getAttribute("admin_auth");
			
			//토큰 유효성 + 사용자 일치성 체크
			String new_token = jwtTokenProvider.TokenCheck(sessionUid, sessionUAuth, token);
			if(new_token.equals("fail") || new_token.equals("expired")) {
				return "redirect:/logout";
			}else {
				session.setAttribute("teacher_token", new_token);
				
				String callback = vo.getCallback();
				String callback_func = vo.getCallback_func();
				String file_result = "";
				try {
					if(vo.getFiledata() != null && vo.getFiledata().getOriginalFilename() != null && !vo.getFiledata().getOriginalFilename().equals("")) {
						//파일 존재할때
						String original_name = vo.getFiledata().getOriginalFilename();
						String ext = original_name.substring(original_name.lastIndexOf(".")+1);
						//기본경로
						//String defaultPath = "D:/spring_image/";
						String defaultPath = "/resources/se2/";
						SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
						String today = formatter.format(new java.util.Date());
						//상세경로
						String path = defaultPath + File.separator;
						File file = new File(path);
						if(!file.exists()) {
							file.mkdirs();
						}
						//서버에 업로드할 파일명
						String realname = sessionUid+today+UUID.randomUUID().toString() + "." + ext;
						//서버에 파일 작성
						vo.getFiledata().transferTo(new File(path+realname));
						file_result += "&bNewLine=true&sFileName="+original_name+"&sFileURL=/resources/se2/"+realname;
					}
				}catch (Exception e) {
					e.printStackTrace();
				}
				return "redirect:" + callback + "?callback_func="+callback_func+file_result;
				
			}
		}
	}
	
	
	@RequestMapping(value="/multiplePhotoUpload", method=RequestMethod.POST)
	public void multiplePhotoUpload(HttpServletRequest request, HttpServletResponse response, HttpSession session){
		if(session.getAttribute("teacher_id") == null || session.getAttribute("teacher_token") == null || session.getAttribute("admin_auth") == null) {
		}else {
			String token = (String)session.getAttribute("teacher_token");
			String sessionUid = (String)session.getAttribute("teacher_id");
			String sessionUAuth = (String)session.getAttribute("admin_auth");
			//토큰 유효성 + 사용자 일치성 체크
			String new_token = jwtTokenProvider.TokenCheck(sessionUid, sessionUAuth, token);
			if(new_token.equals("fail") || new_token.equals("expired")) {
			}else {
				session.setAttribute("teacher_token", new_token);
				
				try {
					//파일정보
					String sFileInfo = "";
					//원본 파일명
					String filename = request.getHeader("file-name");
					//확장자
					String filename_ext = filename.substring(filename.lastIndexOf(".")+1);
					//확장자 소문자변경
					filename_ext = filename_ext.toLowerCase();
					//파일 경로
					//String filePath = "D:/spring_image/" + File.separator;
					String filePath = "/resources/se2/";
					File file = new File(filePath);
					if(!file.exists()) {
						file.mkdirs();
					}
					String realFileNm = "";
					SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
					String today = formatter.format(new java.util.Date());
					realFileNm = sessionUid+today+UUID.randomUUID().toString() + filename.substring(filename.lastIndexOf("."));
					String rlFileNm = filePath + realFileNm;
					//서버에 파일쓰기
					InputStream is = request.getInputStream();
					OutputStream os = new FileOutputStream(rlFileNm);
					int numRead;
					byte b[] = new byte[Integer.parseInt(request.getHeader("file-size"))];
					while((numRead = is.read(b,0,b.length)) != -1) {
						os.write(b,0,numRead);
					}
					if(is != null) {
						is.close();
					}
					os.flush();
					os.close();
					
					//정보 출력
					sFileInfo += "&bNewLine=true";
					//img 태그의 title 속성을 원본 파일명으로 적용시켜주기 위함
					sFileInfo += "&sFileName="+filename;
					sFileInfo += "&sFileURL="+"/resources/se2/"+realFileNm;
					PrintWriter print = response.getWriter();
					print.print(sFileInfo);
					print.flush();
					print.close();
				}catch(Exception e) {
					e.printStackTrace();
				}
				
			}
		}
	}
	
	
	
	/* 메인 페이지 ( admin인지 user인지 확인해서 각각 다른페이지로 이동시키자 ) */
	@RequestMapping(value = "/", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String home(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		//System.out.println("메인페이지 접근 <로그인 완료된사람만 들어올 수 있음>");
		if(session.getAttribute("teacher_id") == null || session.getAttribute("teacher_token") == null || session.getAttribute("admin_auth") == null) {
			return "redirect:/logout";
		}else {
			String token = (String)session.getAttribute("teacher_token");
			String sessionUid = (String)session.getAttribute("teacher_id");
			String sessionUAuth = (String)session.getAttribute("admin_auth");
			
			//토큰 유효성 + 사용자 일치성 체크
			String new_token = jwtTokenProvider.TokenCheck(sessionUid, sessionUAuth, token);
			if(new_token.equals("fail") || new_token.equals("expired")) {
				return "redirect:/logout";
			}else {
				session.setAttribute("teacher_token", new_token);
			}
			
			//이부분에서 각각 다른페이지로 이동시켜야한다.
			if(sessionUAuth.equals("ROLE_ADMIN")){
				return "redirect:/admin/member/lms_member_management_list";
			}else {
				model.addAttribute("teacher_id", (String)session.getAttribute("teacher_id"));
				model.addAttribute("teacher_name", (String)session.getAttribute("teacher_name"));
				model.addAttribute("teacher_email", (String)session.getAttribute("teacher_email"));
				model.addAttribute("teacher_phone", (String)session.getAttribute("teacher_phone"));
				model.addAttribute("teacher_sex", (String)session.getAttribute("teacher_sex"));
				model.addAttribute("teacher_school", (String)session.getAttribute("teacher_school"));
				
				/* 신규 공지사항이 있는지 여부 확인 */
				List<Admin_Notice_VO> lately = web_Teacher_Service.Get_Admin_Notice_List(null, "0");
				
				SimpleDateFormat format = new SimpleDateFormat ("yyyyMMdd");
				format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date time = new Date();
				String today = format.format(time);
				
				if(lately != null && lately.size() > 0) {					
					
					try {
						Date stDt = format.parse(lately.get(0).getAdmin_notice_date().substring(0, 8));
						Date edDt = format.parse(today);
						
						long diff = edDt.getTime() - stDt.getTime();
				        long diffDays = diff / (24 * 60 * 60 * 1000);
				        if(diffDays >= 0 && diffDays < 14) {
				        	model.addAttribute("notice", "y");	
				        }else {
				        	model.addAttribute("notice", "n");	
				        }
				        
					} catch (ParseException e) {
						model.addAttribute("notice", "n");
					}
				}else {
					model.addAttribute("notice", "n");
				}
				
				/* 답변안한 메세지가 있는지 여부 확인 */
				List<String> teacher_classcode = (List<String>) session.getAttribute("teacher_classcode");
				if(teacher_classcode != null && teacher_classcode.size() > 0) {
					if(web_Teacher_Service.Get_Student_Message_List_None_Reply(teacher_classcode)) {
						model.addAttribute("message","y");
					}else {
						model.addAttribute("message","n");
					}
				}else {
					model.addAttribute("message","n");
				}
				
				
				
				/* 팝업이 있는지 여부 확인 */
				List<Popup_List_VO> popup_list = web_Teacher_Service.Get_Popup_List(today);
				if(popup_list.size() > 0) {
					model.addAttribute("popup",popup_list.get(0));	
				}
				
				return "index";
			}
		}
	}
	
	
	
	/* book test */
	@RequestMapping(value = "/normal", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String normal(Locale locale, Model model) {
		return "normal";
	}
	
	/* book test */
	@RequestMapping(value = "/cloude", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String cloude(Locale locale, Model model) {
		return "cloude";
	}
	
	
	
	
	
	
	
	
	
	/* 로그인 페이지 */
	@RequestMapping(value = "/login", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String login(Locale locale, Model model, HttpServletRequest request) {
		
		System.out.println(">> (staging) login 로그인 페이지");
		
		Map<String, String> map = new HashMap<String, String>();
		
		if(request.getParameter("state") != null && request.getParameter("state").equals("secession")){
			map.put("state", "1");
		}else if(request.getParameter("login_error") != null && request.getParameter("login_error").equals("1")) {
			map.put("state", "2");
		}else {
			map.put("state", "3");
		}
		model.addAttribute("state",map);
		
		return "login";
	}
	
	/* 로그인 성공 페이지 */
	@RequestMapping(value = "/login_success", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String SuccessLogin(Locale locale, Model model, HttpSession session) {
		if(session.getAttribute("teacher_token") == null) {
			Teacher_Information_VO user = (Teacher_Information_VO)SecurityContextHolder.getContext().getAuthentication().getDetails();
			
			String token = jwtTokenProvider.createToken(user.getUsername(), user.getAdmin_auth());
			if(!token.equals("fail") && !token.equals("expired") && user.getTeacher_state().equals("0")) {
				session.setAttribute("teacher_token", token);
				session.setAttribute("teacher_id", user.getUsername());
				session.setAttribute("teacher_name", user.getTeacher_name());
				session.setAttribute("teacher_email", user.getTeacher_email());
				session.setAttribute("teacher_phone", user.getTeacher_phone());
				session.setAttribute("teacher_sex", user.getTeacher_sex());
				session.setAttribute("teacher_school", user.getTeacher_school());
				session.setAttribute("teacher_email_agreement", user.getTeacher_email_agreement());
				session.setAttribute("teacher_message_agreement", user.getTeacher_message_agreement());
				session.setAttribute("admin_auth", user.getAdmin_auth());
				session.setAttribute("teacher_birth", user.getTeacher_birth());
				List<String> classcode_list = webUserAuthService.Get_Classcode_List(user.getUsername());
				if(classcode_list != null && classcode_list.size() > 0) {
					session.setAttribute("teacher_classcode", classcode_list);	
				}else {
					session.setAttribute("teacher_classcode", null);
				}
				
				return "redirect:/";
			}else {
				System.out.println("토큰발급 실패 또는 탈퇴회원일 때 : ");
				
				if(!user.getTeacher_state().equals("0")) {
					return "redirect:/logout?state=secession";
				}else {
					return "redirect:/logout";	
				}
			}
		}else {
			return "redirect:/";
		}
	}
	
	/* 로그아웃 백엔드 페이지 */
	@RequestMapping(value = "/logout", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("로그아웃 페이지 접근");		
		
		//세션 삭제
		HttpSession session = request.getSession();
		
		boolean isSecession = false;
		if(request.getParameter("state") != null && request.getParameter("state").equals("secession")){
			isSecession = true;
		}
		
		session.invalidate();
		
		//사용자 정보 삭제
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null){
			new SecurityContextLogoutHandler().logout(request, response, auth);
		}
		
		//로그인페이지로 리다이렉트
		if(isSecession) {
			return "redirect:/login?state=secession";
		}else {
			return "redirect:/login";	
		}
	}
	
	/* 아이디 찾기 페이지 ( 로그인사용자는 못들어오게 하자 ) */
	@RequestMapping(value = "/find_id", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String find_id(Locale locale, Model model, HttpServletRequest request, HttpSession session) {
		
		Map<String, String> map = new HashMap<String, String>();
		
		if(request.getParameter("find_id_error") != null) {	//해당하는 사용자가 없는 경우
			map.put("state", "1");
		}else {
			map.put("state", "2");
		}
		model.addAttribute("state",map);
		session.setAttribute("find_id", "1");
		return "find_id";
	}
	
	/* 아이디 찾기 검증 페이지 ( 로그인사용자는 못들어오게 하자, 아이디 찾기페이지를 거쳐서 온 경우에만 들어올수 있게 하자 ) */
	@RequestMapping(value = "/find_id_ck", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String find_id_ck(Locale locale, Model model, HttpServletRequest request, HttpSession session) {
		
		String teacher_name = request.getParameter("teacher_name");
		String teacher_email = request.getParameter("teacher_email");
		if(session.getAttribute("find_id") != null) {
			session.setAttribute("find_id", null);
			if(teacher_name != null && teacher_email != null && kr.co.onpe.common.common.isValidEmail(teacher_email)) {
				String teacher_id = webUserAuthService.Teacher_Find_Id(teacher_name, teacher_email);
				if(teacher_id != null) {
					
					sendMailThread_find_id sendMailThread = new sendMailThread_find_id(teacher_email, teacher_id, mailSender);
					workExecutor.execute(sendMailThread);
					
					return "find_id_success";
				}else {
					return "redirect:/find_id?find_id_error=1";	
				}
			}else {
				return "redirect:/find_id?find_id_error=1";
			}	
		}else {
			return "redirect:/login";
		}
	}
	
	
	/* 비밀번호 찾기 페이지 ( 로그인사용자는 못들어오게 하자 ) */
	@RequestMapping(value = "/find_pw", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String find_pw(Locale locale, Model model, HttpServletRequest request, HttpSession session) {
		
		Map<String, String> map = new HashMap<String, String>();
		if(request.getParameter("find_pw_error") != null) {
			if(request.getParameter("find_pw_error").equals("1")) {	//서버에러
				map.put("state", "1");
			}			
		}else if(request.getParameter("none") != null) {
			if(request.getParameter("none").equals("1")){//해당하는 사용자가 없는 경우
				map.put("state", "2");
			}
		}
		model.addAttribute("state",map);
		session.setAttribute("find_pw", "1");
		
		return "find_pw";
	}
	
	/* 비밀번호 찾기 검증 페이지 ( 로그인사용자는 못들어오게 하자, 비밀번호 찾기페이지를 거쳐서 온 경우에만 들어올수 있게 하자 ) */
	@RequestMapping(value = "/find_pw_ck", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String find_pw_ck(Locale locale, Model model, HttpServletRequest request, HttpSession session) {
		
		String teacher_id = request.getParameter("teacher_id");
		String teacher_email = request.getParameter("teacher_email");
		if(session.getAttribute("find_pw") != null) {
			session.setAttribute("find_pw", null);
			if(teacher_id != null && teacher_email != null && kr.co.onpe.common.common.isValidEmail(teacher_email)) {
				
				try {
					String new_password = kr.co.onpe.common.common.makePassword();
					String sha256pw = kr.co.onpe.common.common.sha256(new_password);
					
					if(webUserAuthService.Teacher_Find_Id_For_Pw(teacher_id, teacher_email)) {
						
						if(webUserAuthService.Teacher_Change_Pw(teacher_id, sha256pw)) {

							sendMailThread sendMailThread = new sendMailThread(teacher_email, new_password, mailSender);
							
							workExecutor.execute(sendMailThread);
							return "find_pw_success";			
						}else {
							return "redirect:/find_pw?find_pw_error=1";		
						}
						
					}else {
						return "redirect:/find_pw?none=1";
					}
					
					
				} catch (NoSuchAlgorithmException e) {
					e.printStackTrace();
					return "redirect:/find_pw?find_pw_error=1";
				}
			}else {
				return "redirect:/find_pw?find_pw_error=1";
			}
		}else {
			return "redirect:/login";
		}
	}
	
	/* 회원가입 페이지 ( 로그인사용자는 못들어오게 하자 ) */
	@RequestMapping(value = "/sign_up", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String sign_up(Locale locale, Model model, HttpServletRequest request) {
		return "sign_up";
	}
	
	/* 회원가입 처리 페이지 ( 로그인사용자는 못들어오게 하자 ) */
	@ResponseBody
	@RequestMapping(value = "/sign_up_ck", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String sign_up_check(Locale locale, Model model, HttpServletRequest request) {
		
		String teacher_id = request.getParameter("teacher_id");
		String teacher_name = request.getParameter("teacher_name");
		String teacher_password = request.getParameter("teacher_password");
		String teacher_email = request.getParameter("teacher_email");
		String teacher_phone = request.getParameter("teacher_phone");
		String teacher_birth = request.getParameter("teacher_birth");
		String teacher_sex = request.getParameter("teacher_sex");
		String teacher_school = request.getParameter("teacher_school");
		String teacher_email_agreement = request.getParameter("teacher_email_agreement");
		String teacher_message_agreement = request.getParameter("teacher_message_agreement");
		
		if(teacher_id != null && teacher_name != null && teacher_password != null && teacher_email != null && teacher_phone != null && teacher_sex != null && teacher_school != null && teacher_email_agreement != null && teacher_message_agreement != null) {
			
			if(teacher_name.length() < 1 || teacher_name.length() > 10) {
				return "fail";
			}else if(teacher_school.length() < 1 || teacher_school.length() > 30) {
				return "fail";
			}else if(teacher_birth.length() != 8) {
				return "fail";
			}else if(!teacher_sex.equals("남") && !teacher_sex.equals("여")) {
				return "fail";
			}else if(teacher_id.length() < 3 || teacher_id.length() > 20) {
				return "fail";
			}else if(!kr.co.onpe.common.common.teacher_passwordCheck(teacher_password)) {
				return "fail";
			}else if(!kr.co.onpe.common.common.isValidEmail(teacher_email)){
				return "fail";
			}else if(teacher_phone.length() != 11) {
				return "fail";
			}else if((!teacher_email_agreement.equals("0") && !teacher_email_agreement.equals("1")) || (!teacher_message_agreement.equals("0") && !teacher_message_agreement.equals("1"))){
				return "fail";
			}else {
				if(teacher_sex.equals("남")) {
					teacher_sex = "m";
				}else {
					teacher_sex = "f";
				}
				try {
					String sha256pw = kr.co.onpe.common.common.sha256(teacher_password);
					
					if(webUserAuthService.Teacher_Id_Overlap(teacher_id)) {
						return "id_overlap";
					}else if(webUserAuthService.Teacher_Email_Overlap(teacher_email)) {
						return "email_overlap";
					}else if(webUserAuthService.Teacher_Phone_Overlap(teacher_phone)) {
						return "phone_overlap";
					}else {
						
						SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
						format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
						Date time = new Date();
						String time_number = format.format(time);

						if(webUserAuthService.Teacher_Sign_Up(teacher_id, teacher_name, sha256pw, teacher_email, teacher_phone, teacher_birth, teacher_sex, teacher_school, time_number, teacher_email_agreement, teacher_message_agreement)) {
							student_information_service.Delete_Student_Email_Authentication_Code(teacher_email);
							return "success";
						}else {
							return "fail";
						}
						
					}
					
				} catch (NoSuchAlgorithmException e) {
//					e.printStackTrace();
					return "fail";
				}
			}
			
		}else {
			return "fail"; 
		}
	}
	
	/* 마이 페이지 (선생님, 관리자 공통) */
	@RequestMapping(value = "/mypage", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String mypage(Locale locale, Model model, HttpServletRequest request, HttpSession session) {
		if(session.getAttribute("teacher_id") == null || session.getAttribute("teacher_token") == null || session.getAttribute("admin_auth") == null) {
			return "redirect:/logout";
		}else {
			String token = (String)session.getAttribute("teacher_token");
			String sessionUid = (String)session.getAttribute("teacher_id");
			String sessionUAuth = (String)session.getAttribute("admin_auth");
			
			//토큰 유효성 + 사용자 일치성 체크
			String new_token = jwtTokenProvider.TokenCheck(sessionUid, sessionUAuth, token);
			if(new_token.equals("fail") || new_token.equals("expired")) {
				return "redirect:/logout";
			}else {
				session.setAttribute("teacher_token", new_token);
				model.addAttribute("teacher_id", sessionUid);
			}
			
			return "mypage";
		}
	}
	
	/* 마이 페이지 정보변경 처리 (선생님, 관리자 공통) */
	@ResponseBody
	@RequestMapping(value = "/mypage_modify_ck", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String mypage_modify_ck(Locale locale, Model model, HttpServletRequest request, HttpSession session) {
		if(session.getAttribute("teacher_id") == null || session.getAttribute("teacher_token") == null || session.getAttribute("admin_auth") == null) {
			return "out";
		}else {
			String token = (String)session.getAttribute("teacher_token");
			String sessionUid = (String)session.getAttribute("teacher_id");
			String sessionUAuth = (String)session.getAttribute("admin_auth");
			String sessionUEmail = (String)session.getAttribute("teacher_email");
			String sessionUPhone = (String)session.getAttribute("teacher_phone");
			
			//토큰 유효성 + 사용자 일치성 체크
			String new_token = jwtTokenProvider.TokenCheck(sessionUid, sessionUAuth, token);
			if(new_token.equals("fail") || new_token.equals("expired")) {
				return "out";
			}else {
				session.setAttribute("teacher_token", new_token);
			}
			
			String teacher_password_before = request.getParameter("teacher_password_before");
			String teacher_password = request.getParameter("teacher_password");
			String teacher_email = request.getParameter("teacher_email");
			String teacher_phone = request.getParameter("teacher_phone");
			String teacher_email_agreement = request.getParameter("teacher_email_agreement");
			String teacher_message_agreement = request.getParameter("teacher_message_agreement");
			String change_password = request.getParameter("change_password");
			
			if(change_password.equals("y")) {
				if(teacher_password_before == null || teacher_password == null || teacher_email == null || teacher_phone == null || teacher_email_agreement == null || teacher_message_agreement == null) {
					return "fail";
				}else {
					if(teacher_password_before.equals(teacher_password)) {
						return "fail";
					}else if(!kr.co.onpe.common.common.teacher_passwordCheck(teacher_password)) {
						return "fail";
					}
				}
			}else {
				if(teacher_email == null || teacher_phone == null || teacher_email_agreement == null || teacher_message_agreement == null) {
					return "fail";
				}
			}
			if(!change_password.equals("y") && !change_password.equals("n")) {
				return "fail";
			}else if(!kr.co.onpe.common.common.isValidEmail(teacher_email)){
				return "fail";
			}else if(teacher_phone.length() != 11) {
				return "fail";
			}else if((!teacher_email_agreement.equals("0") && !teacher_email_agreement.equals("1")) || (!teacher_message_agreement.equals("0") && !teacher_message_agreement.equals("1"))){
				return "fail";
			}else {
				
				try {
					String sha256pw = "1234";
					if(change_password.equals("y")) {
						String sha256pw_before = kr.co.onpe.common.common.sha256(teacher_password_before);
						sha256pw = kr.co.onpe.common.common.sha256(teacher_password);	
						
						if(!webUserAuthService.Teacher_Password_Check(sessionUid, sha256pw_before)) {
							return "before_password";
						}
					}
					
					if(!sessionUEmail.equals(teacher_email)) {
						if(webUserAuthService.Teacher_Email_Overlap(teacher_email)) {
							return "email_overlap";
						}	
					}
					if(!sessionUPhone.equals(teacher_phone)) {
						if(webUserAuthService.Teacher_Phone_Overlap(teacher_phone)) {
							return "phone_overlap";
						}	
					}
					
					boolean result = false;
					
					if(change_password.equals("y")) {
						result = webUserAuthService.Teacher_Modify_Information(sessionUid, change_password, sha256pw, teacher_email, teacher_phone, teacher_email_agreement, teacher_message_agreement); 
					}else {
						result = webUserAuthService.Teacher_Modify_Information(sessionUid, change_password, sha256pw, teacher_email, teacher_phone, teacher_email_agreement, teacher_message_agreement);
					}
					
					if(result){
						
						session.setAttribute("teacher_email",teacher_email);
						session.setAttribute("teacher_phone", teacher_phone);
						session.setAttribute("teacher_email_agreement", teacher_email_agreement);
						session.setAttribute("teacher_message_agreement", teacher_message_agreement);
						
						return "success";
					}else {
						return "fail";
					}
					
				} catch (NoSuchAlgorithmException e) {
//					e.printStackTrace();
					return "fail";
				}
			}
		}
	}
	
	/* 이메일 인증코드 발급 ( 매개변수로 전달받은 이메일로 코드 전송 ) */
	@ResponseBody
	@RequestMapping(value = "/email_authentication", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String email_authentication(Locale locale, HttpServletRequest request) {
		String email = request.getParameter("teacher_email");
		
		if(email != null) {
			if(kr.co.onpe.common.common.isValidEmail(email)) {
				if(!webUserAuthService.Teacher_Email_Overlap(email)) {
					
					// 인증 번호
					String code = kr.co.onpe.common.common.numberGen(6,1);
					
					// 인증받을 이메일과 인증번호를 DB에 저장한다.
					boolean queryResult = student_information_service.Create_Student_Email_Authentication_Code(email, code);
					
					if(queryResult) {
						email_authentication_sendMailThread sendMailThread = new email_authentication_sendMailThread(email, code, mailSender);
						
						workExecutor.execute(sendMailThread);
						return "success";
						
					}else {
						return "fail";
					}
					
				}else {
					return "email_overlap";
				}
			}else {
				return "unvalid_email";
			}
		}else {
			return "fail";
		}
	}
	
	/* 이메일 인증코드 검증 */
	@ResponseBody
	@RequestMapping(value = "/email_authentication_eheck", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String email_authentication_check(Locale locale, HttpServletRequest request) {
		String email = request.getParameter("teacher_email");
		String authentication_code = request.getParameter("authentication_code");
		
		if(email != null && authentication_code != null) {
			if(student_information_service.Student_Email_Authentication_Code_Check(email, authentication_code)) {	//이메일 인증코드 검증
				return "success";
			}else {
				return "fail";
			}
		}else {
			return "fail";
		}
	}
	
	/* 선생 학교 변경 */
	@ResponseBody
	@RequestMapping(value = "/mypage_school_change", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String mypage_school_change(Locale locale, HttpSession session, HttpServletRequest request) {
		//System.out.println("메인페이지 접근 <로그인 완료된사람만 들어올 수 있음>");
		
		if(session.getAttribute("teacher_id") == null || session.getAttribute("teacher_token") == null || session.getAttribute("admin_auth") == null) {
			return "fail";
		}else {
			String token = (String)session.getAttribute("teacher_token");
			String sessionUid = (String)session.getAttribute("teacher_id");
			String sessionUAuth = (String)session.getAttribute("admin_auth");
			
			//토큰 유효성 + 사용자 일치성 체크
			String new_token = jwtTokenProvider.TokenCheck(sessionUid, sessionUAuth, token);
			if(new_token.equals("fail") || new_token.equals("expired")) {
				return "fail";
			}else {
				session.setAttribute("teacher_token", new_token);
				String teacher_id = request.getParameter("teacher_id");
				String school_name = request.getParameter("school_name");
				if(teacher_id != null && school_name != null) {
					if(webUserAuthService.Teacher_School_Change(teacher_id, school_name)) {
						session.setAttribute("teacher_school", school_name);
						return "success";
					}else {
						return "fail";
					}
				}else {
					return "fail";
				}
			}
		}
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/get_school_list", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String get_school_list(Locale locale, Model model, HttpServletRequest request) {
		
		String keyword = request.getParameter("keyword");
		
		if(keyword != null) {
											
			List result = webUserAuthService.Get_School_List(keyword);
			
			if(result.size() != 0) {
				Gson gson = new Gson();
				
				return gson.toJson(result);	
			}else {
				return null;
			}
			

		}
		return null;
	}
}
