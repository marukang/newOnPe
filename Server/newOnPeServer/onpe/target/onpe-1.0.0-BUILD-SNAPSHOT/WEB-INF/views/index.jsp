<!-- 메인화면(선생님, 관리자 통합) -->

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
			
			#popup_window{ border:1px #E6E6E6 solid; position:absolute; z-index:999; overflow:auto; border-radius:10px; background-color:white; padding:5px 10px; position:absolute; }
			#preview_name_box{ position:relative; float:left; width:100%; height:auto; }
			#preview_name{ width:100%; font-size:16px; font-weight:bold; text-align:center; float:left; overflow:normal; height:auto; line-height:30px; min-height:39px; }
			#preview_attachments{ width:100%; }
			#preview_content{ margin-top:5px; font-size:15px; text-align:center; }
			#preview_close{ position:absolute; right:0; }
		</style>
	</head>
	<body>
	
	<c:if test="${popup != null}">
	<div id="popup_window" style="width:${popup.popup_x_size}px; height:${popup.popup_y_size}px; left:${popup.popup_x_location}px; top:${popup.popup_y_location}px; display:block;">
		<div id="preview_name_box">
			<div id="preview_name">${popup.popup_name}</div>
			<button id="preview_close" class="close">x</button>
		</div>
		<div class="pop-cont">
			<div class="pop-cont-inner">
				<img id="preview_attachments" src="${popup.popup_attachments}"/>
				<div id="preview_content">
					${popup.popup_content}
				</div>
			
			</div>
		</div>
	</div>
	</c:if>

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
	
	<div id="message_popup" class="popup" style="display:none;">
		<div class="popup-cont small-pop">
			<div class="pop-title flex justify-space">
				<div class="left flex">
					<h2>메세지 보내기</h2>
				</div>
				<div class="right">
					<button id="popup_close" class="close">x</button>
				</div>
			</div>
			<div class="pop-cont">
				<div class="pop-cont-inner">
					
					<div class="form">
						<div class="field">
							<div class="field-inner">
								<label>메시지</label>
								<textarea id="message_text" class="popup_textarea" disabled="disabled"></textarea>
							</div>
						</div>
						<div class="field">
							<div class="field-inner">
								<label>답변</label>
								<textarea id="message_comment" class="popup_textarea" placeholder="답변을 달아주세요"></textarea>
							</div>
						</div>
					</div>
				
				</div>
				
				<div id="send_message_parent" class="btn-wrap">
					<button class="btn-pt" id="send_message">보내기</button>
				</div>
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
				</li>
				-->
				<li class="active"><span class="slide-tab">서비스</span>
					<ul class="depth2">
						<li><a href="/teacher/service/notice_list">공지사항</a></li>
						<li><a href="/teacher/service/faq_list">FAQ</a></li>
						<li><a href="/teacher/service/qna_list">1:1 문의</a></li>
					</ul>
				</li>
			</ul>
		</div>

		<div class="content">
			<div class="wrapper">
				<h2 class="sub-title">소식</h2>

				<div class="flex justify-space">
					<div class="box-wrap w29 profile">
						<div class="box-content profile-wrap">
							<div class="icon icon-person">
								<c:if test="${teacher_sex == 'm'}">
									<div class="profile-img"><img src="/asset/images/icon/man.png"></div>
								</c:if>
								<c:if test="${teacher_sex == 'f'}">
									<div class="profile-img"><img src="/asset/images/icon/woman.png"></div>
								</c:if>
								<p>${teacher_name}<span>${teacher_id}</span></p>
							</div>
							<ul class="profile-info">
								<li class="icon icon-envelope">${teacher_email}</li>
								<li class="icon icon-phone">${teacher_phone}</li>
								<li class="icon icon-map">${teacher_school}</li>       
							</ul>
						</div>
						<div class="btn-wrap flex">
							<button class="quick-line-squere" onclick="location.href='/mypage'">정보수정</button>
							<button class="quick-line-squere" onclick="location.href='/logout'">로그아웃</button>
						</div>
					</div>
					
					<div class="box-wrap w70 main-list main-box">
						<div class="box-content">
							<h3 id="index_class_box">오늘의 수업</h3>
							<a href="/teacher/progress/class_progress_management" class="show-more">더보기</a>
							<div id="today_curriculum_box" class="list-group"></div>
							<div id="today_curriculum_paging" class="paging">
							</div>
						</div>
					</div>
					
					<div class="box-wrap w100 main-box">
						<div class="box-content">
							<div class="flex justify-space">
								<c:if test="${message == 'y'}">
								<h3 id="index_message_box" class="mark-new">메세지</h3>
								</c:if>
								<c:if test="${message == 'n'}">
								<h3 id="index_message_box">메세지</h3>
								</c:if>
								<div class="search">
									<input type="search"  id="message_search"/>
								</div>
							</div>
							<div id="message_box" class="list-group message"></div>
							<div id="message_btn_box" class="edit-btn-wrap">
								<button id="popup_on">쪽지 보내기</button>
								<button id="delete_message">삭제하기</button>
							</div>
							<div id="message_paging" class="paging"></div>

						</div>
					</div>

					<div class="box-wrap w100 main-box">
						<div class="box-content">
							<div class="flex justify-space">
								<c:if test="${notice == 'y'}">
									<h3 id="index_notice_box" class="mark-new">공지사항</h3>
								</c:if>
								<c:if test="${notice == 'n'}">
									<h3 id="index_notice_box">공지사항</h3>
								</c:if>
								
								<div class="search">
									<input id="notice_search" type="search" />
								</div>
							</div>
							<div id="notice_box" class="list-group message"></div>
							
							<div id="notice_paging" class="paging"></div>

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
	var notice_keyword = "";
	var message_keyword = "";
	var message_object = null;
	var select_index = null;
	
	/* 팝업 닫기 버튼 클릭 이벤트 */
	$("#preview_close").click(function(){
		$("#popup_window").css("display","none");
	});
	
	/* 오늘의 수업, 메세지, 공지사항 데이터를 가져온다. */
	$(document).ready(function(){
		get_curriculum_list(1);
		get_message_list(1);
		get_notice_list(1);
	});
	
	/* 메세지 팝업 닫기 이벤트 */
	$("#popup_close").click(function(){
		$("#message_popup").css("display","none");
	});
	
	/* 메세지 팝업(클릭 대상 메세지 답장보내기 or 클릭 대상 메세지 확인하기) 생성 function */
	function message_popup_on(){
		var length = $("input:checkbox[name=message_checkbox]:checked").length;
		if(length < 1){
			alert("답장하실 쪽지를 선택해주세요");
			return;
		}else if(length > 1){
			alert("답장하실 쪽지를 하나만 선택해주세요");
			return;
		}else{
			var message_node = $("input:checkbox[name=message_checkbox]:checked").parent().parent().parent();
			var index = $("input:checkbox[name=message_checkbox]:checked").attr("index");
			select_index = index;
			$("#message_text").val(message_object[index]["message_text"]);
			if(message_object[index]["message_comment_state"] == "1"){
				$("#message_comment").val(message_object[index]["message_comment"]);
				$("#message_comment").attr("disabled",true);
				$("#send_message_parent").css("display","none");
			}else{
				$("#message_comment").val("");
				$("#message_comment").attr("disabled",false);
				$("#send_message_parent").css("display","block");
			}
			$("#message_popup").css("display","block");
		}
	}
	
	/* 쪽지 보내기 버튼 클릭 이벤트 */
	$("#popup_on").click(function(){
		$("#common_message_target_level").val("선택").prop("selected",true);
		$("#common_message_target_class").val("선택").prop("selected",true);
		$("#common_message_target_name").val("선택").prop("selected",true);
		$("#common_message_popup").css("display", "block");
	});
	
	/* 쪽지 보내기 팝업 닫기 이벤트 */
	$("#common_popup_close").click(function(){
		$("#common_message_popup").css("display", "none");
	});
	
	/* 쪽지 보내기 팝업 학년 셀렉트박스 변경 이벤트 */
	$("#common_message_target_level").change(function(){
		$("#common_message_target_name").val("선택").prop("selected",true);
		if($("#common_message_target_class").val() != "선택"){
			set_common_message_target();
		}
	});
	
	/* 쪽지 보내기 팝업 학급 셀렉트박스 변경 이벤트 */
	$("#common_message_target_class").change(function(){
		if($("#common_message_target_level").val() != "선택"){
			set_common_message_target();
		}
		$("#common_message_target_name").val("선택").prop("selected",true);
	});
	
	
	/* 
	 - 쪽지 보내기 팝업 이름(아이디) 셀렉트박스 셋팅 함수 
	 - 학년, 학급이 미리 선택되어 있어야 한다.
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
	
	/* 쪽지 보내기 팝업 "보내기" 버튼 클릭 이벤트 */
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
	
	
	/* 메세지 답장 "보내기" 버튼 클릭 이벤트 */
	$("#send_message").click(function(){
		var message_number = message_object[select_index]["message_number"];
		var message_comment_state = message_object[select_index]["message_comment_state"];
		if(message_number.length > 0 && message_comment_state == "0"){
			var message_comment = $("#message_comment").val();
			if(message_comment.length > 2 && message_comment.length < 500){
				
				data = {"mode":"create","message_number":message_number, "message_comment":message_comment};
				console.log(data);
				
				$.ajax({
				type:"POST",
				url:"/teacher/update_index_student_message",
				data:data,
				dataType:"text",
				success:function(string){
					if(string == "fail"){
						alert("메세지 전송에 실패했습니다.\r다시 시도해주세요");
					}else{
						get_message_list(1);
						$("#message_popup").css("display","none");
					}
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert("메세지 전송에 실패했습니다.\r다시 시도해주세요");
				}
			});
			
			}else{
				alert("메세지 답변은 2자이상 500자 이하로 적어주세요");
				return;
			}
		}else{
			return;
		}
	});
	
	/* 메세지 삭제하기 버튼 클릭 이벤트 */
	$("#delete_message").click(function(){
		var length = $("input:checkbox[name=message_checkbox]:checked").length;
		if(length < 1){
			alert("삭제하실 쪽지를 선택해주세요");
			return;
		}else{
			var message_node = $("input:checkbox[name=message_checkbox]:checked").parent().parent().parent();
			var message_number = [];
			for(x=0;x<length;x++){
				message_number.push(message_object[$("input:checkbox[name=message_checkbox]:checked").eq(x).attr("index")]["message_number"]);
			}
			if (confirm("정말 메세지를 삭제하시겠습니까?") == true){    //확인
				data = {"mode":"delete","message_number":JSON.stringify(message_number)};
				console.log(data);
				$.ajax({
					type:"POST",
					url:"/teacher/update_index_student_message",
					data:data,
					dataType:"text",
					success:function(string){
						if(string == "fail"){
							alert("메세지 삭제에 실패했습니다.\r다시 시도해주세요");
						}else{
							get_message_list(1);
						}
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert("메세지 삭제에 실패했습니다.\r다시 시도해주세요");
					}
				});
			}
		}
	});
	
	/* 메세지 검색필드 Enter 키다운 이벤트 */
	$("#message_search").keydown(function(key){
		if(key.keyCode == 13){
			if($(this).val().length != 0 && ( $(this).val().length < 2 || $(this).val().length > 50)){
				alert("메세지 검색은 2자 이상, 50자 이하로 입력해주세요");
				$("#message_search").focus();
				return;
			}else{
				message_keyword = $(this).val();
				get_message_list(1);
			}
		}
	});
	
	/* 메세지 목록 셋팅 함수 */
	function get_message_list(page){
		var data = { keyword:message_keyword, page:page };
		$.ajax({
			type:"POST",
			url:"/teacher/get_index_student_message",
			data:data,
			dataType:"text",
			success:function(string){
				if(string == null || string.length < 1){
					$("#message_box").children("div").remove();
					$("#message_paging").children("button").remove();
					$("#message_paging").children("ul").remove();
					$("#message_btn_box").addClass("display_hidden");
					return;
				}else{
					$("#message_btn_box").removeClass("display_hidden");
					var object = JSON.parse(string);
					var message = object["message"];
					message_object = object["message"];
					var message_node = "";
					$("#message_box").children("div").remove();
					for(x=0;x<message.length;x++){
						if(message[x]['message_comment_state'] == "0"){
							message_node += "<div class='list-group-item new-message message_item'>";
						}else{
							message_node += "<div class='list-group-item message_item'>";
						}
						message_node += "<div class='list-group-check'><label><input class='message_checkbox' index='"+x+"' type='checkbox' name='message_checkbox'><span class='custom-check'></span></label></div>";
						var date = message[x]['message_date'];
						message_node += "<div class='list-group-title'><h4>"+message[x]['message_title']+"<span class='date'>"+date.substring(0,4)+'-'+date.substring(4,6)+'-'+date.substring(6,8)+"</span></h4></div>";
						message_node += "<div class='list-group-writer'><p>"+message[x]['message_name']+"</p></div></div>";
					}
					$("#message_box").append(message_node);
					
					$("#message_paging").children("button").remove();
					$("#message_paging").children("ul").remove();
					
					$(".message_checkbox").off().change(function(){
						$(".message_checkbox").prop("checked", false);
						$(this).prop("checked", true);
					});
					
					$(".message_item").off().click(function(e){
						var className = e.target.className;
						if(className != "list-group-check" && className != "custom-check" && className != "message_checkbox"){
							$(".message_checkbox").prop("checked", false);
							$(".message_checkbox").eq($(this).index()).prop("checked", true);
							message_popup_on();
						}
					});
					
					var paging_node = "";
					if(page != "1"){
						paging_node += "<button class='page-arrow go-first' onclick='get_message_list(1)'>처음으로</button>";
						paging_node += "<button class='page-arrow go-prev' onclick='get_message_list("+(page-1)+")'>이전</button>";
					}
					paging_node += "<ul class='page-num'>";
					for(x=object["pageing_start"];x<object["pageing_last"]*1+1;x++){
						if(x == page){
							paging_node += "<li class='active'>"+x+"</li>"
						}else{
							paging_node += "<li onclick='get_message_list("+x+")'>"+x+"</li>"
						}
					}
					if(page != object["last_page"] && object["last_page"] != "0"){
						paging_node += "<button class='page-arrow go-next' onclick='get_message_list("+(page+1)+")'>다음</button>";
						paging_node += "<button class='page-arrow go-last' onclick='get_message_list("+object['last_page']+")'>끝으로</button>";
					}
					$("#message_paging").append(paging_node);
				}				
			},
			error:function(request,status,error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});	
	}
	
	/* 공지사항 검색필드 Enter 키다운 이벤트 */
	$("#notice_search").keydown(function(key){
		if(key.keyCode == 13){
			if($(this).val().length != 0 && ( $(this).val().length < 2 || $(this).val().length > 80)){
				alert("공지사항 검색은 2자 이상, 80자 이하로 입력해주세요");
				$("#notice_search").focus();
				return;
			}else{
				notice_keyword = $(this).val();
				get_notice_list(1);
			}
		}
	});
	
	/* 공지사항 목록 셋팅 함수 */
	function get_notice_list(page){
		var page = page;
		
		var data = { keyword:notice_keyword, page:page };
		$.ajax({
			type:"POST",
			url:"/teacher/get_index_admin_notice",
			data:data,
			dataType:"text",
			success:function(string){
				if(string == null || string.length < 1){
					$("#message_box").children("div").remove();
					$("#message_paging").children("button").remove();
					$("#message_paging").children("ul").remove();
					return;
				}else{
					var object = JSON.parse(string);
					var notice = object["notice"];
					var notice_node = "";
					$("#notice_box").children("div").remove();
					for(x=0;x<notice.length;x++){
						notice_node += "<div class='list-group-item' onclick='location.href=\"/teacher/service/notice_detail?admin_notice_number="+notice[x]['admin_notice_number']+"\"'>";
						notice_node += "<div class='list-group-num'>"+((page-1)*5+1+x)+"</div>";
						notice_node += "<div class='list-group-title'>";
						notice_node += "<h4>"+notice[x]['admin_notice_title']+"</h4></div>";
						var date = notice[x]['admin_notice_date'];
						notice_node += "<div class='list-group-writer'><span class='date'>"+date.substring(0,4)+'-'+date.substring(4,6)+'-'+date.substring(6,8)+"</span></div></div>";
					}
					$("#notice_box").append(notice_node);
					
					$("#notice_paging").children("button").remove();
					$("#notice_paging").children("ul").remove();
					var paging_node = "";
					if(page != "1"){
						paging_node += "<button class='page-arrow go-first' onclick='get_notice_list(1)'>처음으로</button>";
						paging_node += "<button class='page-arrow go-prev' onclick='get_notice_list("+(page-1)+")'>이전</button>";
					}
					paging_node += "<ul class='page-num'>";
					for(x=object["pageing_start"];x<object["pageing_last"]*1+1;x++){
						if(x == page){
							paging_node += "<li class='active'>"+x+"</li>"
						}else{
							paging_node += "<li onclick='get_notice_list("+x+")'>"+x+"</li>"
						}
					}
					if(page != object["last_page"] && object["last_page"] != "0"){
						paging_node += "<button class='page-arrow go-next' onclick='get_notice_list("+(page+1)+")'>다음</button>";
						paging_node += "<button class='page-arrow go-last' onclick='get_notice_list("+object['last_page']+")'>끝으로</button>";
					}
					$("#notice_paging").append(paging_node);
				}
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){
				alert(errorThrown);
			}
		});
	}
	
	/* 오늘의 수업 목록 셋팅 함수 */
	function get_curriculum_list(page){
		var page = page;
		
		var data = { page:page };
		$.ajax({
			type:"POST",
			url:"/teacher/get_index_curriculum",
			data:data,
			dataType:"text",
			success:function(string){
				if(string == null || string == "fail" || string.length < 1){
					$("#index_class_box").removeClass("mark-new");
					$("#today_curriculum_box").children("div").remove();
					$("#today_curriculum_paging").children("button").remove();
					$("#today_curriculum_paging").children("ul").remove();
						
				}else{
					var object = JSON.parse(string);
					var curriculum = object["curriculum"];
					if(curriculum.length > 0){
						if(!$("#index_class_box").hasClass("mark-new")){
							$("#index_class_box").addClass("mark-new");	
						}
					}
					var node = '';
					for(x=0;x<curriculum.length;x++){
						node += '<div class="list-group-item curriculum_node" onclick="location.href=\'/teacher/ready/class_configuration_management_detail?class_code='+curriculum[x]["class_code"]+'\'">';
						node += '<div class="list-group-title">';
						var start_date = curriculum[x]["unit_start_date"];
						var end_date = curriculum[x]["unit_end_date"];
						node += '<h4>'+curriculum[x]["unit_class_name"]+' <span class="date">'+start_date.substring(0, 4)+'-'+start_date.substring(4, 6)+'-'+start_date.substring(6, 8)+' ~ '+end_date.substring(0, 4)+'-'+end_date.substring(4, 6)+'-'+end_date.substring(6, 8)+'</span></h4></div></div>';
					}
					
					$(".curriculum_node").remove();
					$("#today_curriculum_box").append(node);
					
					
					
					$("#today_curriculum_paging").children("button").remove();
					$("#today_curriculum_paging").children("ul").remove();
					var paging_node = "";
					if(page != "1"){
						paging_node += "<button class='page-arrow go-first' onclick='get_curriculum_list(1)'>처음으로</button>";
						paging_node += "<button class='page-arrow go-prev' onclick='get_curriculum_list("+(page-1)+")'>이전</button>";
					}
					paging_node += "<ul class='page-num'>";
					for(x=object["pageing_start"];x<object["pageing_last"]*1+1;x++){
						if(x == page){
							paging_node += "<li class='active'>"+x+"</li>"
						}else{
							paging_node += "<li onclick='get_notice_list("+x+")'>"+x+"</li>"
						}
					}
					if(page != object["last_page"] && object["last_page"] != "0"){
						paging_node += "<button class='page-arrow go-next' onclick='get_curriculum_list("+(page+1)+")'>다음</button>";
						paging_node += "<button class='page-arrow go-last' onclick='get_curriculum_list("+object['last_page']+")'>끝으로</button>";
					}
					$("#today_curriculum_paging").append(paging_node);
				}
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){
				alert(errorThrown);
			}
		});
	}
	
	</script>
</html>
