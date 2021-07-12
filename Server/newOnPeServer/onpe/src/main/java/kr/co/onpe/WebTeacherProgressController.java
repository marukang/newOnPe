package kr.co.onpe;

import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
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

import kr.co.onpe.common.Fcm_Util;
import kr.co.onpe.security.JwtTokenProvider;
import kr.co.onpe.service.Web_Teacher_Progress_Service;
import kr.co.onpe.service.Web_Teacher_Ready_Service;
import kr.co.onpe.vo.Class_Community_Comment_VO;
import kr.co.onpe.vo.Class_Community_VO;
import kr.co.onpe.vo.Class_List_VO;
import kr.co.onpe.vo.Class_Record_VO;
import kr.co.onpe.vo.Curriculum_Unit_List_Class_VO;
import kr.co.onpe.vo.Json_Class_Unit_List_VO;
import kr.co.onpe.vo.Student_Information_VO;

@Controller
@RequestMapping("/teacher/progress/*")
public class WebTeacherProgressController {
	
	/* 토큰발급, 검증, 재발급 등 access token 관련 클래스 */
	@Autowired
	private JwtTokenProvider jwtTokenProvider;
	
	/* 서비스 */
	@Inject
	private Web_Teacher_Progress_Service web_Teacher_Service;
	
	@Inject
	private Web_Teacher_Ready_Service web_Teacher_Ready_Service;
	
	private static final Logger logger = LoggerFactory.getLogger(WebTeacherProgressController.class);
	
	/* 수엄 진행 관리 */
	@RequestMapping(value = "/class_progress_management", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String class_progress_management(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				if(class_code != null && unit_code != null) {
					model.addAttribute("class_code", class_code);
					model.addAttribute("unit_code", unit_code);
					model.addAttribute("get","y");
				}else {
					model.addAttribute("get","n");
				}
				
				
				return "/teacher/progress/class_progress_management";
			}
		}
	}
	
	/* 공지사항 전송 */
	@ResponseBody
	@RequestMapping(value = "/send_notification", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String get_class_progress_management_calendar(Locale locale, HttpSession session, HttpServletRequest request) {
		
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
				
				String title = request.getParameter("push_title");
				String content = request.getParameter("push_content");
				String class_code = request.getParameter("class_code");
				SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
				format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date time = new Date();
				String date = format.format(time);
				if(title != null && content != null && class_code != null) {
					List<Student_Information_VO> student_infos = web_Teacher_Service.Get_Student_Tokens_For_Noti(class_code);
					if(student_infos != null && student_infos.size() > 0) {
						List<String> tokens = new ArrayList<String>();
						List<String> student_ids = new ArrayList<String>();
						for(int x=0;x<student_infos.size();x++) {
							if(student_infos.get(x).getStudent_token() != null && student_infos.get(x).getStudent_token().length() > 5) {
								tokens.add(student_infos.get(x).getStudent_token());
								student_ids.add(student_infos.get(x).getStudent_id());	
							}
						}
						
						if(web_Teacher_Service.Create_Notice_List(class_code, title, content, date, sessionUid, sessionUname)) {
							
							//학생 새소식 업데이트
							web_Teacher_Service.Update_Student_News_State(student_ids);
							
							Fcm_Util fcmUtil = new Fcm_Util();
							fcmUtil.send_FCM(tokens, title, content);
							return "success";	
						}else {
							return "fail";
						}
					}else {
						return "none";
					}	
				}else {
					return "fail";
				}
			}
		}
	}
	
	
	/* 수엄 진행 관리 */
	@ResponseBody
	@RequestMapping(value = "/get_class_progress_management_work", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String get_class_progress_management_calendar(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				if(mode != null) {
					if(mode.equals("calendar")) {
						
						List<String> class_code = web_Teacher_Service.Get_Class_Code_By_Id(sessionUid);
						if(class_code.size() != 0) {
							List<Curriculum_Unit_List_Class_VO> curriculum_unit_list_class = web_Teacher_Service.Get_Curriculum_Unit_List_Class(class_code);
							if(curriculum_unit_list_class.size() != 0) {
								Gson gson = new Gson();
								return gson.toJson(curriculum_unit_list_class);	
							}else {
								return "none";
							}
						}else {
							return "none";
						}
					}else if(mode.equals("curriculum")) {
						
						String class_code = request.getParameter("class_code");
						String unit_code = request.getParameter("unit_code");
						
						if(class_code != null && unit_code != null) {
							Class_List_VO class_list = web_Teacher_Service.Get_Class_List_By_Class_Code(class_code);
							List<Curriculum_Unit_List_Class_VO> curriculum_unit_list_class = web_Teacher_Service.Get_Curriculum_Unit_List_Class_One(class_code, unit_code);
							
							HashMap<String, Object> data = new HashMap<String, Object>();
							data.put("class_list", class_list);
							data.put("curriculum", curriculum_unit_list_class);
							
							Gson gson = new Gson();
							return gson.toJson(data);	
							
						}else {
							return "fail";
						}
					}else if(mode.equals("record_list")) {
						
						Gson gson = new Gson();
						
						String id_list = request.getParameter("number_list");
						String class_code = request.getParameter("class_code");
						String unit_code = request.getParameter("unit_code");
						String page = request.getParameter("page");
						String sqlpage = "";
						
						int pageing_start = 1;
						
						if(!kr.co.onpe.common.common.isInteger(page) || page == null || Integer.parseInt(page) <= 0) {
							page = "1";
							sqlpage = "0";
						}else {
							pageing_start = 5*((Integer.parseInt(page) - 1) / 5) + 1;
							sqlpage = Integer.toString((Integer.parseInt(page) - 1)*5);
						}
						List<Class_Record_VO> student_class_record = null;
						String content_count = null;
						if(id_list != null && id_list.length() > 4) {
							List<String> id_list_g = gson.fromJson(id_list, new TypeToken<List<String>>(){}.getType());
							
							student_class_record = web_Teacher_Service.Get_Student_Class_Record_List(class_code, unit_code, sqlpage, id_list_g);
							content_count = web_Teacher_Service.Get_Student_Class_Record_List_Count(class_code, unit_code, id_list_g);
						}else {
							student_class_record = web_Teacher_Service.Get_Student_Class_Record_List(class_code, unit_code, sqlpage, null);
							content_count = web_Teacher_Service.Get_Student_Class_Record_List_Count(class_code, unit_code, null);	
						}
						
						if(content_count == null) {
							content_count = "0";
						}
						
						int count_int = Integer.parseInt(content_count) / 5;
						int count_result = Integer.parseInt(content_count) % 5;
						if(count_result > 0) {
							count_int++;
						}
						
						HashMap<String, Object> data = new HashMap<String, Object>();
						data.put("record", student_class_record);
						data.put("last_page", Integer.toString(count_int));
						data.put("pageing_start", Integer.toString(pageing_start));
						if(count_int < pageing_start + 4) {
							data.put("pageing_last", Integer.toString(count_int));
						}else {
							data.put("pageing_last", Integer.toString(pageing_start + 4));
						}
						
						
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
	
	/* 수엄 진행 관리 */
	@ResponseBody
	@RequestMapping(value = "/update_student_class_record", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String update_student_class_record(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				String unit_code = request.getParameter("unit_code");
				String student_id = request.getParameter("student_id");
				String evaluation_type_1 = request.getParameter("evaluation_type_1");
				String evaluation_type_2 = request.getParameter("evaluation_type_2");
				String evaluation_type_3 = request.getParameter("evaluation_type_3");

				if(class_code != null && unit_code != null && student_id != null && evaluation_type_1 != null && evaluation_type_2 != null && evaluation_type_3 != null) {
					Gson gson = new Gson();
					List<String> student_id_list = gson.fromJson(student_id, new TypeToken<List<String>>(){}.getType());
					List<String> evaluation_type_1_list = gson.fromJson(evaluation_type_1, new TypeToken<List<String>>(){}.getType());
					List<String> evaluation_type_2_list = gson.fromJson(evaluation_type_2, new TypeToken<List<String>>(){}.getType());
					List<String> evaluation_type_3_list = gson.fromJson(evaluation_type_3, new TypeToken<List<String>>(){}.getType());
					boolean isOk = true;
					for(int x=0;x<student_id_list.size();x++) {
						boolean result = web_Teacher_Service.Update_Student_Class_Record_Evaluation(evaluation_type_1_list.get(x).toString(), evaluation_type_2_list.get(x).toString(), evaluation_type_3_list.get(x).toString(), unit_code, class_code, student_id_list.get(x));
						if(!result) {
							isOk = false;
						}
					}
					if(isOk) {
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
	
	
	
	/* 전체 수업현황 */
	@RequestMapping(value = "/overall_class_status", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String overall_class_status(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				String class_grade = request.getParameter("class_grade");
				String class_group = request.getParameter("class_group");
				String class_semester = request.getParameter("class_semester");
				String keyword = request.getParameter("keyword");
				String page = request.getParameter("page");
				String sqlpage = null;
				String pageing_url = "/teacher/progress/overall_class_status?ck=1";
				
				if(class_grade != null && class_grade.length()>0 && class_grade.length() < 2) {
					pageing_url += "&class_grade="+class_grade;
				}else {
					class_grade = null;
				}
				if(class_group == null) {
					class_group = null;
				}else {
					if(class_group.length() > 0 && class_group.length() < 3) {
						pageing_url += "&class_group="+class_group;
					}else {
						class_group = null;
					}	
				}
				
				if(class_semester == null) {
					class_semester = null;
				}else {
					if(class_semester.length()>0 && class_semester.length() < 2) {
						pageing_url += "&class_semester="+class_semester;
					}else {
						class_semester = null;
					}	
				}
				

				if(keyword != null && keyword.length()>1) {
					pageing_url += "&keyword="+keyword;
				}else {
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

				List<Class_List_VO> class_list = web_Teacher_Service.Get_My_Class_List(sessionUid, class_grade, class_group, class_semester, keyword, sqlpage);
				
				String class_count = web_Teacher_Service.Get_My_Class_List_Count(sessionUid, class_grade, class_group, class_semester, keyword);
				
				if(class_count == null) {
					class_count = "0";
				}
				int count_int = Integer.parseInt(class_count) / 5;
				int count_result = Integer.parseInt(class_count) % 5;
				if(count_result > 0) {
					count_int++;
				}
				
				model.addAttribute("class_list", class_list);
				model.addAttribute("page",page);
				model.addAttribute("last_page",Integer.toString(count_int));
				model.addAttribute("pageing_start",Integer.toString(pageing_start));
				if(count_int < pageing_start + 4) {
					model.addAttribute("pageing_last",Integer.toString(count_int));
				}else {
					model.addAttribute("pageing_last",Integer.toString(pageing_start + 4));
				}
				model.addAttribute("pageing_url",pageing_url);
				model.addAttribute("class_grade", class_grade);
				model.addAttribute("class_group", class_group);
				model.addAttribute("class_semester", class_semester);
				model.addAttribute("keyword", keyword);
				model.addAttribute("teacher_name", (String)session.getAttribute("teacher_name"));
				
				return "/teacher/progress/overall_class_status";
			}
		}
	}
	
	
	/* 전체 수업현황 엑셀 다운로드 */
	@ResponseBody
	@RequestMapping(value = "/overallCSExcelDownload", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public void overallCSExcelDownload(HttpServletResponse response, Model model, HttpSession session, HttpServletRequest request) throws Exception {
		
		String class_code = request.getParameter("class_code");
		String teacher_id = (String)session.getAttribute("teacher_id");
		
		HSSFWorkbook objWorkBook = new HSSFWorkbook();
	    HSSFSheet objSheet = null;
	    HSSFRow objRow = null;
	    HSSFCell objCell = null;       //셀 생성

	    //제목 폰트
	    HSSFFont font = objWorkBook.createFont();
	    font.setFontHeightInPoints((short)10);
	    font.setBoldweight((short)font.BOLDWEIGHT_BOLD);
	    font.setFontName("맑은고딕");

	    //제목 스타일에 폰트 적용, 정렬
	    HSSFCellStyle styleHd = objWorkBook.createCellStyle();    //제목 스타일
	    styleHd.setWrapText(true);
	    styleHd.setFont(font);
	    styleHd.setAlignment(HSSFCellStyle.ALIGN_LEFT);
	    styleHd.setVerticalAlignment (HSSFCellStyle.VERTICAL_CENTER);

	    objSheet = objWorkBook.createSheet("Sheet");     //워크시트 생성

	    // 1행
	    objRow = objSheet.createRow(0);
	    objRow.setHeight ((short) 0x150);

	    objCell = objRow.createCell(0);
	    objCell.setCellValue("차시");
	    objCell.setCellStyle(styleHd);

	    objCell = objRow.createCell(1);
	    objCell.setCellValue("수업명(차시별)");
	    objCell.setCellStyle(styleHd);
	    
	    objCell = objRow.createCell(2);
	    objCell.setCellValue("학년");
	    objCell.setCellStyle(styleHd);
	    
	    objCell = objRow.createCell(3);
	    objCell.setCellValue("학급");
	    objCell.setCellStyle(styleHd);
	    
	    objCell = objRow.createCell(4);
	    objCell.setCellValue("학번");
	    objCell.setCellStyle(styleHd);
	    
	    objCell = objRow.createCell(5);
	    objCell.setCellValue("이름");
	    objCell.setCellStyle(styleHd);
	    
	    objCell = objRow.createCell(6);
	    objCell.setCellValue("아이디");
	    objCell.setCellStyle(styleHd);
	    
	    objCell = objRow.createCell(7);
	    objCell.setCellValue("출석");
	    objCell.setCellStyle(styleHd);
	    
	    objCell = objRow.createCell(8);
	    objCell.setCellValue("과제");
	    objCell.setCellStyle(styleHd);
	    
	    objCell = objRow.createCell(9);
	    objCell.setCellValue("평가등급");
	    objCell.setCellStyle(styleHd);
	    
	    objCell = objRow.createCell(10);
	    objCell.setCellValue("평가점수");
	    objCell.setCellStyle(styleHd);
	    
	    objCell = objRow.createCell(11);
	    objCell.setCellValue("평가내용");
	    objCell.setCellStyle(styleHd);
	    
	    objCell = objRow.createCell(12);
	    objCell.setCellValue("운동기록(평가수업)");
	    objCell.setCellStyle(styleHd);
	    
	    objCell = objRow.createCell(13);
	    objCell.setCellValue("운동기록(실습수업)");
	    objCell.setCellStyle(styleHd);
		
		if(class_code != null && teacher_id != null) {
			
			Class_List_VO class_information = web_Teacher_Ready_Service.Get_Class_List_For_Management_Detail(teacher_id, class_code);
			
			if(class_information != null) {
				Gson gson = new Gson();
			    
			    List<Json_Class_Unit_List_VO> unit_list = null;
				if(class_information.getClass_unit_list() != null) {
					unit_list = gson.fromJson(class_information.getClass_unit_list(), new TypeToken<List<Json_Class_Unit_List_VO>>(){}.getType());
				}
				
				int record_count = 0;
				
				for( int x = 0; x < unit_list.size() ; x++ ) {
					
					List<Class_Record_VO> record_list = web_Teacher_Service.Get_Student_Class_Record_List_All(class_code, unit_list.get(x).getUnit_code());
					
					if(record_list != null) {
						
						for( int xx = 0; xx < record_list.size() ; xx++ ) {
							
							objRow = objSheet.createRow(record_count+1);
						    objRow.setHeight ((short) 0x150);
							
						    objCell = objRow.createCell(0);
						    objCell.setCellValue(Integer.toString(x+1)+"차시");
						    objCell.setCellStyle(styleHd);
							
							record_count += 1;
						    
						    objCell = objRow.createCell(1);
						    objCell.setCellValue(unit_list.get(x).getUnit_class_name());
						    objCell.setCellStyle(styleHd);
						    
						    objCell = objRow.createCell(2);
						    objCell.setCellValue(record_list.get(xx).getStudent_grade());
						    objCell.setCellStyle(styleHd);
						    
						    objCell = objRow.createCell(3);
						    objCell.setCellValue(record_list.get(xx).getStudent_group());
						    objCell.setCellStyle(styleHd);
						    
						    objCell = objRow.createCell(4);
						    objCell.setCellValue(record_list.get(xx).getStudent_number());
						    objCell.setCellStyle(styleHd);
						    
						    objCell = objRow.createCell(5);
						    objCell.setCellValue(record_list.get(xx).getStudent_name());
						    objCell.setCellStyle(styleHd);
						    
						    objCell = objRow.createCell(6);
						    objCell.setCellValue(record_list.get(xx).getStudent_id());
						    objCell.setCellStyle(styleHd);
						    
						    if(record_list.get(xx).getStudent_participation().equals("1")) {
						    	objCell = objRow.createCell(7);
							    objCell.setCellValue("Y");
							    objCell.setCellStyle(styleHd);						    	
						    }else {
						    	objCell = objRow.createCell(7);
							    objCell.setCellValue("N");
							    objCell.setCellStyle(styleHd);
						    }
						    
						    if(record_list.get(xx).getStudent_practice().equals("1")) {
						    	objCell = objRow.createCell(8);
							    objCell.setCellValue("Y");
							    objCell.setCellStyle(styleHd);						    	
						    }else if(record_list.get(xx).getStudent_practice().equals("0")){
						    	objCell = objRow.createCell(8);
							    objCell.setCellValue("N");
							    objCell.setCellStyle(styleHd);
						    }else {
						    	objCell = objRow.createCell(8);
							    objCell.setCellValue("-");
							    objCell.setCellStyle(styleHd);
						    }
						    
						    if(record_list.get(xx).getEvaluation_type_1() != null && record_list.get(xx).getEvaluation_type_1().length() > 2) {
						    	List<String> temp = gson.fromJson(record_list.get(xx).getEvaluation_type_1(), new TypeToken<List<String>>(){}.getType());
						    	String str = "";
						    	
						    	for(int xxx=0;xxx<temp.size();xxx++) {
						    		if(xxx != 0) {
						    			str += " / ";
						    		}
						    		str += "콘텐츠"+Integer.toString(xxx+1)+" 평가등급 : "+temp.get(xxx);
						    	}
						    	
						    	objCell = objRow.createCell(9);
							    objCell.setCellValue(str);
							    objCell.setCellStyle(styleHd);
						    	
						    	
						    }else {
						    	objCell = objRow.createCell(9);
							    objCell.setCellValue("-");
							    objCell.setCellStyle(styleHd);
						    }
						    
						    if(record_list.get(xx).getEvaluation_type_2() != null && record_list.get(xx).getEvaluation_type_2().length() > 2) {
						    	List<String> temp = gson.fromJson(record_list.get(xx).getEvaluation_type_2(), new TypeToken<List<String>>(){}.getType());
						    	String str = "";
						    	
						    	for(int xxx=0;xxx<temp.size();xxx++) {
						    		if(xxx != 0) {
						    			str += " / ";
						    		}
						    		str += "콘텐츠"+Integer.toString(xxx+1)+" 평가점수 : "+temp.get(xxx);
						    	}
						    	
						    	objCell = objRow.createCell(10);
							    objCell.setCellValue(str);
							    objCell.setCellStyle(styleHd);
						    	
						    	
						    }else {
						    	objCell = objRow.createCell(10);
							    objCell.setCellValue("-");
							    objCell.setCellStyle(styleHd);
						    }
						    
						    if(record_list.get(xx).getEvaluation_type_3() != null && record_list.get(xx).getEvaluation_type_3().length() > 2) {
						    	List<String> temp = gson.fromJson(record_list.get(xx).getEvaluation_type_2(), new TypeToken<List<String>>(){}.getType());
						    	String str = "";
						    	
						    	for(int xxx=0;xxx<temp.size();xxx++) {
						    		if(xxx != 0) {
						    			
						    			str += " / ";
						    		}
						    		str += "콘텐츠"+Integer.toString(xxx+1)+" 평가내용 : "+temp.get(xxx);
						    	}
						    	
						    	objCell = objRow.createCell(11);
							    objCell.setCellValue(str);
							    objCell.setCellStyle(styleHd);
						    	
						    }else {
						    	objCell = objRow.createCell(11);
							    objCell.setCellValue("-");
							    objCell.setCellStyle(styleHd);
						    }
						    
						    if(record_list.get(xx).getEvaluation_practice() != null) {
						    	List<List<HashMap>> ex_record = gson.fromJson(record_list.get(xx).getEvaluation_practice(), new TypeToken<List<List<HashMap>>>(){}.getType());
						    	
						    	String str_all = "";
						    	
						    	for(int xxx=0;xxx<ex_record.size();xxx++) {
						    		
						    		if(xxx != 0) {
						    			
						    			str_all += "\n";
						    		}
						    		
						    		str_all += "<평가수업 "+Integer.toString(xxx+1)+">\n";
						    		
						    		String str = "";
						    		
						    		for(int xxxx=0;xxxx<ex_record.get(xxx).size();xxxx++) {
						    			
						    			if(xxxx != 0) {
							    			
							    			str += " / ";
							    		}
						    			try {
						    				str += "콘텐츠 명 : " + ex_record.get(xxx).get(xxxx).get("content_detail_name");
							    			str += ", 운동 개수 : " + ex_record.get(xxx).get(xxxx).get("content_count")+"개";
							    			str += ", 운동 시간 : " + ex_record.get(xxx).get(xxxx).get("content_time")+"초";	
						    			}catch (Exception e) {
						    				str += "운동 기록 없음";
										}						    			
						    		}
						    		str_all += str;
						    	}
						    	
						    	objCell = objRow.createCell(12);
							    objCell.setCellValue(str_all);
							    objCell.setCellStyle(styleHd);
						    	
						    }else {
						    	objCell = objRow.createCell(12);
							    objCell.setCellValue("-");
							    objCell.setCellStyle(styleHd);
						    }
						    
						    if(record_list.get(xx).getClass_practice() != null) {
						    	List<List<HashMap>> ex_record = gson.fromJson(record_list.get(xx).getClass_practice(), new TypeToken<List<List<HashMap>>>(){}.getType());
						    	
						    	String str_all = "";
						    	
						    	for(int xxx=0;xxx<ex_record.size();xxx++) {
						    		
						    		if(xxx != 0) {
						    			
						    			str_all += "\n";
						    		}
						    		
						    		str_all += "<실습수업 "+Integer.toString(xxx+1)+">\n";
						    		
						    		String str = "";
						    		
						    		for(int xxxx=0;xxxx<ex_record.get(xxx).size();xxxx++) {
						    			
						    			if(xxxx != 0) {
							    			
							    			str += " / ";
							    		}
						    			
						    			try {
						    				str += "콘텐츠 명 : " + ex_record.get(xxx).get(xxxx).get("content_detail_name");
							    			str += ", 운동 개수 : " + ex_record.get(xxx).get(xxxx).get("content_count")+"개";
							    			str += ", 운동 시간 : " + ex_record.get(xxx).get(xxxx).get("content_time")+"초";	
						    			}catch (Exception e) {
						    				str += "운동 기록 없음";
										}
						    		}
						    		str_all += str;
						    	}
						    	
						    	objCell = objRow.createCell(13);
							    objCell.setCellValue(str_all);
							    objCell.setCellStyle(styleHd);
						    	
						    }else {
						    	objCell = objRow.createCell(13);
							    objCell.setCellValue("-");
							    objCell.setCellStyle(styleHd);
						    }
							
						}
						
					}else {
						record_count += 1;
					}
				}
			}
		}
		
		response.setContentType("Application/Msexcel");
	    response.setHeader("Content-Disposition", "ATTachment; Filename="+URLEncoder.encode("전체수업현황","UTF-8")+".xls");

	    OutputStream fileOut  = response.getOutputStream();
	    objWorkBook.write(fileOut);
	    fileOut.close();

	    response.getOutputStream().flush();
	    response.getOutputStream().close();
		
	}
	
	
	/* 전체 수업현황 처리 */
	@ResponseBody
	@RequestMapping(value = "/overall_class_status_work", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String overall_class_status_work(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				if(mode != null) {
					
					if(mode.equals("curriculum")) {
						
						String class_code = request.getParameter("class_code");
						String unit_code = request.getParameter("unit_code");
						
						if(class_code != null && unit_code != null) {
							Gson gson = new Gson();
							List<String> unit_code_list = gson.fromJson(unit_code, new TypeToken<List<String>>(){}.getType());
							
							List<List<Curriculum_Unit_List_Class_VO>> curriculum = new ArrayList<List<Curriculum_Unit_List_Class_VO>>();
							for(int x=0;x<unit_code_list.size();x++) {
								List<Curriculum_Unit_List_Class_VO> my_c = web_Teacher_Service.Get_My_Curriculum_Unit_List_Class_One(class_code, unit_code_list.get(x));
								curriculum.add(my_c);
							}
							
							return gson.toJson(curriculum);
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
	
	
	/* 학급별 게시판 리스트 */
	@RequestMapping(value = "/class_board_list", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String class_board_list(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				String class_grade = request.getParameter("class_grade");
				String class_group = request.getParameter("class_group");
				String class_semester = request.getParameter("class_semester");
				String option = request.getParameter("option");
				String keyword = request.getParameter("keyword");
				String page = request.getParameter("page");
				String sqlpage = null;
				String pageing_url = "/teacher/progress/class_board_list?ck=1";
				
				if(class_grade != null && class_grade.length()>0 && class_grade.length() < 2) {
					pageing_url += "&class_grade="+class_grade;
				}else {
					class_grade = null;
				}
				if(class_group == null) {
					class_group = null;
				}else {
					if(class_group.length() > 0 && class_group.length() < 3) {
						pageing_url += "&class_group="+class_group;
					}else {
						class_group = null;
					}	
				}
				
				if(class_semester == null) {
					class_semester = null;
				}else {
					if(class_semester.length()>0 && class_semester.length() < 2) {
						pageing_url += "&class_semester="+class_semester;
					}else {
						class_semester = null;
					}	
				}
				
				if(option != null) {
					if(option.equals("이름") || option.equals("아이디") || option.equals("제목")) {
						option += "&option="+option;
					}else {
						option = null;
					}
				}
				

				if(keyword != null && keyword.length()>1) {
					pageing_url += "&keyword="+keyword;
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
				
				List<String> teacher_classcode_temp = (List<String>)session.getAttribute("teacher_classcode");
				if(teacher_classcode_temp == null || teacher_classcode_temp.size() == 0) {
					teacher_classcode_temp = new ArrayList<String>();
				}
				List<String> teacher_classcode = new ArrayList<String>();
				for(int x=0;x < teacher_classcode_temp.size();x++) {
					
					String c_grade = teacher_classcode_temp.get(x).split("_")[1].substring(0, 1);
					String c_group = teacher_classcode_temp.get(x).split("_")[1].substring(1, 3);
					String c_semester = teacher_classcode_temp.get(x).split("_")[1].substring(3, 4);
					boolean isOk = true;
					if(class_grade != null) {
						if(!class_grade.equals(c_grade)) {
							isOk = false;
						}
					}
					if(class_group != null) {
						if(c_group.substring(0, 1).equals("0")) {
							c_group = c_group.substring(1, 2);
						}
						if(!class_group.equals(c_group)) {
							isOk = false;
						}
					}
					if(class_semester != null) {
						if(!class_semester.equals(c_semester)) {
							isOk = false;
						}
					}
					if(isOk) {
						teacher_classcode.add(teacher_classcode_temp.get(x));
					}
					
					
				}
				
				if(teacher_classcode.size() > 0) {
					List<Class_Community_VO> community_list = web_Teacher_Service.Get_Class_Community_List(teacher_classcode, option, keyword, sqlpage);
					for(int x=0;x<community_list.size();x++) {
						community_list.get(x).setCommunity_class_code(community_list.get(x).getCommunity_class_code().split("_")[1]);
					}
					
					String community_count = web_Teacher_Service.Get_Class_Community_List_Count(teacher_classcode, option, keyword);
					
					if(community_count == null) {
						community_count = "0";
					}
					int count_int = Integer.parseInt(community_count) / 15;
					int count_result = Integer.parseInt(community_count) % 15;
					if(count_result > 0) {
						count_int++;
					}
					
					model.addAttribute("community_count", community_count);
					model.addAttribute("community_list", community_list);
					model.addAttribute("page",page);
					model.addAttribute("last_page",Integer.toString(count_int));
					model.addAttribute("pageing_start",Integer.toString(pageing_start));
					if(count_int < pageing_start + 4) {
						model.addAttribute("pageing_last",Integer.toString(count_int));
					}else {
						model.addAttribute("pageing_last",Integer.toString(pageing_start + 4));
					}
				}else {
					model.addAttribute("community_count", 0);
					model.addAttribute("community_list", null);
					model.addAttribute("page",page);
					model.addAttribute("last_page",0);
					model.addAttribute("pageing_start",1);
					model.addAttribute("pageing_last",0);
				}
				
				model.addAttribute("pageing_url",pageing_url);
				model.addAttribute("class_grade", class_grade);
				model.addAttribute("class_group", class_group);
				model.addAttribute("class_semester", class_semester);
				model.addAttribute("option", option);
				model.addAttribute("keyword", keyword);
				return "/teacher/progress/class_board_list";
				
			}
		}
	}
	
	
	
	/* 학급별 게시판 리스트 */
	@RequestMapping(value = "/class_board_detail", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String class_board_detail(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				String mode = request.getParameter("mode");
				if(mode != null) {
					model.addAttribute("mode", mode);
					if(mode.equals("detail")) {
						
						String community_number = request.getParameter("community_number");
						
						if(community_number != null) {
							
							Class_Community_VO community = web_Teacher_Service.Get_Class_Community_One(community_number);
							
							List<Class_Community_Comment_VO> comment = web_Teacher_Service.Get_Class_Community_Comment_List(community_number);
							
							if(community != null) {
								
								model.addAttribute("community", community);
								if(comment.size() == 0) {
									model.addAttribute("comment", null);	
								}else {
									model.addAttribute("comment", comment);
								}
								model.addAttribute("teacher_id", sessionUid);
								
								return "/teacher/progress/class_board_detail";
								
							}else{
								return "redirect:/teacher/progress/class_board_list";
							}
							
						}else {
							return "redirect:/teacher/progress/class_board_list";
						}
						
					}else if(mode.equals("modify")) {
						
						String community_number = request.getParameter("community_number");
						
						
						if(community_number != null) {
							
							Class_Community_VO community = web_Teacher_Service.Get_My_Class_Community_One(community_number, sessionUid);
							
							if(community != null) {
								
								List<String> teacher_classcode_temp = (List<String>)session.getAttribute("teacher_classcode");
								List<String> code_list = new ArrayList<String>();
								for(int x=0;x < teacher_classcode_temp.size();x++) {
									String c_grade = teacher_classcode_temp.get(x).split("_")[1].substring(0, 4);
									code_list.add(c_grade);
								}
								String target_code = community.getCommunity_class_code().split("_")[1].substring(0, 4);
								
								model.addAttribute("teacher_classcode", teacher_classcode_temp);
								model.addAttribute("community", community);
								model.addAttribute("code_list", code_list);
								model.addAttribute("target_code", target_code);
								
								
								return "/teacher/progress/class_board_detail";	
								
							}else{
								return "redirect:/teacher/progress/class_board_list";
							}
							
						}else {
							return "redirect:/teacher/progress/class_board_list";
						}
						
					}else if(mode.equals("create")) {
						
						List<String> teacher_classcode_temp = (List<String>)session.getAttribute("teacher_classcode");
						if(teacher_classcode_temp == null) {
							model.addAttribute("state","none");
							return "/teacher/progress/class_board_detail";
						}else {
							List<String> code_list = new ArrayList<String>();
							for(int x=0;x < teacher_classcode_temp.size();x++) {
								String c_grade = teacher_classcode_temp.get(x).split("_")[1].substring(0, 4);
								code_list.add(c_grade);
							}
							model.addAttribute("teacher_classcode", teacher_classcode_temp);
							model.addAttribute("code_list", code_list);
							model.addAttribute("state","ok");
							return "/teacher/progress/class_board_detail";
						}
					}else {
						return "redirect:/teacher/progress/class_board_list";
					}
					
				}else {
					return "redirect:/teacher/progress/class_board_list";
				}
			}
		}
	}
	
	
	
	
	
	/* 커뮤니티 처리 */
	@ResponseBody
	@RequestMapping(value = "/class_board_detail_work", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String class_board_detail_work(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
				format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date time = new Date();
				String time_number = format.format(time);
				
				String mode = request.getParameter("mode");
				String target = request.getParameter("target");
				
				if(mode != null && target != null) {
					
					if(target.equals("community")) {
						
						if(mode.equals("create")) {
							
							//게시글 등록(제목, 내용, target 게시판(클래스코드), id, name, date, count(댓글수))
							String community_class_code = request.getParameter("community_class_code");
							String community_id = sessionUid;
							String community_name = (String)session.getAttribute("teacher_name");
							String community_title = request.getParameter("community_title");
							String community_text = request.getParameter("community_text");
							String community_date = time_number;
							
							if(community_class_code != null && community_title != null && community_text != null) {
								
								if(community_title.length() > 2 && community_text.length() > 2 && community_title.length() < 51) {
									
									if(web_Teacher_Service.Create_Class_Community(community_class_code, community_id, community_name, community_title, community_text, community_date)) {
										return "success";
									}else {
										System.out.println("1112");
										return "fail";
									}
									
								}else {
									System.out.println("1112222222");
									return "fail";
								}
								
							}else {
								System.out.println("111");
								return "fail";
							}
							
						}else if(mode.equals("modify")) {
							
							//게시글 제목, 내용, target 게시판 수정 ( WHERE community_id, community_class_code, community_number )
							String community_class_code = request.getParameter("community_class_code");
							String community_number = request.getParameter("community_number");
							String community_id = sessionUid;
							String community_title = request.getParameter("community_title");
							String community_text = request.getParameter("community_text");
							
							if(community_class_code != null && community_title != null && community_text != null && community_number != null) {
								
								if(community_title.length() > 2 && community_text.length() > 2 && community_title.length() < 51) {
									
									if(web_Teacher_Service.Update_Class_Community(community_class_code, community_title, community_text, community_number, community_id)) {
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
							
							//게시글, 코멘트 삭제 ( WHERE community_id, community_class_code, community_number )
							String community_number = request.getParameter("community_number");
							String community_id = sessionUid;
							
							if(community_number != null) {
								
								if(web_Teacher_Service.Delete_Class_Community(community_number, community_id)) {
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
						
					}else if(target.equals("comment")){
						
						if(mode.equals("create")) {
							
							String comment_community_number = request.getParameter("comment_community_number");
							String comment_id = sessionUid;
							String comment_name = (String)session.getAttribute("teacher_name");
							String comment_content = request.getParameter("comment_content");
							String comment_date = time_number;
							
							if(comment_community_number != null && comment_content != null) {
								
								if(comment_content.length() > 2 && comment_content.length() < 501) {
									
									if(web_Teacher_Service.Create_Class_Community_Comment(comment_community_number, comment_id, comment_name, comment_content, comment_date)) {
										web_Teacher_Service.Update_Class_Community_Count_Up(comment_community_number);
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
							
							String comment_number = request.getParameter("comment_number");
							String comment_community_number = request.getParameter("comment_community_number");
							String comment_id = sessionUid;
							
							if(comment_number != null && comment_community_number != null) {
								
								if(web_Teacher_Service.Delete_Class_Community_Comment(comment_number, comment_id)) {
									web_Teacher_Service.Update_Class_Community_Count_Down(comment_community_number);
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
					
				}else {
					return "fail";
				}
				
			}
		}
	}
	
	
	
	/* 수업 마감 관리 */
	@RequestMapping(value = "/class_deadline_management", method = RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String class_deadline_management(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				
				SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMdd");
				format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date time = new Date();
				String today = format.format(time);
				
				String class_grade = request.getParameter("class_grade");
				String class_group = request.getParameter("class_group");
				String class_semester = request.getParameter("class_semester");
				String keyword = request.getParameter("keyword");
				String page = request.getParameter("page");
				String sqlpage = null;
				String pageing_url = "/teacher/progress/class_deadline_management?ck=1";
				
				if(class_grade != null && class_grade.length()>0 && class_grade.length() < 2) {
					pageing_url += "&class_grade="+class_grade;
				}else {
					class_grade = null;
				}
				if(class_group == null) {
					class_group = null;
				}else {
					if(class_group.length() > 0 && class_group.length() < 3) {
						pageing_url += "&class_group="+class_group;
					}else {
						class_group = null;
					}	
				}
				
				if(class_semester == null) {
					class_semester = null;
				}else {
					if(class_semester.length()>0 && class_semester.length() < 2) {
						pageing_url += "&class_semester="+class_semester;
					}else {
						class_semester = null;
					}	
				}
				

				if(keyword != null && keyword.length()>1) {
					pageing_url += "&keyword="+keyword;
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

				List<Class_List_VO> class_list = web_Teacher_Service.Get_My_Class_List_For_DeadLine(sessionUid, class_grade, class_group, class_semester, keyword, sqlpage, today);
				
				String class_count = web_Teacher_Service.Get_My_Class_List_Count_For_DeadLine(sessionUid, class_grade, class_group, class_semester, keyword, today);
				
				if(class_count == null) {
					class_count = "0";
				}
				int count_int = Integer.parseInt(class_count) / 15;
				int count_result = Integer.parseInt(class_count) % 15;
				if(count_result > 0) {
					count_int++;
				}
				
				model.addAttribute("class_list", class_list);
				model.addAttribute("page",page);
				model.addAttribute("last_page",Integer.toString(count_int));
				model.addAttribute("pageing_start",Integer.toString(pageing_start));
				if(count_int < pageing_start + 4) {
					model.addAttribute("pageing_last",Integer.toString(count_int));
				}else {
					model.addAttribute("pageing_last",Integer.toString(pageing_start + 4));
				}
				
				model.addAttribute("pageing_url",pageing_url);
				model.addAttribute("class_grade", class_grade);
				model.addAttribute("class_group", class_group);
				model.addAttribute("class_semester", class_semester);
				model.addAttribute("keyword", keyword);
				model.addAttribute("teacher_name", (String)session.getAttribute("teacher_name"));
				
				
				
				return "/teacher/progress/class_deadline_management";
			}
		}
	}
	
	
	
	/* 수업 마감처리 */
	@ResponseBody
	@RequestMapping(value = "/class_deadline_management_work", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String class_deadline_management_work(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
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
				if(class_code != null) {
					
					if(web_Teacher_Service.DeadLine_Work(sessionUid, class_code)) {
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

