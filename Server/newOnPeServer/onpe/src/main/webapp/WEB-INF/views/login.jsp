<!-- 로그인 화면 -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
		</style>
	</head>
	<body>

	<div class="fixed-area desktop">
		<div class="header flex justify-space">
			<h1 class="logo"><a href="/"><img src="/asset/images/logo.png" alt="" /></a></h1>
			<div class="top-menu flex items-center">
				
			</div>
		</div>
	</div>

	<div class="fixed-area mobile">
		<div class="header">
			<h1 class="logo"><a href="/">온체육</a></h1>
		</div>
	</div>

	

	<div class="wrap">
		<div class="nonelogin_content">
			<div class="wrapper member-wrapper">
				<div class="box-wrap">
					<h2 class="login-title"><img src="/asset/images/logo.png" alt="" /></h2>
					<div class="box-content">
						<form id="loginForm" action="/j_spring_security_check" method="post">
							<div class="form">
								<div class="field">
									<div class="field-inner">
										<label>아이디</label>
										<input id="login_username" type="text" name="username" placeholder="아이디를 입력하세요.">
									</div>
								</div>
								<div class="field">
									<div class="field-inner">
										<label>비밀번호</label>
										<input id="login_password" type="password" name="password" placeholder="비밀번호를 입력하세요.">
									</div>
								</div>
								
							</div>
						</form>
						<div class="btn-wrap">
							<button class="btn-pt w100">로그인</button>
							<button class="btn-sec w100 mt10">회원가입</button>
						</div>
						<div class="mylogin-txt">
							<a href="/find_id">아이디 찾기 /</a>
							<a href="/find_pw"> 비밀번호 찾기</a>
						</div>
					</div>
					
				</div>

			</div>

			<div class="footer">
				<p>copyright 컴플렉시온 ⓒ All rights reserved.</p>
				<br>
				<p>문의 : complexion@complexion.co.kr</p>
			</div>
		</div>
	</div>
	
	</body>
	<script>
		/* 
		1. 기존 로그인 전송을 실패했다면(탈퇴 회원, 아이디 또는 비밀번호 불일치) 알림창으로 알려준다. 
		2. 새로고침시 다시 알림창이 생성될 수 있으므로 파라미터를 지운다. 
		*/
		var state = "${state.state}";
		window.onload = function(){
			if(state == "1"){
				alert("탈퇴한 회원입니다.");
			}else if(state == "2"){
				alert("아이디 또는 비밀번호를 확인하세요");
			}
		}
		
		$(document).ready(function(){
			
			/* 비밀번호 입력창에서 엔터 키다운 이벤트 (로그인) */
			$("#login_password").keydown(function(key){
				if(key.keyCode == 13){
					login();
				}
			});
			
			/* 로그인 버튼 클릭 이벤트 */
			$(".btn-pt").click(function(){
				login();
			});
			
			/* 회원가입 창으로 이동 */
			$(".btn-sec").click(function(){
				location.href="/sign_up";
			});
			
			/* 입력값 존재유무 검증 후 서버로 데이터 전송 */
			function login(){
				var username = $("#login_username").val();
				var userpassword = $("#login_password").val();
				
				if(username.length > 20 || userpassword.length > 20){
					alert("아이디 또는 비밀번호를 제대로 입력해주세요");
					return;
				}else if(username.length < 4 && userpassword.length < 6){
					alert("아이디 또는 비밀번호를 제대로 입력해주세요");
					return;
				}else{
					$("#loginForm").submit();	
				}
				
			}
		});
		
		/* 새로고침시 파라미터 제거 */
		window.onkeydown = function() {
			var kcode = event.keyCode;
			if(kcode == 116) {
				history.replaceState({}, null, location.pathname);
			}
		}
	</script>
</html>
