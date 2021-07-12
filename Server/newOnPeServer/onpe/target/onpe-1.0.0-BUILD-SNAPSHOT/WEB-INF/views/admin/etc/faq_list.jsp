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
			<h1 class="logo"><a href="#"><img src="/asset/images/logo.png" alt="" /></a></h1>
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
					<li><span class="slide-tab">관리자 메뉴</span>
						<ul class="depth2">
							<li><a href="/admin/member/lms_member_management_list">회원관리(LMS)</a></li>
							<li><a href="/admin/member/app_member_management_list">회원관리(App)</a></li>
							<li><a href="/admin/exercise/exercise_management_list">종목 관리</a></li>
							<li><a href="/admin/popup/popup_management_list">팝업창 관리</a></li>
							<li><a href="/admin/push/push_management_list">PUSH 관리</a></li>
							<li><a href="/admin/etc/notice_list">공지사항 관리</a></li>
							<li class="active"><a href="/admin/etc/faq_list">FAQ 관리</a></li>
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
						<li><a href="/admin/member/lms_member_management_list">회원관리(LMS)</a></li>
						<li><a href="/admin/member/app_member_management_list">회원관리(App)</a></li>
						<li><a href="/admin/exercise/exercise_management_list">종목 관리</a></li>
						<li><a href="/admin/popup/popup_management_list">팝업창 관리</a></li>
						<li><a href="/admin/push/push_management_list">PUSH 관리</a></li>
						<li><a href="/admin/etc/notice_list">공지사항 관리</a></li>
						<li class="active"><a href="/admin/etc/faq_list">FAQ 관리</a></li>
						<li><a href="/admin/etc/qna_list">1:1문의 관리</a></li>
					</ul>
				</li>
			</ul>
		</div>

		<div class="content">
			<div class="wrapper">
				<h2 class="sub-title">관리자 메뉴 - FAQ 관리</h2>

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
									<tr class="faq_list_tr" onclick="location.href='/admin/etc/faq_detail?mode=modify&faq_number=${faq_list.faq_number}'">
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

						<div class="btn-wrap">
							<button class="btn-pt" onclick="location.href='/admin/etc/faq_detail?mode=create'">등록하기</button>
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
			location.href="/admin/etc/faq_list"
		});
		
		/* 상단 조회 버튼 클릭 이벤트 */
		$("#search_btn").click(function(){
			form_check();
		});
		
		/* 검색값 입력 필드 Enter 키다운 이벤트 */
		$("#search_input").keydown(function(key){
			if(key.keyCode == 13){
				form_check();
			}
		});
		
		/* 검색어 검증 및 검색값&검색구분에 해당하는 목록 재구성 함수 */
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
			var url = "/admin/etc/faq_list?ck=1";
			url += "&option="+option;
			if(keyword.length != 0){
				url += "&keyword="+keyword;
			}
			location.href=url;
			
		}
	});
	</script>
</html>
