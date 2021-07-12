<!-- 
 - 학급별 게시판 글쓰기, 수정, 상세 페이지 
 - Naver SmartEditor2 사용
-->
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

		<!-- SmartEditor2 라이브러리 -->  
		<script type="text/javascript" src="/asset/se2/js/HuskyEZCreator.js" charset="utf-8"></script>
		
		<script src="/asset/lib/jquery-1.11.3.min.js"></script>
		<script src="/asset/lib/jquery-ui.js"></script>
		<script src="/asset/lib/swiper-bundle.min.js"></script>
		<script src="/asset/js/script.js"></script>
		<base href="/" />
		<style>
			.table_tr{ cursor:pointer; }
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
							<li class="active"><a href="/teacher/progress/class_board_list">학급별 게시판</a></li>
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
						<li><a href="/teacher/progress/class_progress_management">실시간 수업 진행</a></li>
						<li class="active"><a href="/teacher/progress/class_board_list">학급별 게시판</a></li>
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
				<!-- 
				<li class="active"><span class="slide-tab">교사 커뮤니티</span>
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

		<div class="content">
			<div class="wrapper">
				<c:if test="${mode == 'create'}">
					<h2 class="sub-title">학급별 게시판 작성하기</h2>
				</c:if>
				<c:if test="${mode == 'detail'}">
					<h2 class="sub-title">학급별 게시판 상세보기</h2>
				</c:if>
				<c:if test="${mode == 'modify'}">
					<h2 class="sub-title">학급별 게시판 수정하기</h2>
				</c:if>

				<div class="box-wrap">
					<div class="box-content">
						
						<div class="view-wrap">
						
							<c:if test="${mode == 'create'}">
								<div class="view-title">
									<div class="field w32">
										<h4 class="txt-title">게시판</h4>
										<select id="class_code_selectbox">
											<option>선택</option>
											<c:set var="index" value="0" />
											<c:forEach items="${code_list}" var="code_list">
												<option class_code="${teacher_classcode[index]}">${fn:substring(code_list,0,1)}학년 ${fn:substring(code_list,1,3)}반 ${fn:substring(code_list,3,4)}학기</option>
												<c:set var="index" value="${index+1}" />
											</c:forEach>
										</select>
									</div>
								</div>
							</c:if>
							
							<c:if test="${mode == 'modify'}">
								<div class="view-title">
									<div class="field w32">
										<h4 class="txt-title">게시판</h4>
										<select id="class_code_selectbox">
											<option>선택</option>
											<c:set var="index" value="0" />
											<c:forEach items="${code_list}" var="code_list">
												<c:if test="${code_list == target_code}">
													<option selected class_code="${teacher_classcode[index]}">${fn:substring(code_list,0,1)}학년 ${fn:substring(code_list,1,3)}반 ${fn:substring(code_list,3,4)}학기</option>
												</c:if>
												<c:if test="${code_list != target_code}">
													<option class_code="${teacher_classcode[index]}">${fn:substring(code_list,0,1)}학년 ${fn:substring(code_list,1,3)}반 ${fn:substring(code_list,3,4)}학기</option>
												</c:if>
												<c:set var="index" value="${index+1}" />
											</c:forEach>
										</select>
									</div>
								</div>
							</c:if>
							
							<div class="view-title">
								<c:if test="${mode == 'modify' or mode == 'create'}">
									<h4 class="txt-title">제목</h4>
									<input id="community_title" type="text" value="${community.community_title}" placeholder="게시글 제목을 입력해주세요"/>
								</c:if>
								<c:if test="${mode == 'detail'}">
									<h4 class="txt-title">${community.community_title}</h4>
									<p>작성자: ${community.community_name}  ·  등록일: ${fn:substring(community.community_date,0,4)}-${fn:substring(community.community_date,4,6)}-${fn:substring(community.community_date,6,8)}</p>
								</c:if>
							</div>
							
							<c:if test="${mode == 'modify' or mode == 'create'}">
							<div class="view-title">
								<h4 class="txt-title">내용</h4>
								<textarea id="community_text" name="community_text" rows="10" cols="100" placeholder="게시글 내용을 입력해주세요"></textarea>
							</div>
							</c:if>
							
							<c:if test="${mode == 'detail'}">
								<div id="community_text_box"></div>
								<div class="view-attachment flex">
									<div class="view-info">
										<h4>첨부파일</h4>
										<div class="link-wrap">
											<c:if test="${community.community_file1 != null}">
												<a href="${community.community_file1}" download>${fn:replace(community.community_file1, '/resources/community_file/', '')}</a>
											</c:if>
											<c:if test="${community.community_file2 != null}">
												<a href="${community.community_file1}" download>${fn:replace(community.community_file2, '/resources/community_file/', '')}</a>
											</c:if>
										</div>
									</div>
								</div>
							</c:if>
							
							<div class="edit-btn-wrap txt-right">
								<c:if test="${mode == 'detail' and community.community_id == teacher_id and community.community_auth != null}">
								<button onclick="location.href='/teacher/progress/class_board_detail?community_number=${community.community_number}&mode=modify'">수정</button>
								<button id="delete_community_btn">삭제</button>
								</c:if>
								
								<c:if test="${mode == 'detail'}">
									<button onclick="location.href='/teacher/progress/class_board_list'">목록</button>
								</c:if>
								
								<c:if test="${mode == 'modify'}">
									<button onclick="location.href='/teacher/progress/class_board_detail?community_number=${community.community_number}&mode=detail'">취소</button>
								</c:if>
								<c:if test="${mode == 'create'}">
									<button onclick="location.href='/teacher/progress/class_board_list'">취소</button>
								</c:if>
							</div>

							<div class="reply-wrap">
								<c:if test="${mode == 'detail' and comment != null }">
									<h5>댓글</h5>
									
									<c:forEach items="${comment}" var="comment">
																			
										<div class="reply flex justify-space">
											<div class="reply-cont">
												<p>${comment.comment_name} <span>${fn:substring(comment.comment_date,0,4)}-${fn:substring(comment.comment_date,4,6)}-${fn:substring(comment.comment_date,6,8)}</span></p>
												<p>${comment.comment_content}</p>
											</div>
											<c:if test="${comment.comment_id == teacher_id and comment.comment_auth != null}">
												<div class="reply-edit">
													<div class="edit-btn-wrap">
														<button class="comment_delete_btn" comment_number="${comment.comment_number}" >삭제</button>
													</div>
												</div>
											</c:if>
										</div>

									</c:forEach>
									
								</c:if>
								<c:if test="${mode == 'detail'}">
									<div class="reply-write">
										<h5>댓글 작성하기</h5>
										<input id="comment_area" placeholder="댓글을 작성해주세요"></input>
										<div class="btn-wrap">
											<button id="comment_save_btn" class="btn-pt">댓글 등록하기</button>
										</div>
									</div>
								</c:if>
								
								<c:if test="${mode == 'modify'}">
									<div class="reply-write">
										<div class="btn-wrap">
											<button id="community_modify_btn" class="btn-pt">게시글 수정하기</button>
										</div>
									</div>
								</c:if>
								
								<c:if test="${mode == 'create'}">
									<div class="reply-write">
										<div class="btn-wrap">
											<button id="community_save_btn" class="btn-pt">게시글 등록하기</button>
										</div>
									</div>
								</c:if>
							</div>
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
</html>

<script>

	$(document).ready(function(){
		
		var state = "${state}";
		var thismode = "${mode}";
		
		/* 보유 클래스가 없을경우 알림창 + 메인 리다이렉트 */
		if(state == "none"){
			alert("개설한 수업이 없습니다.");
			location.href="/";
		}
		
		
		/* 
		 - 상세, 수정페이지와 같이 이미 작성된 글을 보여줄 때는 에디터로 작성된 글을 형식에 맞게(HTML 특수문자 치환) 변경하여 화면에 보여준다. 
		*/
		if(thismode == "modify" || thismode == "create"){
			<!-- SmartEditor2 -->
			var oEditors = []; 
			if(thismode == "modify"){
				nhn.husky.EZCreator.createInIFrame({ 
					oAppRef : oEditors, 
					elPlaceHolder : "community_text",
					sSkinURI : "/asset/se2/SmartEditor2Skin.html",
					htParams : { 
						bUseToolbar : true,
						bUseVerticalResizer : false,
						bUseModeChanger : true
					},
					fOnAppLoad : function(){
						var contentText = '${community.community_text}';
						contentText = contentText.replace(/& lt;/gi, "<").replace(/&lt;/gi, "<").replace(/& gt;/gi, ">").replace(/&gt;/gi, ">");

						oEditors.getById["community_text"].exec("SET_IR", [""]);
						oEditors.getById["community_text"].exec("PASTE_HTML", [contentText]);	
					},
					fCreator : "createSEditor2", 
				});
			}else{
				nhn.husky.EZCreator.createInIFrame({ 
					oAppRef : oEditors, 
					elPlaceHolder : "community_text",
					sSkinURI : "/asset/se2/SmartEditor2Skin.html",
					htParams : { 
						bUseToolbar : true,
						bUseVerticalResizer : false,
						bUseModeChanger : true
					},
					fCreator : "createSEditor2", 
				});
			}
		}else{
			var contentText = '${community.community_text}';
			contentText = contentText.replace(/& lt;/gi, "<").replace(/&lt;/gi, "<").replace(/& gt;/gi, ">").replace(/&gt;/gi, ">");
			$("#community_text_box").append(contentText);
		}
		
		
		var community_number = "${community.community_number}";
		
		// 게시글 등록 버튼
		$("#community_save_btn").click(function(){
			
			var community_class_code = $("#class_code_selectbox option:selected").attr("class_code");
			var community_title = $("#community_title").val();
			if(community_class_code == null || community_class_code.length < 1){
				alert("게시판을 선택해주세요");
				return;
			}
			if(community_title.length < 2 || community_title.length > 50){
				alert("게시글 제목을 2자 이상 50자 이하로 작성해주세요");
				return;
			}
			oEditors.getById["community_text"].exec("UPDATE_CONTENTS_FIELD", []);
			var community_text = $("#community_text").val();
			if(community_text.length < 10){
				alert("게시글 내용을 10자 이상 입력해 주세요");
				return;
			}
			var Obj = {
					"community_class_code":community_class_code,
					"community_title":community_title,
					"community_text":community_text,
					"mode":"create",
					"target":"community"
			}
			
			$.ajax({
				type:"POST",
				url:"/teacher/progress/class_board_detail_work",
				data:Obj,
				dataType:"text",
				success:function(string){
					if(string == "success"){
						alert("게시글을 작성했습니다.");
						location.href="/teacher/progress/class_board_list";
					}else{
						alert("게시글 작성에 실패했습니다.\r다시 시도 해주세요");
					}
					
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert("게시글 작성에 실패했습니다.\r다시 시도 해주세요");
				}
			});
		});
		
		
		// 게시글 수정 버튼
		$("#community_modify_btn").click(function(){
			var community_class_code = $("#class_code_selectbox option:selected").attr("class_code");
			var community_title = $("#community_title").val();
			if(community_class_code == null || community_class_code.length < 1){
				alert("게시판을 선택해주세요");
				return;
			}
			if(community_title.length < 2 || community_title.length > 50){
				alert("게시글 제목을 2자 이상 50자 이하로 작성해주세요");
				return;
			}
			oEditors.getById["community_text"].exec("UPDATE_CONTENTS_FIELD", []);
			var community_text = $("#community_text").val();
			if(community_text.length < 2 || community_text.length > 2000){
				alert("게시글 내용을 2자 이상 2000자 이하로 작성해주세요");
				return;
			}
			var Obj = {
					"community_class_code":community_class_code,
					"community_title":community_title,
					"community_text":community_text,
					"mode":"modify",
					"target":"community",
					"community_number":"${community.community_number}"
			}
			
			$.ajax({
				type:"POST",
				url:"/teacher/progress/class_board_detail_work",
				data:Obj,
				dataType:"text",
				success:function(string){
					if(string == "success"){
						alert("게시글을 수정했습니다.");
						location.href="/teacher/progress/class_board_detail?mode=detail&community_number="+community_number;
					}else{
						alert("게시글 수정에 실패했습니다.\r다시 시도 해주세요");
					}
					
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert("게시글 수정에 실패했습니다.\r다시 시도 해주세요");
				}
			});
		});
		
		
		// 댓글 등록 버튼 + 현재 페이지 새로고침
		$("#comment_save_btn").click(function(){
			var comment_content = $("#comment_area").val();
			if(comment_content.length < 2 || comment_content.length > 2000){
				alert("댓글을 2자 이상 500자 이하로 작성해주세요");
				return;
			}
			var Obj = {
					"comment_content":comment_content,
					"mode":"create",
					"target":"comment",
					"comment_community_number":"${community.community_number}"
			}
			
			$.ajax({
				type:"POST",
				url:"/teacher/progress/class_board_detail_work",
				data:Obj,
				dataType:"text",
				success:function(string){
					if(string == "success"){
						location.href="/teacher/progress/class_board_detail?mode=detail&community_number="+community_number;
					}else{
						alert("댓글 작성에 실패했습니다.\r다시 시도 해주세요");
					}
					
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert("댓글 작성에 실패했습니다.\r다시 시도 해주세요");
				}
			});
			
		});
		
		// 댓글 삭제 버튼 + 현재 페이지 새로고침
		$(".comment_delete_btn").click(function(){
			var comment_number = $(this).attr("comment_number");
			var Obj = {
					"comment_community_number":"${community.community_number}",
					"comment_number":comment_number,
					"mode":"delete",
					"target":"comment"
			}
			
			$.ajax({
				type:"POST",
				url:"/teacher/progress/class_board_detail_work",
				data:Obj,
				dataType:"text",
				success:function(string){
					if(string == "success"){
						location.href="/teacher/progress/class_board_detail?mode=detail&community_number="+community_number;
					}else{
						alert("댓글 삭제에 실패했습니다.\r다시 시도 해주세요");
					}
					
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert("댓글 삭제에 실패했습니다.\r다시 시도 해주세요");
				}
			});
		});
		
		// 게시글 삭제 버튼
		$("#delete_community_btn").click(function(){
			if (confirm("정말 게시글을 삭제 하시겠습니까?") == true){
				var Obj = {
						"mode":"delete",
						"target":"community",
						"community_number":"${community.community_number}"
				}
				$.ajax({
					type:"POST",
					url:"/teacher/progress/class_board_detail_work",
					data:Obj,
					dataType:"text",
					success:function(string){
						if(string == "success"){
							alert("게시글을 삭제했습니다.");
							location.href="/teacher/progress/class_board_list";
						}else{
							alert("게시글 삭제에 실패했습니다.\r다시 시도 해주세요");
						}
						
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert("게시글 삭제에 실패했습니다.\r다시 시도 해주세요");
					}
				});
				
			}
			
		});
		
	});
</script>

