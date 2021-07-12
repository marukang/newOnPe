<!-- 차시별 수업 설정 페이지 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="date" value="<%=new java.util.Date()%>" />
<c:set var="nowDate"><fmt:formatDate value="${date}" pattern="yyyyMMdd" /></c:set>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no, target-densitydpi=medium-dpi">

		<title>온체육</title>
		<link rel="preconnect" href="https://fonts.gstatic.com">
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
		<link rel="stylesheet" type="text/css" href="/asset/css/jquery-ui.css">
		<link rel="stylesheet" type="text/css" href="/asset/css/swiper-bundle.css">
		<link rel="stylesheet" type="text/css" href="/asset/css/style.css" />
		
		
		<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
		<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
		<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
		<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
		
		<script src="https://cdn.jsdelivr.net/npm/jquery-sortablejs@latest/jquery-sortable.js"></script>


		<script src="/asset/lib/jquery-1.11.3.min.js"></script>
		<script src="/asset/lib/jquery-ui.js"></script>
		<script src="/asset/lib/swiper-bundle.min.js"></script>
		<script src="/asset/js/script.js"></script>
		<base href="/" />
		<style>
			.class_project_submit_type_parent{ margin-bottom:5px; }
			.class_project_submit_type_value{ margin-left:5px; }
			.hidden_box{ display:none; }
			.auto_make_curriculum_popup_td_title{ cursor:pointer; text-decoration: underline; color:var(--pri-blue); }
			.curriculum_detail_popup_content{ margin-bottom:5px; }
			.curriculum_detail_popup_content_youtube{ margin-bottom:5px; }
			.curriculum_detail_popup_content_etc{ margin-bottom:5px; }
			#curriculum_detail_popup_files_box{ float:left; width:100%; }
			.bottom_save_btn{ margin-bottom:30px; }
			.curriculum_detail_content_list{ margin-bottom:12px; font-size:14px; }
			.curriculum_detail_content{ margin-bottom:3px; }
		</style>
	</head>
	<body>

	<div class="fixed-area desktop">
		<div class="header flex justify-space">
			<h1 class="logo"><a href="/"><img src="/asset/images/logo.png" alt="" /></a></h1>
			<div class="top-menu flex items-center">
				<div><a href="/">홈</a></div>
				<div><a href="/logout">로그아웃</a></div>
				<div><a href="/mypage">마이 페이지</a></div>
			</div>
		</div>
	</div>

	<div class="fixed-area mobile">
		<div class="header">
			<h1 class="logo"><a href="/">온체육</a></h1>
			<div class="top-menu">
				
				<div class="icon-menu"><img src="/asset/images/icon/icon-menu.svg" alt="" /></div>
			</div>
		</div>
	</div>

	<div class="drawer">
		<div class="drawer-inner">
			<div class="icon-close">
				<img src="/asset/images/icon/icon-close-pop.svg" alt="" />
			</div>
			<div class="drawer-gnb">
				<ul class="depth1">
					<li><span class="slide-tab">수업 준비</span>
						<ul class="depth2">
							<li><a href="/teacher/ready/create_link">초대 링크 생성</a></li>
							<li class="active"><a href="/teacher/ready/class_configuration_management_list">수업 생성/관리</a></li>
						</ul>
					</li>
					<li><span class="slide-tab">수업 진행</span>
						<ul class="depth2">
							<li><a href="/teacher/progress/class_progress_management">실시간 수업 진행</a></li>
							<li><a href="/teacher/progress/class_board_list">학급별 게시판</a></li>
						</ul>
					</li>
					<li><span class="slide-tab">기타 메뉴</span>
						<ul class="depth2">
							<li><a href="/teacher/progress/overall_class_status">전체 수업 현황</a></li>
							<li><a href="/teacher/ready/student_management">학생 관리</a></li>
							<li><a href="/teacher/progress/class_deadline_management">수업 마감 관리</a></li>
							<!-- <li><a href="#">체육 기록부(수업별)</a></li>
							<li><a href="#">체육 기록부(학생별)</a></li> -->
						</ul>
					</li>
					<!-- <li><span class="slide-tab">교사 커뮤니티</span>
						<ul class="depth2">
							<li><a href="#">추천 학습 자료</a></li>
							<li><a href="#">종목별 백서</a></li>
						</ul>
					</li> -->
					<li><span class="slide-tab">서비스</span>
						<ul class="depth2">
							<li><a href="/teacher/service/notice_list">공지사항</a></li>
							<li><a href="/teacher/service/faq_list">FAQ</a></li>
							<li><a href="/teacher/service/qna_list">1:1 문의</a></li>
						</ul>
					</li>
				</ul>
			</div>
		</div>
	</div>

	<div class="wrap">

		<div class="lnb">
			<ul class="depth1">
				<li class="active"><span class="badge danger">수업 준비</span>
					<ul class="depth2">
						<li><a href="/teacher/ready/create_link">초대 링크 생성</a></li>
						<li class="active"><a href="/teacher/ready/class_configuration_management_list">수업 생성/관리</a></li>
					</ul>
				</li>
				<li class="active"><span class="badge warning">수업 진행</span>
					<ul class="depth2">
						<li><a href="/teacher/progress/class_progress_management">실시간 수업 진행</a></li>
						<li><a href="/teacher/progress/class_board_list">학급별 게시판</a></li>
					</ul>
				</li>
				<li class="active"><span class="badge success">기타 메뉴</span>
					<ul class="depth2">
						<li><a href="/teacher/progress/overall_class_status">전체 수업 현황</a></li>
						<li><a href="/teacher/ready/student_management">학생 관리</a></li>
						<li><a href="/teacher/progress/class_deadline_management">수업 마감 관리</a></li>
						<!-- <li><a href="#">체육 기록부(수업별)</a></li>
						<li><a href="#">체육 기록부(학생별)</a></li> -->
					</ul>
				</li>
				<!-- <li class="active"><span class="slide-tab">교사 커뮤니티</span>
					<ul class="depth2">
						<li><a href="#">추천 학습 자료</a></li>
						<li><a href="#">종목별 백서</a></li>
					</ul>
				</li> -->
				<li class="active"><span class="slide-tab">서비스</span>
					<ul class="depth2">
						<li><a href="/teacher/service/notice_list">공지사항</a></li>
						<li><a href="/teacher/service/faq_list">FAQ</a></li>
						<li><a href="/teacher/service/qna_list">1:1 문의</a></li>
					</ul>
				</li>
			</ul>
		</div>		

		<div class="content">
		
			<div class="wrapper">
				<h2 class="sub-title">차시별 수업 설정</h2>
				
				<div class="box-wrap">
					<div class="box-content">
						<div class="field">
							<div class="field-inner">
								<label>수업명(차시별)</label>
								<input id="unit_class_name" type="text" class="w49" placeholder="제목을 입력하세요." autocomplete="off">
								<label class="radio-wrap"><input id="curriculum_detail_radio0" class="curriculum_detail_radio" value="0" type="radio" name="class-type" checked/><span class="custom-radio">전체형 수업</span></label>
								<label class="radio-wrap"><input id="curriculum_detail_radio1" class="curriculum_detail_radio" value="1" type="radio" name="class-type" /><span class="custom-radio">맞춤형 수업</span></label>
							</div>
		
						</div>
						<div class="field w100">
							<label>수업 일시</label>
							<div class="date-range">
								<div>
									<input type="text" id="from" name="from" autocomplete="off">
									<select id="from_hour" class="time-selection">
										<option>시</option>
										<c:forTokens var="item" items="01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24" delims=",">
											<option>${item}</option>
										</c:forTokens>
									</select>
									<select id="from_min" class="time-selection2">
										<option>분</option>
										<c:forTokens var="item" items="01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59" delims=",">
											<option>${item}</option>
										</c:forTokens>
									</select>
								</div>
								<span class="date-range">~</span>
								<div>
									<input type="text" id="to" name="to" autocomplete="off">
									<select id="to_hour" class="time-selection">
										<option>시</option>
										<c:forTokens var="item" items="01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24" delims=",">
											<option>${item}</option>
										</c:forTokens>
									</select>
									<select id="to_min" class="time-selection2">
										<option>분</option>
										<c:forTokens var="item" items="01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59" delims=",">
											<option>${item}</option>
										</c:forTokens>
									</select>
								</div>
							</div>
						</div>
						<div id="group_content_box" class="field hidden_box">
							<label>그룹 선택</label>
							<div class="field-inner flex">
								<select id="unit_group_name" class="w32">
									<option class="unit_group_name_option" selected unit_group_name="1그룹">1그룹</option>
									<option class="unit_group_name_option" unit_group_name="2그룹">2그룹</option>
								</select>
								<button id="unit_group_setting_btn" class="btn-s-round-l active">그룹 설정</button>
							</div>
						</div>
						<div class="field w100">
							<label>수업 구성</label>
							<div id="curriculum_detail_popup_content1" class="field-inner add-row curriculum_detail_popup_content">
								<select id="curriculum_detail_popup_content_name1" class="w24 curriculum_detail_popup_content_name">
									<option>이론수업</option>
									<option>실습수업</option>
									<option>평가수업</option>
								</select>
								<select id="curriculum_detail_popup_content_test1" class="w24 curriculum_detail_popup_content_test hidden_box">
									<option>평가방식</option>
									<option>상/중/하 평가</option>
									<option>점수 평가</option>
									<option>텍스트 평가</option>
								</select>
								<button id="curriculum_detail_popup_content_set_btn1" class="btn-s-round-l active mb10 curriculum_detail_popup_content_set_btn hidden_box">콘텐츠 선택</button>
								<select id="curriculum_detail_popup_content_type1" class="w24 curriculum_detail_popup_content_type">
									<option>안전</option>
									<option>표현</option>
									<option>도전</option>
									<option>건강</option>
									<option>경쟁</option>
								</select>
								<button id="curriculum_detail_popup_content_add1" class="btn-round btn-add btn-add-row">+</button>
							</div>
							<div class="field-inner curriculum_detail_content_list hidden_box">
							</div>
							<div id="curriculum_detail_popup_content2" class="field-inner add-row curriculum_detail_popup_content hidden_box">
								<select id="curriculum_detail_popup_content_name2" class="w24 curriculum_detail_popup_content_name">
									<option>이론수업</option>
									<option>실습수업</option>
									<option>평가수업</option>
								</select>
								<select id="curriculum_detail_popup_content_test2" class="w24 curriculum_detail_popup_content_test hidden_box">
									<option>평가방식</option>
									<option>상/중/하 평가</option>
									<option>점수 평가</option>
									<option>텍스트 평가</option>
								</select>
								<button id="curriculum_detail_popup_content_set_btn2" class="btn-s-round-l active mb10 curriculum_detail_popup_content_set_btn hidden_box">콘텐츠 선택</button>
								<select id="curriculum_detail_popup_content_type2" class="w24 curriculum_detail_popup_content_type">
									<option>안전</option>
									<option>표현</option>
									<option>도전</option>
									<option>건강</option>
									<option>경쟁</option>
								</select>
								<button id="curriculum_detail_popup_content_add2" class="btn-round btn-add btn-add-row">+</button>
								<button id="curriculum_detail_popup_content_remove2" class="btn-round btn-remove btn-remove-row">-</button>
							</div>
							<div class="field-inner curriculum_detail_content_list hidden_box">
							</div>
							<div id="curriculum_detail_popup_content3" class="field-inner add-row curriculum_detail_popup_content hidden_box">
								<select id="curriculum_detail_popup_content_name3" class="w24 curriculum_detail_popup_content_name">
									<option>이론수업</option>
									<option>실습수업</option>
									<option>평가수업</option>
								</select>
								<select id="curriculum_detail_popup_content_test3" class="w24 curriculum_detail_popup_content_test hidden_box">
									<option>평가방식</option>
									<option>상/중/하 평가</option>
									<option>점수 평가</option>
									<option>텍스트 평가</option>
								</select>
								<button id="curriculum_detail_popup_content_set_btn3" class="btn-s-round-l active mb10 curriculum_detail_popup_content_set_btn hidden_box">콘텐츠 선택</button>
								<select id="curriculum_detail_popup_content_type3" class="w24 curriculum_detail_popup_content_type">
									<option>안전</option>
									<option>표현</option>
									<option>도전</option>
									<option>건강</option>
									<option>경쟁</option>
								</select>
								<button id="curriculum_detail_popup_content_add3" class="btn-round btn-add btn-add-row">+</button>
								<button id="curriculum_detail_popup_content_remove3" class="btn-round btn-remove btn-remove-row">-</button>
							</div>
							<div class="field-inner curriculum_detail_content_list hidden_box">
								
							</div>
							<div id="curriculum_detail_popup_content4" class="field-inner add-row curriculum_detail_popup_content hidden_box">
								<select id="curriculum_detail_popup_content_name4" class="w24 curriculum_detail_popup_content_name">
									<option>이론수업</option>
									<option>실습수업</option>
									<option>평가수업</option>
								</select>
								<select id="curriculum_detail_popup_content_test4" class="w24 curriculum_detail_popup_content_test hidden_box">
									<option>평가방식</option>
									<option>상/중/하 평가</option>
									<option>점수 평가</option>
									<option>텍스트 평가</option>
								</select>
								<button id="curriculum_detail_popup_content_set_btn4" class="btn-s-round-l active mb10 curriculum_detail_popup_content_set_btn hidden_box">콘텐츠 선택</button>
								<select id="curriculum_detail_popup_content_type4" class="w24 curriculum_detail_popup_content_type">
									<option>안전</option>
									<option>표현</option>
									<option>도전</option>
									<option>건강</option>
									<option>경쟁</option>
								</select>
								<button id="curriculum_detail_popup_content_add4" class="btn-round btn-add btn-add-row">+</button>
								<button id="curriculum_detail_popup_content_remove4" class="btn-round btn-remove btn-remove-row">-</button>
							</div>
							<div class="field-inner curriculum_detail_content_list hidden_box">
								
							</div>
							<div id="curriculum_detail_popup_content5" class="field-inner add-row curriculum_detail_popup_content hidden_box">
								<select id="curriculum_detail_popup_content_name5" class="w24 curriculum_detail_popup_content_name">
									<option>이론수업</option>
									<option>실습수업</option>
									<option>평가수업</option>
								</select>
								<select id="curriculum_detail_popup_content_test5" class="w24 curriculum_detail_popup_content_test hidden_box">
									<option>평가방식</option>
									<option>상/중/하 평가</option>
									<option>점수 평가</option>
									<option>텍스트 평가</option>
								</select>
								<button id="curriculum_detail_popup_content_set_btn5" class="btn-s-round-l active mb10 curriculum_detail_popup_content_set_btn hidden_box">콘텐츠 선택</button>
								<select id="curriculum_detail_popup_content_type5" class="w24 curriculum_detail_popup_content_type">
									<option>안전</option>
									<option>표현</option>
									<option>도전</option>
									<option>건강</option>
									<option>경쟁</option>
								</select>
								<button id="curriculum_detail_popup_content_remove5" class="btn-round btn-remove btn-remove-row">-</button>
							</div>
							<div class="field-inner curriculum_detail_content_list hidden_box">
								
							</div>
						</div>
						
						<div class="field">
							<label>유튜브 영상</label>
							<div id="curriculum_detail_popup_youtube1" class="field-inner curriculum_detail_popup_content_youtube">
								<input type="text" id="curriculum_detail_popup_youtube_name1" class="w32 curriculum_detail_popup_youtube_name" autocomplete="off" placeholder="제목 입력">
								<input type="text" id="curriculum_detail_popup_youtube_link1" class="w32 curriculum_detail_popup_youtube_link" autocomplete="off" placeholder="링크 입력">
								<button id="curriculum_detail_popup_youtube_add1" class="btn-round btn-add">+</button>
							</div>
							<div id="curriculum_detail_popup_youtube2" class="field-inner curriculum_detail_popup_content_youtube hidden_box">
								<input type="text" id="curriculum_detail_popup_youtube_name2" class="w32 curriculum_detail_popup_youtube_name" autocomplete="off" placeholder="제목 입력">
								<input type="text" id="curriculum_detail_popup_youtube_link2" class="w32 curriculum_detail_popup_youtube_link" autocomplete="off" placeholder="링크 입력">
								<button id="curriculum_detail_popup_youtube_add2" class="btn-round btn-add">+</button>
								<button id="curriculum_detail_popup_youtube_remove2" class="btn-round btn-remove">-</button>
							</div>
							<div id="curriculum_detail_popup_youtube3" class="field-inner curriculum_detail_popup_content_youtube hidden_box">
								<input type="text" id="curriculum_detail_popup_youtube_name3" class="w32 curriculum_detail_popup_youtube_name" autocomplete="off" placeholder="제목 입력">
								<input type="text" id="curriculum_detail_popup_youtube_link3" class="w32 curriculum_detail_popup_youtube_link" autocomplete="off" placeholder="링크 입력">
								<button id="curriculum_detail_popup_youtube_add3" class="btn-round btn-add">+</button>
								<button id="curriculum_detail_popup_youtube_remove3" class="btn-round btn-remove">-</button>
							</div>
							<div id="curriculum_detail_popup_youtube4" class="field-inner curriculum_detail_popup_content_youtube hidden_box">
								<input type="text" id="curriculum_detail_popup_youtube_name4" class="w32 curriculum_detail_popup_youtube_name" autocomplete="off" placeholder="제목 입력">
								<input type="text" id="curriculum_detail_popup_youtube_link4" class="w32 curriculum_detail_popup_youtube_link" autocomplete="off" placeholder="링크 입력">
								<button id="curriculum_detail_popup_youtube_add4" class="btn-round btn-add">+</button>
								<button id="curriculum_detail_popup_youtube_remove4" class="btn-round btn-remove">-</button>
							</div>
							<div id="curriculum_detail_popup_youtube5" class="field-inner curriculum_detail_popup_content_youtube hidden_box">
								<input type="text" id="curriculum_detail_popup_youtube_name5" class="w32 curriculum_detail_popup_youtube_name" autocomplete="off" placeholder="제목 입력">
								<input type="text" id="curriculum_detail_popup_youtube_link5" class="w32 curriculum_detail_popup_youtube_link" autocomplete="off" placeholder="링크 입력">
								<button id="curriculum_detail_popup_youtube_add5" class="btn-round btn-add">+</button>
								<button id="curriculum_detail_popup_youtube_remove5" class="btn-round btn-remove">-</button>
							</div>
							<div id="curriculum_detail_popup_youtube6" class="field-inner curriculum_detail_popup_content_youtube hidden_box">
								<input type="text" id="curriculum_detail_popup_youtube_name6" class="w32 curriculum_detail_popup_youtube_name" autocomplete="off" placeholder="제목 입력">
								<input type="text" id="curriculum_detail_popup_youtube_link6" class="w32 curriculum_detail_popup_youtube_link" autocomplete="off" placeholder="링크 입력">
								<button id="curriculum_detail_popup_youtube_add6" class="btn-round btn-add">+</button>
								<button id="curriculum_detail_popup_youtube_remove6" class="btn-round btn-remove">-</button>
							</div>
							<div id="curriculum_detail_popup_youtube7" class="field-inner curriculum_detail_popup_content_youtube hidden_box">
								<input type="text" id="curriculum_detail_popup_youtube_name7" class="w32 curriculum_detail_popup_youtube_name" autocomplete="off" placeholder="제목 입력">
								<input type="text" id="curriculum_detail_popup_youtube_link7" class="w32 curriculum_detail_popup_youtube_link" autocomplete="off" placeholder="링크 입력">
								<button id="curriculum_detail_popup_youtube_remove7" class="btn-round btn-remove">-</button>
							</div>
						</div>
						<div class="field">
							<label>수업 관련 링크</label>
							<div id="curriculum_detail_popup_etc1" class="field-inner curriculum_detail_popup_content_etc">
								<input id="curriculum_detail_popup_etc_name1" type="text" class="w32 curriculum_detail_popup_etc_name" placeholder="제목 입력" autocomplete="off">
								<input id="curriculum_detail_popup_etc_link1" type="text" class="w32 curriculum_detail_popup_etc_link" placeholder="링크 입력" autocomplete="off">
								<button id="curriculum_detail_popup_etc_add1" class="btn-round btn-add">+</button>
							</div>
							<div id="curriculum_detail_popup_etc2" class="field-inner curriculum_detail_popup_content_etc hidden_box">
								<input id="curriculum_detail_popup_etc_name2" type="text" class="w32 curriculum_detail_popup_etc_name" placeholder="제목 입력" autocomplete="off">
								<input id="curriculum_detail_popup_etc_link2" type="text" class="w32 curriculum_detail_popup_etc_link" placeholder="링크 입력" autocomplete="off">
								<button id="curriculum_detail_popup_etc_add2" class="btn-round btn-add">+</button>
								<button id="curriculum_detail_popup_etc_remove2" class="btn-round btn-remove">-</button>
							</div>
							<div id="curriculum_detail_popup_etc3" class="field-inner curriculum_detail_popup_content_etc hidden_box">
								<input id="curriculum_detail_popup_etc_name3" type="text" class="w32 curriculum_detail_popup_etc_name" placeholder="제목 입력" autocomplete="off">
								<input id="curriculum_detail_popup_etc_link3" type="text" class="w32 curriculum_detail_popup_etc_link" placeholder="링크 입력" autocomplete="off">
								<button id="curriculum_detail_popup_etc_add3" class="btn-round btn-add">+</button>
								<button id="curriculum_detail_popup_etc_remove3" class="btn-round btn-remove">-</button>
							</div>
							<div id="curriculum_detail_popup_etc4" class="field-inner curriculum_detail_popup_content_etc hidden_box">
								<input id="curriculum_detail_popup_etc_name4" type="text" class="w32 curriculum_detail_popup_etc_name" placeholder="제목 입력" autocomplete="off">
								<input id="curriculum_detail_popup_etc_link4" type="text" class="w32 curriculum_detail_popup_etc_link" placeholder="링크 입력" autocomplete="off">
								<button id="curriculum_detail_popup_etc_add4" class="btn-round btn-add">+</button>
								<button id="curriculum_detail_popup_etc_remove4" class="btn-round btn-remove">-</button>
							</div>
							<div id="curriculum_detail_popup_etc5" class="field-inner curriculum_detail_popup_content_etc hidden_box">
								<input id="curriculum_detail_popup_etc_name5" type="text" class="w32 curriculum_detail_popup_etc_name" placeholder="제목 입력" autocomplete="off">
								<input id="curriculum_detail_popup_etc_link5" type="text" class="w32 curriculum_detail_popup_etc_link" placeholder="링크 입력" autocomplete="off">
								<button id="curriculum_detail_popup_etc_add5" class="btn-round btn-add">+</button>
								<button id="curriculum_detail_popup_etc_remove5" class="btn-round btn-remove">-</button>
							</div>
							<div id="curriculum_detail_popup_etc6" class="field-inner curriculum_detail_popup_content_etc hidden_box">
								<input id="curriculum_detail_popup_etc_name6" type="text" class="w32 curriculum_detail_popup_etc_name" placeholder="제목 입력" autocomplete="off">
								<input id="curriculum_detail_popup_etc_link6" type="text" class="w32 curriculum_detail_popup_etc_link" placeholder="링크 입력" autocomplete="off">
								<button id="curriculum_detail_popup_etc_add6" class="btn-round btn-add">+</button>
								<button id="curriculum_detail_popup_etc_remove6" class="btn-round btn-remove">-</button>
							</div>
							<div id="curriculum_detail_popup_etc7" class="field-inner curriculum_detail_popup_content_etc hidden_box">
								<input id="curriculum_detail_popup_etc_name7" type="text" class="w32 curriculum_detail_popup_etc_name" placeholder="제목 입력" autocomplete="off">
								<input id="curriculum_detail_popup_etc_link7" type="text" class="w32 curriculum_detail_popup_etc_link" placeholder="링크 입력" autocomplete="off">
								<button id="curriculum_detail_popup_etc_remove7" class="btn-round btn-remove">-</button>
							</div>
						</div>
		
						<div class="field">
							<label>참고자료</label>
							<div class="field-inner">
								<ul id="curriculum_detail_popup_files_box" class="uploaded-list">

								</ul>
								<label id="curriculum_detail_popup_file_tag_box" class="btn-upload">
									<input id="curriculum_detail_popup_files" type="file" name="curriculum_file[]" multiple="multiple" />
									등록하기
								</label>
								<p class="txt-notice">최대 5개, 용량제한 : 30M / pdf, jpg, jpeg, png 허용</p>
							</div>
						</div>
						
						<label>수업 소개글</label>
						<textarea id="curriculum_detail_popup_unit_class_text" placeholder="수업 내용을 입력하세요"></textarea>
					</div>
					<div class="btn-wrap bottom_save_btn">
						<button id="curriculum_detail_popup_save_btn" class="btn-pt">저장하기</button>
						<button id="go_back_btn" class="btn-sec">뒤로가기</button>
					</div>
				</div>
			</div>

			<div class="footer">
				<p>copyright 컴플렉시온 ⓒ All rights reserved.</p>
			</div>
			
		</div>
		
		
		<div id="exercise_combination_popup" class="popup" style="display:none;">
			<div class="popup-cont">
				<div class="pop-title flex justify-space">
					<div class="left flex">
						<h2>수업 구성 관리</h2>
						<!-- 추천 조합, 직접 조합 모드 스위치 버튼(클라이언트 요구사항으로 사용X) -->
						<!-- <button id="exercise_combination_popup_content_box1_btn" class="btn-s-round2 mr10">추천 조합</button>
						<button id="exercise_combination_popup_content_box2_btn" class="btn-s-round2">직접 조합</button> -->
					</div>
					<div class="right">
						<button id="exercise_combination_popup_close" class="close">x</button>
					</div>
				</div>
				<!-- 추천 조합 (사용X) -->
				<!-- 
				<div id="exercise_combination_popup_content_box1" class="pop-cont hidden_class">
					<div class="filter-wrap">
						<div class="filter-inner flex">
							<div class="field w32">
								<label>종목</label>
								<select id="exercise_combination_popup_content_name">
									<option>전체</option>
									<c:forEach items="${content_list_content_name}" var="content_list_content_name">
									<option>${content_list_content_name}</option>
									</c:forEach>
								</select>
							</div>
							<div class="field w32">
								<label>대분류</label>
								<select id="exercise_combination_popup_content_category">
									<option>전체</option>
									<c:forEach items="${content_list_content_category}" var="content_list_content_category">
									<option>${content_list_content_category}</option>
									</c:forEach>
								</select>
							</div>
							<div class="field w100">
								<label>검색 구분</label>
								<select id="exercise_combination_popup_content_search_option">
									<option>전체</option>
									<option>제목</option>
									<option>생산자</option>
								</select>
								<input id="exercise_combination_popup_content_search_input" type="text" class="search-input ml10" />
							</div>
						</div>
	
						<div class="btn-wrap">
							<button id="exercise_combination_popup_content_search_btn" class="btn-pt">조회</button>
						</div>
							
					</div>
					<div class="pop-cont-inner">
						<div class="table-control">
							<select id="exercise_combination_popup_content_sort">
								<option>최신순</option>
								<option>오래된순</option>
							</select>
						</div>
						<div class="overflow">
							<table id="exercise_combination_popup_content_table" class="basic medium">
								<tr>
									<th></th>
									<th>#</th>
									<th>종목</th>
									<th>대분류</th>
									<th>제목</th>
									<th>생산자</th>
									<th>학교급</th>
									<th>학년</th>
									<th>등록일</th>
								</tr>
							</table>
						</div>
						<div id="exercise_combination_popup_paging_box" class="paging mt10">
							
						</div>
	
					
					</div>
					
					<div class="btn-wrap">
						<button id="exercise_combination_popup_save1" class="btn-pt">저장하기</button>
						<button id="exercise_combination_popup_close1" class="btn-sec">뒤로가기</button>
					</div>
	
				</div>
				 -->
				 <!-- 직접 조합 -->
				<div id="exercise_combination_popup_content_box2" class="pop-cont hidden_class">
					
					<div class="pop-cont-inner">
						<div class="overflow">
							<table id="exercise_combination_popup_my_content_table" class="basic medium">
								<tr>
									<th>종목</th>
									<th>대분류</th>
									<th>동작명</th>
									<th>갯수</th>
									<th>제한시간(초)</th>
									<th>등급</th>
									<th>비고</th>
								</tr>
							</table>
						</div>
						<button id="exercise_combinatio_add_content_btn" class="btn-fw-gray mt10">+ 추가</button>
					</div>
					
					<div class="btn-wrap">
						<button id="exercise_combination_popup_save2" class="btn-pt">저장하기</button>
						<button id="exercise_combination_popup_close2" class="btn-sec">뒤로가기</button>
					</div>
	
				</div>
			</div>
		</div>
	
	</div>
	
	<!-- 그룹 셋팅 팝업 -->
	<div id="group_setting_popup" class="popup" style="display:none;">
		<div class="popup-cont">
			<div class="pop-title flex justify-space">
				<div class="left flex">
					<h2>그룹관리</h2>
					<button id="group_div_sex_btn" class="btn-s-round mr10">남/여 나누기</button>
					<button id="group_div_dir_btn" class="btn-s-round active">직접 구성</button>
				</div>
				<div class="right">
					<button id="grop_setting_popup_close" class="close">x</button>
				</div>
			</div>
			<div class="pop-cont">
				<div class="pop-cont-inner">
					<h3>그룹관리</h3>
					<ul id="group_box_parent" class="s-list-txt group-seletion">
						<li class="group_box active">1그룹<span class="group_setting_name_remove close">x</span></li>
						<li class="group_box">2그룹<span class="group_setting_name_remove close">x</span></li>
						
						<li><button id="group_add_btn" class="btn-round btn-add">+</button></li>
						<li class="exit edit-small group-edit">
							<input id="group-edit_input" type="text" />
							<div class="btn-wrap">
								<button id="group_push_btn" class="btn-s-round bg-blue">등록</button>
								<button id="group_pop_btn" class="btn-s-round">취소</button>
							</div>
						</li>
					</ul>
				</div>
				<div class="pop-cont-inner">
					<h3>그룹 지정</h3>
					<ul id="group_setting_student_list" class="s-list-txt-box">
						
					</ul>
				</div>

				<div class="btn-wrap">
					<button id="group_setting_save" class="btn-pt">저장하기</button>
				</div>
			</div>
		</div>
	</div>
	
	</body>
	<script>
	var curriculum_detail_popup_content_set_btn = null;	//현재 설정중인 콘텐츠 선택 버튼, 버튼 내부에 해당 콘텐츠 식별값(콘텐츠코드가)이 들어간다.
	/* 추천조합에 사용되는 상단 옵션들 */
	var exercise_combination_popup_content_name = "전체";
	var exercise_combination_popup_content_category = "전체";
	var exercise_combination_popup_content_search_option = "전체";
	var exercise_combination_popup_content_search_input = "";
	var exercise_combination_popup_content_sort = "최신순";

	var exercise_name_list = ${exercise_name_list};	//수업 구성관리(콘텐츠)의 종목 Array
	var curriculum_list = null;	//수정모드에서 사용하는 해당 커리큘럼정보 Array(그룹이면 여러개일수있으므로 배열 형태)
	var this_group_node = null;	//현재 선택중인 그룹 정보
	var group_file_array = [];	//각 그룹마다 추가 파일들을 저장할 Array(Array 내부 파일 Array 저장)

	var deleteFile = [];	//수정에서 사용할 서버내에서 삭제할 파일
	var fileBuffer = [];	//신규 업데이트 파일
	var is = "${is}";		//수정모드일 경우 전체형 수업, 맞춤형 수업(그룹) 의 구분값
	var type = "one";		//그룹이라면 "group", 일반(전체형 수업)일 경우 "one" 이다. Default : "one"
	var student_info = null;	//클래스에 참여중인 학생들의 정보 목록
	
	var mode = "${mode}";	//모드(생성, 수정)
	
	$(document).ready(function(){

		/* 참여 학생정보 셋팅 */
		var temp = "" + ${class_student_info};
		if(temp != "n"){
			student_info = ${class_student_info};
		}

		/* 뒤로가기 버튼 클릭 이벤트 */
		$("#go_back_btn").click(function(){
			location.href="/teacher/ready/class_configuration_management_detail?class_code="+"${class_code}";
		});

		/* 현재 선택중인 그룹노드를 전역변수에 저장(최초:첫번째 그룹) */
		this_group_node = $("#unit_group_name option:selected");

		/* 수정일 때의 최초 셋팅 값 */
		if(mode == "modify"){
			curriculum_list = ${curriculum};

			/*
			 - 2차원 배열로 저장된 콘텐츠 종목명, 해당 종목 지정 운동 개수 지정
			 - 해당 데이터를 토대로 수업구성 필드에 - '운동명' '개수'회 라는 뷰를 보여줌
			*/
			var default_content_detail_name_list = ${content_detail_name_list};
			var default_content_count_list = ${content_count_list};
			if(default_content_detail_name_list == 1){
				default_content_detail_name_list = null;
			}
			if(default_content_count_list == 1){
				default_content_count_list = null;
			}
			if(default_content_detail_name_list != null){
				for(x=0;x<default_content_detail_name_list[0].length;x++){
					if(default_content_detail_name_list[0][x] != null){
						$(".curriculum_detail_content_list").eq(x).removeClass("hidden_box");
						for(xx=0;xx<default_content_detail_name_list[0][x].length;xx++){
							$(".curriculum_detail_content_list").eq(x).append('<div class="curriculum_detail_content">- <span class="curriculum_detail_content_name">'+default_content_detail_name_list[0][x][xx]+'</span> <span class="curriculum_detail_content_count">'+default_content_count_list[0][x][xx]+'</span>회</div>');
						}	
					}
				}
			}

			$(".radio-wrap").remove();	//수정일때 수업 타입 변경 불가

			/* 수정모드 + 그룹형 수업일 경우 셋팅 */
			if(is == "group"){
				type = "group";

				/* 그룹 선택 필드를 숨김 해제처리 */
				$("#group_content_box").removeClass("hidden_box");

				/*
				 - 그룹 선택 필드의 셀렉트박스에 그룹 목록을 넣고, 그룹내부데이터도 속성으로 저장

				*/
				$("#unit_group_name").empty();

				var content_participation_check = false;

				for(x=0;x<curriculum_list.length;x++){
					var this_cur = curriculum_list[x];

					if(this_cur["content_participation"] != null || this_cur["content_submit_task"] != null){
						content_participation_check = true;
					}
					
					if(this_cur["unit_attached_file"] == null){
						if(default_content_detail_name_list != null){
							$("#unit_group_name").append('<option class="unit_group_name_option" unit_group_name="'+this_cur["unit_group_name"]+'" ' +
									'unit_group_id_list=\''+this_cur["unit_group_id_list"]+'\' unit_class_text="'+this_cur["unit_class_text"]+'" ' +
									'unit_youtube_url=\''+this_cur["unit_youtube_url"]+'\' unit_content_url=\''+this_cur["unit_content_url"]+'\' ' +
									'default_content_detail_name_list=\''+JSON.stringify(default_content_detail_name_list[x])+'\' default_content_count_list=\''+JSON.stringify(default_content_count_list[x])+'\' ' +
									'content_code_list=\''+this_cur["content_code_list"]+'\' content_evaluation_type=\''+this_cur["content_evaluation_type"]+'\'>'+this_cur["unit_group_name"]+'</option>');	
						}else{
							$("#unit_group_name").append('<option class="unit_group_name_option" unit_group_name="'+this_cur["unit_group_name"]+'" ' +
									'unit_group_id_list=\''+this_cur["unit_group_id_list"]+'\' unit_class_text="'+this_cur["unit_class_text"]+'" ' +
									'unit_youtube_url=\''+this_cur["unit_youtube_url"]+'\' unit_content_url=\''+this_cur["unit_content_url"]+'\' ' +
									'content_code_list=\''+this_cur["content_code_list"]+'\' content_evaluation_type=\''+this_cur["content_evaluation_type"]+'\'>'+this_cur["unit_group_name"]+'</option>');
						}
					}else{
						if(default_content_detail_name_list != null){
							$("#unit_group_name").append('<option class="unit_group_name_option" unit_group_name="'+this_cur["unit_group_name"]+'" ' +
									'unit_group_id_list=\''+this_cur["unit_group_id_list"]+'\' unit_class_text="'+this_cur["unit_class_text"]+'" ' +
									'unit_youtube_url=\''+this_cur["unit_youtube_url"]+'\' unit_content_url=\''+this_cur["unit_content_url"]+'\' ' +
									'default_content_detail_name_list=\''+JSON.stringify(default_content_detail_name_list[x])+'\' default_content_count_list=\''+JSON.stringify(default_content_count_list[x])+'\' ' +
									'befor_file=\''+this_cur["unit_attached_file"]+'\' content_code_list=\''+this_cur["content_code_list"]+'\' content_evaluation_type=\''+this_cur["content_evaluation_type"]+'\'>'+this_cur["unit_group_name"]+'</option>');	
						}else{
							$("#unit_group_name").append('<option class="unit_group_name_option" unit_group_name="'+this_cur["unit_group_name"]+'" ' +
									'unit_group_id_list=\''+this_cur["unit_group_id_list"]+'\' unit_class_text="'+this_cur["unit_class_text"]+'" ' +
									'unit_youtube_url=\''+this_cur["unit_youtube_url"]+'\' unit_content_url=\''+this_cur["unit_content_url"]+'\' ' +
									'befor_file=\''+this_cur["unit_attached_file"]+'\' content_code_list=\''+this_cur["content_code_list"]+'\' content_evaluation_type=\''+this_cur["content_evaluation_type"]+'\'>'+this_cur["unit_group_name"]+'</option>');
						}
					}
				}
				this_group_node = $("#unit_group_name option:selected");	//현재선택중인 그룹노드를 지정(최초:첫번쨰 그룹노드)

				/* 이미 수업에 참여중인 학생이 있는 경우에는 그룹설정을 하지 못하도록 만든다. */
				if(content_participation_check){
					$("#unit_group_setting_btn").remove();
					$("#group_setting_popup").remove();	
				}
			}
			/* 수업 제목 셋팅 */
			$("#unit_class_name").val(curriculum_list[0]["unit_class_name"]);
			$("#curriculum_detail_popup_unit_class_text").val(curriculum_list[0]["unit_class_text"]);

			/* 날짜 셋팅(시작일) */
			if(curriculum_list[0]["unit_start_date"] == "0"){
				$("#from").val("");
				$("#from_hour").val("시").prop("selected", true);
				$("#from_min").val("분").prop("selected", true);	
			}else{
				$("#from").val(curriculum_list[0]["unit_start_date"].substring(4,6) + "/" + curriculum_list[0]["unit_start_date"].substring(6,8) + "/" + curriculum_list[0]["unit_start_date"].substring(0,4));
				$("#from_hour").val(curriculum_list[0]["unit_start_date"].substring(8,10)).prop("selected", true);
				$("#from_min").val(curriculum_list[0]["unit_start_date"].substring(10,12)).prop("selected", true);
			}

			/* 날짜 셋팅(종료일) */
			if(curriculum_list[0]["unit_end_date"] == "0"){
				$("#to").val("");
				$("#to_hour").val("시").prop("selected", true);
				$("#to_min").val("분").prop("selected", true);
			}else{
				$("#to").val(curriculum_list[0]["unit_end_date"].substring(4,6) + "/" + curriculum_list[0]["unit_end_date"].substring(6,8) + "/" + curriculum_list[0]["unit_end_date"].substring(0,4));
				$("#to_hour").val(curriculum_list[0]["unit_end_date"].substring(8,10)).prop("selected", true);
				$("#to_min").val(curriculum_list[0]["unit_end_date"].substring(10,12)).prop("selected", true);	
			}

			/* 수업구성 셋팅 */
			var content_code_list = JSON.parse(curriculum_list[0]["content_code_list"]);
			var content_evaluation_type = JSON.parse(curriculum_list[0]["content_evaluation_type"]);

			for(x=0;x<content_code_list.length;x++){
				$(".curriculum_detail_popup_content_name").eq(x).val(content_code_list[x]["content_name"]);
				if(content_code_list[x]["content_name"] == "평가수업"){
					$(".curriculum_detail_popup_content_test").eq(x).removeClass("hidden_box");
					if(content_evaluation_type[x] == "1"){
						$(".curriculum_detail_popup_content_test").eq(x).val("상/중/하 평가").prop("selected", true);
					}else if(content_evaluation_type[x] == "2"){
						$(".curriculum_detail_popup_content_test").eq(x).val("점수 평가").prop("selected", true);
					}else if(content_evaluation_type[x] == "3"){
						$(".curriculum_detail_popup_content_test").eq(x).val("텍스트 평가").prop("selected", true);
					}
				}

				if(content_code_list[x]["content_name"] != "이론수업"){
					$(".curriculum_detail_popup_content_set_btn").eq(x).removeClass("hidden_box");
					$(".curriculum_detail_popup_content_set_btn").eq(x).attr("content_code", content_code_list[x]["content_code"]);
					$(".curriculum_detail_popup_content_set_btn").eq(x).attr("content_title", content_code_list[x]["content_title"]);
				}

				$(".curriculum_detail_popup_content_type").eq(x).val(content_code_list[x]["content_type"]).prop("selected", true);
				$(".curriculum_detail_popup_content").eq(x).removeClass("hidden_box");
				if(x==1){
					$("#curriculum_detail_popup_content_add1").addClass("hidden_box");
					$("#curriculum_detail_popup_content_add2").removeClass("hidden_box");
					$("#curriculum_detail_popup_content_remove2").removeClass("hidden_box");
				}else if(x==2){
					$("#curriculum_detail_popup_content_add2").addClass("hidden_box");
					$("#curriculum_detail_popup_content_remove2").addClass("hidden_box");
					$("#curriculum_detail_popup_content_add3").removeClass("hidden_box");
					$("#curriculum_detail_popup_content_remove3").removeClass("hidden_box");
				}else if(x==3){
					$("#curriculum_detail_popup_content_add3").addClass("hidden_box");
					$("#curriculum_detail_popup_content_remove3").addClass("hidden_box");
					$("#curriculum_detail_popup_content_add4").removeClass("hidden_box");
					$("#curriculum_detail_popup_content_remove4").removeClass("hidden_box");
				}else if(x==4){
					$("#curriculum_detail_popup_content_add4").addClass("hidden_box");
					$("#curriculum_detail_popup_content_remove4").addClass("hidden_box");
					$("#curriculum_detail_popup_content_remove5").removeClass("hidden_box");
				}
			}

			/* 유튜브영상 셋팅 */
			if(curriculum_list[0]["unit_youtube_url"] != null){
				var unit_youtube_url = JSON.parse(curriculum_list[0]["unit_youtube_url"]);
				for(x=0;x<unit_youtube_url.length;x++){
					$(".curriculum_detail_popup_youtube_name").eq(x).val(unit_youtube_url[x]["title"]);
					$(".curriculum_detail_popup_youtube_link").eq(x).val(unit_youtube_url[x]["link"]);
					$(".curriculum_detail_popup_content_youtube").eq(x).removeClass("hidden_box");
					$("#curriculum_detail_popup_youtube_add"+x).addClass("hidden_box");
					$("#curriculum_detail_popup_youtube_remove"+x).addClass("hidden_box");
					$("#curriculum_detail_popup_youtube_add"+(x+1)).removeClass("hidden_box");
					$("#curriculum_detail_popup_youtube_remove"+(x+1)).removeClass("hidden_box");
					$("#curriculum_detail_popup_youtube"+(x+1)).removeClass("hidden_box");
				}	
			}

			/* 수업 관련 링크 셋팅 */
			if(curriculum_list[0]["unit_content_url"] != null){
				var unit_content_url = JSON.parse(curriculum_list[0]["unit_content_url"]);
				for(x=0;x<unit_content_url.length;x++){
					$(".curriculum_detail_popup_etc_name").eq(x).val(unit_content_url[x]["title"]);
					$(".curriculum_detail_popup_etc_link").eq(x).val(unit_content_url[x]["link"]);
					$(".curriculum_detail_popup_content_etc").eq(x).removeClass("hidden_box");
					$("#curriculum_detail_popup_etc_add"+x).addClass("hidden_box");
					$("#curriculum_detail_popup_etc_remove"+x).addClass("hidden_box");
					$("#curriculum_detail_popup_etc_add"+(x+1)).removeClass("hidden_box");
					$("#curriculum_detail_popup_etc_remove"+(x+1)).removeClass("hidden_box");
					$("#curriculum_detail_popup_etc"+(x+1)).removeClass("hidden_box");
				}
			}

			/* 참고자료 셋팅 */
			$("#curriculum_detail_popup_files_box").children('div').remove();
			if(curriculum_list[0]["unit_attached_file"] != null){
				var unit_attached_file = JSON.parse(curriculum_list[0]["unit_attached_file"]);
				for(x=0;x<unit_attached_file.length;x++){
					$("#curriculum_detail_popup_files_box").append('<div style="float:left; width:100%;"><li class="curriculum_file_base" style="float:left; ">'+unit_attached_file[x].replace("/resources/class_file/", "")+'</li></div>');
				}
			}
		}

		/*
		 - 그룹 선택필드의 셀렉트박스 그룹 변경시 이벤트 추가
		 - 1. 전역변수 this_group_node에 저장되어있는 현재 그룹 노드에 해당 그룹 데이터들을(화면상 데이터) 저장한다.(속성)
		 - 2. 선택한 셀렉트박스 옵션 노드를 전역변수 this_group_node에 저장한다.
		 - 3. 현재 선택중인 그룹노드(this_group_node)의 속성을 토대로 해당 그룹 데이터들을 변경한다(화면상 데이터)
		 - 4. 기존 참고자료 파일들은 배열형태로 전역변수 group_file_array[이전 그룹 인덱스] 저장(이차원배열 형태)한 뒤 전역변수 fileBuffer를 초기화한다.
		 - 5. group_file_array[현재 선택된 그룹 인덱스]의 배열(이차원배열 형태)을 fileBuffer에 저장한다. 또한 방금 저장된 fileBuffer배열을 토대로 참고자료를 셋팅한다.
		*/
		$("#unit_group_name").change(function(){
			var index = $("#unit_group_name option").index($(this_group_node));
			/* 이전 그룹에서 추가된 파일 배열을 Array에 저장 */
			group_file_array[index] = fileBuffer;
			fileBuffer = [];
			
			/* 이전 그룹에서 셋팅했던 데이터들을 그룹 selectbox option의 attr에 동기화 */
			$(this_group_node).attr("unit_class_text", $("#curriculum_detail_popup_unit_class_text").val());
			
			var unit_youtube_url = [];
			for(x=0;x<$(".curriculum_detail_popup_content_youtube").length;x++){
				var obj = {};
				if(!$(".curriculum_detail_popup_content_youtube").eq(x).hasClass("hidden_box")){
					obj["title"] = $(".curriculum_detail_popup_youtube_name").eq(x).val();
					obj["link"] = $(".curriculum_detail_popup_youtube_link").eq(x).val();
				}
			}
			$(this_group_node).attr("unit_youtube_url", JSON.stringify(unit_youtube_url));
			
			var unit_youtube_url = [];
			for(x=0;x<$(".curriculum_detail_popup_content_youtube").length;x++){
				var obj = {};
				if(!$(".curriculum_detail_popup_content_youtube").eq(x).hasClass("hidden_box")){
					obj["title"] = $(".curriculum_detail_popup_youtube_name").eq(x).val();
					obj["link"] = $(".curriculum_detail_popup_youtube_link").eq(x).val();
					unit_youtube_url.push(obj);
				}
			}
			$(this_group_node).attr("unit_youtube_url", JSON.stringify(unit_youtube_url));
			
			var unit_content_url = [];
			for(x=0;x<$(".curriculum_detail_popup_content_etc").length;x++){
				var obj = {};
				if(!$(".curriculum_detail_popup_content_etc").eq(x).hasClass("hidden_box")){
					obj["title"] = $(".curriculum_detail_popup_etc_name").eq(x).val();
					obj["link"] = $(".curriculum_detail_popup_etc_link").eq(x).val();
					unit_content_url.push(obj);
				}
			}
			$(this_group_node).attr("unit_content_url", JSON.stringify(unit_content_url));
			
			var content_code_list = [];
			var content_evaluation_type = [];
			for(x=0;x<$(".curriculum_detail_popup_content").length;x++){
				var obj = {};
				if(!$(".curriculum_detail_popup_content").eq(x).hasClass("hidden_box")){
					if(x==0){
						obj["content_name"] = $("#curriculum_detail_popup_content_name1 option:selected").val();
						if(obj["content_name"] == "평가수업"){
							if($("#curriculum_detail_popup_content_test1 option:selected").val() == "평가방식"){
								content_evaluation_type.push("0");	
							}else if($("#curriculum_detail_popup_content_test1 option:selected").val() == "상/중/하 평가"){
								content_evaluation_type.push("1");
							}else if($("#curriculum_detail_popup_content_test1 option:selected").val() == "점수 평가"){
								content_evaluation_type.push("2");
							}else if($("#curriculum_detail_popup_content_test1 option:selected").val() == "텍스트 평가"){
								content_evaluation_type.push("3");
							}
						}else{
							content_evaluation_type.push("0");
						}
						if($("#curriculum_detail_popup_content_set_btn1").attr("content_code") != null){
							obj["content_code"] = $("#curriculum_detail_popup_content_set_btn1").attr("content_code");
							obj["content_title"] = $("#curriculum_detail_popup_content_set_btn1").attr("content_title");	
						}else{
							obj["content_code"] = null;
							obj["content_title"] = null;
						}
						obj["content_type"] = $("#curriculum_detail_popup_content_type1 option:selected").val();
					}else if(x==1){
						obj["content_name"] = $("#curriculum_detail_popup_content_name2 option:selected").val();
						if(obj["content_name"] == "평가수업"){
							if($("#curriculum_detail_popup_content_test2 option:selected").val() == "평가방식"){
								content_evaluation_type.push("0");	
							}else if($("#curriculum_detail_popup_content_test2 option:selected").val() == "상/중/하 평가"){
								content_evaluation_type.push("1");
							}else if($("#curriculum_detail_popup_content_test2 option:selected").val() == "점수 평가"){
								content_evaluation_type.push("2");
							}else if($("#curriculum_detail_popup_content_test2 option:selected").val() == "텍스트 평가"){
								content_evaluation_type.push("3");
							}
						}else{
							content_evaluation_type.push("0");
						}
						if($("#curriculum_detail_popup_content_set_btn2").attr("content_code") != null){
							obj["content_code"] = $("#curriculum_detail_popup_content_set_btn2").attr("content_code");
							obj["content_title"] = $("#curriculum_detail_popup_content_set_btn2").attr("content_title");	
						}else{
							obj["content_code"] = null;
							obj["content_title"] = null;
						}
						obj["content_type"] = $("#curriculum_detail_popup_content_type2 option:selected").val();
					}else if(x==2){
						obj["content_name"] = $("#curriculum_detail_popup_content_name3 option:selected").val();
						if(obj["content_name"] == "평가수업"){
							if($("#curriculum_detail_popup_content_test3 option:selected").val() == "평가방식"){
								content_evaluation_type.push("0");	
							}else if($("#curriculum_detail_popup_content_test3 option:selected").val() == "상/중/하 평가"){
								content_evaluation_type.push("1");
							}else if($("#curriculum_detail_popup_content_test3 option:selected").val() == "점수 평가"){
								content_evaluation_type.push("2");
							}else if($("#curriculum_detail_popup_content_test3 option:selected").val() == "텍스트 평가"){
								content_evaluation_type.push("3");
							}
						}else{
							content_evaluation_type.push("0");
						}
						if($("#curriculum_detail_popup_content_set_btn3").attr("content_code") != null){
							obj["content_code"] = $("#curriculum_detail_popup_content_set_btn3").attr("content_code");
							obj["content_title"] = $("#curriculum_detail_popup_content_set_btn3").attr("content_title");	
						}else{
							obj["content_code"] = null;
							obj["content_title"] = null;
						}
						obj["content_type"] = $("#curriculum_detail_popup_content_type3 option:selected").val();
					}else if(x==3){
						obj["content_name"] = $("#curriculum_detail_popup_content_name4 option:selected").val();
						if(obj["content_name"] == "평가수업"){
							if($("#curriculum_detail_popup_content_test4 option:selected").val() == "평가방식"){
								content_evaluation_type.push("0");	
							}else if($("#curriculum_detail_popup_content_test4 option:selected").val() == "상/중/하 평가"){
								content_evaluation_type.push("1");
							}else if($("#curriculum_detail_popup_content_test4 option:selected").val() == "점수 평가"){
								content_evaluation_type.push("2");
							}else if($("#curriculum_detail_popup_content_test4 option:selected").val() == "텍스트 평가"){
								content_evaluation_type.push("3");
							}
						}else{
							content_evaluation_type.push("0");
						}
						if($("#curriculum_detail_popup_content_set_btn4").attr("content_code") != null){
							obj["content_code"] = $("#curriculum_detail_popup_content_set_btn4").attr("content_code");
							obj["content_title"] = $("#curriculum_detail_popup_content_set_btn4").attr("content_title");	
						}else{
							obj["content_code"] = null;
							obj["content_title"] = null;
						}
						obj["content_type"] = $("#curriculum_detail_popup_content_type4 option:selected").val();
					}else{
						obj["content_name"] = $("#curriculum_detail_popup_content_name5 option:selected").val();
						if(obj["content_name"] == "평가수업"){
							if($("#curriculum_detail_popup_content_test5 option:selected").val() == "평가방식"){
								content_evaluation_type.push("0");	
							}else if($("#curriculum_detail_popup_content_test5 option:selected").val() == "상/중/하 평가"){
								content_evaluation_type.push("1");
							}else if($("#curriculum_detail_popup_content_test5 option:selected").val() == "점수 평가"){
								content_evaluation_type.push("2");
							}else if($("#curriculum_detail_popup_content_test5 option:selected").val() == "텍스트 평가"){
								content_evaluation_type.push("3");
							}
						}else{
							content_evaluation_type.push("0");
						}
						if($("#curriculum_detail_popup_content_set_btn5").attr("content_code") != null){
							obj["content_code"] = $("#curriculum_detail_popup_content_set_btn5").attr("content_code");
							obj["content_title"] = $("#curriculum_detail_popup_content_set_btn5").attr("content_title");	
						}else{
							obj["content_code"] = null;
							obj["content_title"] = null;
						}
						obj["content_type"] = $("#curriculum_detail_popup_content_type5 option:selected").val();
					}
					content_code_list.push(obj);
				}
			}
			
			$(this_group_node).attr("content_code_list",JSON.stringify(content_code_list));
			$(this_group_node).attr("content_evaluation_type",JSON.stringify(content_evaluation_type));
			$(this_group_node).attr("unit_class_text", $("#curriculum_detail_popup_unit_class_text").val());
			
			var content_text_arr = [];
			var content_count_arr = [];
			for(x=0;x<$(".curriculum_detail_popup_content").length;x++){
				if(!$(".curriculum_detail_popup_content").eq(x).hasClass("hidden_box")){
					var temp_arr1 = [];
					var temp_arr2 = [];
					if(!$(".curriculum_detail_content_list").eq(x).hasClass("hidden_box")){
						
						var temp_node = $(".curriculum_detail_content_list").eq(x).children('.curriculum_detail_content');
						for(ch=0;ch<temp_node.length;ch++){
							temp_arr1.push(temp_node.eq(ch).children(".curriculum_detail_content_name").text());
							temp_arr2.push(temp_node.eq(ch).children(".curriculum_detail_content_count").text());
						}
					}else{
						temp_arr1.push(null);
						temp_arr2.push(null);
					}
					content_text_arr.push(temp_arr1);
					content_count_arr.push(temp_arr2);
				}
			}
			$(this_group_node).attr("default_content_detail_name_list", JSON.stringify(content_text_arr));
			$(this_group_node).attr("default_content_count_list", JSON.stringify(content_count_arr));
			
			if($(".curriculum_file_base").length > 0){
				var befor_file = [];
				for(x=0;x<$(".curriculum_file_base").length;x++){
					befor_file.push($(".curriculum_file_base").eq(x).text());
				}
				//기존 남은파일 저장
				$(this_group_node).attr("befor_file", JSON.stringify(befor_file));
			}else{
				$(this_group_node).attr("befor_file", null);
			}
			

			/* 
			 - 신규 추가된 그룹은 데이터가 없으므로 공백으로 초기화 시켜야한다. 
			 - 기존 데이터가 존재하는 그룹은 보유한 데이터로 초기화 시켜야한다. 
			*/
			this_group_node = $("#unit_group_name option:selected");
			index = $("#unit_group_name option").index($(this_group_node));
			/* 신규 그룹에서 추가된 파일 배열을 Array에 저장 */
			if(group_file_array[index] != null && group_file_array[index].length > 0){
				fileBuffer = group_file_array[index];	
			}else{
				fileBuffer = [];
			}
			
			/* 수업구성 셋팅 */

			$("#curriculum_detail_popup_content_add1").removeClass("hidden_box");

			$("#curriculum_detail_popup_content_add2").addClass("hidden_box");
			$("#curriculum_detail_popup_content_add3").addClass("hidden_box");
			$("#curriculum_detail_popup_content_add4").addClass("hidden_box");

			$("#curriculum_detail_popup_content_remove2").addClass("hidden_box");
			$("#curriculum_detail_popup_content_remove3").addClass("hidden_box");
			$("#curriculum_detail_popup_content_remove4").addClass("hidden_box");
			$("#curriculum_detail_popup_content_remove5").addClass("hidden_box");

			$(".curriculum_detail_popup_content").addClass("hidden_box");
			$(".curriculum_detail_popup_content").eq(0).removeClass("hidden_box");
			
			
			$(".curriculum_detail_content_list").empty();
			$(".curriculum_detail_content_list").addClass("hidden_box");
			
			
			if($(this_group_node).attr("default_content_detail_name_list") != null){
				var default_content_detail_name = JSON.parse($(this_group_node).attr("default_content_detail_name_list"));
				var default_content_detail_count = JSON.parse($(this_group_node).attr("default_content_count_list"));
				for(d_c=0;d_c<default_content_detail_name.length;d_c++){
					if(default_content_detail_name[d_c] != null && default_content_detail_name[d_c][0] != null){
						$(".curriculum_detail_content_list").eq(d_c).removeClass("hidden_box");
						for(d_c_i=0;d_c_i<default_content_detail_name[d_c].length;d_c_i++){
							$(".curriculum_detail_content_list").eq(d_c).append('<div class="curriculum_detail_content">- <span class="curriculum_detail_content_name">'+default_content_detail_name[d_c][d_c_i]+'</span> <span class="curriculum_detail_content_count">'+default_content_detail_count[d_c][d_c_i]+'</span>회</div>');
						}	
					}
				}
			}

			if($(this_group_node).attr("content_code_list") != null && $(this_group_node).attr("content_code_list").length > 3){
				var content_code_list = JSON.parse($(this_group_node).attr("content_code_list"));
				var content_evaluation_type = JSON.parse($(this_group_node).attr("content_evaluation_type"));
				
				$(".curriculum_detail_popup_content_set_btn").attr("content_code", null);
				$(".curriculum_detail_popup_content_set_btn").attr("content_title", null);
				
				for(x=0;x<content_code_list.length;x++){
					$(".curriculum_detail_popup_content").eq(x).removeClass("hidden_box");
					$("#curriculum_detail_popup_content_add"+(x)).addClass("hidden_box");
					$("#curriculum_detail_popup_content_remove"+(x)).addClass("hidden_box");
					$("#curriculum_detail_popup_content_add"+(x+1)).removeClass("hidden_box");
					$("#curriculum_detail_popup_content_remove"+(x+1)).removeClass("hidden_box");
					if(x==0){
						$("#curriculum_detail_popup_content_name1").val(content_code_list[x]["content_name"]).prop("selected", true);
						if(content_code_list[x]["content_name"] == "평가수업"){
							$("#curriculum_detail_popup_content_test1").removeClass("hidden_box");
							if(content_evaluation_type[x] == "0"){
								$("#curriculum_detail_popup_content_test1").val("평가방식").prop("selected", true);	
							}else if(content_evaluation_type[x] == "1"){
								$("#curriculum_detail_popup_content_test1").val("상/중/하 평가").prop("selected", true);
							}else if(content_evaluation_type[x] == "2"){
								$("#curriculum_detail_popup_content_test1").val("점수 평가").prop("selected", true);
							}else if(content_evaluation_type[x] == "3"){
								$("#curriculum_detail_popup_content_test1").val("텍스트 평가").prop("selected", true);
							}	
						}else{
							$("#curriculum_detail_popup_content_test1").addClass("hidden_box");
							$("#curriculum_detail_popup_content_test1").val("평가방식").prop("selected", true);
						}
						
						$("#curriculum_detail_popup_content_set_btn1").attr("content_code", content_code_list[x]["content_code"]);
						$("#curriculum_detail_popup_content_set_btn1").attr("content_title", content_code_list[x]["content_title"]);
						
						if(content_code_list[x]["content_name"] != "이론수업"){
							$("#curriculum_detail_popup_content_set_btn1").removeClass("hidden_box");
						}else{
							$("#curriculum_detail_popup_content_set_btn1").addClass("hidden_box");
						}
						$("#curriculum_detail_popup_content_type1").val(content_code_list[x]["content_type"]).prop("selected", true);
					}else if(x==1){
						$("#curriculum_detail_popup_content_name2").val(content_code_list[x]["content_name"]).prop("selected", true);
						if(content_code_list[x]["content_name"] == "평가수업"){
							$("#curriculum_detail_popup_content_test2").removeClass("hidden_box");
							if(content_evaluation_type[x] == "0"){
								$("#curriculum_detail_popup_content_test2").val("평가방식").prop("selected", true);
							}else if(content_evaluation_type[x] == "1"){
								$("#curriculum_detail_popup_content_test2").val("상/중/하 평가").prop("selected", true);
							}else if(content_evaluation_type[x] == "2"){
								$("#curriculum_detail_popup_content_test2").val("점수 평가").prop("selected", true);
							}else if(content_evaluation_type[x] == "3"){
								$("#curriculum_detail_popup_content_test2").val("텍스트 평가").prop("selected", true);
							}
						}else{
							$("#curriculum_detail_popup_content_test2").addClass("hidden_box");
							$("#curriculum_detail_popup_content_test2").val("평가방식").prop("selected", true);
						}

						$("#curriculum_detail_popup_content_set_btn2").attr("content_code", content_code_list[x]["content_code"]);
						$("#curriculum_detail_popup_content_set_btn2").attr("content_title", content_code_list[x]["content_title"]);

						if(content_code_list[x]["content_name"] != "이론수업"){
							$("#curriculum_detail_popup_content_set_btn2").removeClass("hidden_box");
						}else{
							$("#curriculum_detail_popup_content_set_btn2").addClass("hidden_box");
						}
						$("#curriculum_detail_popup_content_type2").val(content_code_list[x]["content_type"]).prop("selected", true);
					}else if(x==2){
						$("#curriculum_detail_popup_content_name3").val(content_code_list[x]["content_name"]).prop("selected", true);
						if(content_code_list[x]["content_name"] == "평가수업"){
							$("#curriculum_detail_popup_content_test3").removeClass("hidden_box");
							if(content_evaluation_type[x] == "0"){
								$("#curriculum_detail_popup_content_test3").val("평가방식").prop("selected", true);
							}else if(content_evaluation_type[x] == "1"){
								$("#curriculum_detail_popup_content_test3").val("상/중/하 평가").prop("selected", true);
							}else if(content_evaluation_type[x] == "2"){
								$("#curriculum_detail_popup_content_test3").val("점수 평가").prop("selected", true);
							}else if(content_evaluation_type[x] == "3"){
								$("#curriculum_detail_popup_content_test3").val("텍스트 평가").prop("selected", true);
							}
						}else{
							$("#curriculum_detail_popup_content_test3").addClass("hidden_box");
							$("#curriculum_detail_popup_content_test3").val("평가방식").prop("selected", true);
						}

						$("#curriculum_detail_popup_content_set_btn3").attr("content_code", content_code_list[x]["content_code"]);
						$("#curriculum_detail_popup_content_set_btn3").attr("content_title", content_code_list[x]["content_title"]);

						if(content_code_list[x]["content_name"] != "이론수업"){
							$("#curriculum_detail_popup_content_set_btn3").removeClass("hidden_box");
						}else{
							$("#curriculum_detail_popup_content_set_btn3").addClass("hidden_box");
						}
						$("#curriculum_detail_popup_content_type3").val(content_code_list[x]["content_type"]).prop("selected", true);
					}else if(x==3){
						$("#curriculum_detail_popup_content_name4").val(content_code_list[x]["content_name"]).prop("selected", true);
						if(content_code_list[x]["content_name"] == "평가수업"){
							$("#curriculum_detail_popup_content_test4").removeClass("hidden_box");
							if(content_evaluation_type[x] == "0"){
								$("#curriculum_detail_popup_content_test4").val("평가방식").prop("selected", true);
							}else if(content_evaluation_type[x] == "1"){
								$("#curriculum_detail_popup_content_test4").val("상/중/하 평가").prop("selected", true);
							}else if(content_evaluation_type[x] == "2"){
								$("#curriculum_detail_popup_content_test4").val("점수 평가").prop("selected", true);
							}else if(content_evaluation_type[x] == "3"){
								$("#curriculum_detail_popup_content_test4").val("텍스트 평가").prop("selected", true);
							}
						}else{
							$("#curriculum_detail_popup_content_test4").addClass("hidden_box");
							$("#curriculum_detail_popup_content_test4").val("평가방식").prop("selected", true);
						}

						$("#curriculum_detail_popup_content_set_btn4").attr("content_code", content_code_list[x]["content_code"]);
						$("#curriculum_detail_popup_content_set_btn4").attr("content_title", content_code_list[x]["content_title"]);

						if(content_code_list[x]["content_name"] != "이론수업"){
							$("#curriculum_detail_popup_content_set_btn4").removeClass("hidden_box");
						}else{
							$("#curriculum_detail_popup_content_set_btn4").addClass("hidden_box");
						}
						$("#curriculum_detail_popup_content_type4").val(content_code_list[x]["content_type"]).prop("selected", true);
					}else{
						$("#curriculum_detail_popup_content_name5").val(content_code_list[x]["content_name"]).prop("selected", true);
						if(content_code_list[x]["content_name"] == "평가수업"){
							$("#curriculum_detail_popup_content_test5").removeClass("hidden_box");
							if(content_evaluation_type[x] == "0"){
								$("#curriculum_detail_popup_content_test5").val("평가방식").prop("selected", true);
							}else if(content_evaluation_type[x] == "1"){
								$("#curriculum_detail_popup_content_test5").val("상/중/하 평가").prop("selected", true);
							}else if(content_evaluation_type[x] == "2"){
								$("#curriculum_detail_popup_content_test5").val("점수 평가").prop("selected", true);
							}else if(content_evaluation_type[x] == "3"){
								$("#curriculum_detail_popup_content_test5").val("텍스트 평가").prop("selected", true);
							}
						}else{
							$("#curriculum_detail_popup_content_test5").addClass("hidden_box");
							$("#curriculum_detail_popup_content_test5").val("평가방식").prop("selected", true);
						}

						$("#curriculum_detail_popup_content_set_btn5").attr("content_code", content_code_list[x]["content_code"]);
						$("#curriculum_detail_popup_content_set_btn5").attr("content_title", content_code_list[x]["content_title"]);

						if(content_code_list[x]["content_name"] != "이론수업"){
							$("#curriculum_detail_popup_content_set_btn5").removeClass("hidden_box");
						}else{
							$("#curriculum_detail_popup_content_set_btn5").addClass("hidden_box");
						}
						$("#curriculum_detail_popup_content_type5").val(content_code_list[x]["content_type"]).prop("selected", true);
					}
				}
				
			}else{
				//수업 구성 초기화
				for(x=0;x<$(".curriculum_detail_popup_content").length;x++){

					$(".curriculum_detail_popup_content_name").eq(x).val("이론수업").prop("selected", true);
					$(".curriculum_detail_popup_content_test").eq(x).val("평가방식").prop("selected", true);
					$(".curriculum_detail_popup_content_test").eq(x).addClass("hidden_box");
					$(".curriculum_detail_popup_content_set_btn").eq(x).attr("content_code", null);
					$(".curriculum_detail_popup_content_set_btn").eq(x).attr("content_title", null);
					$(".curriculum_detail_popup_content_set_btn").eq(x).addClass("hidden_box");
					$(".curriculum_detail_popup_content_type").eq(x).val("안전").prop("selected", true);
				}
			}


			/* 유튜브 영상 셋팅 */
			$("#curriculum_detail_popup_youtube_add1").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_add2").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube_add3").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube_add4").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube_add5").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube_add6").addClass("hidden_box");

			$("#curriculum_detail_popup_youtube_remove2").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove3").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove4").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove5").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove6").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove7").addClass("hidden_box");

			$(".curriculum_detail_popup_content_youtube").addClass("hidden_box");
			$(".curriculum_detail_popup_content_youtube").eq(0).removeClass("hidden_box");

			for(x=0;x<$(".curriculum_detail_popup_content_youtube").length;x++){
				$(".curriculum_detail_popup_youtube_name").eq(x).val("");
				$(".curriculum_detail_popup_youtube_link").eq(x).val("");
			}

			if($(this_group_node).attr("unit_youtube_url") != null && $(this_group_node).attr("unit_youtube_url").length > 3 && $(this_group_node).attr("unit_youtube_url") != "undefined") {
				var unit_youtube_url = JSON.parse($(this_group_node).attr("unit_youtube_url"));
				for(x=0;x<unit_youtube_url.length;x++) {
					$(".curriculum_detail_popup_content_youtube").eq(x).removeClass("hidden_box");
					$(".curriculum_detail_popup_youtube_name").eq(x).val(unit_youtube_url[x]["title"]);
					$(".curriculum_detail_popup_youtube_link").eq(x).val(unit_youtube_url[x]["link"]);
					$("#curriculum_detail_popup_youtube_add"+(x)).addClass("hidden_box");
					$("#curriculum_detail_popup_youtube_add"+(x+1)).removeClass("hidden_box");
					$("#curriculum_detail_popup_youtube_remove"+(x)).addClass("hidden_box");
					$("#curriculum_detail_popup_youtube_remove"+(x+1)).removeClass("hidden_box");
				}
			}

			/* 수업 관련 링크 셋팅 */
			$("#curriculum_detail_popup_etc_add1").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_add2").addClass("hidden_box");
			$("#curriculum_detail_popup_etc_add3").addClass("hidden_box");
			$("#curriculum_detail_popup_etc_add4").addClass("hidden_box");
			$("#curriculum_detail_popup_etc_add5").addClass("hidden_box");
			$("#curriculum_detail_popup_etc_add6").addClass("hidden_box");

			$("#curriculum_detail_popup_etc_remove2").addClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove3").addClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove4").addClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove5").addClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove6").addClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove7").addClass("hidden_box");

			$(".curriculum_detail_popup_content_etc").addClass("hidden_box");
			$(".curriculum_detail_popup_content_etc").eq(0).removeClass("hidden_box");

			for(x=0;x<$(".curriculum_detail_popup_content_etc").length;x++){
				$(".curriculum_detail_popup_etc_name").eq(x).val("");
				$(".curriculum_detail_popup_etc_link").eq(x).val("");
			}

			if($(this_group_node).attr("unit_content_url") != null && $(this_group_node).attr("unit_content_url").length > 3 && $(this_group_node).attr("unit_content_url") != "undefined") {
				var unit_content_url = JSON.parse($(this_group_node).attr("unit_content_url"));
				for(x=0;x<unit_content_url.length;x++) {
					$(".curriculum_detail_popup_content_etc").eq(x).removeClass("hidden_box");
					$(".curriculum_detail_popup_etc_name").eq(x).val(unit_content_url[x]["title"]);
					$(".curriculum_detail_popup_etc_link").eq(x).val(unit_content_url[x]["link"]);

					$("#curriculum_detail_popup_etc_add"+(x)).addClass("hidden_box");
					$("#curriculum_detail_popup_etc_add"+(x+1)).removeClass("hidden_box");
					$("#curriculum_detail_popup_etc_remove"+(x)).addClass("hidden_box");
					$("#curriculum_detail_popup_etc_remove"+(x+1)).removeClass("hidden_box");
				}
			}

			/* 참고자료 셋팅 */
			$("#curriculum_detail_popup_files_box").empty();
			if($(this_group_node).attr("befor_file") != null && $(this_group_node).attr("befor_file").length > 3) {
				var befor_file = JSON.parse($(this_group_node).attr("befor_file"));
				for(x=0;x<befor_file.length;x++){
					$("#curriculum_detail_popup_files_box").append('<div style="float:left; width:100%;"><li class="curriculum_file_base" style="float:left; ">'+befor_file[x].replace("/resources/class_file/", "")+'</li></div>');
				}
			}

			if(fileBuffer.length > 0) {
				for(x=0;x<fileBuffer.length;x++){
					$("#curriculum_detail_popup_files_box").append('<div style="float:left; width:100%;"><li class="curriculum_file" style="float:left; ">'+fileBuffer[x]["name"]+'</li></div>');
				}
			}

			/*
			 - 기존 파일 삭제
			 - 삭제 배열에 삭제시킬 파일 경로 저장
			*/
			$(".curriculum_file_base").off().click(function(){
				deleteFile.push("/resources/class_file/"+$(this).text());
				$(this).parent('div').remove();
			});

			/*
			 - 신규 파일 삭제
			 - 업로드파일 배열내부 삭제시킬 파일 제거
			*/
			$(".curriculum_file").off().click(function(){
				for(x=0;x<fileBuffer.length;x++){
					if(fileBuffer[x]["name"] == $(this).text()){
						fileBuffer.splice(x,1);
					}
				}
				$(this).parent('div').remove();
			});

			/* 수업내용 */
			if($(this_group_node).attr("unit_class_text") != null && $(this_group_node).attr("unit_class_text").length > 0) {
				$("#curriculum_detail_popup_unit_class_text").val($(this_group_node).attr("unit_class_text"));
			}else{
				$("#curriculum_detail_popup_unit_class_text").val("");
			}
		});

		/*
		 - 콘텐츠 선택 버튼 클릭이벤트
		 - 1. 기존에 이미 콘텐츠가 설정되어 있다면 해당 버튼에 내부속성으로 콘텐츠 코드가 저장되어있다.
		 - 2. 내부속성에 콘텐츠 코드가 저장되어있다면 해당 콘텐츠 코드를 통해 운동목록을 불러온다.
		 - 3. 불러온 운동 목록을 토대로 수업 구성관리 팝업을 셋팅한다.
		 - 4. 만약 내부속성에 콘텐츠 코드가 없다면 수업 구성관리 팝업을 초기셋팅으로 변경한다.
		 - 5. 수업 구성관리 팝업을 보여준다.
		*/
		$(".curriculum_detail_popup_content_set_btn").click(function(){
			var content_code = $(this).attr("content_code");
			curriculum_detail_popup_content_set_btn = $(this);
			$(".exercise_combination_popup_my_content_tr").remove();
			$("#exercise_combination_popup_my_content_tr_modify").remove();

			exercise_combination_popup_content_name = "전체";
			exercise_combination_popup_content_category = "전체";
			exercise_combination_popup_content_search_option = "전체";
			exercise_combination_popup_content_search_input = "";
			exercise_combination_popup_content_sort = "최신순";
			$("#exercise_combination_popup_content_name").val("전체").prop("selected", true);
			$("#exercise_combination_popup_content_category").val("전체").prop("selected", true);
			$("#exercise_combination_popup_content_search_option").val("전체").prop("selected", true);
			$("#exercise_combination_popup_content_sort").val("최신순").prop("selected", true);
			$("#exercise_combination_popup_content_search_input").val("");

			if(content_code == null || content_code.length < 2){
				//추천조합 불러오기
				/*
				$("#exercise_combination_popup_content_box1_btn").removeClass("active");
				$("#exercise_combination_popup_content_box2_btn").removeClass("active");
				$("#exercise_combination_popup_content_box1_btn").addClass("active");
				$("#exercise_combination_popup_content_box2").addClass("hidden_box");
				$("#exercise_combination_popup_content_box1").removeClass("hidden_box");
				get_exercise_combination_content_value("0", 1, null);
				*/
				$("#exercise_combination_popup_content_box1_btn").removeClass("active");
				$("#exercise_combination_popup_content_box2_btn").removeClass("active");
				$("#exercise_combination_popup_content_box2_btn").addClass("active");
				$("#exercise_combination_popup_content_box1").addClass("hidden_box");
				$("#exercise_combination_popup_content_box2").removeClass("hidden_box");
				
				
				var saveRunning = false;
				$("#exercise_combination_popup_save2").off().click(function(){
					if(!saveRunning){
						saveRunning = true;
						if($(".exercise_combination_popup_my_content_tr_modify").length != 0){
							alert("등록이 완료되지 않은 운동이 있습니다.");
							saveRunning = false;
							return;
						}else {
							if ($(".exercise_combination_popup_my_content_tr").length < 1) {
								alert("종목을 추가해주세요");
								saveRunning = false;
							}else{
								var tr_obj = $(".exercise_combination_popup_my_content_tr");
								var content_number = [];
								var content_count_list = [];	//운동 횟수
								var content_time = [];	//운동 시간
								for(x=0;x<tr_obj.length;x++){
									content_number.push($(".exercise_combination_popup_my_content_tr").eq(x).attr("exercise_code"));
									content_count_list.push($(".exercise_combination_popup_my_content_tr").eq(x).children("td").eq(3).text());
									content_time.push($(".exercise_combination_popup_my_content_tr").eq(x).children("td").eq(4).text().replace("초", ""));
								}
								var Obj = {
									"content_number_list":JSON.stringify(content_number),
									"content_count_list":JSON.stringify(content_count_list),
									"content_time":JSON.stringify(content_time),
									"content_class_grade":"${class_list.class_grade}"
								}
								
								$.ajax({
									type:"POST",
									url:"/teacher/ready/save_content_list",
									data:Obj,
									dataType:"text",
									success:function(string){
										if(string != null && string != "fail"){
											var obj = JSON.parse(string);
											$(curriculum_detail_popup_content_set_btn).attr("content_title", $(".exercise_combination_popup_my_content_tr").eq(0).children('td').eq(2).text());
											$(curriculum_detail_popup_content_set_btn).attr("content_code", obj["content_code"]);
											
											
											var nodeId = $(curriculum_detail_popup_content_set_btn).attr("id");
											if(nodeId == "curriculum_detail_popup_content_set_btn1"){
												$(".curriculum_detail_content_list").eq(0).empty();
												$(".curriculum_detail_content_list").eq(0).removeClass("hidden_box");
											}else if(nodeId == "curriculum_detail_popup_content_set_btn2"){
												$(".curriculum_detail_content_list").eq(1).empty();
												$(".curriculum_detail_content_list").eq(1).removeClass("hidden_box");
											}else if(nodeId == "curriculum_detail_popup_content_set_btn3"){
												$(".curriculum_detail_content_list").eq(2).empty();
												$(".curriculum_detail_content_list").eq(2).removeClass("hidden_box");
											}else if(nodeId == "curriculum_detail_popup_content_set_btn4"){
												$(".curriculum_detail_content_list").eq(3).empty();
												$(".curriculum_detail_content_list").eq(3).removeClass("hidden_box");
											}else if(nodeId == "curriculum_detail_popup_content_set_btn5"){
												$(".curriculum_detail_content_list").eq(4).empty();
												$(".curriculum_detail_content_list").eq(4).removeClass("hidden_box");
											}
											
											for(x=0;x<obj["content_detail_name_list"].length;x++){
												var nodeId = $(curriculum_detail_popup_content_set_btn).attr("id");
												if(nodeId == "curriculum_detail_popup_content_set_btn1"){
													$(".curriculum_detail_content_list").eq(0).append('<div class="curriculum_detail_content">- <span class="curriculum_detail_content_name">'+obj["content_detail_name_list"][x]+'</span> <span class="curriculum_detail_content_count">'+obj["content_count_list"][x]+'</span>회</div>');
												}else if(nodeId == "curriculum_detail_popup_content_set_btn2"){
													$(".curriculum_detail_content_list").eq(1).append('<div class="curriculum_detail_content">- <span class="curriculum_detail_content_name">'+obj["content_detail_name_list"][x]+'</span> <span class="curriculum_detail_content_count">'+obj["content_count_list"][x]+'</span>회</div>');
												}else if(nodeId == "curriculum_detail_popup_content_set_btn3"){
													$(".curriculum_detail_content_list").eq(2).append('<div class="curriculum_detail_content">- <span class="curriculum_detail_content_name">'+obj["content_detail_name_list"][x]+'</span> <span class="curriculum_detail_content_count">'+obj["content_count_list"][x]+'</span>회</div>');
												}else if(nodeId == "curriculum_detail_popup_content_set_btn4"){
													$(".curriculum_detail_content_list").eq(3).append('<div class="curriculum_detail_content">- <span class="curriculum_detail_content_name">'+obj["content_detail_name_list"][x]+'</span> <span class="curriculum_detail_content_count">'+obj["content_count_list"][x]+'</span>회</div>');
												}else if(nodeId == "curriculum_detail_popup_content_set_btn5"){
													$(".curriculum_detail_content_list").eq(4).append('<div class="curriculum_detail_content">- <span class="curriculum_detail_content_name">'+obj["content_detail_name_list"][x]+'</span> <span class="curriculum_detail_content_count">'+obj["content_count_list"][x]+'</span>회</div>');
												}
											}
											
											$("#exercise_combination_popup").css("display","none");
											$("#curriculum_detail_popup").css("display", "block");
											curriculum_detail_popup_content_set_btn = null;

										}else{
											alert("서버가 불안정합니다.\r다시 시도해주세요");
										}
									},
									error:function(XMLHttpRequest, textStatus, errorThrown){
										alert(errorThrown);
									}
								});
							}
						}
					}
				});
				
			}else{
				//직접조합 리스트만들기
				$("#exercise_combination_popup_content_box1_btn").removeClass("active");
				$("#exercise_combination_popup_content_box2_btn").removeClass("active");
				$("#exercise_combination_popup_content_box2_btn").addClass("active");
				$("#exercise_combination_popup_content_box1").addClass("hidden_box");
				$("#exercise_combination_popup_content_box2").removeClass("hidden_box");
				get_exercise_combination_content_value("1", null, content_code);
			}

			$("#curriculum_detail_popup").css("display", "none");
			$("#exercise_combination_popup").css("display","block");
		});

		/* 추천조합 관련(사용X) */
		$("#exercise_combination_popup_content_search_btn").click(function(){
			var input = $("#exercise_combination_popup_content_search_input").val();
			if(input.length != 0 && (input.length < 2 || input.length > 20)){
				alert("검색어를 2자 이상 20자 이하로 적어주세요")
			}else{
				exercise_combination_popup_content_name = $("#exercise_combination_popup_content_name option:selected").val();
				exercise_combination_popup_content_category = $("#exercise_combination_popup_content_category option:selected").val();
				exercise_combination_popup_content_search_option = $("#exercise_combination_popup_content_search_option option:selected").val();
				exercise_combination_popup_content_search_input = input;
				get_exercise_combination_content_value("0", 1, null);
			}
		});

		/* 추천조합 관련(사용X) */
		$("#exercise_combination_popup_content_sort").change(function(){
			exercise_combination_popup_content_sort = $("#exercise_combination_popup_content_sort option:selected").val();
			get_exercise_combination_content_value("0", 1, null);
		});

		/*
		 - 수업 구성관리 팝업 - "+ 추가" 버튼 클릭 이벤트
		 - 만일 콘텐츠 구성에서 운동설정이 완료되지않은 운동이 존재시 알림창 생성
		 - 새로 추가시킬 운동 필드를 생성하여 보여준다.
		*/
		$("#exercise_combinatio_add_content_btn").click(function(){
			if($(".exercise_combination_popup_my_content_tr_modify").length != 0){
				alert("등록이 완료되지 않은 운동이 있습니다.");
			}else{
				if($(".exercise_combination_popup_my_content_tr").length < 5){
					var modify_node = '<tr id="exercise_combination_popup_my_content_tr_modify" class="editable-tr exercise_combination_popup_my_content_tr_modify">';
					modify_node += '<td><select id="exercise_combination_popup_my_content_tr_modify_exercise_name"><option>종목</option>';
					for(x=0;x<exercise_name_list.length;x++){
						modify_node += '<option>'+exercise_name_list[x]+'</option>'
					}
					modify_node += '</select></td>'
					modify_node += '<td><select id="exercise_combination_popup_my_content_tr_modify_exercise_category"><option>대분류</option></select></td>';
					modify_node += '<td><select id="exercise_combination_popup_my_content_tr_modify_exercise_detail_name"><option>동작명</option></select></td>';
					modify_node += '<td id="exercise_combination_popup_my_content_tr_modify_exercise_count"></td>';
					modify_node += '<td id="exercise_combination_popup_my_content_tr_modify_exercise_time"></td>';
					modify_node += '<td id="exercise_combination_popup_my_content_tr_modify_exercise_type"></td>';
					modify_node += '<td><button id="exercise_combination_popup_my_content_tr_modify_save_btn" class="btn-s-round-l">등록</button><button id="exercise_combination_popup_my_content_tr_modify_close_btn" class="btn-s-round-l bg-gray-btn">취소</button></td></tr>';

					$("#exercise_combination_popup_my_content_table").append(modify_node);

					/*
					 - 비고 - 취소 버튼 클릭이벤트
					 - 설정중이던 운동셋팅을 취소한다.(삭제)
					*/
					$("#exercise_combination_popup_my_content_tr_modify_close_btn").click(function(){
						$(this).parent().parent().remove();
					});

					/*
					 - 수업 구성 관리 - "+ 추가" - 종목명 변경시 이벤트
					 - 해당 운동의 대분류, 동작명, 갯수, 제한시간(초), 등급, 비고 를 초기화한다.
					 - 변경시킨 옵션값이 "종목"이 아닌 경우 선택된 종목 option을 토대로 동작명을 조회하여 대분류 option들을 셋팅한다.
					*/
					$("#exercise_combination_popup_my_content_tr_modify_exercise_name").change(function(){
						var value = $("#exercise_combination_popup_my_content_tr_modify_exercise_name option:selected").val();
						$("#exercise_combination_popup_my_content_tr_modify").attr("exercise_code", null);
						$("#exercise_combination_popup_my_content_tr_modify_exercise_category").empty();
						$("#exercise_combination_popup_my_content_tr_modify_exercise_category").append("<option>대분류</option>");
						$("#exercise_combination_popup_my_content_tr_modify_exercise_detail_name").empty();
						$("#exercise_combination_popup_my_content_tr_modify_exercise_detail_name").append("<option>동작명</option>");
						$("#exercise_combination_popup_my_content_tr_modify_exercise_time").text("");
						$("#exercise_combination_popup_my_content_tr_modify_exercise_count").text("");
						$("#exercise_combination_popup_my_content_tr_modify_exercise_type").text("");
						if(value != "종목"){
							var Obj = {
								"exercise_name":$("#exercise_combination_popup_my_content_tr_modify_exercise_name option:selected").val(),
								"mode":"exercise_category"
							}
							$.ajax({
								type:"POST",
								url:"/teacher/ready/get_exercise_one",
								data:Obj,
								dataType:"text",
								success:function(string){
									if(string != null){
										var list = JSON.parse(string);
										var node = "";
										for(x=0;x<list.length;x++){
											node += "<option>"+list[x]+"</option>";
										}
										$("#exercise_combination_popup_my_content_tr_modify_exercise_category").append(node);
									}else{
										alert("서버가 불안정합니다.\r다시 시도해주세요");
									}
								},
								error:function(XMLHttpRequest, textStatus, errorThrown){
									alert(errorThrown);
								}
							});
						}
					});

					/*
					 - 수업 구성 관리 - "+ 추가" - 대분류 변경시 이벤트
					 - 해당 운동의 동작명, 갯수, 제한시간(초), 등급, 비고 를 초기화한다.
					 - 변경시킨 옵션값이 "대분류"가 아닌 경우 선택된 종목과 대분류 옵션을 토대로 동작명을 조회하여 동작명 option들을 셋팅한다.
					*/
					$("#exercise_combination_popup_my_content_tr_modify_exercise_category").change(function(){
						var value = $("#exercise_combination_popup_my_content_tr_modify_exercise_category option:selected").val();
						$("#exercise_combination_popup_my_content_tr_modify").attr("exercise_code", null);
						$("#exercise_combination_popup_my_content_tr_modify_exercise_detail_name").empty();
						$("#exercise_combination_popup_my_content_tr_modify_exercise_detail_name").append("<option>동작명</option>");
						$("#exercise_combination_popup_my_content_tr_modify_exercise_time").text("");
						$("#exercise_combination_popup_my_content_tr_modify_exercise_count").text("");
						$("#exercise_combination_popup_my_content_tr_modify_exercise_type").text("");
						if(value != "대분류"){
							Obj = {
								"exercise_name":$("#exercise_combination_popup_my_content_tr_modify_exercise_name option:selected").val(),
								"exercise_category":$("#exercise_combination_popup_my_content_tr_modify_exercise_category option:selected").val(),
								"mode":"exercise_detail_name"
							}
							$.ajax({
								type:"POST",
								url:"/teacher/ready/get_exercise_one",
								data:Obj,
								dataType:"text",
								success:function(string){
									if(string != null){
										var list = JSON.parse(string);
										var node = "";
										for(x=0;x<list.length;x++){
											node += "<option>"+list[x]+"</option>";
										}
										$("#exercise_combination_popup_my_content_tr_modify_exercise_detail_name").append(node);
									}else{
										alert("서버가 불안정합니다.\r다시 시도해주세요");
									}
								},
								error:function(XMLHttpRequest, textStatus, errorThrown){
									alert(errorThrown);
								}
							});
						}
					});

					/*
					 - 수업 구성 관리 - "+ 추가" - 동작명 변경시 이벤트
					 - 해당 운동의 갯수, 제한시간(초), 등급, 비고 를 초기화한다.
					 - 변경시킨 옵션값이 "동작명"이 아닌 경우 선택된 종목과 대분류와 동작명 옵션을 토대로 해당운동 데이터들을 조회하여 갯수, 제한시간(초), 등급을 셋팅한다.
					 - 셋팅한 갯수, 제한시간(초)는 사용자가 커스텀할 수 있다.
					*/
					$("#exercise_combination_popup_my_content_tr_modify_exercise_detail_name").change(function(){
						var value = $("#exercise_combination_popup_my_content_tr_modify_exercise_category option:selected").val();
						$("#exercise_combination_popup_my_content_tr_modify").attr("exercise_code", null);
						$("#exercise_combination_popup_my_content_tr_modify_exercise_time").empty();
						$("#exercise_combination_popup_my_content_tr_modify_exercise_count").empty();
						$("#exercise_combination_popup_my_content_tr_modify_exercise_type").text("");
						if(value != "동작명"){
							Obj = {
								"exercise_name":$("#exercise_combination_popup_my_content_tr_modify_exercise_name option:selected").val(),
								"exercise_category":$("#exercise_combination_popup_my_content_tr_modify_exercise_category option:selected").val(),
								"exercise_detail_name":$("#exercise_combination_popup_my_content_tr_modify_exercise_detail_name option:selected").val(),
								"mode":"one"
							}
							$.ajax({
								type:"POST",
								url:"/teacher/ready/get_exercise_one",
								data:Obj,
								dataType:"text",
								success:function(string){
									if(string != null){
										var obj = JSON.parse(string);
										$("#exercise_combination_popup_my_content_tr_modify").attr("exercise_code", obj["exercise_code"]);
										
										$("#exercise_combination_popup_my_content_tr_modify_exercise_count").append('<input type="number" style="width:100px;" value="'+obj["exercise_count"]+'">');
										$("#exercise_combination_popup_my_content_tr_modify_exercise_time").append('<input type="number" style="width:100px;" value="'+obj["exercise_time"]+'">');
										
										if(obj["exercise_type"] == "0"){
											$("#exercise_combination_popup_my_content_tr_modify_exercise_type").text("평가 가능");
										}else if(obj["exercise_type"] == "1"){
											$("#exercise_combination_popup_my_content_tr_modify_exercise_type").text("과제 가능");
										}else if(obj["exercise_type"] == "2"){
											$("#exercise_combination_popup_my_content_tr_modify_exercise_type").text("평가, 과제 가능");
										}
									}else{
										alert("서버가 불안정합니다.\r다시 시도해주세요");
									}
								},
								error:function(XMLHttpRequest, textStatus, errorThrown){
									alert(errorThrown);
								}
							});
						}
					});

					/*
					 - 수업 구성 관리 - "+ 추가" - 비고 - 등록 버튼 클릭 이벤트
					 - 선택한 종목, 대분류, 동작명들과 갯수, 제한시간(초)들이 정상적이라면 해당 운동셋팅을 저장한다.
					*/
					$("#exercise_combination_popup_my_content_tr_modify_save_btn").off().click(function(){
						var exercise_code_temp = $("#exercise_combination_popup_my_content_tr_modify").attr("exercise_code");
						var exercise_name_temp = $("#exercise_combination_popup_my_content_tr_modify_exercise_name option:selected").val();
						var exercise_category_temp = $("#exercise_combination_popup_my_content_tr_modify_exercise_category option:selected").val();
						var exercise_detail_name_temp = $("#exercise_combination_popup_my_content_tr_modify_exercise_detail_name option:selected").val();
						var exercise_count_temp = $("#exercise_combination_popup_my_content_tr_modify_exercise_count").children("input").val();
						var exercise_time_temp = $("#exercise_combination_popup_my_content_tr_modify_exercise_time").children("input").val();
						var exercise_type_temp = $("#exercise_combination_popup_my_content_tr_modify_exercise_type").text();

						if(exercise_name_temp.length < 2){
							alert("종목명을 선택해주세요");
							return;
						}
						if(exercise_category_temp.length < 2){
							alert("대분류를 선택해주세요");
							return;
						}
						if(exercise_detail_name_temp.length < 2){
							alert("동작명을 선택해주세요");
							return;
						}
						if(exercise_code_temp != null && exercise_code_temp != null && exercise_code_temp != null && exercise_code_temp != null){
							if(exercise_code_temp.length == null || exercise_count_temp.length == null || exercise_time_temp.length == 0 || exercise_type_temp.length == 0){
								alert("작성중인 동작정보를 완성해주세요");
								return;
							}
							if(exercise_time_temp.length < 1 || exercise_time_temp.length > 4){
								alert("제한시간을 초단위로 1 ~ 4자리로 적어주세요");
								return;
							}
							if(exercise_count_temp.length < 1 || exercise_count_temp.length > 3){
								alert("개수를 1 ~ 3자리로 적어주세요");
								return;
							}
						}else{
							alert("작성중인 동작정보를 완성해주세요");
							return;
						}

						var node = "";
						node += '<tr class="exercise_combination_popup_my_content_tr" exercise_code="'+exercise_code_temp+'">';
						node += '<td>'+exercise_name_temp+'</td>';
						node += '<td>'+exercise_category_temp+'</td>';
						node += '<td>'+exercise_detail_name_temp+'</td>';
						node += '<td>'+exercise_count_temp+'</td>';
						node += '<td>'+exercise_time_temp+'초</td>';
						node += '<td>'+exercise_type_temp+'</td>';
						node += '<td><button class="exercise_combination_popup_content_tr_delete_btn">삭제하기</button></td>';

						$("#exercise_combination_popup_my_content_tr_modify").remove();
						$("#exercise_combination_popup_my_content_table").append(node);

						$(".exercise_combination_popup_content_tr_delete_btn").click(function(){
							$(this).parent().parent().remove();
						});
					});

				}else{
					alert("최대 5개까지 등록 가능합니다.");
					return;
				}
			}
		});

		/*
		 - 수업 구성 관리 팝업의 닫기(X) 버튼 클릭 또는 뒤로가기 버튼 클릭시 해당 팝업을 끈다.
		*/
		$("#exercise_combination_popup_close, #exercise_combination_popup_close1, #exercise_combination_popup_close2").click(function(){
			$("#exercise_combination_popup").css("display","none");
			$("#curriculum_detail_popup").css("display", "block");
			curriculum_detail_popup_content_set_btn = null;
		});

		$("#exercise_combination_popup_close").click(function(){
			$("#exercise_combination_popup").css("display","none");
			$("#curriculum_detail_popup").css("display", "block");
			curriculum_detail_popup_content_set_btn = null;
		});
		$("#exercise_combination_popup_close").click(function(){
			$("#exercise_combination_popup").css("display","none");
			$("#curriculum_detail_popup").css("display", "block");
			curriculum_detail_popup_content_set_btn = null;
		});

		/* 추천 조합 관련(사용안함) */
		$("#exercise_combination_popup_content_box1_btn").click(function(){
			if(!$(this).hasClass("active")){
				$(this).addClass("active");
				$("#exercise_combination_popup_content_box2_btn").removeClass("active");
				$("#exercise_combination_popup_content_box2").addClass("hidden_box");
				$("#exercise_combination_popup_content_box1").removeClass("hidden_box");
			}
		});

		/* 추천 조합 관련(사용안함) */
		$("#exercise_combination_popup_content_box2_btn").click(function(){
			if(!$(this).hasClass("active")){
				$(this).addClass("active");
				$("#exercise_combination_popup_content_box1_btn").removeClass("active");
				$("#exercise_combination_popup_content_box1").addClass("hidden_box");
				$("#exercise_combination_popup_content_box2").removeClass("hidden_box");
			}
		});

		/*
		 - 기존 파일 삭제(수정모드일 경우 이전에 저장한 참고자료)
		 - 삭제 배열에 삭제시킬 파일 경로 저장
		*/
		$(".curriculum_file_base").click(function(){
			deleteFile.push("/resources/class_file/"+$(this).text());
			$(this).parent('div').remove();
		});

		/*
		 - 참고자료 등록하기 이벤트(확장자 체크, 개수체크)
		 - 정상 파일일 경우 전역변수에 저장
		*/
		$('#curriculum_detail_popup_files').off().change(function(){
			const target = document.getElementsByName('curriculum_file[]');
			var stop = false;
			$.each(target[0].files, function(index, file){
				if($("#curriculum_detail_popup_files_box").children("div").length > 4){
					if(!stop){
						alert("최대 등록 파일은 5개 입니다.");
						stop = true;
					}
				}else{
					if(!stop){
						const fileName = file.name;
						const fileEx = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length).toLowerCase();
						if(fileEx != "jpg" && fileEx != "png" && fileEx != "pdf" && fileEx != "jpeg"){
							alert("파일은 (jpg, png, pdf, jpeg) 형식만 등록 가능합니다.");
							return false;
						}else{
							$("#curriculum_detail_popup_files_box").append('<div style="float:left; width:100%;"><li class="curriculum_file" style="float:left; ">'+fileName+'</li></div>');

							fileBuffer.push(file);
						}
					}
				}
			});
			$('#curriculum_detail_popup_files').val("");

			/*
			 - 신규 파일 삭제(셋팅중 추가시킨 참고자료)
			 - 업로드파일 배열내부 삭제시킬 파일 제거
			*/
			$(".curriculum_file").off().click(function(){
				for(x=0;x<fileBuffer.length;x++){
					if(fileBuffer[x]["name"] == $(this).text()){
						fileBuffer.splice(x,1);
					}
				}
				$(this).parent('div').remove();
			});
		});
		
		
		/* 전체형, 맞춤형 수업 radio */
		$(".curriculum_detail_radio").click(function(){
			var value = $(this).attr("value");
			// 전체형 수업
			if(value == "0"){
				$("#group_content_box").addClass("hidden_box");
				type = "one";
			}else if(value == "1"){	//맞춤형 수업
				$("#group_content_box").removeClass("hidden_box");
				type = "group";
			}	
		});
		
		
		/* 수업구성, 유튜브영상, 수업 관련링크 + - 클릭 이벤트 */
		$("#curriculum_detail_popup_content_add1").click(function(){
			$("#curriculum_detail_popup_content_name2").val("이론수업").prop("selected", true);
			$("#curriculum_detail_popup_content_test2").val("평가방식").prop("selected",true);
			$("#curriculum_detail_popup_content_test2").addClass("hidden_box");
			$("#curriculum_detail_popup_content_set_btn2").addClass("hidden_box");
			$("#curriculum_detail_popup_content_type2").val("안전").prop("selected",true);
			$("#curriculum_detail_popup_content_add1").addClass("hidden_box");
			$("#curriculum_detail_popup_content2").removeClass("hidden_box");
			$("#curriculum_detail_popup_content_add2").removeClass("hidden_box");
			$("#curriculum_detail_popup_content_remove2").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_content_add2").click(function(){
			$("#curriculum_detail_popup_content_name3").val("이론수업").prop("selected", true);
			$("#curriculum_detail_popup_content_test3").val("평가방식").prop("selected",true);
			$("#curriculum_detail_popup_content_test3").addClass("hidden_box");
			$("#curriculum_detail_popup_content_set_btn3").addClass("hidden_box");
			$("#curriculum_detail_popup_content_type3").val("안전").prop("selected",true);
			$("#curriculum_detail_popup_content_add2").addClass("hidden_box");
			$("#curriculum_detail_popup_content_remove2").addClass("hidden_box");
			$("#curriculum_detail_popup_content3").removeClass("hidden_box");
			$("#curriculum_detail_popup_content_add3").removeClass("hidden_box");
			$("#curriculum_detail_popup_content_remove3").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_content_add3").click(function(){
			$("#curriculum_detail_popup_content_name4").val("이론수업").prop("selected", true);
			$("#curriculum_detail_popup_content_test4").val("평가방식").prop("selected",true);
			$("#curriculum_detail_popup_content_test4").addClass("hidden_box");
			$("#curriculum_detail_popup_content_set_btn4").addClass("hidden_box");
			$("#curriculum_detail_popup_content_type4").val("안전").prop("selected",true);
			$("#curriculum_detail_popup_content_add3").addClass("hidden_box");
			$("#curriculum_detail_popup_content_remove3").addClass("hidden_box");
			$("#curriculum_detail_popup_content4").removeClass("hidden_box");
			$("#curriculum_detail_popup_content_add4").removeClass("hidden_box");
			$("#curriculum_detail_popup_content_remove4").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_content_add4").click(function(){
			$("#curriculum_detail_popup_content_name5").val("이론수업").prop("selected", true);
			$("#curriculum_detail_popup_content_test5").val("평가방식").prop("selected",true);
			$("#curriculum_detail_popup_content_test5").addClass("hidden_box");
			$("#curriculum_detail_popup_content_set_btn5").addClass("hidden_box");
			$("#curriculum_detail_popup_content_type5").val("안전").prop("selected",true);
			$("#curriculum_detail_popup_content_add4").addClass("hidden_box");
			$("#curriculum_detail_popup_content_remove4").addClass("hidden_box");
			$("#curriculum_detail_popup_content5").removeClass("hidden_box");
			$("#curriculum_detail_popup_content_add5").removeClass("hidden_box");
			$("#curriculum_detail_popup_content_remove5").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_content_remove2").click(function(){
			$("#curriculum_detail_popup_content_add1").removeClass("hidden_box");
			$("#curriculum_detail_popup_content2").addClass("hidden_box");
			$(".curriculum_detail_content_list").eq(1).empty();
			$(".curriculum_detail_content_list").eq(1).addClass("hidden_box");
		});
		$("#curriculum_detail_popup_content_remove3").click(function(){
			$("#curriculum_detail_popup_content_add2").removeClass("hidden_box");
			$("#curriculum_detail_popup_content_remove2").removeClass("hidden_box");
			$("#curriculum_detail_popup_content3").addClass("hidden_box");
			$(".curriculum_detail_content_list").eq(2).empty();
			$(".curriculum_detail_content_list").eq(2).addClass("hidden_box");
		});
		$("#curriculum_detail_popup_content_remove4").click(function(){
			$("#curriculum_detail_popup_content_add3").removeClass("hidden_box");
			$("#curriculum_detail_popup_content_remove3").removeClass("hidden_box");
			$("#curriculum_detail_popup_content4").addClass("hidden_box");
			$(".curriculum_detail_content_list").eq(3).empty();
			$(".curriculum_detail_content_list").eq(3).addClass("hidden_box");
		});
		$("#curriculum_detail_popup_content_remove5").click(function(){
			$("#curriculum_detail_popup_content_add4").removeClass("hidden_box");
			$("#curriculum_detail_popup_content_remove4").removeClass("hidden_box");
			$("#curriculum_detail_popup_content5").addClass("hidden_box");
			$(".curriculum_detail_content_list").eq(4).empty();
			$(".curriculum_detail_content_list").eq(4).addClass("hidden_box");
		});
		$("#curriculum_detail_popup_youtube_add1").click(function(){
			$("#curriculum_detail_popup_youtube_name2").val("");
			$("#curriculum_detail_popup_youtube_link2").val("");
			$("#curriculum_detail_popup_youtube_add1").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube2").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_add2").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove2").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_youtube_add2").click(function(){
			$("#curriculum_detail_popup_youtube_name3").val("");
			$("#curriculum_detail_popup_youtube_link3").val("");
			$("#curriculum_detail_popup_youtube_add2").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove2").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube3").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_add3").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove3").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_youtube_add3").click(function(){
			$("#curriculum_detail_popup_youtube_name4").val("");
			$("#curriculum_detail_popup_youtube_link4").val("");
			$("#curriculum_detail_popup_youtube_add3").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove3").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube4").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_add4").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove4").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_youtube_add4").click(function(){
			$("#curriculum_detail_popup_youtube_name5").val("");
			$("#curriculum_detail_popup_youtube_link5").val("");
			$("#curriculum_detail_popup_youtube_add4").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove4").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube5").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_add5").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove5").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_youtube_add5").click(function(){
			$("#curriculum_detail_popup_youtube_name6").val("");
			$("#curriculum_detail_popup_youtube_link6").val("");
			$("#curriculum_detail_popup_youtube_add5").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove5").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube6").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_add6").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove6").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_youtube_add6").click(function(){
			$("#curriculum_detail_popup_youtube_name7").val("");
			$("#curriculum_detail_popup_youtube_link7").val("");
			$("#curriculum_detail_popup_youtube_add6").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove6").addClass("hidden_box");
			$("#curriculum_detail_popup_youtube7").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove7").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_etc_add1").click(function(){
			$("#curriculum_detail_popup_etc_name2").val("");
			$("#curriculum_detail_popup_etc_link2").val("");
			$("#curriculum_detail_popup_etc_add1").addClass("hidden_box");
			$("#curriculum_detail_popup_etc2").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_add2").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove2").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_etc_add2").click(function(){
			$("#curriculum_detail_popup_etc_name3").val("");
			$("#curriculum_detail_popup_etc_link3").val("");
			$("#curriculum_detail_popup_etc_add2").addClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove2").addClass("hidden_box");
			$("#curriculum_detail_popup_etc3").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_add3").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove3").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_etc_add3").click(function(){
			$("#curriculum_detail_popup_etc_name4").val("");
			$("#curriculum_detail_popup_etc_link4").val("");
			$("#curriculum_detail_popup_etc_add3").addClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove3").addClass("hidden_box");
			$("#curriculum_detail_popup_etc4").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_add4").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove4").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_etc_add4").click(function(){
			$("#curriculum_detail_popup_etc_name5").val("");
			$("#curriculum_detail_popup_etc_link5").val("");
			$("#curriculum_detail_popup_etc_add4").addClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove4").addClass("hidden_box");
			$("#curriculum_detail_popup_etc5").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_add5").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove5").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_etc_add5").click(function(){
			$("#curriculum_detail_popup_etc_name6").val("");
			$("#curriculum_detail_popup_etc_link6").val("");
			$("#curriculum_detail_popup_etc_add5").addClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove5").addClass("hidden_box");
			$("#curriculum_detail_popup_etc6").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_add6").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove6").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_etc_add6").click(function(){
			$("#curriculum_detail_popup_etc_name7").val("");
			$("#curriculum_detail_popup_etc_link7").val("");
			$("#curriculum_detail_popup_etc_add6").addClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove6").addClass("hidden_box");
			$("#curriculum_detail_popup_etc7").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove7").removeClass("hidden_box");
		});
		$("#curriculum_detail_popup_youtube_remove2").click(function(){
			$("#curriculum_detail_popup_youtube_add1").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube2").addClass("hidden_box");
		});
		$("#curriculum_detail_popup_youtube_remove3").click(function(){
			$("#curriculum_detail_popup_youtube_add2").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove2").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube3").addClass("hidden_box");
		});
		$("#curriculum_detail_popup_youtube_remove4").click(function(){
			$("#curriculum_detail_popup_youtube_add3").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove3").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube4").addClass("hidden_box");
		});
		$("#curriculum_detail_popup_youtube_remove5").click(function(){
			$("#curriculum_detail_popup_youtube_add4").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove4").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube5").addClass("hidden_box");
		});
		$("#curriculum_detail_popup_youtube_remove6").click(function(){
			$("#curriculum_detail_popup_youtube_add5").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove5").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube6").addClass("hidden_box");
		});
		$("#curriculum_detail_popup_youtube_remove7").click(function(){
			$("#curriculum_detail_popup_youtube_add6").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube_remove6").removeClass("hidden_box");
			$("#curriculum_detail_popup_youtube7").addClass("hidden_box");
		});
		$("#curriculum_detail_popup_etc_remove2").click(function(){
			$("#curriculum_detail_popup_etc_add1").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc2").addClass("hidden_box");
		});
		$("#curriculum_detail_popup_etc_remove3").click(function(){
			$("#curriculum_detail_popup_etc_add2").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove2").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc3").addClass("hidden_box");
		});
		$("#curriculum_detail_popup_etc_remove4").click(function(){
			$("#curriculum_detail_popup_etc_add3").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove3").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc4").addClass("hidden_box");
		});
		$("#curriculum_detail_popup_etc_remove5").click(function(){
			$("#curriculum_detail_popup_etc_add4").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove4").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc5").addClass("hidden_box");
		});
		$("#curriculum_detail_popup_etc_remove6").click(function(){
			$("#curriculum_detail_popup_etc_add5").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove5").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc6").addClass("hidden_box");
		});
		$("#curriculum_detail_popup_etc_remove7").click(function(){
			$("#curriculum_detail_popup_etc_add6").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc_remove6").removeClass("hidden_box");
			$("#curriculum_detail_popup_etc7").addClass("hidden_box");
		});
		
		
		
		/*
		 - 수업 구성 필드의 첫번째 셀렉트박스(수업타입) 변경시 이벤트
		 - 이론수업 : 평가방식 셀렉트박스 숨기기, 콘텐츠 선택 버튼 숨기기
		 - 실습수업 : 평가방식 셀렉트박스 숨기기, 콘텐츠 선택 버튼 보이기
		 - 평가수업 : 평가방식 셀렉트박스 보이기, 콘텐츠 선택 버튼 보이기
		*/

		$("#curriculum_detail_popup_content_name1").on('change', function(){
			if($("#curriculum_detail_popup_content_name1 option:selected").val() == "평가수업"){
				$("#curriculum_detail_popup_content_test1").val("평가방식").prop("selected", true);
				$("#curriculum_detail_popup_content_test1").removeClass("hidden_box");
				$("#curriculum_detail_popup_content_set_btn1").removeClass("hidden_box");
			}else{
				$("#curriculum_detail_popup_content_set_btn1").removeClass("hidden_box");
				$("#curriculum_detail_popup_content_test1").addClass("hidden_box");
			}
			if($("#curriculum_detail_popup_content_name1 option:selected").val() == "이론수업"){
				$("#curriculum_detail_popup_content_set_btn1").addClass("hidden_box");
				$(".curriculum_detail_content_list").eq(0).addClass("hidden_box");
			}else{
				$(".curriculum_detail_content_list").eq(0).removeClass("hidden_box");
			}
		});
		
		$("#curriculum_detail_popup_content_name2").on('change', function(){
			if($("#curriculum_detail_popup_content_name2 option:selected").val() == "평가수업"){
				$("#curriculum_detail_popup_content_test2").val("평가방식").prop("selected", true);
				$("#curriculum_detail_popup_content_test2").removeClass("hidden_box");
				$("#curriculum_detail_popup_content_set_btn2").removeClass("hidden_box");
			}else{
				$("#curriculum_detail_popup_content_set_btn2").removeClass("hidden_box");
				$("#curriculum_detail_popup_content_test2").addClass("hidden_box");
			}
			if($("#curriculum_detail_popup_content_name2 option:selected").val() == "이론수업"){
				$("#curriculum_detail_popup_content_set_btn2").addClass("hidden_box");
				$(".curriculum_detail_content_list").eq(1).addClass("hidden_box");
			}else{
				$(".curriculum_detail_content_list").eq(1).removeClass("hidden_box");
			}
		});
		$("#curriculum_detail_popup_content_name3").on('change', function(){
			if($("#curriculum_detail_popup_content_name3 option:selected").val() == "평가수업"){
				$("#curriculum_detail_popup_content_test3").val("평가방식").prop("selected", true);
				$("#curriculum_detail_popup_content_test3").removeClass("hidden_box");
				$("#curriculum_detail_popup_content_set_btn3").removeClass("hidden_box");
			}else{
				$("#curriculum_detail_popup_content_set_btn3").removeClass("hidden_box");
				$("#curriculum_detail_popup_content_test3").addClass("hidden_box");
			}
			if($("#curriculum_detail_popup_content_name3 option:selected").val() == "이론수업"){
				$("#curriculum_detail_popup_content_set_btn3").addClass("hidden_box");
				$(".curriculum_detail_content_list").eq(2).addClass("hidden_box");
			}else{
				$(".curriculum_detail_content_list").eq(2).removeClass("hidden_box");
			}
		});
		$("#curriculum_detail_popup_content_name4").on('change', function(){
			if($("#curriculum_detail_popup_content_name4 option:selected").val() == "평가수업"){
				$("#curriculum_detail_popup_content_test4").val("평가방식").prop("selected", true);
				$("#curriculum_detail_popup_content_test4").removeClass("hidden_box");
				$("#curriculum_detail_popup_content_set_btn4").removeClass("hidden_box");
			}else{
				$("#curriculum_detail_popup_content_set_btn4").removeClass("hidden_box");
				$("#curriculum_detail_popup_content_test4").addClass("hidden_box");
			}
			if($("#curriculum_detail_popup_content_name4 option:selected").val() == "이론수업"){
				$("#curriculum_detail_popup_content_set_btn4").addClass("hidden_box");
				$(".curriculum_detail_content_list").eq(3).addClass("hidden_box");
			}else{
				$(".curriculum_detail_content_list").eq(3).removeClass("hidden_box");
			}
		});
		$("#curriculum_detail_popup_content_name5").on('change', function(){
			if($("#curriculum_detail_popup_content_name5 option:selected").val() == "평가수업"){
				$("#curriculum_detail_popup_content_test5").val("평가방식").prop("selected", true);
				$("#curriculum_detail_popup_content_test5").removeClass("hidden_box");
				$("#curriculum_detail_popup_content_set_btn5").removeClass("hidden_box");
			}else{
				$("#curriculum_detail_popup_content_set_btn5").removeClass("hidden_box");
				$("#curriculum_detail_popup_content_test5").addClass("hidden_box");
			}
			if($("#curriculum_detail_popup_content_name5 option:selected").val() == "이론수업"){
				$("#curriculum_detail_popup_content_set_btn5").addClass("hidden_box");
				$(".curriculum_detail_content_list").eq(4).addClass("hidden_box");
			}else{
				$(".curriculum_detail_content_list").eq(4).removeClass("hidden_box");
			}
		});
		
		/*
		 - 그룹설정 팝업 버튼 클릭 이벤트
		 - 그룹관리 팝업이 보여진다.
		 - 기존에 그룹, 그룹별 학생이 셋팅된 상태라면 팝업셋팅후 보여진다.
		*/
		$("#unit_group_setting_btn").click(function(){
			
			$("#group_add_btn").removeClass("hidden_box");
			$(".group-edit").css("display","none");
			$(".group-edit_input").val("");
			
			// 그룹셋팅
			var people_max_count = ${people_max_count};
			var node = "";
			
			/* 학생번호 셋팅 */
			$(".group_setting_student_box").remove();
			if(student_info != null){
				for(x=0;x<student_info.length;x++){
					node += '<li class="group_setting_student_box" id="'+(student_info[x]["student_id"])+'">'
					+student_info[x]["student_school"]+' '+student_info[x]["student_level"]+'학년 '+student_info[x]["student_class"]+'반 '+student_info[x]["student_number"]+'번 '+student_info[x]["student_name"]+'</li>'
				}	
			}else{
				alert("클래스에 참여중인 학생이 없습니다.");
				return;
				
			}
			$("#group_setting_student_list").append(node);
			

			$("#group_div_sex_btn").removeClass("active");
			$("#group_div_dir_btn").addClass("active");
			
			/* 그룹명 셋팅 */
			
			$(".group_box").eq(0).empty();
			$(".group_box").eq(0).addClass("active");
			$(".group_box").eq(0).attr("unit_group_name", "1그룹");
			$(".group_box").eq(0).text("1그룹");
			$(".group_box").eq(0).append('<span class="group_setting_name_remove close">x</span>');
			$(".group_box").eq(1).empty();
			$(".group_box").eq(1).removeClass("active");
			$(".group_box").eq(1).attr("unit_group_name", "2그룹");
			$(".group_box").eq(1).text("2그룹");
			$(".group_box").eq(1).append('<span class="group_setting_name_remove close">x</span>');
			for(x=2;x<$(".group_box").length;x++){
				$(".group_box").eq(x).remove();
				x--;
			}
			
			
			for(x=0;x<$(".unit_group_name_option").length;x++){
				var this_option = $(".unit_group_name_option").eq(x);
				if(this_option.attr("unit_group_name") != null && this_option.attr("unit_group_id_list") != null){
					var unit_group_name = this_option.attr("unit_group_name")
					var unit_group_id_list = JSON.parse(this_option.attr("unit_group_id_list"));
					
					for(xx=0;xx<$(".group_setting_student_box").length;xx++){
						var id = $(".group_setting_student_box").eq(xx).attr("id");
						if(unit_group_id_list.includes(id)){
							if(x==0){
								$(".group_setting_student_box").eq(xx).addClass("active");
								$(".group_setting_student_box").eq(xx).attr("unit_group_name", unit_group_name);
								$(".group_setting_student_box").eq(xx).append("<span> · "+unit_group_name+"</span>");
							}else{
								$(".group_setting_student_box").eq(xx).attr("unit_group_name", unit_group_name);
								$(".group_setting_student_box").eq(xx).append("<span> · "+unit_group_name+"</span>");	
							}
						}
					}
					if(x==0){
						$(".group_box").eq(0).empty();
						$(".group_box").eq(0).attr("unit_group_name", unit_group_name);
						$(".group_box").eq(0).text(unit_group_name);
						$(".group_box").eq(0).append('<span class="group_setting_name_remove close">x</span>');
					}else if(x==1){
						$(".group_box").eq(1).empty();
						$(".group_box").eq(1).attr("unit_group_name", unit_group_name);
						$(".group_box").eq(1).text(unit_group_name);
						$(".group_box").eq(1).append('<span class="group_setting_name_remove close">x</span>');
					}else{
						$(".group_box").eq($(".group_box").length-1).after('<li class="group_box" unit_group_name="'+unit_group_name+'">'+unit_group_name+'<span class="group_setting_name_remove close">x</span></li>');
					}
				}
			}
			
			for(xx=0;xx<$(".group_setting_student_box").length;xx++){
				if($(".group_setting_student_box").eq(xx).attr("unit_group_name") != null){
					if(!$(".group_setting_student_box").eq(xx).hasClass("active")){
						$(".group_setting_student_box").eq(xx).addClass("disabled");
					}
				}
			}
			
			// 학생 그룹지정 이벤트
			$(".group_setting_student_box").off().click(function(){
				if(!$(this).hasClass("disabled")){
					if($(this).hasClass("active")){
						//그룹선택 취소
						$(this).removeClass("active");
						$(this).attr("unit_group_name", null);
						$(this).children("span").remove();
					}else{
						//그룹선택
						var group = null;
						for(x=0;x<$(".group_box").length;x++){
							if($(".group_box").eq(x).hasClass("active")){
								group = $(".group_box").eq(x).attr("unit_group_name");
							}
						}
						$(this).addClass("active");
						$(this).attr("unit_group_name", group);
						$(this).append('<span> · '+group+'</span>');
					}
				}
			});
			
			// 그룹 선택 이벤트
			$("#group_box_parent").off().on("click", ".group_box", function(){
				if(!$(this).hasClass("active")){
					$(".group_box").removeClass("active");
					$(this).addClass("active");
					
					var group = null;
					for(x=0;x<$(".group_box").length;x++){
						if($(".group_box").eq(x).hasClass("active")){
							group = $(".group_box").eq(x).attr("unit_group_name");
						}
					}
					$(".group_setting_student_box").removeClass("active");
					$(".group_setting_student_box").removeClass("disabled");
					for(x=0;x<$(".group_setting_student_box").length;x++){
						if($(".group_setting_student_box").eq(x).attr("unit_group_name") != null){
							if($(".group_setting_student_box").eq(x).attr("unit_group_name") == group){
								$(".group_setting_student_box").eq(x).addClass("active");
							}else{
								$(".group_setting_student_box").eq(x).addClass("disabled");
							}
						}
					}
				}
			});
			
			
			
			
			// 남/여 나누기 버튼
			$("#group_div_sex_btn").off().click(function(){
				if(!$(this).hasClass("active")){
					
					$(".group_setting_student_box").remove();
					
					var node = "";
					if(student_info != null){
						for(x=0;x<student_info.length;x++){
							node += '<li class="group_setting_student_box" id="'+(student_info[x]["student_id"])+'">'
							+student_info[x]["student_school"]+' '+student_info[x]["student_level"]+'학년 '+student_info[x]["student_class"]+'반 '+student_info[x]["student_number"]+'번 '+student_info[x]["student_name"]+'</li>'
						}	
					}else{
						alert("클래스에 참여중인 학생이 없습니다.");
						return;
						
					}
					$("#group_setting_student_list").append(node);
					
					$(".group_box").eq(0).empty();
					$(".group_box").eq(0).attr("unit_group_name", "남자그룹");
					$(".group_box").eq(0).addClass("active");
					$(".group_box").eq(0).text("남자그룹");
					$(".group_box").eq(1).empty();
					$(".group_box").eq(1).attr("unit_group_name", "여자그룹");
					$(".group_box").eq(1).removeClass("active");
					$(".group_box").eq(1).text("여자그룹");
					for(x=2;x<$(".group_box").length;x++){
						$(".group_box").eq(x).remove();
						x--;
					}
					
					$("#group_add_btn").addClass("hidden_box");
					$(".group-edit").css("display", "none");
					$("#group-edit_input").val("");
					
					$(this).addClass("active");
					$("#group_div_dir_btn").removeClass("active");
					
					// 남/여 나누기에서 학생 그룹지정 이벤트
					$(".group_setting_student_box").off().click(function(){
						if(!$(this).hasClass("disabled")){
							if($(this).hasClass("active")){
								//그룹선택 취소
								$(this).removeClass("active");
								$(this).attr("unit_group_name", null);
								$(this).children("span").remove();
							}else{
								//그룹선택
								var group = null;
								if($(".group_box").eq(0).hasClass("active")){
									group = "남자그룹";
								}else{
									group = "여자그룹";
								}
								$(this).addClass("active");
								$(this).attr("unit_group_name", group);
								$(this).append('<span> · '+group+'</span>');
							}
						}
					});
					
					// 남/여 나누기에서 그룹 선택 이벤트
					$("#group_box_parent").off().on("click", ".group_box", function(){
						if(!$(this).hasClass("active")){
							$(".group_box").removeClass("active");
							$(this).addClass("active");
							
							if($(".group_box").eq(0).hasClass("active")){
								group = "남자그룹";
							}else{
								group = "여자그룹";
							}
							$(".group_setting_student_box").removeClass("active");
							$(".group_setting_student_box").removeClass("disabled");
							for(x=0;x<$(".group_setting_student_box").length;x++){
								if($(".group_setting_student_box").eq(x).attr("unit_group_name") != null){
									if($(".group_setting_student_box").eq(x).attr("unit_group_name") == group){
										$(".group_setting_student_box").eq(x).addClass("active");
									}else{
										$(".group_setting_student_box").eq(x).addClass("disabled");
									}
								}
							}
						}
					});
				}
			});
			
			// 직접 구성 버튼
			$("#group_div_dir_btn").off().click(function(){
				if(!$(this).hasClass("active")){
					
					$("#group_add_btn").removeClass("hidden_box");
					$(".group-edit").css("display", "none");
					$(".group-edit_input").val("");
					
					$(".group_setting_student_box").remove();
					
					var node = "";
					if(student_info != null){
						for(x=0;x<student_info.length;x++){
							node += '<li class="group_setting_student_box" id="'+(student_info[x]["student_id"])+'">'
							+student_info[x]["student_school"]+' '+student_info[x]["student_level"]+'학년 '+student_info[x]["student_class"]+'반 '+student_info[x]["student_number"]+'번 '+student_info[x]["student_name"]+'</li>'
						}	
					}else{
						alert("클래스에 참여중인 학생이 없습니다.");
						return;
						
					}
					$("#group_setting_student_list").append(node);
					
					$(".group_box").eq(0).empty();
					$(".group_box").eq(0).addClass("active");
					$(".group_box").eq(0).attr("unit_group_name", "1그룹");
					$(".group_box").eq(0).text("1그룹");
					$(".group_box").eq(0).append('<span class="group_setting_name_remove close">x</span>');
					$(".group_box").eq(1).empty();
					$(".group_box").eq(1).removeClass("active");
					$(".group_box").eq(1).attr("unit_group_name", "2그룹");
					$(".group_box").eq(1).text("2그룹");
					$(".group_box").eq(1).append('<span class="group_setting_name_remove close">x</span>');
					
					for(x=2;x<$(".group_box").length;x++){
						$(".group_box").eq(x).remove();
						x--;
					}
					
					for(x=0;x<$(".unit_group_name_option").length;x++){
						var this_option = $(".unit_group_name_option").eq(x);
						if(this_option.attr("unit_group_name") != null && this_option.attr("unit_group_id_list") != null){
							var unit_group_name = this_option.attr("unit_group_name")
							var unit_group_id_list = JSON.parse(this_option.attr("unit_group_id_list"));
							
							for(xx=0;xx<$(".group_setting_student_box").length;xx++){
								var id = $(".group_setting_student_box").eq(xx).attr("id");
								if(unit_group_id_list.includes(id)){
									if(x==0){
										$(".group_setting_student_box").eq(xx).addClass("active");
										$(".group_setting_student_box").eq(xx).attr("unit_group_name", unit_group_name);
										$(".group_setting_student_box").eq(xx).append("<span> · "+unit_group_name+"</span>");
									}else{
										$(".group_setting_student_box").eq(xx).attr("unit_group_name", unit_group_name);
										$(".group_setting_student_box").eq(xx).append("<span> · "+unit_group_name+"</span>");	
									}
								}
							}
							if(x==0){
								$(".group_box").eq(0).empty();
								$(".group_box").eq(0).attr("unit_group_name", unit_group_name);
								$(".group_box").eq(0).text(unit_group_name);
								$(".group_box").eq(0).append('<span class="group_setting_name_remove close">x</span>');
							}else if(x==1){
								$(".group_box").eq(1).empty();
								$(".group_box").eq(1).attr("unit_group_name", unit_group_name);
								$(".group_box").eq(1).text(unit_group_name);
								$(".group_box").eq(1).append('<span class="group_setting_name_remove close">x</span>');
							}else{
								$(".group_box").eq($(".group_box").length-1).after('<li class="group_box" unit_group_name="'+unit_group_name+'">'+unit_group_name+'<span class="group_setting_name_remove close">x</span></li>');
							}
						}
					}
					
					
					for(xx=0;xx<$(".group_setting_student_box").length;xx++){
						if($(".group_setting_student_box").eq(xx).attr("unit_group_name") != null){
							if(!$(".group_setting_student_box").eq(xx).hasClass("active")){
								$(".group_setting_student_box").eq(xx).addClass("disabled");
							}
						}
					}
					
					$(this).addClass("active");
					$("#group_div_sex_btn").removeClass("active");
					
					// 학생 그룹지정 이벤트
					$(".group_setting_student_box").off().click(function(){
						if(!$(this).hasClass("disabled")){
							if($(this).hasClass("active")){
								//그룹선택 취소
								$(this).removeClass("active");
								$(this).attr("unit_group_name", null);
								$(this).children("span").remove();
							}else{
								//그룹선택
								var group = null;
								for(x=0;x<$(".group_box").length;x++){
									if($(".group_box").eq(x).hasClass("active")){
										group = $(".group_box").eq(x).attr("unit_group_name");
									}
								}
								$(this).addClass("active");
								$(this).attr("unit_group_name", group);
								$(this).append('<span> · '+group+'</span>');
							}
						}
					});
					
					// 그룹 선택 이벤트
					$("#group_box_parent").off().on("click", ".group_box", function(){
						
						if(!$(this).hasClass("active")){
							$(".group_box").removeClass("active");
							$(this).addClass("active");
							
							var group = null;
							for(x=0;x<$(".group_box").length;x++){
								if($(".group_box").eq(x).hasClass("active")){
									group = $(".group_box").eq(x).attr("unit_group_name");
								}
							}
							$(".group_setting_student_box").removeClass("active");
							$(".group_setting_student_box").removeClass("disabled");
							for(x=0;x<$(".group_setting_student_box").length;x++){
								if($(".group_setting_student_box").eq(x).attr("unit_group_name") != null){
									if($(".group_setting_student_box").eq(x).attr("unit_group_name") == group){
										$(".group_setting_student_box").eq(x).addClass("active");
									}else{
										$(".group_setting_student_box").eq(x).addClass("disabled");
									}
								}
							}
						}
					});
					
					$(".group_setting_name_remove").off().click(function(){
						if($(".group_box").length < 3){
							alert("그룹은 2개이상 있어야합니다.");
							return;
						}
						var group = $(this).parent("li").attr("unit_group_name");
						
						for(x=0;x<$(".group_setting_student_box").length;x++){
							if($(".group_setting_student_box").eq(x).attr("unit_group_name") != null && $(".group_setting_student_box").eq(x).attr("unit_group_name") == group){
								$(".group_setting_student_box").eq(x).children("span").remove();
								$(".group_setting_student_box").eq(x).attr("unit_group_name", null);
								$(".group_setting_student_box").eq(x).removeClass("active");
								$(".group_setting_student_box").eq(x).removeClass("disabled");
							}
						}
						
						if($(this).parent("li").hasClass("active")){
							$(this).parent("li").remove();
							group = $(".group_box").eq(0).attr("unit_group_name");
							$(".group_box").eq(0).addClass("active");
							
							$(".group_setting_student_box").removeClass("active");
							$(".group_setting_student_box").removeClass("disabled");
							for(x=0;x<$(".group_setting_student_box").length;x++){
								if($(".group_setting_student_box").eq(x).attr("unit_group_name") != null){
									if($(".group_setting_student_box").eq(x).attr("unit_group_name") == group){
										$(".group_setting_student_box").eq(x).addClass("active");
									}else{
										$(".group_setting_student_box").eq(x).addClass("disabled");
									}
								}
							}
						}else{
							$(this).parent("li").remove();
						}			
					});
					
				}
			});
			
			$("#group_add_btn").off().click(function(){
				$(".group-edit").css("display","flex");
				$("#group_add_btn").addClass("hidden_box");
			});
			
			$("#group_push_btn").off().click(function(){
				var group_name = $("#group-edit_input").val();
				
				if(group_name.length < 2 || group_name.length > 10){
					alert("그룹명을 2 ~ 10자로 입력해주세요");
					return;
				}else{
					for(x=0;x<$(".group_box").length;x++){
						if($(".group_box").eq(x).attr("unit_group_name") == group_name){
							alert("중복된 그룹명이 존재합니다.");
							return;
						}
					}
					if($(".group_box").length == 10){
						alert("그룹은 최대 10개까지 생성가능합니다.");
						return;
					}
					
					var node = '<li class="group_box" unit_group_name="'+group_name+'">'+group_name+'<span class="group_setting_name_remove close">x</span></li>';
					$(".group_box").eq($(".group_box").length-1).after(node);
					
					$("#group_add_btn").removeClass("hidden_box");
					$("#group-edit_input").val("");
					$(".group-edit").css("display","none");	
					
					$(".group_setting_name_remove").off().click(function(){
						if($(".group_box").length < 3){
							alert("그룹은 2개이상 있어야합니다.");
							return;
						}
						var group = $(this).parent("li").attr("unit_group_name");
						
						for(x=0;x<$(".group_setting_student_box").length;x++){
							if($(".group_setting_student_box").eq(x).attr("unit_group_name") != null && $(".group_setting_student_box").eq(x).attr("unit_group_name") == group){
								$(".group_setting_student_box").eq(x).children("span").remove();
								$(".group_setting_student_box").eq(x).attr("unit_group_name", null);
								$(".group_setting_student_box").eq(x).removeClass("active");
								$(".group_setting_student_box").eq(x).removeClass("disabled");
							}
						}
						
						if($(this).parent("li").hasClass("active")){
							$(this).parent("li").remove();
							group = $(".group_box").eq(0).attr("unit_group_name");
							$(".group_box").eq(0).addClass("active");
							
							$(".group_setting_student_box").removeClass("active");
							$(".group_setting_student_box").removeClass("disabled");
							for(x=0;x<$(".group_setting_student_box").length;x++){
								if($(".group_setting_student_box").eq(x).attr("unit_group_name") != null){
									if($(".group_setting_student_box").eq(x).attr("unit_group_name") == group){
										$(".group_setting_student_box").eq(x).addClass("active");
									}else{
										$(".group_setting_student_box").eq(x).addClass("disabled");
									}
								}
							}
						}else{
							$(this).parent("li").remove();
						}			
					});
				}
			});
			
			$("#group_pop_btn").off().click(function(){
				$("#group_add_btn").removeClass("hidden_box");
				$("#group-edit_input").val("");
				$(".group-edit").css("display","none");
			});
			
			
			$(".group_setting_name_remove").off().click(function(){
				if($(".group_box").length < 3){
					alert("그룹은 2개이상 있어야합니다.");
					return;
				}
				var group = $(this).parent("li").attr("unit_group_name");
				
				for(x=0;x<$(".group_setting_student_box").length;x++){
					if($(".group_setting_student_box").eq(x).attr("unit_group_name") != null && $(".group_setting_student_box").eq(x).attr("unit_group_name") == group){
						$(".group_setting_student_box").eq(x).children("span").remove();
						$(".group_setting_student_box").eq(x).attr("unit_group_name", null);
						$(".group_setting_student_box").eq(x).removeClass("active");
						$(".group_setting_student_box").eq(x).removeClass("disabled");
					}
				}
				
				if($(this).parent("li").hasClass("active")){
					$(this).parent("li").remove();
					group = $(".group_box").eq(0).attr("unit_group_name");
					$(".group_box").eq(0).addClass("active");
					
					$(".group_setting_student_box").removeClass("active");
					$(".group_setting_student_box").removeClass("disabled");
					for(x=0;x<$(".group_setting_student_box").length;x++){
						if($(".group_setting_student_box").eq(x).attr("unit_group_name") != null){
							if($(".group_setting_student_box").eq(x).attr("unit_group_name") == group){
								$(".group_setting_student_box").eq(x).addClass("active");
							}else{
								$(".group_setting_student_box").eq(x).addClass("disabled");
							}
						}
					}
				}else{
					$(this).parent("li").remove();
				}
			});
			
			$("#group_setting_popup").css("display", "block");
		});
		
		/* 그룹설정 팝업 off */
		$("#grop_setting_popup_close").click(function(){
			$("#group_setting_popup").css("display", "none");
		});
		
		/*
		 - 그룹관리 - 저장하기 버튼 클릭 이벤트
		 - 셋팅한 그룹명을 그룹선택 필드의 셀렉트박스 옵션들로 셋팅
		 - 셋팅한 학생 목록을 그룹선택 필드의 셀렉트박스의 각 옵션들에 속성으로 셋팅
		*/
		$("#group_setting_save").off().click(function(){
			
			//unit_group_name selectbox id
			//unit_group_name_option 추가
			//unit_group_name
			//unit_group_id_list JSON
			var group_name_array = [];
			var group_obj = [];
			for(x=0;x<$(".group_box").length;x++){
				group_name_array.push($(".group_box").eq(x).attr("unit_group_name"));
				group_obj[$(".group_box").eq(x).attr("unit_group_name")] = [];
			}
			
			for(x=0;x<$(".group_setting_student_box").length;x++){
				if($(".group_setting_student_box").eq(x).attr("unit_group_name") != null){
					
					group_obj[$(".group_setting_student_box").eq(x).attr("unit_group_name")].push($(".group_setting_student_box").eq(x).attr("id"));
					
				}else{
					alert($(".group_setting_student_box").eq(x).text() + "님의 그룹을 지정해주세요.");
					return;
				}
			}
			
			for(x=0;x<group_name_array.length;x++){
				if(group_obj[group_name_array[x]].length == 0){
					alert(group_name_array[x]+"그룹의 지정인원이 없습니다.");
					return;
				}
			}
			
			
			$("#unit_group_name option:eq(0)").attr("selected", "selected");
			$("#unit_group_name").change();
			
			var bo = false;
			for(x=0;x<group_name_array.length;x++){
				if($(".unit_group_name_option").eq(x).length > 0){
					$(".unit_group_name_option").eq(x).attr("unit_group_name", group_name_array[x]);
					$(".unit_group_name_option").eq(x).attr("unit_group_id_list", JSON.stringify(group_obj[group_name_array[x]]));
					$(".unit_group_name_option").eq(x).text(group_name_array[x]);
				}else{
					//노드추가
					bo = true;
					$("#unit_group_name").append('<option class="unit_group_name_option" unit_group_name="'+group_name_array[x]+'" unit_group_id_list=\''+JSON.stringify(group_obj[group_name_array[x]])+'\'>'+group_name_array[x]+'</option>');
				}
			}
			
			if(!bo){
				for(x=group_name_array.length;x<$(".unit_group_name_option").length;x++){
					$(".unit_group_name_option").eq(x).remove();
					x--;
				}	
			}
			
			alert("그룹정보가 변경 되었습니다.");
			$("#group_setting_popup").css("display", "none");
			
		});



		/*
		 - 저장하기 버튼 클릭 이벤트
		 - 셋팅한 데이터들을 토대로 차시를 생성한다.
		 - 셋팅 데이터가 그룹이라면 : 그룹 선택 필드의 그룹 셀렉트박스 각 옵션들에 데이터들이 저장되어있으므로 해당 데이터들로 그룹별 차시 구성
		 - 셋팅 데이터가 그룹이 아니라면 : 화면상 보여지는 데이터들로 차시를 구성
		*/
		$("#curriculum_detail_popup_save_btn").click(function(){
			
			var unit_code = null;	// modify 일때 unit_code를 통해 테이블을 지워야함
			var class_code = "${class_code}";
			var unit_class_type = "0";
			var unit_group_name = null;
			var unit_group_id_list = null;
			var unit_class_name = $("#unit_class_name").val();
			var unit_class_text = null;
			var unit_start_date = null;
			var unit_end_date = null;
			var unit_youtube_url = null;
			var unit_content_url = null;
			var unit_attached_file = null;	//테이블에 삽입할 파일경로배열
			var delete_file = null;	//삭제할 파일경로
			var files = null;
			var content_code_list = null;
			var content_home_work = null;
			var content_test = null;
			var content_evaluation_type = null;
			var formData = new FormData();
			
			if(unit_class_name.length < 2 || unit_class_name.length > 50){
				alert("수업명을 2 ~ 50자로 입력해주세요.");
				return;
			}
			if($("#from").val().length != 10 || $("#from_hour option:selected").val() == "시" || $("#from_min option:selected").val() == "분"){
				alert("수업일시를 입력해주세요.");
				return;
			}
			unit_start_date = $("#from").val().substring(6, 10) + $("#from").val().substring(0, 2) + $("#from").val().substring(3, 5) + $("#from_hour option:selected").val() + $("#from_min option:selected").val();
			if($("#to").val().length != 10 || $("#to_hour option:selected").val() == "시" || $("#to_min option:selected").val() == "분"){
				alert("수업일시를 입력해주세요.");
				return;
			}
			unit_end_date = $("#to").val().substring(6, 10) + $("#to").val().substring(0, 2) + $("#to").val().substring(3, 5) + $("#to_hour option:selected").val() + $("#to_min option:selected").val();

			if($("#curriculum_detail_popup_unit_class_text").val().length < 2 || $("#curriculum_detail_popup_unit_class_text").length > 2000){
				alert("수업 내용을 2 ~ 2000자로 입력해 주세요.");
				return;
			}

			if(type == "group"){
				// 2. 맞춤형 수업일경우 ( 그룹있음 )

				$("#unit_group_name option:eq(0)").attr("selected", "selected");
				$("#unit_group_name").change();

				unit_class_type = "1";

				/* 그룹이름 및 참여인원 검증 */
				var temp_array = [];
				for(x=0;x<$(".unit_group_name_option").length;x++){
					if($(".unit_group_name_option").eq(x).attr("unit_group_name") != null && $(".unit_group_name_option").eq(x).attr("unit_group_name").length > 0){
						temp_array.push($(".unit_group_name_option").eq(x).attr("unit_group_name"));
					}else{
						alert("그룹 설정을 해주세요.");
						return;
					}
				}
				unit_group_name = JSON.stringify(temp_array);

				temp_array = [];
				var sum = 0;
				for(x=0;x<$(".unit_group_name_option").length;x++){
					if($(".unit_group_name_option").eq(x).attr("unit_group_id_list") != null && $(".unit_group_name_option").eq(x).attr("unit_group_id_list").length > 0){
						var json = JSON.parse($(".unit_group_name_option").eq(x).attr("unit_group_id_list"));
						temp_array.push(json);
						sum += json.length;
					}else{
						alert("그룹 참여인원 설정을 해주세요.");
						return;
					}
				}
				if(${people_count} != null && ${people_count} != sum){
					alert("그룹 참여인원 설정을 해주세요.");
					return;
				}
				unit_group_id_list = JSON.stringify(temp_array);

				/* 수업 내용 */
				temp_array = [];

				for(x=0;x<$(".unit_group_name_option").length;x++){
					if($(".unit_group_name_option").eq(x).attr("unit_class_text") == null){
						alert("그룹 "+$(".unit_group_name_option").eq(x).attr("unit_group_name")+"의 수업 내용을 2 ~ 2000자로 작성해주세요.");
						return;
					}
					if($(".unit_group_name_option").eq(x).attr("unit_class_text").length > 1 && $(".unit_group_name_option").eq(x).attr("unit_class_text").length < 2001){
						temp_array.push($(".unit_group_name_option").eq(x).attr("unit_class_text"));
					}else{
						alert("그룹 "+$(".unit_group_name_option").eq(x).attr("unit_group_name")+"의 수업 내용을 2 ~ 2000자로 작성해주세요.");
						return;
					}
				}
				unit_class_text = JSON.stringify(temp_array);


				/* 유튜브링크 검증 */
				temp_array = [];
				for(x=0;x<$(".unit_group_name_option").length;x++){
					if($(".unit_group_name_option").eq(x).attr("unit_youtube_url") != null && $(".unit_group_name_option").eq(x).attr("unit_youtube_url").length > 0){
						if($(".unit_group_name_option").eq(x).attr("unit_youtube_url") != "undefined"){
							var json = JSON.parse($(".unit_group_name_option").eq(x).attr("unit_youtube_url"));
							var temp_array_t = [];
							for(xx=0;xx<json.length;xx++){
								if(json[xx]["title"].length > 0 && json[xx]["link"].length > 0){
									temp_array_t.push(json[xx]);
								}else if(json[xx]["title"].length > 0 &&  json[xx]["link"].length < 1){
									alert("그룹 "+$(".unit_group_name_option").eq(x).attr("unit_group_name")+"의 유튜브영상 제목과 링크를 작성해주세요.");
									return;
								}else if(json[xx]["title"].length < 1 &&  json[xx]["link"].length > 0){
									alert("그룹 "+$(".unit_group_name_option").eq(x).attr("unit_group_name")+"의 유튜브영상 제목과 링크를 작성해주세요.");
									return;
								}
							}
							if(temp_array_t.length < 1){
								temp_array_t = null;
							}
							temp_array.push(temp_array_t);	
						}else{
							temp_array.push(null);
						}
					}else{
						alert("그룹 "+$(".unit_group_name_option").eq(x).attr("unit_group_name")+"의 유튜브영상 제목과 링크를 작성해주세요.");
						return;
					}
				}
				unit_youtube_url = JSON.stringify(temp_array);


				/* 수업관련 링크 검증 */
				temp_array = [];
				for(x=0;x<$(".unit_group_name_option").length;x++){
					if($(".unit_group_name_option").eq(x).attr("unit_content_url") != null && $(".unit_group_name_option").eq(x).attr("unit_content_url").length > 0){
						if($(".unit_group_name_option").eq(x).attr("unit_content_url") != "undefined"){
							var json = JSON.parse($(".unit_group_name_option").eq(x).attr("unit_content_url"));
							var temp_array_t = [];
							for(xx=0;xx<json.length;xx++){
								if(json[xx]["title"].length > 0 && json[xx]["link"].length > 0){
									temp_array_t.push(json[xx]);
								}else if(json[xx]["title"].length > 0 &&  json[xx]["link"].length < 1){
									alert("그룹 "+$(".unit_group_name_option").eq(x).attr("unit_group_name")+"의 수업 관련 링크를 작성해주세요.");
									return;
								}else if(json[xx]["title"].length < 1 &&  json[xx]["link"].length > 0){
									alert("그룹 "+$(".unit_group_name_option").eq(x).attr("unit_group_name")+"의 수업 관련 링크를 작성해주세요.");
									return;
								}
							}
							if(temp_array_t.length < 1){
								temp_array_t = null;
							}
							temp_array.push(temp_array_t);
						}else{
							temp_array.push(null);
						}
					}else{
						alert("그룹 "+$(".unit_group_name_option").eq(x).attr("unit_group_name")+"의 수업 관련 링크를 작성해주세요.");
						return;
					}
				}
				unit_content_url = JSON.stringify(temp_array);


				/* 서버로 전송할 그룹 파일 셋팅 */
				for(x=0;x<group_file_array.length;x++){
					
					if(group_file_array[x] != null && group_file_array[x].length > 0){
						for(xx=0;xx<group_file_array[x].length;xx++){
							formData.append("files", group_file_array[x][xx]);
						}
					}
				}


				/* 수업구성 셋팅 */
				var temp_content_code_list = [];
				var temp_content_home_work = [];
				var temp_content_test = [];
				var temp_content_evaluation_type = [];
				for(x=0;x<$(".unit_group_name_option").length;x++){
					if($(".unit_group_name_option").eq(x).attr("content_code_list") != null && $(".unit_group_name_option").eq(x).attr("content_code_list").length > 0){
						var json = JSON.parse($(".unit_group_name_option").eq(x).attr("content_code_list"));
						var temp_content_home_work2 = [];
						var temp_content_test2 = [];
						var temp_content_evaluation_type2 = JSON.parse($(".unit_group_name_option").eq(x).attr("content_evaluation_type"));
						for(xx=0;xx<json.length;xx++){
							var content_name = json[xx]["content_name"];
							var content_code = json[xx]["content_code"];
							var content_title = json[xx]["content_title"];

							if(content_name == "이론수업"){
								content_code = null;
								content_title = null;
							}else{
								if(content_code == null || content_code.length < 2 || content_title == null || content_title.length < 2){
									alert("수업구성에 선택하지않은 컨텐츠가 존재합니다.");
									return;
								}
							}
							if(content_name == "이론수업" || content_name == "실습수업"){
								temp_content_home_work2.push("0");
								temp_content_test2.push("0");
							}else if(content_name == "평가수업"){
								temp_content_home_work2.push("0");
								temp_content_test2.push("1");
								if(temp_content_evaluation_type2[xx] != "3" && temp_content_evaluation_type2[xx] != "2" && temp_content_evaluation_type2[xx] != "1") {
									alert("수업이 평가형일 경우 평가방식을 정해주셔야 합니다.");
									return;
								}
							}else{
								alert("수업구성이 잘못되었습니다.");
								return;
							}
						}
						temp_content_code_list.push(json);
						temp_content_home_work.push(temp_content_home_work2);
						temp_content_test.push(temp_content_test2);
						temp_content_evaluation_type.push(JSON.parse($(".unit_group_name_option").eq(x).attr("content_evaluation_type")));
					}else{
						alert("그룹 "+$(".unit_group_name_option").eq(x).attr("unit_group_name")+"의 수업 관련 링크를 작성해주세요.");
						return;
					}
				}
				content_code_list = JSON.stringify(temp_content_code_list);
				content_home_work = JSON.stringify(temp_content_home_work);
				content_test = JSON.stringify(temp_content_test);
				content_evaluation_type = JSON.stringify(temp_content_evaluation_type);

				/* 기존 파일 + 신규파일 */
				var unit_attached_file_temp = [];
				for(x=0;x<$(".unit_group_name_option").length;x++){
					var unit_attached_file_temp_t = [];
					if($(".unit_group_name_option").eq(x).attr("befor_file") != null && $(".unit_group_name_option").eq(x).attr("befor_file").length > 4){
						var json = JSON.parse($(".unit_group_name_option").eq(x).attr("befor_file"));
						for(xx=0;xx<json.length;xx++){
							unit_attached_file_temp_t.push("/resources/class_file/"+json[xx]);
						}
					}
					if(group_file_array[x] != null && group_file_array[x].length > 0){
						for(xx=0;xx<group_file_array[x].length;xx++){
							unit_attached_file_temp_t.push("/resources/class_file/"+group_file_array[x][xx]["name"]);
						}
					}
					if(unit_attached_file_temp_t.length > 0){
						unit_attached_file_temp.push(unit_attached_file_temp_t);	
					}else{
						unit_attached_file_temp.push(null);
					}
				}
				unit_attached_file = JSON.stringify(unit_attached_file_temp);

			}else{
				unit_class_text = $("#curriculum_detail_popup_unit_class_text").val();

				/* 유튜브 영상 링크 */
				var youtubes = $(".curriculum_detail_popup_content_youtube");
				var youtube_array = []
				var youtube_not_null = false;
				for(x=0;x<youtubes.length;x++){
					var youtube_in_obj = {};
					if(!youtubes.eq(x).hasClass("hidden_box")) {
						var title = $("#curriculum_detail_popup_youtube_name" + (x+1)).val();
						var link = $("#curriculum_detail_popup_youtube_link" + (x+1)).val();
						if(title.length < 1 || link.length < 1){
							if(x==0){
								if(title.length < 1 && link.length < 1){
									youtube_not_null = true;
									break;
								}else{
									alert("유튜브 영상의 제목, 링크를 제대로 입력해주세요.");
									return;
								}
							}else{
								alert("유튜브 영상의 제목, 링크를 제대로 입력해주세요.");
								return;
							}
						}else{
							youtube_in_obj["title"] = title;
							youtube_in_obj["link"] = link;
						}
						youtube_array.push(youtube_in_obj);
					}
				}
				if(!youtube_not_null){
					unit_youtube_url = JSON.stringify(youtube_array);
				}else{
					unit_youtube_url = null;
				}

				/*수업 관련 링크*/
				var etcs = $(".curriculum_detail_popup_content_etc");
				var etc_array = [];
				var etc_not_null = false;
				for(x=0;x<etcs.length;x++){
					var etc_in_obj = {};
					if(!etcs.eq(x).hasClass("hidden_box")) {
						var title = $("#curriculum_detail_popup_etc_name" + (x+1)).val();
						var link = $("#curriculum_detail_popup_etc_link" + (x+1)).val();
						if(title.length < 1 || link.length < 1){
							if(x==0){
								if(title.length < 1 && link.length < 1){
									etc_not_null = true;
									break;
								}else{
									alert("수업관련 링크의 제목, 링크를 제대로 입력해주세요");
									return;
								}
							}else{
								alert("수업관련 링크의 제목, 링크를 제대로 입력해주세요");
								return;
							}
						}else{
							etc_in_obj["title"] = title;
							etc_in_obj["link"] = link;
						}
						etc_array.push(etc_in_obj);
					}
				}
				if(!etc_not_null){
					unit_content_url = JSON.stringify(etc_array);
				}else{
					unit_content_url = null;
				}

				/* 기존 파일 + 신규파일 */
				var unit_attached_file_temp = [];
				var files_box = $("#curriculum_detail_popup_files_box").children('div');
				if(files_box.length > 0){
					for(x=0;x<files_box.length;x++){
						unit_attached_file_temp.push("/resources/class_file/"+$(files_box).eq(x).text());
					}
					unit_attached_file = JSON.stringify(unit_attached_file_temp);
				}

				/* 수업구성 셋팅 */
				var contents = $(".curriculum_detail_popup_content");
				var temp_content_code_list = [];
				var temp_content_home_work = [];
				var temp_content_test = [];
				var temp_content_evaluation_type = [];
				for(x=0;x<contents.length;x++){
					var content_code_list_in_obj = {};
					if(!contents.eq(x).hasClass("hidden_box")){
						var content_name = $("#curriculum_detail_popup_content_name" + (x+1) + " option:selected").val();
						content_code_list_in_obj["content_name"] = content_name;
						var content_code = $("#curriculum_detail_popup_content_set_btn" + (x+1)).attr("content_code");
						var content_title = $("#curriculum_detail_popup_content_set_btn" + (x+1)).attr("content_title");
						if(content_name == "이론수업"){
							content_code_list_in_obj["content_code"] = null;
							content_code_list_in_obj["content_title"] = null;
							content_code_list_in_obj["content_type"] = $("#curriculum_detail_popup_content_type" + (x+1) + " option:selected").val();
						}else{
							if(content_code == null || content_code.length < 2 || content_title == null || content_title.length < 2){
								alert("수업구성에 선택하지않은 컨텐츠가 존재합니다.");
								return;
							}
							content_code_list_in_obj["content_code"] = content_code;
							content_code_list_in_obj["content_title"] = content_title;
							content_code_list_in_obj["content_type"] = $("#curriculum_detail_popup_content_type" + (x+1) + " option:selected").val();
						}
						if(content_name == "이론수업" || content_name == "실습수업"){
							temp_content_home_work.push("0");
							temp_content_test.push("0");
							temp_content_evaluation_type.push("0");
						}else if(content_name == "평가수업"){
							temp_content_home_work.push("0");
							temp_content_test.push("1");
							var test_val = $("#curriculum_detail_popup_content_test" + (x+1) + " option:selected").val();
							if(test_val == "상/중/하 평가"){
								temp_content_evaluation_type.push("1");
							}else if(test_val == "점수 평가"){
								temp_content_evaluation_type.push("2");
							}else if(test_val == "텍스트 평가"){
								temp_content_evaluation_type.push("3");
							}else{
								alert("수업이 평가형일 경우 평가방식을 정해주셔야 합니다.");
								return;
							}
						}else{
							alert("수업구성이 잘못되었습니다.");
							return;
						}
						temp_content_code_list.push(content_code_list_in_obj);
					}
				}
				content_code_list = JSON.stringify(temp_content_code_list);
				content_home_work = JSON.stringify(temp_content_home_work);
				content_test = JSON.stringify(temp_content_test);
				content_evaluation_type = JSON.stringify(temp_content_evaluation_type);


				if(fileBuffer.length>0){
					for(var i=0;i<fileBuffer.length; i++) {
						   formData.append("files", fileBuffer[i]);
					}
				}
			}

			/* 삭제할 파일 */
			if(deleteFile != null && deleteFile.length > 0){
				delete_file = JSON.stringify(deleteFile);
			}

			formData.append("mode", mode);
			formData.append("type", type);
			formData.append("unit_code", "${unit_code}");
			formData.append("class_code", class_code);
			formData.append("content_code_list", content_code_list);
			formData.append("content_evaluation_type", content_evaluation_type);
			formData.append("content_home_work", content_home_work);
			formData.append("content_test", content_test);
			formData.append("unit_attached_file", unit_attached_file);
			formData.append("delete_files", delete_file);
			formData.append("unit_youtube_url", unit_youtube_url);
			formData.append("unit_content_url", unit_content_url);
			formData.append("unit_start_date", unit_start_date);
			formData.append("unit_end_date", unit_end_date);
			formData.append("unit_class_type", unit_class_type);
			formData.append("unit_class_name", unit_class_name);
			formData.append("unit_class_text", unit_class_text);
			formData.append("unit_group_id_list", unit_group_id_list);
			formData.append("unit_group_name", unit_group_name);

			$.ajax({
				type:"POST",
				url:"/teacher/ready/class_configuration_management_detail_curriculum_work",
				data:formData,
				cache:false,
				contentType:false,
				processData:false,
				dataType:"text",
				success:function(string){
					if(string == "success"){
						if(mode == "create"){
							alert("차시를 생성했습니다.");
						}else if(mode == "modify"){
							alert("차시를 수정했습니다.");
						}
						location.href="/teacher/ready/class_configuration_management_detail?class_code="+class_code;
					}else{
						alert("서버가 불안정합니다.\r잠시후 다시 시도해주세요");
					}
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert(errorThrown);
				}
			});
		});
	});

	/*
	 - 추천조합, 직접조합 불러오는 함수
	 - 추천조합은 현재 사용X
	 - 직접조합일때 : 콘텐츠코드를 토대로 해당 운동목록들을 불러와서 수업 구성 관리 팝업을 셋팅한다.
	*/
	function get_exercise_combination_content_value(value, page, content_code){
		var Obj = {}
		if(value == "0"){
			//추천조합 불러오기 (page가 필요)
			Obj["content_name"] = exercise_combination_popup_content_name;
			Obj["content_category"] = exercise_combination_popup_content_category;
			Obj["option"] = exercise_combination_popup_content_search_option;
			Obj["keyword"] = exercise_combination_popup_content_search_input;
			Obj["sort"] = exercise_combination_popup_content_sort;
			Obj["page"] = page;

		}else if(value == "1"){
			//직접조합 불러오기 (page 필요없음)
			Obj["content_code"] = content_code;
		}
		Obj["value"] = value;
		var isValue = value;
		$.ajax({
			type:"POST",
			url:"/teacher/ready/get_exercise_combination",
			data:Obj,
			dataType:"text",
			success:function(string){
				if(string != null && string != "fail"){
					var object = JSON.parse(string);
					if(isValue == "1"){
						//직접조합
						var node = "";
						for(x=0;x<object.length;x++){
							node += '<tr class="exercise_combination_popup_my_content_tr" exercise_code="'+object[x]["exercise_code"]+'">';
							node += '<td>'+object[x]["exercise_name"]+'</td>';
							node += '<td>'+object[x]["exercise_category"]+'</td>';
							node += '<td>'+object[x]["exercise_detail_name"]+'</td>';
							node += '<td>'+object[x]["exercise_count"]+'</td>';
							node += '<td>'+object[x]["exercise_time"]+'초</td>';
							if(object[x]["exercise_type"] == "0"){
								node += '<td>평가가능</td>';
							}else if(object[x]["exercise_type"] == "1"){
								node += '<td>과제가능</td>';
							}else{
								node += '<td>평가, 과제가능</td>';
							}
							node += '<td><button class="exercise_combination_popup_content_tr_delete_btn">삭제하기</button></td>';
						}
						$("#exercise_combination_popup_my_content_table").append(node);

						$(".exercise_combination_popup_content_tr_delete_btn").off().click(function(){
							$(this).parent().parent().remove();
						});
					}else{
						//추천조합
						var node = "";
						$(".exercise_combination_popup_content_tr").remove();
						for(x=0;x<object["content_list"].length;x++){
							node += '<tr class="exercise_combination_popup_content_tr">';
							node += '<td class="exercise_combination_popup_content_checkbox_td"><label><input name="exercise_combination_popup_content_checkbox" class="exercise_combination_popup_content_checkbox" type="checkbox" content_title="'+object["content_list"][x]["content_title"]+'" content_code="'+object["content_list"][x]["content_code"]+'" /><span class="custom-check"></span></label></td>';
							node += '<td>'+((page-1)*5 +x+1)+'</td>';
							node += '<td>'+object["content_list"][x]["content_name"]+'</td>';
							node += '<td>'+object["content_list"][x]["content_category"]+'</td><td>'+object["content_list"][x]["content_title"]+'</td>';
							node += '<td>'+object["content_list"][x]["content_user"]+'</td><td>'+object["content_list"][x]["content_class_level"]+'</td>';
							node += '<td>'+object["content_list"][x]["content_class_grade"]+'</td>';
							var date = object["content_list"][x]["content_write_date"];
							node += '<td>'+date.substring(0, 4)+"-"+date.substring(4, 6)+"-"+date.substring(6, 8)+'</td></tr>';
						}
						$("#exercise_combination_popup_content_table").append(node);

						$("#exercise_combination_popup_paging_box").children("button").remove();
						$("#exercise_combination_popup_paging_box").children("ul").remove();
						var paging_node = "";
						if(page != "1"){
							paging_node += "<button class='page-arrow go-first' onclick='get_exercise_combination_content_value(\"0\",1,\"none\")'>처음으로</button>";
							paging_node += "<button class='page-arrow go-prev' onclick='get_exercise_combination_content_value(\"0\","+(page-1)+",\"none\")'>이전</button>";
						}
						paging_node += "<ul class='page-num'>";
						for(x=object["pageing_start"];x<object["pageing_last"]*1+1;x++){
							if(x == page){
								paging_node += "<li class='active'>"+x+"</li>"
							}else{
								paging_node += "<li onclick='get_exercise_combination_content_value(\"0\","+(x)+",\"none\")'>"+x+"</li>"
							}
						}
						if(page != object["last_page"] && object["last_page"] != "0"){
							paging_node += "<button class='page-arrow go-next' onclick='get_exercise_combination_content_value(\"0\","+(page+1)+",\"none\")'>다음</button>";
							paging_node += "<button class='page-arrow go-last' onclick='get_exercise_combination_content_value(\"0\","+object['last_page']+",\"none\")'>끝으로</button>";
						}
						$("#exercise_combination_popup_paging_box").append(paging_node);

						$("#exercise_combination_popup_save1").off().click(function(){
							var content = $('input:checkbox[name="exercise_combination_popup_content_checkbox"]:checked');
							if(content.length < 1){
								alert("하나의 조합을 선택해주세요");
							}else{
								$(curriculum_detail_popup_content_set_btn).attr("content_title", $(content).attr("content_title"));
								$(curriculum_detail_popup_content_set_btn).attr("content_code", $(content).attr("content_code"));

								$("#exercise_combination_popup").css("display","none");
								$("#curriculum_detail_popup").css("display", "block");
							}
						});

						$(".exercise_combination_popup_content_checkbox").change(function(){
							$(".exercise_combination_popup_content_checkbox").prop("checked",false);
							$(this).prop("checked", true);
						});
					}
				}else{
					alert("서버가 불안정합니다.\r다시 시도해주세요");
				}
				if(isValue == "1"){
					get_exercise_combination_content_value("0", 1, null);
				}
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){
				alert(errorThrown);
				if(value == "1"){
					get_exercise_combination_content_value("0", 1, null);
				}
			}
		});

		/*
		 - 수업 구성 관리 - 저장하기 버튼 클릭 이벤트
		 - 셋팅한 운동목록을 저장하여 콘텐츠코드를 생성한 뒤 해당 코드를 수업 구성 관리 팝업을 들어오게 한 버튼 속성으로 지정한다.
		*/
		var saveRunning = false;
		$("#exercise_combination_popup_save2").off().click(function(){
			if(!saveRunning){
				saveRunning = true;
				if($(".exercise_combination_popup_my_content_tr_modify").length != 0){
					alert("등록이 완료되지 않은 운동이 있습니다.");
					saveRunning = false;
					return;
				}else {
					if ($(".exercise_combination_popup_my_content_tr").length < 1) {
						alert("종목을 추가해주세요");
						saveRunning = false;
					}else{
						var tr_obj = $(".exercise_combination_popup_my_content_tr");
						var content_number = [];
						var content_count_list = [];	//운동 횟수
						var content_time = [];	//운동 시간
						for(x=0;x<tr_obj.length;x++){
							content_number.push($(".exercise_combination_popup_my_content_tr").eq(x).attr("exercise_code"));
							content_count_list.push($(".exercise_combination_popup_my_content_tr").eq(x).children("td").eq(3).text());
							content_time.push($(".exercise_combination_popup_my_content_tr").eq(x).children("td").eq(4).text().replace("초", ""));
						}
						var Obj = {
							"content_number_list":JSON.stringify(content_number),
							"content_count_list":JSON.stringify(content_count_list),
							"content_time":JSON.stringify(content_time),
							"content_class_grade":"${class_list.class_grade}"
						}
						$.ajax({
							type:"POST",
							url:"/teacher/ready/save_content_list",
							data:Obj,
							dataType:"text",
							success:function(string){
								if(string != null && string != "fail"){
									
									var obj = JSON.parse(string);

									$(curriculum_detail_popup_content_set_btn).attr("content_title", $(".exercise_combination_popup_my_content_tr").eq(0).children('td').eq(2).text());
									$(curriculum_detail_popup_content_set_btn).attr("content_code", obj["content_code"]);
									
									
									var nodeId = $(curriculum_detail_popup_content_set_btn).attr("id");
									if(nodeId == "curriculum_detail_popup_content_set_btn1"){
										$(".curriculum_detail_content_list").eq(0).empty();
										$(".curriculum_detail_content_list").eq(0).removeClass("hidden_box");
									}else if(nodeId == "curriculum_detail_popup_content_set_btn2"){
										$(".curriculum_detail_content_list").eq(1).empty();
										$(".curriculum_detail_content_list").eq(1).removeClass("hidden_box");
									}else if(nodeId == "curriculum_detail_popup_content_set_btn3"){
										$(".curriculum_detail_content_list").eq(2).empty();
										$(".curriculum_detail_content_list").eq(2).removeClass("hidden_box");
									}else if(nodeId == "curriculum_detail_popup_content_set_btn4"){
										$(".curriculum_detail_content_list").eq(3).empty();
										$(".curriculum_detail_content_list").eq(3).removeClass("hidden_box");
									}else if(nodeId == "curriculum_detail_popup_content_set_btn5"){
										$(".curriculum_detail_content_list").eq(4).empty();
										$(".curriculum_detail_content_list").eq(4).removeClass("hidden_box");
									}
									
									for(x=0;x<obj["content_detail_name_list"].length;x++){
										var nodeId = $(curriculum_detail_popup_content_set_btn).attr("id");
										if(nodeId == "curriculum_detail_popup_content_set_btn1"){
											$(".curriculum_detail_content_list").eq(0).append('<div class="curriculum_detail_content">- <span class="curriculum_detail_content_name">'+obj["content_detail_name_list"][x]+'</span> <span class="curriculum_detail_content_count">'+obj["content_count_list"][x]+'</span>회</div>');
										}else if(nodeId == "curriculum_detail_popup_content_set_btn2"){
											$(".curriculum_detail_content_list").eq(1).append('<div class="curriculum_detail_content">- <span class="curriculum_detail_content_name">'+obj["content_detail_name_list"][x]+'</span> <span class="curriculum_detail_content_count">'+obj["content_count_list"][x]+'</span>회</div>');
										}else if(nodeId == "curriculum_detail_popup_content_set_btn3"){
											$(".curriculum_detail_content_list").eq(2).append('<div class="curriculum_detail_content">- <span class="curriculum_detail_content_name">'+obj["content_detail_name_list"][x]+'</span> <span class="curriculum_detail_content_count">'+obj["content_count_list"][x]+'</span>회</div>');
										}else if(nodeId == "curriculum_detail_popup_content_set_btn4"){
											$(".curriculum_detail_content_list").eq(3).append('<div class="curriculum_detail_content">- <span class="curriculum_detail_content_name">'+obj["content_detail_name_list"][x]+'</span> <span class="curriculum_detail_content_count">'+obj["content_count_list"][x]+'</span>회</div>');
										}else if(nodeId == "curriculum_detail_popup_content_set_btn5"){
											$(".curriculum_detail_content_list").eq(4).append('<div class="curriculum_detail_content">- <span class="curriculum_detail_content_name">'+obj["content_detail_name_list"][x]+'</span> <span class="curriculum_detail_content_count">'+obj["content_count_list"][x]+'</span>회</div>');
										}
									}
									
									$("#exercise_combination_popup").css("display","none");
									$("#curriculum_detail_popup").css("display", "block");
									curriculum_detail_popup_content_set_btn = null;

								}else{
									alert("서버가 불안정합니다.\r다시 시도해주세요");
								}
							},
							error:function(XMLHttpRequest, textStatus, errorThrown){
								alert(errorThrown);
							}
						});
					}
				}
			}
		});

	}

		
	</script>
</html>

