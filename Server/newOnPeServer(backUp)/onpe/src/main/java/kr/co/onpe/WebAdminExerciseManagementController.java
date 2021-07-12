package kr.co.onpe;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

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
import kr.co.onpe.vo.Exercise_Category_VO;
import kr.co.onpe.vo.Student_Information_VO;

@Controller
@RequestMapping("/admin/exercise/*")
public class WebAdminExerciseManagementController {

	private static final Logger logger = LoggerFactory.getLogger(WebAdminExerciseManagementController.class);
	
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
	
	//종목관리 목록
	@RequestMapping(value = "/exercise_management_list", produces = "application/json; charset=utf8", method = RequestMethod.GET)
	public String exercise_management_list(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
				String exercise_name = request.getParameter("exercise_name");			//종목 이름
				String exercise_category = request.getParameter("exercise_category");	//종목 대분류
				String exercise_area = request.getParameter("exercise_area");			//종목 영역
				String keyword = request.getParameter("keyword");						//검색어
				
				int pageing_start = 1;
				String pageing_url = "/admin/exercise/exercise_management_list?ck=1";
				if(!kr.co.onpe.common.common.isInteger(page) || page == null || Integer.parseInt(page) < 0) {
					page = "1";
					sqlpage = "0";
				}else {
					pageing_start = 5*((Integer.parseInt(page) - 1) / 5) + 1;
					sqlpage = Integer.toString((Integer.parseInt(page) - 1)*15);
				}
				
				if(exercise_name == null || exercise_name.length() < 2 || exercise_name.length() > 20) {
					exercise_name = null;
				}else {
					pageing_url += "&exercise_name="+exercise_name;
				}
				if(exercise_category == null || exercise_category.length() < 2 || exercise_category.length() > 20) {
					exercise_category = null;
				}else {
					pageing_url += "&exercise_category="+exercise_category;
				}
				if(exercise_area == null || exercise_area.length() != 2) {
					exercise_area = null;
				}else {
					pageing_url += "&exercise_area="+exercise_area;
				}
				if(keyword == null || keyword.length() < 2 || keyword.length() > 30) {
					keyword = null;
				}else {
					pageing_url += "&keyword="+keyword;
				}
				
				String exercise_count = web_Admin_Management_Service.Get_Exercise_Count(exercise_name, exercise_category, exercise_area, keyword);
				List exercise_list_t = web_Admin_Management_Service.Get_Exercise_List(exercise_name, exercise_category, exercise_area, keyword, sqlpage);
				List<Exercise_Category_VO> exercise_list = new ArrayList<Exercise_Category_VO>(); 
				Gson gson = new Gson();
				for(int x=0;x<exercise_list_t.size();x++) {
					Exercise_Category_VO temp = (Exercise_Category_VO)exercise_list_t.get(x);
					List<String> temp_exercise_area = gson.fromJson(temp.getExercise_area(), new TypeToken<List<String>>(){}.getType());
					temp.setExercise_area_temp(temp_exercise_area);
					exercise_list.add(temp);
				}
				
				
				int exercise_count_int = Integer.parseInt(exercise_count) / 15;
				int exercise_count_result = Integer.parseInt(exercise_count) % 15;
				if(exercise_count_result > 0) {
					exercise_count_int++;
				}
				
				
				model.addAttribute("exercise_list",exercise_list);
				model.addAttribute("exercise_count",exercise_count);
				model.addAttribute("page",page);
				model.addAttribute("last_page",Integer.toString(exercise_count_int));
				model.addAttribute("pageing_start",Integer.toString(pageing_start));
				if(exercise_count_int < pageing_start + 4) {
					model.addAttribute("pageing_last",Integer.toString(exercise_count_int));
				}else {
					model.addAttribute("pageing_last",Integer.toString(pageing_start + 4));
				}
				model.addAttribute("keyword",keyword);				
				model.addAttribute("exercise_name",exercise_name);
				model.addAttribute("exercise_category",exercise_category);
				model.addAttribute("exercise_area",exercise_area);
				model.addAttribute("pageing_url",pageing_url);
				
				/* 임시 종목 + 임시 대분류 */
				/*#################################################*/
				HashMap<String, Object> data = new HashMap<String, Object>();
				List<Object> top_list = new ArrayList<>();	
				top_list.add("홈트레이닝");
				
				data.put("홈트레이닝", top_list);	
				model.addAttribute("exercise_name_obj",gson.toJson(data));
				/*#################################################*/
				
				
				return "/admin/exercise/exercise_management_list";
				
			}
			
		}
	}
	
	//종목관리 수정, 등록 페이지
	@RequestMapping(value = "/exercise_management_detail", produces = "application/json; charset=utf8", method = RequestMethod.GET)
	public String exercise_management_detail(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		
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
			
			String exercise_code = request.getParameter("exercise_code");
			String mode = request.getParameter("mode");
			
			if(mode != null) {
				if(mode.equals("create")) {
					// 성공
					Gson gson = new Gson();
					/* 임시 종목 + 임시 대분류 */
					/*#################################################*/
					HashMap<String, Object> data = new HashMap<String, Object>();
					List<Object> top_list = new ArrayList<>();	
					top_list.add("홈트레이닝");
					
					data.put("홈트레이닝", top_list);	
					model.addAttribute("exercise_name_obj",gson.toJson(data));
					/*#################################################*/
					
					model.addAttribute("mode",mode);
					return "/admin/exercise/exercise_management_detail";
				}else if(mode.equals("modify")) {
					if(exercise_code != null) {
						
						Exercise_Category_VO exercise = web_Admin_Management_Service.Get_Exercise(exercise_code);
						
						if(exercise != null) {
							
							Gson gson = new Gson();
							List<String> temp_exercise_area = gson.fromJson(exercise.getExercise_area(), new TypeToken<List<String>>(){}.getType());
							exercise.setExercise_area_temp(temp_exercise_area);
							
							/* 임시 종목 + 임시 대분류 */
							/*#################################################*/
							int temp_number = 1;
							HashMap<String, Object> data = new HashMap<String, Object>();
							for(int x=1;x<6;x++) {
								
								List<Object> top_list = new ArrayList<>();	
								for(int xx=0;xx<5;xx++) {
									top_list.add("분류"+Integer.toString(temp_number));	
									temp_number++;
								}
								
								data.put("종목"+x, top_list);	
							}
							model.addAttribute("exercise_name_obj",gson.toJson(data));
							/*#################################################*/
							
							model.addAttribute("exercise", exercise);
							model.addAttribute("mode",mode);
							
							return "/admin/exercise/exercise_management_detail";						
						}else {
							return "redirect:/admin/exercise/exercise_management_list";	
						}
						
					}else {
						return "redirect:/admin/exercise/exercise_management_list";
					}
				}else {
					return "redirect:/admin/exercise/exercise_management_list";
				}
			}else {
				return "redirect:/admin/exercise/exercise_management_list";
			}			
		}
	}
	
	//종목관리 수정, 등록 처리 페이지
	@ResponseBody
	@RequestMapping(value = "/exercise_management_detail_work", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String exercise_management_detail_work(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				String exercise_code = request.getParameter("exercise_code");
				String exercise_name = request.getParameter("exercise_name");
				String exercise_category = request.getParameter("exercise_category");
				String exercise_type = request.getParameter("exercise_type");
				String exercise_area = request.getParameter("exercise_area");
				String exercise_detail_name = request.getParameter("exercise_detail_name");
				String exercise_count = request.getParameter("exercise_count");
				String exercise_time = request.getParameter("exercise_time");
				String exercise_url = request.getParameter("exercise_url");
				String exercise_level = request.getParameter("exercise_level");
				
				if(mode.equals("modify")) {
					if(exercise_code == null) {
						return "fail";
					}
				}
				
				if(mode != null && exercise_name != null && exercise_category != null && exercise_type != null && exercise_area != null && exercise_detail_name != null && exercise_count != null && exercise_time != null && exercise_url != null && exercise_level != null) {

					if(!mode.equals("modify") && !mode.equals("create")) {
						return "fail";
					}else if(exercise_name.length() > 10 || exercise_name.length() < 2) {
						return "fail";
					}else if(exercise_category.length() > 20 || exercise_category.length() < 2) {
						return "fail";
					}else if(!exercise_type.equals("0") && !exercise_type.equals("1") && !exercise_type.equals("2")) {
						return "fail";
					}else if(exercise_detail_name.length() > 30 || exercise_detail_name.length() < 2) {
						return "fail";
					}else if(exercise_count.length() > 3 || exercise_count.length() < 1 || !kr.co.onpe.common.common.isInteger(exercise_count)) {
						return "fail";
					}else if(exercise_time.length() > 3 || exercise_time.length() < 1 || !kr.co.onpe.common.common.isInteger(exercise_time)) {
						return "fail";
					}else if(!exercise_level.equals("0") && !exercise_level.equals("1") && !exercise_level.equals("2") && !exercise_level.equals("3")) {
						return "fail";
					}else {

						boolean result = web_Admin_Management_Service.Modify_or_Create_Exercise(mode, exercise_code, exercise_name, exercise_category, exercise_type, exercise_area, exercise_detail_name, exercise_count, exercise_time, exercise_url, exercise_level);

						if(result) {
							return "success";
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
