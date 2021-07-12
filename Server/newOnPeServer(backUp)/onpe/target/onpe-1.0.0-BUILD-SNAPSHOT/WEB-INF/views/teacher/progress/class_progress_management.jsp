<!-- 실시간 수업 진행 페이지 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="date" value="<%=new java.util.Date()%>" />
<c:set var="nowDate"><fmt:formatDate value="${date}" pattern="yyyyMMdd" /></c:set>
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
		<link rel="stylesheet" href="/asset/css/main.css" />
		<link rel="stylesheet" type="text/css" href="/asset/css/style.css" />
		
		
		<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
		<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>


		<script src="/asset/lib/jquery-1.11.3.min.js"></script>
		<script src="/asset/lib/jquery-ui.js"></script>
		<script src="/asset/lib/swiper-bundle.min.js"></script>
		<script src="/asset/js/script.js"></script>
		<script src="/asset/lib/main.min.js"></script>
		<base href="/" />
		<style>
			.hidden_box{ display:none; }
			.fc-event-title-container{ cursor:pointer; }
			#unit_content_url a, #unit_youtube_url a{ cursor:pointer; }
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
							<li class="active"><a href="/teacher/progress/class_progress_management">실시간 수업 진행</a></li>
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
							<li><a href="/teacher/service/qna_list">1:1 문의</a></li>
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
						<li class="active"><a href="/teacher/progress/class_progress_management">실시간 수업 진행</a></li>
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
						<li><a href="/teacher/service/qna_list">1:1 문의</a></li>
					</ul>
				</li>
			</ul>
		</div>
		
		<div id="curriculum_result_popup" class="popup" style="display:none;">
			<div class="popup-cont">
				<div class="pop-title flex justify-space">
					<div class="left flex">
						<h2 id="curriculum_result_popup_title"></h2>
					</div>
					<div class="right">
						<button id="curriculum_result_popup_close" class="close">x</button>
					</div>
				</div>
				<div class="pop-cont">
					<div class="x-scroll-area">
						<table id="curriculum_result_popup_table" class="basic">
							<tr>
								<th>학년</th>
								<th>학급</th>
								<th>학번</th>
								<th>이름</th>
								<th>출석</th>
								<th>실습과제</th>
								<th>상/중/하 평가</th>
								<th>점수 평가</th>
								<th>텍스트 평가</th>
								<th>운동기록</th>
							</tr>
						</table>
					</div>
					<div id="curriculum_result_popup_paging" class="paging mt10">
					</div>
					<div class="btn-wrap">
						<button id="curriculum_result_popup_save" class="btn-pt" class_code="" unit_code="">저장하기</button>
					</div>
	
				</div>
			</div>
		</div>
		
		<div id="push_popup" class="popup" style="display:none;">
		<div class="popup-cont small-pop">
			<div class="pop-title flex justify-space">
				<div class="left flex">
					<h2>공지사항</h2>
				</div>
				<div class="right">
					<button id="push_popup_close" class="close">x</button>
				</div>
			</div>
			<div class="pop-cont">
				<div class="pop-cont-inner">
					
					<div class="form">
						
						<div class="field-inner">
							<label>제목</label>
							<input id="push_title" />
						</div>
					
						<div class="field">
							<div class="field-inner">
								<label>내용</label>
								<textarea id="push_content"></textarea>
							</div>
						</div>
					</div>
				
				</div>
				
				<div class="btn-wrap">
					<button class="btn-pt" id="popup_send_push_btn">전송</button>
				</div>
			</div>
		</div>
	</div>
		
		<div id="student_one_class_status_popup" class="popup" style="display:none;">
			<div class="popup-cont">
				<div class="pop-title flex justify-space">
					<div class="left flex">
						<h2>수업 현황</h2>
					</div>
					<div class="right">
						<button id="student_one_class_status_popup_close" class="close">x</button>
					</div>
				</div>
				<div class="pop-cont">
					<div class="pop-cont-inner">
						<div class="overflow">
							<table id="student_one_class_status_popup_table" class="basic medium">
								<tr>
									<th>학년</th>
									<th>학급</th>
									<th>학번</th>
									<th>이름</th>
									<th>출석</th>
									<th>실습과제</th>
									<th>상/중/하 평가</th>
									<th>점수 평가</th>
									<th>텍스트 평가</th>
									<th>운동 기록</th>
								</tr>
							</table>
						</div>				
					</div>		
				</div>
			</div>
		</div>
		
		<div id="student_exercise_record_popup" class="popup" style="display:none;">
			<div class="popup-cont">
				<div class="pop-title flex justify-space">
					<div class="left flex">
						<h2>학생 운동기록</h2>
					</div>
					<div class="right">
						<button id="student_exercise_record_popup_close" class="close">x</button>
					</div>
				</div>
				<div class="pop-cont">
					<div class="pop-cont-inner">
						<div class="overflow">
							<table id="student_exercise_record_popup_table" class="basic medium">
								<tr>
									<th>수업</th>
									<th>종목</th>
									<th>대분류</th>
									<th>동작명</th>
									<th>운동 개수</th>
									<th>완료 시간</th>
								</tr>
							</table>
						</div>				
					</div>		
				</div>
			</div>
		</div>
		
		<div id="student_exercise_record_main_popup" class="popup" style="display:none;">
			<div class="popup-cont">
				<div class="pop-title flex justify-space">
					<div class="left flex">
						<h2>학생 운동기록</h2>
					</div>
					<div class="right">
						<button id="student_exercise_record_popup_main_close" class="close">x</button>
					</div>
				</div>
				<div class="pop-cont">
					<div class="pop-cont-inner">
						<div class="overflow">
							<table id="student_exercise_record_popup_main_table" class="basic medium">
								<tr>
									<th>수업</th>
									<th>종목</th>
									<th>대분류</th>
									<th>동작명</th>
									<th>운동 개수</th>
									<th>완료 시간</th>
								</tr>
							</table>
						</div>				
					</div>		
				</div>
			</div>
		</div>
		

		<div class="content">
			<div class="wrapper">
				<h2 class="sub-title">실시간 수업 진행</h2>
				<div class="box-wrap">
					<div class="calendar-wrap">
						<div id='calendar'></div>
					</div>
				</div>
				<div id="curriculum_management_box" class="box-wrap hidden_box">
					<div class="arco-title">
						<h3>수업 관리</h3>
					</div>
					<div class="box-content arco-cont">
						<div class="view-wrap">
						
							<div id="group_content_box" class="field hidden_box">
								<label>그룹 선택</label>
								<div class="field-inner flex">
									<select id="unit_group_name" class="w32">
										<option class="unit_group_name_option">1그룹</option>
									</select>
								</div>
							</div>
							
							<div class="view-title flex justify-space">
								<div class="left">
									<h4 id="unit_class_name" class="txt-title"></h4>
									<p id="unit_class_curriculum_information"></p>
								</div>
								<div class="right flex">
									<div id="class_project_submit_type" class="view-info mr30">
										<h4>과제 제출 방법</h4>
									</div>
								</div>
							</div>
							<textarea id="unit_class_text" class="view-content" disabled>
								
							</textarea>
							<div class="view-attachment flex">
								<div class="view-info w32">
									<h4>참고자료</h4>
									<div id="unit_attached_file" class="link-wrap">
									</div>
								</div>
								<div class="view-info w32">
									<h4>유튜브 영상</h4>
									<div id="unit_youtube_url" class="link-wrap">
									</div>
								</div>
								<div class="view-info w32">
									<h4>수업 관련 링크</h4>
									<div id="unit_content_url" class="link-wrap">
									</div>
								</div>
							</div>
						</div>
						<div class="btn-wrap">
							<button id="send_push_btn" class="btn-pt mr10">학급 공지 보내기</button>
							<button id="modify_curriculum_btn" class="btn-sec">수업 정보 수정</button>
						</div>
					</div>
				</div>
				<div id="student_management_box" class="box-wrap hidden_box">
					<div class="arco-title">
						<h3>학생 관리</h3>
					</div>
					<div class="box-content arco-cont">
						<div class="overflow">
							<table id="student_management_table" class="basic">
								<tr>
									<th>학년</th>
									<th>학급</th>
									<th>학번</th>
									<th>이름</th>
									<th>상태</th>
									<th>연락처</th>
									<th>수업 현황</th>
									<th>본인 확인</th>
								</tr>
							</table>
						</div>
						<div class="edit-btn-wrap mt10">
							<button onclick="location.href='/'" class="bg">메세지함</button>
						</div>
						
						<div id="student_management_box_paging" class="paging mt10">
							
						</div>
						
						<div class="btn-wrap">
							<button id="open_curriculum_result_popup" class="btn-pt">차시별 수업 결과 확인하기</button>
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
	var first = false;	//차시별 수업 결과 팝업의 학생목록 구성함수 재호출 방지
	var global_start_date = null;	//선택한 클래스 - 시작일
	var global_end_date = null;	//선택한 클래스 - 종료일
	var now_date = ${nowDate};	//오늘날짜
	var global_content_home_work = null;	//선택한 클래스 - 차시의 과제유무(JSON Array)
	var global_content_evaluation_type = null;	//선택한 클래스 - 차시의 평가방식(JSON Array)
	var global_content_test = null	//선택한 클래스 - 차시의 평가유무(JSON Array)
	var global_class_code = "";	//선택한 클래스 - 클래스코드
	var running_noti = false;	//공지사항 전송함수 재호출 방지
	var group_object = null;	//선택한 클래스 - 차시 가 그룹일 경우 그룹 객체를 저장
	var class_object = null;	//선택한 클래스 객체를 저장

	document.addEventListener('DOMContentLoaded', function() {

		//공지사항 전송팝업 닫기 클릭 이벤트
		$("#push_popup_close").click(function(){
			$("#push_popup").css("display", "none");
		});

		//선택 클래스 - 차시가 그룹형 차시일 경우 선택 그룹 셀렉트박스 변경시 이벤트
		$("#unit_group_name").change(function(){
			first = true;
			var index = $("#unit_group_name option").index($("#unit_group_name option:selected"));
			var class_list = class_object;
			var curriculum = group_object[index];

			/* 선택 클래스 정보로 전역변수 셋팅(과제유무 JSON Array, 평가방식 JSON Array, 평가유무 JSON Array) */
			global_content_home_work = JSON.parse(curriculum["content_home_work"]);
			global_content_test = JSON.parse(curriculum["content_test"]);
			global_content_evaluation_type = JSON.parse(curriculum["content_evaluation_type"]);

			/* 화면 셋팅(선택 그룹 정보 + 선택그룹에 포함된 수업에 참여한 학생 목록) */

			/* -------------------- 선택한 그룹 정보 셋팅 Start -------------------- */
			$("#unit_class_name").text(curriculum["unit_class_name"]);

			$("#curriculum_result_popup_title").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반 "+curriculum["unit_class_name"]+" 차시별 결과");
			  
			var start_date = curriculum["unit_start_date"];
			global_start_date = start_date;
			var end_date = curriculum["unit_end_date"];
			global_end_date = end_date;
			if(curriculum["unit_class_type"] == "1"){
				var allP = JSON.parse(curriculum["unit_group_id_list"]);
				if(curriculum["content_participation"] != null){
					var parP = JSON.parse(curriculum["content_participation"]);
					$("#unit_class_curriculum_information").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반("+parP.length+"명/"+allP.length+"명) · "+start_date.substring(0,4)+"-"+start_date.substring(4,6)+"-"+start_date.substring(6,8)+" ~ "+end_date.substring(0,4)+"-"+end_date.substring(4,6)+"-"+end_date.substring(6,8));
				}else{
					$("#unit_class_curriculum_information").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반(0명/"+allP.length+"명) · "+start_date.substring(0,4)+"-"+start_date.substring(4,6)+"-"+start_date.substring(6,8)+" ~ "+end_date.substring(0,4)+"-"+end_date.substring(4,6)+"-"+end_date.substring(6,8));
				}
			}else{
				if(curriculum["content_participation"] != null){
					var parP = JSON.parse(curriculum["content_participation"]);
					$("#unit_class_curriculum_information").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반("+parP.length+"명/"+class_list["class_people_max_count"]+"명) · "+start_date.substring(0,4)+"-"+start_date.substring(4,6)+"-"+start_date.substring(6,8)+" ~ "+end_date.substring(0,4)+"-"+end_date.substring(4,6)+"-"+end_date.substring(6,8));
				}else{
					$("#unit_class_curriculum_information").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반(0명/"+class_list["class_people_max_count"]+"명) · "+start_date.substring(0,4)+"-"+start_date.substring(4,6)+"-"+start_date.substring(6,8)+" ~ "+end_date.substring(0,4)+"-"+end_date.substring(4,6)+"-"+end_date.substring(6,8));
				}	
			}
			  
			var submit_type = JSON.parse(class_list["class_project_submit_type"]);
			var node = "<h4>과제 제출 방법</h4>";
			for(x=0;x<submit_type.length;x++){
				node += "<p>"+submit_type[x]["type"]+" : "+submit_type[x]["link"]+"</p>";
			}
			$("#class_project_submit_type").empty();
			$("#class_project_submit_type").append(node);
			$("#unit_class_text").text(curriculum["unit_class_text"]);
			  
			$("#unit_attached_file").empty();
			if(curriculum["unit_attached_file"] != null){
				var attached_file = JSON.parse(curriculum["unit_attached_file"]);
				var node = "";
				for(x=0;x<attached_file.length;x++){
					node += "<a href='"+attached_file[x]+"' download>"+attached_file[x].replace("/resources/class_file/","")+"</a>";
				}
				$("#unit_attached_file").append(node);
			}
			  
			$("#unit_youtube_url").empty();
			if(curriculum["unit_youtube_url"] != null){
				var unit_youtube_url = JSON.parse(curriculum["unit_youtube_url"]);
				var node = "";
				for(x=0;x<unit_youtube_url.length;x++){
					node += "<a onclick='window.open(\""+unit_youtube_url[x]["link"]+"\")'>"+unit_youtube_url[x]["title"]+"</a>";
				}
				$("#unit_youtube_url").append(node);
			}
			  
			$("#unit_content_url").empty();
			if(curriculum["unit_content_url"] != null){
				var unit_content_url = JSON.parse(curriculum["unit_content_url"]);
				var node = "";
				for(x=0;x<unit_content_url.length;x++){
					node += "<a onclick='window.open(\""+unit_content_url[x]["link"]+"\")'>"+unit_content_url[x]["title"]+"</a>";
				}
				$("#unit_content_url").append(node);
			}
			  
			$("#curriculum_management_box").removeClass("hidden_box");
			if(!$("#curriculum_management_box").children('div').eq(0).hasClass("active")){
				$("#curriculum_management_box").children('div').eq(0).addClass("active");
				$("#curriculum_management_box").children('div').eq(1).css("display", "block");
			}
			/* -------------------- 선택한 그룹 정보 셋팅 End -------------------- */

			/* -------------------- 선택한 그룹 수업에 참여중인 학생 목록 셋팅 Start -------------------- */
			if(curriculum["unit_class_type"] == "1"){
				get_student_management(curriculum["class_code"],curriculum["unit_code"], 1, JSON.parse(curriculum["unit_group_id_list"]));
			}else{
				get_student_management(curriculum["class_code"],curriculum["unit_code"], 1, null);	
			}
			/* -------------------- 선택한 그룹 수업에 참여중인 학생 목록 셋팅 End -------------------- */
			  
			//클릭이벤트 추가(공지사항 전송)
			$("#send_push_btn").off().click(function(){
				$("#push_title").val("");
				$("#push_content").val("");
				$("#push_popup").css("display","block");
			});

			/* "수업 정보 수정" 버튼 클릭 이벤트 추가 */
			$("#modify_curriculum_btn").off().click(function(){
				location.href="/teacher/ready/class_configuration_management_detail?class_code="+curriculum["class_code"];
			});
		});

		/* 학급 공지 보내기 팝업 -> 전송 버튼 클릭시 이벤트 */
		$("#popup_send_push_btn").click(function(){
			if(!running_noti){
				running_noti = true;
				if($("#push_title").val().length < 2 || $("#push_title").val().length > 50){
					alert("공지사항 제목을 2자 이상 50자 이하로 작성해주세요");
					return;
				}
				if($("#push_content").val().length < 2 || $("#push_content").val().length > 200){
					alert("공지사항 내용을 2자 이상 200자 이하로 작성해주세요");
					return;
				}
				var Obj = {
						"push_content": $("#push_title").val(),
						"class_code": global_class_code,
						"push_title": $("#push_content").val()
					}
				$.ajax({
					type:"POST",
	    			url:"/teacher/progress/send_notification",
		    		data:Obj,
		    		success:function(string){
		    			if(string == "success"){
		    				alert("공지사항을 전송했습니다.");
		    				$("#push_popup").css("display", "none");
	    				}else if(string == "none"){
	    					alert("클래스에 참여중인 학생이 없습니다.");
	    					$("#push_popup").css("display", "none");
    					}else{
    						alert("공지사항 전송에 실패했습니다.");
    						$("#push_popup").css("display", "none");
   						}
		    			running_noti = false;
		    		},
	    			error:function(XMLHttpRequest, textStatus, errorThrown){
	    				alert("서버에러입니다.\r다시 시도해주세요");
	    				running_noti = false;
					}
				});
			}
		});

		/*
		*  - 수업 생성/관리 -> 클래스 -> STEP 2 -> 하나의 차시 "수업이동" 버튼을 통해 현재 페이지에 온 경우
		*  - 바로 수업관리, 학생관리까지 셋팅해준다.
		*/
		var is_get = "${get}";
		if(is_get == "y"){
			var Obj = {
					"unit_code": "${unit_code}",
					"class_code": "${class_code}",
					"mode": "curriculum"
				}
			$.ajax({
				type:"POST",
    			url:"/teacher/progress/get_class_progress_management_work",
	    		data:Obj,
	    		success:function(string){
	    			var object = JSON.parse(string);
	    			var class_list = object["class_list"];
	    			var curriculum = object["curriculum"][0];

	    			/* 그룹 수업 확인 및 그룹선택 셀렉트박스 셋팅 */
	    			if(curriculum["unit_class_type"] == "1"){
	    				class_object = object["class_list"];
	    				group_object = object["curriculum"];
	    				var nd = "";
	    				for(x=0;x<object["curriculum"].length;x++){
	    					$("#unit_group_name").empty();
	    					nd += '<option class="unit_group_name_option">'+object["curriculum"][x]["unit_group_name"]+'</option>';
	    				}
	    				$("#unit_group_name").append(nd);
	    				$("#group_content_box").removeClass("hidden_box");
	    			}

	    			/* 차시 정보 전역변수 셋팅 */
	    			global_content_home_work = JSON.parse(curriculum["content_home_work"]);
	    			global_content_test = JSON.parse(curriculum["content_test"]);
	    			global_content_evaluation_type = JSON.parse(curriculum["content_evaluation_type"]);

	    			/* 해당 차시 정보를 화면에 셋팅 */
	    			if(curriculum != null){
						first = true;

	    				$("#unit_class_name").text(curriculum["unit_class_name"]);

	    				$("#curriculum_result_popup_title").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반 "+curriculum["unit_class_name"]+" 차시별 결과");
	    				  
	    				var start_date = curriculum["unit_start_date"];
	    				global_start_date = start_date;
	    				var end_date = curriculum["unit_end_date"];
	    				global_end_date = end_date;
	    				if(curriculum["unit_class_type"] == "1"){
	    					var allP = JSON.parse(curriculum["unit_group_id_list"]);
	    					if(curriculum["content_participation"] != null){
	    						var parP = JSON.parse(curriculum["content_participation"]);
	    						$("#unit_class_curriculum_information").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반("+parP.length+"명/"+allP.length+"명) · "+start_date.substring(0,4)+"-"+start_date.substring(4,6)+"-"+start_date.substring(6,8)+" ~ "+end_date.substring(0,4)+"-"+end_date.substring(4,6)+"-"+end_date.substring(6,8));
	    					}else{
	    						$("#unit_class_curriculum_information").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반(0명/"+allP.length+"명) · "+start_date.substring(0,4)+"-"+start_date.substring(4,6)+"-"+start_date.substring(6,8)+" ~ "+end_date.substring(0,4)+"-"+end_date.substring(4,6)+"-"+end_date.substring(6,8));
	    					}
	    				}else{
	    					if(curriculum["content_participation"] != null){
	    						var parP = JSON.parse(curriculum["content_participation"]);
	    						$("#unit_class_curriculum_information").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반("+parP.length+"명/"+class_list["class_people_max_count"]+"명) · "+start_date.substring(0,4)+"-"+start_date.substring(4,6)+"-"+start_date.substring(6,8)+" ~ "+end_date.substring(0,4)+"-"+end_date.substring(4,6)+"-"+end_date.substring(6,8));
	    					}else{
	    						$("#unit_class_curriculum_information").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반(0명/"+class_list["class_people_max_count"]+"명) · "+start_date.substring(0,4)+"-"+start_date.substring(4,6)+"-"+start_date.substring(6,8)+" ~ "+end_date.substring(0,4)+"-"+end_date.substring(4,6)+"-"+end_date.substring(6,8));
	    					}	
	    				}
	    				  
	    				var submit_type = JSON.parse(class_list["class_project_submit_type"]);
	    				var node = "<h4>과제 제출 방법</h4>";
	    				for(x=0;x<submit_type.length;x++){
	    					node += "<p>"+submit_type[x]["type"]+" : "+submit_type[x]["link"]+"</p>";
	    				}
	    				$("#class_project_submit_type").empty();
	    				$("#class_project_submit_type").append(node);
	    				$("#unit_class_text").text(curriculum["unit_class_text"]);
	    				  
	    				$("#unit_attached_file").empty();
	    				if(curriculum["unit_attached_file"] != null){
	    					var attached_file = JSON.parse(curriculum["unit_attached_file"]);
	    					var node = "";
	    					for(x=0;x<attached_file.length;x++){
	    						node += "<a href='"+attached_file[x]+"' download>"+attached_file[x].replace("/resources/class_file/","")+"</a>";
	    					}
	    					$("#unit_attached_file").append(node);
	    				}
	    				  
	    				$("#unit_youtube_url").empty();
	    				if(curriculum["unit_youtube_url"] != null){
	    					var unit_youtube_url = JSON.parse(curriculum["unit_youtube_url"]);
	    					var node = "";
	    					for(x=0;x<unit_youtube_url.length;x++){
	    						node += "<a onclick='window.open(\""+unit_youtube_url[x]["link"]+"\")'>"+unit_youtube_url[x]["title"]+"</a>";
    						}
	    					$("#unit_youtube_url").append(node);
	    				}
	    				  
	    				$("#unit_content_url").empty();
	    				if(curriculum["unit_content_url"] != null){
	    					var unit_content_url = JSON.parse(curriculum["unit_content_url"]);
	    					var node = "";
	    					for(x=0;x<unit_content_url.length;x++){
	    						node += "<a onclick='window.open(\""+unit_content_url[x]["link"]+"\")'>"+unit_content_url[x]["title"]+"</a>";
	    					}
	    					$("#unit_content_url").append(node);
	    				}
	    				  
	    				$("#curriculum_management_box").removeClass("hidden_box");
	    				if(!$("#curriculum_management_box").children('div').eq(0).hasClass("active")){
	    					$("#curriculum_management_box").children('div').eq(0).addClass("active");
	    					$("#curriculum_management_box").children('div').eq(1).css("display", "block");
	    				}

	    				/* 학생 목록 셋팅 */
	    				if(curriculum["unit_class_type"] == "1"){
	    					get_student_management(curriculum["class_code"],curriculum["unit_code"], 1, JSON.parse(curriculum["unit_group_id_list"]));
	    				}else{
	    					get_student_management(curriculum["class_code"],curriculum["unit_code"], 1, null);	
	    				}
		    			  
		    			//"학급 공지 보내기" 버튼 클릭이벤트 추가
		    			$("#send_push_btn").off().click(function(){
		    				$("#push_title").val("");
		    				$("#push_content").val("");
		    				$("#push_popup").css("display","block");
		    			});

	    				/* "수업 정보 수정" 버튼 클릭 이벤트 추가 */
		    			$("#modify_curriculum_btn").off().click(function(){
		    				location.href="/teacher/ready/class_configuration_management_detail?class_code="+curriculum["class_code"];
		    			});
		    			  
	    			}else{

	    				/* 해당 차시정보가 없으므로 수업 관리, 학생 관리 숨기기 */

	    				if(!$("#curriculum_management_box").hasClass("hidden_box")){
	    					$("#curriculum_management_box").addClass("hidden_box");
	    				}
	    				if(!$("#student_management_box").hasClass("hidden_box")){
	    					$("#student_management_box").addClass("hidden_box");  
	    				}
    				}			    			  
    			},
    			error:function(XMLHttpRequest, textStatus, errorThrown){
    				alert("서버에러입니다.\r다시 시도해주세요");
				}
   			});
		}
		
		
		
		/* 캘린더 셋팅 */
		var calendarEl = document.getElementById('calendar');
		Obj = {mode:"calendar"};
		$.ajax({
			type:"POST",
			url:"/teacher/progress/get_class_progress_management_work",
			data:Obj,
			success:function(string){
				if(string == "fail"){
					alert("에러입니다.\r새로고침 해주세요");
					return;
				}
				if(string == "none"){
					alert("진행중인 수업이 없습니다.");
					return;
				}
				/* 진행중인 수업이 존재할 때 존재 수업들의 시작일, 종료일을 기준으로 캘린더 셋팅 */
				var object = JSON.parse(string);
				var appendArray = [];
				for(x=0;x<object.length;x++){
					var start_temp = object[x]["unit_start_date"];
					var start = start_temp.substring(0,4) + "-" + start_temp.substring(4,6) + "-" + start_temp.substring(6,8);
					var end_temp = object[x]["unit_end_date"];
					
					var t_y = end_temp.substring(0,4);
					var t_m = end_temp.substring(4,6);
					var t_d = end_temp.substring(6,8);
					if(t_m.substring(0,1) == "0"){
						t_m = t_m.substring(1,2);
					}
					if(t_d.substring(0,1) == "0"){
						t_d = t_d.substring(1,2);
					}
					var date = new Date(t_y, (t_m*1-1), t_d);
					date.setDate(date.getDate()+1);
					var m = date.getMonth()+1;
					var year = date.getFullYear();
					var day = date.getDate();
					if(day < 10){
						day = "0"+day;
					}
					if(m < 10){
						m = "0"+m;
					}
					var end = year+"-"+m+"-"+day;
					var appendObj = {
							title: object[x]["unit_class_name"],
							start: start,
							end: end,
							id: object[x]["unit_code"],
							groupId: object[x]["class_code"]
					};
					appendArray.push(appendObj);
				}
				
				var calendar = new FullCalendar.Calendar(calendarEl, {
				      headerToolbar: {
				        left: 'prev,next today',
				        center: 'title',
				        right: 'dayGridMonth'
				      },
				      navLinks: false, // can click day/week names to navigate views
				      businessHours: true, // display business hours
				      editable: false,
				      selectable: true,
				      events: appendArray,
				      eventClick: function(info){
						  //캘린더 내의 수업 클릭 이벤트

				    	  var Obj2 = {
				    			  "unit_code": info.event.id,
				    			  "class_code": info.event.groupId,
				    			  "mode": "curriculum"
				    	  }
				    	  global_class_code = info.event.groupId;
				    	  $.ajax({
				    		  type:"POST",
				    		  url:"/teacher/progress/get_class_progress_management_work",
				    		  data:Obj2,
				    		  success:function(string){
				    			  var object = JSON.parse(string);
				    			  var class_list = object["class_list"];
				    			  var curriculum = object["curriculum"][0];

				    			  //그룹 체크
				    			  if(curriculum["unit_class_type"] == "1"){
					    			  class_object = object["class_list"];
					    			  group_object = object["curriculum"];
					    			  var nd = "";
					    			  for(x=0;x<object["curriculum"].length;x++){
					    				  $("#unit_group_name").empty();
					    				  nd += '<option class="unit_group_name_option">'+object["curriculum"][x]["unit_group_name"]+'</option>';
				    				  }
					    			  $("#unit_group_name").append(nd);
					    			  $("#group_content_box").removeClass("hidden_box");
				    			  }else{
				    				  $("#group_content_box").addClass("hidden_box");
				    			  }

				    			  //전역변수 셋팅
				    			  global_content_home_work = JSON.parse(curriculum["content_home_work"]);
				    			  global_content_test = JSON.parse(curriculum["content_test"]);
				    			  global_content_evaluation_type = JSON.parse(curriculum["content_evaluation_type"]);

				    			  //수업 관리 셋팅
				    			  if(curriculum != null){
									  first = true;
				    				  //받아온 커리큘럼정보를 수업관리 탭에 셋팅한다.
				    				  $("#unit_class_name").text(curriculum["unit_class_name"]);

				    				  $("#curriculum_result_popup_title").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반 "+curriculum["unit_class_name"]+" 차시별 결과");
				    				  
				    				  var start_date = curriculum["unit_start_date"];
				    				  global_start_date = start_date;
				    				  var end_date = curriculum["unit_end_date"];
				    				  global_end_date = end_date;
				    				  
				    				  if(curriculum["unit_class_type"] == "1"){
				    					  var allP = JSON.parse(curriculum["unit_group_id_list"]);
				    					  if(curriculum["content_participation"] != null){
				    						  var parP = JSON.parse(curriculum["content_participation"]);
				    						  $("#unit_class_curriculum_information").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반("+parP.length+"명/"+allP.length+"명) · "+start_date.substring(0,4)+"-"+start_date.substring(4,6)+"-"+start_date.substring(6,8)+" ~ "+end_date.substring(0,4)+"-"+end_date.substring(4,6)+"-"+end_date.substring(6,8));
			    						  }else{
			    							  $("#unit_class_curriculum_information").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반(0명/"+allP.length+"명) · "+start_date.substring(0,4)+"-"+start_date.substring(4,6)+"-"+start_date.substring(6,8)+" ~ "+end_date.substring(0,4)+"-"+end_date.substring(4,6)+"-"+end_date.substring(6,8));
		    							  }
			    					  }else{
			    						  if(curriculum["content_participation"] != null){
			    							  var parP = JSON.parse(curriculum["content_participation"]);
			    							  $("#unit_class_curriculum_information").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반("+parP.length+"명/"+class_list["class_people_max_count"]+"명) · "+start_date.substring(0,4)+"-"+start_date.substring(4,6)+"-"+start_date.substring(6,8)+" ~ "+end_date.substring(0,4)+"-"+end_date.substring(4,6)+"-"+end_date.substring(6,8));
		    							  }else{
		    								  $("#unit_class_curriculum_information").text(class_list["class_grade"]+"학년 "+class_list["class_group"]+"반(0명/"+class_list["class_people_max_count"]+"명) · "+start_date.substring(0,4)+"-"+start_date.substring(4,6)+"-"+start_date.substring(6,8)+" ~ "+end_date.substring(0,4)+"-"+end_date.substring(4,6)+"-"+end_date.substring(6,8));
	    								  }	
		    						  }
				    				  
				    				  $("#class_project_submit_type").empty();
				    				  var node = "<h4>과제 제출 방법</h4>";
				    				  if(class_list["class_project_submit_type"] != null){
				    					  var submit_type = JSON.parse(class_list["class_project_submit_type"]);
					    				  for(x=0;x<submit_type.length;x++){
					    					  node += "<p>"+submit_type[x]["type"]+" : "+submit_type[x]["link"]+"</p>";
					    				  }
				    				  }
				    				  $("#class_project_submit_type").append(node);
				    				  
				    				  $("#unit_class_text").text(curriculum["unit_class_text"]);
				    				  
				    				  $("#unit_attached_file").empty();
				    				  if(curriculum["unit_attached_file"] != null){
				    					  var attached_file = JSON.parse(curriculum["unit_attached_file"]);
				    					  var node = "";
				    					  for(x=0;x<attached_file.length;x++){
				    						  node += "<a href='"+attached_file[x]+"' download>"+attached_file[x].replace("/resources/class_file/","")+"</a>";
				    					  }
				    					  $("#unit_attached_file").append(node);
				    				  }
				    				  
				    				  $("#unit_youtube_url").empty();
				    				  if(curriculum["unit_youtube_url"] != null){
				    					  var unit_youtube_url = JSON.parse(curriculum["unit_youtube_url"]);
				    					  var node = "";
				    					  for(x=0;x<unit_youtube_url.length;x++){
				    						  node += "<a onclick='window.open(\""+unit_youtube_url[x]["link"]+"\")'>"+unit_youtube_url[x]["title"]+"</a>";
				    					  }
				    					  $("#unit_youtube_url").append(node);
				    				  }
				    				  
				    				  $("#unit_content_url").empty();
				    				  if(curriculum["unit_content_url"] != null){
				    					  var unit_content_url = JSON.parse(curriculum["unit_content_url"]);
				    					  var node = "";
				    					  for(x=0;x<unit_content_url.length;x++){
				    						  node += "<a onclick='window.open(\""+unit_content_url[x]["link"]+"\")'>"+unit_content_url[x]["title"]+"</a>";
				    					  }
				    					  $("#unit_content_url").append(node);
				    				  }
				    				  
				    				  $("#curriculum_management_box").removeClass("hidden_box");
				    				  if(!$("#curriculum_management_box").children('div').eq(0).hasClass("active")){
				    					  $("#curriculum_management_box").children('div').eq(0).addClass("active");
				    					  $("#curriculum_management_box").children('div').eq(1).css("display", "block");
				    				  }

				    				  //학생 관리 셋팅
				    				  if(curriculum["unit_class_type"] == "1"){
				    					  get_student_management(curriculum["class_code"],curriculum["unit_code"],1, JSON.parse(curriculum["unit_group_id_list"]));
			    					  }else{
			    						  get_student_management(curriculum["class_code"],curriculum["unit_code"],1, null);
		    						  }
				    				  
				    				  
					    			  
					    			  // "학급 공지 보내기" 버튼 클릭 이벤트
					    			  $("#send_push_btn").off().click(function(){
					    				  $("#push_title").val("");
					    				  $("#push_content").val("");
					    				  $("#push_popup").css("display","block");
				    				  });

				    				  // "수업 정보 수정" 버튼 클릭 이벤트
					    			  $("#modify_curriculum_btn").off().click(function(){
					    				  location.href="/teacher/ready/class_configuration_management_detail?class_code="+curriculum["class_code"];
					    			  });
					    			  
				    			  }else{

									  //해당 차시의 정보가 없는 경우 수업 관리, 학생 관리 탭 숨기기
				    				  if(!$("#curriculum_management_box").hasClass("hidden_box")){
				    					  $("#curriculum_management_box").addClass("hidden_box");
				    				  }
				    				  if(!$("#student_management_box").hasClass("hidden_box")){
				    					  $("#student_management_box").addClass("hidden_box");  
				    				  }
				    			  }			    			  
			    			  },
			    			  error:function(XMLHttpRequest, textStatus, errorThrown){
			    				  alert("서버에러입니다.\r다시 시도해주세요");
		    				  }
		    			  });
				      }
				    });

				    calendar.render();
				
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){
				alert("에러입니다.\r새로고침 해주세요");
			}
		});
	});
	
	var running = false;
	var before_page = null;

	//해당 차시에 참여중인 학생 목록 셋팅 함수
	function get_student_management(class_code, unit_code, page, number_list){
		if(!running){
			running = true;
			
			if(number_list != null){
				number_list = JSON.stringify(number_list);
			}
			
			Obj = {
					"number_list":number_list,
					"class_code":class_code,
					"unit_code":unit_code,
					"mode":"record_list",
					"page":page
			}
			
			 $.ajax({
	    		  type:"POST",
	    		  url:"/teacher/progress/get_class_progress_management_work",
	    		  data:Obj,
	    		  success:function(string){
	    			  if(string != null && string != "fail"){
	    				  var object = JSON.parse(string);
	    				  var record = object["record"];
	    				  if(record.length > 0){
	    					  before_page = page;
	    					  var node = "";
	    					  for(x=0;x<record.length;x++){
	    						  node +='<tr class="student_management_tr">';
	    						  node +='<td>'+record[x]["student_grade"]+'</td>';
	    						  node +='<td>'+record[x]["student_group"]+'</td>';
	    						  node +='<td>'+record[x]["student_number"]+'</td>';
	    						  node +='<td>'+record[x]["student_name"]+'</td>';
	    						  
	    						  if(record[x]["student_participation"] == "0"){
	    							  node +='<td class="alert-yellow">수업 준비중</td>';
	    						  }else{
	    							  if(record[x]["student_practice"] == "0" || record[x]["student_practice"] == "-"){
	    								  node +='<td class="alert-success">수업 중</td>';  
	    							  }else{
	    								  node +='<td class="alert-danger">수업 완료</td>';	  
	    							  }
	    						  }
	    						  
	    						  if(record[x]["student_phone"] != null && record[x]["student_phone"].length == 13){
	    							  node +='<td>'+record[x]["student_phone"]+'</td>';
	    						  }else{
	    							  node +='<td>-</td>';  
	    						  }
	    						  node +='<td><div class="edit-btn-wrap txt-left"><button class="bg2 class_confirm_btn" info=\''+JSON.stringify(record[x])+'\'>확인하기</button></div></td>';
	    						  if(record[x]["image_confirmation"] != null){
	    							  node +='<td><div class="edit-btn-wrap txt-left"><button class="bg student_confirm_btn" onclick="window.open(\''+record[x]["image_confirmation"]+'\')">확인하기</button></div></td></tr>';  
	    						  }else{
	    							  node +='<td></td></tr>';
	    						  }
	    					  }	
	    					  $(".student_management_tr").remove();
	    					  $("#student_management_table").append(node);
	    					  
	    					  // 학생 관리 -> 학생 목록 -> "수업 현황" 버튼 클릭 이벤트
	    					  $(".class_confirm_btn").off().click(function(){
	    						  var info = JSON.parse($(this).attr("info"));				    			  
				    			  var node = '';
				    			  var ev_count = 0;
			    				  var cp_count = 0;
				    			  for(x=0;x<global_content_home_work.length;x++){
				    				  node += '<tr class="student_one_class_status_popup_tr">';
				    				  node += '<td>'+info["student_grade"]+'</td>';
				    				  node += '<td>'+info["student_group"]+'</td>';
				    				  node += '<td>'+info["student_number"]+'</td>';
				    				  node += '<td>'+info["student_name"]+'</td>';
				    				  if(info["student_participation"] == "1"){
				    					  node += '<td>Y</td>';  
				    				  }else{
				    					  node += '<td>N</td>';
				    				  }
				    				  if(global_content_home_work[x] == "1"){
				    					  if(info["student_practice"] == "1"){
					    					  node += '<td>Y</td>';  
					    				  }else if(info["student_practice"] == "0"){
					    					  node += '<td>N</td>';
					    				  }else{
					    					  node += '<td>-</td>';
					    				  }
				    				  }else{
				    					  node += '<td>-</td>';
				    				  }
				    				  if(global_content_evaluation_type[x] == "1"){
				    					  if(info["evaluation_type_1"] == null){
				    						  node += '<td>평가전</td>';
				    					  }else{
				    						  var evaluation_type_1 = JSON.parse(info["evaluation_type_1"]);
				    						  if(evaluation_type_1[x] == "0" || evaluation_type_1[x] == "" || evaluation_type_1[x] == "-"){
				    							  node += '<td>평가전</td>';
				    						  }else if(evaluation_type_1[x] == "1"){
					    						  node += '<td>하</td>';
					    					  }else if(evaluation_type_1[x] == "2"){
					    						  node += '<td>중</td>';
					    					  }else if(evaluation_type_1[x] == "3"){
					    						  node += '<td>상</td>';
					    					  }else{
					    						  node += '<td>-</td>';  
					    					  }
				    					  }
				    					  node += '<td>-</td>';
				    					  node += '<td>-</td>';
				    				  }else if(global_content_evaluation_type[x] == "2"){
				    					  node += '<td>-</td>';
				    					  if(info["evaluation_type_2"] != null){
				    						  var evaluation_type_2 = JSON.parse(info["evaluation_type_2"]);
				    						  if(evaluation_type_2[x] != null && evaluation_type_2[x] != "-" && evaluation_type_2[x] != ""){
				    							  node += '<td>'+evaluation_type_2[x]+'점</td>';  
				    						  }else{
				    							  node += '<td>평가전</td>';  
				    						  }
				    					  }else{
				    						  node += '<td>평가전</td>';				    						  
				    					  }
				    					  node += '<td>-</td>';
				    				  }else if(global_content_evaluation_type[x] == "3"){
				    					  node += '<td>-</td>';
				    					  node += '<td>-</td>';
				    					  if(info["evaluation_type_3"] != null){
				    						  var evaluation_type_3 = JSON.parse(info["evaluation_type_3"]);
				    						  if(evaluation_type_3[x] != "-" && evaluation_type_3[x] != ""){
				    							  node += '<td>'+evaluation_type_3[x]+'</td>';  
				    						  }else{
				    							  node += '<td>평가전</td>';
				    						  }
				    					  }else{
				    						  node += '<td>평가전</td>';				    						  
				    					  }
				    				  }else{
				    					  node += '<td>-</td>';
				    					  node += '<td>-</td>';
				    					  node += '<td>-</td>';
				    				  }
				    				  
				    				  
				    				  if(global_content_test[x] == "1"){
				    					  if(info["evaluation_practice"] != null){
				    						  var temp_obj = JSON.parse(info["evaluation_practice"]);
					    					  if(temp_obj[ev_count] != null && temp_obj[ev_count].length > 0){
					    						  node += '<td><div class="edit-btn-wrap txt-left"><button class="bg2 student_record_view_btn_main" info=\''+JSON.stringify(temp_obj[ev_count])+'\'>확인하기</button></div></td>';
					    					  }else{
					    						  node += "<td>-</td>"  
					    					  }
					    					  ev_count ++;
				    					  }else{
					    					  node += "<td>-</td>"
					    				  }
				    				  }else{
				    					  if(info["class_practice"] != null){
				    						  var temp_obj = JSON.parse(info["class_practice"]);
				    						  if(temp_obj[cp_count] != null && temp_obj[cp_count].length > 0){
				    							  node += '<td><div class="edit-btn-wrap txt-left"><button class="bg2 student_record_view_btn_main" info=\''+JSON.stringify(temp_obj[cp_count])+'\'>확인하기</button></div></td>';
					    					  }else{
					    						  node += "<td>-</td>"  
					    					  }
				    						  cp_count ++;
				    					  }else{
					    					  node += "<td>-</td>"
					    				  }
				    				  }
				    			  }
				    			  
				    			  $(".student_one_class_status_popup_tr").remove();
				    			  $("#student_one_class_status_popup_table").append(node);
				    			  
				    			  /* // 학생 관리 -> 학생 목록 -> 수업 현황 팝업 -> 운동 기록 클릭 이벤트 */
			    				  $(".student_record_view_btn_main").off().click(function(){
			    					  var object = JSON.parse($(this).attr("info"));
			    					  var node = "";
			    					  $(".student_exercise_record_main_tr").remove();
			    					  for(x=0;x<object.length;x++){
			    						  node += '<tr class="student_exercise_record_main_tr">';
			    						  node += '<td>'+object[x]["content_title"]+'</td>';	//수업
			    						  node += '<td>'+object[x]["content_name"]+'</td>';	//종목
			    						  node += '<td>'+object[x]["content_category"]+'</td>';	//대분류
			    						  node += '<td>'+object[x]["content_detail_name"]+'</td>';	//동작명
			    						  node += '<td>'+object[x]["content_count"]+'개</td>';
			    						  node += '<td>'+object[x]["content_time"]+'초</td>';
			    						  node += '</tr>';
			    					  }
			    					  $("#student_exercise_record_popup_main_table").append(node);
			    					  $("#student_one_class_status_popup").css("display","none");
			    					  $("#student_exercise_record_main_popup").css("display","block");
			    				  });
			    				  
			    				  /*운동기록 확인팝업 off*/
			    				  $("#student_exercise_record_popup_main_close").off().click(function(){
			    					  $("#student_exercise_record_main_popup").css("display","none");
			    					  $("#student_one_class_status_popup").css("display","block");
			    				  });
				    			  
				    			  $("#student_one_class_status_popup").css("display", "block");
	    					  });
	    					  
	    					  
	    					  
	    					  /* 페이징 처리 */
	    					  $("#student_management_box_paging").children("button").remove();
	    					  $("#student_management_box_paging").children("ul").remove();
	    					  var paging_node = "";
	    					  if(page != "1"){
	    						  paging_node += "<button class='page-arrow go-first' onclick='get_student_management(\""+class_code+"\",\""+unit_code+"\",1,"+number_list+")'>처음으로</button>";
	    						  paging_node += "<button class='page-arrow go-prev' onclick='get_student_management(\""+class_code+"\",\""+unit_code+"\","+(page-1)+","+number_list+")'>이전</button>";
    						  }
		    				  paging_node += "<ul class='page-num'>";
		    				  for(x=object["pageing_start"];x<object["pageing_last"]*1+1;x++){
		    					  if(x == page){
		    						  paging_node += "<li class='active'>"+x+"</li>";
	    						  }else{
	    							  paging_node += "<li onclick='get_student_management(\""+class_code+"\",\""+unit_code+"\","+(x)+","+number_list+")'>"+x+"</li>";
    							  }
	    					  }
		    				  if(page != object["last_page"] && object["last_page"] != "0"){
		    					  paging_node += "<button class='page-arrow go-next' onclick='get_student_management(\""+class_code+"\",\""+unit_code+"\","+(page+1)+","+number_list+")'>다음</button>";
		    					  paging_node += "<button class='page-arrow go-last' onclick='get_student_management(\""+class_code+"\",\""+unit_code+"\","+object['last_page']+","+number_list+")'>끝으로</button>";
	    					  }
		    				  $("#student_management_box_paging").append(paging_node);	    				  
		    				  
		    				  $("#student_management_box").removeClass("hidden_box");
		    				  if(!$("#student_management_box").children('div').eq(0).hasClass("active")){
		    					  $("#student_management_box").children('div').eq(0).addClass("active");
		    					  $("#student_management_box").children('div').eq(1).css("display", "block");
		    				  }
		    				  
		    			  }else{
		    				  if(!$("#student_management_box").hasClass("hidden_box")){
		    					  $("#student_management_box").addClass("hidden_box");  
		    				  }
		    			  }
	    			  }else{
	    				  alert("학생관리 목록을 불러오는데 실패했습니다.\r다시 시도해주세요");
	    			  }

	    			  /* 차시별 수업 결과 팝업의 학생 목록 셋팅(1페이지) */
	    			  running = false;
	    			  if(first){
	    				  first = false;
	    				  if(number_list != null){
	    					  get_student_management_popup(class_code, unit_code, 1, JSON.parse(number_list));  
	    				  }else{
	    					  get_student_management_popup(class_code, unit_code, 1, null);
	    				  }
	    			  }
	    		  },
	    		  error:function(XMLHttpRequest, textStatus, errorThrown){
	    			  alert("학생관리 목록을 불러오는데 실패했습니다.\r다시 시도해주세요");
	    			  running = false;
				  }
			 });
		}
	}

	/* 수업 현황 팝업 닫기 버튼 클릭 이벤트 */
	$("#student_one_class_status_popup_close").off().click(function(){
		$("#student_one_class_status_popup").css("display", "none");
	});

	/* 차시별 수업 결과 팝업 닫기 버튼 클릭 이벤트 */
	$("#curriculum_result_popup_close").off().click(function(){
		$("#curriculum_result_popup").css("display", "none");
	});

	/* 차시별 수업 결과 확인하기 버튼 클릭 이벤트  */
	$("#open_curriculum_result_popup").click(function(){
		$("#curriculum_result_popup").css("display", "block");
	});

	/* 차시별 수업 결과 팝업의 학생 목록 셋팅 함수 */
	var saveRunning = false;
	function get_student_management_popup(class_code, unit_code, page, number_list){
		if(!running){
			running = true;
			
			if(number_list != null){
				number_list = JSON.stringify(number_list);
			}
			
			Obj = {
					"number_list":number_list,
					"class_code":class_code,
					"unit_code":unit_code,
					"mode":"record_list",
					"page":page
			}
			
			 $.ajax({
	    		  type:"POST",
	    		  url:"/teacher/progress/get_class_progress_management_work",
	    		  data:Obj,
	    		  success:function(string){
	    			  if(string != null && string != "fail"){
	    				  var object = JSON.parse(string);
	    				  var record = object["record"];
	    				  if(record.length > 0){
	    					  var node = "";
	    					  //학생 목록 셋팅
		    				  for(xx=0;xx<record.length;xx++){
		    					  
		    					  var eval_1_temp = record[xx]["evaluation_type_1"];
			    				  var eval_2_temp = record[xx]["evaluation_type_2"];
			    				  var eval_3_temp = record[xx]["evaluation_type_3"];
			    				  
			    				  var eval_1 = null;
			    				  var eval_2 = null;
			    				  var eval_3 = null;
			    				  
			    				  if(eval_1_temp != null){
			    					  eval_1 = JSON.parse(record[xx]["evaluation_type_1"]);
			    				  }
			    				  if(eval_2_temp != null){
			    					  eval_2 = JSON.parse(record[xx]["evaluation_type_2"]);
			    				  }
			    				  if(eval_3_temp != null){
			    					  eval_3 = JSON.parse(record[xx]["evaluation_type_3"]);
			    				  }
		    					  var ev_count = 0;
								  var cp_count = 0;
		    					  for(x=0;x<global_content_home_work.length;x++){
				    				  node += '<tr class="curriculum_result_popup_tr" student_id="'+record[xx]["student_id"]+'">';
				    				  node += '<td>'+record[xx]["student_grade"]+'</td>';
				    				  node += '<td>'+record[xx]["student_group"]+'</td>';
				    				  node += '<td>'+record[xx]["student_number"]+'</td>';
				    				  node += '<td>'+record[xx]["student_name"]+'</td>';
				    				  if(record[xx]["student_participation"] == "1"){
				    					  node += '<td>Y</td>';  
				    				  }else{
				    					  node += '<td>N</td>';
				    				  }
				    				  if(global_content_home_work[x] == "1"){
				    					  if(info["student_practice"] == "1"){
					    					  node += '<td>Y</td>';
					    				  }else if(info["student_practice"] == "0"){
					    					  node += '<td>N</td>';
					    				  }else{
					    					  node += '<td>-</td>';
					    				  }
				    				  }else{
				    					  node += '<td>-</td>';
				    				  }
				    				  
				    				  if(global_content_evaluation_type[x] == "1"){
				    					  if(eval_1 == null || eval_1[x] == "0" || eval_1[x] == "-"){
				    						  node += '<td><select class="curriculum_result_popup_evaluation1"><option>선택</option><option>상</option><option>중</option><option>하</option></select></td>';
				    					  }else if(eval_1[x] == "1"){
				    						  node += '<td><select class="curriculum_result_popup_evaluation1"><option>선택</option><option>상</option><option>중</option><option selected>하</option></select></td>';
				    					  }else if(eval_1[x] == "2"){
				    						  node += '<td><select class="curriculum_result_popup_evaluation1"><option>선택</option><option>상</option><option selected>중</option><option>하</option></select></td>';
				    					  }else if(eval_1[x] == "3"){
				    						  node += '<td><select class="curriculum_result_popup_evaluation1"><option>선택</option><option selected>상</option><option>중</option><option>하</option></select></td>';
				    					  }else{
				    						  node += '<td><select class="curriculum_result_popup_evaluation1"><option>선택</option><option>상</option><option>중</option><option>하</option></select></td>';  
				    					  }
				    					  node += '<td><input class="curriculum_result_popup_evaluation2 input-l" type="number" placeholder="-" value="-" disabled></td>';
				    					  node += '<td><input class="curriculum_result_popup_evaluation3 input-l" type="text" placeholder="-" value="-" disabled></td>';
				    				  }else if(global_content_evaluation_type[x] == "2"){				    					  
				    					  node += '<td><select class="curriculum_result_popup_evaluation1" disabled><option>-</option></select></td>';
				    					  if(eval_2 != null){
				    						  if(eval_2[x] != "-" && eval_2[x] != ""){
				    							  node += '<td><input class="curriculum_result_popup_evaluation2 input-l" type="number" placeholder="점수 평가를 적어주세요" value="'+eval_2[x]+'"></td>';  
				    						  }else{
				    							  node += '<td><input class="curriculum_result_popup_evaluation2 input-l" type="number" placeholder="점수 평가를 적어주세요"></td>'	;  
				    						  }
				    					  }else{
				    						  node += '<td><input class="curriculum_result_popup_evaluation2 input-l" type="number" placeholder="점수 평가를 적어주세요"></td>'	;			    						  
				    					  }
				    					  node += '<td><input class="curriculum_result_popup_evaluation3 input-l" type="text" placeholder="-" value="-" disabled></td>';
				    				  }else if(global_content_evaluation_type[x] == "3"){
				    					  node += '<td><select class="curriculum_result_popup_evaluation1" disabled><option>-</option></select></td>';
				    					  node += '<td><input class="curriculum_result_popup_evaluation2 input-l" type="number" placeholder="-" value="-" disabled></td>';
				    					  if(eval_3 != null){
				    						  if(eval_3[x] != "-" && eval_3[x] != ""){
				    							  node += '<td><input class="curriculum_result_popup_evaluation3 input-l" type="text" placeholder="평가를 적어주세요" value="'+eval_3[x]+'"></td>';  
				    						  }else{
				    							  node += '<td><input class="curriculum_result_popup_evaluation3 input-l" type="text" placeholder="평가를 적어주세요"></td>';  
				    						  }
				    					  }else{
				    						  node += '<td><input class="curriculum_result_popup_evaluation3 input-l" type="text" placeholder="평가를 적어주세요"></td>';		    						  
				    					  }
				    				  }else{
				    					  node += '<td><select class="curriculum_result_popup_evaluation1" disabled><option>-</option></select></td>';
				    					  node += '<td><input class="curriculum_result_popup_evaluation2 input-l" type="number" placeholder="-" value="-" disabled></td>';
				    					  node += '<td><input class="curriculum_result_popup_evaluation3 input-l" type="text" placeholder="-" value="-" disabled></td>';
				    				  }
				    				  
				    				  if(global_content_test[x] == "1"){
				    					  if(record[xx]["evaluation_practice"] != null){
				    						  var temp_obj = JSON.parse(record[xx]["evaluation_practice"]);
					    					  if(temp_obj[ev_count] != null && temp_obj[ev_count].length > 0){
					    						  node += '<td><div class="edit-btn-wrap txt-left"><button class="bg2 student_record_view_btn" info=\''+JSON.stringify(temp_obj[ev_count])+'\'>확인하기</button></div></td>';
					    					  }else{
					    						  node += "<td>-</td>"  
					    					  }
					    					  ev_count ++;
				    					  }else{
					    					  node += "<td>-</td>"
					    				  }
				    				  }else{
				    					  if(record[xx]["class_practice"] != null){
				    						  var temp_obj = JSON.parse(record[xx]["class_practice"]);
				    						  if(temp_obj[cp_count] != null && temp_obj[cp_count].length > 0){
				    							  node += '<td><div class="edit-btn-wrap txt-left"><button class="bg2 student_record_view_btn" info=\''+JSON.stringify(temp_obj[cp_count])+'\'>확인하기</button></div></td>';
					    					  }else{
					    						  node += "<td>-</td>"  
					    					  }
				    						  cp_count ++;
				    					  }else{
					    					  node += "<td>-</td>"
					    				  }
				    				  }
				    			  }
		    				  }
		    				  $(".curriculum_result_popup_tr").remove();
		    				  $("#curriculum_result_popup_table").append(node);
		    				  
		    				  /* 운동기록 확인 버튼 클릭 이벤트 */
		    				  $(".student_record_view_btn").off().click(function(){
		    					  var object = JSON.parse($(this).attr("info"));
		    					  console.log(object);
		    					  var node = "";
		    					  $(".student_exercise_record_tr").remove();
		    					  for(x=0;x<object.length;x++){
		    						  node += '<tr class="student_exercise_record_tr">';
		    						  node += '<td>'+object[x]["content_title"]+'</td>';	//수업
		    						  node += '<td>'+object[x]["content_name"]+'</td>';	//종목
		    						  node += '<td>'+object[x]["content_category"]+'</td>';	//대분류
		    						  node += '<td>'+object[x]["content_detail_name"]+'</td>';	//동작명
		    						  node += '<td>'+object[x]["content_count"]+'개</td>';
		    						  node += '<td>'+object[x]["content_time"]+'초</td>';
		    						  node += '</tr>';
		    					  }
		    					  $("#student_exercise_record_popup_table").append(node);
		    					  $("#curriculum_result_popup").css("display","none");
		    					  $("#student_exercise_record_popup").css("display","block");
		    				  });
		    				  
		    				  /*운동기록 확인팝업 닫기 버튼 클릭 이벤트*/
		    				  $("#student_exercise_record_popup_close").off().click(function(){
		    					  $("#student_exercise_record_popup").css("display","none");
		    					  $("#curriculum_result_popup").css("display","block");
		    				  });
		    				  
		    				  /* 차시별 수업 결과 확인 팝업 페이징 처리 */
		    				  $("#curriculum_result_popup_paging").children("button").remove();
	    					  $("#curriculum_result_popup_paging").children("ul").remove();
	    					  var paging_node = "";
	    					  if(page != "1"){
	    						  paging_node += "<button class='page-arrow go-first' onclick='get_student_management_popup(\""+class_code+"\",\""+unit_code+"\",1, "+number_list+")'>처음으로</button>";
	    						  paging_node += "<button class='page-arrow go-prev' onclick='get_student_management_popup(\""+class_code+"\",\""+unit_code+"\","+(page-1)+", "+number_list+")'>이전</button>";
    						  }
		    				  paging_node += "<ul class='page-num'>";
		    				  for(x=object["pageing_start"];x<object["pageing_last"]*1+1;x++){
		    					  if(x == page){
		    						  paging_node += "<li class='active'>"+x+"</li>"
	    						  }else{
	    							  paging_node += "<li onclick='get_student_management_popup(\""+class_code+"\",\""+unit_code+"\","+(x)+", "+number_list+")'>"+x+"</li>"
    							  }
	    					  }
		    				  if(page != object["last_page"] && object["last_page"] != "0"){
		    					  paging_node += "<button class='page-arrow go-next' onclick='get_student_management_popup(\""+class_code+"\",\""+unit_code+"\","+(page+1)+", "+number_list+")'>다음</button>";
		    					  paging_node += "<button class='page-arrow go-last' onclick='get_student_management_popup(\""+class_code+"\",\""+unit_code+"\","+object['last_page']+", "+number_list+")'>끝으로</button>";
	    					  }
		    				  $("#curriculum_result_popup_paging").append(paging_node);
		    				  $("#curriculum_result_popup_save").attr("class_code", class_code);
		    				  $("#curriculum_result_popup_save").attr("unit_code", unit_code);

		    				  /* 차시별 수업 결과 확인 팝업 "저장하기" 버튼 클릭 이벤트 */
		    				  $("#curriculum_result_popup_save").off().click(function(){
		    					  var cl_code = $(this).attr("class_code");
		    					  var un_code = $(this).attr("unit_code");
		    					  
		    					  var student_id = [];
		    					  var evaluation_type_1 = [];
		    					  var evaluation_type_2 = [];
		    					  var evaluation_type_3 = [];
		    					  
		    					  for(xx=0;xx<$(".curriculum_result_popup_tr").length;xx++){
		    						  student_id.push($(".curriculum_result_popup_tr").eq(xx).attr("student_id"));
		    						  var eval_1 = [];
		    						  var eval_2 = [];
		    						  var eval_3 = [];
		    						  for(x=0;x<global_content_home_work.length;x++){
		    							  var node = $(".curriculum_result_popup_evaluation1").eq(xx);
		    							  if($(node).val() == "선택"){
		    								  eval_1.push("-");
		    							  }else{
		    								  if($(node).val() == "상"){
		    									  eval_1.push("3");  
		    								  }else if($(node).val() == "중"){
		    									  eval_1.push("2");
		    								  }else if($(node).val() == "하"){
		    									  eval_1.push("1");
		    								  }else{
		    									  eval_1.push("-");
		    								  }
		    							  }
		    							  if($(".curriculum_result_popup_evaluation2").eq(xx).val().length != 0 && ($(".curriculum_result_popup_evaluation2").eq(xx).val() < 0 || $(".curriculum_result_popup_evaluation2").eq(xx).val() > 100)){
		    								  alert("점수평가를 0~100의 숫자로 입력해주세요");
		    								  return;
		    							  }
		    							  if($(".curriculum_result_popup_evaluation2").eq(xx).val().length == 0){
		    								  eval_2.push("-");
		    							  }else{
		    								  eval_2.push($(".curriculum_result_popup_evaluation2").eq(xx).val());  
		    							  }
		    							  if($(".curriculum_result_popup_evaluation3").eq(xx).val().length == 0){
		    								  eval_3.push("-");
		    							  }else{
		    								  eval_3.push($(".curriculum_result_popup_evaluation3").eq(xx).val());  
		    							  }
		    							  xx++;
		    						  }
		    						  xx--;
		    						  
		    						  evaluation_type_1.push(JSON.stringify(eval_1));
		    						  evaluation_type_2.push(JSON.stringify(eval_2));
		    						  evaluation_type_3.push(JSON.stringify(eval_3));
		    					  }
		    					  
		    					  var Object = {
		    							  "class_code":cl_code,
		    							  "unit_code":un_code,
		    							  "student_id":JSON.stringify(student_id),
		    							  "evaluation_type_1":JSON.stringify(evaluation_type_1),
		    							  "evaluation_type_2":JSON.stringify(evaluation_type_2),
		    							  "evaluation_type_3":JSON.stringify(evaluation_type_3)
		    					  }
		    					  if(!saveRunning){
		    						  saveRunning = true;
		    						  
		    						  $.ajax({
			    			    		  type:"POST",
			    			    		  url:"/teacher/progress/update_student_class_record",
			    			    		  data:Object,
			    			    		  success:function(string){
			    			    			  if(string == "success"){
			    			    				  //get_student_management(cl_code, un_code, before_page);
			    			    				  alert("저장했습니다.");
			    			    				  
			    			    			  }else{
			    			    				  alert("저장실패\r다시 시도해주세요");
			    			    			  }
			    			    			  saveRunning = false;
			    			    		  },
			    			    		  error:function(XMLHttpRequest, textStatus, errorThrown){
			    			    			  alert("저장실패\r다시 시도해주세요");
			    			    			  saveRunning = false;
			    						  }
			    					  });
		    					  }
		    				  });
	    				  }
	    			  }else{
	    				  alert("학생관리 목록을 불러오는데 실패했습니다.\r다시 시도해주세요");
	    			  }
	    			  running = false;
	    		  },
	    		  error:function(XMLHttpRequest, textStatus, errorThrown){
	    			  alert("학생관리 목록을 불러오는데 실패했습니다.\r다시 시도해주세요");
	    			  running = false;
				  }
			 });
		}
	}
	
	</script>
</html>

