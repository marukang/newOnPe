<!-- 1:1문의 관리 답변 페이지 -->

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
			.popup_textarea{ height:150px; }
			#today_curriculum_box{ min-height:250px; }
			.info_p{ margin:10px 0; }
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
					<li><span class="slide-tab">관리자 메뉴</span>
						<ul class="depth2">
							<li><a href="/admin/member/lms_member_management_list">회원관리(LMS)</a></li>
							<li><a href="/admin/member/app_member_management_list">회원관리(App)</a></li>
							<li><a href="/admin/exercise/exercise_management_list">종목 관리</a></li>
							<li><a href="/admin/popup/popup_management_list">팝업창 관리</a></li>
							<li><a href="/admin/push/push_management_list">PUSH 관리</a></li>
							<li><a href="/admin/etc/notice_list">공지사항 관리</a></li>
							<li><a href="/admin/etc/faq_list">FAQ 관리</a></li>
							<li class="active"><a href="/admin/etc/qna_list">1:1문의 관리</a></li>
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
						<li><a href="/admin/etc/faq_list">FAQ 관리</a></li>
						<li class="active"><a href="/admin/etc/qna_list">1:1문의 관리</a></li>
					</ul>
				</li>
			</ul>
		</div>

		<div class="content">
			<div class="wrapper">
				<h2 class="sub-title">관리자메뉴 - 1:1문의 관리</h2>

				<div class="box-wrap">
					<div class="box-content">	
					
						<div class="view-wrap">
							<div class="view-title">
								<h4 class="txt-title">${qna.question_title}</h4>
								<p class="info_p">작성자 아이디 : ${qna.question_id}  ·  작성자 소속 : ${qna.question_belong}  ·  작성자 이름 : ${qna.question_name}</p>
								<p class="info_p">문의 분류 : ${qna.question_type}</p>
								<p class="info_p">등록일 : ${fn:substring(qna.question_date,0,4)}-${fn:substring(qna.question_date,4,6)}-${fn:substring(qna.question_date,6,8)}  ·  연락처: ${fn:substring(qna.question_phonenumber,0,3)}-${fn:substring(qna.question_phonenumber,3,7)}-${fn:substring(qna.question_phonenumber,7,11)}</p>
							</div>
							<div class="field w100">
								<div class="field-inner">
									<label>문의내용</label>
									<textarea disabled>${qna.question_content}</textarea>
								</div>
							</div>
							<div class="view-attachment flex">
								<div class="view-info">
									<h4>첨부파일</h4>
									<div class="link-wrap">
										<c:if test="${qna.question_image_content != null}">
											<a href="${qna.question_image_content}" download>${fn:replace(qna.question_image_content, '/resources/qna/', '')}</a>
										</c:if>
									</div>
								</div>
							</div>
							 
							<br><br><br>
							<div class="field w100">
								<div class="field-inner">
									<label>답변</label>
									<textarea id="answer_content" placeholder="1:1문의 답변 내용을 입력해주세요">${qna.question_comment}</textarea>
								</div>
							</div>
						</div>
						
						
						<div class="btn-wrap">
							<button id="answer_btn" class="btn-pt">답변하기</button>
							<button class="btn-sec" onclick="location.href='/admin/etc/qna_list'">목록</button>
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
		
		/* 답변하기 버튼 클릭 이벤트 */
		$("#answer_btn").click(function(){
			var answer_content = $("#answer_content").val();
			
			if(answer_content.length < 5 || answer_content.length > 3000){
				alert("답변 내용을 5 ~ 3000자로 입력해주세요");
				return;
			}
			
			var data = {
					"question_number":"${question_number}",
					"question_comment":answer_content
				}

			$.ajax({
				type:"POST",
				url:"/admin/etc/qna_detail_work",
				data:data,
				dataType:"text",
				success:function(string){
					if(string == "fail"){
						alert("1:1문의 답변에 실패했습니다.\r다시 시도해주세요");
					}else{
						alert("1:1문의에 답변했습니다.");
						history.go(0);
					}
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert("1:1문의 답변에 실패했습니다.\r다시 시도해주세요");
				}
			});
		});
		
	});
	</script>
</html>
