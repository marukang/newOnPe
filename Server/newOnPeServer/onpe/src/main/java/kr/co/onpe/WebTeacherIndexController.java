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
import kr.co.onpe.service.Web_Teacher_Index_Service;
import kr.co.onpe.service.Web_Teacher_Progress_Service;
import kr.co.onpe.vo.Admin_Notice_VO;

@Controller
@RequestMapping("/teacher/*")
public class WebTeacherIndexController {
	
	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
	/* 서비스 */
	@Inject
	private Web_Teacher_Index_Service web_Teacher_Service;
	
	@Inject
	private Web_Teacher_Progress_Service web_Teacher_Service2;
	
	private static final Logger logger = LoggerFactory.getLogger(WebTeacherIndexController.class);
	
	/* index에서 앱사용자 메세지 불러오기 */
	@ResponseBody
	@RequestMapping(value = "/get_index_student_message", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String get_index_student_message(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				String keyword = request.getParameter("keyword");
				String page = request.getParameter("page");
				String sqlpage = null;
				
				if(keyword != null && ( keyword.length() < 2 || keyword.length() > 80 )) {
					keyword = null;
				}
				
				int pageing_start = 1;
				if(!kr.co.onpe.common.common.isInteger(page) || page == null || Integer.parseInt(page) < 0) {
					page = "1";
					sqlpage = "0";
				}else {
					pageing_start = 5*((Integer.parseInt(page) - 1) / 5) + 1;
					sqlpage = Integer.toString((Integer.parseInt(page) - 1)*5);
				}
				List<String> teacher_classcode = (List<String>) session.getAttribute("teacher_classcode");
				if(teacher_classcode != null && teacher_classcode.size() > 0) {
					String count = web_Teacher_Service.Get_Student_Message_Count(teacher_classcode, keyword);
					List message = web_Teacher_Service.Get_Student_Message_List(teacher_classcode, sqlpage, keyword);
					
					int count_int = Integer.parseInt(count) / 5;
					int count_result = Integer.parseInt(count) % 5;
					if(count_result > 0) {
						count_int++;
					}
					
					if(message.size() != 0) {
						Gson gson = new Gson();
						
						HashMap<String, Object> data = new HashMap<String, Object>();
						data.put("count_int", count_int);
						data.put("last_page", Integer.toString(count_int));
						data.put("pageing_start", Integer.toString(pageing_start));
						if(count_int < pageing_start + 4) {
							data.put("pageing_last", Integer.toString(count_int));
						}else {
							data.put("pageing_last", Integer.toString(pageing_start + 4));
						}
						data.put("message", message);
						
						return gson.toJson(data);	
					}else {
						return null;
					}
				}else {
					return null;
				}
			}
		}
	}
	
	/* index에서 관리자 공지사항 불러오기 */
	@ResponseBody
	@RequestMapping(value = "/get_index_admin_notice", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String get_index_admin_notice(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				String keyword = request.getParameter("keyword");
				String page = request.getParameter("page");
				String sqlpage = null;
				
				if(keyword != null && ( keyword.length() < 2 || keyword.length() > 80 )) {
					keyword = null;
				}
				
				int pageing_start = 1;
				if(!kr.co.onpe.common.common.isInteger(page) || page == null || Integer.parseInt(page) < 0) {
					page = "1";
					sqlpage = "0";
				}else {
					pageing_start = 5*((Integer.parseInt(page) - 1) / 5) + 1;
					sqlpage = Integer.toString((Integer.parseInt(page) - 1)*5);
				}
				
				String count = web_Teacher_Service.Get_Admin_Notice_Count(keyword);
				List notice = web_Teacher_Service.Get_Admin_Notice_List(keyword, sqlpage);
				
				int count_int = Integer.parseInt(count) / 5;
				int count_result = Integer.parseInt(count) % 5;
				if(count_result > 0) {
					count_int++;
				}				
				
				if(notice.size() != 0) {
					
					Gson gson = new Gson();
					
					HashMap<String, Object> data = new HashMap<String, Object>();
					data.put("count_int", count_int);
					data.put("last_page", Integer.toString(count_int));
					data.put("pageing_start", Integer.toString(pageing_start));
					if(count_int < pageing_start + 4) {
						data.put("pageing_last", Integer.toString(count_int));
					}else {
						data.put("pageing_last", Integer.toString(pageing_start + 4));
					}
					data.put("notice", notice);
					
					return gson.toJson(data);	
				}else {
					return null;
				}
				
			}
		}
	}
	
	
	/* index에서 메세지 답장(수정)하기 or 메세지 삭제하기 */
	@ResponseBody
	@RequestMapping(value = "/update_index_student_message", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String update_index_student_message(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				if(mode != null) {
					if(mode.equals("delete")) {
						String message_numbers = request.getParameter("message_number");
						if(message_numbers != null && message_numbers.length() > 2) {
							Gson gson = new Gson();
							List<String> message_number = gson.fromJson(message_numbers , new TypeToken<List<String>>(){}.getType());
							boolean result = web_Teacher_Service.Delete_Student_Message(message_number);
							if(result) {
								return "success";
							}else {
								return "fail";
							}	
						}else {
							return "fail";
						}
					}else if(mode.equals("create")) {
						String message_comment = request.getParameter("message_comment");
						String message_number = request.getParameter("message_number");
						if(message_comment != null && message_comment.length() > 2 && message_number != null && message_comment.length() > 1) {
							String message_teacher_name = (String)session.getAttribute("teacher_name");
							String message_teacher_id = (String)session.getAttribute("teacher_id");
							SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
							format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
							Date time = new Date();
							String message_comment_date = format.format(time);
							boolean result = web_Teacher_Service.Update_Student_Message(message_comment, message_teacher_name, message_teacher_id, message_comment_date, message_number);
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
				}else {
					return "fail";
				}
			}
		}
	}
	
	/* index에서 오늘의 수업 가져오기 */
	@ResponseBody
	@RequestMapping(value = "/get_index_curriculum", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String get_index_curriculum(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				String time_number = format.format(time);
				
				String page = request.getParameter("page");
				String sqlpage = null;
				
				int pageing_start = 1;
				if(!kr.co.onpe.common.common.isInteger(page) || page == null || Integer.parseInt(page) < 0) {
					page = "1";
					sqlpage = "0";
				}else {
					pageing_start = 5*((Integer.parseInt(page) - 1) / 5) + 1;
					sqlpage = Integer.toString((Integer.parseInt(page) - 1)*4);
				}
				
				List<String> class_code = web_Teacher_Service2.Get_Class_Code_By_Id(sessionUid);
				if(class_code == null || class_code.size() == 0) {
					return "fail";
				}
				
				String count = web_Teacher_Service.Get_Today_Curriculum_Unit_List_Class_Count(class_code, time_number);
				List curr = web_Teacher_Service.Get_Today_Curriculum_Unit_List_Class(class_code, time_number, sqlpage);
				
				int count_int = Integer.parseInt(count) / 4;
				int count_result = Integer.parseInt(count) % 4;
				if(count_result > 0) {
					count_int++;
				}
				
				if(curr.size() != 0) {
					Gson gson = new Gson();
					
					HashMap<String, Object> data = new HashMap<String, Object>();
					data.put("count_int", count_int);
					data.put("last_page", Integer.toString(count_int));
					data.put("pageing_start", Integer.toString(pageing_start));
					if(count_int < pageing_start + 4) {
						data.put("pageing_last", Integer.toString(count_int));
					}else {
						data.put("pageing_last", Integer.toString(pageing_start + 4));
					}
					data.put("curriculum", curr);
					
					return gson.toJson(data);
				}else {
					return "fail";
				}
				
			}
		}
	}
	
	
	
	/* 메세지 전송에서 학생목록 불러오기 */
	@ResponseBody
	@RequestMapping(value = "/get_index_student_information", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String get_index_student_information(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				
				List<String> class_code = (List<String>)session.getAttribute("teacher_classcode");
				String student_level = request.getParameter("student_level");
				String student_class = request.getParameter("student_class");
				
				if(class_code == null) {
					class_code = new ArrayList<String>();
					class_code.add("n");
				}
				
				Gson gson = new Gson();
				
				return gson.toJson(web_Teacher_Service.Get_Student_Information(class_code, student_level, student_class));
			}
		}
	}
	
	/* 메세지 전송 */
	@ResponseBody
	@RequestMapping(value = "/set_common_message", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String set_common_message(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
		if(session.getAttribute("teacher_id") == null || session.getAttribute("teacher_token") == null || session.getAttribute("admin_auth") == null) {
			return "fail";
		}else {
			String token = (String)session.getAttribute("teacher_token");
			String sessionUid = (String)session.getAttribute("teacher_id");
			String sessionUAuth = (String)session.getAttribute("admin_auth");
			String sessionUname = (String)session.getAttribute("teacher_name");
			
			//토큰 유효성 + 사용자 일치성 체크
			String new_token = jwtTokenProvider.TokenCheck(sessionUid, sessionUAuth, token);
			if(new_token.equals("fail") || new_token.equals("expired")) {
				return "fail";
			}else {
				session.setAttribute("teacher_token", new_token);
				
				String target_id = request.getParameter("target_id");
				String message_content = request.getParameter("message_content");
				
				if(target_id != null && message_content != null) {
					
					SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
					format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
					Date time = new Date();
					String time_number = format.format(time);
					
					if(web_Teacher_Service.Send_Common_Message(sessionUid, sessionUname, message_content, target_id, time_number)) {
						web_Teacher_Service.Update_Student_News_State(target_id);
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
