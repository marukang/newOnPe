package kr.co.onpe;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;
import java.util.UUID;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;

import kr.co.onpe.security.JwtTokenProvider;
import kr.co.onpe.service.WebUserAuthService;
import kr.co.onpe.service.Web_Teacher_Ready_Service;
import kr.co.onpe.thread.CreateUser_sendMailThread;
import kr.co.onpe.vo.Auto_Curriculum_List_VO;
import kr.co.onpe.vo.Class_List_VO;
import kr.co.onpe.vo.Content_List_VO;
import kr.co.onpe.vo.Curriculum_Content_List_VO;
import kr.co.onpe.vo.Curriculum_Unit_List_Class_VO;
import kr.co.onpe.vo.Exercise_Category_VO;
import kr.co.onpe.vo.Json_Class_Project_Submit_Type_VO;
import kr.co.onpe.vo.Json_Class_Unit_List_VO;
import kr.co.onpe.vo.SmarteditorVO;
import kr.co.onpe.vo.Student_Information_VO;

@Controller
@RequestMapping("/teacher/ready/*")
public class WebTeacherReadyController {
	
	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
	/* 서비스 */
	@Inject
	private Web_Teacher_Ready_Service web_Teacher_Service;
	
	/* 파일경로 */
	@Resource(name="Curriculum_uploadPath")
    String Curriculum_uploadPath;
	
	/* 선생 정보 테이블(teacher_information) 테이블 관련 서비스 */
	@Inject
	private WebUserAuthService webUserAuthService;
	
	/* root-context.xml에 등록한 Bean 호출 ( 의존성 주입 **Autowired ) */
	@Autowired
	private JavaMailSender mailSender;
	
	@Resource(name = "workExecutor")
	private ThreadPoolTaskExecutor workExecutor;
	
	private static final Logger logger = LoggerFactory.getLogger(WebTeacherReadyController.class);
	
	/* 링크생성 페이지 */
	@RequestMapping(value = "/create_link", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String create_link(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				model.addAttribute("teacher_school", (String)session.getAttribute("teacher_school"));
				return "/teacher/ready/create_link";
			}
		}
	}
	
	/* 이미 생성된 링크 불러오기 */
	@ResponseBody
	@RequestMapping(value = "/get_my_link", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String get_my_link(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				String class_year = request.getParameter("class_year");
				String class_semester = request.getParameter("class_semester");
				String class_grade = request.getParameter("class_grade");
				String class_group = request.getParameter("class_group");
				
				if(class_year != null && class_semester != null && class_year.length() == 4 && class_semester.length() > 0) {
					
					if(class_grade != null && ( class_grade.length() < 1 || class_grade.length() > 2 ) && !kr.co.onpe.common.common.isInteger(class_grade)) {
						class_grade = null;
					}
					if(class_group != null && ( class_group.length() < 1 || class_group.length() > 2 ) && !kr.co.onpe.common.common.isInteger(class_group)) {
						class_group = null;
					}
					if(kr.co.onpe.common.common.isInteger(class_year) && kr.co.onpe.common.common.isInteger(class_semester)) {
						Gson gson = new Gson();
						List data = web_Teacher_Service.Get_Class_List_For_Create_Link(sessionUid, class_year, class_semester, class_grade, class_group);
						return gson.toJson(data);	
					}else {
						return "fail";
					}
				}else {
					return "fail";
				}
			}
		}
	}
	
	/* 링크생성 페이지에서 학급정원 변경 */
	@ResponseBody
	@RequestMapping(value = "/change_max_count", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String change_max_count(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				String class_code = request.getParameter("class_code");
				String class_people_max_count = request.getParameter("max_count");
				
				if(class_code != null && class_people_max_count != null && class_people_max_count.length() < 3) {
					
					if(web_Teacher_Service.Change_Class_People_Max_Count(class_people_max_count, sessionUid, class_code)) {
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
	
	/* 클래스 링크 생성 */
	@ResponseBody
	@RequestMapping(value = "/create_link_work", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String create_link_work(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				String school_name = (String)session.getAttribute("teacher_school");
				String class_year = request.getParameter("class_year");
				String class_semester = request.getParameter("class_semester");
				String class_grade = request.getParameter("class_grade");
				String class_group = request.getParameter("class_group");
				String class_people_max_count = request.getParameter("class_people_max_count");
				
				if(school_name != null && class_year != null && class_semester != null && class_grade != null && class_group != null && class_people_max_count != null) {
					
					if(kr.co.onpe.common.common.isInteger(class_year) && kr.co.onpe.common.common.isInteger(class_semester) && kr.co.onpe.common.common.isInteger(class_grade) && kr.co.onpe.common.common.isInteger(class_group) && kr.co.onpe.common.common.isInteger(class_people_max_count)) {
						//세션의 가지고있는 클래스코드목록에 생성된 클래스코드를 추가해야한다.
						String class_group_z = null;
						if(Integer.parseInt(class_group) < 10) {
							class_group_z = "0"+class_group;
						}else {
							class_group_z = class_group;
						}
						
						String class_code = school_name + "_" + class_grade + class_group_z + class_semester + Integer.toString((int)(Math.random() * 10)) + Integer.toString((int)(Math.random() * 10)) + Integer.toString((int)(Math.random() * 10));

						boolean result = web_Teacher_Service.Create_Class_List_For_Create_Link(sessionUid, class_code, class_year, class_semester, class_grade, class_group, "0", class_people_max_count);
						if(result) {
							
							List<String> classcode_list = webUserAuthService.Get_Classcode_List(sessionUid);
							session.setAttribute("teacher_classcode", classcode_list);
							return class_code;	
						}else {
							return "fail";
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
	
	/* 클래스 링크 삭제 */
	@ResponseBody
	@RequestMapping(value = "/delete_link_work", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String delete_link_work(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				String class_code = request.getParameter("class_code");
				
				if(class_code != null && class_code.length() > 8) {
					
					List<String> classcode_list = webUserAuthService.Get_Classcode_List(sessionUid);
					boolean isMine = false;
					for(int x=0;x<classcode_list.size();x++) {
						if(classcode_list.get(x).equals(class_code)) {
							isMine = true;
							break;
						}
					}
					
					if(isMine) {
						boolean result = web_Teacher_Service.Delete_Class_List_For_Create_Link(class_code);
						if(result) {
							classcode_list = null;
							classcode_list = webUserAuthService.Get_Classcode_List(sessionUid);
							session.setAttribute("teacher_classcode", classcode_list);	
							return "success";	
						}else {
							return "fail";
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
	
	/* 수업 구성관리 페이지 */
	@RequestMapping(value = "/class_configuration_management_list", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String class_configuration_management_list(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				String class_grade = request.getParameter("class_grade");
				String class_group = request.getParameter("class_group");
				String class_start_date = request.getParameter("class_start_date");
				String class_end_date = request.getParameter("class_end_date");
				String keyword = request.getParameter("keyword");
				String page = request.getParameter("page");
				String sqlpage = null;
				String pageing_url = "/teacher/ready/class_configuration_management_list?ck=1";
				if(class_grade != null && class_grade.length()>0) {
					pageing_url += "&class_grade"+class_grade;
				}else {
					class_grade = null;
				}
				if(class_group != null && class_group.length()>0) {
					pageing_url += "&class_group"+class_group;
				}else {
					class_group = null;
				}
				if((class_start_date != null && class_start_date.length() == 8) && (class_end_date != null && class_end_date.length() == 8)) {
					pageing_url += "&class_start_date"+class_start_date;
					pageing_url += "&class_end_date"+class_end_date;
				}else {
					class_start_date = null;
					class_end_date = null;
				}
				if(keyword != null && keyword.length()>1) {
					pageing_url += "&keyword"+keyword;
				}else {
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

				List class_list = web_Teacher_Service.Get_Class_List_For_Management(sessionUid, class_grade, class_group, class_start_date, class_end_date, keyword, sqlpage);
				
				String class_count = web_Teacher_Service.Get_Class_List_Count_For_Management(sessionUid, class_grade, class_group, class_start_date, class_end_date, keyword);
				
				if(class_count == null) {
					class_count = "0";
				}
				int push_count_int = Integer.parseInt(class_count) / 15;
				int push_count_result = Integer.parseInt(class_count) % 15;
				if(push_count_result > 0) {
					push_count_int++;
				}
				
				model.addAttribute("class_list", class_list);
				model.addAttribute("page",page);
				model.addAttribute("last_page",Integer.toString(push_count_int));
				model.addAttribute("pageing_start",Integer.toString(pageing_start));
				if(push_count_int < pageing_start + 4) {
					model.addAttribute("pageing_last",Integer.toString(push_count_int));
				}else {
					model.addAttribute("pageing_last",Integer.toString(pageing_start + 4));
				}
				model.addAttribute("keyword",keyword);
				model.addAttribute("class_grade",class_grade);
				model.addAttribute("class_group",class_group);
				model.addAttribute("class_start_date",class_start_date);
				model.addAttribute("class_end_date",class_end_date);
				model.addAttribute("pageing_url",pageing_url);
				
				return "/teacher/ready/class_configuration_management_list";
			}
		}
	}
	
	
	/* 수업 구성관리 상세 페이지 */
	@RequestMapping(value = "/class_configuration_management_detail", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String class_configuration_management_detail(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				String class_code = request.getParameter("class_code");
				
				if(class_code == null) {
					model.addAttribute("class_unit_list_check","null");
					return "redirect:/teacher/ready/class_configuration_management_list";
				}
				
				Class_List_VO class_list = web_Teacher_Service.Get_Class_List_For_Management_Detail(sessionUid, class_code);
				
				Gson gson = new Gson();
				
				model.addAttribute("class_code", class_code);
				
				if(class_list != null) {
					List<Json_Class_Project_Submit_Type_VO> type = null;
					if(class_list.getClass_project_submit_type() != null) {
						type = gson.fromJson(class_list.getClass_project_submit_type(), new TypeToken<List<Json_Class_Project_Submit_Type_VO>>(){}.getType());
						model.addAttribute("type",type);
					}
					List<Json_Class_Unit_List_VO> unit_list = null;
					if(class_list.getClass_unit_list() != null) {
						unit_list = gson.fromJson(class_list.getClass_unit_list(), new TypeToken<List<Json_Class_Unit_List_VO>>(){}.getType());
						model.addAttribute("unit_list",unit_list);
					}

					model.addAttribute("class_list",class_list);
					
					if(class_list.getClass_unit_list() == null) {
						model.addAttribute("class_unit_list_check","null");
						model.addAttribute("class_unit_list_object","\"null\"");
					}else {
						model.addAttribute("class_unit_list_check","notnull");
						model.addAttribute("class_unit_list_object",class_list.getClass_unit_list());
					}

					return "/teacher/ready/class_configuration_management_detail";	
				}else {
					model.addAttribute("class_unit_list_check","null");	
					return "redirect:/teacher/ready/class_configuration_management_list";
				}
			}
		}
	}
	
	/* 수업 구성관리 상세 수정 페이지 */
	@ResponseBody
	@RequestMapping(value = "/class_configuration_management_detail_work", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String class_configuration_management_detail_work(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				String teacher_id = sessionUid;
				String class_code = request.getParameter("class_code");
				String mode = request.getParameter("mode");
				if(class_code != null) {
					if(mode.equals("default")) {
						String class_people_max_count = request.getParameter("class_people_max_count");
						String class_name = request.getParameter("class_name");
						String class_start_date = request.getParameter("class_start_date");
						String class_end_date = request.getParameter("class_end_date");
						String class_project_submit_type = request.getParameter("class_project_submit_type");
						if(class_people_max_count != null && class_name != null && class_start_date != null && class_end_date != null && class_project_submit_type != null) {
							if(class_people_max_count.length() < 1 || class_people_max_count.length() > 2 || !kr.co.onpe.common.common.isInteger(class_people_max_count)) {
								return "fail";	
							}else if(class_name.length() < 1 || class_name.length() > 50) {
								return "fail";
							}else if(class_start_date.length() != 8 || class_end_date.length() != 8) {
								return "fail";
							}else if(class_project_submit_type.length() < 10) {
								return "fail";
							}else {
																									  			
								boolean result = web_Teacher_Service.Update_Class_List_For_Management(teacher_id, class_code, class_people_max_count, class_name, class_start_date, class_end_date, class_project_submit_type, null);
								if(result) {
									return "success";
								}else {
									return "fail";
								}
							}
						}else {
							return "fail";
						}
					}else {
						String class_unit_list = request.getParameter("class_unit_list");
						if(class_unit_list.length() > 1) {
							
							boolean result = web_Teacher_Service.Update_Class_List_For_Management(teacher_id, class_code, null, null, null, null, null, class_unit_list);
							if(result) {
								return "success";
							}else {
								return "fail";
							}
						}else {
							return "fail";
						}
					}
				}else {
					return "fail";
				}
			}
		}
	}
	
	/* 추천 커리큘럼 자동완성 커리큘럼 리스트 불러오기 */
	@ResponseBody
	@RequestMapping(value = "/curriculum_auto_make_search", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String curriculum_auto_make_search(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				String class_level = request.getParameter("class_level");
				String class_grade = request.getParameter("class_grade");
				String class_semester = request.getParameter("class_semester");
				
				String keyword_option = request.getParameter("keyword_option");
				String keyword = request.getParameter("keyword");
				String sort = request.getParameter("sort");
				String page = request.getParameter("page");
				String sqlpage = null;

				if(class_level != null && class_grade != null && class_semester != null && keyword_option != null && sort != null) {
					
					if(class_level.equals("전체")) {
						class_level = null;
					}else {
						if(class_level.equals("초등학교")) {
							class_level = "1";
						}else if(class_level.equals("중학교")) {
							class_level = "2";
						}else if(class_level.equals("고등학교")) {
							class_level = "3";
						}else if(class_level.equals("기타")) {
							class_level = "4";
						}
					}
					if(class_grade.equals("전체")) {
						class_grade = null;
					}else {
						if(class_grade.equals("1학년")) {
							class_grade = "1";
						}else if(class_grade.equals("2학년")) {
							class_grade = "2";
						}else if(class_grade.equals("3학년")) {
							class_grade = "3";
						}else if(class_grade.equals("4학년")) {
							class_grade = "4";
						}else if(class_grade.equals("5학년")) {
							class_grade = "5";
						}else if(class_grade.equals("6학년")) {
							class_grade = "6";
						}
					}
					if(class_semester.equals("전체")) {
						class_semester = null;
					}else {
						if(class_semester.equals("1학기")) {
							class_semester = "1";
						}else if(class_semester.equals("2학기")) {
							class_semester = "2";
						}
					}

					if(keyword.length() < 2) {
						keyword = null;
					}
					
					if(!sort.equals("최신순") && !sort.equals("오래된순")) {
						return "fail";
					}
					
					int pageing_start = 1;
					
					if(!kr.co.onpe.common.common.isInteger(page) || page == null || Integer.parseInt(page) <= 0) {
						page = "1";
						sqlpage = "0";
					}else {
						pageing_start = 5*((Integer.parseInt(page) - 1) / 5) + 1;
						sqlpage = Integer.toString((Integer.parseInt(page) - 1)*10);
					}
					
					Gson gson = new Gson();
					List curriculum_list = web_Teacher_Service.Get_Auto_Make_Curriculum(class_level, class_grade, class_semester, keyword_option, keyword, sort, sqlpage);
					String curriculum_count = web_Teacher_Service.Get_Auto_Make_Curriculum_Count(class_level, class_grade, class_semester, keyword_option, keyword);
					
					if(curriculum_count == null) {
						curriculum_count = "0";
					}
					int push_count_int = Integer.parseInt(curriculum_count) / 10;
					int push_count_result = Integer.parseInt(curriculum_count) % 10;
					if(push_count_result > 0) {
						push_count_int++;
					}
					
					HashMap<String, Object> data = new HashMap<String, Object>();
					data.put("curriculum_list", curriculum_list);
					data.put("last_page", Integer.toString(push_count_int));
					data.put("pageing_start", Integer.toString(pageing_start));
					if(push_count_int < pageing_start + 4) {
						data.put("pageing_last", Integer.toString(push_count_int));
					}else {
						data.put("pageing_last", Integer.toString(pageing_start + 4));
					}
					
					return gson.toJson(data);
					
					
				}else {
					return "fail";
				}
				
			}
		}
	}
	
	/* 추천 커리큘럼 자동완성 커리큘럼 저장 */
	@ResponseBody
	@RequestMapping(value = "/curriculum_auto_make_save", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String curriculum_auto_make_save(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				String teacher_id = sessionUid;
				String class_code = request.getParameter("class_code");
				String curriculum_code = request.getParameter("curriculum_code");
				
				Auto_Curriculum_List_VO curriculum = web_Teacher_Service.Get_Auto_Make_Curriculum_One(curriculum_code);
				
				if(curriculum != null) {
					
					SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
					format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
					Date time = new Date();
					String time_number = format.format(time);
					List<String> new_unit_code = new ArrayList<String>();
					
					String class_code_list = curriculum.getClass_code_list();
					Gson gson = new Gson();
					List<Json_Class_Unit_List_VO> unit_list = gson.fromJson(class_code_list, new TypeToken<List<Json_Class_Unit_List_VO>>(){}.getType());
					List<String> unit_code_list = new ArrayList<String>();
					
					for(int x=0;x<unit_list.size();x++) {
						unit_code_list.add(unit_list.get(x).getUnit_code());
						new_unit_code.add(time_number + Integer.toString(x) + class_code + teacher_id);
					}
					
					for(int x=0;x<unit_list.size();x++) {
						unit_list.get(x).setUnit_code(new_unit_code.get(x));
					}
					
					class_code_list = gson.toJson(unit_list);
					
					List<Curriculum_Unit_List_Class_VO> result = web_Teacher_Service.Get_Curriculum_Unit_List_Class_For_Auto_Make(unit_code_list);
					
					if(result != null) {
						
						for(int x=0;x<result.size();x++) {
							
							for(int xx=0;xx<unit_code_list.size();xx++) {
								if(unit_code_list.get(xx).equals(result.get(x).getUnit_code())) {
									result.get(x).setUnit_code(new_unit_code.get(xx));//유닛코드 변경		
								}
							}
							
							result.get(x).setClass_code(class_code);//클래스코드 변경
							
							result.get(x).setUnit_group_name(null);
							result.get(x).setUnit_group_id_list(null);
							result.get(x).setContent_participation(null);
							result.get(x).setContent_submit_task(null);
						}
						
						boolean create_query = web_Teacher_Service.Create_Curriculum_Unit_List_Class_For_Auto_Make(result);
						if(create_query) {
							boolean update_result = web_Teacher_Service.Update_Class_List_For_Management(teacher_id, class_code, null, null, null, null, null, class_code_list);
							if(update_result) {
								return "success";
							}else {
								return "fail";
							}
						}else {
							return "fail";
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
	
	/* 커리큘럼 리셋 */
	@ResponseBody
	@RequestMapping(value = "/curriculum_reset", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String curriculum_reset(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				String teacher_id = sessionUid;
				String class_code = request.getParameter("class_code");
				
				web_Teacher_Service.Reset_Curriculum_Unit_List_Class(teacher_id, class_code);
				return "success";
			}
		}
	}
	
	/* 단일 커리큘럼 리스트 불러오기 */
	@ResponseBody
	@RequestMapping(value = "/get_curriculum_unit_list_class", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String get_curriculum_unit_list_class(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				String unit_code = request.getParameter("unit_code");
				String class_code = request.getParameter("class_code");
				
				List curriculum_unit_list = web_Teacher_Service.Get_Curriculum_Unit_LIst_Class(unit_code, class_code);
				Gson gson = new Gson();
				return gson.toJson(curriculum_unit_list);	
				
			}
		}
	}

	/* 커리큘럼 수정 or 생성 or 복제 or 삭제 */
	@ResponseBody
	@RequestMapping(value = "/class_configuration_management_detail_curriculum_work", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String class_configuration_management_detail_curriculum_work(Locale locale, Model model, HttpSession session, MultipartHttpServletRequest request) {
		
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
				
				
				String mode = request.getParameter("mode");
				String unit_code = request.getParameter("unit_code");
				String class_code = request.getParameter("class_code");
				String content_code_list = request.getParameter("content_code_list");
				String content_evaluation_type = request.getParameter("content_evaluation_type");
				String content_home_work = request.getParameter("content_home_work");
				String content_test = request.getParameter("content_test");
				String unit_attached_file = request.getParameter("unit_attached_file");
				if(unit_attached_file != null && unit_attached_file.length() < 6) {
					unit_attached_file = null;
				}
				String delete_files = request.getParameter("delete_files");
				String unit_youtube_url = request.getParameter("unit_youtube_url");
				String unit_content_url = request.getParameter("unit_content_url");
				String unit_start_date = request.getParameter("unit_start_date");
				String unit_end_date = request.getParameter("unit_end_date");
				String unit_class_type = request.getParameter("unit_class_type");
				String unit_class_name = request.getParameter("unit_class_name");
				String unit_class_text = request.getParameter("unit_class_text");
				
				if(unit_youtube_url == null || unit_youtube_url.length() < 3 || unit_youtube_url.equals("null")) {
					unit_youtube_url = null;
				}
				if(unit_content_url == null || unit_content_url.length() < 3 || unit_content_url.equals("null")) {
					unit_content_url = null;
				}
				
				SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
				format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date time = new Date();
				String time_number = format.format(time);
				
				if(mode.equals("copy")) {
					
					if(unit_code != null && class_code != null) {
						
						Class_List_VO class_list = web_Teacher_Service.Get_Class_List_For_Management_Detail(sessionUid, class_code);
						
						if(class_list.getClass_unit_list() == null) {
							return "fail";
						}
						
						Gson gson = new Gson();
						
						//기존 유닛리스트
						List<Json_Class_Unit_List_VO> unit_list = gson.fromJson(class_list.getClass_unit_list(), new TypeToken<List<Json_Class_Unit_List_VO>>(){}.getType());
						
						if(unit_list.size() < 1) {
							return "fail";
						}
						
						Json_Class_Unit_List_VO new_unit_list = new Json_Class_Unit_List_VO(); //신규 유닛리스트
						
						String new_unit_code = time_number + class_code + sessionUid;
						List<Curriculum_Unit_List_Class_VO> curriculum_unit_list_class = web_Teacher_Service.Get_Curriculum_Unit_LIst_Class(unit_code, class_code);
						
						if(curriculum_unit_list_class.size() < 1) {
							return "fail";
						}
						
						for(int x=0;x<curriculum_unit_list_class.size();x++) {
							if(x == 0) {
								new_unit_list.setUnit_class_name(curriculum_unit_list_class.get(x).getUnit_class_name());
								new_unit_list.setUnit_code(new_unit_code);
								new_unit_list.setUnit_start_date(curriculum_unit_list_class.get(x).getUnit_start_date());
								new_unit_list.setUnit_end_date(curriculum_unit_list_class.get(x).getUnit_end_date());
							}
							curriculum_unit_list_class.get(x).setUnit_code(new_unit_code);
							curriculum_unit_list_class.get(x).setUnit_group_id_list(null);
							curriculum_unit_list_class.get(x).setContent_participation(null);
							curriculum_unit_list_class.get(x).setContent_submit_task(null);
							curriculum_unit_list_class.get(x).setContent_use_time("0");
							
							String before_unit_attached_file = curriculum_unit_list_class.get(x).getUnit_attached_file();
							
							if(before_unit_attached_file != null) {
								
								List<String> new_unit_attached_file = new ArrayList<String>();
								
								List<String> temp = gson.fromJson(before_unit_attached_file, new TypeToken<List<String>>(){}.getType());

								for(int xx=0;xx<temp.size();xx++) {
									String fileName = temp.get(xx);
									String newFileName = null;
									if(kr.co.onpe.common.common.checkImageType(fileName)) {
										newFileName = Curriculum_uploadPath+"/"+sessionUid + time_number+ Integer.toString(x) + Integer.toString(xx) + ".jpg";
									}else {
										newFileName = Curriculum_uploadPath+"/"+sessionUid + time_number+ Integer.toString(x) + Integer.toString(xx) + ".pdf";
									}
									
									File in = new File(fileName);
									File out = new File(newFileName);
									
									try {
										if(in.exists()) {
											FileCopyUtils.copy(in, out);
											new_unit_attached_file.add(newFileName);
										}
									} catch (IOException e) {
										// TODO Auto-generated catch block
										e.printStackTrace();
									}
								}
								if(new_unit_attached_file.size() > 0) {
									curriculum_unit_list_class.get(x).setUnit_attached_file(gson.toJson(new_unit_attached_file));	
								}else {
									curriculum_unit_list_class.get(x).setUnit_attached_file(null);
								}
							}
						}
						unit_list.add(new_unit_list);
						
						boolean result = web_Teacher_Service.Create_Curriculum_Unit_List_Class_List(curriculum_unit_list_class);
						
						if(result) {
							if(web_Teacher_Service.Update_Class_List_For_Management(sessionUid, class_code, null, null, null, null, null, gson.toJson(unit_list))) {
								return "success";
							}else {
								return "fail";
							}
						}else {
							return "fail";
						}
					}else {
						return "fail";
					}
				
				}else if(mode.equals("delete")) {
					
					if(unit_code != null && class_code != null) {
						
						Class_List_VO class_list = web_Teacher_Service.Get_Class_List_For_Management_Detail(sessionUid, class_code);
						
						if(class_list.getClass_unit_list() == null) {
							return "fail";
						}
						
						Gson gson = new Gson();
						
						//기존 유닛리스트
						List<Json_Class_Unit_List_VO> unit_list = gson.fromJson(class_list.getClass_unit_list(), new TypeToken<List<Json_Class_Unit_List_VO>>(){}.getType());
						
						if(unit_list.size() < 1) {
							return "fail";
						}

						for(int x=0;x<unit_list.size();x++) {
							if(unit_list.get(x).getUnit_code().equals(unit_code)) {
								unit_list.remove(x);
								break;
							}
						}
						List<Curriculum_Unit_List_Class_VO> curriculum_unit_list_class = web_Teacher_Service.Get_Curriculum_Unit_LIst_Class(unit_code, class_code);
						
						if(curriculum_unit_list_class.size() < 1) {
							return "fail";
						}
						
						List<String> temp = null;
						
						for(int x=0;x<curriculum_unit_list_class.size();x++) {
							String before_unit_attached_file = curriculum_unit_list_class.get(x).getUnit_attached_file();
							if(before_unit_attached_file != null) {
								temp = gson.fromJson(before_unit_attached_file, new TypeToken<List<String>>(){}.getType());
							}
						}
						boolean result = web_Teacher_Service.Delete_Curriculum_Unit_List_Class(unit_code, class_code);
						
						if(result) {
							
							if(temp != null) {
								for(int x=0;x<temp.size();x++) {
									File delete_file = new File(temp.get(x));
									if(delete_file.exists()) {
										delete_file.delete();							
									}	
								}
							}
							
							if(web_Teacher_Service.Update_Class_List_For_Management(sessionUid, class_code, null, null, null, null, null, gson.toJson(unit_list))) {
								return "success";
							}else {
								return "fail";
							}
						}else {
							return "fail";
						}
					}else {
						return "fail";
					}
					
				}else if(mode.equals("date_update")){
					
					if(unit_code != null && class_code != null && unit_start_date != null && unit_end_date != null && unit_start_date.length() == 12 && unit_end_date.length() == 12) {
						
						Class_List_VO class_list = web_Teacher_Service.Get_Class_List_For_Management_Detail(sessionUid, class_code);
						if(class_list == null || class_list.getClass_unit_list() == null) {
							return "fail";
						}
						Gson gson = new Gson();
						List<Json_Class_Unit_List_VO> unit_list = gson.fromJson(class_list.getClass_unit_list(), new TypeToken<List<Json_Class_Unit_List_VO>>(){}.getType());
						
						for(int x=0;x<unit_list.size();x++) {
							if(unit_list.get(x).getUnit_code().equals(unit_code)) {
								unit_list.get(x).setUnit_start_date(unit_start_date+"01");
								unit_list.get(x).setUnit_end_date(unit_end_date+"01");					
							}
						}
						
						if(web_Teacher_Service.Update_Curriculum_Unit_List_Class_Date(unit_start_date, unit_end_date, unit_code, class_code)) {
							if(web_Teacher_Service.Update_Class_List_For_Management(sessionUid, class_code, null, null, null, null, null, gson.toJson(unit_list))) {
								return "success";
							}else {
								return "fail";
							}
						}else {
							return "fail";
						}
						
					}else {
						return "fail";
					}
					
				}else {
					String type = request.getParameter("type");
					if(type != null && unit_class_name != null && unit_class_text != null && mode != null && class_code != null && content_code_list != null && content_evaluation_type != null && content_home_work  != null && content_test != null && unit_start_date != null && unit_end_date != null && unit_class_type != null) {

						if(mode.equals("modify") && (unit_code == null || unit_code.length() < 2)) {
							return "fail";
						}
						Gson gson = new Gson();
						if(type.equals("one")) {
							
							if(unit_class_name.length() < 2 || unit_class_text.length() < 2 || content_code_list.length() < 2 || class_code.length() < 2 || content_evaluation_type.length() < 2 || content_home_work.length() < 2 || content_test.length() < 2 || unit_start_date.length() != 12 || unit_end_date.length() != 12) {
								return "fail";
							}
							
							unit_start_date += "01";
							unit_end_date += "01";
							
							Class_List_VO class_list = web_Teacher_Service.Get_Class_List_For_Management_Detail(sessionUid, class_code);
							
							List<Json_Class_Unit_List_VO> unit_list = gson.fromJson(class_list.getClass_unit_list(), new TypeToken<List<Json_Class_Unit_List_VO>>(){}.getType());
							
							List<MultipartFile> fileList = request.getFiles("files");
							if(fileList.size() != 0) {
								if(fileList.get(0).getSize() != 0){
									for(MultipartFile this_file : fileList) {
										String fileName = this_file.getOriginalFilename();
										//확장자 체크 ( IMAGE or PDF )
										if(!kr.co.onpe.common.common.checkImageorPdfType(fileName)) {
								    		return "fail";
										}
									}
								}
								
								
								List<String> unit_attached_file_list = gson.fromJson(unit_attached_file, new TypeToken<List<String>>(){}.getType());
								
								int num = 1;
								for(MultipartFile this_file : fileList) {
									num++;
									String fileName = this_file.getOriginalFilename();
									String newFileName = null;
									if(kr.co.onpe.common.common.checkImageType(fileName)) {
										newFileName = sessionUid + time_number + Integer.toString(num) + ".jpg";
									}else {
										newFileName = sessionUid + time_number + Integer.toString(num) + ".pdf";
									}
									
									for(int x=0;x<unit_attached_file_list.size();x++) {
										if(unit_attached_file_list.get(x).equals(Curriculum_uploadPath+"/"+fileName)) {
											unit_attached_file_list.set(x, Curriculum_uploadPath+"/"+newFileName);
										}
									}
									
									File target = new File(Curriculum_uploadPath, newFileName);	//파일명
							        
							        //파일 복사
							        try {
							            FileCopyUtils.copy(this_file.getBytes(), target);
							            
							        } catch(Exception e) {
							            e.printStackTrace();
							    		return "fail";
							        }
								}
								unit_attached_file = gson.toJson(unit_attached_file_list);
							}
							
							if(mode.equals("modify")) {
								
								/* 클래스의 class_unit_list 변경 */
								for(int x=0;x<unit_list.size();x++) {
									if(unit_list.get(x).getUnit_code().equals(unit_code)) {
										unit_list.get(x).setUnit_class_name(unit_class_name);
										unit_list.get(x).setUnit_start_date(unit_start_date);
										unit_list.get(x).setUnit_end_date(unit_end_date);
										unit_list.get(x).setUnit_code(unit_code);								
									}
								}
					  
								if(web_Teacher_Service.Update_Curriculum_Unit_List_Class_ALL(unit_class_type, null, null, unit_class_name, unit_class_text, unit_start_date, unit_end_date, unit_youtube_url, unit_content_url, unit_attached_file, content_code_list, content_home_work, content_test, content_evaluation_type, unit_code, class_code)) {
									
									//파일삭제
									if(delete_files != null && delete_files.length() > 1 && !delete_files.equals("null")) {							
										List<String> delete_file_list = gson.fromJson(delete_files, new TypeToken<List<String>>(){}.getType());
										for(int x=0;x<delete_file_list.size();x++) {
											File delete_file = new File(delete_file_list.get(x));
											if(delete_file.exists()) {
												delete_file.delete();							
											}	
										}
									}
									
									if(web_Teacher_Service.Update_Class_List_For_Management(sessionUid, class_code, null, null, null, null, null, gson.toJson(unit_list))) {
										return "success";
									}else {
										return "fail";
									}
									
								}else {
									return "fail";
								}
								
							}else if(mode.equals("create")) {
								
								//unit_code 먼저 생성해야함
								unit_code = time_number + class_code + sessionUid;
								
								/* 클래스의 class_unit_list 변경 */
								Json_Class_Unit_List_VO temp = new Json_Class_Unit_List_VO();
								temp.setUnit_class_name(unit_class_name);
								temp.setUnit_code(unit_code);
								temp.setUnit_end_date(unit_end_date);
								temp.setUnit_start_date(unit_start_date);
								
								if(unit_list == null) {
									unit_list = new ArrayList<Json_Class_Unit_List_VO>();
								}
								
								unit_list.add(temp);

								if(web_Teacher_Service.Create_Curriculum_Unit_List_Class(unit_code, class_code, unit_class_type, null, null, unit_class_name, unit_class_text, unit_start_date, unit_end_date, unit_youtube_url, unit_content_url, unit_attached_file, content_code_list, content_home_work, content_test, content_evaluation_type)) {
									if(web_Teacher_Service.Update_Class_List_For_Management(sessionUid, class_code, null, null, null, null, null, gson.toJson(unit_list))) {
										return "success";
									}else {
										return "fail";
									}
								}else {
									return "fail";
								}
								
							}else {
								return "fail";
							}
							
						}else {
							
							if(mode.equals("create")) {
								unit_code = time_number + class_code + sessionUid;
							}
							
							String unit_group_id_list = request.getParameter("unit_group_id_list");
							String unit_group_name = request.getParameter("unit_group_name");
							
							if(unit_group_id_list == null || unit_group_id_list.length() < 2) {
								return "fail";
							}
							if(unit_group_name == null || unit_group_name.length() < 2) {
								return "fail";
							}
							
							//그룹
							// 먼저 기존 그룹을 싹다 삭제하고 다시만들어야함 ( 그룹명 변경이 있을수 있으므로 ) 만약 차시가 진행중이라면 진행하지 않는다. ( mode == modify )
							
							/* 그룹별 수업구성 */
							List<List<HashMap>> content_code_list_g = gson.fromJson(content_code_list, new TypeToken<List<List<HashMap>>>(){}.getType());
							
							/* 그룹별 평가방식 */
							List<List<String>> content_evaluation_type_g = gson.fromJson(content_evaluation_type, new TypeToken<List<List<String>>>(){}.getType());
							
							/* 그룹별 과제유무 */
							List<List<String>> content_home_work_g = gson.fromJson(content_home_work, new TypeToken<List<List<String>>>(){}.getType());
							
							/* 그룹별 평가유무 */
							List<List<String>> content_test_g = gson.fromJson(content_test, new TypeToken<List<List<String>>>(){}.getType());
							
							/* 그룹별 참고자료 */
							List<List<String>> unit_attached_file_g = gson.fromJson(unit_attached_file, new TypeToken<List<List<String>>>(){}.getType());
							
							/* 그룹별 평가방식 */
							List<List<HashMap>> unit_youtube_url_g = gson.fromJson(unit_youtube_url, new TypeToken<List<List<HashMap>>>(){}.getType());
							
							/* 그룹별 평가방식 */
							List<List<HashMap>> unit_content_url_g = gson.fromJson(unit_content_url, new TypeToken<List<List<HashMap>>>(){}.getType());
							
							unit_start_date += "01";
							unit_end_date += "01";
							
							/* 그룹별 차시내용 */
							List<String> unit_class_text_g = gson.fromJson(unit_class_text, new TypeToken<List<String>>(){}.getType());
							
							/* 그룹별 학생번호 */
							List<List<String>> unit_group_id_list_g = gson.fromJson(unit_group_id_list, new TypeToken<List<List<String>>>(){}.getType());
							
							/* 그룹별 차시내용 */
							List<String> unit_group_name_g = gson.fromJson(unit_group_name, new TypeToken<List<String>>(){}.getType());
							
							
							List<MultipartFile> fileList = request.getFiles("files");
							if(fileList.size() != 0) {
								if(fileList.get(0).getSize() != 0){
									for(MultipartFile this_file : fileList) {
										String fileName = this_file.getOriginalFilename();
										//확장자 체크 ( IMAGE or PDF )
										if(!kr.co.onpe.common.common.checkImageorPdfType(fileName)) {
								    		return "fail";
										}
									}
								}
								
								int num = 1;
								for(MultipartFile this_file : fileList) {
									num++;
									String fileName = this_file.getOriginalFilename();
									String newFileName = null;
									if(kr.co.onpe.common.common.checkImageType(fileName)) {
										if(type.equals("group")) {
											newFileName = sessionUid + time_number + "g" + Integer.toString(num) + ".jpg";	
										}else {
											newFileName = sessionUid + time_number + Integer.toString(num) + ".jpg";
										}
									}else {
										if(type.equals("group")) {
											newFileName = sessionUid + time_number + "g" + Integer.toString(num) + ".pdf";
										}else {
											newFileName = sessionUid + time_number + Integer.toString(num) + ".pdf";
										}
									}
									
									for(int x=0;x<unit_attached_file_g.size();x++) {
										boolean fin = false;
										if(unit_attached_file_g.get(x) != null && !unit_attached_file_g.get(x).equals("null")) {
											for(int xx=0;xx<unit_attached_file_g.get(x).size();xx++) {
												if(unit_attached_file_g.get(x).get(xx).equals(Curriculum_uploadPath+"/"+fileName)) {
													unit_attached_file_g.get(x).set(xx, Curriculum_uploadPath+"/"+newFileName);
													fin = true;
													break;
												}	
											}
										}
										if(fin) {
											break;
										}
									}
									
									File target = new File(Curriculum_uploadPath, newFileName);	//파일명
							        
							        //파일 복사
							        try {
							            FileCopyUtils.copy(this_file.getBytes(), target);
							            
							        } catch(Exception e) {
							            e.printStackTrace();
							    		return "fail";
							        }
								}
							}
							
							boolean isOk = true;
							
							if(mode.equals("modify")) {
								//기존 그룹 싹다 삭제
								isOk = web_Teacher_Service.Delete_Curriculum_Unit_List_Class(unit_code, class_code);
							}
							
							if(isOk) {
								Class_List_VO class_list = web_Teacher_Service.Get_Class_List_For_Management_Detail(sessionUid, class_code);
								
								List<Json_Class_Unit_List_VO> unit_list = gson.fromJson(class_list.getClass_unit_list(), new TypeToken<List<Json_Class_Unit_List_VO>>(){}.getType());
								
								if(mode.equals("create")) {
									
									/* 클래스의 class_unit_list 변경 */
									Json_Class_Unit_List_VO temp = new Json_Class_Unit_List_VO();
									temp.setUnit_class_name(unit_class_name);
									temp.setUnit_code(unit_code);
									temp.setUnit_end_date(unit_end_date+"01");
									temp.setUnit_start_date(unit_start_date+"01");
									
									if(unit_list == null) {
										unit_list = new ArrayList<Json_Class_Unit_List_VO>();
									}
									
									unit_list.add(temp);
								}else if(mode.equals("modify")) {
									for(int x=0;x<unit_list.size();x++) {
										if(unit_list.get(x).getUnit_code().equals(unit_code)) {
											unit_list.get(x).setUnit_class_name(unit_class_name);
											unit_list.get(x).setUnit_start_date(unit_start_date);
											unit_list.get(x).setUnit_end_date(unit_end_date);						
										}
									}
								}
								
								boolean isOk2 = true;
								for(int x=0;x<unit_group_name_g.size();x++) {
									
									String temp_youtube_url = null;
									if(unit_youtube_url_g.get(x) != null && !unit_youtube_url_g.get(x).equals("null")) {
										temp_youtube_url = gson.toJson(unit_youtube_url_g.get(x));
									}
									String temp_content_url = null;
									if(unit_content_url_g.get(x) != null && !unit_content_url_g.get(x).equals("null")) {
										temp_content_url = gson.toJson(unit_content_url_g.get(x));
									}
									String temp_attached_file = null;
									if(unit_attached_file_g.get(x) != null && !unit_attached_file_g.get(x).equals("null")) {
										temp_attached_file = gson.toJson(unit_attached_file_g.get(x));
									}
									
									
									if(web_Teacher_Service.Create_Curriculum_Unit_List_Class(unit_code, class_code, unit_class_type, unit_group_name_g.get(x), gson.toJson(unit_group_id_list_g.get(x)), unit_class_name, unit_class_text_g.get(x), unit_start_date, unit_end_date, temp_youtube_url, temp_content_url, temp_attached_file, gson.toJson(content_code_list_g.get(x)), gson.toJson(content_home_work_g.get(x)), gson.toJson(content_test_g.get(x)), gson.toJson(content_evaluation_type_g.get(x)))) {
										isOk2 = true;
									}else {
										isOk2 = false;
										break;
									}
								}
								
								if(isOk2) {
									
									if(web_Teacher_Service.Update_Class_List_For_Management(sessionUid, class_code, null, null, null, null, null, gson.toJson(unit_list))){
										
										if(mode.equals("modify")) {
											if(delete_files != null && delete_files.length() > 5) {
												List<String> delete_files_g = gson.fromJson(delete_files, new TypeToken<List<String>>(){}.getType());
												
												for(int x=0;x<delete_files_g.size();x++) {
													File delete_file = new File(delete_files_g.get(x));
													if(delete_file.exists()) {
														delete_file.delete();							
													}	
												}
											}
										}
										
										return "success";
									}else {
										return "fail";
									}
								}else {
									return "fail";
								}

								
							}else {
								return "fail";
							}
						}
											
					}else {
						return "fail";
					}
				}
			}
		}
	}
	
	/* 이전수업 불러오기 */
	@ResponseBody
	@RequestMapping(value = "/class_configuration_management_detail_before_class", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String class_configuration_management_detail_before_class(Locale locale, Model model, HttpSession session, MultipartHttpServletRequest request) {
		
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
				
				String class_code = request.getParameter("class_code");
				if(class_code != null && class_code.length() > 1) {
					
					SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
					format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
					Date time = new Date();
					String time_number = format.format(time);
					Class_List_VO my_class = web_Teacher_Service.Get_Class_List_For_Management_Detail(sessionUid, class_code);
					Class_List_VO class_list = (Class_List_VO)web_Teacher_Service.Get_Class_List_For_Auto_Create(sessionUid);
					if(class_list == null) {
						return "none";
					}
					
					//그룹이 들어간다면 코드가 바뀌어야함
					List<Curriculum_Unit_List_Class_VO> curriculum_unit_list_class = web_Teacher_Service.Get_Curriculum_Unit_List_For_Auto_Create(class_list.getClass_code());
					Gson gson = new Gson();
					
					//유닛리스트 만들기
					List<Json_Class_Unit_List_VO> unit_list = new ArrayList<Json_Class_Unit_List_VO>();
					
					if(curriculum_unit_list_class.size() < 1) {
						return "fail";
					}
					
					for(int x=0;x<curriculum_unit_list_class.size();x++) {
						
						Json_Class_Unit_List_VO new_unit_list = new Json_Class_Unit_List_VO(); //신규 유닛리스트
						String new_unit_code = time_number+"_"+ Integer.toBinaryString(x) + class_code + sessionUid;
						
						
						new_unit_list.setUnit_class_name(curriculum_unit_list_class.get(x).getUnit_class_name());
						new_unit_list.setUnit_code(new_unit_code);
						new_unit_list.setUnit_start_date(curriculum_unit_list_class.get(x).getUnit_start_date());
						new_unit_list.setUnit_end_date(curriculum_unit_list_class.get(x).getUnit_end_date());

						curriculum_unit_list_class.get(x).setClass_code(class_code);
						curriculum_unit_list_class.get(x).setUnit_code(new_unit_code);
						curriculum_unit_list_class.get(x).setUnit_group_id_list(null);
						curriculum_unit_list_class.get(x).setContent_participation(null);
						curriculum_unit_list_class.get(x).setContent_submit_task(null);
						curriculum_unit_list_class.get(x).setContent_use_time("0");
						
						String before_unit_attached_file = curriculum_unit_list_class.get(x).getUnit_attached_file();
						
						if(before_unit_attached_file != null) {
							
							List<String> new_unit_attached_file = new ArrayList<String>();
							
							List<String> temp = gson.fromJson(before_unit_attached_file, new TypeToken<List<String>>(){}.getType());

							for(int xx=0;xx<temp.size();xx++) {
								String fileName = temp.get(xx);
								String newFileName = null;
								if(kr.co.onpe.common.common.checkImageType(fileName)) {
									newFileName = Curriculum_uploadPath+"/"+sessionUid + time_number+ Integer.toString(x) + Integer.toString(xx) + ".jpg";
								}else {
									newFileName = Curriculum_uploadPath+"/"+sessionUid + time_number+ Integer.toString(x) + Integer.toString(xx) + ".pdf";
								}
								
								File in = new File(fileName);
								File out = new File(newFileName);
								
								try {
									if(in.exists()) {
										FileCopyUtils.copy(in, out);
										new_unit_attached_file.add(newFileName);
									}
								} catch (IOException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
							}
							if(new_unit_attached_file.size() > 0) {
								curriculum_unit_list_class.get(x).setUnit_attached_file(gson.toJson(new_unit_attached_file));	
							}else {
								curriculum_unit_list_class.get(x).setUnit_attached_file(null);
							}
						}
						unit_list.add(new_unit_list);
					}
					
					boolean result = web_Teacher_Service.Create_Curriculum_Unit_List_Class_List(curriculum_unit_list_class);
					
					if(result) {
						if(web_Teacher_Service.Update_Class_List_For_Management(sessionUid, class_code, my_class.getClass_people_max_count(), class_list.getClass_name(), class_list.getClass_start_date(), class_list.getClass_end_date(), class_list.getClass_project_submit_type(), gson.toJson(unit_list))) {
							return "success";
						}else {
							return "fail";
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


	/* 추천조합, 직접조합 불러오기 */
	@ResponseBody
	@RequestMapping(value = "/get_exercise_combination", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String get_exercise_combination(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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

				String value = request.getParameter("value");
				String content_code = request.getParameter("content_code");
				String content_name = request.getParameter("content_name");
				String content_category = request.getParameter("content_category");
				String option = request.getParameter("option");
				String keyword = request.getParameter("keyword");
				String sort = request.getParameter("sort");
				String page = request.getParameter("page");
				String sqlpage = "";
				
				if(value.equals("0")) {
					//추천조합
					if(content_name != null && content_category != null && option != null && sort != null && (!option.equals("제목") || !option.equals("생산자"))) {
						
						if(keyword.length() < 2) {
							keyword = null;
						}
						
						if(content_name.equals("전체")) {
							content_name = null;
						}
						if(content_category.equals("전체")) {
							content_category = null;
						}
						if(option.equals("전체")) {
							option = null;
						}
						
						if(!sort.equals("최신순") && !sort.equals("오래된순")) {
							return "fail";
						}
						
						int pageing_start = 1;
						
						if(!kr.co.onpe.common.common.isInteger(page) || page == null || Integer.parseInt(page) <= 0) {
							page = "1";
							sqlpage = "0";
						}else {
							pageing_start = 5*((Integer.parseInt(page) - 1) / 5) + 1;
							sqlpage = Integer.toString((Integer.parseInt(page) - 1)*5);
						}
						
						Gson gson = new Gson();
						
						List content_list = web_Teacher_Service.Get_Content_List(content_name, content_category, option, keyword, sort, sqlpage);
						String content_count = web_Teacher_Service.Get_Content_List_Count(content_name, content_category, option, keyword, sort);
						
						if(content_count == null) {
							content_count = "0";
						}
						int exercise_combination_count_int = Integer.parseInt(content_count) / 5;
						int exercise_combination_count_result = Integer.parseInt(content_count) % 5;
						if(exercise_combination_count_result > 0) {
							exercise_combination_count_int++;
						}
						
						HashMap<String, Object> data = new HashMap<String, Object>();
						data.put("content_list", content_list);
						data.put("last_page", Integer.toString(exercise_combination_count_int));
						data.put("pageing_start", Integer.toString(pageing_start));
						if(exercise_combination_count_int < pageing_start + 4) {
							data.put("pageing_last", Integer.toString(exercise_combination_count_int));
						}else {
							data.put("pageing_last", Integer.toString(pageing_start + 4));
						}
						
						return gson.toJson(data);
						
					}else {
						return "fail";
					}
					
					
				}else if(value.equals("1")) {
					//직접조합
					if(content_code != null) {
						if(content_code.length() < 1) {
							return "fail";
						}
						Content_List_VO content_list = web_Teacher_Service.Get_Content_List_Mine(content_code, sessionUid);
						if(content_list == null) {
							return "fail";
						}else {
							Gson gson = new Gson();
							List<Exercise_Category_VO> exercise_category = new ArrayList<Exercise_Category_VO>();
							List<String> exercise_code = gson.fromJson(content_list.getContent_number_list(), new TypeToken<List<String>>(){}.getType());
							List<String> content_count_list = gson.fromJson(content_list.getContent_count_list(), new TypeToken<List<String>>(){}.getType());
							List<String> content_time = gson.fromJson(content_list.getContent_time(), new TypeToken<List<String>>(){}.getType());

							for(int x=0;x<exercise_code.size();x++) {
								Exercise_Category_VO ex_temp = web_Teacher_Service.Get_Exercise_Category_Mine(exercise_code.get(x));
								for(int xx=0;xx<exercise_code.size();xx++) {
									if(exercise_code.get(xx).equals(ex_temp.getExercise_code())) {
										ex_temp.setExercise_count(content_count_list.get(xx));
										ex_temp.setExercise_time(content_time.get(xx));
										break;
									}
								}
								exercise_category.add(ex_temp);
							}
							return gson.toJson(exercise_category);
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

	
	/* 운동 검색 */
	@ResponseBody
	@RequestMapping(value = "/get_exercise_one", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String get_exercise_one(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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

				String exercise_name = request.getParameter("exercise_name");
				String exercise_category = request.getParameter("exercise_category");
				String exercise_detail_name = request.getParameter("exercise_detail_name");
				String mode = request.getParameter("mode");
				
				if(exercise_name != null) {
					Gson gson = new Gson();
					if(mode.equals("exercise_category")) {
						List<String> exercise_category_list = web_Teacher_Service.Get_Exercise_Category_Exercise_Category(exercise_name);
						return gson.toJson(exercise_category_list);
					}else if(mode.equals("exercise_detail_name") && exercise_category != null) {
						List<String> exercise_detail_name_list = web_Teacher_Service.Get_Exercise_Category_Exercise_Detail_Name(exercise_name, exercise_category);
						return gson.toJson(exercise_detail_name_list);
					}else if(mode.equals("one") && exercise_category != null && exercise_detail_name != null) {
						List<Exercise_Category_VO> exercise_category_obj = web_Teacher_Service.Get_Exercise_Category_One(exercise_name, exercise_category, exercise_detail_name);
						return gson.toJson(exercise_category_obj.get(0));
					}else {
						return "fail";
					}
				}else {
					return "fail";
				}
			}
		}
	}
	
	/* 운동 저장 */
	@ResponseBody
	@RequestMapping(value = "/save_content_list", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String save_content_list(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				String content_number_list_json = request.getParameter("content_number_list");
				String content_class_grade = request.getParameter("content_class_grade");
				String content_count_list = request.getParameter("content_count_list");
				String content_time = request.getParameter("content_time");
				
				SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
				format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date time = new Date();
				String time_number = format.format(time);
				
				if(content_number_list_json != null && content_number_list_json.length() > 2 && content_class_grade != null && content_count_list != null && content_count_list.length() > 2 && content_time != null && content_time.length() > 2) {
					Gson gson = new Gson();
					List<String> content_number_list = gson.fromJson(content_number_list_json, new TypeToken<List<String>>(){}.getType());
					
					String content_value = "1";
					String content_title = null;
					String content_name = null; 
					String content_category = null;
					String content_class_level = "-";
					List<String> content_name_list_temp = new ArrayList<String>();
					List<String> content_cateogry_list_temp = new ArrayList<String>();
					List<String> content_type_list_temp = new ArrayList<String>();
					List<List<String>> content_area_list_temp = new ArrayList<List<String>>();
					List<String> content_detail_name_list_temp = new ArrayList<String>();
					List<String> content_url_temp = new ArrayList<String>();
					List<String> content_level_list_temp = new ArrayList<String>();
					
					for(int x=0;x<content_number_list.size();x++) {
						
						Exercise_Category_VO exercise_category = web_Teacher_Service.Get_Exercise_Category_Mine(content_number_list.get(x));
						
						if(x==0) {
							content_title = exercise_category.getExercise_detail_name();
							content_name = exercise_category.getExercise_name();
							content_category = exercise_category.getExercise_category();
						}
						content_name_list_temp.add(exercise_category.getExercise_name());
						content_cateogry_list_temp.add(exercise_category.getExercise_category());
						content_type_list_temp.add(exercise_category.getExercise_type());
						List<String> content_area_list_temp_t = gson.fromJson(exercise_category.getExercise_area(), new TypeToken<List<String>>(){}.getType());
						content_area_list_temp.add(content_area_list_temp_t);
						content_detail_name_list_temp.add(exercise_category.getExercise_detail_name());
						content_url_temp.add(exercise_category.getExercise_url());
						content_level_list_temp.add(exercise_category.getExercise_level());
					}
					String content_name_list = gson.toJson(content_name_list_temp);
					String content_cateogry_list = gson.toJson(content_cateogry_list_temp);
					String content_type_list = gson.toJson(content_type_list_temp);
					String content_area_list = gson.toJson(content_area_list_temp);
					String content_detail_name_list = gson.toJson(content_detail_name_list_temp);
					String content_url = gson.toJson(content_url_temp);
					String content_level_list = gson.toJson(content_level_list_temp);
					String content_code = time_number+sessionUid+Integer.toString((int)(Math.random() * 10)) + Integer.toString((int)(Math.random() * 10)) + Integer.toString((int)(Math.random() * 10));
					String content_write_date = time_number;
					
					boolean result = web_Teacher_Service.Create_Content_List(content_code, content_value, content_title, content_name, content_category, sessionUid, content_class_level, content_class_grade, content_write_date, content_number_list_json, content_name_list, content_cateogry_list, content_type_list, content_area_list, content_detail_name_list, content_count_list, content_time, content_url, content_level_list);
					if(result) {
						
						HashMap<String, Object> data = new HashMap<String, Object>();
						data.put("content_detail_name_list", content_detail_name_list_temp);
						List<String> content_count_list_temp = gson.fromJson(content_count_list, new TypeToken<List<String>>(){}.getType());
						data.put("content_count_list", content_count_list_temp);
						data.put("content_code", content_code);
						return gson.toJson(data);
					}else {
						return "fail";
					}
				}else {
					return "fail";
				}
			}
		}
	}
	
	
	/* 학급 구성관리 */
	@RequestMapping(value = "/student_management", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String student_management(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				String student_level = request.getParameter("student_level");	//학년
				String student_class = request.getParameter("student_class");	//학급
				String option = request.getParameter("option");	//이름, 아이디, 전체
				String keyword = request.getParameter("keyword");	//키워드
				List<String> class_code = (List<String>) session.getAttribute("teacher_classcode");
				String page = request.getParameter("page");
				String sqlpage = null;
				
				if(class_code == null) {
					class_code = new ArrayList<String>();
					class_code.add("n");
					model.addAttribute("c_code", "n");
				}else {
					model.addAttribute("c_code", "y");
				}
				
				
				String pageing_url = "/teacher/ready/student_management?ck=1";
				if(student_level != null && student_level.length()>0 && !student_level.equals("전체")) {
					pageing_url += "&student_level"+student_level;
				}else {
					student_level = null;
				}
				if(student_class != null && student_class.length()>0 && !student_class.equals("전체")) {
					pageing_url += "&student_class"+student_class;
				}else {
					student_class = null;
				}
				if(keyword != null && keyword.length()>1) {
					pageing_url += "&keyword"+keyword;
				}else {
					keyword = null;
					option = null;
				}
				if(option != null && (option.equals("이름") || option.equals("아이디"))) {
					pageing_url += "&option"+option;
				}else {
					option = null;
				}
				
				int pageing_start = 1;
				
				if(!kr.co.onpe.common.common.isInteger(page) || page == null || Integer.parseInt(page) < 0) {
					page = "1";
					sqlpage = "0";
				}else {
					pageing_start = 5*((Integer.parseInt(page) - 1) / 5) + 1;
					sqlpage = Integer.toString((Integer.parseInt(page) - 1)*15);
				}

				List student_list = web_Teacher_Service.Get_Student_Information_For_Student_Management(student_level, student_class, option, keyword, sqlpage, class_code);
				
				String student_count = web_Teacher_Service.Get_Student_Information_For_Student_Management_Count(student_level, student_class, option, keyword, class_code);
				
				if(student_count == null) {
					student_count = "0";
				}
				int push_count_int = Integer.parseInt(student_count) / 15;
				int push_count_result = Integer.parseInt(student_count) % 15;
				if(push_count_result > 0) {
					push_count_int++;
				}
				
				model.addAttribute("student_list", student_list);
				model.addAttribute("page",page);
				model.addAttribute("last_page",Integer.toString(push_count_int));
				model.addAttribute("pageing_start",Integer.toString(pageing_start));
				if(push_count_int < pageing_start + 4) {
					model.addAttribute("pageing_last",Integer.toString(push_count_int));
				}else {
					model.addAttribute("pageing_last",Integer.toString(pageing_start + 4));
				}
				model.addAttribute("keyword",keyword);
				model.addAttribute("option",option);
				model.addAttribute("student_level",student_level);
				model.addAttribute("student_class",student_class);
				model.addAttribute("pageing_url",pageing_url);			
				
				return "/teacher/ready/student_management";
			}
		}
	}
	
	/* 학급 구성관리 */
	@RequestMapping(value = "/student_management_sign_up", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String student_management_sign_up(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				String teacher_school = (String)session.getAttribute("teacher_school");
				model.addAttribute("teacher_school",teacher_school);
				return "/teacher/ready/student_management_sign_up";
			}
		}
	}
	
	/* 아이디 중복검사 */
	@ResponseBody
	@RequestMapping(value = "/student_management_id_overlap", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String student_management_id_overlap(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				if(student_id != null) {
					if(!web_Teacher_Service.Get_Student_id(student_id)) {
						return "success";
					}else {
						return "overlap";
					}
				}else {
					return "fail";
				}
				
			}
		}
	}
	
	/* 운동 검색 */
	@ResponseBody
	@RequestMapping(value = "/student_management_sign_up_work", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String student_management_sign_up_work(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				String student_name = request.getParameter("student_name");
				String student_password_temp = kr.co.onpe.common.common.makePassword();
				String student_password = null;
				String student_email = request.getParameter("student_email");
				String student_email_agreement = request.getParameter("student_email_agreement");
				String student_message_agreement = request.getParameter("student_message_agreement");
				String student_phone = request.getParameter("student_phone");
				String student_level = request.getParameter("student_level");
				String student_class = request.getParameter("student_class");
				String student_number = request.getParameter("student_number");
				String student_age = request.getParameter("student_age");
				String student_sex = request.getParameter("student_sex");
				String student_school = (String)session.getAttribute("teacher_school");
				
				if(student_phone != null) {
					if(student_phone.length() != 13) {
						return "fail";
					}
				}else {
					student_phone = null;
				}
				if(student_id != null && student_name != null && student_email != null && (student_email_agreement.equals("1") || student_email_agreement.equals("0")) && (student_message_agreement.equals("1") || student_message_agreement.equals("0")) && student_level != null && student_class != null && student_number != null && student_age != null && student_sex != null && student_school != null) {
					
					if(!web_Teacher_Service.Get_Student_id(student_id)) {	//아이디 중복확인
						
						if(student_name.length() > 1 && student_name.length() < 7) {	//이름 문자열 길이 확인
							
							if(kr.co.onpe.common.common.isValidEmail(student_email)) {	//이메일 정규식 확인
								
								if(!web_Teacher_Service.Get_Student_email(student_email)) {	//이메일 중복검사 확인
									
									/* 비밀번호 암호화 */
									try {
										student_password = kr.co.onpe.common.common.sha256(student_password_temp);
										
										/* 현재 시간 */
										SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
										format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
										Date time = new Date();
										String student_create_date = format.format(time);

										boolean result = web_Teacher_Service.Create_Student_Information(student_id, student_name, student_password, student_email, student_phone, student_email_agreement, student_message_agreement, student_age, student_sex, student_school, student_level, student_class, student_number, student_create_date);
										if(result) {
											
											/* 이메일 전송 */
											CreateUser_sendMailThread sendMailThread = new CreateUser_sendMailThread(student_email, student_id, student_password, mailSender);
											
											workExecutor.execute(sendMailThread);
											
											return "success";
										}else {
											return "fail";										
										}
										
									} catch (NoSuchAlgorithmException e) {	//SHA256 변환 실패
										e.printStackTrace();
										return "fail";	
									}
									
								}else {
									return "email_overlap";									
								}								
								
							}else {
								return "fail";
							}
							
						}else {
							return "fail";
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
	
	
	/* 운동 검색 */
	@ResponseBody
	@RequestMapping(value = "/student_management_work", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String student_management_work(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				String mode = request.getParameter("mode");
				if(student_id != null && mode != null) {
					if(mode.equals("modify")) {
						
						String student_school = request.getParameter("student_school");
						String student_level = request.getParameter("student_level");
						String student_class = request.getParameter("student_class");
						String student_number = request.getParameter("student_number");
						
						if(student_school != null && student_level != null && student_class != null && student_number != null) {
							boolean result = web_Teacher_Service.Update_Student_Information_By_Teacher(student_school, student_level, student_class, student_number, student_id);
							
							if(result) {
								return "success";
							}else {
								return "fail";
							}
							
						}else {
							return "fail";
						}
					}else if(mode.equals("delete")){
						
						boolean result = web_Teacher_Service.Delete_Student_Information_By_Teacher(student_id);
						
						if(result) {
							return "success";
						}else {
							return "fail";
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
	
	
	
	
	/* 수업 구성관리 커리큘럼 상세 페이지 */
	@RequestMapping(value = "/curriculum_configuration_management_detail", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String curriculum_configuration_management_detail(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				String class_code = request.getParameter("class_code");
				String unit_code = request.getParameter("unit_code");
				String mode = request.getParameter("mode");
				
				if(class_code == null || mode == null) {
					return "redirect:/teacher/ready/class_configuration_management_list";
				}
				if(unit_code != null && mode.equals("create")) {
					return "redirect:/teacher/ready/class_configuration_management_list";
				}
				if(unit_code == null && mode.equals("modify")) {
					return "redirect:/teacher/ready/class_configuration_management_list";
				}
				if(!mode.equals("create") && !mode.equals("modify")) {
					return "redirect:/teacher/ready/class_configuration_management_list";
				}
				
				Gson gson = new Gson();
				
				model.addAttribute("curriculum","n");
				model.addAttribute("is", "one");
				
				List<Student_Information_VO> class_student_info = web_Teacher_Service.Get_Student_List_In_Class(class_code);
				if(class_student_info.size() > 0) {
					model.addAttribute("class_student_info", gson.toJson(class_student_info));	
				}else {
					model.addAttribute("class_student_info", gson.toJson("n"));
				}
				
				if(mode.equals("modify") && unit_code != null) {
					
					//정보 가져오기
					List<Curriculum_Unit_List_Class_VO> curriculum = web_Teacher_Service.Get_Curriculum_Unit_LIst_Class(unit_code, class_code);
					
					if(curriculum.size() == 0) {
						System.out.println(unit_code+" is none unit_code");
						return "redirect:/teacher/ready/class_configuration_management_list";	
					}
					
					if(curriculum.size() > 1) {
						model.addAttribute("is", "group");
					}
					model.addAttribute("unit_code", unit_code);
					model.addAttribute("curriculum",gson.toJson(curriculum));
					
					//커리큘럼 콘텐츠의 동작명, 갯수 리스트를 불러와야함
					//그룹은 일단 제외시키고 작업 -> 그룹 포함작업
					
					List<List<List<String>>> temp_arr1 = new ArrayList<List<List<String>>>();
					List<List<List<String>>> temp_arr2 = new ArrayList<List<List<String>>>();
					
					for(int xx=0;xx<curriculum.size();xx++) {
						List<Curriculum_Content_List_VO> content_list = gson.fromJson(curriculum.get(xx).getContent_code_list(), new TypeToken<List<Curriculum_Content_List_VO>>(){}.getType());
						
						List<List<String>> content_detail_name_list = new ArrayList<List<String>>();
						List<List<String>> content_count_list = new ArrayList<List<String>>();
						
						for(int x=0; x<content_list.size(); x++) {
							Content_List_VO content_ob = web_Teacher_Service.Get_Content_List_For_Curriculum(content_list.get(x).getContent_code());
							if(content_ob != null && content_ob.getContent_detail_name_list() != null) {
								List<String> temp1 = gson.fromJson(content_ob.getContent_detail_name_list(), new TypeToken<List<String>>(){}.getType());
								content_detail_name_list.add(temp1);	
							}else {
								content_detail_name_list.add(null);
							}
							
							if(content_ob != null && content_ob.getContent_count_list() != null) {
								List<String> temp2 = gson.fromJson(content_ob.getContent_count_list(), new TypeToken<List<String>>(){}.getType());
								content_count_list.add(temp2);
							}else {
								content_count_list.add(null);
							}
						}
						
						if(content_detail_name_list.size() > 0) {						
							temp_arr1.add(content_detail_name_list);
							temp_arr2.add(content_count_list);
						}
					}
					
					
					
					if(temp_arr1.size() > 0) {
						model.addAttribute("content_detail_name_list", gson.toJson(temp_arr1));
						model.addAttribute("content_count_list", gson.toJson(temp_arr2));	
					}else {
						model.addAttribute("content_detail_name_list", "1");
						model.addAttribute("content_count_list", "1");
					}
					
				}else {
					
					model.addAttribute("content_detail_name_list", "1");
					model.addAttribute("content_count_list", "1");
					
				}
				
				//클래스정보 가져오기 ( 그룹 번호 셋팅을 위함 )
				Class_List_VO class_list = web_Teacher_Service.Get_Class_List_For_Management_Detail(sessionUid, class_code);
				model.addAttribute("people_count", class_list.getClass_people_count());
				model.addAttribute("people_max_count", class_list.getClass_people_max_count());
				
				List<String> content_list_content_name = web_Teacher_Service.Get_Content_List_Content_Name_List();
				
				List<String> content_list_content_category = web_Teacher_Service.Get_Content_List_Content_Category_List();
				
				List<String> exercise_name_list = web_Teacher_Service.Get_Exercise_Category_Exercise_Name();
				
				model.addAttribute("exercise_name_list", gson.toJson(exercise_name_list));
				model.addAttribute("content_list_content_name", content_list_content_name);
				model.addAttribute("content_list_content_category", content_list_content_category);
				
				model.addAttribute("class_code", class_code);
				model.addAttribute("mode",mode);
				
				
				
				
				return "/teacher/ready/curriculum_configuration_management_detail";
			}
		}
	}
	
}

