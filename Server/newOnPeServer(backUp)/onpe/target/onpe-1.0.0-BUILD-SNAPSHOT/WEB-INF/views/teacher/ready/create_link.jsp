<!-- 초대 링크 생성 페이지 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="date" value="<%=new java.util.Date()%>" />
<c:set var="nowYear"><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>
<c:set var="nextYear" value="${nowYear+1}" />
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
			.search_text{ font-size:14px; width:100%; margin:20px 0 0 0; text-align:center; color:#3A6EFF; /*font-weight:bold;*/ }
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
							<li class="active"><a href="/teacher/ready/create_link">초대 링크 생성</a></li>
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
						<li class="active"><a href="/teacher/ready/create_link">초대 링크 생성</a></li>
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
						<li><a href="/teacher/service/qna_list">1:1 문의</a></li>
					</ul>
				</li>
			</ul>
		</div>

		<div class="content">
			<div class="wrapper">
				<h2 class="sub-title">수업 링크 생성</h2>

				<div class="box-wrap">
					<div class="filter-wrap">
						<div class="filter-inner flex justify-space">
							<div class="field w24">
								<label>년도</label>
								<select id="class_year_selectbox">
									<option>${nowYear}</option>
									<option>${nextYear}</option>
								</select>
							</div>
							<div class="field w24">
								<label>학기</label>
								<select id="class_semester_selectbox">
									<option>1</option>
									<option>2</option>
								</select>
							</div>
							<div class="field w24">
								<label>학년</label>
								<select id="class_grade_selectbox">
									<option>전체</option>
									<c:forTokens var="item1" items="1,2,3,4,5,6" delims=",">
										<option>${item1}</option>
									</c:forTokens>
								</select>
							</div>
							<div class="field w24">
								<label>학급</label>
								<select id="class_group_selectbox">
									<option>전체</option>
									<c:forTokens var="item2" items="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20" delims=",">
										<option>${item2}</option>
									</c:forTokens>
								</select>
							</div>
						</div>

						<div class="btn-wrap">
							<button class="btn-pt" id="search_btn">조회</button>
						</div>
						
						<div class="search_text">
							<p>&uarr; 조회버튼을 눌러주세요.</p>
						</div>
							
					</div>
					<div id="box-content" class="box-content" style="display:none;">
						<div class="overflow">
							<table id="box-content-table" class="basic wide">
								<tr>
									<th>년도</th>
									<th>학기</th>
									<th>학년</th>
									<th>학급</th>
									<th>학급 정원</th>
									<th>초대코드(자동생성)</th>
								</tr>
							</table>
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
	
	var search_class_year = "";		//상단 년도 옵션 값
	var search_class_semester = "";	//상단 학기 옵션 값
	var search_class_grade = "";	//상단 학년 옵션 값
	var search_class_group = "";	//상단 학급 옵션 값
	
	$(document).ready(function(){
		
	});

	/*
	 - 상단 조회 버튼 클릭 이벤트
	 - 각 옵션(년도, 학기, 학년, 학급)에 해당하는 생성가능 + 이미 생성되어 있던 클래스 목록 재구성
	*/
	$("#search_btn").click(function(){
		var class_year = $("#class_year_selectbox option:selected").val();
		var class_semester = $("#class_semester_selectbox option:selected").val();
		var class_grade = $("#class_grade_selectbox option:selected").val();
		var class_group = $("#class_group_selectbox option:selected").val();
		if(class_grade == "전체"){
			class_grade = null;
		}
		if(class_group == "전체"){
			class_group = null;
		}
		get_class_list(class_year, class_semester, class_grade, class_group);
	});

	/*
	 - 전달받은 옵션(년도, 학기, 학년, 학급)에 해당하는 클래스 목록 조회 + 목록 재구성 함수
	 - 해당 옵션에 해당하는 목록들을 생성하며(빈값) 또는 옵션에 해당하는 클래스를 보유하고 있다면 해당클래스 정보를 입력
	*/
	function get_class_list(class_year, class_semester, class_grade, class_group){
		$("#box-content").css("display","none");
		$(".search_text").css("display","none");
		var data = { 
				"class_year":class_year, 
				"class_semester":class_semester,
				"class_grade":class_grade,
				"class_group":class_group
			};

		$.ajax({
			type:"POST",
			url:"/teacher/ready/get_my_link",
			data:data,
			dataType:"text",
			success:function(string){
				$(".class_link_box").remove();
				if(string != "fail"){
					search_class_year = class_year;
					search_class_semester = class_semester;
					search_class_grade = class_grade;
					search_class_group = class_group;
					var object = JSON.parse(string);
					
					var append_node = "";
					if(class_grade == null){
						for(grade_num=1;grade_num<7;grade_num++){
							if(class_group == null){
								for(group_num=1;group_num<21;group_num++){
									var overlap = false;
									for(object_num=0;object_num<object.length;object_num++){
										if(object[object_num]["class_grade"] == grade_num && object[object_num]["class_group"] == group_num){
											append_node += create_node(class_year,class_semester,object[object_num]["class_grade"], object[object_num]["class_group"], object[object_num]);
											overlap = true;
											break;
										}
									}
									if(!overlap){
										append_node += create_node(class_year,class_semester,grade_num, group_num, null);
									}
								}
							}else{
								var overlap = false;
								for(object_num=0;object_num<object.length;object_num++){
									if(object[object_num]["class_grade"] == grade_num && object[object_num]["class_group"] == class_group){
										append_node += create_node(class_year,class_semester,object[object_num]["class_grade"], object[object_num]["class_group"], object[object_num]);
										overlap = true;
										break;
									}
								}
								if(!overlap){
									append_node += create_node(class_year,class_semester,grade_num, class_group, null);
								}
							}
						}	
					}else{
						if(class_group == null){
							for(group_num=1;group_num<21;group_num++){
								var overlap = false;
								for(object_num=0;object_num<object.length;object_num++){
									if(object[object_num]["class_grade"] == class_grade && object[object_num]["class_group"] == group_num){
										append_node += create_node(class_year,class_semester,object[object_num]["class_grade"], object[object_num]["class_group"], object[object_num]);
										overlap = true;
										break;
									}
								}
								if(!overlap){
									append_node += create_node(class_year,class_semester,class_grade, group_num, null);
								}
							}
						}else{
							if(object.length == 1){
								//object에 있는걸 보여주기
								append_node += create_node(class_year,class_semester,object[object_num]["class_grade"], object[object_num]["class_group"], object[object_num]);
							}else{
								//새로 만들기
								append_node += create_node(class_year,class_semester,class_grade, class_group, null);
							}
						}
					}
					
					$("#box-content-table").append(append_node);

					/* 클래스 목록 - 보유클래스 - "수정하기" 버튼 클릭 이벤트 */
					$(".modify_max_count").off().click(function(){
						change_max_count($(this).parent().parent().children("td").eq(5).children(".class_code").text(), $(this).parent().children("input").val());
					});

					/* 클래스 목록 - 미 보유클래스 - "저장하기" 버튼 클릭 이벤트 */
					$(".save_max_count").click(function(){
						var value = $(this).parent().children('.max_count').val();
						//console.log("학급정원 저장(disable), 저장하기 버튼 속성 변경, 학급정원이 숫자인지 검증, 학급 정원 1 ~ 99 검증");
						if(value.length > 0 && value.length < 3 && $.isNumeric(value)){
							$(this).parent().children('.max_count').attr("disabled", true);
							$(this).text("저장완료");
							$(this).attr("disabled", true);
							
							$(this).parent().parent().children('.hidden_box').children('.create_class_code').removeClass("display_hidden");
							
						}else{
							alert("학급 정원을 1~99의 숫자로 입력해주세요");
							$(this).parent().children('.max_count').focus();
							return;
						}
					});

					/*
					 - 클래스 목록 - 미 보유클래스 - "저장하기" 버튼 클릭 - "생성하기" 버튼 클릭 이벤트
					 - 실제로 생성되는(새로고침해도 생성되어있음) 부분
					*/
					$(".create_class_code").click(function(){
						var this_node = $(this);
						var class_year = $(this).parent().parent().children('td').eq(0).text();
						var class_semester = $(this).parent().parent().children('td').eq(1).text();
						var class_grade = $(this).parent().parent().children('td').eq(2).text();
						var class_group = $(this).parent().parent().children('td').eq(3).text();
						var class_people_max_count = $(this).parent().parent().children('td').eq(4).children('.max_count').val();
						
						var data = {
								"class_year":class_year,
								"class_semester":class_semester,
								"class_grade":class_grade,
								"class_group":class_group,
								"class_people_max_count":class_people_max_count
						}
						$.ajax({
							type:"POST",
							url:"/teacher/ready/create_link_work",
							data:data,
							dataType:"text",
							success:function(string){
								if(string != null && string != "fail"){
									this_node.parent().children(".class_code").text(string);
									
									this_node.parent().parent().children("td").eq(4).children("button").text("수정하기");
									this_node.parent().parent().children("td").eq(4).children("button").removeClass("btn-s-round-l");
									this_node.parent().parent().children("td").eq(4).children("button").removeClass("mr10");
									this_node.parent().parent().children("td").eq(4).children("button").removeClass("save_max_count");
									this_node.parent().parent().children("td").eq(4).children("button").addClass("btn-s-round-sub");
									this_node.parent().parent().children("td").eq(4).children("button").addClass("modify_max_count");
									this_node.parent().parent().children("td").eq(4).children("button").removeAttr("disabled");
									
									this_node.parent().parent().children("td").eq(4).children("input").removeAttr("disabled");
									this_node.attr("disabled", true);
									this_node.parent().children(".copy_class_code").removeClass("display_hidden");
									this_node.parent().children(".delete_class_code").removeClass("display_hidden");
									this_node.removeClass("create_class_code");
									
									$(".modify_max_count").off().click(function(){
										change_max_count($(this).parent().parent().children("td").eq(5).children(".class_code").text(), $(this).parent().children("input").val());
									});
								}else{
									alert("링크생성에 실패했습니다.\r다시 시도해주세요");
								}
							},
							error:function(XMLHttpRequest, textStatus, errorThrown){
								alert(errorThrown);
							}
						});
						
					});

					/*
					 - 클래스코드 목록 - 보유 클래스 - "복사하기" 버튼 클릭 이벤트 ( 클래스코드 복사 기능 )
					*/
					$(".copy_class_code").click(function(){
						var value = $(this).parent().children(".class_code").text();
						if(value.length > 8){
							var t = document.createElement("textarea");
							document.body.appendChild(t);
							t.value = value;
							t.select();
							document.execCommand('copy');
							document.body.removeChild(t);
							alert("초대코드를 복사했습니다.");
						}
					});

					/*
					 - 클래스코드 목록 - 보유 클래스 - "취소하기" 버튼 클릭 이벤트 ( 대상 클래스 삭제 )
					*/
					$(".delete_class_code").click(function(){
						if (confirm("링크를 취소할 경우 현재 학급에 참여하고 있는 전원의 수업이 초기화 됩니다.\r그래도 취소하시겠습니까?") == true){
							var class_code = $(this).parent().children(".class_code").text();
							var data = {"class_code":class_code}
							$.ajax({
								type:"POST",
								url:"/teacher/ready/delete_link_work",
								data:data,
								dataType:"text",
								success:function(string){
									if(string != null && string == "success"){
										get_class_list(search_class_year, search_class_semester, search_class_grade, search_class_group);
									}else{
										alert("링크삭제에 실패했습니다.\r다시 시도해주세요");
									}
								},
								error:function(XMLHttpRequest, textStatus, errorThrown){
									alert(errorThrown);
								}
							});
						}
					});
					$("#box-content").css("display","block");
				}else{
					console.log("fail");
				}
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){
				alert(errorThrown);
			}
		});	
	}

	/*
	 - 클래스코드 목록 셋팅 함수
	*/
	function create_node(year, semester, grade, group, object){
		var node = "<tr class='class_link_box'><td>"+year+"</td><td>"+semester+"</td><td>"+grade+"</td><td>"+group+"</td><td>";
		if(object != null){
			node +="<input type='text' class='input-small mr10' value='"+object["class_people_max_count"]+"'>";
			node +="<button class='btn-s-round-sub modify_max_count'>수정하기</button></td>";
			node +="<td class='hidden_box'><span class='mr10 class_code'>"+object['class_code']+"</span>";
			node +="<button class='btn-s-round-l' disabled>생성완료</button><button class='btn-s-round-option copy_class_code'>복사하기</button><button class='btn-s-round-sub delete_class_code'>취소하기</button></td>";
		}else{
			node +="<input type='text' class='input-small mr10 max_count'>";
			node +="<button class='btn-s-round-l mr10 save_max_count'>저장하기</button></td>";
			node +="<td class='hidden_box'><span class='mr10 class_code'></span>";
			node +="<button class='btn-s-round-l create_class_code display_hidden'>생성하기</button><button class='btn-s-round-option copy_class_code display_hidden'>복사하기</button><button class='btn-s-round-sub delete_class_code display_hidden'>취소하기</button></td>";
		}
		node +="</tr>";
		return node;
	}

	/*
	 - 학급 정원 수정 함수
	*/
	var changeMaxCount = false;
	function change_max_count(class_code, max_count){
		if(!changeMaxCount){
			changeMaxCount = true;
			$.ajax({
				type:"POST",
				url:"/teacher/ready/change_max_count",
				data:{"class_code":class_code, "max_count":max_count},
				dataType:"text",
				success:function(string){
					if(string != null && string == "success"){
						alert("학급 정원을 수정했습니다.");
					}else{
						alert("학급 정원수정에 실패했습니다.\r다시 시도해주세요");
					}
					changeMaxCount = false;
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert("학급 정원수정에 실패했습니다.\r다시 시도해주세요");
					changeMaxCount = false;
				}
			});
			
		}
	}
	
	</script>
</html>

