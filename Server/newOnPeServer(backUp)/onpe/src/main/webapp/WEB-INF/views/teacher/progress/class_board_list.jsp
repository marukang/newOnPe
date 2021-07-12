<!-- 학급별 게시판 목록 페이지 -->

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
		<style>
			.table_tr{ cursor:pointer; }
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
							<li class="active"><a href="/teacher/progress/class_board_list">학급별 게시판</a></li>
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
						<li><a href="/teacher/ready/class_configuration_management_list">수업 생성/관리</a></li>
					</ul>
				</li>
				<li class="active"><span class="badge warning">수업 진행</span>
					<ul class="depth2">
						<li><a href="/teacher/progress/class_progress_management">실시간 수업 진행</a></li>
						<li class="active"><a href="/teacher/progress/class_board_list">학급별 게시판</a></li>
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
				<h2 class="sub-title">학급별 게시판</h2>

				<div class="box-wrap">
					<div class="filter-wrap">
						<div class="filter-inner flex">
							<div class="field w32">
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
							<div class="field w32">
								<label>학급</label>
								<select id="class_group_selectbox">
									<option>전체</option>
									<c:forTokens var="item" items="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20" delims=",">
										<c:if test="${item == class_group}">
											<option selected>${item}</option>
										</c:if>
										<c:if test="${item != class_group}">
											<option>${item}</option>
										</c:if>
									</c:forTokens>
								</select>
							</div>
							<div class="field w32">
								<label>학기</label>
								<select id="class_semester_selectbox">
									<option>전체</option>
									<c:forTokens var="item" items="1,2" delims=",">
										<c:if test="${item == class_semester}">
											<option selected>${item}</option>
										</c:if>
										<c:if test="${item != class_semester}">
											<option>${item}</option>
										</c:if>
									</c:forTokens>
								</select>
							</div>
							<div class="field w100">
								<label>검색 구분</label>
								<select id="option_selectbox">
									<option>전체</option>
									<c:forTokens var="item" items="이름,아이디,제목" delims=",">
										<c:if test="${item == option}">
											<option selected>${item}</option>
										</c:if>
										<c:if test="${item != option}">
											<option>${item}</option>
										</c:if>
									</c:forTokens>
								</select>
								<input id="keyword_input" type="text" class="search-input ml10" value="${keyword}"/>
							</div>
						</div>

						<div class="btn-wrap">
							<button id="search_btn" class="btn-pt">조회</button>
						</div>
							
					</div>
					<div class="box-content">
						<div class="overflow">
							<table class="basic medium">
								<tr>
									<th>No</th>
									<th>학년</th>
									<th>학급</th>
									<th>이름</th>
									<th>아이디</th>
									<th>제목</th>
									<th>작성일</th>
									<th>댓글수</th>
								</tr>
								<c:set var="Number" value="${community_count - (page-1)*15 }" />
								<c:forEach items="${community_list}" var="community_list">
									<tr class="table_tr" onclick="location.href='/teacher/progress/class_board_detail?community_number=${community_list.community_number}&mode=detail'">
										<td><c:out value="${Number}"/></td>
										
										<td>${fn:substring(community_list.community_class_code,0,1)}</td>
										<c:if test="${fn:substring(community_list.community_class_code,1,2) == '0'}">
											<td>${fn:substring(community_list.community_class_code,2,3)}</td>
										</c:if>
										<c:if test="${fn:substring(community_list.community_class_code,1,2) != '0'}">
											<td>${fn:substring(community_list.community_class_code,1,3)}</td>
										</c:if>
										
										<td>${community_list.community_name}</td>
										<td>${community_list.community_id}</td>
										<td>${community_list.community_title}</td>
										<td>${fn:substring(community_list.community_date,0,4)}-${fn:substring(community_list.community_date,4,6)}-${fn:substring(community_list.community_date,6,8)}</td>
										<td>${community_list.community_count}</td>
									</tr>
									<c:set var="Number" value="${Number-1}" />
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
						
						<div class="btn-wrap">
							<button class="btn-pt" onclick="location.href='/teacher/progress/class_board_detail?mode=create'">글쓰기</button>
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
		
		/* 
		 - 조회 버튼 클릭 이벤트 
		 - 검색어 검증 및 검색값 + 학년 + 학급 + 학기 + 검색구분에 해당하는 목록 재구성
		*/
		$("#search_btn").click(function(){
			var class_grade = $("#class_grade_selectbox option:selected").val();
			var class_group = $("#class_group_selectbox option:selected").val();
			var class_semester = $("#class_semester_selectbox option:selected").val();
			var option = $("#option_selectbox option:selected").val();
			var keyword = $("#keyword_input").val();
			var url = "/teacher/progress/class_board_list?ck=1";
			if(class_grade != "전체"){
				url += "&class_grade="+class_grade;
			}
			if(class_group != "전체"){
				url += "&class_group="+class_group;
			}
			if(class_semester != "전체"){
				url += "&class_semester="+class_semester;
			}
			if(option != "전체"){
				url += "&option="+option;
			}
			if(keyword.length != 0){
				if(keyword.length < 2 || keyword.length > 30){
					alert("검색어는 2자이상 30자 이하로 입력해주세요");
					return;
				}
				url += "&keyword="+keyword;
			}
			
			location.href=url;
		});
	});
	</script>
</html>

