<!-- 마이페이지 -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
session = request.getSession();
String id = (String)session.getAttribute("teacher_id");
String name = (String)session.getAttribute("teacher_name");
String email = (String)session.getAttribute("teacher_email");
String phone = (String)session.getAttribute("teacher_phone");
String sex = (String)session.getAttribute("teacher_sex");
String school = (String)session.getAttribute("teacher_school");
String birth = (String)session.getAttribute("teacher_birth");
String auth = (String)session.getAttribute("admin_auth");
String email_agreement = (String)session.getAttribute("teacher_email_agreement");
String message_agreement = (String)session.getAttribute("teacher_message_agreement");
String year = birth.substring(0, 4);
String month = birth.substring(4, 6);
String day = birth.substring(6, 8);
if(sex.equals("m")){
	sex="남";
}else{
	sex="여";
}
%>
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
			.login-title{ padding-top: 50px; text-align: center; }
			.mylogin-txt{ text-align: center; font-size: 0.875rem; color: #444; padding: 16px 0 0; }
			.mylogin-txt a{ display: inline-block; }
			.mylogin-txt a:hover{ color: var(--pri-blue); }
			.nonelogin_content{ margin: 30px 0; }
			.hidden_box{ display:none; }
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
					<!-- 일반사용자용 메뉴(선생님) -->
					<% if(auth.equals("ROLE_USER")){%>
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
					<!-- <li><span class="slide-tab">교사 커뮤니티</span>
						<ul class="depth2">
							<li><a href="#">추천 학습 자료</a></li>
							<li><a href="#">종목별 백서</a></li>
						</ul>
					</li>
					 -->
					<li><span class="slide-tab">서비스</span>
						<ul class="depth2">
							<li><a href="/teacher/service/notice_list">공지사항</a></li>
							<li><a href="/teacher/service/faq_list">FAQ</a></li>
							<li><a href="/teacher/service/qna_list">1:1 문의</a></li>
						</ul>
					</li>
					<% } %>
					<!-- 관리자용 메뉴 -->
					<% if(auth.equals("ROLE_ADMIN")){%>
					<li><span class="slide-tab">관리자 메뉴</span>
						<ul class="depth2">
							<li><a href="/admin/management/lms_member_management_list">회원관리(LMS)</a></li>
							<li><a href="/admin/management/app_member_management_list">회원관리(App)</a></li>
							<li><a href="/admin/exercise/exercise_management_list">종목 관리</a></li>
							<li><a href="/admin/popup/popup_management_list">팝업창 관리</a></li>
							<li><a href="/admin/push/push_management_list">PUSH 관리</a></li>
							<li><a href="/admin/etc/notice_list">공지사항 관리</a></li>
							<li><a href="/admin/etc/faq_list">FAQ 관리</a></li>
							<li><a href="/admin/etc/qna_list">1:1문의 관리</a></li>
						</ul>
					</li>
					<% } %>
				</ul>
			</div>
		</div>
	</div>

	

	<div class="wrap">
	
		<div class="lnb">
			<ul class="depth1">
				<!-- 일반 사용자용 메뉴(선생님) -->
				<% if(auth.equals("ROLE_USER")){%>
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
				<!-- <li class="active"><span class="slide-tab">교사 커뮤니티</span>
					<ul class="depth2">
						<li><a href="#">추천 학습 자료</a></li>
						<li><a href="#">종목별 백서</a></li>
					</ul>
				</li>
				-->
				<li class="active"><span class="slide-tab">서비스</span>
					<ul class="depth2">
						<li><a href="/teacher/service/notice_list">공지사항</a></li>
						<li><a href="/teacher/service/faq_list">FAQ</a></li>
						<li><a href="/teacher/service/qna_list">1:1 문의</a></li>
					</ul>
				</li>
				<% } %>
				
				<!-- 관리자용 메뉴 -->
				<% if(auth.equals("ROLE_ADMIN")){%>
				<li class="active"><span class="slide-tab">관리자 메뉴</span>
					<ul class="depth2">
						<li><a href="/admin/management/lms_member_management_list">회원관리(LMS)</a></li>
						<li><a href="/admin/management/app_member_management_list">회원관리(App)</a></li>
						<li><a href="/admin/exercise/exercise_management_list">종목 관리</a></li>
						<li><a href="/admin/popup/popup_management_list">팝업창 관리</a></li>
						<li><a href="/admin/push/push_management_list">PUSH 관리</a></li>
						<li><a href="/admin/etc/notice_list">공지사항 관리</a></li>
						<li><a href="/admin/etc/faq_list">FAQ 관리</a></li>
						<li><a href="/admin/etc/qna_list">1:1문의 관리</a></li>
					</ul>
				</li>
				<% } %>

			</ul>
		</div>
	
		<div class="content">
		<div class="wrapper member-wrapper">
				<h2 class="sub-title">마이페이지</h2>

				<div class="box-wrap">
					
					<div class="box-content">
						<div class="form">
							<!-- 이름 field -->
							<div class="field">
								<div class="field-inner">
									<label>이름</label>
									<input type="text" value="<% out.print(name); %>" disabled>
								</div>
							</div>
							<!-- 소속 입력 field -->
							<div class="field">
								<div class="field-inner">
									<label>기관명(소속)</label>
									<input type="text" placeholder="학교검색 또는 기관명을 입력하세요" class="w49" id="teacher_school" value="<% out.print(school); %>" disabled>
									<button class="btn-s-round bg-blue" id="search_school">소속 변경</button>
									<button class="btn-s-round bg-blue hidden_box" id="index_search_school_btn">학교 검색</button>
								</div>
							</div>
							<!-- 생년월일 field -->
							<div class="field w69">
								<div class="field-inner">
									<label>생년월일</label>
									<input type="text" value="<% out.print(year); %>-<% out.print(month); %>-<% out.print(day); %>" disabled>
								</div>
							</div>
							<!-- 성별 field -->
							<div class="field w29">
								<div class="field-inner">
									<label>성별</label>
									<input type="text" value="<% out.print(sex); %>" disabled>
								</div>
							</div>
							<!-- 아이디 field -->
							<div class="field">
								<div class="field-inner">
									<label>아이디</label>
									<input id="teacher_id" type="text" value="<% out.print(id); %>" disabled>
								</div>
							</div>
							<!-- 현재 비밀번호 입력 field -->
							<div class="field">
								<div class="field-inner">
									<label>현재 비밀번호</label>
									<input id="teacher_password_before" type="password" placeholder="현재 비밀번호를 입력해주세요">
								</div>
							</div>
							<!-- 변경 비밀번호 입력 field -->
							<div class="field">
								<div class="field-inner">
									<label>변경할 비밀번호</label>
									<input id="teacher_password" type="password" placeholder="새로운 비밀번호를 입력해주세요">
								</div>
							</div>
							<!-- 변경 비밀번호 확인 입력 field -->
							<div class="field">
								<div class="field-inner">
									<label>변경할 비밀번호 확인</label>
									<input id="teacher_password_again" type="password" placeholder="새로운 비밀번호를 입력해주세요">
								</div>
							</div>
							<!-- 이메일 입력, 이메일 수신동의 체크 field -->
							<div class="field">
								<div class="field-inner">
									<label>E-mail</label>
									<input id="teacher_email" type="email" placeholder="이메일 주소를 입력하세요" value="<% out.print(email); %>">
									<label>
									<% if(email_agreement.equals("1")){ %>
									<input id="teacher_email_checkbox" type="checkbox" checked>
									<% }else{ %>
									<input id="teacher_email_checkbox" type="checkbox">
									<% } %>
									<span class="custom-check"></span>이메일 수신 동의</label>
								</div>
							</div>
							<!-- 휴대폰 번호 입력, 문자 수신동의 체크 field -->
							<div class="field">
								<div class="field-inner">
									<label>휴대폰</label>
									<input id="teacher_phone" type="text" placeholder="휴대폰 번호를 입력하세요." value="<% out.print(phone); %>">
									<label>
									<% if(message_agreement.equals("1")){ %>
									<input id="teacher_phone_checkbox" type="checkbox" checked>
									<% }else{ %>
									<input id="teacher_phone_checkbox" type="checkbox">
									<% } %>
									<span class="custom-check"></span>문자 수신 동의</label>
								</div>
							</div>
						</div>
						<!-- 정보 수정 버튼 -->
						<div class="btn-wrap">
							<button class="btn-pt mr10" id="modify_info">정보 수정하기</button>
						</div>

					</div>
					
				</div>

			</div>

			<div class="footer">
				<p>copyright 컴플렉시온 ⓒ All rights reserved.</p>
			</div>
		</div>
	</div>
	
	<!-- 학교 검색 팝업 -->
	<div class="popup" id="search_school_popup" style="display:none;">
			<div class="popup-cont small-pop">
				<div class="pop-title flex justify-space">
					<div class="left flex">
						<h2>학교 검색</h2>
					</div>
					<div class="right">
						<button id="popup_close" class="close">x</button>
					</div>
				</div>
				<div class="pop-cont">
					
					<div class="form">
						<div class="field">
							<div class="field-inner">
								<label>학교명</label>
								<input id="search_school_input" type="text" class="input-w-btn" placeholder="학교명을 입력하세요.">
								<button id="search_school_btn" class="btn-s-round">조회</button>
							</div>
							<ul class="result" id="school_list_parent">
							</ul>
						</div>
					</div>
	
					<div class="btn-wrap">
						<button id="school_choose" class="btn-pt">선택하기</button>
					</div>
				</div>
			</div>
		</div>
	
	</body>
	<script>		
		var isRunning = false;
		var ismodify = false;
		$(document).ready(function(){
			
			/*
			 - "소속 변경" 버튼 클릭시 생성되는 "학교 검색" 버튼 클릭 이벤트
			 - 학교 검색 팝업이 생성된다. 생성될 때 기존에 입력되있던 학교명 입력 필드의 값과 기존 조회했던 목록을 초기화한다.
			*/
			$("#index_search_school_btn").click(function(){
				$("#school_list_parent").children('li').remove();
				$("#search_school_input").val("");
				$("#search_school_popup").css("display", "block");
			});
			
			/*
			학교 검색 팝업의 닫기버튼 클릭 이벤트
			*/
			$("#popup_close").click(function(){
				$("#search_school_popup").css("display", "none");
			});
			
			/* 학교 검색 팝업의 학교명 입력필드 Enter 키다운 이벤트 */
			$("#search_school_input").keydown(function(key){
				if(key.keyCode == 13){
					var school_input_val = $("#search_school_input").val();
					if(school_input_val.length > 1 && school_input_val.length < 30){
						search_school(school_input_val);
					}else{
						alert("학교명을 2자이상 30자 이하로 입력해주세요");
					}
				}
			});
			
			/* 학교 검색 팝업의 조회 버튼 클릭 이벤트 */
			$("#search_school_btn").click(function(){
				var school_input_val = $("#search_school_input").val();
				if(school_input_val.length > 1 && school_input_val.length < 30){
					search_school(school_input_val);
				}else{
					alert("학교명을 2자이상 30자 이하로 입력해주세요");
				}
			});
			
			/* 학교 검색 팝업의 목록중 학교 클릭 이벤트 */
			$("#school_choose").click(function(){
				var node = $(".school_node");
				var this_node = null;
				for(x=0;x<node.length;x++){
					if(node.eq(x).hasClass("active")){
						this_node = node.eq(x);
					}
				}
				if(this_node != null){
					//모달 끄고 선택 된 학교를 밖의 학교 input에 넣는다.
					$("#teacher_school").val(this_node.text());
					$("#search_school_popup").css("display","none");
					
				}else{
					alert("학교목록에서 학교를 선택해 주세요");
					return;
				}
			});
			
			/* "선택하기" 버튼 클릭 이벤트 */
			$("#search_school").click(function(){
				//학교수정
				if(!ismodify){
					ismodify = true;
					$("#teacher_school").attr("disabled", false);
					
					$(this).removeClass("btn-s-round");
					$(this).removeClass("bg-blue");
					$(this).addClass("btn-s-round-l");
					$("#index_search_school_btn").removeClass("hidden_box");
					
					$("#search_school").text("저장");
				}else{
					
					if($("#teacher_school").val().length < 2 || $("#teacher_school").val() > 30){
						alert("학교명을 2 ~ 30자로 입력해주세요");
						return;
					}
					
					if(!isRunning){
						isRunning = true;
						
						if (confirm("소속 변경시 학급 구성인원이 변경학교의 학생들로 변경됩니다.\r정말 변경하시겠습니까?") == true){
							$.ajax({
								type:"POST",
								url:"/mypage_school_change",
								data:{"teacher_id":"${teacher_id}", "school_name":$("#teacher_school").val()},
								success:function(string){
									if(string == "success"){
										$("#teacher_school").val($("#teacher_school").val());
										$("#teacher_school").attr("disabled", true);
										$("#search_school").text("소속 변경");
										$("#search_school").addClass("btn-s-round");
										$("#search_school").addClass("bg-blue");
										$("#search_school").removeClass("btn-s-round-l");
										$("#index_search_school_btn").addClass("hidden_box");
									}else{
										alert("소속 변경에 실패했습니다.\r다시 시도해주세요.");
									}
									isRunning = false;
									ismodify = false;
								},
								error:function(XMLHttpRequest, textStatus, errorThrown){
									alert("소속 변경에 실패했습니다.\r다시 시도해주세요.");
									isRunning = false;
									ismodify = false;
								}
							});
						}else{
							ismodify = false;
							isRunning = false;
						}
					}
				}
			});
			
			/* 학교검색 -> 검색 */
			function search_school(search_val){
				if(!isRunning){
					isRunning = true;
					//ajax로 학교명 긁어오기
					var params = {keyword:search_val}
					$.ajax({
							type:"GET",
							url:"/get_school_list",
							data:params,
							success:function(string){
								$("#school_list_parent").children('li').remove();
								var data = JSON.parse(string);
								
								var node = "";
								for(x=0;x<data.length;x++){
									node += "<li class='school_node'>"+data[x]+"</li>";
								}
								
								
								$("#school_list_parent").append(node);
								$(".school_node").click(function(){
									$(".school_node").removeClass('active');
									$(this).addClass('active');
								});
								
								
								isRunning = false;
							},
							error:function(XMLHttpRequest, textStatus, errorThrown){
								alert("다시 시도해주세요");
								isRunning = false;
							}
						});
				}
				

			}
			
			/* "정보 수정하기" 버튼 클릭 이벤트 */
			$("#modify_info").click(function(){
				form_check();
			});
			
			/* 
			 - 입력 데이터들을 검증 후 서버로 데이터 일괄 전송
			 - 반환값으로 비밀번호 인증 오류, 핸드폰번호 중복, 이메일 중복, 정보수정 성공 유무를 받는다.
			*/
			function form_check(){
				
				var teacher_password_before = $("#teacher_password_before").val();
				var teacher_password = $("#teacher_password").val();
				var teacher_password_again = $("#teacher_password_again").val();
				var teacher_email = $("#teacher_email").val();
				var teacher_email_checkbox = $("#teacher_email_checkbox");
				var teacher_phone = $("#teacher_phone").val();
				var teacher_phone_checkbox = $("#teacher_phone_checkbox");
				var change_password = "n";
				var teacher_email_agreement = "0";
				var teacher_message_agreement = "0";
				
				if(teacher_password_before.length != 0 || teacher_password.length != 0 || teacher_password_again != 0){
					if(teacher_password_before == null || teacher_password_before.length < 8 || teacher_password_before.length > 20){
						alert("기존 비밀번호를 제대로 입력해 주세요");
						$("#teacher_password_before").focus();
						return;
					}else if(teacher_password == null){
						alert("새로운 비밀번호를 입력해 주세요");
						$("#teacher_password").focus();
						return;
					}else if(teacher_password_again == null){
						alert("새로운 비밀번호 확인을 입력해 주세요");
						$("#teacher_password_again").focus();
						return;
					}else if(teacher_password != teacher_password_again){
						alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
						$("#teacher_password").focus();
						return;
					}else if(teacher_password.length < 8 || teacher_password.length > 20){
						alert("비밀번호를 영문+숫자+특수문자를 포함하여 8~20자로 입력하세요");
						$("#teacher_password").focus();
						return;
					}else if(!chekPassword(teacher_password)){
						alert("비밀번호를 영문+숫자+특수문자를 포함하여 8~20자로 입력하세요");
						$("#teacher_password").focus();
						return;
					}else if(teacher_password_before == teacher_password){
						alert("기존 비밀번호와 새로운 비밀번호가 동일합니다.");
						$("#teacher_password").focus();
						return;
					}else{
						change_password = "y"	
					}
				}else{
					change_password = "n";
				}
				
				if(!CheckEmail(teacher_email)){
					alert("이메일을 제대로 입력해주세요");
					$("#teacher_email").focus();
					return;
				}else if(teacher_phone.length != 11){
					alert("핸드폰번호를 제대로 입력해주세요");
					$("#teacher_phone").focus();
					return;
				}else{
					
					if(teacher_email_checkbox.is(":checked")){
						teacher_email_agreement = "1";
					}
					
					if(teacher_phone_checkbox.is(":checked")){
						teacher_message_agreement = "1";
					}
					
					var params = null;
					
					if(change_password == "y"){
						params = {
								teacher_password_before:teacher_password_before,
								teacher_password:teacher_password,
								teacher_email:teacher_email,
								teacher_phone:teacher_phone,
								teacher_email_agreement:teacher_email_agreement,
								teacher_message_agreement:teacher_message_agreement,
								change_password:change_password
						}	
					}else{
						params = {
								teacher_email:teacher_email,
								teacher_phone:teacher_phone,
								teacher_email_agreement:teacher_email_agreement,
								teacher_message_agreement:teacher_message_agreement,
								change_password:change_password
						}
					}
					
					$.ajax({
						type:"POST",
						url:"/mypage_modify_ck",
						data:params,
						success:function(string){
							if(string == "out"){
								location.href="/logout";
							}else if(string == "fail"){
								alert("정보 수정에 실패 했습니다.");
								history.go(0);
							}else if(string == "before_password"){
								alert("기존 비밀번호가 일치하지 않습니다.");
								$("#teacher_password_before").val("");
								$("#teacher_password_before").focus();
							}else if(string == "email_overlap"){
								alert("중복된 이메일 입니다.");
								$("#teacher_eamil").val("");
								$("#teacher_eamil").focus();
							}else if(string == "phone_overlap"){
								alert("중복된 핸드폰번호 입니다.");
								$("#teacher_phone").val("");
								$("#teacher_phone").focus();
							}else{
								alert("정보 수정에 성공했습니다.");
								location.href="/mypage";
							}
						},
						error:function(XMLHttpRequest, textStatus, errorThrown){
							alert("정보 수정에 실패했습니다.");
						}
					});
				}
			}
		});
	</script>
</html>
