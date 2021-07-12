<!-- 수업 생성/관리 목록 페이지 -->
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


		<script src="/asset/lib/jquery-1.11.3.min.js"></script>
		<script src="/asset/lib/jquery-ui.js"></script>
		<script src="/asset/lib/swiper-bundle.min.js"></script>
		<script src="/asset/js/script.js"></script>
		<base href="/" />
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
		
		<div id="popup" class="popup" style="display:none;">
			<div class="popup-cont small-pop">
				<div class="pop-title flex justify-space">
					<div class="left flex">
						<h2 id="popup_title"></h2>
					</div>
					<div class="right">
						<button id="popup_close" class="close">x</button>
					</div>
				</div>
				<div class="pop-cont">
					<div class="pop-cont-inner">
						
						<div id="popup_content">
						</div>
					
					</div>
					
					<div class="btn-wrap">
						<button id="popup_close2" class="btn-pt">닫기</button>
					</div>
				</div>
			</div>
		</div>

		<div class="content">
			<div class="wrapper">
				<h2 class="sub-title">수업 생성/관리</h2>
				<div class="box-wrap">
					<div class="filter-wrap">
						<div class="filter-inner flex">
							<div class="field w24">
								<label>학년</label>
								<select id="class_grade_selectbox">
									<option>전체</option>
									<c:forTokens var="item" items="1,2,3,4,5,6" delims=",">
										<c:if test="${item == class_grade}">
											<option selected>${item}</option>
										</c:if>
										<c:if test="${item != class_grade}">
											<option>${item}</option>
										</c:if>
									</c:forTokens>
								</select>
							</div>
							<div class="field w24">
								<label>학급</label>
								<select id="class_group_selectbox">
									<option>전체</option>
									<c:forTokens var="item2" items="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20" delims=",">
										<c:if test="${item2 == class_group}">
											<option selected>${item2}</option>
										</c:if>
										<c:if test="${item2 != class_group}">
											<option>${item2}</option>
										</c:if>
									</c:forTokens>
								</select>
							</div>

							<div class="field flex w49">
								<label>기간</label>
								<div class="date-range">
									<c:if test="${class_start_date != null}">
										<input type="text" id="from" name="from" autocomplete="off" value="${fn:substring(class_start_date,4,6)}/${fn:substring(class_start_date,6,8)}/${fn:substring(class_start_date,0,4)}">
										<span class="datemark">~</span>
										<input type="text" id="to" name="to" autocomplete="off" value="${fn:substring(class_end_date,4,6)}/${fn:substring(class_end_date,6,8)}/${fn:substring(class_end_date,0,4)}">
									</c:if>
									<c:if test="${class_start_date == null}">
										<input type="text" id="from" autocomplete="off" name="from">
										<span class="datemark">~</span>
										<input type="text" id="to" autocomplete="off" name="to">
									</c:if>
								</div>
								
							</div>
							<div class="field w100">
								<label>검색 구분</label>
								<select id="class_search_selectbox">
									<option>수업명</option>
								</select>
								<input id="search_keyword" type="text" class="search-input ml10" value="${keyword}" />
							</div>
						</div>

						<div class="btn-wrap">
							<button class="btn-pt" id="search_btn">조회</button>
						</div>
					</div>
					<div class="box-content">
						<div class="overflow">
							<table class="basic wide link">
								<tr>
									<th>No</th>
									<th>학년</th>
									<th>학급</th>
									<th>수업명<span id="question_mark_class_name" class="question-mark">?</span></th>
									<th></th>
									<th>수업 초대 코드<span id="question_mark_class_code" class="question-mark">?</span></th>
									<th>참여 인원<span id="question_mark_class_people_count" class="question-mark">?</span></th>
									<th>시작일</th>
									<th>종료일</th>
									<th>상태</th>
								</tr>
								<c:set var="sum" value="${(page-1)*15 + 1}" />
								<c:forEach items="${class_list}" var="class_list">
									<tr>
										<td><c:out value="${sum}"/></td>
										<td>${class_list.class_grade}</td>
										<td>${class_list.class_group}</td>
										<c:if test="${class_list.class_name == null}">
											<td><a href="/teacher/ready/class_configuration_management_detail?class_code=${class_list.class_code}">${class_list.class_grade}학년 ${class_list.class_group}반 ${class_list.class_semester}학기 수업</a></td>
										</c:if>
										<c:if test="${class_list.class_name != null}">
											<td><a href="/teacher/ready/class_configuration_management_detail?class_code=${class_list.class_code}">${class_list.class_name}</a></td>
										</c:if>
										<c:if test="${class_list.class_end_date == null}">
											<td><button class="btn-s-round-l mr10" onclick="location.href='/teacher/ready/class_configuration_management_detail?class_code=${class_list.class_code}'">클릭!</button></td>
										</c:if>
										<c:if test="${class_list.class_end_date != null}">
											<td></td>
										</c:if>
										<td class="copy-txt"> 
											<input id="copy${sum}" class="class_code" type="text" value="${class_list.class_code}" disabled/>
											<button class="copy-btn"  data-clipboard-target="#copy1">Copy</button>
										</td>
										<td>${class_list.class_people_count}/${class_list.class_people_max_count}명</td>
										<c:if test="${class_list.class_start_date == null}">
											<td>-</td>
										</c:if>
										<c:if test="${class_list.class_start_date != null}">
											<td>${fn:substring(class_list.class_start_date,0,4)}-${fn:substring(class_list.class_start_date,4,6)}-${fn:substring(class_list.class_start_date,6,8)}</td>
										</c:if>
										<c:if test="${class_list.class_end_date == null}">
											<td>-</td>
										</c:if>
										<c:if test="${class_list.class_end_date != null}">
											<td>${fn:substring(class_list.class_end_date,0,4)}-${fn:substring(class_list.class_end_date,4,6)}-${fn:substring(class_list.class_end_date,6,8)}</td>
										</c:if>										
										<c:if test="${class_list.class_start_date == null}">
											<td class="alert-success">수업 준비중</td>
										</c:if>
										<c:if test="${class_list.class_start_date != null}">
											<c:if test="${class_list.class_state == '3' }">
												<td class="alert-success">수업 마감</td>
											</c:if>
											<c:if test="${class_list.class_state != '3' }">
												<c:if test="${class_list.class_start_date > nowDate }">
													<td class="alert-success">수업 준비중</td>
												</c:if>
												<c:if test="${class_list.class_start_date <= nowDate and class_list.class_end_date >= nowDate }">
													<td class="alert-success">수업 진행중</td>
												</c:if>
												<c:if test="${class_list.class_start_date < nowDate and class_list.class_end_date < nowDate }">
													<td class="alert-success">수업 종료</td>
												</c:if>
											</c:if>
										</c:if>
									</tr>
									<c:set var="sum" value="${sum+1}" />
								</c:forEach>
							</table>
						</div>
						
						<div class="paging mt10">
							<c:if test="${page ne '1'}">
								<button class="page-arrow go-first" onclick="location.href='${pageing_url}&page=1'">처음으로</button>
								<button class="page-arrow go-prev" onclick="location.href='${pageing_url}&page=${page-1}'">이전</button>
							</c:if>
							<ul class="page-num">
								<c:forEach var="index" begin="${pageing_start}" end="${pageing_last}">
									<c:if test="${page eq index}">
										<li class="active">${index}</li>
									</c:if>
									<c:if test="${page ne index}">
										<li onclick="location.href='${pageing_url}&page=${index}'">${index}</li>
									</c:if>
								</c:forEach>
							</ul>
							<c:if test="${page ne last_page and last_page != '0'}">
								<button class="page-arrow go-next" onclick="location.href='${pageing_url}&page=${page+1}'">다음</button>
								<button class="page-arrow go-last" onclick="location.href='${pageing_url}&page=${last_page}'">끝으로</button>
							</c:if>
						</div>
					</div>
				</div>
			</div>

			<div class="footer">
				<p>copyright 컴플렉시온 ⓒ All rights reserved.</p>
			</div>
		</div>
	</div>	
	</body>
	<script>
	$(document).ready(function(){
		
	});
	
	/* 가이드 팝업 닫기(X) 버튼 클릭 이벤트 */
	$("#popup_close").click(function(){
		$("#popup").css("display","none");
	});
	
	/* 가이드 팝업 "닫기" 버튼 클릭 이벤트 */
	$("#popup_close2").click(function(){
		$("#popup").css("display","none");
	});
	
	/* 수업명 물음표 클릭 이벤트 */
	$("#question_mark_class_name").click(function(){
		popup_on("물음표 - 수업명 이란?","각 수업을 구분하기위한 제목입니다.");
	});
	
	/* 수업 초대 코드 물음표 클릭 이벤트 */
	$("#question_mark_class_code").click(function(){
		popup_on("물음표 - 수업 초대 코드란?","앱에서 선생님이 개설하는 수업에 들어오기 위한 코드입니다.");
	});
	
	/* 참여 인원 물음표 클릭 이벤트 */
	$("#question_mark_class_people_count").click(function(){
		popup_on("물음표 - 참여 인원이란?","현재 참여중인 학생들의 숫자 입니다.");
	});
	
	/* 물음표 팝업 ON */
	function popup_on(title, content){
		$("#popup_title").text(title);
		$("#popup_content").text(content);
		$("#popup").css("display","block");
	}
	
	/* 클래스코드 복사 버튼 클릭 이벤트 */
	$(".copy-btn").click(function(){
		var value = $(this).parent().children(".class_code").val();
		if(value.length > 8){
			var t = document.createElement("textarea");
			document.body.appendChild(t);
			t.value = value;
			t.select();
			document.execCommand('copy');
			document.body.removeChild(t);
			alert("초대코드를 복사했습니다.");
		}
	});
	
	/* 
	 - 상단 조회하기 버튼 클릭 이벤트
	 - 학년, 학급, 클래스 기간, 검색구분, 검색어 등 옵션들을 포함하여 클래스 목록 재구성 
	*/
	$("#search_btn").click(function(){
		var class_grade = $("#class_grade_selectbox option:selected").val();
		var class_group = $("#class_group_selectbox option:selected").val();
		var class_start_date_t = $("#from").val();
		var class_end_date_t = $("#to").val();
		var class_start_date = null;
		var class_end_date = null;
		var keyword = $("#search_keyword").val();
		var url = "/teacher/ready/class_configuration_management_list?ck=1";
		if(class_grade == "전체"){
			class_grade = null;
		}else{
			url += "&class_grade="+class_grade;
		}
		if(class_group == "전체"){
			class_group = null;
		}else{
			url += "&class_group="+class_group;
		}
		if(class_start_date_t.length == 0 && class_end_date_t.length > 0){
			alert("기간을 선택해주세요");
			$("#from").focus();
			return;
		}else if(class_start_date_t.length > 0 && class_end_date_t.length == 0){
			alert("기간을 선택해주세요");
			$("#to").focus();
			return;
		}else if(class_start_date_t.length == 10 && class_end_date_t.length == 10){
			class_start_date = class_start_date_t.substring(6,10) + class_start_date_t.substring(0,2) + class_start_date_t.substring(3,5);
			class_end_date = class_end_date_t.substring(6,10) + class_end_date_t.substring(0,2) + class_end_date_t.substring(3,5);
			url += "&class_start_date="+class_start_date;
			url += "&class_end_date="+class_end_date;
		}
		
		if(keyword.length != 0 && (keyword.length < 2 || keyword.length > 50)){
			alert("검색하실 수업명을 2자이상 50자 이하로 입력해주세요");
			$("#search_keyword").focus();
			return;
		}else if(keyword.length == 0){
			keyword = null;
		}else{
			url += "&keyword="+keyword;
		}
		location.href=url;
	});
	</script>
</html>

