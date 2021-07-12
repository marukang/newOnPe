<!-- 아이디 찾기 페이지 -->

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
				<h2 class="sub-title">아이디 찾기</h2>

				<div class="box-wrap">
					
					<div class="box-content">
						<div class="form">
						<div class="field">
							<div class="field-inner">
								<label>이름</label>
									<input id="teacher_name" type="text" placeholder="이름을 입력하세요">
								</div>
							</div>
							<div class="field">
								<div class="field-inner">
									<label>E-mail</label>
									<input id="teacher_email" type="email" placeholder="ex) complexion@complexion.co.kr">
								</div>
							</div>
							<form id="find_id_form" action="/find_id_ck" method="post">
								<input id="teacher_name_f" name="teacher_name" type="hidden">
								<input id="teacher_email_f" name="teacher_email" type="hidden">
							</form>
						</div>
						<div class="btn-wrap">
							<button class="btn-pt mr10">확인</button>
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
	
	/* 
	1. 이름과 이메일이 불일치시 알림창 생성
	2. 새로고침시 다시 알림창이 생성될 수 있으므로 파라미터를 지운다. 
	*/
	
		var state = "${state.state}";
		window.onload = function(){
			if(state == "1"){
				alert("아이디를 찾을수 없습니다.");
			}
		}
		
		/* 새로고침시 파라미터 제거 */
		window.onkeydown = function() {
			var kcode = event.keyCode;
			if(kcode == 116) {
				history.replaceState({}, null, location.pathname);
			}
		}
		
		$(document).ready(function(){
			
			/* 
			"확인버튼" 클릭 또는 E-mail 입력필드 Enter 키다운 이벤트 
			 - 입력값이 공백인지 검증
			 - E-mail 입력필드가 이메일 형식인지 검증
			 - 위 두가지 검증 후 서버로 데이터 전송
			*/
			
			$("#teacher_email").keydown(function(key){
				if(key.keyCode == 13){
					form_check();
				}
			});
			
			$(".btn-pt").click(function(){
				form_check();
			});
			
			function form_check(){
				var teacher_name = $("#teacher_name").val();
				var teacher_email = $("#teacher_email").val();
				
				if(teacher_name.length > 20 || teacher_name.length < 1){
					alert("이름을 제대로 입력해주세요");
					return;
				}else if(!CheckEmail(teacher_email)){
					alert("이메일을 제대로 입력해주세요");
					return;
				}else{
					$("#teacher_name_f").val(teacher_name);
					$("#teacher_email_f").val(teacher_email);
					$("#find_id_form").submit();
				}
				
			}
		});
		
	
	</script>
</html>
