<!-- 학생관리 목록 페이지 -->
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
	
	<div id="common_message_popup" class="popup" style="display:none;">
		<div class="popup-cont small-pop">
			<div class="pop-title flex justify-space">
				<div class="left flex">
					<h2>쪽지 보내기</h2>
				</div>
				<div class="right">
					<button id="common_popup_close" class="close">x</button>
				</div>
			</div>
			<div class="pop-cont">
				<div class="pop-cont-inner">
					
					<div class="form">
						<div class="field-inner w100">
							<label>학년</label>
							<select id="common_message_target_level">
								<option>선택</option>
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
							</select>
						</div>
						
						<div class="field-inner w100">
							<label>학급</label>
							<select id="common_message_target_class">
								<option>선택</option>
								<c:forTokens var="item" items="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20" delims=",">
									<option>${item}</option>
								</c:forTokens>
							</select>
						</div>
						
						<div class="field-inner w100">
							<label>이름(아이디)</label>
							<select id="common_message_target_name">
							<option>선택</option>
							</select>
						</div>
					
						<div class="field">
							<div class="field-inner">
								<label>내용</label>
								<textarea id="common_message_text" class="popup_textarea"></textarea>
							</div>
						</div>
					</div>
				
				</div>
				
				<div class="btn-wrap">
					<button class="btn-pt" id="send_common_message">보내기</button>
				</div>
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
							<li class="active"><a href="/teacher/ready/student_management">학생 관리</a></li>
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
						<li><a href="/teacher/progress/class_progress_management">실시간 수업 진행</a></li>
						<li><a href="/teacher/progress/class_board_list">학급별 게시판</a></li>
					</ul>
				</li>
				<li class="active"><span class="badge success">기타 메뉴</span>
					<ul class="depth2">
						<li><a href="/teacher/progress/overall_class_status">전체 수업 현황</a></li>
						<li class="active"><a href="/teacher/ready/student_management">학생 관리</a></li>
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
		
		<div id="student_management_school_modify_popup" class="popup" style="display:none">
			<div class="popup-cont small-pop">
				<div class="pop-title flex justify-space">
					<div class="left flex">
						<h2>학급구성관리</h2>
					</div>
					<div class="right">
						<button id="student_management_school_modify_popup_close" class="close">x</button>
					</div>
				</div>
				<div class="pop-cont">
					
					<div class="form">
						<div class="field">
							<div class="field-inner">
								<label>학교명</label>
								<input id="student_management_school_modify_popup_input" type="text" class="input-w-btn" placeholder="제목을 입력하세요.">
								<button id="school_list_popup_open_btn" class="btn-s-round">조회</button>
							</div>
							<div class="field-inner w100">
								<label>학년</label>
								<select id="school_list_popup_student_level_selectbox">
								<option>선택</option>
								<c:forTokens var="item" items="1,2,3,4,5,6" delims=",">
									<option>${item}</option>
								</c:forTokens>
								</select>
							</div>
							<div class="field-inner">
								<label>학급</label>
								<select id="school_list_popup_student_class_selectbox">
								<option>선택</option>
								<c:forTokens var="item" items="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20" delims=",">
									<option>${item}</option>
								</c:forTokens>
								</select>
							</div>
							<div class="field-inner">
								<label>학번</label>
								<select id="school_list_popup_student_number_selectbox">
								<option>선택</option>
								<c:forTokens var="item" items="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40" delims=",">
									<option>${item}</option>
								</c:forTokens>
								</select>
							</div>

						</div>
					</div>
	
					<div class="btn-wrap">
						<button id="modify_student_information_btn" class="btn-pt">수정하기</button>
					</div>
				</div>
			</div>
		</div>
		
		<div class="popup" id="search_school_popup" style="display:none;">
			<div class="popup-cont small-pop">
				<div class="pop-title flex justify-space">
					<div class="left flex">
						<h2>학교 검색</h2>
					</div>
					<div class="right">
						<button id="school_list_popup_close" class="close">x</button>
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

		<div class="content">
			<div class="wrapper">
				<h2 class="sub-title">학생 관리</h2>
				<div class="box-wrap">
					<div class="filter-wrap">
						<div class="filter-inner flex">
							<div class="field w32">
								<label>학년</label>
								<select id="student_level_selectbox">
									<option>전체</option>
									<c:forTokens var="item" items="1,2,3,4,5,6" delims=",">
										<c:if test="${item == student_level}">
											<option selected>${item}</option>
										</c:if>
										<c:if test="${item != student_level}">
											<option>${item}</option>
										</c:if>
									</c:forTokens>
								</select>
							</div>
							<div class="field w32">
								<label>학급</label>
								<select id="student_class_selectbox">
									<option>전체</option>
									<c:forTokens var="item" items="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20" delims=",">
										<c:if test="${item == student_class}">
											<option selected>${item}</option>
										</c:if>
										<c:if test="${item != student_class}">
											<option>${item}</option>
										</c:if>
									</c:forTokens>
								</select>
							</div>
							<div class="field w100">
								<label>검색 구분</label>
								<select id="student_search_option_selectbox">
									<option>전체</option>
									<c:if test="${option == null}">
										<option>이름</option>
										<option>아이디</option>
									</c:if>
									<c:if test="${option != null and option == '이름'}">
										<option selected>이름</option>
										<option>아이디</option>
									</c:if>
									<c:if test="${option != null and option == '아이디'}">
										<option>이름</option>
										<option selected>아이디</option>
									</c:if>
								</select>
								<input type="text" class="search-input ml10" id="student_search_keyword_input" value="${keyword}" />
							</div>
						</div>

						<div class="btn-wrap">
							<button class="btn-pt" id="student_search_btn">조회</button>
						</div>
							
					</div>
					<div class="box-content">
						<div class="overflow">
							<table class="basic medium">
								<tr>
									<th></th>
									<th>학년</th>
									<th>학급</th>
									<th>학번</th>
									<th>이름</th>
									<th>아이디</th>
									<th>연락처</th>
									<th>가입일</th>
								</tr>
								
								<c:forEach items="${student_list}" var="student_list">
									<tr>
										<td><label><input name="student_information_checkbox" type="checkbox" class="student_information_checkbox" 
										student_school="${student_list.student_school}" 
										student_level="${student_list.student_level}" 
										student_class="${student_list.student_class}" 
										student_number="${student_list.student_number}"
										student_id="${student_list.student_id}"
										><span class="custom-check"></span></label></td>
										<c:if test="${student_list.student_level == null}">
											<td>-</td>
										</c:if>
										<c:if test="${student_list.student_level != null}">
											<td>${student_list.student_level}</td>
										</c:if>
										
										<c:if test="${student_list.student_class == null}">
											<td>-</td>
										</c:if>
										<c:if test="${student_list.student_class != null}">
											<td>${student_list.student_class}</td>
										</c:if>
										
										<c:if test="${student_list.student_number == null}">
											<td>-</td>
										</c:if>
										<c:if test="${student_list.student_number != null}">
											<td>${student_list.student_number}</td>
										</c:if>
										
										<td>${student_list.student_name}</td>
										<td class="student_information_id">${student_list.student_id}</td>
										<c:if test="${student_list.student_phone == null}">
											<td>-</td>
										</c:if>
										<c:if test="${student_list.student_phone != null}">
											<td>${student_list.student_phone}</td>
										</c:if>
										<td>${fn:substring(student_list.student_create_date,0,4)}-${fn:substring(student_list.student_create_date,4,6)}-${fn:substring(student_list.student_create_date,6,8)}</td>
									</tr>
								</c:forEach>
							</table>
						</div>
						
						<div class="flex justify-space mt10">
							<div class="edit-btn-wrap mb10">
								
							</div>
							<div class="edit-btn-wrap">
								<button class="bg" id="sned_common_message_btn">쪽지 보내기</button>
								<button class="bg" id="student_modify_btn">학교/학급 수정</button>
								<button class="bg" onclick="location.href='/teacher/ready/student_management_sign_up'">신규 등록</button>
								<button class="bg" id="student_delete_btn">회원 탈퇴</button>
							</div>
						</div>
						
						
						<div class="paging mt10">
							<c:if test="${page ne '1'}">
								<button class="page-arrow go-first" onclick="location.href='${pageing_url}&page=1'">처음으로</button>
								<button class="page-arrow go-prev" onclick="location.href='${pageing_url}&page=${page-1}'">이전</button>
							</c:if>
							<ul class="page-num">
								<c:forEach var="index" begin="${pageing_start}" end="${pageing_last}">
									<c:if test="${page eq index}">
										<li class="active">${index}</li>
									</c:if>
									<c:if test="${page ne index}">
										<li onclick="location.href='${pageing_url}&page=${index}'">${index}</li>
									</c:if>
								</c:forEach>
							</ul>
							<c:if test="${page ne last_page and last_page != '0'}">
								<button class="page-arrow go-next" onclick="location.href='${pageing_url}&page=${page+1}'">다음</button>
								<button class="page-arrow go-last" onclick="location.href='${pageing_url}&page=${last_page}'">끝으로</button>
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
	
	/* 
	 - 페이지 접근시 보유 클래스가 없는경우 안내창 생성
	 - 보유클래스가 존재해야 클래스에 참여중인 학생들 목록을 불러올 수 있다.
	*/
	if("${c_code}" == "n"){
		alert("개설한 수업이 없습니다.");
	}
	
	var student_id = null;	//쪽지 보내기 대상(학생) 아이디 저장
	
	/* 
	 - "쪽지 보내기" 버튼 클릭 이벤트
	 - 쪽지 보내기 팝업 셋팅 + 생성
	*/
	$("#sned_common_message_btn").click(function(){
		$("#common_message_target_level").val("선택").prop("selected",true);
		$("#common_message_target_class").val("선택").prop("selected",true);
		$("#common_message_target_name").val("선택").prop("selected",true);
		$("#common_message_popup").css("display", "block");
	});
	
	/* 
	 - 쪽지 보내기 팝업 - 닫기(X) 버튼 클릭 이벤트
	*/
	$("#common_popup_close").click(function(){
		$("#common_message_popup").css("display", "none");
	});
	
	/* 
	 - 쪽지 보내기 팝업 - 학년 선택(변경) 이벤트
	 - 만약 학년, 학급이 다 선택되어 있다면 선택한 학년과 학급에 해당하는 보유 학생들 목록을 이름(아이디) 필드의 셀렉트박스에 셋팅한다.  
	*/
	$("#common_message_target_level").change(function(){
		$("#common_message_target_name").val("선택").prop("selected",true);
		if($("#common_message_target_class").val() != "선택"){
			set_common_message_target();
		}
	});
	
	/* 
	 - 쪽지 보내기 팝업 - 학급 선택(변경) 이벤트
	 - 만약 학년, 학급이 다 선택되어 있다면 선택한 학년과 학급에 해당하는 보유 학생들 목록을 이름(아이디) 필드의 셀렉트박스에 셋팅한다.  
	*/
	$("#common_message_target_class").change(function(){
		if($("#common_message_target_level").val() != "선택"){
			set_common_message_target();
		}
		$("#common_message_target_name").val("선택").prop("selected",true);
	});
	
	/* 
	 - 쪽지 보내기 팝업 - 보유 학생들 목록 셋팅 함수  
	*/
	var issetrunning = false;
	function set_common_message_target(){
		if(!issetrunning){
			issetrunning = true;
			$.ajax({
				type:"POST",
				url:"/teacher/get_index_student_information",
				data:{"student_level":$("#common_message_target_level").val(), "student_class":$("#common_message_target_class").val()},
				dataType:"text",
				success:function(string){
					$("#common_message_target_name").empty();
					$("#common_message_target_name").append("<option>선택</option>");
					var object = JSON.parse(string);
					for(x=0;x<object.length;x++){
						$("#common_message_target_name").append("<option student_id='"+object[x]["student_id"]+"'>"+object[x]["student_name"]+"("+object[x]["student_id"]+")</option>");	
					}
					issetrunning = false;
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					issetrunning = false;
				}
			});
		}
	}
	
	/* 
	 - 쪽지 보내기 팝업 - "보내기" 버튼 클릭 이벤트
	 - 대상 학생에게 쪽지 전송
	*/
	$("#send_common_message").click(function(){
		if(!issetrunning){
			issetrunning = true;
			
			var message_content = $("#common_message_text").val();
			var target_id = $("#common_message_target_name option:selected").attr("student_id");
			if(message_content.length < 2 || message_content.length > 500){
				alert("메세지를 2 ~ 500자로 입력해 주세요.");
				return;
			}
			if(target_id == null || target_id.length == 0){
				alert("메세지를 전송할 학생을 선택해주세요.");
				return;
			}
			
			$.ajax({
				type:"POST",
				url:"/teacher/set_common_message",
				data:{"target_id":target_id, "message_content":message_content},
				dataType:"text",
				success:function(string){
					if(string == "fail"){
						alert("쪽지 전송에 실패했습니다.\r다시 시도해주세요");
					}else if(string == "success"){
						alert("쪽지를 전송했습니다.");
						$("#common_message_popup").css("display", "none");
					}
					issetrunning = false;
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					issetrunning = false;
				}
			});
		}
	});
	
	/* 
	 - "회원 탈퇴" 버튼 클릭 이벤트
	 - 해당 학생을 회원 탈퇴처리 한다.
	*/
	$("#student_delete_btn").click(function(){
		var obj = $("input:checkbox[name=student_information_checkbox]:checked");
		if(obj.length == 1){
			if (confirm("정말 해당학생을 탈퇴 시키시겠습니까?") == true){
				var Obj = {
						"student_id":student_id,
						"mode":"delete"
				}
				
				$.ajax({
					type:"POST",
					url:"/teacher/ready/student_management_work",
					data:Obj,
					success:function(string){
						if(string != null){
							alert("해당 학생을 탈퇴시켰습니다.");
							history.go(0);
						}else{
							alert("서버가 불안정합니다.\r잠시후 다시 시도해주세요");						
						}
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert("서버가 불안정합니다.\r잠시후 다시 시도해주세요");
					}
				});
			}	
		}else{
			alert("학생을 선택해주세요");
		}
	});
	
	/*
	 - 학급 구성 관리 팝업 - "수정하기" 버튼 클릭 이벤트
	 - 해당 학생의 학급 구성을 수정한다(학교명, 학년, 학급, 학번)
	*/
	$("#modify_student_information_btn").click(function(){
		var student_school = $("#student_management_school_modify_popup_input").val();
		var student_level = $("#school_list_popup_student_level_selectbox option:selected").val();
		var student_class = $("#school_list_popup_student_class_selectbox option:selected").val();
		var student_number = $("#school_list_popup_student_number_selectbox option:selected").val();
		
		if(student_id.length < 2){
			alert("학생 정보변경에 실패했습니다.");
		}else if(student_level.length == 0 || student_class.length == 0 || student_number.length == 0){
			alert("학생 정보변경에 실패했습니다.");
		}else if(student_school.length < 2 || student_school > 30){
			alert("학교명은 2자이상 30자 이하로 작성해주세요");
		}else if(student_level == "선택"){
			alert("학생 학년을 선택해주세요");
		}else if(student_class == "선택"){
			alert("학생 학급을 선택해주세요");
		}else if(student_number == "선택"){
			alert("학생 학번을 선택해주세요");
		}else{
			var Obj = {
					"student_id":student_id,
					"student_school":student_school,
					"student_level":student_level,
					"student_class":student_class,
					"student_number":student_number,
					"mode":"modify"
			}
			
			$.ajax({
				type:"POST",
				url:"/teacher/ready/student_management_work",
				data:Obj,
				success:function(string){
					if(string != null){
						alert("학생 정보를 수정했습니다.");
						history.go(0);
					}else{
						alert("서버가 불안정합니다.\r잠시후 다시 시도해주세요");						
					}
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert("서버가 불안정합니다.\r잠시후 다시 시도해주세요");
				}
			});
		}
	});
	
	/*
	 - 학급 구성 관리 팝업 - 닫기 버튼(X) 클릭 이벤트
	*/
	$("#student_management_school_modify_popup_close").click(function(){
		$("#student_management_school_modify_popup").css("display","none");
	});
	
	/*
	 - "학교/학급 수정" 버튼 클릭 이벤트
	 - 해당 학생에 대한 학급정보를 셋팅한 뒤 학급 구성 관리 팝업을 생성한다.
	*/
	$("#student_modify_btn").click(function(){
		//선택한 학생 정보를 팝업창에 셋팅
		var obj = $("input:checkbox[name=student_information_checkbox]:checked");
		if(obj.length == 1){
			var student_school = obj.attr("student_school");
			var student_level = obj.attr("student_level");
			var student_class = obj.attr("student_class");
			var student_number = obj.attr("student_number");
			
			$("#student_management_school_modify_popup_input").val(student_school);
			if(student_level != null && student_level.length > 0){
				$("#school_list_popup_student_level_selectbox").val(student_level).prop("selected",true);
			}else{
				$("#school_list_popup_student_level_selectbox").val("선택").prop("selected",true);
			}
			if(student_class != null && student_class.length > 0){
				$("#school_list_popup_student_class_selectbox").val(student_class).prop("selected",true);
			}else{
				$("#school_list_popup_student_class_selectbox").val("선택").prop("selected",true);
			}
			if(student_number != null && student_number.length > 0){
				$("#school_list_popup_student_number_selectbox").val(student_number).prop("selected",true);
			}else{
				$("#school_list_popup_student_number_selectbox").val("선택").prop("selected",true);
			}
			
			$("#student_management_school_modify_popup").css("display", "block");	
		}else{
			alert("학생을 선택해주세요");
		}
	});
	
	/*
	 - 학급 구성 관리 팝업 - 학교명 필드 "조회" 버튼 클릭 이벤트
	 - 학교 검색 팝업이 생성된다.
	*/
	$("#school_list_popup_open_btn").click(function(){
		$("#school_list_parent").children('li').remove();
		$("#search_school_input").val("");
		$("#student_management_school_modify_popup").css("display","none");
		$("#search_school_popup").css("display","block");
	});
	
	/*
	 - 학교 검색 팝업 - 닫기 버튼(X) 클릭 이벤트
	*/
	$("#school_list_popup_close").click(function(){
		$("#search_school_popup").css("display","none");
		$("#student_management_school_modify_popup").css("display","block");
	});
	
	
	/* 
	 - 학교 검색 팝업 - 학교명 입력필드 키다운 이벤트
	 - 학교명 입력필드에 입력된 값을 대상으로 학교 목록을 구성하여 보여준다.
	*/
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
	
	/* 
	 - 학교 검색 팝업 - "조회" 버튼 클릭 이벤트
	 - 학교명 입력필드에 입력된 값을 대상으로 학교 목록을 구성하여 보여준다.
	*/
	$("#search_school_btn").click(function(){
		var school_input_val = $("#search_school_input").val();
		if(school_input_val.length > 1 && school_input_val.length < 30){
			search_school(school_input_val);
		}else{
			alert("학교명을 2자이상 30자 이하로 입력해주세요");
		}
	});
	
	/*
	- 학교 검색 팝업 - 조회된 학교목록 - 학교 클릭 이벤트
	- 중복선택할 수 없음
	*/
	$(".student_information_checkbox").change(function(){
		$(".student_information_checkbox").prop("checked",false);
    	$(this).prop("checked", true);
    	student_id = $(this).attr("student_id");
	});
	
	/*
	- 상단 "조회" 버튼 클릭 이벤트
	- 상단 학년, 학급, 검색구분, 검색값에 해당하는 학생들 목록을 보여준다.
	*/
	$("#student_search_btn").click(function(){
		var student_level = $("#student_level_selectbox option:selected").val();
		var student_class = $("#student_class_selectbox option:selected").val();
		var option = $("#student_search_option_selectbox option:selected").val();
		var keyword = $("#student_search_keyword_input").val();
		if(keyword.length != 0 && (keyword.length < 2 || keyword.length > 20)){
			alert("검색어는 2자 이상 20자 이하로 입력해 주세요");
		}else{
			var url = "/teacher/ready/student_management?ck=1";
			url += "&student_level="+student_level;
			url += "&student_class="+student_class;
			url += "&option="+option;
			url += "&keyword="+keyword;
			location.href=url;
		}
	});
	
	$("#school_choose").off().click(function(){
		if($(".active_student_school").size() == 1){
			//모달 끄고 선택 된 학교를 밖의 학교 input에 넣는다.
			$("#student_management_school_modify_popup_input").val($(".active_student_school").text());
			$("#search_school_popup").css("display","none");
			$("#student_management_school_modify_popup").css("display","block");
			
		}else{
			alert("학교목록에서 학교를 선택해 주세요");
			return;
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
						$(".school_node").off().click(function(){
							$(".school_node").removeClass('active');
							$(".school_node").removeClass('active_student_school');
							$(this).addClass('active');
							$(this).addClass('active_student_school');
						});
						
						$("#school_choose").off().click(function(){
							if($(".active_student_school").size() == 1){
								//모달 끄고 선택 된 학교를 밖의 학교 input에 넣는다.
								$("#student_management_school_modify_popup_input").val($(".active_student_school").text());
								$("#search_school_popup").css("display","none");
								$("#student_management_school_modify_popup").css("display","block");
								
							}else{
								alert("학교목록에서 학교를 선택해 주세요");
								return;
							}
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
	</script>
</html>


