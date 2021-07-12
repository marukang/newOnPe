<!-- 회원관리(LMS) 목록 페이지 -->

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
			.teacher_list_tr{ cursor:pointer; }
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
					<li class="active"><span class="slide-tab">관리자 메뉴</span>
						<ul class="depth2" style="display:block;">
							<li class="active"><a href="/admin/member/lms_member_management_list">회원관리(LMS)</a></li>
							<li><a href="/admin/member/app_member_management_list">회원관리(App)</a></li>
							<li><a href="/admin/exercise/exercise_management_list">종목 관리</a></li>
							<li><a href="/admin/popup/popup_management_list">팝업창 관리</a></li>
							<li><a href="/admin/push/push_management_list">PUSH 관리</a></li>
							<li><a href="/admin/etc/notice_list">공지사항 관리</a></li>
							<li><a href="/admin/etc/faq_list">FAQ 관리</a></li>
							<li><a href="/admin/etc/qna_list">1:1문의 관리</a></li>
						</ul>
					</li>
				</ul>
			</div>
		</div>
	</div>

	<div class="wrap">

		<div class="lnb">
			<ul class="depth1">
				<li class="active"><span class="slide-tab">관리자 메뉴</span>
					<ul class="depth2">
						<li class="active"><a href="/admin/member/lms_member_management_list">회원관리(LMS)</a></li>
						<li><a href="/admin/member/app_member_management_list">회원관리(App)</a></li>
						<li><a href="/admin/exercise/exercise_management_list">종목 관리</a></li>
						<li><a href="/admin/popup/popup_management_list">팝업창 관리</a></li>
						<li><a href="/admin/push/push_management_list">PUSH 관리</a></li>
						<li><a href="/admin/etc/notice_list">공지사항 관리</a></li>
						<li><a href="/admin/etc/faq_list">FAQ 관리</a></li>
						<li><a href="/admin/etc/qna_list">1:1문의 관리</a></li>
					</ul>
				</li>
			</ul>
		</div>

		<div class="content">
			<div class="wrapper">
				<h2 class="sub-title">관리자 메뉴 - 회원관리</h2>

				<div class="box-wrap">
					<div class="filter-wrap">
						<div class="filter-inner flex">
							<div class="field w100">
								<label>검색 구분</label>
								<select id="option_selectBox">
									<c:if test="${option eq'teacher_name'}">
										<option selected>이름</option>
										<option>아이디</option>
									</c:if>
									<c:if test="${option eq'teacher_id'}">
										<option>이름</option>
										<option selected>아이디</option>
									</c:if>
									
									<c:if test="${option ne 'teacher_id' and option ne 'teacher_name'}">
										<option selected>이름</option>
										<option>아이디</option>
									</c:if>
								</select>
								
								<c:if test="${keyword != null}">
									<input id="search_input" type="text" class="search-input ml10" value="${keyword}"/>
								</c:if>
								
								<c:if test="${keyword == null}">
									<input id="search_input" type="text" class="search-input ml10" />
								</c:if>
							</div>
						</div>

						<div class="btn-wrap">
							<button id="search_btn" class="btn-pt">조회</button>
						</div>
							
					</div>
					<div class="box-content">
						<c:if test="${keyword != null and option != null}">
							<div class="txt-right txt-small">검색 회원수: ${teacher_count}명</div>
						</c:if>
						<c:if test="${keyword == null and option == null}">
							<div class="txt-right txt-small">회원수: ${teacher_count}명</div>
						</c:if>
						<div class="overflow">
							<table class="basic medium">
								<tr>
									<th>#</th>
									<th>이름</th>
									<th>아이디</th>
									<th>전화번호</th>
									<th>성별</th>
									<th>가입일</th>
								</tr>
								<c:set var="sum" value="${(page-1)*15 + 1}" />
								<c:forEach items="${teachers_list}" var="teachers_list">
									<tr class="teacher_list_tr" onclick="location.href='/admin/member/lms_member_management_detail?teacher_id=${teachers_list.teacher_id}&mode=modify'">
										<td><c:out value="${sum}"/></td>
										<td>${teachers_list.teacher_name}</td>
										<td>${teachers_list.teacher_id}</td>
										<td>${fn:substring(teachers_list.teacher_phone,0,3)}-${fn:substring(teachers_list.teacher_phone,3,7)}-${fn:substring(teachers_list.teacher_phone,7,11)}</td>
										<c:if test="${teachers_list.teacher_sex eq 'm'}">
											<td>남자</td>
										</c:if>
										<c:if test="${teachers_list.teacher_sex eq 'f'}">
											<td>여자</td>
										</c:if>
										<td>${fn:substring(teachers_list.teacher_join_date,0,4)}-${fn:substring(teachers_list.teacher_join_date,4,6)}-${fn:substring(teachers_list.teacher_join_date,6,8)}</td>
									</tr>
									<c:set var="sum" value="${sum+1}" />
								</c:forEach>
								
							</table>
						</div>
						
						<div class="paging">
							<!-- 옵션, 키워드 현재 페이지를 고려해서 해야함 -->
							<c:if test="${page ne '1'}">
							
								<c:if test="${option eq'teacher_name'}">
									<button class="page-arrow go-first" onclick="location.href='/admin/member/lms_member_management_list?page=1&option=이름&keyword=${keyword}'">처음으로</button>
									<button class="page-arrow go-prev" onclick="location.href='/admin/member/lms_member_management_list?page=${page-1}&option=이름&keyword=${keyword}'">이전</button>
								</c:if>
								<c:if test="${option eq'teacher_id'}">
									<button class="page-arrow go-first" onclick="location.href='/admin/member/lms_member_management_list?page=1&option=아이디&keyword=${keyword}'">처음으로</button>
									<button class="page-arrow go-prev" onclick="location.href='/admin/member/lms_member_management_list?page=${page-1}&option=아이디&keyword=${keyword}'">이전</button>
								</c:if>
								
								<c:if test="${option ne 'teacher_id' and option ne 'teacher_name'}">
									<button class="page-arrow go-first" onclick="location.href='/admin/member/lms_member_management_list?page=1'">처음으로</button>
									<button class="page-arrow go-prev" onclick="location.href='/admin/member/lms_member_management_list?page=${page-1}'">이전</button>
								</c:if>
								
							</c:if>
							<ul class="page-num">
								<c:forEach var="index" begin="${pageing_start}" end="${pageing_last}">
								<c:if test="${page eq index}">
									<li class="active">${index}</li>
								</c:if>
								<c:if test="${page ne index}">
								
									<c:if test="${option eq'teacher_name'}">
										<li onclick="location.href='/admin/member/lms_member_management_list?page=${index}&option=이름&keyword=${keyword}'">${index}</li>
									</c:if>
									<c:if test="${option eq'teacher_id'}">
										<li onclick="location.href='/admin/member/lms_member_management_list?page=${index}&option=아이디&keyword=${keyword}'">${index}</li>
									</c:if>
									
									<c:if test="${option ne 'teacher_id' and option ne 'teacher_name'}">
										<li onclick="location.href='/admin/member/lms_member_management_list?page=${index}'">${index}</li>
									</c:if>
								
								</c:if>
								</c:forEach>
							</ul>
							<c:if test="${page ne last_page and last_page != '0'}">
								<c:if test="${option eq'teacher_name'}">
									<button class="page-arrow go-next" onclick="location.href='/admin/member/lms_member_management_list?page=${page+1}&option=이름&keyword=${keyword}'">다음</button>
									<button class="page-arrow go-last" onclick="location.href='/admin/member/lms_member_management_list?page=${last_page}&option=이름&keyword=${keyword}'">끝으로</button>
								</c:if>
								<c:if test="${option eq'teacher_id'}">
									<button class="page-arrow go-next" onclick="location.href='/admin/member/lms_member_management_list?page=${page+1}&option=아이디&keyword=${keyword}'">다음</button>
									<button class="page-arrow go-last" onclick="location.href='/admin/member/lms_member_management_list?page=${last_page}&option=아이디&keyword=${keyword}'">끝으로</button>
								</c:if>
								
								<c:if test="${option ne 'teacher_id' and option ne 'teacher_name'}">
									<button class="page-arrow go-next" onclick="location.href='/admin/member/lms_member_management_list?page=${page+1}'">다음</button>
									<button class="page-arrow go-last" onclick="location.href='/admin/member/lms_member_management_list?page=${last_page}'">끝으로</button>
								</c:if>
								
							</c:if>
						</div>

						<div class="btn-wrap">
							<button id="add_btn" class="btn-pt" onclick="location.href='/admin/member/lms_member_management_detail?mode=create'">등록하기</button>
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
		
		/* 조회 버튼 클릭 이벤트 */
		$("#search_btn").click(function(){
			form_check();
		});
		
		/* 검색 입력 필드 Enter 키다운 이벤트 */
		$("#search_input").keydown(function(key){
			if(key.keyCode == 13){
				form_check();
			}
		});
		
		/* 검색구분&검색어에 해당하는 회원 목록 재구성 함수(페이지 리로드) */
		function form_check(){
			
			var option = $("#option_selectBox option:selected").val();
			var keyword = $("#search_input").val();
			if(option != "이름" && option != "아이디"){
				alert("이름 또는 아이디를 선택해주세요.");
				$("#option_selectBox").focus();
			}else if(keyword.length < 2 || keyword.length > 20){
				alert("검색어는 2자 이상 20자 이하로 입력해주세요.");
				$("#search_input").focus();
			}else{
				location.href='/admin/member/lms_member_management_list?option='+option+'&keyword='+keyword;
			}
			
		}
	});
	</script>
</html>