<!-- 1:1문의 문의 등록, 문의 수정, 문의 상세 페이지 -->
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
			#question_image_box > div{ margin-bottom:10px; }
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
					</li> -->
					<li><span class="slide-tab">서비스</span>
						<ul class="depth2">
							<li><a href="/teacher/service/notice_list">공지사항</a></li>
							<li><a href="/teacher/service/faq_list">FAQ</a></li>
							<li class="active"><a href="/teacher/service/qna_list">1:1 문의</a></li>
						</ul>
					</li>
				</ul>
			</div>
		</div>
	</div>

	<div class="wrap">

		<div class="lnb">
			<ul class="depth1">
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
				</li> -->
				<li class="active"><span class="slide-tab">서비스</span>
					<ul class="depth2">
						<li><a href="/teacher/service/notice_list">공지사항</a></li>
						<li><a href="/teacher/service/faq_list">FAQ</a></li>
						<li class="active"><a href="/teacher/service/qna_list">1:1 문의</a></li>
					</ul>
				</li>
			</ul>
		</div>

		<div class="content">
			<div class="wrapper">
				<h2 class="sub-title">서비스 - 1:1 문의</h2>

				<c:if test="${mode == 'detail'}">
					<div class="box-wrap">
						<div class="box-content">	
						
							<div class="view-wrap">
								<div class="view-title">
									<h4 class="txt-title">${qna.question_title}</h4>
									<p class="info_p">작성자 아이디 : ${qna.question_id}  ·  작성자 소속 : ${qna.question_belong}  ·  작성자 이름 : ${qna.question_name}</p>
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
												<a id="deleteFile" href="${qna.question_image_content}" download>${fn:replace(qna.question_image_content, '/resources/qna/', '')}</a>
											</c:if>
										</div>
									</div>
								</div>
								
								<c:if test="${qna.question_state == '1'}">
									<br><br><br>
									<div class="field w100">
										<div class="field-inner">
											<label>답변</label>
											<textarea id="answer_content" placeholder="1:1문의 답변 내용을 입력해주세요" disabled>${qna.question_comment}</textarea>
										</div>
									</div>
								</c:if>
								
								<div class="edit-btn-wrap txt-right">
									<c:if test="${qna.question_state == '0'}">
									<button onclick="location.href='/teacher/service/qna_detail?mode=modify&question_number=${qna.question_number}'">수정</button>
									</c:if>
									<button id="delete_btn">삭제</button>
									<button onclick="location.href='/teacher/service/qna_list'">목록</button>
								</div>
								
							</div>
						</div>
						
					</div>
				</c:if>
				<c:if test="${mode == 'create' or mode == 'modify'}">
					<div class="box-wrap">
						<div class="box-content">
							<div class="form auto-w">
								<div class="field w100">
									<div class="field-inner">
										<label>제목</label>
										<input id="question_title" type="text" class="w100" placeholder="문의 제목을 작성해주세요" value="${qna.question_title}">
									</div>
								</div>
								
								<div class="field">
									<div class="field-inner">
										<label>첨부파일</label>
										<ul id="question_image_box" class="uploaded-list">
											<c:if test="${qna.question_image_content != null}">
												<div style="float:left; width:100%;">
													<li class="file_base" style="float:left;" file="${qna.question_image_content}">${fn:replace(qna.question_image_content, '/resources/qna/', '')}</li>
												</div>
											</c:if>
										</ul>
										<ul id="question_image_box2" class="uploaded-list">
										
										</ul>
										<label class="btn-upload">
											<input id="question_image_content" name="q_file" type="file">
											등록하기
										</label>
										<p class="txt-small">(용량제한 : 5M / jpg, jpeg, png 허용)</p>
									</div>
								</div>
								<div class="field w100">
									<textarea id="question_content">${qna.question_content}</textarea>
								</div>
							</div>
							<div class="btn-wrap">
								<c:if test="${mode == 'modify' }">
									<button id="modify_btn" class="btn-pt">수정</button>
									<button class="btn-sec mr10" onclick="location.href='/teacher/service/qna_detail?mode=detail&question_number=${qna.question_number}'">취소</button>
								</c:if>
								<c:if test="${mode == 'create' }">
									<button id="create_btn" class="btn-pt">등록</button>
									<button class="btn-sec mr10" onclick="location.href='/teacher/service/qna_list'">취소</button>
								</c:if>
								
							</div>
	
						</div>
						
					</div>
				</c:if>

			</div>

			<div class="footer">
				<p>copyright 컴플렉시온 ⓒ All rights reserved.</p>
			</div>
		</div>
	</div>	
	</body>
	<script>
	$(document).ready(function(){
		var newFile = null;	//신규 파일
		var deleteFile = null;	//삭제 파일

		/* 수정 모드일 경우 기존에 저장된 파일명 클릭 이벤트(해당 파일 삭제 기능) */
		$(".file_base").click(function(){
			$(this).parent('div').remove();
			deleteFile = $(this).attr("file");
		});

		/*
		 - "등록하기" 버튼클릭으로 이미지 추가, 수정시 이벤트
		 - 기존에 이미지 파일명이 있다면 삭제
		 - 해당 이미지 파일명을 첨부파일 필드에 추가
		 - 전역변수 "newFile" 에 해당파일 저장
		*/
		$("#question_image_content").change(function(){
			$("#question_image_box2").empty();
			if($(this).val() != ""){
		        // 확장자 체크
		        const target = document.getElementsByName('q_file');
		        var ext = $(this).val().split(".").pop().toLowerCase();
		        if($.inArray(ext, ["jpg","jpeg",,"png"]) == -1){
		        	alert("jpg, jpeg, png 파일만 업로드 해주세요.");
		        	$(this).val("");
		        	return;
		        }else{
		        	if($(".file_base").length > 0){
		        		deleteFile = $(".file_base").attr("file");
		        		$(".file_base").parent('div').remove();
		        	}
		        	$.each(target[0].files, function(index, file){
			        	const fileName = file.name;
			        	$("#question_image_box").append('<div style="float:left; width:100%;"><li class="file_base2" style="float:left; ">'+ fileName +'</li></div>');
			        	newFile = file;
			        });
		        	$(".file_base2").off().click(function(){
		    			$(this).parent('div').remove();
		    			newFile = null;
		    		});
		        }
            }
		});

		/*
		 - "삭제" 버튼 클릭 이벤트
		 - 해당 문의글을 삭제한다.
		*/
		$("#delete_btn").click(function(){
			if (confirm("정말 문의글을 삭제 하시겠습니까?") == true){
				var formData = new FormData();
				formData.append("mode", "delete");
				formData.append("question_number", "${qna.question_number}");
				if($("#deleteFile").length > 0){
					formData.append("deleteFile", $("#deleteFile").attr("href"));
				}
				$.ajax({
					type:"POST",
					url:"/teacher/service/qna_detail_work",
					data:formData,
					cache:false,
					contentType:false,
					processData:false,
					dataType:"text",
					success:function(string){
						if(string == "fail"){
							alert("문의 삭제에 실패했습니다.\r다시 시도해주세요");
						}else{
							alert("문의를 삭제 했습니다.");
							location.href="/teacher/service/qna_list";
						}
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert("문의 삭제에 실패했습니다.\r다시 시도해주세요");
					}
				});
			}
		});

		/*
		 - 수정모드 - "수정" 버튼 클릭이벤트
		 - 입력한 값으로 1:1문의글을 수정한다.
		*/
		$("#modify_btn").click(function(){
			
			var question_title = $("#question_title").val();
			var question_content = $("#question_content").val();
			var question_image_content = null;
			if($(".file_base").length > 0){
				question_image_content = $(".file_base").attr("file");
			}
			
			if(question_title.length < 2 || question_title.length > 80){
				alert("문의 제목을 2 ~ 80자로 입력해주세요.");
				return;
			}
			if(question_content.length < 5 || question_content.length > 3000){
				alert("문의 내용을 5 ~ 3000자로 입력해주세요.");
				return;
			}
			
			var formData = new FormData();
			if(newFile!=null){
				formData.append("files", newFile);
			}
			formData.append("question_number", "${qna.question_number}");
			formData.append("question_title", question_title);
			formData.append("question_content", question_content);
			formData.append("deleteFile", deleteFile);
			formData.append("question_image_content", question_image_content);
			formData.append("mode", "modify");
			
			$.ajax({
				type:"POST",
				url:"/teacher/service/qna_detail_work",
				data:formData,
				cache:false,
				contentType:false,
				processData:false,
				dataType:"text",
				success:function(string){
					if(string == "fail"){
						alert("문의 수정 실패했습니다.\r다시 시도해주세요");
					}else{
						alert("문의를 수정 했습니다.");
						location.href="/teacher/service/qna_detail?mode=detail&question_number=${qna.question_number}";
					}
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert("문의 수정에 실패했습니다.\r다시 시도해주세요");
				}
			});
		});

		/*
		 - 등록모드 - "등록" 버튼 클릭 이벤트
		 - 입력한 값으로 1:1문의를 등록한다.
		*/
		$("#create_btn").click(function(){
			var question_title = $("#question_title").val();
			var question_content = $("#question_content").val();
			if(question_title.length < 2 || question_title.length > 80){
				alert("문의 제목을 2 ~ 80자로 입력해주세요.");
				return;
			}
			if(question_content.length < 5 || question_content.length > 3000){
				alert("문의 내용을 5 ~ 3000자로 입력해주세요.");
				return;
			}
			
			var formData = new FormData();
			if(newFile!=null){
				formData.append("files", newFile);
			}
			formData.append("question_title", question_title);
			formData.append("question_content", question_content);
			formData.append("mode", "create");
			
			$.ajax({
				type:"POST",
				url:"/teacher/service/qna_detail_work",
				data:formData,
				cache:false,
				contentType:false,
				processData:false,
				dataType:"text",
				success:function(string){
					if(string == "fail"){
						alert("문의 등록에 실패했습니다.\r다시 시도해주세요");
					}else{
						alert("문의를 등록 했습니다.");
						location.href="/teacher/service/qna_list";
					}
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert("문의 등록에 실패했습니다.\r다시 시도해주세요");
				}
			});
		});
	});
	</script>
</html>
