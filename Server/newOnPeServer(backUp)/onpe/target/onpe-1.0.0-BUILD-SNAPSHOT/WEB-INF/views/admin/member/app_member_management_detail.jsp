<!-- 회원관리(APP) 등록, 수정 페이지 -->

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
							<li class="active"><a href="/admin/member/app_member_management_list">회원관리(App)</a></li>
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

		<div class="lnb">
			<ul class="depth1">
				<li class="active"><span class="slide-tab">관리자 메뉴</span>
					<ul class="depth2">
						<li><a href="/admin/member/lms_member_management_list">회원관리(LMS)</a></li>
						<li class="active"><a href="/admin/member/app_member_management_list">회원관리(App)</a></li>
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
				
				<c:if test="${mode == 'modify'}">
					<h2 class="sub-title">관리자 메뉴 - 회원관리</h2>
				</c:if>
				<c:if test="${mode == 'create'}">
					<h2 class="sub-title">관리자 메뉴 - 회원관리</h2>
				</c:if>

				<div class="box-wrap">
					
					<div class="box-content">
						<div class="form">
							<div class="field w32">
								<div class="field-inner">
									<label>이름</label>
									<input id="student_name" type="text" placeholder="학생 이름을 입력해주세요" value="${student_information.student_name}">
								</div>
							</div>
							
							<div class="field w32">
								<div class="field-inner">
									<label>학교</label>
									<input id="student_school" type="text" value="${student_information.student_school}" class="input-m">
									<button class="btn-s-round bg-blue" id="search_school">학교검색</button>
								</div>
							</div>
							
							<div class="field w32">
								<div class="field-inner">
									<label>나이</label>
									<input id="student_age" type="number" placeholder="ex) 25" value="${student_information.student_age}">
								</div>
							</div>
							
							<div class="field w32">
								<div class="field-inner">
									<label>성별</label>
									<select id="student_sex">
										<c:if test="${student_information.student_sex eq 'm'}">
											<option>선택</option>
											<option selected>남자</option>
											<option>여자</option>
										</c:if>
										<c:if test="${student_information.student_sex eq 'f'}">
											<option>선택</option>
											<option>남자</option>
											<option selected>여자</option>
										</c:if>
										<c:if test="${student_information.student_sex == null}">
											<option selected>선택</option>
											<option>남자</option>
											<option>여자</option>
										</c:if>
									</select>
								</div>
							</div>
							
							<div class="field w32">
								<div class="field-inner">
									<label>아이디</label>
									<c:if test="${mode == 'modify'}">
										<input id="student_id" type="text" value="${student_information.student_id}" disabled>
									</c:if>
									<c:if test="${mode == 'create'}">
										<input id="student_id" type="text" value="${student_information.student_id}" placeholder="아이디를 입력해 주세요">
									</c:if>
								</div>
							</div>
							
							<c:if test="${mode == 'modify'}">
								<div class="field w32">
									<div class="field-inner">
										<label>비밀번호</label>
										<button id="student_password_reset" class="btn-s-round bg-blue">초기화</button>
									</div>
								</div>
							</c:if>
							<c:if test="${mode == 'create'}">
								<div class="field w49">
									<div class="field-inner">
										<label>비밀번호</label>
										<input type="password" id="student_password" placeholder="영문+숫자+특수문자를 포함하여 8~20자로 입력하세요">
									</div>
								</div>
								
								<div class="field w49">
									<div class="field-inner">
										<label>비밀번호 확인</label>
										<input type="password" id="student_password_again" placeholder="영문+숫자+특수문자를 포함하여 8~20자로 입력하세요">
									</div>
								</div>
							</c:if>
							
							<div class="field w49">
								<label>E-mail</label>
								<input id="student_email" type="email" placeholder="이메일 주소를 입력하세요" value="${student_information.student_email}">
								<label>
								<c:if test="${student_information.student_email_agreement == '1'}">
									<input id="student_email_checkbox" type="checkbox" checked>
								</c:if>
								<c:if test="${student_information.student_email_agreement != '1'}">
									<input id="student_email_checkbox" type="checkbox">
								</c:if>
								<span class="custom-check"></span>이메일 수신 동의</label>
							</div>
							
							<div class="field w49">
								<label>학생 휴대폰</label>
								<input id="student_phone" type="number" placeholder="휴대폰 번호를 입력하세요." value="${fn:substring(student_information.student_phone,0,3)}${fn:substring(student_information.student_phone,4,8)}${fn:substring(student_information.student_phone,9,13)}">
								<label>
								<c:if test="${student_information.student_push_agreement == '1'}">
									<input id="student_phone_checkbox" type="checkbox" checked>
								</c:if>
								<c:if test="${student_information.student_push_agreement != '1'}">
									<input id="student_phone_checkbox" type="checkbox">
								</c:if>
								<span class="custom-check"></span>푸시 수신 동의</label>
							</div>
							
						</div>
						
						<c:if test="${mode == 'modify'}">
							<c:if test="${student_information.student_recent_join_date != null }">
								<p class="txt-right txt-small">최근 접속일: ${fn:substring(student_information.student_recent_join_date,0,4)}-${fn:substring(student_information.student_recent_join_date,4,6)}-${fn:substring(student_information.student_recent_join_date,6,8)}</p>
							</c:if>
							<c:if test="${student_information.student_recent_join_date == null }">
								<p class="txt-right txt-small">미접속 회원</p>
							</c:if>
						</c:if>
						
						<div class="btn-wrap">
							<c:if test="${mode == 'modify'}">
								<button id="modify_btn" class="btn-pt mr10">수정하기</button>
								<button id="delete_btn" class="btn-sec">탈퇴처리</button>
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
		
		var password_change = false;
		var state = "${mode}";
		
		/* 학교검색 팝업on */
		$("#search_school").click(function(){
			//학교목록 초기화 후 열기
			$("#school_list_parent").children('li').remove();
			$("#search_school_popup").css("display","block");
		});
		
		/* 학교검색 검색버튼 */
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
		
		/* 비밀번호 초기화 버튼 클릭 이벤트 */
		$("#student_password_reset").click(function(){
			alert("비밀번호를 초기화 했습니다. \r수정을 완료하시면 입력하신 이메일로 비밀번호가 전송됩니다.");
			password_change = true;
		});
		
		/* 학교검색 검색버튼 */
		$("#search_school_btn").click(function(){
			var school_input_val = $("#search_school_input").val();
			if(school_input_val.length > 1 && school_input_val.length < 30){
				search_school(school_input_val);
			}else{
				alert("학교명을 2자이상 30자 이하로 입력해주세요");
			}
		});
		
		/* 학교 검색팝업 닫기 버튼 클릭 이벤트 */
		$("#popup_close").click(function(){
			$("#search_school_popup").css("display","none");
		});
		
		/* 학교 겁색팝업 - 학교 목록중 학교 클릭 이벤트 */
		$("#school_choose").click(function(){
			if($("#school_list_parent").children('.active').size() == 1){
				//모달 끄고 선택 된 학교를 밖의 학교 input에 넣는다.
				$("#student_school").val($("#school_list_parent").children('.active').text());
				$("#search_school_popup").css("display","none");
				
			}else{
				alert("학교목록에서 학교를 선택해 주세요");
				return;
			}
		});
		
		function addzero(str){
			if(str.length == 1){
				return "0"+str;
			}else{
				return str;
			}
		}
		
		// 등록하기 버튼 클릭 이벤트
		// 반환값으로 중복아이디, 중복메일, 등록 성공 유무 반환 
		$("#create_btn").click(function(){
			
			var student_name = $("#student_name").val();
			var student_school = $("#student_school").val();
			var student_age = $("#student_age").val();
			var student_sex = $("#student_sex option:selected").text();
			var student_id = $("#student_id").val();
			var student_password = $("#student_password").val();
			var student_password_again = $("#student_password_again").val();
			var student_email = $("#student_email").val();
			var student_email_checkbox = $("#student_email_checkbox");
			var student_phone = $("#student_phone").val();
			var student_phone_checkbox = $("#student_phone_checkbox");
			var student_email_agreement = "0";
			var student_push_agreement = "0";
			
			if(student_name == null || student_name.length < 1 || student_name.length > 6){
				alert("이름을 1자이상 6자 이하로 입력해주세요");
				$("#student_name").focus();
			}else if(student_school.length != 0 && (student_school.length < 1 || student_school.length > 30)){
				alert("학교 또는 기관명을 1자이상 30자 이하로 입력해주세요");
				$("#student_school").focus();
			}else if(student_sex != "남자" && student_sex != "여자" && student_sex != "선택"){
				alert("성별을 확인해 주세요");
				$("#student_sex").focus();
			}else if(student_id == null || student_id.length < 4 || student_id.length > 20){
				alert("아이디를 4자이상 20자 이하로 입력해주세요");
			}else if(student_password == null){
				alert("비밀번호를 입력해 주세요");
				$("#student_password").focus();
			}else if(student_password_again == null){
				alert("비밀번호 확인을 입력해 주세요");
				$("#student_password_again").focus();
			}else if(student_password != student_password_again){
				alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
				$("#student_password").focus();
			}else if(student_password.length < 8 || student_password.length > 20){
				alert("비밀번호를 영문+숫자+특수문자를 포함하여 8~20자로 입력하세요");
				$("#student_password").focus();
			}else if(!chekPassword(student_password)){
				alert("비밀번호를 영문+숫자+특수문자를 포함하여 8~20자로 입력하세요");
				$("#student_password").focus();
			}else if(!CheckEmail(student_email)){
				alert("이메일을 제대로 입력해주세요");
				$("#student_email").focus();
			}else if(student_age.length > 2){
				alert("나이를 제대로 입력해주세요");
				$("#student_age").focus();
			}else if(student_phone.length != 0 && student_phone.length != 11){
				alert("핸드폰번호를 제대로 입력해주세요");
				$("#student_phone").focus();
			}else{
				
				if(student_phone.length == 0){
					student_phone = null;
				}else{
					var temp_student_phone = student_phone.substr(0,3)+"-"+student_phone.substr(3,4)+"-"+student_phone.substr(7,4);
					student_phone = temp_student_phone;
				}
				
				if(student_school.length == 0){
					student_school = null;
				}
				
				if(student_age.length == 0){
					student_age = null;
				}
				
				if(student_email_checkbox.is(":checked")){
					student_email_agreement = "1";
				}
				
				if(student_phone_checkbox.is(":checked")){
					student_push_agreement = "1";
				}
				
				if(student_sex == "선택"){
					student_sex = null;
				}
				
				var params = {
						student_id:student_id,
						student_name:student_name,
						student_password:student_password,
						student_email:student_email,
						student_phone:student_phone,
						student_sex:student_sex,
						student_school:student_school,
						student_age:student_age,
						student_email_agreement:student_email_agreement,
						student_push_agreement:student_push_agreement,
						state:"create"
				}
				
				$.ajax({
					type:"POST",
					url:"/admin/member/app_member_management_detail_work",
					data:params,
					success:function(string){
						if(string == "fail"){
							alert("회원등록에 실패 했습니다.");
						}else if(string == "id_overlap"){
							alert("중복된 아이디 입니다.");
							$("#student_id").val("");
							$("#student_id").focus();
						}else if(string == "email_overlap"){
							alert("중복된 이메일 입니다.");
							$("#student_eamil").val("");
							$("#student_eamil").focus();
						}else{
							alert("회원 등록에 성공했습니다.");
							location.href="/admin/member/app_member_management_detail?student_id="+student_id+"&mode=modify";
						}
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert("회원 등록에 실패했습니다.");
						history.go(0);
					}
				});
				
			}
		});
		
		// 수정하기 버튼 클릭 이벤트
		// 반환값으로 중복메일, 수정 성공 유무 반환 
		$("#modify_btn").click(function(){
			var student_name = $("#student_name").val();
			var student_school = $("#student_school").val();
			var student_sex = $("#student_sex option:selected").text();
			var student_age = $("#student_age").val();
			var password_changed = "";
			if(password_change){
				password_changed = "y";
			}else{
				password_changed = "n";
			}
			var student_email = $("#student_email").val();
			var student_email_checkbox = $("#student_email_checkbox");
			var student_phone = $("#student_phone").val();
			var student_phone_checkbox = $("#student_phone_checkbox");
			var student_email_agreement = "0";
			var student_push_agreement = "0";
			
			if(student_name == null || student_name.length < 1 || student_name.length > 6){
				alert("이름을 1자이상 6자 이하로 입력해주세요");
				$("#student_name").focus();
			}else if(student_school.length != 0 && (student_school.length < 1 || student_school.length > 30)){
				alert("학교 또는 기관명을 1자이상 30자 이하로 입력해주세요");
				$("#student_school").focus();
			}else if(student_sex != "남자" && student_sex != "여자" && student_sex != "선택"){
				alert("성별을 확인해 주세요");
				$("#student_sex").focus();
			}else if(!CheckEmail(student_email)){
				alert("이메일을 제대로 입력해주세요");
				$("#student_email").focus();
			}else if(student_age.length > 2){
				alert("나이를 제대로 입력해주세요");
				$("#student_age").focus();
			}else if(student_phone.length != 0 && student_phone.length != 11){
				alert("핸드폰번호를 제대로 입력해주세요");
				$("#student_phone").focus();
			}else{
				
				if(student_phone.length == 0){
					student_phone = null;
				}else{
					var temp_student_phone = student_phone.substr(0,3)+"-"+student_phone.substr(3,4)+"-"+student_phone.substr(7,4);
					student_phone = temp_student_phone;
				}
				
				if(student_school.length == 0){
					student_school = null;
				}
				
				if(student_age.length == 0){
					student_age = null;
				}
				
				if(student_email_checkbox.is(":checked")){
					student_email_agreement = "1";
				}
				
				if(student_phone_checkbox.is(":checked")){
					student_push_agreement = "1";
				}
				
				if(student_sex == "선택"){
					student_sex = null;
				}
				
				var params = {
						student_id:"${student_id}",
						student_name:student_name,
						student_email:student_email,
						student_age:student_age,
						student_phone:student_phone,
						student_sex:student_sex,
						password_changed:password_changed,
						student_school:student_school,
						student_email_agreement:student_email_agreement,
						student_push_agreement:student_push_agreement,
						state:"modify"
				}
				
				$.ajax({
					type:"POST",
					url:"/admin/member/app_member_management_detail_work",
					data:params,
					success:function(string){
						if(string == "fail"){
							alert("회원정보 변경에 실패했습니다.\r다시 시도해주세요");
						}else if(string == "email_overlap"){
							alert("중복된 이메일 입니다.");
							$("#student_eamil").val("");
							$("#student_eamil").focus();
						}else{
							alert("회원정보를 변경했습니다.");
							history.go(0);
						}
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert("회원정보 변경에 실패했습니다.\r다시 시도해주세요");
						history.go(0);
					}
				});
			}
		});
		
		/* 탈퇴하기 버튼 클릭 이벤트 */
		$("#delete_btn").click(function(){
			if(confirm("정말 탈퇴처리 하시겠습니까?") == true){
				var params = {
						student_id:"${student_id}",
						state:"delete"
				}
				console.log(params);
				$.ajax({
					type:"POST",
					url:"/admin/member/app_member_management_detail_work",
					data:params,
					success:function(string){
						if(string == "success"){
							alert("해당 회원을 탈퇴처리 했습니다.");
							location.href="/admin/member/app_member_management_list"
						}else{
							alert("탈퇴 처리에 실패했습니다. \r다시 시도해주세요");
							history.go(0);
						}
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert("탈퇴 처리에 실패했습니다.\r다시 시도해주세요");
						history.go(0);
					}
				});
						
			}
		});
		
		var isRunning = false;
		
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
	});
	</script>
</html>
