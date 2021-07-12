package kr.co.onpe;

import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.onpe.security.JwtTokenProvider;
import kr.co.onpe.service.Student_Information_Service;
import kr.co.onpe.service.WebUserAuthService;
import kr.co.onpe.service.Web_Admin_Management_Service;
import kr.co.onpe.thread.sendMailThread;
import kr.co.onpe.vo.Student_Information_VO;
import kr.co.onpe.vo.Teacher_Information_Management_VO;

@Controller
@RequestMapping("/admin/member/*")
public class WebAdminMemberManagementController {

	private static final Logger logger = LoggerFactory.getLogger(WebAdminMemberManagementController.class);
	
	/* 사용자 정보 테이블(student_information) 테이블 관련 서비스 */
	@Inject
	private Web_Admin_Management_Service web_Admin_Management_Service;
	
	@Inject
	private WebUserAuthService webUserAuthService;
	
	/* 사용자 정보 테이블(student_information) 테이블 관련 서비스 */
	@Inject
	private Student_Information_Service student_information_service;
	
	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
	/* root-context.xml에 등록한 Bean 호출 ( 의존성 주입 **Autowired ) */
	@Autowired
	private JavaMailSender mailSender;
	
	@Resource(name = "workExecutor")
	private ThreadPoolTaskExecutor workExecutor;
	
	
	/* lms 회원관리 목록 */
	@RequestMapping(value = "/lms_member_management_list", produces = "application/json; charset=utf8", method = RequestMethod.GET)
	public String lms_member_management_list(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
			
			String page = request.getParameter("page");
			String sqlpage = null;
			String keyword = request.getParameter("keyword");
			String option = request.getParameter("option");
			
			if(option != null && keyword != null && keyword.length() < 21 && keyword.length() > 1) {
				if(keyword != null && keyword.length() > 1) {
					if(option.equals("이름")) {
						option = "teacher_name";
					}else if(option.equals("아이디")) {
						option = "teacher_id";
					}else {
						option = null;
						keyword = null;
					}
				}else {
					return "redirect:/admin/member/lms_member_management_list";
				}
			}else {
				option = null;
				keyword = null;
			}
			
			int pageing_start = 1;
			
			if(!kr.co.onpe.common.common.isInteger(page) || page == null || Integer.parseInt(page) < 0) {
				page = "1";
				sqlpage = "0";
			}else {
				pageing_start = 5*((Integer.parseInt(page) - 1) / 5) + 1;
				sqlpage = Integer.toString((Integer.parseInt(page) - 1)*15);
			}
			
			List teachers_list = web_Admin_Management_Service.Get_Teachers_List(keyword, option, sqlpage);
			
			String teacher_count = web_Admin_Management_Service.Get_Teachers_Count(keyword, option);
			
			int teacher_count_int = Integer.parseInt(teacher_count) / 15;
			int teacher_count_result = Integer.parseInt(teacher_count) % 15;
			if(teacher_count_result > 0) {
				teacher_count_int++;
			}
			
			
			model.addAttribute("teachers_list",teachers_list);
			model.addAttribute("teacher_count",teacher_count);
			model.addAttribute("page",page);
			model.addAttribute("last_page",Integer.toString(teacher_count_int));
			model.addAttribute("pageing_start",Integer.toString(pageing_start));
			if(teacher_count_int < pageing_start + 4) {
				model.addAttribute("pageing_last",Integer.toString(teacher_count_int));
			}else {
				model.addAttribute("pageing_last",Integer.toString(pageing_start + 4));
			}
			model.addAttribute("keyword",keyword);
			model.addAttribute("option",option);
			
			return "/admin/member/lms_member_management_list";
			
		}
	}
	
	/* lms 회원관리 상세 */
	@RequestMapping(value = "/lms_member_management_detail", produces = "application/json; charset=utf8", method = RequestMethod.GET)
	public String lms_member_management_detail(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
			
			String teacher_id = request.getParameter("teacher_id");
			String mode = request.getParameter("mode");
			
			if(mode != null) {
				if(mode.equals("create")) {
					// 성공
					model.addAttribute("mode",mode);
					return "/admin/member/lms_member_management_detail";	
				}else if(mode.equals("modify")) {
					if(teacher_id != null) {
						// 기존 선생님 정보 불러오기
						
						Teacher_Information_Management_VO teacher_information = web_Admin_Management_Service.Get_Teacher_Information(teacher_id);
						
						if(teacher_information != null) {
							
							model.addAttribute("teacher_information", teacher_information);
							model.addAttribute("mode",mode);
							model.addAttribute("teacher_id",teacher_id);
							
							return "/admin/member/lms_member_management_detail";							
						}else {
							return "redirect:/admin/member/lms_member_management_list";	
						}
						
					}else {
						return "redirect:/admin/member/lms_member_management_list";		
					}
				}else {
					return "redirect:/admin/member/lms_member_management_list";
				}
			}else {
				return "redirect:/admin/member/lms_member_management_list";
			}			
		}
	}
	
	
	
	
	/* 앱 회원관리 목록 */
	@RequestMapping(value = "/app_member_management_list", produces = "application/json; charset=utf8", method = RequestMethod.GET)
	public String app_member_management_list(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
			
			String page = request.getParameter("page");
			String sqlpage = null;
			String keyword = request.getParameter("keyword");
			String option = request.getParameter("option");
			
			if(option != null && keyword != null && keyword.length() < 21 && keyword.length() > 1) {
				if(keyword != null && keyword.length() > 1) {
					if(option.equals("이름")) {
						option = "student_name";
					}else if(option.equals("아이디")) {
						option = "student_id";
					}else {
						option = null;
						keyword = null;
					}
				}else {
					return "redirect:/admin/member/app_member_management_list";
				}
			}else {
				option = null;
				keyword = null;
			}
			
			int pageing_start = 1;
			
			if(!kr.co.onpe.common.common.isInteger(page) || page == null || Integer.parseInt(page) < 0) {
				page = "1";
				sqlpage = "0";
			}else {
				pageing_start = 5*((Integer.parseInt(page) - 1) / 5) + 1;
				sqlpage = Integer.toString((Integer.parseInt(page) - 1)*15);
			}
			
			List students_list = web_Admin_Management_Service.Get_Students_List(keyword, option, sqlpage);
			
			String student_count = web_Admin_Management_Service.Get_Students_Count(keyword, option);
			
			int student_count_int = Integer.parseInt(student_count) / 15;
			int student_count_result = Integer.parseInt(student_count) % 15;
			if(student_count_result > 0) {
				student_count_int++;
			}
			
			
			model.addAttribute("students_list",students_list);
			model.addAttribute("student_count",student_count);
			model.addAttribute("page",page);
			model.addAttribute("last_page",Integer.toString(student_count_int));
			model.addAttribute("pageing_start",Integer.toString(pageing_start));
			if(student_count_int < pageing_start + 4) {
				model.addAttribute("pageing_last",Integer.toString(student_count_int));
			}else {
				model.addAttribute("pageing_last",Integer.toString(pageing_start + 4));
			}
			model.addAttribute("keyword",keyword);
			model.addAttribute("option",option);
			
			return "/admin/member/app_member_management_list";
			
		}
	}
	
	/* 앱 회원관리 상세 */
	@RequestMapping(value = "/app_member_management_detail", produces = "application/json; charset=utf8", method = RequestMethod.GET)
	public String app_member_management_detail(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
			
			String student_id = request.getParameter("student_id");
			String mode = request.getParameter("mode");
			
			if(mode != null) {
				if(mode.equals("create")) {
					// 성공
					model.addAttribute("mode",mode);
					return "/admin/member/app_member_management_detail";
				}else if(mode.equals("modify")) {
					if(student_id != null) {
						
						Student_Information_VO student_information = web_Admin_Management_Service.Get_Student_Information(student_id);
						
						if(student_information != null) {
							
							model.addAttribute("student_information", student_information);
							model.addAttribute("mode",mode);
							model.addAttribute("student_id",student_id);
							
							return "/admin/member/app_member_management_detail";						
						}else {
							return "redirect:/admin/member/app_member_management_list";	
						}
						
					}else {
						return "redirect:/admin/member/app_member_management_list";		
					}
				}else {
					return "redirect:/admin/member/app_member_management_list";
				}
			}else {
				return "redirect:/admin/member/app_member_management_list";
			}			
		}
		
	}
	
	
	
	
	/* 앱 회원관리 처리 */
	@ResponseBody
	@RequestMapping(value = "/app_member_management_detail_work", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	public String app_member_management_detail_work(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				String student_id = request.getParameter("student_id");
				String state = request.getParameter("state");
				
				if(state.equals("delete")) {
					boolean result = web_Admin_Management_Service.Student_Delete_Information(student_id);
					if(result) {
						return "success";
					}else {
						return "fail";
					}
				}else if(state.equals("modify")) {
					
					String student_name = request.getParameter("student_name");
					String student_email = request.getParameter("student_email");
					String student_phone = request.getParameter("student_phone");
					String student_age = request.getParameter("student_age");
					String student_sex = request.getParameter("student_sex");
					String password_changed = request.getParameter("password_changed");
					String student_school = request.getParameter("student_school");
					String student_email_agreement = request.getParameter("student_email_agreement");
					String student_push_agreement = request.getParameter("student_push_agreement");
					
					if(student_id != null && student_name != null && student_email != null && password_changed != null && student_email_agreement != null && student_push_agreement != null) {
						
						if(student_name.length() < 1 || student_name.length() > 6) {
							return "fail";
						}else if(student_school != null && student_school.length() != 0 && (student_school.length() < 1 || student_school.length() > 30)) {
							return "fail";
						}else if(student_age != null && student_age.length() != 0 && student_age.length() > 2) {
							return "fail";
						}else if(student_sex != null && student_sex.length() != 0 && (!student_sex.equals("남자") && !student_sex.equals("여자"))) {
							return "fail";
						}else if(!kr.co.onpe.common.common.isValidEmail(student_email)){
							return "fail";
						}else if(student_phone != null && student_phone.length() != 0 && student_phone.length() != 13) {
							return "fail";
						}else if((!student_email_agreement.equals("0") && !student_email_agreement.equals("1")) || (!student_push_agreement.equals("0") && !student_push_agreement.equals("1"))){
							return "fail";
						}else {
							
							if(student_school.length() == 0) {
								student_school = null;
							}
							if(student_age.length() == 0) {
								student_age = null;
							}
							if(student_sex.length() == 0) {
								student_sex = null;
							}else {
								if(student_sex.equals("남자")) {
									student_sex = "m";
								}else if(student_sex.equals("여자")) {
									student_sex = "f";
								}
							}
							if(student_phone.length() == 0) {
								student_phone = null;
							}
							

							
							String new_password = null;
							String sha256pw = null;
							
							if(password_changed.equals("y")) {
								try {
									
									new_password = kr.co.onpe.common.common.makePassword();
									sha256pw = kr.co.onpe.common.common.sha256(new_password);
									
								} catch (NoSuchAlgorithmException e) {
									return "fail";
								}	
							}
							
							String search_id_e = web_Admin_Management_Service.Get_Student_Email_For_Modify(student_email);
							
							if(search_id_e == null || search_id_e.equals(student_id)) {
								boolean result = web_Admin_Management_Service.Student_Modify_Information(sha256pw, student_age, student_email, student_email_agreement, student_id, student_name, student_phone, student_push_agreement, student_school, student_sex);
								
								if(result) {
									
									if(password_changed.equals("y")) {
										
										sendMailThread sendMailThread = new sendMailThread(student_email, new_password, mailSender);
										workExecutor.execute(sendMailThread);
										
									}
									
									return "success";
								}else {
									return "fail";
								}
								
							}else {
								return "email_overlap";
							}
														
						}
						
					}else {
						return "fail";
					}
					
				}else if(state.equals("create")) {
					
					String student_name = request.getParameter("student_name");
					String student_password = request.getParameter("student_password");
					String student_email = request.getParameter("student_email");
					String student_phone = request.getParameter("student_phone");
					String student_age = request.getParameter("student_age");
					String student_sex = request.getParameter("student_sex");
					String student_school = request.getParameter("student_school");
					String student_email_agreement = request.getParameter("student_email_agreement");
					String student_push_agreement = request.getParameter("student_push_agreement");
					
					if(student_id != null && student_name != null && student_email != null && student_password != null && student_email_agreement != null && student_push_agreement != null) {
						
						if(student_name.length() < 1 || student_name.length() > 6) {
							return "fail";
						}else if(student_school != null && student_school.length() != 0 && (student_school.length() < 1 || student_school.length() > 30)) {
							return "fail";
						}else if(student_age != null && student_age.length() != 0 && student_age.length() > 2) {
							return "fail";
						}else if(student_sex != null && student_sex.length() != 0 && (!student_sex.equals("남자") && !student_sex.equals("여자"))) {
							return "fail";
						}else if(student_id.length() < 3 || student_id.length() > 20) {
							return "fail";
						}else if(!kr.co.onpe.common.common.teacher_passwordCheck(student_password)) {
							return "fail";
						}else if(!kr.co.onpe.common.common.isValidEmail(student_email)){
							return "fail";
						}else if(student_phone != null && student_phone.length() != 0 && student_phone.length() != 13) {
							return "fail";
						}else if((!student_email_agreement.equals("0") && !student_email_agreement.equals("1")) || (!student_push_agreement.equals("0") && !student_push_agreement.equals("1"))){
							return "fail";
						}else {

							if(student_school.length() == 0) {
								student_school = null;
							}
							if(student_age.length() == 0) {
								student_age = null;
							}
							if(student_sex.length() == 0) {
								student_sex = null;
							}else {
								if(student_sex.equals("남자")) {
									student_sex = "m";
								}else if(student_sex.equals("여자")) {
									student_sex = "f";
								}
							}
							if(student_phone.length() == 0) {
								student_phone = null;
							}
							
							try {
								String sha256pw = kr.co.onpe.common.common.sha256(student_password);
								
								if(student_information_service.Id_Overlap_Check(student_id)) {
									return "id_overlap";
								}else if(student_information_service.Email_Overlap_Check(student_email)) {
									return "email_overlap";
								}else {
									
									SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
									format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
									Date time = new Date();
									String time_number = format.format(time);

									if(web_Admin_Management_Service.Student_Insert_Information(student_id, student_name, sha256pw, student_email, student_phone, student_age, student_sex, student_school, student_email_agreement, student_push_agreement, time_number)) {
										return "success";		
									}else {
										return "fail";
									}
									
								}
								
							} catch (NoSuchAlgorithmException e) {
								return "fail";
							}
						}
						
					}else {
						return "fail";
					}
					
				}else {
					return "fail";
				}
			}		
		}
		
	}
	
	/* lms 회원관리 처리 */
	@ResponseBody
	@RequestMapping(value = "/lms_member_management_detail_work", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	public String lms_member_management_detail_work(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				String state = request.getParameter("state");
				
				if(state.equals("delete")) {
					boolean result = web_Admin_Management_Service.Teacher_Delete_Information(teacher_id);
					if(result) {
						return "success";
					}else {
						return "fail";
					}
				}else if(state.equals("modify")) {
					
					String teacher_name = request.getParameter("teacher_name");
					String teacher_email = request.getParameter("teacher_email");
					String teacher_phone = request.getParameter("teacher_phone");
					String teacher_birth = request.getParameter("teacher_birth");
					String teacher_sex = request.getParameter("teacher_sex");
					String password_changed = request.getParameter("password_changed");
					String teacher_school = request.getParameter("teacher_school");
					String teacher_email_agreement = request.getParameter("teacher_email_agreement");
					String teacher_message_agreement = request.getParameter("teacher_message_agreement");
					
					if(teacher_id != null && teacher_name != null && password_changed != null && teacher_birth != null && teacher_email != null && teacher_phone != null && teacher_sex != null && teacher_school != null && teacher_email_agreement != null && teacher_message_agreement != null) {
						
						if(teacher_name.length() < 1 || teacher_name.length() > 10) {
							return "fail";
						}else if(teacher_school.length() < 1 || teacher_school.length() > 30) {
							return "fail";
						}else if(teacher_birth.length() != 8) {
							return "fail";
						}else if(!teacher_sex.equals("남자") && !teacher_sex.equals("여자")) {
							return "fail";
						}else if(!kr.co.onpe.common.common.isValidEmail(teacher_email)){
							return "fail";
						}else if(teacher_phone.length() != 11) {
							return "fail";
						}else if((!teacher_email_agreement.equals("0") && !teacher_email_agreement.equals("1")) || (!teacher_message_agreement.equals("0") && !teacher_message_agreement.equals("1"))){
							return "fail";
						}else {
							
							if(teacher_sex.equals("남자")) {
								teacher_sex = "m";
							}else {
								teacher_sex = "f";
							}
							
							String new_password = null;
							String sha256pw = null;
							
							if(password_changed.equals("y")) {
								try {
									
									new_password = kr.co.onpe.common.common.makePassword();
									sha256pw = kr.co.onpe.common.common.sha256(new_password);
									
								} catch (NoSuchAlgorithmException e) {
									return "fail";
								}	
							}
							
							String search_id_e = web_Admin_Management_Service.Get_Teacher_Email_For_Modify(teacher_email);
							String search_id_p = web_Admin_Management_Service.Get_Teacher_Phone_For_Modify(teacher_phone);
							
							if(search_id_e == null || search_id_e.equals(teacher_id)) {
								
								if(search_id_p == null || search_id_p.equals(teacher_id)) {
									
									boolean result = web_Admin_Management_Service.Teacher_Modify_Information(teacher_id, sha256pw, teacher_name, teacher_birth, teacher_sex, teacher_school, teacher_email, teacher_phone, teacher_email_agreement, teacher_message_agreement);
									
									if(result) {
										
										if(password_changed.equals("y")) {
											
											sendMailThread sendMailThread = new sendMailThread(teacher_email, new_password, mailSender);
											workExecutor.execute(sendMailThread);
											
										}
										
										return "success";
									}else {
										return "fail";
									}
									
								}else {
									return "phone_overlap";
								}
								
							}else {
								return "email_overlap";
							}
														
						}
						
					}else {
						return "fail";
					}
					
				}else if(state.equals("create")) {
					
					String teacher_name = request.getParameter("teacher_name");
					String teacher_password = request.getParameter("teacher_password");
					String teacher_email = request.getParameter("teacher_email");
					String teacher_phone = request.getParameter("teacher_phone");
					String teacher_birth = request.getParameter("teacher_birth");
					String teacher_sex = request.getParameter("teacher_sex");
					String teacher_school = request.getParameter("teacher_school");
					String teacher_email_agreement = request.getParameter("teacher_email_agreement");
					String teacher_message_agreement = request.getParameter("teacher_message_agreement");
					
					if(teacher_id != null && teacher_name != null && teacher_password != null && teacher_birth != null && teacher_email != null && teacher_phone != null && teacher_sex != null && teacher_school != null && teacher_email_agreement != null && teacher_message_agreement != null) {
						
						if(teacher_name.length() < 1 || teacher_name.length() > 10) {
							return "fail";
						}else if(teacher_school.length() < 1 || teacher_school.length() > 30) {
							return "fail";
						}else if(teacher_birth.length() != 8) {
							return "fail";
						}else if(!teacher_sex.equals("남자") && !teacher_sex.equals("여자")) {
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
							if(teacher_sex.equals("남자")) {
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
										return "success";		
									}else {
										return "fail";
									}
									
								}
								
							} catch (NoSuchAlgorithmException e) {
								return "fail";
							}
						}
						
					}else {
						return "fail";
					}
					
				}else {
					return "fail";
				}
			}		
		}
	}
	
}
