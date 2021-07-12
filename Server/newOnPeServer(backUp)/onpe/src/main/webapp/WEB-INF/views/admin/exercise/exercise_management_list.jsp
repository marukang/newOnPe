<!-- 종목관리 목록 페이지 -->

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
		.exercise_list_tr{ cursor:pointer; }
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
							<li class="active"><a href="/admin/exercise/exercise_management_list">종목 관리</a></li>
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
						<li><a href="/admin/member/lms_member_management_list">회원관리(LMS)</a></li>
						<li><a href="/admin/member/app_member_management_list">회원관리(App)</a></li>
						<li class="active"><a href="/admin/exercise/exercise_management_list">종목 관리</a></li>
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
				<h2 class="sub-title">관리자 메뉴 - 종목관리</h2>

				<div class="box-wrap">
					<div class="filter-wrap">
						<div class="filter-inner flex">
							<div class="field w32">
								<label>종목</label>
								<select id="exercise_name">
									<c:if test="${exercise_name eq'홈트레이닝'}">
										<option>전체</option>
										<option selected>홈트레이닝</option>
									</c:if>
									<c:if test="${exercise_name == null}">
										<option selected>전체</option>
										<option>홈트레이닝</option>
									</c:if>
								</select>
							</div>
							<div class="field w32">
								<label>대분류</label>
								<select id="exercise_category">
									<option>전체</option>
									<c:if test="${exercise_category != null}">
										<option selected>${exercise_category}</option>
									</c:if>
								</select>
							</div>
							<div class="field w32">
								<label>운동 영역</label>
								<select id="exercise_area">
									<option>전체</option>
									<c:if test="${exercise_area == '건강'}">
										<option selected>건강</option>
										<option>도전</option>
										<option>경쟁</option>
										<option>표현</option>
										<option>안전</option>
									</c:if>
									<c:if test="${exercise_area == '도전'}">
										<option>건강</option>
										<option selected>도전</option>
										<option>경쟁</option>
										<option>표현</option>
										<option>안전</option>
									</c:if>
									<c:if test="${exercise_area == '경쟁'}">
										<option>건강</option>
										<option>도전</option>
										<option selected>경쟁</option>
										<option>표현</option>
										<option>안전</option>
									</c:if>
									<c:if test="${exercise_area == '표현'}">
										<option>건강</option>
										<option>도전</option>
										<option>경쟁</option>
										<option selected>표현</option>
										<option>안전</option>
									</c:if>
									<c:if test="${exercise_area == '안전'}">
										<option>건강</option>
										<option>도전</option>
										<option>경쟁</option>
										<option>표현</option>
										<option selected>안전</option>
									</c:if>
									<c:if test="${exercise_area == null}">
										<option>건강</option>
										<option>도전</option>
										<option>경쟁</option>
										<option>표현</option>
										<option>안전</option>
									</c:if>
								</select>
							</div>
							<div class="field w100">
								<label>검색 구분</label>
								<select>
									<option>동작명</option>
								</select>
								<input type="text" id="keyword" class="search-input ml10" value="${keyword}"/>
							</div>
						</div>

						<div class="btn-wrap">
							<button class="btn-pt" id="search_btn">조회</button>
						</div>
							
					</div>
					<div class="box-content">
						<div class="txt-right txt-small">검색갯수: ${exercise_count}</div>
						<div class="overflow">
							<table class="basic medium">
								<tr>
									<th>#</th>
									<th>종목</th>
									<th>대분류</th>
									<th>운동 영역</th>
									<th>동작명</th>
									<th>기본 횟수</th>
									<th>기본 시간</th>
								</tr>
								
								<c:set var="sum" value="${(page-1)*15 + 1}" />
								<c:forEach items="${exercise_list}" var="exercise_list">
									<tr class="exercise_list_tr" onclick="location.href='/admin/exercise/exercise_management_detail?mode=modify&exercise_code=${exercise_list.exercise_code}'">
										<td><c:out value="${sum}"/></td>
										<td>${exercise_list.exercise_name}</td>
										<td>${exercise_list.exercise_category}</td>
										<td>
										<c:set var="inside_sum" value="1" />
										<c:forEach items="${exercise_list.exercise_area_temp}" var="exercise_area_temp">
										<c:if test='${inside_sum == 1}'>
										<c:out value="${exercise_area_temp}" />
										</c:if>
										<c:if test='${inside_sum != 1}'>
										, <c:out value="${exercise_area_temp}" />
										</c:if>
										<c:set var="inside_sum" value="${inside_sum+1}" />	
										</c:forEach>
										</td>
										<td>${exercise_list.exercise_detail_name}</td>
										<td>${exercise_list.exercise_count}</td>
										<td>${exercise_list.exercise_time}</td>
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
							<button id="add_btn" class="btn-pt" onclick="location.href='/admin/exercise/exercise_management_detail?mode=create'">등록하기</button>
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
		
		/* 종목, 대분류 object */
		var category_obj = JSON.parse('${exercise_name_obj}');
		
		$(document).ready(function(){
			
			/* 최초 상단 셀렉트박스 셋팅 */
			
			var value = $("#exercise_name option:selected").val();
			if(value == "전체"){
				$("#exercise_category").children('option').remove();
				$("#exercise_category").append("<option>전체</option>");
			}else{
				$("#exercise_category").children('option').remove();
				$("#exercise_category").append("<option>전체</option>");
				for(x=0;x<category_obj[value].length;x++){
					if(category_obj[value][x] == "${exercise_category}"){
						$("#exercise_category").append("<option selected>"+category_obj[value][x]+"</option>");
					}else{
						$("#exercise_category").append("<option>"+category_obj[value][x]+"</option>");	
					}
				}
			}
		});
		
		/* 종목 변경시 대분류 목록도 변경시키기 */
		$("#exercise_name").change(function(){
			var value = $("#exercise_name option:selected").val();
			if(value == "전체"){
				$("#exercise_category").children('option').remove();
				$("#exercise_category").append("<option>전체</option>");
			}else{
				$("#exercise_category").children('option').remove();
				$("#exercise_category").append("<option>전체</option>");
				for(x=0;x<category_obj[value].length;x++){
					$("#exercise_category").append("<option>"+category_obj[value][x]+"</option>");
				}
			}
		});
		
		/* 조회버튼 클릭 이벤트 */
		$("#search_btn").click(function(){
			var exercise_name = $("#exercise_name option:selected").val();
			var exercise_category = $("#exercise_category option:selected").val();
			var exercise_area = $("#exercise_area option:selected").val();
			var keyword = $("#keyword").val();
			var url = "/admin/exercise/exercise_management_list?ck=1";
			if(exercise_name != "전체"){
				url += "&exercise_name="+exercise_name;
			}
			if(exercise_category != "전체"){
				url += "&exercise_category="+exercise_category;
			}
			if(exercise_area != "전체"){
				url += "&exercise_area="+exercise_area;
			}
			
			if(keyword.length > 0 && ( keyword.length < 2 || keyword.length > 30 )){
				alert("동작명을 2자 이상 30자 이하로 입력해주세요");
				$("#keyword").val("");
				$("#keyword").focus();
			}else{
				
				if(keyword.length != 0){
					url += "&keyword="+keyword;
				}
				
				location.href=url;
				
			}
			
		});
		
	});
	</script>
</html>
