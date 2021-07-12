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
			textarea { resize: none; }
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
							<li class="active"><a href="/admin/push/push_management_list">PUSH 관리</a></li>
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
						<li><a href="/admin/exercise/exercise_management_list">종목 관리</a></li>
						<li><a href="/admin/popup/popup_management_list">팝업창 관리</a></li>
						<li class="active"><a href="/admin/push/push_management_list">PUSH 관리</a></li>
						<li><a href="/admin/etc/notice_list">공지사항 관리</a></li>
						<li><a href="/admin/etc/faq_list">FAQ 관리</a></li>
						<li><a href="/admin/etc/qna_list">1:1문의 관리</a></li>
					</ul>
				</li>
			</ul>
		</div>

		<div class="content">
			<div class="wrapper">
				<h2 class="sub-title">관리자 메뉴 - PUSH 관리</h2>

				<div class="box-wrap">
					
					<div class="box-content">
						<div class="form auto-w">
							<div class="field w49">
								<div class="field-inner">
									<label>제목</label>
									<c:if test='${mode == "create"}'>
										<input id="push_title" type="text" class="w100" placeholder="푸시 제목을 입력해주세요" value="${push.push_title}">
									</c:if>
									<c:if test='${mode == "modify"}'>
										<input id="push_title" type="text" class="w100" placeholder="푸시 제목을 입력해주세요" value="${push.push_title}" disabled>
									</c:if>
								</div>
							</div>
							<div class="field">
								<div class="field-inner">
									<label>등록자명</label>
									<input type="text" value="관리자" disabled="disabled">
								</div>
							</div>
							<!-- <div class="field w100">
								<label>발송 시각 예약</label>
								<div class="flex">
									<c:if test="${mode == 'modify'}">
										<input type="text" class="w32" id="datepicker" value="${fn:substring(push.push_reservation_time,4,6)}/${fn:substring(push.push_reservation_time,6,8)}/${fn:substring(push.push_reservation_time,0,4)}">
									</c:if>
									<c:if test="${mode == 'create'}">
										<input type="text" class="w32" id="datepicker">
									</c:if>
									<select id="push_reservation_time_h" class="w24 ml10">
										<option>시간</option>
										<c:forTokens var="item" items="01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24" delims=",">
											<c:choose>
												<c:when test="${mode == 'modify' and fn:substring(push.push_reservation_time,8,10) == item}">
													<option selected="selected">${item}</option>
												</c:when>
												<c:otherwise>
													<option>${item}</option>
												</c:otherwise>
											</c:choose>
										</c:forTokens>
									</select>
									<select id="push_reservation_time_m" class="w24">
										<option>분</option>
										<c:forTokens var="item" items="00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59" delims=",">
											<c:choose>
												<c:when test="${mode == 'modify' and fn:substring(push.push_reservation_time,10,12) == item}">
													<option selected="selected">${item}</option>
												</c:when>
												<c:otherwise>
													<option>${item}</option>
												</c:otherwise>
											</c:choose>
										</c:forTokens>
									</select>
								</div>
								
							</div>
							 -->
							<div class="field w100">
								<c:if test='${mode == "create"}'>
									<textarea id="push_content" placeholder="푸시 내용을 입력해주세요">${push.push_content}</textarea>
								</c:if>
								<c:if test='${mode == "modify"}'>
									<textarea id="push_content" placeholder="푸시 내용을 입력해주세요" disabled>${push.push_content}</textarea>
								</c:if>
							</div>
						</div>
						<div class="btn-wrap">
							<c:if test='${mode == "create"}'>
								<button class="btn-pt mr10" id="create_btn">등록하기</button>
							</c:if>
							<c:if test='${mode == "modify"}'>
								<button class="btn-sec" onclick='history.go(-1)'>뒤로가기</button>
								<!-- <button class="btn-pt mr10" id="modify_btn">수정하기</button>
								<button class="btn-sec" id="delete_btn">취소하기</button> -->
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
		var mode = "${mode}";
		
		/* 취소하기 버튼 클릭 */
		/*$("#delete_btn").click(function(){
			var push_number = "${push.push_number}";
			var data = {"mode":"delete","push_number":push_number};
			if (confirm("정말 취소하시겠습니까?") == true){    //확인
				$.ajax({
					type:"POST",
					url:"/admin/push/push_management_detail_work",
					data:data,
					dataType:"text",
					success:function(string){
						if(string == "fail"){
							alert("취소에 실패했습니다.\r다시 시도해주세요");
						}else{
							alert("해당 푸시를 취소했습니다.");
							location.href='/admin/push/push_management_list'
						}
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert("취소에 실패했습니다.\r다시 시도해주세요");
					}
				});
			}
		});*/
		
		/* 수정하기 버튼 */
		/*$("#modify_btn").click(function(){
			var push_number = "${push.push_number}";
			var push_title = $("#push_title").val();
			var push_content = $("#push_content").val();
			var datepicker = $("#datepicker").val();
			var push_reservation_time_h = $("#push_reservation_time_h option:selected").val();
			var push_reservation_time_m = $("#push_reservation_time_m option:selected").val();
			var push_reservation_time = null;
			
			if(push_title.length < 2 || push_title.length > 50){
				alert("제목을 2자이상 50자 이하로 입력해주세요");
				$("#push_title").focus();
				return;
			}else if(push_content.length < 2){
				alert("내용을 2자이상 입력해주세요");
				$("#push_content").focus();
				return;
			}else if(datepicker.length != 10){
				alert("발송 시간을 설정해주세요");
				$("#datepicker").focus();
				return;
			}else if(push_reservation_time_h == "시간"){
				alert("발송 시간을 설정해주세요");
				$("#push_reservation_time_h").focus();
				return;
			}else if(push_reservation_time_m == "분"){
				alert("발송 시간을 설정해주세요");
				$("#push_reservation_time_m").focus();
				return;
			}else{
				push_reservation_time = datepicker.substring(6,10) + datepicker.substring(0,2) + datepicker.substring(3,5) + push_reservation_time_h + push_reservation_time_m;
				var data = {
						"mode":"modify",
						"push_number":push_number,
						"push_title":push_title,
						"push_content":push_content,
						"push_reservation_time":push_reservation_time
						};
				
				$.ajax({
					type:"POST",
					url:"/admin/push/push_management_detail_work",
					data:data,
					dataType:"text",
					success:function(string){
						if(string == "fail"){
							alert("푸시 수정에 실패했습니다.\r다시 시도해주세요");
						}else{
							alert("해당 푸시를 수정했습니다.");
							history.go(0);
						}
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert("푸시 수정에 실패했습니다.\r다시 시도해주세요");
					}
				});
			}
		});*/
		
		$("#create_btn").click(function(){
			var push_title = $("#push_title").val();
			var push_content = $("#push_content").val();
			var datepicker = $("#datepicker").val();
			var time = getTimeStamp();
			
			//var push_reservation_time_h = $("#push_reservation_time_h option:selected").val();
			//var push_reservation_time_m = $("#push_reservation_time_m option:selected").val();
			//var push_reservation_time = null;
			
			if(push_title.length < 2 || push_title.length > 50){
				alert("제목을 2자이상 50자 이하로 입력해주세요");
				$("#push_title").focus();
				return;
			}else if(push_content.length < 2){
				alert("내용을 2자이상 입력해주세요");
				$("#push_content").focus();
				return;
			}
			/*else if(datepicker.length != 10){
				alert("발송 시간을 설정해주세요");
				$("#datepicker").focus();
				return;
			}
			else if(push_reservation_time_h == "시간"){
				alert("발송 시간을 설정해주세요");
				$("#push_reservation_time_h").focus();
				return;
			}else if(push_reservation_time_m == "분"){
				alert("발송 시간을 설정해주세요");
				$("#push_reservation_time_m").focus();
				return;
			}*/
			else{
				//push_reservation_time = datepicker.substring(6,10) + datepicker.substring(0,2) + datepicker.substring(3,5) + push_reservation_time_h + push_reservation_time_m;
				var data = {
						"mode":"create",
						"push_title":push_title,
						"push_content":push_content,
						"push_reservation_time":time
						};
				
				$.ajax({
					type:"POST",
					url:"/admin/push/push_management_detail_work",
					data:data,
					dataType:"text",
					success:function(string){
						if(string == "fail"){
							alert("푸시 등록에 실패했습니다.\r다시 시도해주세요");
						}else{
							alert("푸시를 등록했습니다.");
							location.href='/admin/push/push_management_list';
						}
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert("푸시 등록에 실패했습니다.\r다시 시도해주세요");
					}
				});
			}
		});
		
	});
	
	function getTimeStamp() {
		  var d = new Date();

		  var s =
		    leadingZeros(d.getFullYear(), 4)+
		    leadingZeros(d.getMonth() + 1, 2)+
		    leadingZeros(d.getDate(), 2)+

		    leadingZeros(d.getHours(), 2)+
		    leadingZeros(d.getMinutes(), 2);
		    //leadingZeros(d.getSeconds(), 2);

		  return s;
		}



		function leadingZeros(n, digits) {
		  var zero = '';
		  n = n.toString();

		  if (n.length < digits) {
		    for (i = 0; i < digits - n.length; i++)
		      zero += '0';
		  }
		  return zero + n;
		}
	</script>
</html>
