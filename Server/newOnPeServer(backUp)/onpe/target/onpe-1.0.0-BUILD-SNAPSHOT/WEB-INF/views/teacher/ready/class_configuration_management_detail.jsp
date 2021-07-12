<!-- 수업 생성/관리 상세 페이지 -->
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
		
		<div id="curriculum_date_popup" class="popup" style="display: none;">
			<div class="popup-cont small-pop">
				<div class="pop-title flex justify-space">
					<div class="left flex">
						<h2>차시별 수업일정 수정</h2>
					</div>
					<div class="right">
						<button id="curriculum_date_popup_close" class="close" onclick="closePopup()">x</button>
					</div>
				</div>
				<div class="pop-cont">
					<div class="form">
						<div class="field w100">
							<div class="field-inner">
								<label>회차</label>
								<input id="curriculum_date_popup_title" type="text" value="1회차" disabled>
							</div>

						</div>
						<div class="field w100">
							<label>수업일시</label>
							<div>
								<input id="curriculum_date_popup_from" type="text" class="datepick-from">
								<select id="curriculum_date_popup_from_hour" class="w24 ml10">
									<option>시</option>
									<c:forTokens var="item" items="01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24" delims=",">
										<option selected>${item}</option>
									</c:forTokens>
								</select>
								<select id="curriculum_date_popup_from_min" class="w24">
									<option>분</option>
									<c:forTokens var="item2" items="01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59" delims=",">
										<option selected>${item2}</option>
									</c:forTokens>
								</select>
							</div>
							<div class="rangemark">~</div>
							<div>
								<input id="curriculum_date_popup_to" type="text" class="datepick-to">
								<select id="curriculum_date_popup_to_hour" class="w24 ml10">
									<option>시</option>
									<c:forTokens var="item" items="01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24" delims=",">
										<option selected>${item}</option>
									</c:forTokens>
								</select>
								<select id="curriculum_date_popup_to_min" class="w24">
									<option>분</option>
									<c:forTokens var="item2" items="01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59" delims=",">
										<option selected>${item2}</option>
									</c:forTokens>
								</select>
							</div>
							
							
						</div>
					</div>
					<div class="btn-wrap">
						<button id="curriculum_date_popup_save" class="btn-pt">저장하기</button>
					</div>
				</div>
			</div>
		</div>
		
		

		<div class="content">
			<div class="wrapper">
				<h2 class="sub-title">수업 생성/관리</h2>

				<div class="box-wrap">
					<div class="arco-title active">
						<h3>STEP 1. 학기 수업 개요</h3>
						<c:if test="${class_unit_list_check == 'null'}">
							<button id="get_before_class_information" class="btn-s-round">이전 수업 불러오기</button>
						</c:if>
					</div>

					<div class="box-content arco-cont active">
						<div class="form">
							<div class="field w32">
								<label>학급</label>
								<input type="text" placeholder="${class_list.class_grade}학년 ${class_list.class_group}반 ${class_list.class_semester}학기" disabled>
							</div>
							<div class="field w32">
								<label>학급 정원</label>
								<input id="class_people_max_count" type="number" placeholder="1 ~ 99의 숫자를 입력해주세요" value="${class_list.class_people_max_count}">
							</div>
							<div class="field w32">
								<label>학기 수업명</label>
								<input id="class_name" type="text" placeholder="수업명을 입력하세요" value="${class_list.class_name}">
							</div>
							<div class="field w49">
								<label>학기 수업기간</label>
								<div class="date-range">
									<c:if test="${class_list.class_start_date != null}">
										<input type="text" id="from" name="from" value="${fn:substring(class_list.class_start_date,4,6)}/${fn:substring(class_list.class_start_date,6,8)}/${fn:substring(class_list.class_start_date,0,4)}">
									</c:if>
									<c:if test="${class_list.class_start_date == null}">
										<input type="text" id="from" name="from">
									</c:if>
									<span class="datemark">~</span>
									<c:if test="${class_list.class_end_date != null}">
										<input type="text" id="to" name="to" value="${fn:substring(class_list.class_end_date,4,6)}/${fn:substring(class_list.class_end_date,6,8)}/${fn:substring(class_list.class_end_date,0,4)}">
									</c:if>
									<c:if test="${class_list.class_end_date == null}">
										<input type="text" id="to" name="to">
									</c:if>
								</div>
								
							</div>
							<div id="class_project_submit_type_parent_box" class="field">
								<label>전체 공지 링크(과제제출, 오픈채팅, 줌 등)</label>
								<div class="field-inner class_project_submit_type_parent ">
									<select id="class_project_submit_type_selectbox1" class="w32 class_project_submit_type_selectbox">
										<c:if test="${type != null and type[0] != null}">
											<c:if test="${type[0].type == '이메일'}">
												<option>오픈채팅</option>
												<option selected>이메일</option>
												<option>N드라이브</option>
												<option>직접입력</option>
											</c:if>
											<c:if test="${type[0].type == 'N드라이브'}">
												<option>오픈채팅</option>
												<option>이메일</option>
												<option selected>N드라이브</option>
												<option>직접입력</option>
											</c:if>
											<c:if test="${type[0].type == '오픈채팅'}">
												<option selected>오픈채팅</option>
												<option>이메일</option>
												<option>N드라이브</option>
												<option>직접입력</option>
											</c:if>
											<c:if test="${type[0].type == '직접입력'}">
												<option>오픈채팅</option>
												<option>이메일</option>
												<option>N드라이브</option>
												<option selected>직접입력</option>
											</c:if>
										</c:if>
										<c:if test="${type == null or type[0] == null}">
											<option>오픈채팅</option>
											<option>이메일</option>
											<option>N드라이브</option>
											<option>직접입력</option>
										</c:if>
									</select>
									<input type="text" class="w49 class_project_submit_type_value" placeholder="오픈채팅 링크를 입력하세요" value="${type[0].link}">
									<c:if test="${type != null and type[1] != null}">
										<button id="add_p_s_t1" class="btn-round btn-add class_project_submit_type_value_add_btn hidden_box">+</button>
									</c:if>
									<c:if test="${type == null or type[1] == null}">
										<button id="add_p_s_t1" class="btn-round btn-add class_project_submit_type_value_add_btn">+</button>
									</c:if>
								</div>
								<c:if test="${type != null and type[1] != null}">
								<div class="field-inner class_project_submit_type_parent">
								</c:if>
								<c:if test="${type == null or type[1] == null}">
								<div class="field-inner class_project_submit_type_parent hidden_box">
								</c:if>
									<select id="class_project_submit_type_selectbox2" class="w32 class_project_submit_type_selectbox">
										<c:if test="${type != null and type[1] != null}">
											<c:if test="${type[1].type == '이메일'}">
												<option>오픈채팅</option>
												<option selected>이메일</option>
												<option>N드라이브</option>
												<option>직접입력</option>
											</c:if>
											<c:if test="${type[1].type == 'N드라이브'}">
												<option>오픈채팅</option>
												<option>이메일</option>
												<option selected>N드라이브</option>
												<option>직접입력</option>
											</c:if>
											<c:if test="${type[1].type == '오픈채팅'}">
												<option selected>오픈채팅</option>
												<option>이메일</option>
												<option>N드라이브</option>
												<option>직접입력</option>
											</c:if>
											<c:if test="${type[1].type == '직접입력'}">
												<option>오픈채팅</option>
												<option>이메일</option>
												<option>N드라이브</option>
												<option selected>직접입력</option>
											</c:if>
										</c:if>
										<c:if test="${type == null || type[1] == null}">
											<option>오픈채팅</option>
											<option>이메일</option>
											<option>N드라이브</option>
											<option>직접입력</option>
										</c:if>
									</select>
									<input type="text" class="w49 class_project_submit_type_value" placeholder="오픈채팅 링크를 입력하세요" value="${type[1].link}">
									<c:if test="${type != null and type[2] != null}">
										<button id="add_p_s_t2" class="btn-round btn-add class_project_submit_type_value_add_btn hidden_box">+</button>
										<button id="remove_p_s_t2" class="btn-round btn-remove class_project_submit_type_value_remove_btn hidden_box">-</button>
									</c:if>
									<c:if test="${type == null or type[2] == null}">
										<button id="add_p_s_t2" class="btn-round btn-add class_project_submit_type_value_add_btn">+</button>
										<button id="remove_p_s_t2" class="btn-round btn-remove class_project_submit_type_value_remove_btn">-</button>
									</c:if>
								</div>
								<c:if test="${type != null and type[2] != null}">
								<div class="field-inner class_project_submit_type_parent">
								</c:if>
								<c:if test="${type == null or type[2] == null}">
								<div class="field-inner class_project_submit_type_parent hidden_box">
								</c:if>
									<select id="class_project_submit_type_selectbox3" class="w32 class_project_submit_type_selectbox">
										<c:if test="${type != null and type[2] != null}">
											<c:if test="${type[2].type == '이메일'}">
												<option>오픈채팅</option>
												<option selected>이메일</option>
												<option>N드라이브</option>
												<option>직접입력</option>
											</c:if>
											<c:if test="${type[2].type == 'N드라이브'}">
												<option>오픈채팅</option>
												<option>이메일</option>
												<option selected>N드라이브</option>
												<option>직접입력</option>
											</c:if>
											<c:if test="${type[2].type == '오픈채팅'}">
												<option selected>오픈채팅</option>
												<option>이메일</option>
												<option>N드라이브</option>
												<option>직접입력</option>
											</c:if>
											<c:if test="${type[2].type == '직접입력'}">
												<option>오픈채팅</option>
												<option>이메일</option>
												<option>N드라이브</option>
												<option selected>직접입력</option>
											</c:if>
										</c:if>
										<c:if test="${type == null || type[2] == null}">
											<option>오픈채팅</option>
											<option>이메일</option>
											<option>N드라이브</option>
											<option>직접입력</option>
										</c:if>
									</select>
									<input type="text" class="w49 class_project_submit_type_value" placeholder="오픈채팅 링크를 입력하세요" value="${type[2].link}">
									<c:if test="${type != null and type[3] != null}">
										<button id="add_p_s_t3" class="btn-round btn-add class_project_submit_type_value_add_btn hidden_box">+</button>
										<button id="remove_p_s_t3" class="btn-round btn-remove class_project_submit_type_value_remove_btn hidden_box">-</button>
									</c:if>
									<c:if test="${type == null or type[3] == null}">
										<button id="add_p_s_t3" class="btn-round btn-add class_project_submit_type_value_add_btn">+</button>
										<button id="remove_p_s_t3" class="btn-round btn-remove class_project_submit_type_value_remove_btn">-</button>
									</c:if>
								</div>
								<c:if test="${type != null and type[3] != null}">
								<div class="field-inner class_project_submit_type_parent">
								</c:if>
								<c:if test="${type == null or type[3] == null}">
								<div class="field-inner class_project_submit_type_parent hidden_box">
								</c:if>
									<select id="class_project_submit_type_selectbox4" class="w32 class_project_submit_type_selectbox">
										<c:if test="${type != null and type[3] != null}">
											<c:if test="${type[3].type == '이메일'}">
												<option>오픈채팅</option>
												<option selected>이메일</option>
												<option>N드라이브</option>
												<option>직접입력</option>
											</c:if>
											<c:if test="${type[3].type == 'N드라이브'}">
												<option>오픈채팅</option>
												<option>이메일</option>
												<option selected>N드라이브</option>
												<option>직접입력</option>
											</c:if>
											<c:if test="${type[3].type == '오픈채팅'}">
												<option selected>오픈채팅</option>
												<option>이메일</option>
												<option>N드라이브</option>
												<option>직접입력</option>
											</c:if>
											<c:if test="${type[3].type == '직접입력'}">
												<option>오픈채팅</option>
												<option>이메일</option>
												<option>N드라이브</option>
												<option selected>직접입력</option>
											</c:if>
										</c:if>
										<c:if test="${type == null || type[3] == null}">
											<option>오픈채팅</option>
											<option>이메일</option>
											<option>N드라이브</option>
											<option>직접입력</option>
										</c:if>
									</select>
									<input type="text" class="w49 class_project_submit_type_value" placeholder="오픈채팅 링크를 입력하세요" value="${type[3].link}">
									<button id="remove_p_s_t4" class="btn-round btn-remove class_project_submit_type_value_remove_btn">-</button>
								</div>
							</div>
						</div>
						<div class="btn-wrap">
							<button id="class_save_btn" class="btn-pt mr10">저장하기</button>
							<button id="class_delete_btn" class="btn-sec">삭제하기</button>
						</div>

					</div>
					
				</div>
				

				<div class="box-wrap">
					<div class="arco-title">
						<h3>STEP 2. 차시별 수업 관리</h3>
						<c:if test="${class_list.class_unit_list == null}">
							<button id="curriculum_auto_save" class="btn-s-round mr10">추천 커리큘럼으로 자동 완성하기</button>
						</c:if>
						<c:if test="${class_list.class_unit_list != null}">
							<button id="curriculum_reset" class="btn-s-round">전체 초기화</button>
						</c:if>
					</div>

					<div id="step2_content_box" class="box-content arco-cont">
						
						<p id="drag-txt-notice" class="txt-notice hidden_box">드래그 & 드롭으로 단원의 순서를 바꿔보세요!</p>
						<div id="step2_content_item_box" class="dragdrop-list list-group col">
						</div>

						<div class="btn-wrap">
							<button id="create_curriculum_btn" class="btn-fw-gray"><img src="/asset/images/icon/plus.svg" alt="" />신규 생성</button>
						</div>

					</div>
					
				</div>


			</div>

			<div class="footer">
				<p>copyright 컴플렉시온 ⓒ All rights reserved.</p>
			</div>
		</div>
		
		<div id="auto_make_curriculum_popup" class="popup" style="display:none;">
			<div class="popup-cont">
				<div class="pop-title flex justify-space">
					<div class="left flex">
						<h2>추천 커리큘럼 자동완성</h2>
					</div>
					<div class="right">
						<button id="auto_make_curriculum_popup_close" class="close">x</button>
					</div>
				</div>
				<div class="pop-cont">
					<div class="filter-wrap">
						<div class="filter-inner flex">
							<div class="field w32">
								<label>학교급</label>
								<select id="auto_make_curriculum_popup_level">
									<option>전체</option>
									<option>초등학교</option>
									<option>중학교</option>
									<option>고등학교</option>
									<option>기타</option>
								</select>
							</div>
							<div class="field w32">
								<label>학기</label>
								<select id="auto_make_curriculum_popup_semester">
									<option>전체</option>
									<option>1학기</option>
									<option>2학기</option>
								</select>
							</div>
							<div class="field w32">
								<label>학년</label>
								<select id="auto_make_curriculum_popup_grade">
									<option>전체</option>
									<option>1학년</option>
									<option>2학년</option>
									<option>3학년</option>
									<option>4학년</option>
									<option>5학년</option>
									<option>6학년</option>
								</select>
							</div>
							
							<div class="field w100">
								<label>검색 구분</label>
								<select id="auto_make_curriculum_popup_search_option">
									<option>전체</option>
									<option>생산자</option>
									<option>제목</option>
								</select>
								<input id="auto_make_curriculum_popup_keyword" type="text" class="search-input ml10" />
							</div>
						</div>
	
						<div class="btn-wrap">
							<button id="auto_make_curriculum_popup_search_btn" class="btn-pt">조회</button>
						</div>
							
					</div>
					<div class="pop-cont-inner">
						<div class="table-control">
							<select id="auto_make_curriculum_popup_sort">
								<option>최신순</option>
								<option>오래된순</option>
							</select>
						</div>
						<div class="overflow">
							<table id="auto_make_curriculum_table" class="basic medium">
								<tr>
									<th></th>
									<th>No</th>
									<th>학교급</th>
									<th>학년</th>
									<th>학기</th>
									<th>생산자</th>
									<th>제목</th>
									<th>등록일</th>
								</tr>
							</table>
							<div id="auto_make_curriculum_popup_paging_box" class="paging mt10">
							</div>
						</div>
					</div>
					
					<div class="btn-wrap">
						<button id="auto_make_curriculum_popup_save_btn" class="btn-pt">저장하기</button>
					</div>
				</div>
			</div>
		</div>
		
		<div id="auto_make_curriculum_detail_popup" class="popup" style="display:none;">
			<div class="popup-cont">
				<div class="pop-title flex justify-space">
					<div class="left flex">
						<h2 id="auto_make_curriculum_detail_popup_title"></h2>
					</div>
					<div class="right">
						<button id="auto_make_curriculum_detail_popup_close" class="close">x</button>
					</div>
				</div>
				<div class="pop-cont">
					<div class="pop-cont-inner">
						
						<div id="auto_make_curriculum_detail_popup_content" class="editable-area">
						</div>
					
					</div>
					
					<div class="btn-wrap">
						<button id="auto_make_curriculum_detail_popup_close2" class="btn-sec">목록으로</button>
					</div>
				</div>
			</div>
		</div>
	
	</div>
	</body>
	<script>
	var class_code = "${class_code}";	//해당 클래스코드

	var auto_curriculum_isRunning = false;	// 추천 커리큘럼으로 자동 완성 중복실행 방지
	var curriculum = null;	// 해당 클래스 - 차시 객체
	var auto_make_curriculum_popup_level = "전체";	//추천 커리큘럼 자동 완성 팝업 - 학교급 옵션
	var auto_make_curriculum_popup_semester = "전체";	//추천 커리큘럼 자동 완성 팝업 - 학기 옵션
	var auto_make_curriculum_popup_grade = "전체";	//추천 커리큘럼 자동 완성 팝업 - 학년 옵션
	var auto_make_curriculum_popup_search_option = "전체";	//추천 커리큘럼 자동 완성 팝업 - 검색구분 옵션
	var auto_make_curriculum_popup_keyword = null;	//추천 커리큘럼 자동 완성 팝업 - 검색어
	var auto_make_curriculum_popup_sort = "최신순";	//추천 커리큘럼 자동 완성 팝업 - 정렬기준

	
	$(document).ready(function(){
		/*
		 - 해당 클래스에 하나 이상의 차시가 존재한다면 추천 커리큘럼 자동완성 기능을 사용할 수 없도록 셋팅한다.
		 - 해당 클래스에 차시가 존재한다면 차시 목록을 "STEP 2. 차시별 수업 관리"에 셋팅한다.
		 - 해당 클래스에 차시가 존재하지 않다면 추천 커리큘럼 자동완성 기능을 활성 + 최초 셋팅을 진행한다.
		*/
		if("${class_unit_list_check}" != "null"){
			curriculum = ${class_unit_list_object};
			$("#drag-txt-notice").removeClass("hidden_box");
			var node = "";
			for(x=0;x<curriculum.length;x++){
				node += '<div class="list-group-item" unit_code="'+curriculum[x]['unit_code']+'" unit_class_name="'+curriculum[x]['unit_class_name']+'" unit_end_date="'+curriculum[x]['unit_end_date']+'" unit_start_date="'+curriculum[x]['unit_start_date']+'">';
				node += '<div class="list-group-num">'+(x+1)+'회차</div><div class="list-group-title">';
				if(curriculum[x]['unit_start_date'] == "0"){
					node += '<h4>'+curriculum[x]['unit_class_name']+'<button class="btn-s-round-l" onclick="openPopup(\''+curriculum[x]['unit_code']+'\',\''+curriculum[x]['unit_start_date']+'\',\''+curriculum[x]['unit_end_date']+'\', \''+curriculum[x]['unit_class_name']+'\')">일정 설정</button></h4>'
				}else{
					node += '<h4>'+curriculum[x]['unit_class_name']+'<button class="btn-s-round-sub" onclick="openPopup(\''+curriculum[x]['unit_code']+'\',\''+curriculum[x]['unit_start_date']+'\',\''+curriculum[x]['unit_end_date']+'\', \''+curriculum[x]['unit_class_name']+'\')">일정 수정</button></h4>'	
				}
				node += '</div><div class="list-group-edit"><button class="btn-s-round bg-blue" onclick="curriculum_detail_page(\''+curriculum[x]['unit_code']+'\', \'modify\')">세부설정 수정</button><div class="edit-btn-wrap"><button onclick="copy_curriculum(\''+curriculum[x]['unit_code']+'\')">복제하기</button><button onclick="delete_curriculum(\''+curriculum[x]['unit_code']+'\')">삭제하기</button><button class="bg2" onclick="location.href=\'/teacher/progress/class_progress_management?class_code='+class_code+'&unit_code='+curriculum[x]['unit_code']+'\'">수업이동</button></div></div></div>'
			}
			$("#step2_content_item_box").append(node);	
		}else{
			// 추천 커리큘럼 자동완성 기능 최초 셋팅
			auto_curriculum_list(1);
		}
	});

	/*
	 - STEP 2. 차시별 수업 관리의 "세부설정 수정" 클릭시 실행함수
	 - 선택한 차시의 세부설정 페이지로 이동한다.
	*/
	function curriculum_detail_page(unit_code, mode){
		if(unit_code == null || unit_code.length < 1){
			location.href="/teacher/ready/curriculum_configuration_management_detail?class_code="+class_code+"&mode="+mode;
		}else{
			location.href="/teacher/ready/curriculum_configuration_management_detail?class_code="+class_code+"&mode="+mode+"&unit_code="+unit_code;
		}
	}

	/*
	 - STEP 2. 차시별 수업 관리의 "+신규 생성" 버튼 클릭 이벤트
	 - 생성시킬 차시의 세부설정 페이지로 이동한다.
	*/
	$("#create_curriculum_btn").click(function(){
		curriculum_detail_page(null, "create");
	});
	
	// STEP 2. 차시별 수업 관리의 차시 목록 Drag & Drop 기능
	$('.dragdrop-list').sortable({
		update:function(event, ui){
			var length = $(".list-group-item").length;
			var jsonArray = [];
			for(x=0;x<length;x++){
				$(".list-group-item").eq(x).children(".list-group-num").text((x+1)+"회차");
				var jsonObject = {
					"unit_class_name":$(".list-group-item").eq(x).attr("unit_class_name"),
					"unit_code":$(".list-group-item").eq(x).attr("unit_code"),
					"unit_start_date":$(".list-group-item").eq(x).attr("unit_start_date"),
					"unit_end_date":$(".list-group-item").eq(x).attr("unit_end_date")
				}
				jsonArray.push(jsonObject);
			}

			var Obj = {
				"class_unit_list":JSON.stringify(jsonArray),
				"class_code":"${class_list.class_code}",
				"mode":"yo"
			}
			$.ajax({
				type:"POST",
				url:"/teacher/ready/class_configuration_management_detail_work",
				data:Obj,
				dataType:"text",
				success:function(string){
					
					auto_curriculum_isRunning = false;
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert(errorThrown);
					auto_curriculum_isRunning = false;
				}
			});

		}
	});
	
	
	/*추천커리큘럼 팝업 open*/
	$("#curriculum_auto_save").click(function(){
		$("#auto_make_curriculum_popup").css("display","block");
	});
	
	/*추천커리큘럼 팝업 close*/
	$("#auto_make_curriculum_popup_close").click(function(){
		$("#auto_make_curriculum_popup").css("display","none");
	});

	/* STEP 2. 차시별 수업 관리 - 전체 초기화 버튼 클릭 이벤트(해당 클래스의 보유 차시 전부 삭제) */
	$("#curriculum_reset").click(function(){
		if (confirm("정말 차시별 수업목록을 초기화 하시겠습니까?") == true){
			if(!auto_curriculum_isRunning){
				auto_curriculum_isRunning = true;
				
				var Obj = { "class_code":"${class_list.class_code}" }
				$.ajax({
					type:"POST",
					url:"/teacher/ready/curriculum_reset",
					data:Obj,
					dataType:"text",
					success:function(string){
						if(string != null && string == "success"){
							alert("차시 목록을 초기화했습니다.");
							history.go(0);
						}else{
							alert("서버가 불안정합니다.\r잠시후 다시 시도해주세요");
							auto_curriculum_isRunning = false;
						}
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert(errorThrown);
						auto_curriculum_isRunning = false;
					}
				});
				
			}else{
				alert("잠시후 다시 시도해주세요");
			}
		}
	});

	/* STEP 2. 차시별 수업 관리 -> 추천 커리큘럼 자동 완성 팝업 -> 조회 버튼 클릭 이벤트 */
	$("#auto_make_curriculum_popup_search_btn").click(function(){
		var curriculum_level = $("#auto_make_curriculum_popup_level option:selected").val();
		var curriculum_semester = $("#auto_make_curriculum_popup_semester option:selected").val();
		var curriculum_grade = $("#auto_make_curriculum_popup_grade option:selected").val();
		var keyword_option = $("#auto_make_curriculum_popup_search_option option:selected").val();
		var keyword = $("#auto_make_curriculum_popup_keyword").val();
		if(keyword.length < 2 && keyword.length > 50){
			alert("검색어는 2자 이상 50자 이하로 입력해주세요");
		}else{
			auto_make_curriculum_popup_level = curriculum_level;
			auto_make_curriculum_popup_grade = curriculum_grade;
			auto_make_curriculum_popup_semester = curriculum_semester;
			auto_make_curriculum_popup_search_option = keyword_option;
			auto_make_curriculum_popup_keyword = keyword;
			auto_curriculum_list(1);
		}
	});

	/* STEP 2. 차시별 수업 관리 -> 추천 커리큘럼 자동 완성 팝업 -> 정렬 기준 변경 이벤트 */
	$("#auto_make_curriculum_popup_sort").change( function() {
		auto_make_curriculum_popup_sort = $("#auto_make_curriculum_popup_sort option:selected").val();
		auto_curriculum_list(1);
	});

	/* STEP 2. 차시별 수업 관리 -> 추천 커리큘럼 자동 완성 팝업 -> 목록 재구성 함수 */
	function auto_curriculum_list(page){
		if(!auto_curriculum_isRunning){
			auto_curriculum_isRunning = true;
			var Obj = {
					"class_level":auto_make_curriculum_popup_level,
					"class_grade":auto_make_curriculum_popup_grade,
					"class_semester":auto_make_curriculum_popup_semester,
					"keyword_option":auto_make_curriculum_popup_search_option,
					"keyword":auto_make_curriculum_popup_keyword,
					"sort":auto_make_curriculum_popup_sort,
					"page":page
			}
			$.ajax({
				type:"POST",
				url:"/teacher/ready/curriculum_auto_make_search",
				data:Obj,
				dataType:"text",
				success:function(string){
					if(string != null && string != "fail"){
						nowpage = page;
						var object = JSON.parse(string);
						var curriculum = object["curriculum_list"];
						var node = "";
						for(x=0;x<curriculum.length;x++){
							node += '<tr class="auto_make_curriculum_tr">';
							node += '<td><label><input class="auto_make_curriculum_popup_checkbox" type="checkbox" name="auto_make_curriculum_checkbox" curriculum_code="'+curriculum[x]['curriculum_code']+'" /><span class="custom-check"></span></label></td>';
							node += '<td>'+(x+1)+'</td>';
							if(curriculum[x]['class_level'] == '1'){
								node += '<td>초등학교</td>';
							}else if(curriculum[x]['class_level'] == '2'){
								node += '<td>중학교</td>';
							}else if(curriculum[x]['class_level'] == '3'){
								node += '<td>고등학교</td>';
							}else{
								node += '<td>기타</td>';
							}
							node += '<td>'+curriculum[x]['class_grade']+'</td>';
							node += '<td>'+curriculum[x]['class_semester']+'</td>';
							node += '<td>'+curriculum[x]['curriculum_provider']+'</td>';
							node += '<td class="auto_make_curriculum_popup_td_title" onclick="curriculum_detail_text(\''+curriculum[x]['curriculum_title']+'\', \''+curriculum[x]['curriculum_info']+'\')">'+curriculum[x]['curriculum_title']+'</td>';
							var date = curriculum[x]['curriculum_date'];
							node += '<td>'+date.substring(0,4)+'-'+date.substring(4,6)+'-'+date.substring(6,8)+'</td></tr>';
						}
						$(".auto_make_curriculum_tr").remove();
						$("#auto_make_curriculum_table").append(node);
						
						$("#auto_make_curriculum_popup_paging_box").children("button").remove();
						$("#auto_make_curriculum_popup_paging_box").children("ul").remove();
						var paging_node = "";
						if(page != 1){
							paging_node += "<button class='page-arrow go-first' onclick='auto_curriculum_list(1)'>처음으로</button>";
							paging_node += "<button class='page-arrow go-prev' onclick='auto_curriculum_list("+(page-1)+")'>이전</button>";
						}
						paging_node += "<ul class='page-num'>";
						for(x=object["pageing_start"];x<object["pageing_last"]*1+1;x++){
							if(x == page){
								paging_node += "<li class='active'>"+x+"</li>"
							}else{
								paging_node += "<li onclick='auto_curriculum_list("+x+")'>"+x+"</li>"
							}
						}
						if(page != object["last_page"] && object["last_page"] != "0"){
							paging_node += "<button class='page-arrow go-next' onclick='auto_curriculum_list("+(page+1)+")'>다음</button>";
							paging_node += "<button class='page-arrow go-last' onclick='auto_curriculum_list("+object['last_page']+")'>끝으로</button>";
						}
						$("#auto_make_curriculum_popup_paging_box").append(paging_node);
						
						$(".auto_make_curriculum_popup_checkbox").change(function(){
					        if($(this).is(":checked")){
					        	$(".auto_make_curriculum_popup_checkbox").prop("checked",false);
					        	$(this).prop("checked", true);
					        }
					    });
						
						auto_curriculum_isRunning = false;
					}else{
						alert("서버가 불안정합니다.\r잠시후 다시 시도해주세요");
						auto_curriculum_isRunning = false;
					}
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert(errorThrown);
					auto_curriculum_isRunning = false;
				}
			});
		}else{
			alert("잠시후 다시 시도해주세요");
		}
	}

	/*
	 - STEP 2. 차시별 수업 관리 -> 추천 커리큘럼 자동 완성 팝업 -> 저장하기 버튼 클릭 이벤트
	 - 선택한 커리큘럼의 차시를 해당 클래스에 포함시킨다.
	*/
	$("#auto_make_curriculum_popup_save_btn").click(function(){
		if(!auto_curriculum_isRunning){
			auto_curriculum_isRunning = true;
			
			var length = $("input:checkbox[name=auto_make_curriculum_checkbox]:checked").length;
			if(length == 1){
				curriculum_code = $("input:checkbox[name=auto_make_curriculum_checkbox]:checked").attr("curriculum_code");
				
				var Obj = {
						"curriculum_code":curriculum_code,
						"class_code":"${class_list.class_code}"
				}
				$.ajax({
					type:"POST",
					url:"/teacher/ready/curriculum_auto_make_save",
					data:Obj,
					dataType:"text",
					success:function(string){
						if(string != null && string == "success"){
							alert("커리큘럼을 저장했습니다.");
							history.go(0);
						}else{
							alert("서버가 불안정합니다.\r잠시후 다시 시도해주세요");
							auto_curriculum_isRunning = false;
						}
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert(errorThrown);
						auto_curriculum_isRunning = false;
					}
				});
				
			}else{
				alert("추가하실 커리큘럼을 선택해주세요");
			}
			
		}else{
			alert("잠시후 다시 시도해주세요");
		}
		
	});
	
	/*
	 - 커리큘럼 자동완성 팝업 - 커리큘럼 목록 - 제목 클릭
	 - 해당 커리큘럼 상세 내용이 보여지는 팝업 ON
	*/
	function curriculum_detail_text(title, content){
		$("#auto_make_curriculum_detail_popup_title").text(title);
		$("#auto_make_curriculum_detail_popup_content").text(content);
		$("#auto_make_curriculum_popup").css("display","none");
		$("#auto_make_curriculum_detail_popup").css("display","block");
	}

	/* 커리큘럼 자동완성 팝업 - 커리큘럼 목록 - 제목 클릭 - 해당 커리큘럼 상세 팝업 닫기(X) 버튼 클릭 이벤트 */
	$("#auto_make_curriculum_detail_popup_close").click(function(){
		$("#auto_make_curriculum_detail_popup").css("display","none");
		$("#auto_make_curriculum_popup").css("display","block");
	});

	/* 커리큘럼 자동완성 팝업 - 커리큘럼 목록 - 제목 클릭 - 해당 커리큘럼 상세 팝업 "목록으로" 버튼 클릭 이벤트 */
	$("#auto_make_curriculum_detail_popup_close2").click(function(){
		$("#auto_make_curriculum_detail_popup").css("display","none");
		$("#auto_make_curriculum_popup").css("display","block");
	});

	/*
	 - STEP 1. 학기 수업 개요 - "저장하기" 버튼 클릭 이벤트
	 - 해당 클래스 정보를 입력한 값들로 저장 or 수정
	*/
	$("#class_save_btn").click(function(){
		var class_people_max_count = $("#class_people_max_count").val();
		var class_name = $("#class_name").val();
		var from = $("#from").val();
		var to = $("#to").val();
		var type1 = $("#class_project_submit_type_selectbox1 option:selected").val();
		var type2 = $("#class_project_submit_type_selectbox2 option:selected").val();
		var type3 = $("#class_project_submit_type_selectbox3 option:selected").val();
		var type4 = $("#class_project_submit_type_selectbox4 option:selected").val();
		var link1 = $(".class_project_submit_type_value").eq(0).val();
		var link2 = $(".class_project_submit_type_value").eq(1).val();
		var link3 = $(".class_project_submit_type_value").eq(2).val();
		var link4 = $(".class_project_submit_type_value").eq(3).val();
		var class_start_date = null;
		var class_end_date = null;
		
		if(class_people_max_count.length < 1 || class_people_max_count.length > 3){
			alert("학급 정원을 1~99의 숫자로 입력해주세요");
			$("#class_people_max_count").focus();
			return;
		}else if(class_name.length < 1 || class_name.length > 50){
			alert("학기 수업명을 1자이상 50자 이하로 입력해주세요");
			$("#class_name").focus();
			return;
		}else if(from.length != 10){
			alert("학기 수업기간을 입력해주세요");
			$("#from").focus();
			return;
		}else if(to.length != 10){
			alert("학기 수업기간을 입력해주세요");
			$("#to").focus();
			return;
		}
		class_start_date = from.substring(6,10) + from.substring(0,2) + from.substring(3,5);
		class_end_date = to.substring(6,10) + to.substring(0,2) + to.substring(3,5);
		var data = [];
		if(link1.length > 0){
			var child_data = { "type":type1, "link":link1 };
			data.push(child_data);
		}
		if(link2.length > 0){
			var child_data = { "type":type2, "link":link2 };
			data.push(child_data);
		}
		if(link3.length > 0){
			var child_data = { "type":type3, "link":link3 };
			data.push(child_data);
		}
		if(link4.length > 0){
			var child_data = { "type":type4, "link":link4 };
			data.push(child_data);
		}
		if(data.length > 0){
			var class_project_submit_type = JSON.stringify(data);
			
			var Obj = {
					"class_people_max_count":class_people_max_count,
					"class_name":class_name,
					"class_start_date":class_start_date,
					"class_end_date":class_end_date,
					"class_project_submit_type":class_project_submit_type,
					"class_code":"${class_list.class_code}",
					"mode":"default"
			}
			$.ajax({
				type:"POST",
				url:"/teacher/ready/class_configuration_management_detail_work",
				data:Obj,
				dataType:"text",
				success:function(string){
					if(string != null && string == "success"){
						alert("수업을 수정했습니다.");
						history.go(0);
					}else{
						alert("수업 수정에 실패했습니다.\r다시 시도해주세요");
					}
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert(errorThrown);
				}
			});
		}else{
			alert("과제 제출방법을 하나이상 입력하셔야합니다.");
			return;
		}
		
	});

	/*
	 - STEP 1. 학기 수업 개요 - "삭제하기" 버튼 클릭 이벤트
	 - 해당 클래스를 삭제한다.
	*/
	$("#class_delete_btn").click(function(){
		if (confirm("정말 해당 수업을 삭제하시겠습니까?") == true){
			var data = {"class_code":"${class_list.class_code}"}
			$.ajax({
				type:"POST",
				url:"/teacher/ready/delete_link_work",
				data:data,
				dataType:"text",
				success:function(string){
					if(string != null && string == "success"){
						alert("수업을 삭제했습니다.");
						location.href="/teacher/ready/class_configuration_management_list";
					}else{
						alert("수업 삭제에 실패했습니다.\r다시 시도해주세요");
					}
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert(errorThrown);
				}
			});
		}
	});

	/*
	- STEP 1. 학기 수업 개요 - 전체 공지 링크(과제제출, 오픈채팅, 줌 등) - "+" 버튼 클릭 이벤트
	- 링크를 작성할수 있는 필드가 생성된다.(최소1개 이상, 최대 4개)
	*/
	$(".class_project_submit_type_value_add_btn").click(function(){
		var node_id = $(this).attr("id"); 
		if(node_id == "add_p_s_t1"){
			$("#add_p_s_t1").addClass("hidden_box");
			$("#remove_p_s_t1").addClass("hidden_box");
			$(".class_project_submit_type_parent").eq(1).removeClass("hidden_box");
		}else if(node_id == "add_p_s_t2"){
			$("#add_p_s_t2").addClass("hidden_box");
			$("#remove_p_s_t2").addClass("hidden_box");
			$(".class_project_submit_type_parent").eq(2).removeClass("hidden_box");
		}else if(node_id == "add_p_s_t3"){
			$("#add_p_s_t3").addClass("hidden_box");
			$("#remove_p_s_t3").addClass("hidden_box");
			$(".class_project_submit_type_parent").eq(3).removeClass("hidden_box");
		}
	});

	/*
	- STEP 1. 학기 수업 개요 - 전체 공지 링크(과제제출, 오픈채팅, 줌 등) - "-" 버튼 클릭 이벤트
	- 버튼 좌측 입력 필드가 삭제된다.(최소1개 이상, 최대 4개)
	*/
	$(".class_project_submit_type_value_remove_btn").click(function(){
		var node_id = $(this).attr("id"); 
		if(node_id == "remove_p_s_t2"){
			$("#add_p_s_t1").removeClass("hidden_box");
			$("#remove_p_s_t1").removeClass("hidden_box");
			$(".class_project_submit_type_parent").eq(1).addClass("hidden_box");
			$(".class_project_submit_type_value").eq(1).val("");
		}else if(node_id == "remove_p_s_t3"){
			$("#add_p_s_t2").removeClass("hidden_box");
			$("#remove_p_s_t2").removeClass("hidden_box");
			$(".class_project_submit_type_parent").eq(2).addClass("hidden_box");
			$(".class_project_submit_type_value").eq(2).val("");
		}else if(node_id == "remove_p_s_t4"){
			$("#add_p_s_t3").removeClass("hidden_box");
			$("#remove_p_s_t3").removeClass("hidden_box");
			$(".class_project_submit_type_parent").eq(3).addClass("hidden_box");
			$(".class_project_submit_type_value").eq(3).val("");
		}
	});

	/*
	- STEP 1. 학기 수업 개요 - 전체 공지 링크(과제제출, 오픈채팅, 줌 등) - 필드 - 셀렉트박스 변경 이벤트
	- 셀렉트박스의 옵션이 변경될 때 각 옵션들마다 셀렉트박스 우측의 입력 필드에 별도의 텍스트 안내
	*/
	$(".class_project_submit_type_selectbox").change(function(){
		var node_id = $(this).attr("id");
		var value = null;
		if(node_id == "class_project_submit_type_selectbox1"){
			value = $("#class_project_submit_type_selectbox1 option:selected").val();
		}else if(node_id == "class_project_submit_type_selectbox2"){
			value = $("#class_project_submit_type_selectbox2 option:selected").val();
		}else if(node_id == "class_project_submit_type_selectbox3"){
			value = $("#class_project_submit_type_selectbox3 option:selected").val();
		}else if(node_id == "class_project_submit_type_selectbox3"){
			value = $("#class_project_submit_type_selectbox4 option:selected").val();
		}
		if(value == "이메일"){
			$(this).parent().children('.class_project_submit_type_value').attr("placeholder", "이메일 주소를 입력하세요");
		}else if(value == "N드라이브"){
			$(this).parent().children('.class_project_submit_type_value').attr("placeholder", "N드라이브 링크를 입력하세요");
		}else if(value == "오픈채팅"){
			$(this).parent().children('.class_project_submit_type_value').attr("placeholder", "오픈채팅 링크를 입력하세요");
		}else if(value == "직접입력"){
			$(this).parent().children('.class_project_submit_type_value').attr("placeholder", "직접 입력하세요");
		}
	});
	
	/*
	 - STEP 2. 차시별 수업 관리 - 차시 목록 - "일정 수정" 버튼 클릭 이벤트
	 - 해당 차시의 일정(시작일, 종료일)을 수정할 수 있는 팝업 생성
	*/
	function openPopup(unit_code, unit_start_date, unit_end_date, title){
		$("#curriculum_date_popup_title").val(title);
		if(unit_start_date != "0"){
			$("#curriculum_date_popup_from").val(unit_start_date.substring(4,6)+"/"+unit_start_date.substring(6,8)+"/"+unit_start_date.substring(0,4));
			$("#curriculum_date_popup_from_hour").val(unit_start_date.substring(8,10)).prop("selected", true);
			$("#curriculum_date_popup_from_min").val(unit_start_date.substring(10,12)).prop("selected", true);	
		}else{
			$("#curriculum_date_popup_from").val("");
			$("#curriculum_date_popup_from_hour").val("시").prop("selected",true);
			$("#curriculum_date_popup_from_min").val("분").prop("selected",true);
		}
		
		if(unit_end_date != "0"){
			$("#curriculum_date_popup_to").val(unit_end_date.substring(4,6)+"/"+unit_end_date.substring(6,8)+"/"+unit_end_date.substring(0,4));
			$("#curriculum_date_popup_to_hour").val(unit_end_date.substring(8,10)).prop("selected", true);
			$("#curriculum_date_popup_to_min").val(unit_end_date.substring(10,12)).prop("selected", true);	
		}else{
			$("#curriculum_date_popup_to").val("");
			$("#curriculum_date_popup_to_hour").val("시").prop("selected",true);
			$("#curriculum_date_popup_to_min").val("분").prop("selected",true);
		}
		
		$("#curriculum_date_popup_save").attr("unit_code",unit_code);
		
		$('#curriculum_date_popup').show();
	}

	/*
	 - 일정 수정 팝업 닫기 함수
	*/
	function closePopup(){
		$('#curriculum_date_popup').hide();
	}

	/*
	 - 일정 수정 팝업 - "저장하기" 버튼 클릭 이벤트
	 - 해당 차시의 일정을 수정한다.
	*/
	$("#curriculum_date_popup_save").click(function(){
		var from = $("#curriculum_date_popup_from").val();
		var from_hour = $("#curriculum_date_popup_from_hour option:selected").val();
		var from_min = $("#curriculum_date_popup_from_min option:selected").val();
		var to = $("#curriculum_date_popup_to").val();
		var to_hour = $("#curriculum_date_popup_to_hour option:selected").val();
		var to_min = $("#curriculum_date_popup_to_min option:selected").val();
		
		if(from.length != 10 || to.length != 10 || !$.isNumeric(from_hour) || !$.isNumeric(from_min) || !$.isNumeric(to_hour) || !$.isNumeric(to_min)){
			alert("수업일시를 입력해주세요");
			return;
		}
		
		var unit_start_date = from.substring(6,10) + from.substring(0,2) + from.substring(3,5) + from_hour + from_min;
		var unit_end_date = to.substring(6,10) + to.substring(0,2) + to.substring(3,5) + to_hour + to_min;
		
		var formData = new FormData();
		formData.append("unit_start_date", unit_start_date);
		formData.append("unit_end_date", unit_end_date);
		formData.append("unit_code", $(this).attr("unit_code"));
		formData.append("class_code", "${class_list.class_code}");
		formData.append("mode", "date_update");

		if(!auto_curriculum_isRunning){
			auto_curriculum_isRunning = true;
		
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
						alert("일정을 수정했습니다.");
						history.go(0);
					}else{
						alert("서버가 불안정합니다.\r잠시후 다시 시도해주세요");
					}
					auto_curriculum_isRunning = false;
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert(errorThrown);
					auto_curriculum_isRunning = false;
				}
			});
		}
	});

	/*
	 - STEP 2. 차시별 수업 관리 - 차시 목록 - "복제하기" 버튼 클릭시 실행함수
	 - 클릭 대상 차시를 복제 - 최하단에 복제한 차시를 붙여넣는다.
	*/
	function copy_curriculum(unit_code){
		if (confirm("정말 해당 수업을 복제하시겠습니까?") == true){
			if(!auto_curriculum_isRunning){
				auto_curriculum_isRunning = true;
				
				var formData = new FormData();
				formData.append("unit_code", unit_code);
				formData.append("class_code", "${class_list.class_code}");
				formData.append("mode", "copy");
				
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
							alert("해당 수업을 복제했습니다.");
							history.go(0);
						}else{
							alert("서버가 불안정합니다.\r잠시후 다시 시도해주세요");
						}
						auto_curriculum_isRunning = false;
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert(errorThrown);
						auto_curriculum_isRunning = false;
					}
				});
				
				
			}
		}
	}

	/*
	 - STEP 1. 학기 수업 개요 - "이전 수업 불러오기" 버튼 클릭시 실행함수
	 - 기존에 클래스 정보가 셋팅되어 있다면 해당 버튼이 비활성화(숨김) 처리
	 - 기존에 정상적으로 생성했던 클래스 정보를 그대로 붙여넣는다. ( 자동 저장 )
	*/
	$("#get_before_class_information").click(function(){
		if (confirm("정말 이전 수업을 불러오시겠습니까?") == true){
			if(!auto_curriculum_isRunning){
				auto_curriculum_isRunning = true;
				
				var formData = new FormData();
				formData.append("class_code", "${class_list.class_code}");
				
				$.ajax({
					type:"POST",
					url:"/teacher/ready/class_configuration_management_detail_before_class",
					data:formData,
					cache:false,
					contentType:false,
					processData:false,
					dataType:"text",
					success:function(string){
						if(string == "success"){
							alert("이전 수업을 불러왔습니다.");
							history.go(0);
						}else if(string == "none"){
							alert("이전 수업이 존재하지 않습니다.");
						}else{
							alert("서버가 불안정합니다.\r잠시후 다시 시도해주세요");
						}
						auto_curriculum_isRunning = false;
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert(errorThrown);
						auto_curriculum_isRunning = false;
					}
				});
				
			}
		}
	});

	/*
	 - STEP 2. 차시별 수업 관리 - 차시 목록 - "삭제하기" 버튼 클릭시 실행함수
	 - 클릭 대상 차시를 삭제한다.
	*/
	function delete_curriculum(unit_code){
		if (confirm("정말 해당 수업을 삭제하시겠습니까?") == true){
			if(!auto_curriculum_isRunning){
				auto_curriculum_isRunning = true;
				
				var formData = new FormData();
				formData.append("unit_code", unit_code);
				formData.append("class_code", "${class_list.class_code}");
				formData.append("mode", "delete");

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
							alert("해당 수업을 삭제했습니다.");
							history.go(0);
						}else{
							alert("서버가 불안정합니다.\r잠시후 다시 시도해주세요");
						}
						auto_curriculum_isRunning = false;
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert(errorThrown);
						auto_curriculum_isRunning = false;
					}
				});
			}
		}
	}
	
	</script>
</html>

