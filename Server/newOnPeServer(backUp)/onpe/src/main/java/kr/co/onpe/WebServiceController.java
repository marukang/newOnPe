package kr.co.onpe;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.co.onpe.security.JwtTokenProvider;
import kr.co.onpe.service.WebUserAuthService;
import kr.co.onpe.service.Web_Teacher_Service_Service;
import kr.co.onpe.vo.Admin_Notice_VO;
import kr.co.onpe.vo.Admin_Qna_VO;
import kr.co.onpe.vo.FAQ_VO;

@Controller
@RequestMapping("/teacher/service/*")
public class WebServiceController {

	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
	@Inject
	private Web_Teacher_Service_Service web_teacher_service;
	
	/* 파일경로 */
	@Resource(name="Qna_uploadPath")
    String Qna_uploadPath;
	
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
				
				if(admin_notice_number != null) {
					Admin_Notice_VO admin_notice =  web_teacher_service.Get_Admin_Notice_One(admin_notice_number);
					
					model.addAttribute("admin_notice", admin_notice);
					
					return "/teacher/service/notice_detail";
				}else {
					return "redirect:/";
				}
			}
		}
	}
	
	/* 공지사항 목록페이지 */
	@RequestMapping(value = "/notice_list", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String notice_list(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				String page = request.getParameter("page");
				String sqlpage = null;
				String keyword = request.getParameter("keyword");
				String option = request.getParameter("option");
				String pageing_url = "/teacher/service/notice_list?ck=1";
				
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
				
				List<Admin_Notice_VO> notice_list = web_teacher_service.Get_Admin_Notice_List(keyword, option, sqlpage);
				
				String notice_count = web_teacher_service.Get_Admin_Notice_List_Count(keyword, option);
				
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
				
				
				return "/teacher/service/notice_list";
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
				String pageing_url = "/teacher/service/faq_list?ck=1";
				
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
				
				List<FAQ_VO> list = web_teacher_service.Get_Admin_FAQ_List(keyword, option, sqlpage);
				
				String count = web_teacher_service.Get_Admin_FAQ_List_Count(keyword, option);
				
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
				
				return "/teacher/service/faq_list";
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
				if(faq_number != null) {
					FAQ_VO faq = web_teacher_service.Get_Admin_FAQ_One(faq_number);
					if(faq != null) {
						model.addAttribute("faq", faq);
						model.addAttribute("faq_number", faq_number);
						model.addAttribute("mode", "modify");
						return "/teacher/service/faq_detail";	
					}else {
						return "redirect:/teacher/service/faq_list";
					}
				}else {
					return "redirect:/teacher/service/faq_list";
				}
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
				String answer = request.getParameter("answer");
				String pageing_url = "/teacher/service/qna_list?ck=1";
				
				if(answer != null && answer.length() > 0) {
					pageing_url += "&answer="+answer;
				}
				
				int pageing_start = 1;
				
				if(!kr.co.onpe.common.common.isInteger(page) || page == null || Integer.parseInt(page) < 0) {
					page = "1";
					sqlpage = "0";
				}else {
					pageing_start = 5*((Integer.parseInt(page) - 1) / 5) + 1;
					sqlpage = Integer.toString((Integer.parseInt(page) - 1)*15);
				}
				List<Admin_Qna_VO> list = web_teacher_service.Get_Admin_Qna_List(answer, sessionUid, sqlpage);
						
				String count = web_teacher_service.Get_Admin_Qna_List_Count(answer, sessionUid);
				
				int count_int = Integer.parseInt(count) / 15;
				int count_result = Integer.parseInt(count) % 15;
				if(count_result > 0) {
					count_int++;
				}
				
				model.addAttribute("pageing_url",pageing_url);
				model.addAttribute("answer", answer);
				model.addAttribute("qna_list",list);
				model.addAttribute("page",page);
				model.addAttribute("last_page",Integer.toString(count_int));
				model.addAttribute("pageing_start",Integer.toString(pageing_start));
				if(count_int < pageing_start + 4) {
					model.addAttribute("pageing_last",Integer.toString(count_int));
				}else {
					model.addAttribute("pageing_last",Integer.toString(pageing_start + 4));
				}
				return "/teacher/service/qna_list";
			}
		}
	}
	
	//1:1문의 상세
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
				
				String mode = request.getParameter("mode");
				
				if(mode.equals("detail") || mode.equals("create") || mode.equals("modify")) {
					
					if(mode.equals("detail") || mode.equals("modify")) {
						
						String question_number = request.getParameter("question_number");
						
						Admin_Qna_VO qna = web_teacher_service.Get_Admin_Qna_One(question_number, sessionUid);
						
						if(qna != null) {
							
							model.addAttribute("qna", qna);
							
							if(mode.equals("modify")) {
								if(qna.getQuestion_state().equals("1")) {
									return "redirect:/teacher/service/qna_list";
								}
							}
							
						}else {
							return "redirect:/teacher/service/qna_list";
						}
						
					}
					
				}else {
					return "redirect:/teacher/service/qna_list";
				}
				
				model.addAttribute("mode", mode);
				
				return "/teacher/service/qna_detail";
			}
		}
	}
	
	
	//1:1문의 상세 처리
	@ResponseBody
	@RequestMapping(value = "/qna_detail_work", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String qna_detail_work(Locale locale, HttpSession session, MultipartHttpServletRequest request) {
		
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
				
				if(mode.equals("delete")) {
					
					String question_number = request.getParameter("question_number");
					String teacher_id = sessionUid;
					String deleteFile = request.getParameter("deleteFile");
					if(question_number == null) {
						return "fail";
					}

					if(web_teacher_service.Delete_Admin_Qna(question_number, teacher_id)) {
						if(deleteFile != null) {
							File delete_file = new File(deleteFile);
							if(delete_file.exists()) {
								delete_file.delete();							
							}
						}
						
						return "success";
					}else {
						return "fail";
					}
					
				}else if(mode.equals("modify")) {
					String question_number = request.getParameter("question_number");
					String teacher_id = sessionUid;
					String question_title = request.getParameter("question_title");
					String question_content = request.getParameter("question_content");
					String question_image_content = request.getParameter("question_image_content");
					String deleteFile = request.getParameter("deleteFile");
					
					SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
					format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
					Date time = new Date();
					
					String question_date = format.format(time);
					
					if(question_title == null || question_content == null) {
						return "fail";	
					}
					
					if(question_image_content.equals("null")) {
						question_image_content = null;
					}
					
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
						for(MultipartFile this_file : fileList) {
							String newFileName = sessionUid + question_date + ".jpg";
							File target = new File(Qna_uploadPath, newFileName);
					        //파일 복사
					        try {
					            FileCopyUtils.copy(this_file.getBytes(), target);
					            question_image_content = Qna_uploadPath + "/" + newFileName;
					            
					        } catch(Exception e) {
					            e.printStackTrace();
					    		return "fail";
					        }
						}
					}
					
					if(web_teacher_service.Update_Admin_Qna(question_image_content, question_number, teacher_id, question_title, question_content)) {
						
						if(deleteFile != null) {
							File delete_file = new File(deleteFile);
							if(delete_file.exists()) {
								delete_file.delete();							
							}
						}
						
						return "success";
					}else {
						return "fail";
					}
					
					
				}else if(mode.equals("create")) {
					
					SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
					format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
					Date time = new Date();
					
					String question_date = format.format(time);
					String question_id = sessionUid;
					String question_name = (String)session.getAttribute("teacher_name");
					String question_belong = (String)session.getAttribute("teacher_school");
					String question_phonenumber = (String)session.getAttribute("teacher_phone");
					String question_title = request.getParameter("question_title");
					String question_type = "선생님 문의";
					String question_content = request.getParameter("question_content");
					String question_image_content = null;
					
					if(question_title == null || question_content == null) {
						return "fail";	
					}
					
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
						for(MultipartFile this_file : fileList) {
							String newFileName = sessionUid + question_date + ".jpg";
							File target = new File(Qna_uploadPath, newFileName);
					        //파일 복사
					        try {
					            FileCopyUtils.copy(this_file.getBytes(), target);
					            question_image_content = Qna_uploadPath + "/" + newFileName;
					            
					        } catch(Exception e) {
					            e.printStackTrace();
					    		return "fail";
					        }
						}
					}
					
					if(web_teacher_service.Create_Admin_Qna(question_date, question_id, question_name, question_belong, question_phonenumber, question_title, question_type, question_content, question_image_content)) {
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
