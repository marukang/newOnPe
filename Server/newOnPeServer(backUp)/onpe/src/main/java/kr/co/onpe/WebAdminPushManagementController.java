package kr.co.onpe;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.onpe.common.Fcm_Util;
import kr.co.onpe.security.JwtTokenProvider;
import kr.co.onpe.service.Web_Admin_Management_Service;
import kr.co.onpe.vo.Popup_List_VO;
import kr.co.onpe.vo.Push_List_VO;

@Controller
@RequestMapping("/admin/push/*")
public class WebAdminPushManagementController {

	private static final Logger logger = LoggerFactory.getLogger(WebAdminPushManagementController.class);
	
	/* 사용자 정보 테이블(student_information) 테이블 관련 서비스 */
	@Inject
	private Web_Admin_Management_Service web_Admin_Management_Service;
	
	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
	//푸시 목록
	@RequestMapping(value = "/push_management_list", produces = "application/json; charset=utf8", method = RequestMethod.GET)
	public String popup_management_list(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				String option = request.getParameter("option");
				String keyword = request.getParameter("keyword");
				String page = request.getParameter("page");
				String sqlpage = null;
				String pageing_url = "/admin/push/push_management_list?ck=1";
				
				if(option != null && (option.equals("제목") || option.equals("내용"))) {
					pageing_url += "&option="+option;
				}else {
					option = null;
				}
				if(keyword == null || (keyword.length() < 2 || keyword.length() > 50)) {
					keyword = null;
				}else {
					pageing_url += "&keyword="+keyword;
				}				
				
				int pageing_start = 1;
				
				if(!kr.co.onpe.common.common.isInteger(page) || page == null || Integer.parseInt(page) < 0) {
					page = "1";
					sqlpage = "0";
				}else {
					pageing_start = 5*((Integer.parseInt(page) - 1) / 5) + 1;
					sqlpage = Integer.toString((Integer.parseInt(page) - 1)*15);
				}
				
				List push_list = web_Admin_Management_Service.Get_Push_List(option, keyword, sqlpage);
				
				String push_count = web_Admin_Management_Service.Get_Push_Count(option, keyword);
				if(push_count == null) {
					push_count = "0";
				}
				int push_count_int = Integer.parseInt(push_count) / 15;
				int push_count_result = Integer.parseInt(push_count) % 15;
				if(push_count_result > 0) {
					push_count_int++;
				}
				
				
				model.addAttribute("push_list",push_list);
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
				model.addAttribute("pageing_url",pageing_url);				
				
				
				return "/admin/push/push_management_list";
				
			}
			
		}
	}
	
	//푸시관리 상세, 수정, 등록
	@RequestMapping(value = "/push_management_detail", produces = "application/json; charset=utf8", method = RequestMethod.GET)
	public String push_management_detail(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				String mode = request.getParameter("mode");
				
				if(mode.equals("modify") || mode.equals("create")) {
					
					if(mode.equals("modify")) {
						
						String push_number = request.getParameter("push_number");
						
						Push_List_VO push = (Push_List_VO)web_Admin_Management_Service.Get_Push(push_number);
						model.addAttribute("push",push);
						
					}
					model.addAttribute("mode",mode);
					
					return "/admin/push/push_management_detail";
					
				}else {
					return "/admin/push/push_management_list";
				}
				
			}
			
		}
	}
	
	//푸시관리 수정, 등록, 삭제 처리 페이지
	@ResponseBody
	@RequestMapping(value = "/push_management_detail_work", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String push_management_detail_work(Locale locale, Model model, HttpSession session, HttpServletRequest request, MultipartFile file) {
		
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
				
				SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
				format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date time = new Date();
				
				String mode = request.getParameter("mode");
				
				/* 푸시삭제 */
				if(mode.equals("delete")) {
					String push_number = request.getParameter("push_number");
					if(push_number != null) {
						boolean result = web_Admin_Management_Service.Delete_Push(push_number);
						if(result) {
							return "success";
						}else {
							return "fail";
						}	
					}else {
						return "fail";
					}
				}else{
					String push_title = request.getParameter("push_title");
					String push_content = request.getParameter("push_content");
					String push_reservation_time = request.getParameter("push_reservation_time");
					if(push_title == null || push_title.length() < 2 || push_title.length() > 50) {
						return "fail";
					}else if(push_content == null || push_content.length() < 2) {
						return "fail";
					}else if(push_reservation_time == null || push_reservation_time.length() != 12 || !kr.co.onpe.common.common.isLong(push_reservation_time)) {
						return "fail";
					}else {
						if(mode.equals("modify")) {
							String push_number = request.getParameter("push_number");
							if(push_number != null) {												
								boolean result = web_Admin_Management_Service.Modify_or_Create_Push(push_title, push_content, push_reservation_time, null, null, push_number, mode);
								if(result) {
									return "success";
								}else {
									return "fail";
								}
							}else {
								return "fail";
							}
						}else if(mode.equals("create")) {
							
							//학생 token get
							List<String> tokens = web_Admin_Management_Service.Get_Student_Token();
							if(tokens.size() > 0) {
								String Utoken = request.getParameter("token");
								String title = push_title;
								String content = push_content;
								
								Fcm_Util fcmUtil = new Fcm_Util();
								fcmUtil.send_FCM(tokens, title, content);
							}
							
							String push_create_date = format.format(time);
							boolean result = web_Admin_Management_Service.Modify_or_Create_Push(push_title, push_content, push_reservation_time, push_create_date, "0", null, mode);
							if(result) {
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
		}
	}
	
	
}
