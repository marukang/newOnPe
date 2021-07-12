<!-- 팝업창 관리 등록, 수정 페이지 -->

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
		<script src="https://code.jquery.com/jquery-3.4.1.js" integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU=" crossorigin="anonymous"></script>
		<script src="/asset/lib/jquery-ui.js"></script>
		<script src="/asset/lib/swiper-bundle.min.js"></script>
		<script src="/asset/js/script.js"></script>
		<base href="/" /> 
		<style>
			textarea { resize: none; }
			#upload_file_name{ width:250px;height:40px; margin-left:15px; line-height:40px; overflow:hidden; text-overflow: ellipsis; white-space: nowrap; float:left; }
			.btn-upload{float:left;}
			#popup_window{ overflow:auto; border-radius:10px; background-color:white; padding:5px 10px; position:absolute; }
			#preview_name_box{ position:relative; float:left; width:100%; height:auto; }
			#preview_name{ width:100%; font-size:16px; font-weight:bold; text-align:center; float:left; overflow:normal; height:auto; line-height:30px; min-height:39px; }
			#preview_attachments{ width:100%; }
			#preview_content{ margin-top:5px; font-size:15px; text-align:center; }
			#preview_close{ position:absolute; right:0; }
		</style>
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
							<li><a href="/admin/member/app_member_management_list">회원관리(App)</a></li>
							<li><a href="/admin/exercise/exercise_management_list">종목 관리</a></li>
							<li class="active"><a href="/admin/popup/popup_management_list">팝업창 관리</a></li>
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

		<div class="lnb">
			<ul class="depth1">
				<li class="active"><span class="slide-tab">관리자 메뉴</span>
					<ul class="depth2">
						<li><a href="/admin/member/lms_member_management_list">회원관리(LMS)</a></li>
						<li><a href="/admin/member/app_member_management_list">회원관리(App)</a></li>
						<li><a href="/admin/exercise/exercise_management_list">종목 관리</a></li>
						<li class="active"><a href="/admin/popup/popup_management_list">팝업창 관리</a></li>
						<li><a href="/admin/push/push_management_list">PUSH 관리</a></li>
						<li><a href="/admin/etc/notice_list">공지사항 관리</a></li>
						<li><a href="/admin/etc/faq_list">FAQ 관리</a></li>
						<li><a href="/admin/etc/qna_list">1:1문의 관리</a></li>
					</ul>
				</li>
			</ul>
		</div>
		
		<div id="preview_popup" class="popup" style="display:none;">
			<div id="popup_window" style="width:300px; height:500px; left:100px; top:100px;">
				<div id="preview_name_box">
					<div id="preview_name"></div>
					<button id="preview_close" class="close">x</button>
				</div>
				<div class="pop-cont">
					<div class="pop-cont-inner">
						<img id="preview_attachments" src="${popup.popup_attachments}"/>
						<div id="preview_content">
							내용
						</div>
					
					</div>
				</div>
			</div>
		</div>

		<div class="content">
			<div class="wrapper">
				<h2 class="sub-title">관리자 메뉴 - 팝업창 관리</h2>

				<div class="box-wrap">
					
					<div class="box-content">
						<div class="form auto-w">
							<div class="field w69">
								<div class="field-inner">
									<label>제목</label>
									<input id="popup_name" type="text" class="w100" placeholder="팝업제목을 입력해주세요" value="${popup.popup_name}" autocomplete="off">
								</div>
							</div>
							<div class="field w24">
								<div class="field-inner">
									<label>등록자명</label>
									<input type="text" value="관리자" disabled="disabled" autocomplete="off">
								</div>
							</div>
							<div class="field">
								<div class="field-inner">
									<label>팝업 가로크기</label>
									<input id="popup_x_size" type="text" class="input-small" placeholder="" value="${popup.popup_x_size}" autocomplete="off">px
								</div>
							</div>
							<div class="field">
								<div class="field-inner">
									<label>팝업 세로크기</label>
									<input id="popup_y_size" type="text" class="input-small" placeholder="" value="${popup.popup_y_size}" autocomplete="off">px
								</div>
							</div>
							<div class="field">
								<div class="field-inner">
									<label>팝업 위치 TOP</label>
									<input id="popup_y_location" type="text" class="input-small" placeholder="" value="${popup.popup_y_location}" autocomplete="off">px
								</div>
							</div>
							<div class="field">
								<div class="field-inner">
									<label>팝업 위치 LEFT</label>
									<input id="popup_x_location" type="text" class="input-small" placeholder="" value="${popup.popup_x_location}" autocomplete="off">px
								</div>
							</div>
							
							<div class="field w100">
								<div class="field">
									<label>게시기간</label>
									<div class="date-range">
										<c:if test="${mode == 'modify'}">
											<input type="text" id="from" name="from" value="${fn:substring(popup.popup_start_date,4,6)}/${fn:substring(popup.popup_start_date,6,8)}/${fn:substring(popup.popup_start_date,0,4)}" autocomplete="off">
											<span class="datemark">~</span>
											<input type="text" id="to" name="to" value="${fn:substring(popup.popup_end_date,4,6)}/${fn:substring(popup.popup_end_date,6,8)}/${fn:substring(popup.popup_end_date,0,4)}" autocomplete="off">
										</c:if>
										<c:if test="${mode == 'create'}">
											<input type="text" id="from" name="from" autocomplete="off">
											<span class="datemark">~</span>
											<input type="text" id="to" name="to" autocomplete="off">
										</c:if>
									</div>
									
								</div>
							</div>
							<div class="field w69">
								<div class="field-inner">
									<label>첨부파일</label>
									<label class="btn-upload">
										<input id="popup_attachments" type="file">
										<c:if test="${mode == 'modify'}">
											변경하기
										</c:if>
										<c:if test="${mode == 'create'}">
											등록하기
										</c:if>
									</label>
									<div id="upload_file_name">${fn:replace(popup.popup_attachments, '/resources/popup/', '')}</div>
								</div>
							</div>
							
							<div class="field w24">
								<div class="field-inner">
									<label>사용여부</label>
									<div class="checks flex">
										<label><input id="popup_use1" type="checkbox" onclick="popup_use_check('1')" /><span class="custom-check"></span>사용</label>
										<label><input id="popup_use2" type="checkbox" onclick="popup_use_check('0')" /><span class="custom-check"></span>미사용</label>
									</div>
								</div>
							</div>
							
							<div class="field w100">
								<textarea id="popup_content" placeholder="팝업 내용을 입력해주세요" autocomplete="off">${popup.popup_content}</textarea>
							</div>
						</div>
						<div class="btn-wrap">
							<c:if test="${mode == 'modify'}">
								<button class="btn-pt" id="modify_btn">수정하기</button>
							</c:if>
							<c:if test="${mode == 'create'}">
								<button class="btn-pt" id="create_btn">게시하기</button>
							</c:if>
							<button class="btn-sec mr10" id="preview_btn">미리보기</button>
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
		var mode = "${mode}";
		var popup_u_before = "${popup.popup_use}";
		var image = "${popup.popup_attachments}";
		
		/*
		모드에 따라서 사용여부를 다르게 셋팅
		 - 수정 모드일때는 지정된 사용여부로 셋팅
		*/
		if(mode == "create"){
			$("input:checkbox[id='popup_use1']").prop("checked",true)
		}else if(mode == "modify"){
			if(popup_u_before == "1"){
				$("input:checkbox[id='popup_use1']").prop("checked",true)
			}else if(popup_u_before == "0"){
				$("input:checkbox[id='popup_use2']").prop("checked",true)
			}
		}
		
		$("#preview_btn").click(function(){
			
			var popup_name = $("#popup_name").val();
			var popup_x_size = $("#popup_x_size").val();
			var popup_y_size = $("#popup_y_size").val();
			var popup_y_location = $("#popup_y_location").val();
			var popup_x_location = $("#popup_x_location").val();
			var file = $("#popup_attachments");
			var popup_content = $("#popup_content").val();
			
			if(popup_name.length < 2 || popup_name.length > 50){
				alert("제목을 2자 이상 50자 이하로 입력해주세요");
				$("#popup_name").focus();
				return;
			}else if(!$.isNumeric(popup_y_size) || popup_y_size.length < 2 || popup_y_size.length > 3){
				alert("팝업 세로크기를 2 ~ 3자리 수로 입력해주세요");
				$("#popup_y_size").focus();
				return;
			}else if(!$.isNumeric(popup_x_size) || popup_x_size.length < 2 || popup_x_size.length > 3){
				alert("팝업 가로크기를 2 ~ 3자리 수로 입력해주세요");
				$("#popup_x_size").focus();
				return;
			}else if(!$.isNumeric(popup_y_location) || popup_y_location.length < 2 || popup_y_location.length > 3){
				alert("팝업 위치TOP에 2 ~ 3자리 수를 입력해주세요");
				$("#popup_y_location").focus();
				return;
			}else if(!$.isNumeric(popup_x_location) || popup_x_location.length < 2 || popup_x_location.length > 3){
				alert("팝업 위치LEFT에 2 ~ 3자리 수를 입력해주세요");
				$("#popup_x_location").focus();
				return;
			}else if(file.val().length < 1 && image.length < 5){
				alert("팝업 이미지를 등록해주세요");
			}else if(popup_content.length < 2){
				alert("팝업 내용을 입력해주세요");
				$("#popup_content").focus();
				return;
			}else{
				
				$("#popup_window").css({
					"width":popup_x_size+"px",
					"height":popup_y_size+"px",
					"top":popup_y_location+"px",
					"left":popup_x_location+"px"
				});
				$("#preview_name").text(popup_name);
				$("#preview_content").text(popup_content);
				
				$("#preview_popup").css("display","block");	
			}
		});
		
		$("#preview_close").click(function(){
			$("#preview_popup").css("display","none");
		});
		
		$("#popup_attachments").change(function(e){
			$("#upload_file_name").text($(this)[0].files[0].name);
			
			var files = e.target.files;
			var filesArr = Array.prototype.slice.call(files);
			
			filesArr.forEach(function(f){
				sel_file = f;
				
				var reader = new FileReader();
				reader.onload = function(e){
					$("#preview_attachments").attr("src",e.target.result);
				}
				reader.readAsDataURL(f);
			});
			
		});
		
		/* 수정하기 버튼 */
		$("#modify_btn").click(function(){
			var popup_name = $("#popup_name").val();
			var popup_x_size = $("#popup_x_size").val();
			var popup_y_size = $("#popup_y_size").val();
			var popup_y_location = $("#popup_y_location").val();
			var popup_x_location = $("#popup_x_location").val();
			var from = $("#from").val();
			var to = $("#to").val();
			var popup_start_date = null
			var popup_end_date = null
			var file = $("#popup_attachments");
			var popup_content = $("#popup_content").val();
			var popup_use = null;
			
			if($("#popup_use1").is(":checked")){
				popup_use = "1";
	        }else{
	        	popup_use = "0";
	        }
			
			if(popup_name.length < 2 || popup_name.length > 50){
				alert("제목을 2자 이상 50자 이하로 입력해주세요");
				$("#popup_name").focus();
				return;
			}else if(!$.isNumeric(popup_y_size) || popup_y_size.length < 2 || popup_y_size.length > 3){
				alert("팝업 세로크기를 2 ~ 3자리 수로 입력해주세요");
				$("#popup_y_size").focus();
				return;
			}else if(!$.isNumeric(popup_x_size) || popup_x_size.length < 2 || popup_x_size.length > 3){
				alert("팝업 가로크기를 2 ~ 3자리 수로 입력해주세요");
				$("#popup_x_size").focus();
				return;
			}else if(!$.isNumeric(popup_y_location) || popup_y_location.length < 2 || popup_y_location.length > 3){
				alert("팝업 위치TOP에 2 ~ 3자리 수를 입력해주세요");
				$("#popup_y_location").focus();
				return;
			}else if(!$.isNumeric(popup_x_location) || popup_x_location.length < 2 || popup_x_location.length > 3){
				alert("팝업 위치LEFT에 2 ~ 3자리 수를 입력해주세요");
				$("#popup_x_location").focus();
				return;
			}else if(to.length != 10){
				alert("게시기간을 입력해주세요");
				$("#to").focus();
				return;
			}else if(from.length != 10){
				alert("게시기간을 입력해주세요");
				$("#from").focus();
				return;
			}else if(popup_content.length < 2){
				alert("팝업 내용을 입력해주세요");
				$("#popup_content").focus();
				return;
			}else{
				
				popup_start_date = from.substring(6,10) + from.substring(0,2) + from.substring(3,5);
				popup_end_date = to.substring(6,10) + to.substring(0,2) + to.substring(3,5);
				
				var formData = new FormData();
				formData.append("mode", "modify");
				formData.append("popup_number", ${popup.popup_number});
				formData.append("popup_name", popup_name);
				formData.append("popup_content", popup_content);
				formData.append("popup_x_size", popup_x_size);
				formData.append("popup_y_size", popup_y_size);
				formData.append("popup_y_location", popup_y_location);
				formData.append("popup_x_location", popup_x_location);
				formData.append("popup_start_date", popup_start_date);
				formData.append("popup_end_date", popup_end_date);
				if(file.val().length > 0){
					formData.append("file", file[0].files[0]);	
				}
				formData.append("popup_use", popup_use);
				
				$.ajax({
					type:"POST",
					url:"/admin/popup/popup_management_detail_work",
					data:formData,
					processData: false,
					contentType: false,
					dataType:"text",
					success:function(string){
						if(string == "fail"){
							alert("팝업 수정에 실패했습니다.\r다시 시도해주세요");
						}else{
							alert("팝업을 수정했습니다.");
							history.go(0);
						}
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert("팝업 수정에 실패했습니다.\r다시 시도해주세요");
					}
				});
			}
		});
		
		$("#create_btn").click(function(){
			
			var file = $("#popup_attachments");
			if(file.val().length < 1){
				alert("팝업 이미지를 등록해주세요");
			}else{
				var popup_name = $("#popup_name").val();
				var popup_x_size = $("#popup_x_size").val();
				var popup_y_size = $("#popup_y_size").val();
				var popup_y_location = $("#popup_y_location").val();
				var popup_x_location = $("#popup_x_location").val();
				var from = $("#from").val();
				var to = $("#to").val();
				var popup_start_date = null
				var popup_end_date = null
				var popup_content = $("#popup_content").val();
				var popup_use = null;
				
				if($("#popup_use1").is(":checked")){
					popup_use = "1";
		        }else{
		        	popup_use = "0";
		        }
				
				if(popup_name.length < 2 || popup_name.length > 50){
					alert("제목을 2자 이상 50자 이하로 입력해주세요");
					$("#popup_name").focus();
					return;
				}else if(!$.isNumeric(popup_y_size) || popup_y_size.length < 2 || popup_y_size.length > 3){
					alert("팝업 세로크기를 2 ~ 3자리 수로 입력해주세요");
					$("#popup_y_size").focus();
					return;
				}else if(!$.isNumeric(popup_x_size) || popup_x_size.length < 2 || popup_x_size.length > 3){
					alert("팝업 가로크기를 2 ~ 3자리 수로 입력해주세요");
					$("#popup_x_size").focus();
					return;
				}else if(!$.isNumeric(popup_y_location) || popup_y_location.length < 2 || popup_y_location.length > 3){
					alert("팝업 위치TOP에 2 ~ 3자리 수를 입력해주세요");
					$("#popup_y_location").focus();
					return;
				}else if(!$.isNumeric(popup_x_location) || popup_x_location.length < 2 || popup_x_location.length > 3){
					alert("팝업 위치LEFT에 2 ~ 3자리 수를 입력해주세요");
					$("#popup_x_location").focus();
					return;
				}else if(to.length != 10){
					alert("게시기간을 입력해주세요");
					$("#to").focus();
					return;
				}else if(from.length != 10){
					alert("게시기간을 입력해주세요");
					$("#from").focus();
					return;
				}else if(popup_content.length < 2){
					alert("팝업 내용을 입력해주세요");
					$("#popup_content").focus();
					return;
				}else{
					
					popup_start_date = from.substring(6,10) + from.substring(0,2) + from.substring(3,5);
					popup_end_date = to.substring(6,10) + to.substring(0,2) + to.substring(3,5);
					
					var formData = new FormData();
					formData.append("mode", "create");
					formData.append("popup_name", popup_name);
					formData.append("popup_content", popup_content);
					formData.append("popup_x_size", popup_x_size);
					formData.append("popup_y_size", popup_y_size);
					formData.append("popup_y_location", popup_y_location);
					formData.append("popup_x_location", popup_x_location);
					formData.append("popup_start_date", popup_start_date);
					formData.append("popup_end_date", popup_end_date);
					formData.append("file", file[0].files[0]);
					formData.append("popup_use", popup_use);
					
					$.ajax({
						type:"POST",
						url:"/admin/popup/popup_management_detail_work",
						data:formData,
						processData: false,
						contentType: false,
						dataType:"text",
						success:function(string){
							if(string == "fail"){
								alert("팝업 등록 실패했습니다.\r다시 시도해주세요");
							}else{
								alert("팝업을 등록했습니다.");
								location.href="/admin/popup/popup_management_list";
							}
						},
						error:function(XMLHttpRequest, textStatus, errorThrown){
							alert("팝업 등록에 실패했습니다.\r다시 시도해주세요");
						}
					});
				}
			}
		});
		
	});
	function popup_use_check(n){
		if(n == '0'){
			if($("#popup_use2").is(":checked")){
				$("input:checkbox[id='popup_use1']").prop("checked",false)
	        }else{
	        	$("input:checkbox[id='popup_use2']").prop("checked",true);
	        }
		}else if(n == '1'){
			if($("#popup_use1").is(":checked")){
	        	$("input:checkbox[id='popup_use2']").prop("checked",false);
	        }else{
	            $("input:checkbox[id='popup_use1']").prop("checked",true);
	        }
		}
	}
	</script>
</html>
