<!-- 비밀번호 찾기 완료 페이지 -->

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
				<h2 class="sub-title">비밀번호 찾기</h2>

				<div class="box-wrap">
					
					<div class="box-content">
						
						<div class="member-txt">입력하신 이메일로 임시 비밀번호가 발송되었습니다.<br />
							임시 비밀번호로 로그인 후 ‘마이페이지’에서 비밀번호를 변경해주세요.
							</div>

						<div class="btn-wrap">
							<button class="btn-pt mr10">로그인 하기</button>
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
			$(".btn-pt").click(function(){
				location.href="/login";
			});
		});
	</script>
</html>
