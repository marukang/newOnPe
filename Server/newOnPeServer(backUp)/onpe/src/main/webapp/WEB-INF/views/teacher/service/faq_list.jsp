<!-- FAQ 목록 페이지 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
		<style>
			.faq_list_tr{ cursor:pointer; }
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
							<li><a href="/teacher/ready/class_configuration_management_list">수업 생성/관리</a></li>
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
					<!-- <li><span>교사 커뮤니티</span>
						<ul class="depth2">
							<li><a href="#">추천 학습 자료</a></li>
							<li><a href="#">종목별 백서</a></li>
						</ul>
					</li> -->
					<li><span class="slide-tab">서비스</span>
						<ul class="depth2">
							<li><a href="/teacher/service/notice_list">공지사항</a></li>
							<li class="active"><a href="/teacher/service/faq_list">FAQ</a></li>
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
						<li><a href="/teacher/ready/class_configuration_management_list">수업 생성/관리</a></li>
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
				<!-- <li class="active"><span>교사 커뮤니티</span>
					<ul class="depth2">
						<li><a href="#">추천 학습 자료</a></li>
						<li><a href="#">종목별 백서</a></li>
					</ul>
				</li> -->
				<li class="active"><span class="slide-tab">서비스</span>
					<ul class="depth2">
						<li><a href="/teacher/service/notice_list">공지사항</a></li>
						<li class="active"><a href="/teacher/service/faq_list">FAQ</a></li>
						<li><a href="/teacher/service/qna_list">1:1 문의</a></li>
					</ul>
				</li>
			</ul>
		</div>

		<div class="content">
			<div class="wrapper">
				<h2 class="sub-title">서비스 - FAQ</h2>
				
				<div class="box-wrap">
					<div class="filter-wrap">
						<div class="filter-inner flex">
							<div class="field w100">
								<label>검색 구분</label>
								<select id="option_selectBox">
									<c:if test="${option == null or option == '전체'}">
										<option selected="selected">전체</option>
										<option>제목</option>
										<option>내용</option>
									</c:if>
									<c:if test="${option == '제목'}">
										<option>전체</option>
										<option selected="selected">제목</option>
										<option>내용</option>
									</c:if>
									<c:if test="${option == '내용'}">
										<option>전체</option>
										<option>제목</option>
										<option selected="selected">내용</option>
									</c:if>
								</select>
								<input id="search_input" type="text" class="search-input ml10" value="${keyword}" />
							</div>
						</div>

						<div class="btn-wrap">
							<button class="btn-pt" id="search_btn">조회</button>
							<button class="btn-sec" id="reset_btn">초기화</button>
						</div>
							
					</div>
					<div class="box-content">
						<div class="overflow">
							<table class="basic medium">
								<tr>
									<th style="width:10%">No</th>
									<th style="width:60%">제목</th>
									<th style="width:15%">타입</th>
									<th style="width:15%">등록일</th>
								</tr>
								<c:set var="sum" value="${(page-1)*15 + 1}" />
								<c:forEach items="${faq_list}" var="faq_list">
									<tr class="faq_list_tr" onclick="location.href='/teacher/service/faq_detail?faq_number=${faq_list.faq_number}'">
										<td style="width:10%"><c:out value="${sum}"/></td>
										<td style="width:60%">${faq_list.faq_title}</td>
										<td style="width:15%">${faq_list.faq_type}</td>
										<td style="width:15%">${fn:substring(faq_list.faq_date,0,4)}-${fn:substring(faq_list.faq_date,4,6)}-${fn:substring(faq_list.faq_date,6,8)}</td>
									</tr>
									<c:set var="sum" value="${sum+1}" />
								</c:forEach>
							</table>
						</div>
						
						<div class="paging">
							<!-- 옵션, 키워드 현재 페이지를 고려해서 해야함 -->
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
		
		/* 상단 초기화 버튼 클릭 이벤트 */
		$("#reset_btn").click(function(){
			location.href="/teacher/service/faq_list"
		});
		
		/* 상단 조회 버튼 클릭 이벤트 */
		$("#search_btn").click(function(){
			form_check();
		});
		
		/* 상단 검색 입력 필드 Enter 키다운 이벤트 */
		$("#search_input").keydown(function(key){
			if(key.keyCode == 13){
				form_check();
			}
		});
		
		/*
		검색구분 옵션 + 검색어에 해당하는 FAQ 목록 재구성
		*/
		function form_check(){
			
			var option = $("#option_selectBox option:selected").val();
			var keyword = $("#search_input").val();
			console.log(keyword.length);
			if(option != "전체" && option != "제목" && option != "내용"){
				alert("검색 구분을 선택해 주세요");
				$("#option_selectBox").focus();
				return;
			}
			if(keyword.length == 0 || ( keyword.length < 2 || keyword.length > 50 )){
				alert("검색어는 2자 이상 50자 이하로 입력해주세요.");
				$("#search_input").focus();
				return;
			}
			var url = "/teacher/service/faq_list?ck=1";
			url += "&option="+option;
			if(keyword.length != 0){
				url += "&keyword="+keyword;
			}
			location.href=url;
			
		}
	});
	</script>
</html>
