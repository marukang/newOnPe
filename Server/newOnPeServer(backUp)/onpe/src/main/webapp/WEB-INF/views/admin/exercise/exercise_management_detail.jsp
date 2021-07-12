<!-- 종목관리 등록, 상세 페이지 -->

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
					
					<div class="box-content">
						<div class="form">
						
							<div class="field w24">
								<div class="field-inner">
									<label>종목</label>
									<select id="exercise_name">
										<c:if test="${mode == 'modify' and exercise.exercise_name eq'홈트레이닝'}">
											<option>선택</option>
											<option selected>홈트레이닝</option>
										</c:if>
										<c:if test="${mode == 'create'}">
											<option selected>선택</option>
											<option>홈트레이닝</option>
										</c:if>
									</select>
								</div>
							</div>
							
							<div class="field w24">
								<div class="field-inner">
									<label>대분류</label>
									<select id="exercise_category">
										<c:if test="${mode == 'modify'}">
											<option selected>${exercise.exercise_category}</option>
										</c:if>
										<c:if test="${mode == 'create'}">
											<option selected>선택</option>
										</c:if>
									</select>
								</div>
							</div>
							
							<div class="field w49">
								<div class="field-inner">
									<label>운동 영역(중복선택 가능)</label>
									<div class="checks flex">
										<c:if test="${mode == 'modify'}">
											<c:choose>
												<c:when test='${fn:contains(exercise.exercise_area, "건강")}'>
													<label><input id="exercise_area1" type="checkbox" value="건강" checked="checked"/><span class="custom-check"></span>건강</label>
												</c:when>
												<c:otherwise>
													<label><input id="exercise_area1" type="checkbox" value="건강"/><span class="custom-check"></span>건강</label>
												</c:otherwise>
											</c:choose>
											
											<c:choose>
												<c:when test='${fn:contains(exercise.exercise_area, "도전")}'>
													<label><input id="exercise_area2" type="checkbox" value="도전" checked="checked"/><span class="custom-check"></span>도전</label>
												</c:when>
												<c:otherwise>
													<label><input id="exercise_area2" type="checkbox" value="도전"/><span class="custom-check"></span>도전</label>
												</c:otherwise>
											</c:choose>
											
											<c:choose>
												<c:when test='${fn:contains(exercise.exercise_area, "경쟁")}'>
													<label><input id="exercise_area3" type="checkbox" value="경쟁" checked="checked"/><span class="custom-check"></span>경쟁</label>
												</c:when>
												<c:otherwise>
													<label><input id="exercise_area3" type="checkbox" value="경쟁"/><span class="custom-check"></span>경쟁</label>
												</c:otherwise>
											</c:choose>
											
											<c:choose>
												<c:when test='${fn:contains(exercise.exercise_area, "표현")}'>
													<label><input id="exercise_area4" type="checkbox" value="표현" checked="checked"/><span class="custom-check"></span>표현</label>
												</c:when>
												<c:otherwise>
													<label><input id="exercise_area4" type="checkbox" value="표현"/><span class="custom-check"></span>표현</label>
												</c:otherwise>
											</c:choose>
											
											<c:choose>
												<c:when test='${fn:contains(exercise.exercise_area, "안전")}'>
													<label><input id="exercise_area5" type="checkbox" value="안전" checked="checked"/><span class="custom-check"></span>안전</label>
												</c:when>
												<c:otherwise>
													<label><input id="exercise_area5" type="checkbox" value="안전"/><span class="custom-check"></span>안전</label>
												</c:otherwise>
											</c:choose>
											
										</c:if>
										<c:if test="${mode == 'create'}">
											<label><input id="exercise_area1" type="checkbox" value="건강" /><span class="custom-check"></span>건강</label>
											<label><input id="exercise_area2" type="checkbox" value="도전" /><span class="custom-check"></span>도전</label>
											<label><input id="exercise_area3" type="checkbox" value="경쟁" /><span class="custom-check"></span>경쟁</label>
											<label><input id="exercise_area4" type="checkbox" value="표현" /><span class="custom-check"></span>표현</label>
											<label><input id="exercise_area5" type="checkbox" value="안전" /><span class="custom-check"></span>안전</label>
										</c:if>
									</div>
								</div>
							</div>
							
							<div class="field w32">
								<div class="field-inner">
									<label>동작명(별칭)</label>
									<input id="exercise_detail_name" type="text" value="${exercise.exercise_detail_name}" placeholder="동작명을 입력해주세요(별칭)">
								</div>
							</div>
							
							<div class="field w32">
								<div class="field-inner">
									<label>기본 횟수</label>
									<input id="exercise_count" type="number" placeholder="동작 횟수를 입력해주세요" value="${exercise.exercise_count}">
								</div>
							</div>
							
							<div class="field w32">
								<div class="field-inner">
									<label>기본 시간</label>
									<input id="exercise_time" type="number" placeholder="'초' 단위로 입력해주세요" value="${exercise.exercise_time}">
								</div>
							</div>
							
							<div class="field w24">
								<div class="field-inner">
									<label>운동난이도</label>
									<select id="exercise_level">
										<c:if test="${mode == 'modify'}">
											<option>선택</option>
											<c:if test="${exercise.exercise_level == '0'}">
												<option selected="selected">없음</option>
												<option>쉬움</option>
												<option>보통</option>
												<option>어려움</option>
											</c:if>
											<c:if test="${exercise.exercise_level == '1'}">
												<option>없음</option>
												<option selected="selected">쉬움</option>
												<option>보통</option>
												<option>어려움</option>
											</c:if>
											<c:if test="${exercise.exercise_level == '2'}">
												<option>없음</option>
												<option>쉬움</option>
												<option selected="selected">보통</option>
												<option>어려움</option>
											</c:if>
											<c:if test="${exercise.exercise_level == '3'}">
												<option>없음</option>
												<option>쉬움</option>
												<option>보통</option>
												<option selected="selected">어려움</option>
											</c:if>
										</c:if>
										<c:if test="${mode == 'create'}">
											<option>선택</option>
											<option>없음</option>
											<option>쉬움</option>
											<option>보통</option>
											<option>어려움</option>
										</c:if>
									</select>
								</div>
							</div>
							
							<div class="field w49">
								<div class="field-inner">
									<label>운동관련 URL</label>
									<input id="exercise_url" type="text" placeholder="운동에 관련된 URL을 입력해주세요" value="${exercise.exercise_url}">
								</div>
							</div>
							
							<div class="field w24">
								<label>평가 & 과제(중복가능)</label>
								<div class="field-inner">
									<div class="checks flex">
									<c:if test="${mode == 'modify'}">
										<c:if test="${exercise.exercise_type == '0'}">
											<label><input id="exercise_type1" type="checkbox" checked="checked"/><span class="custom-check"></span>평가 가능</label>
											<label><input id="exercise_type2" type="checkbox" /><span class="custom-check"></span>과제 가능</label>
										</c:if>
										<c:if test="${exercise.exercise_type == '1'}">
											<label><input id="exercise_type1" type="checkbox" /><span class="custom-check"></span>평가 가능</label>
											<label><input id="exercise_type2" type="checkbox" checked="checked"/><span class="custom-check"></span>과제 가능</label>
										</c:if>
										<c:if test="${exercise.exercise_type == '2'}">
											<label><input id="exercise_type1" type="checkbox" checked="checked"/><span class="custom-check"></span>평가 가능</label>
											<label><input id="exercise_type2" type="checkbox" checked="checked"/><span class="custom-check"></span>과제 가능</label>
										</c:if>
									</c:if>
									<c:if test="${mode == 'create'}">
										<label><input id="exercise_type1" type="checkbox" /><span class="custom-check"></span>평가 가능</label>
										<label><input id="exercise_type2" type="checkbox" /><span class="custom-check"></span>과제 가능</label>
									</c:if>
									</div>
								</div>
							</div>
							
						</div>
						<div class="btn-wrap">
							<c:if test="${mode == 'modify'}">
								<button id="modify_btn" class="btn-pt mr10">수정하기</button>
								<button class="btn-sec" onclick="location.href='/admin/exercise/exercise_management_list'">목록</button>
							</c:if>
							<c:if test="${mode == 'create'}">
								<button id="create_btn" class="btn-pt mr10">등록하기</button>
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
		
		/* 종목, 대분류 obj */
		var category_obj = JSON.parse('${exercise_name_obj}');
		
		$(document).ready(function(){
			var mode = "${mode}";	//등록 or 상세 구분자
			
			/* 상세 모드일 때 셋팅 */
			if(mode == "modify"){
				var value = "${exercise.exercise_name}";
				$("#exercise_category").children('option').remove();
				$("#exercise_category").append("<option>전체</option>");
				for(x=0;x<category_obj[value].length;x++){
					if(category_obj[value][x] == "${exercise.exercise_category}"){
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
			if(value == "선택"){
				$("#exercise_category").children('option').remove();
				$("#exercise_category").append("<option>선택</option>");
			}else{
				$("#exercise_category").children('option').remove();
				$("#exercise_category").append("<option>선택</option>");
				for(x=0;x<category_obj[value].length;x++){
					$("#exercise_category").append("<option>"+category_obj[value][x]+"</option>");
				}
			}
		});
		
		/* 수정하기 버튼 클릭 이벤트 */
		$("#modify_btn").click(function(){
			var exercise_code = "${exercise.exercise_code}";
			var mode = "modify";
			var exercise_name = $("#exercise_name option:selected").val();
			var exercise_category = $("#exercise_category option:selected").val();
			
			var exercise_area1 = $("#exercise_area1");
			var exercise_area2 = $("#exercise_area2");
			var exercise_area3 = $("#exercise_area3");
			var exercise_area4 = $("#exercise_area4");
			var exercise_area5 = $("#exercise_area5");
			var exercise_area_t = [];
			var exercise_area = null;
			
			var exercise_detail_name = $("#exercise_detail_name").val();
			var exercise_count = $("#exercise_count").val();
			var exercise_time = $("#exercise_time").val();
			var exercise_level_t = $("#exercise_level option:selected").val();
			var exercise_level = null;
			var exercise_url = $("#exercise_url").val();
			
			var exercise_type1 = $("#exercise_type1");
			var exercise_type2 = $("#exercise_type2");
			var exercise_type = null;
			
			if(exercise_area1.is(":checked")){
				exercise_area_t.push(exercise_area1.val());
			}
			if(exercise_area2.is(":checked")){
				exercise_area_t.push(exercise_area2.val());
			}
			if(exercise_area3.is(":checked")){
				exercise_area_t.push(exercise_area3.val());
			}
			if(exercise_area4.is(":checked")){
				exercise_area_t.push(exercise_area4.val());
			}
			if(exercise_area5.is(":checked")){
				exercise_area_t.push(exercise_area5.val());
			}
			
			if(exercise_area_t.length > 0){
				exercise_area = JSON.stringify(exercise_area_t);
			}else{
				alert("운동 영역을 선택해주세요");
				return;
			}
			
			if(exercise_type1.is(":checked") && exercise_type2.is(":checked")){
				exercise_type = "2";
			}else if(exercise_type1.is(":checked")){
				exercise_type = "0";
			}else if(exercise_type2.is(":checked")){
				exercise_type = "1";
			}else{
				alert("평가 & 과제를 선택해주세요 \r중복해서 선택 가능합니다.");
				return;
			}
			
			if(exercise_level_t == "없음"){
				exercise_level ="0";
			}else if(exercise_level_t == "쉬움"){
				exercise_level ="1";
			}else if(exercise_level_t == "보통"){
				exercise_level ="2";
			}else if(exercise_level_t == "어려움"){
				exercise_level ="3";
			}else{
				alert("운동 난이도를 선택해주세요");
				$("#exercise_level").focus();
				return;
			}
			
			if(exercise_name == "선택"){
				alert("종목을 선택해주세요");
				$("#exercise_name").focus();
				return;
			}else if(exercise_category == "선택"){
				alert("대분류를 선택해주세요");
				$("#exercise_category").focus();
				return;
			}else if(exercise_detail_name.length < 2 || exercise_detail_name.length > 30){
				alert("동작명을 2자 이상 30자 이하로 입력해주세요");
				$("#exercise_detail_name").focus();
				return;
			}else if(exercise_count.length < 1 || exercise_count.length > 4){
				alert("기본 횟수를 1~3 사이로 입력해주세요");
				$("#exercise_count").focus();
				return;
			}else if(exercise_time.length < 1 || exercise_time.length > 4){
				alert("기본 시간을 1 ~ 999 사이로 입력해주세요");
				$("#exercise_count").focus();
				return;
			}else if(exercise_url.length < 10){
				alert("운동 관련 URL을 입력해주세요");
				$("#exercise_url").focus();
				return;
			}else{
				var data = {
					mode:mode,
					exercise_code:exercise_code,
					exercise_name:exercise_name,
					exercise_category:exercise_category,
					exercise_type:exercise_type,
					exercise_area:exercise_area,
					exercise_detail_name:exercise_detail_name,
					exercise_count:exercise_count,
					exercise_time:exercise_time,
					exercise_url:exercise_url,
					exercise_level:exercise_level
				}

				$.ajax({
					type:"POST",
					url:"/admin/exercise/exercise_management_detail_work",
					data:data,
					dataType:"text",
					success:function(string){
						if(string == "fail"){
							alert("종목 수정에 실패했습니다.\r다시 시도해주세요");
						}else{
							alert("해당 종목을 수정했습니다.");
							history.go(0);
						}
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert("종목 수정에 실패했습니다.\r다시 시도해주세요");
						history.go(0);
					}
				});
			}
			
		});
		
		/* 등록하기 버튼 클릭 이벤트 */
		$("#create_btn").click(function(){
			
			var mode = "create";
			var exercise_name = $("#exercise_name option:selected").val();
			var exercise_category = $("#exercise_category option:selected").val();
			
			var exercise_area1 = $("#exercise_area1");
			var exercise_area2 = $("#exercise_area2");
			var exercise_area3 = $("#exercise_area3");
			var exercise_area4 = $("#exercise_area4");
			var exercise_area5 = $("#exercise_area5");
			var exercise_area_t = [];
			var exercise_area = null;
			
			var exercise_detail_name = $("#exercise_detail_name").val();
			var exercise_count = $("#exercise_count").val();
			var exercise_time = $("#exercise_time").val();
			var exercise_level_t = $("#exercise_level option:selected").val();
			var exercise_level = null;
			var exercise_url = $("#exercise_url").val();
			
			var exercise_type1 = $("#exercise_type1");
			var exercise_type2 = $("#exercise_type2");
			var exercise_type = null;
			
			if(exercise_area1.is(":checked")){
				exercise_area_t.push(exercise_area1.val());
			}
			if(exercise_area2.is(":checked")){
				exercise_area_t.push(exercise_area2.val());
			}
			if(exercise_area3.is(":checked")){
				exercise_area_t.push(exercise_area3.val());
			}
			if(exercise_area4.is(":checked")){
				exercise_area_t.push(exercise_area4.val());
			}
			if(exercise_area5.is(":checked")){
				exercise_area_t.push(exercise_area5.val());
			}
			
			if(exercise_area_t.length > 0){
				exercise_area = JSON.stringify(exercise_area_t);
			}else{
				alert("운동 영역을 선택해주세요");
				return;
			}
			
			if(exercise_type1.is(":checked") && exercise_type2.is(":checked")){
				exercise_type = "2";
			}else if(exercise_type1.is(":checked")){
				exercise_type = "0";
			}else if(exercise_type2.is(":checked")){
				exercise_type = "1";
			}else{
				alert("평가 & 과제를 선택해주세요 \r중복해서 선택 가능합니다.");
				return;
			}
			
			if(exercise_level_t == "없음"){
				exercise_level ="0";
			}else if(exercise_level_t == "쉬움"){
				exercise_level ="1";
			}else if(exercise_level_t == "보통"){
				exercise_level ="2";
			}else if(exercise_level_t == "어려움"){
				exercise_level ="3";
			}else{
				alert("운동 난이도를 선택해주세요");
				$("#exercise_level").focus();
				return;
			}
			
			if(exercise_name == "선택"){
				alert("종목을 선택해주세요");
				$("#exercise_name").focus();
				return;
			}else if(exercise_category == "선택"){
				alert("대분류를 선택해주세요");
				$("#exercise_category").focus();
				return;
			}else if(exercise_detail_name.length < 2 || exercise_detail_name.length > 30){
				alert("동작명을 2자 이상 30자 이하로 입력해주세요");
				$("#exercise_detail_name").focus();
				return;
			}else if(exercise_count.length < 1 || exercise_count.length > 4){
				alert("기본 횟수를 1~3 사이로 입력해주세요");
				$("#exercise_count").focus();
				return;
			}else if(exercise_time.length < 1 || exercise_time.length > 4){
				alert("기본 시간을 1 ~ 999 사이로 입력해주세요");
				$("#exercise_count").focus();
				return;
			}else if(exercise_url.length < 10){
				alert("운동 관련 URL을 입력해주세요");
				$("#exercise_url").focus();
				return;
			}else{
				var data = {
					mode:mode,
					exercise_name:exercise_name,
					exercise_category:exercise_category,
					exercise_type:exercise_type,
					exercise_area:exercise_area,
					exercise_detail_name:exercise_detail_name,
					exercise_count:exercise_count,
					exercise_time:exercise_time,
					exercise_url:exercise_url,
					exercise_level:exercise_level
				}

				$.ajax({
					type:"POST",
					url:"/admin/exercise/exercise_management_detail_work",
					data:data,
					dataType:"text",
					success:function(string){
						if(string == "fail"){
							alert("종목 수정에 실패했습니다.\r다시 시도해주세요");
						}else{
							alert("종목을 등록했습니다.");
							location.href='/admin/exercise/exercise_management_list'
						}
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert("종목 등록 실패했습니다.\r다시 시도해주세요");
					}
				});
			}
		});
	});
	</script>
</html>
