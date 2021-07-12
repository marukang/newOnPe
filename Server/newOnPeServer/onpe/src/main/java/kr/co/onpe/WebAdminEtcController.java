package kr.co.onpe;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import kr.co.onpe.security.JwtTokenProvider;
import kr.co.onpe.service.Student_Information_Service;
import kr.co.onpe.service.WebUserAuthService;
import kr.co.onpe.service.Web_Admin_Management_Service;
import kr.co.onpe.vo.Admin_Notice_VO;
import kr.co.onpe.vo.Admin_Qna_VO;
import kr.co.onpe.vo.Exercise_Category_VO;
import kr.co.onpe.vo.FAQ_VO;
import kr.co.onpe.vo.Student_Information_VO;

@Controller
@RequestMapping("/admin/etc/*")
public class WebAdminEtcController {

	private static final Logger logger = LoggerFactory.getLogger(WebAdminEtcController.class);
	
	/* 사용자 정보 테이블(student_information) 테이블 관련 서비스 */
	@Inject
	private Web_Admin_Management_Service web_Admin_Management_Service;
	
	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
	
	//공지사항 목록
	@RequestMapping(value = "/notice_list", produces = "application/json; charset=utf8", method = RequestMethod.GET)
	public String notice_list(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				String page = request.getParameter("page");
				String sqlpage = null;
				String keyword = request.getParameter("keyword");
				String option = request.getParameter("option");
				String pageing_url = "/admin/etc/notice_list?ck=1";
				
				if(option != null && keyword != null && (keyword.length() > 20 || keyword.length() < 1)) {
					option = null;
					keyword = null;	
				}
				if(option == null) {
					pageing_url += "&option=전체";
				}else {
					if(option != null && option.length() > 0) {
						pageing_url += "&option="+option;
					}else {
						pageing_url += "&option=전체";	
					}
				}
				if(keyword != null && keyword.length() > 0) {
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
				
				List<Admin_Notice_VO> notice_list = web_Admin_Management_Service.Get_Admin_Notice_List(keyword, option, sqlpage);
				
				String notice_count = web_Admin_Management_Service.Get_Admin_Notice_List_Count(keyword, option);
				
				int notice_count_int = Integer.parseInt(notice_count) / 15;
				int notice_count_result = Integer.parseInt(notice_count) % 15;
				if(notice_count_result > 0) {
					notice_count_int++;
				}
				
				model.addAttribute("pageing_url",pageing_url);
				model.addAttribute("keyword", keyword);
				model.addAttribute("option", option);
				model.addAttribute("notice_list",notice_list);
				model.addAttribute("page",page);
				model.addAttribute("last_page",Integer.toString(notice_count_int));
				model.addAttribute("pageing_start",Integer.toString(pageing_start));
				if(notice_count_int < pageing_start + 4) {
					model.addAttribute("pageing_last",Integer.toString(notice_count_int));
				}else {
					model.addAttribute("pageing_last",Integer.toString(pageing_start + 4));
				}
				model.addAttribute("keyword",keyword);
				model.addAttribute("option",option);
				
				return "/admin/etc/notice_list";
			}
		}
	}
		
	
	/* 공지사항 상세페이지 */
	@RequestMapping(value = "/notice_detail", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
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
				
				String admin_notice_number = request.getParameter("admin_notice_number");
				String mode = request.getParameter("mode");
				
				if(mode.equals("create") || mode.equals("modify")) {
				
					if(mode.equals("modify")) {
						
						if(admin_notice_number != null) {
							Admin_Notice_VO admin_notice = web_Admin_Management_Service.Get_Admin_Notice_One(admin_notice_number);
							
							if(admin_notice != null) {
								model.addAttribute("admin_notice", admin_notice);
								model.addAttribute("admin_notice_number", admin_notice_number);
								model.addAttribute("mode", "modify");
								return "/admin/etc/notice_detail";	
							}else {
								return "redirect:/admin/etc/notice_list";	
							}
						}else {
							return "redirect:/admin/etc/notice_list";
						}
						
					}else {
						
						model.addAttribute("mode", "create");
						return "/admin/etc/notice_detail";
						
					}
					
				}else {
					return "redirect:/admin/etc/notice_list";
				}
			}
		}
	}
	
	/* 공지사항 처리페이지 */
	@ResponseBody
	@RequestMapping(value = "/notice_detail_work", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String notice_detail_work(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				String mode = request.getParameter("mode");
				String admin_notice_title = request.getParameter("admin_notice_title");
				String admin_notice_content = request.getParameter("admin_notice_content");
				
				if(mode.equals("create")) {
					
					SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
					format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
					Date time = new Date();
					String admin_notice_date = format.format(time);
					if(web_Admin_Management_Service.Create_Admin_Notice(admin_notice_title, admin_notice_content, admin_notice_date)) {
						return "success";
					}else {
						return "fail";
					}
					
				}else if(mode.equals("modify")) {
					String admin_notice_number = request.getParameter("admin_notice_number");
					
					if(web_Admin_Management_Service.Update_Admin_Notice(admin_notice_title, admin_notice_content, admin_notice_number)) {
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
	
	
	
	
	
	
	
	//faq 목록
	@RequestMapping(value = "/faq_list", produces = "application/json; charset=utf8", method = RequestMethod.GET)
	public String faq_list(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				String page = request.getParameter("page");
				String sqlpage = null;
				String keyword = request.getParameter("keyword");
				String option = request.getParameter("option");
				String pageing_url = "/admin/etc/faq_list?ck=1";
				
				if(option != null && keyword != null && (keyword.length() > 20 || keyword.length() < 1)) {
					option = null;
					keyword = null;	
				}
				if(option == null) {
					pageing_url += "&option=전체";
				}else {
					if(option != null && option.length() > 0) {
						pageing_url += "&option="+option;
					}else {
						pageing_url += "&option=전체";	
					}
				}
				if(keyword != null && keyword.length() > 0) {
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
				
				List<FAQ_VO> list = web_Admin_Management_Service.Get_Admin_FAQ_List(keyword, option, sqlpage);
				
				String count = web_Admin_Management_Service.Get_Admin_FAQ_List_Count(keyword, option);
				
				int count_int = Integer.parseInt(count) / 15;
				int count_result = Integer.parseInt(count) % 15;
				if(count_result > 0) {
					count_int++;
				}
				
				model.addAttribute("pageing_url",pageing_url);
				model.addAttribute("keyword", keyword);
				model.addAttribute("option", option);
				model.addAttribute("faq_list",list);
				model.addAttribute("page",page);
				model.addAttribute("last_page",Integer.toString(count_int));
				model.addAttribute("pageing_start",Integer.toString(pageing_start));
				if(count_int < pageing_start + 4) {
					model.addAttribute("pageing_last",Integer.toString(count_int));
				}else {
					model.addAttribute("pageing_last",Integer.toString(pageing_start + 4));
				}
				model.addAttribute("keyword",keyword);
				model.addAttribute("option",option);
				
				return "/admin/etc/faq_list";
			}
		}
	}
	
	//1:1문의 목록
	@RequestMapping(value = "/qna_list", produces = "application/json; charset=utf8", method = RequestMethod.GET)
	public String qna_list(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				String page = request.getParameter("page");
				String sqlpage = null;
				String keyword = request.getParameter("keyword");
				String option = request.getParameter("option");
				String pageing_url = "/admin/etc/faq_list?ck=1";
				
				if(option != null && keyword != null && (keyword.length() > 20 || keyword.length() < 1)) {
					option = null;
					keyword = null;	
				}
				String answer = null;
				if(option == null) {
					pageing_url += "&option=전체";
				}else {
					if(option != null && option.length() > 0) {
						pageing_url += "&option="+option;
					}else {
						pageing_url += "&option=전체";	
					}
				}
				if(keyword != null && keyword.length() > 0) {
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
				List<Admin_Qna_VO> list = web_Admin_Management_Service.Get_Admin_Qna_List(keyword, option, answer, sqlpage);
				
				String count = web_Admin_Management_Service.Get_Admin_Qna_List_Count(keyword, option, answer);
				
				int count_int = Integer.parseInt(count) / 15;
				int count_result = Integer.parseInt(count) % 15;
				if(count_result > 0) {
					count_int++;
				}
				
				model.addAttribute("pageing_url",pageing_url);
				model.addAttribute("keyword", keyword);
				model.addAttribute("option", option);
				model.addAttribute("qna_list",list);
				model.addAttribute("page",page);
				model.addAttribute("last_page",Integer.toString(count_int));
				model.addAttribute("pageing_start",Integer.toString(pageing_start));
				if(count_int < pageing_start + 4) {
					model.addAttribute("pageing_last",Integer.toString(count_int));
				}else {
					model.addAttribute("pageing_last",Integer.toString(pageing_start + 4));
				}
				model.addAttribute("keyword",keyword);
				model.addAttribute("option",option);
				return "/admin/etc/qna_list";
			}
		}
	}
	
	
	
	
	
	
	/* faq 상세 페이지 */
	@RequestMapping(value = "/faq_detail", produces = "application/json; charset=utf8", method = RequestMethod.GET)
	public String faq_detail(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				String faq_number = request.getParameter("faq_number");
				String mode = request.getParameter("mode");
				
				if(mode.equals("create") || mode.equals("modify")) {
				
					if(mode.equals("modify")) {
						
						if(faq_number != null) {
							FAQ_VO faq = web_Admin_Management_Service.Get_Admin_FAQ_One(faq_number);
							if(faq != null) {
								model.addAttribute("faq", faq);
								model.addAttribute("faq_number", faq_number);
								model.addAttribute("mode", "modify");
								return "/admin/etc/faq_detail";	
							}else {
								return "redirect:/admin/etc/faq_list";	
							}
						}else {
							return "redirect:/admin/etc/faq_list";
						}
						
					}else {
						
						model.addAttribute("mode", "create");
						return "/admin/etc/faq_detail";
						
					}
					
				}else {
					return "redirect:/admin/etc/faq_list";
				}
			}
		}
	}
	
	
	/* faq 처리페이지 */
	@ResponseBody
	@RequestMapping(value = "/faq_detail_work", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String faq_detail_work(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				String mode = request.getParameter("mode");
				String faq_title = request.getParameter("faq_title");
				String faq_content = request.getParameter("faq_content");
				String faq_type = request.getParameter("faq_type");
				
				if(mode.equals("create")) {
					
					SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
					format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
					Date time = new Date();
					String faq_date = format.format(time);
					if(web_Admin_Management_Service.Create_Admin_FAQ(faq_title, faq_content, faq_date, faq_type)) {
						return "success";
					}else {
						return "fail";
					}
					
				}else if(mode.equals("modify")) {
					String faq_number = request.getParameter("faq_number");
					
					if(web_Admin_Management_Service.Update_Admin_FAQ(faq_title, faq_content, faq_number, faq_type)) {
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
	
	
	
	
	
	
	/* qna 상세 페이지 */
	@RequestMapping(value = "/qna_detail", produces = "application/json; charset=utf8", method = RequestMethod.GET)
	public String qna_detail(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				String question_number = request.getParameter("question_number");
				
				if(question_number != null) {
					Admin_Qna_VO qna = web_Admin_Management_Service.Get_Admin_Qna_One(question_number);
					if(qna != null) {
						model.addAttribute("qna", qna);
						model.addAttribute("question_number", question_number);
						model.addAttribute("mode", "modify");
						return "/admin/etc/qna_detail";	
					}else {
						return "redirect:/admin/etc/qna_list";	
					}
				}else {
					return "redirect:/admin/etc/qna_list";
				}
			}
		}
	}
	
	
	/* qna 처리페이지 */
	@ResponseBody
	@RequestMapping(value = "/qna_detail_work", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String qna_detail_work(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				String question_number = request.getParameter("question_number");
				String question_comment = request.getParameter("question_comment");
				
				SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
				format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date time = new Date();
				String question_comment_date = format.format(time);
				
				if(web_Admin_Management_Service.Answer_Admin_Qna(question_comment, question_comment_date, question_number)) {
					return "success";
				}else {
					return "fail";
				}
			}
		}
	}
	
}
