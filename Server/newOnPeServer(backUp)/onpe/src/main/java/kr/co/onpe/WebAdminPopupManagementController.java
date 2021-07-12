package kr.co.onpe;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
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
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.onpe.security.JwtTokenProvider;
import kr.co.onpe.service.WebUserAuthService;
import kr.co.onpe.service.Web_Admin_Management_Service;
import kr.co.onpe.vo.Popup_List_VO;

@Controller
@RequestMapping("/admin/popup/*")
public class WebAdminPopupManagementController {

	private static final Logger logger = LoggerFactory.getLogger(WebAdminPopupManagementController.class);
	
	/* 사용자 정보 테이블(student_information) 테이블 관련 서비스 */
	@Inject
	private Web_Admin_Management_Service web_Admin_Management_Service;
	
	@Inject
	private WebUserAuthService webUserAuthService;
	
	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
	@Resource(name="Popup_uploadPath")
    String Popup_uploadPath;
	
	//팝업관리 목록
	@RequestMapping(value = "/popup_management_list", produces = "application/json; charset=utf8", method = RequestMethod.GET)
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
				
				String popup_use = request.getParameter("popup_use");
				String option = popup_use;
				String keyword = request.getParameter("keyword");
				String page = request.getParameter("page");
				String sqlpage = null;
				String pageing_url = "/admin/popup/popup_management_list?ck=1";
				
				if(popup_use != null && popup_use.equals("사용")) {
					popup_use = "1";
					pageing_url += "&popup_use=사용";
				}else if(popup_use != null && popup_use.equals("미사용")) {
					pageing_url += "&popup_use=미사용";
					popup_use = "0";
				}else {
					popup_use = null;
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
				
				List popup_list = web_Admin_Management_Service.Get_Popup_List(popup_use, keyword, sqlpage);
				
				String popup_count = web_Admin_Management_Service.Get_Popup_Count(popup_use, keyword);
				if(popup_count == null) {
					popup_count = "0";
				}
				int popup_count_int = Integer.parseInt(popup_count) / 15;
				int popup_count_result = Integer.parseInt(popup_count) % 15;
				if(popup_count_result > 0) {
					popup_count_int++;
				}
				
				
				model.addAttribute("popup_list",popup_list);
				model.addAttribute("page",page);
				model.addAttribute("last_page",Integer.toString(popup_count_int));
				model.addAttribute("pageing_start",Integer.toString(pageing_start));
				if(popup_count_int < pageing_start + 4) {
					model.addAttribute("pageing_last",Integer.toString(popup_count_int));
				}else {
					model.addAttribute("pageing_last",Integer.toString(pageing_start + 4));
				}
				model.addAttribute("keyword",keyword);
				model.addAttribute("option",option);
				model.addAttribute("pageing_url",pageing_url);				
				
				
				return "/admin/popup/popup_management_list";
				
			}
			
		}
	}
	
	//팝업관리 상세, 수정, 등록
	@RequestMapping(value = "/popup_management_detail", produces = "application/json; charset=utf8", method = RequestMethod.GET)
	public String popup_management_detail(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
						
						String popup_number = request.getParameter("popup_number");
						
						Popup_List_VO popup = (Popup_List_VO)web_Admin_Management_Service.Get_Popup(popup_number);
						model.addAttribute("popup",popup);
						
					}
					model.addAttribute("mode",mode);
					
					return "/admin/popup/popup_management_detail";
					
				}else {
					return "/admin/popup/popup_management_list";
				}
				
			}
			
		}
	}
	
	//팝업관리 수정, 등록 처리 페이지
	@ResponseBody
	@RequestMapping(value = "/popup_management_detail_work", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String popup_management_detail_work(Locale locale, Model model, HttpSession session, HttpServletRequest request, MultipartFile file) {
		
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
				SimpleDateFormat format2 = new SimpleDateFormat ( "yyyyMMdd");
				format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				format2.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date time = new Date();
				String popup_attachments = Popup_uploadPath + "/" + format.format(time) + ".jpg";
				
				String popup_create_date = format2.format(time);
				String mode = request.getParameter("mode");
				String popup_name = request.getParameter("popup_name");
				String popup_content = request.getParameter("popup_content");
				String popup_x_size = request.getParameter("popup_x_size");
				String popup_y_size = request.getParameter("popup_y_size");
				String popup_y_location = request.getParameter("popup_y_location");
				String popup_x_location = request.getParameter("popup_x_location");
				String popup_start_date = request.getParameter("popup_start_date");
				String popup_end_date = request.getParameter("popup_end_date");
				String popup_use = request.getParameter("popup_use");
				String popup_number = request.getParameter("popup_number");
				
				if(mode != null && popup_name != null && popup_content != null && popup_x_size != null && popup_y_size != null && popup_y_location != null && popup_x_location != null && popup_start_date != null && popup_end_date != null && popup_use != null) {
					
					if(!mode.equals("create") && !mode.equals("modify")) {
						System.out.println("모드");
						return "fail";
					}else if(popup_name.length() < 2 || popup_name.length() > 50) {
						System.out.println("팝업명");
						return "fail";
					}else if(popup_content.length() < 2 || popup_content.length() > 500) {
						System.out.println("팝업내용");
						return "fail";
					}else if(!kr.co.onpe.common.common.isInteger(popup_x_size) || !kr.co.onpe.common.common.isInteger(popup_y_size) || !kr.co.onpe.common.common.isInteger(popup_y_location) || !kr.co.onpe.common.common.isInteger(popup_x_location) || !kr.co.onpe.common.common.isInteger(popup_start_date) || !kr.co.onpe.common.common.isInteger(popup_end_date)) {
						System.out.println("숫자아님");
						return "fail";
					}else if(popup_x_size.length() < 1 || popup_x_size.length() > 3) {
						System.out.println("popup_x_size length");
						return "fail";
					}else if(popup_y_size.length() < 1 || popup_y_size.length() > 3) {
						System.out.println("popup_y_size length");
						return "fail";
					}else if(popup_y_location.length() < 1 || popup_y_location.length() > 3) {
						System.out.println("popup_y_location length");
						return "fail";
					}else if(popup_x_location.length() < 1 || popup_x_location.length() > 3) {
						System.out.println("popup_x_location length");
						return "fail";
					}else if(popup_start_date.length() != 8 || popup_end_date.length() != 8) {
						System.out.println("popup_x_size length");
						return "fail";
					}else if(!popup_use.equals("0") && !popup_use.equals("1")) {
						System.out.println("popup_use");
						return "fail";
					}else {
						if(mode.equals("create")) {
							
							if(file == null) {
								System.out.println("create: 파일없음");
								return "fail";
							}else {				
								
								if(kr.co.onpe.common.common.checkImageType(file.getOriginalFilename())) {
									
									File target = new File(popup_attachments);
							        
							        //파일 복사
							        try {
							        	FileCopyUtils.copy(file.getBytes(), target);
							        	
							        } catch(Exception e) {
							        	e.printStackTrace();
							    		return "fail";
							        }
							        
								}else {
									System.out.println("파일 확장자");
						    		return "fail";
								}

								boolean result = web_Admin_Management_Service.Modify_or_Create_Popup(popup_name, popup_content, popup_x_size, popup_y_size, popup_x_location, popup_y_location, popup_start_date, popup_end_date, popup_create_date, popup_attachments, popup_use, popup_number, mode);
						        
						        if(result) {
						        	return "success";
						        }else {
						        	return "fail";
						        }
						        
							}
							
						}else if(mode.equals("modify")) {
							
							if(popup_number != null) {
								
								//파일이 있는 경우
								if(file != null) {
									
									if(kr.co.onpe.common.common.checkImageType(file.getOriginalFilename())) {
										
										//기존파일의 경로를 알아와서 같은 이름으로 저장한다.
							        	Popup_List_VO popup = (Popup_List_VO)web_Admin_Management_Service.Get_Popup(popup_number);
							        	popup_attachments = popup.getPopup_attachments();
										
										File target = new File(popup_attachments);	//jpg로 통일
								        
								        //파일 복사
								        try {
								        	FileCopyUtils.copy(file.getBytes(), target);
								        	
								        } catch(Exception e) {
								        	e.printStackTrace();
								    		return "fail";
								        }
								        
									}else {
										System.out.println("파일 확장자");
							    		return "fail";
									}
									
								}
								
								boolean result = web_Admin_Management_Service.Modify_or_Create_Popup(popup_name, popup_content, popup_x_size, popup_y_size, popup_x_location, popup_y_location, popup_start_date, popup_end_date, null, null, popup_use, popup_number, mode);
						        
						        if(result) {
						        	return "success";
						        }else {
						        	return "fail";
						        }
								
								
							}else {
								System.out.println("popup_number");
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
