<!-- 전체 수업 현황 페이지 -->
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
		<link rel="stylesheet" href="/asset/css/chart.css">
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
		<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
		<base href="/" />
		<style>
			.hidden_box{ display:none; }
			.my_class_list_tr, .overall_curriculum_status_tr{ cursor:pointer; }
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
					<li><span>수업 준비</span>
						<ul class="depth2">
							<li><a href="/teacher/ready/create_link">초대 링크 생성</a></li>
							<li><a href="/teacher/ready/class_configuration_management_list">수업 생성/관리</a></li>
						</ul>
					</li>
					<li><span>수업 진행</span>
						<ul class="depth2">
							<li><a href="/teacher/progress/class_progress_management">실시간 수업 진행</a></li>
							<li><a href="/teacher/progress/class_board_list">학급별 게시판</a></li>
						</ul>
					</li>
					<li><span>기타 메뉴</span>
						<ul class="depth2">
							<li class="active"><a href="/teacher/progress/overall_class_status">전체 수업 현황</a></li>
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
						<li><a href="/teacher/progress/class_board_list">학급별 게시판</a></li>
					</ul>
				</li>
				<li class="active"><span class="badge success">기타 메뉴</span>
					<ul class="depth2">
						<li class="active"><a href="/teacher/progress/overall_class_status">전체 수업 현황</a></li>
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
				<h2 class="sub-title">전체 수업 현황</h2>
				<div class="box-wrap">
					<div class="filter-wrap">
						<div class="filter-inner flex">
							<div class="field w32">
								<label>학년</label>
								<select id="class_grade_selectbox">
									<option>전체</option>
									<c:forTokens var="item" items="1,2,3,4,5,6" delims=",">
										<c:if test="${item == class_grade}">
											<option selected>${item}</option>
										</c:if>
										<c:if test="${item != class_grade}">
											<option>${item}</option>
										</c:if>
									</c:forTokens>
								</select>
							</div>
							<div class="field w32">
								<label>학급</label>
								<select id="class_group_selectbox">
									<option>전체</option>
									<c:forTokens var="item" items="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20" delims=",">
										<c:if test="${item == class_group}">
											<option selected>${item}</option>
										</c:if>
										<c:if test="${item != class_group}">
											<option>${item}</option>
										</c:if>
									</c:forTokens>
								</select>
							</div>
							<div class="field w32">
								<label>학기</label>
								<select id="class_semester_selectbox">
									<option>전체</option>
									<c:forTokens var="item" items="1,2" delims=",">
										<c:if test="${item == class_semester}">
											<option selected>${item}</option>
										</c:if>
										<c:if test="${item != class_semester}">
											<option>${item}</option>
										</c:if>
									</c:forTokens>
								</select>
							</div>
							<div class="field w100">
								<label>검색 구분</label>
								<select>
									<option>수업명</option>
								</select>
								<input id="keyword" type="text" class="search-input ml10" value="${keyword}" />
							</div>
						</div>

						<div class="btn-wrap">
							<button id="search_btn" class="btn-pt">조회</button>
						</div>
							
					</div>
					
					<!-- @@@@@@@@@@@@@@@@@@ 상단 보유클래스 목록 @@@@@@@@@@@@@@@@@@ -->
					<div id="my_class_box" class="box-content">
						<div class="overflow">
							<table class="basic wide">
								<tr>
									<th>No</th>
									<th>학년</th>
									<th>학급</th>
									<th>수업명</th>
									<th>시작일</th>
									<th>종료일</th>
									<th>등록자</th>
									<th>상태</th>
								</tr>
								<c:set var="sum" value="${(page-1)*5 + 1}" />
								<c:forEach items="${class_list}" var="class_list">
									<tr class="my_class_list_tr" class_code='${class_list.class_code}' class_people_count='${class_list.class_people_count}' class_unit_list='${class_list.class_unit_list}'>
										<td><c:out value="${sum}"/></td>
										<td>${class_list.class_grade}</td>
										<td>${class_list.class_group}</td>
										
										<c:if test="${class_list.class_name == null}">
											<td><a>${class_list.class_grade}학년 ${class_list.class_group}반 ${class_list.class_semester}학기 수업</a></td>
										</c:if>
										<c:if test="${class_list.class_name != null}">
											<td><a>${class_list.class_name}</a></td>
										</c:if>
										
										<c:if test="${class_list.class_start_date == null}">
											<td>-</td>
										</c:if>
										<c:if test="${class_list.class_start_date != null}">
											<td>${fn:substring(class_list.class_start_date,0,4)}-${fn:substring(class_list.class_start_date,4,6)}-${fn:substring(class_list.class_start_date,6,8)}</td>
										</c:if>
										
										<c:if test="${class_list.class_end_date == null}">
											<td>-</td>
										</c:if>
										<c:if test="${class_list.class_end_date != null}">
											<td>${fn:substring(class_list.class_end_date,0,4)}-${fn:substring(class_list.class_end_date,4,6)}-${fn:substring(class_list.class_end_date,6,8)}</td>
										</c:if>	
										
										<td>${teacher_name}</td>
										<c:if test="${class_list.class_state == '3'}">
											<td class="alert-success">수업 마감</td>
										</c:if>
										<c:if test="${class_list.class_state != '3'}">
											<c:if test="${class_list.class_start_date == null}">
												<td class="alert-yellow">수업 준비중</td>
											</c:if>
											<c:if test="${class_list.class_start_date != null}">
												<c:if test="${class_list.class_start_date > nowDate }">
													<td class="alert-yellow">수업 준비중</td>
												</c:if>
												<c:if test="${class_list.class_start_date <= nowDate and class_list.class_end_date >= nowDate }">
													<td class="alert-success">수업 중</td>
												</c:if>
												<c:if test="${class_list.class_start_date < nowDate and class_list.class_end_date < nowDate }">
													<td class="alert-danger">수업 완료</td>
												</c:if>
											</c:if>
										</c:if>
									</tr>
									<c:set var="sum" value="${sum+1}" />
								</c:forEach>
							</table>
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
				
				<!-- @@@@@@@@@@@@@@@@@@ 수업(커리큘럼) 과제 및 참여인원 차트 @@@@@@@@@@@@@@@@@@ -->
				<div id="curriculum_chart" class="chart-area box-wrap hidden_box">
					<h2>차시별 수업 현황</h2>
					<div id="chart"></div>
				</div>
				
				<!-- @@@@@@@@@@@@@@@@@@ 전체 수업(커리큘럼)현황 @@@@@@@@@@@@@@@@@@ -->
				<div id="overall_curriculum_status" class="box-wrap hidden_box">
					<div class="arco-title active">
						<h3>전체 수업 현황</h3>
					</div>
					<div class="box-content arco-cont" style="display:block;">
						<div class="overflow">
							<table id="overall_curriculum_status_table" class="basic wide">
								<tr>
									<th>차시</th>
									<th>수업명(차시별)</th>
									<th>수업 구성</th>
									<th>테마</th>
									<th>그룹사용</th>
									<th>시작일</th>
									<th>종료일</th>
									<th>참여율</th>
									<th>과제제출</th>
									<th>평균 신체활동 시간</th>
								</tr>
							</table>
						</div>

						<div class="btn-wrap">
							<button id="download_excel" class="btn-pt">엑셀 다운로드</button>
						</div>
					</div>
				</div>

				<!-- @@@@@@@@@@@@@@@@@@ 커리큘럼 학생들 수업현황 @@@@@@@@@@@@@@@@@@ -->
				<div id="student_curriculum_status" class="box-wrap hidden_box">
					<div class="arco-title active">
						<h3>학생별 수업 현황</h3>
					</div>
					<div class="box-content arco-cont"  style="display:block;">
						<div id="group_content_box" class="field">
							<label>그룹 선택</label>
							<div class="field-inner flex">
								<select id="unit_group_name" class="w32">
									<option class="unit_group_name_option">1그룹</option>
								</select>
							</div>
						</div>
						<div class="x-scroll-area">
							<table id="student_curriculum_status_table" class="basic">
								<tr>
									<th>차시</th>
									<th>수업명(차시별)</th>
									<th>학년</th>
									<th>학급</th>
									<th>학번</th>
									<th>이름</th>
									<th>아이디</th>
									<th>본인확인</th>
									<th>출석</th>
									<th>과제N</th>
									<th>평가 등급</th>
									<th>평가 점수</th>
									<th>평가 내용</th>
									<th>운동 기록</th>
								</tr>
							</table>
						</div>
						
						<div id="student_management_box_paging" class="paging">
						</div>

						<div class="btn-wrap">
							<button id="student_management_save_btn" class="btn-pt">저장하기</button>
						</div>
					</div>
				</div>
			</div>

			<!-- 학생별 수업현황 -->
			<div class="footer">
				<p>copyright 컴플렉시온 ⓒ All rights reserved.</p>
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
		
		
		<form id="excelForm" name="excelForm" method="post" action="/teacher/progress/overallCSExcelDownload">
			<input id="excelFormClassCode" type="hidden" name="class_code" />
		</form>
	
	</body>
	<script>
	var isRunning = false;	//특정 함수 중복실행 방지
	var classNumber = null;	//선택 클래스 - 차시 - 차시번호(ex 1차시, 2차시)
	var className = null;	//선택 클래스 명
	var global_content_home_work = null;	//선택한 클래스 - 차시의 과제유무(JSON Array)
	var global_content_evaluation_type = null;	//선택한 클래스 - 차시의 평가방식(JSON Array)
	var global_content_test = null	//선택한 클래스 - 차시의 평가유무(JSON Array)
	var this_group_node = null;	//선택한 클래스 - 차시 가 그룹일 경우 그룹 객체를 저장
	
	$(document).ready(function(){
		//차트 초기 셋팅 ( 과제현황, 출석현황 )
		var options = {
				chart: {height: 350, type: 'area'},
		        dataLabels: {enabled: false},
		        stroke: {curve: 'smooth'},
		        chart: {
		        	id: 'mychart',
		        	type: 'area'
	       	    },
		        xaxis: {
		        	categories: []
		        },
		        series: [{
					name: '과제 현황',
					data: []
				}, {
					name: '출석 현황',
					data: []
				}],
		        tooltip: {
		        	x: { 
		        		format: 'dd/MM/yy HH:mm' 
	        		},
	        	},
	       	};
		var chart = new ApexCharts(document.querySelector("#chart"), options);
		chart.render();

		/* 상단 조회 버튼 클릭 이벤트 ( 학년, 학급, 학기, 검색 구분 옵션 + 검색어를 통해 클래스 목록 조회 ) */
		$("#search_btn").click(function(){
			var class_grade = $("#class_grade_selectbox option:selected").val();
			var class_group = $("#class_group_selectbox option:selected").val();
			var class_semester = $("#class_semester_selectbox option:selected").val();
			var keyword = $("#keyword").val();
			var url = "/teacher/progress/overall_class_status?ck=1";
			if(keyword.length == 1 || keyword.length > 50){
				alert("수업명을 2자이상 50자 이하로 적어주세요");
				return;
			}
			if(class_grade != "전체"){
				url += "&class_grade="+class_grade;
			}
			if(class_group != "전체"){
				url += "&class_group="+class_group;
			}
			if(class_semester != "전체"){
				url += "&class_semester="+class_semester;
			}
			if(keyword.length > 1){
				url += "&keyword="+keyword;
			}
			location.href=url;
		});

		/* 클래스 목록중 하나의 클래스 클릭 이벤트 ( 해당 클래스의 과제, 평가 차트 + 전체 수업 현황(차시별) 셋팅 ) */
		$(".my_class_list_tr").click(function(){
			if(!isRunning){
				isRunning = true;
				if(!$("#curriculum_chart").hasClass("hidden_box")){
					$("#curriculum_chart").addClass("hidden_box");	
				}
				if(!$("#overall_curriculum_status").hasClass("hidden_box")){
					$("#overall_curriculum_status").addClass("hidden_box");	
				}
				if(!$("#student_curriculum_status").hasClass("hidden_box")){
					$("#student_curriculum_status").addClass("hidden_box");	
				}
				
				var class_unit_list_j = $(this).attr("class_unit_list");
				var class_people_count = $(this).attr("class_people_count");
				var class_code = $(this).attr("class_code");

				/* 해당 클래스에 차시가 있다면 전체 수업 현황 셋팅 */
				if(class_unit_list_j.length > 1){
					var class_unit_list = JSON.parse(class_unit_list_j);
					get_curriculum_list(class_code, class_unit_list, class_people_count);
				}else{
					alert("해당클래스의 수업이 없습니다.");
					isRunning = false;
				}	
			}
		});

		/* 전체 수업 현황 셋팅 */
		function get_curriculum_list(class_code, object, overall_count){
			var unit_code = [];
			for(x=0;x<object.length;x++){
				unit_code.push(object[x]["unit_code"]);
			}
			var data = {
					"mode":"curriculum",
					"unit_code":JSON.stringify(unit_code),
					"class_code":class_code
			}
			
			$.ajax({
				type:"POST",
				url:"/teacher/progress/overall_class_status_work",
				data:data,
				dataType:"text",
				success:function(string){
					if(string != null && string != "fail"){
						var result = JSON.parse(string);
						var chart_categories = [];
						var chart_participation = [];	//출석
						var chart_submit_task = [];	//과제
						
						var node = '';
						
						for(x=0;x<result.length;x++){
							
							//차트 셋팅
							var participation_temp = null;
							var submit_task_temp = null;
							chart_categories.push(result[x][0]["unit_class_name"]);
							
							if(result[x][0]["unit_class_type"] == "0"){
								if(result[x][0]["content_participation"] == null){
									chart_participation.push(0);
									participation_temp = 0;
								}else{
									var participation_count = JSON.parse(result[x][0]["content_participation"]).length;
									chart_participation.push(participation_count);
									participation_temp = participation_count;
								}
								if(result[x][0]["content_submit_task"] == null){
									chart_submit_task.push(0);
									submit_task_temp = 0;
								}else{
									var submit_task_count = JSON.parse(result[x][0]["content_submit_task"]).length;
									chart_submit_task.push(submit_task_count);
									submit_task_temp = submit_task_count;
								}
							}else{
								participation_temp = 0;
								submit_task_temp = 0;
								for(xx=0;xx<result[x].length;xx++){
									if(result[x][xx]["content_participation"] == null){
										participation_temp += 0;
									}else{
										var participation_count = JSON.parse(result[x][xx]["content_participation"]).length;
										participation_temp += participation_count;
									}
									if(result[x][xx]["content_submit_task"] == null){
										submit_task_temp += 0;
									}else{
										var submit_task_count = JSON.parse(result[x][xx]["content_submit_task"]).length;
										submit_task_temp += submit_task_count;
									}
								}
								chart_participation.push(participation_temp);
								chart_submit_task.push(submit_task_temp);
							}
							
							
							//전체 수업(커리큘럼) 현황 셋팅
							if(result[x][0]["unit_class_type"] == "0"){
								node += '<tr class="overall_curriculum_status_tr" group="n" content_test=\''+result[x][0]["content_test"]+'\' content_evaluation_type=\''+result[x][0]["content_evaluation_type"]+'\' content_home_work=\''+result[x][0]["content_home_work"]+'\' classNumber="'+(x+1)+'" className="'+result[x][0]["unit_class_name"]+'" class_code="'+result[x][0]["class_code"]+'" unit_code="'+result[x][0]["unit_code"]+'">';	
							}else{
								node += '<tr class="overall_curriculum_status_tr" group="y" classNumber="'+(x+1)+'" className="'+result[x][0]["unit_class_name"]+'" class_code="'+result[x][0]["class_code"]+'" unit_code="'+result[x][0]["unit_code"]+'" object=\''+JSON.stringify(result[x])+'\'>';
							}
							node += '<td>'+(x+1)+'</td>';
							node += '<td>'+result[x][0]["unit_class_name"]+'</td>';
							if(result[x][0]["unit_class_type"] == "0"){
								var content_code_list = JSON.parse(result[x][0]["content_code_list"]);
								node += "<td>";
								for(xx=0;xx<content_code_list.length;xx++){
									if(xx!=0){
										node += "<br>"; 
									}
									node += content_code_list[xx]["content_name"];
								}
								node +="</td><td>";
								for(xx=0;xx<content_code_list.length;xx++){
									if(xx!=0){
										node += "<br>"; 
									}
									node += content_code_list[xx]["content_type"];
								}
								node +="</td><td>-</td>";
							}else{
								var content_code_list = JSON.parse(result[x][0]["content_code_list"]);
								node += "<td>그룹수업</td><td>그룹수업</td><td>-</td>";
							}
							
							node +="<td>"+result[x][0]["unit_start_date"].substring(0,4)+"-"+result[x][0]["unit_start_date"].substring(4,6)+"-"+result[x][0]["unit_start_date"].substring(6,8)+"</td>";
							node +="<td>"+result[x][0]["unit_end_date"].substring(0,4)+"-"+result[x][0]["unit_end_date"].substring(4,6)+"-"+result[x][0]["unit_end_date"].substring(6,8)+"</td>";
							node +="<td>"+participation_temp+"/"+overall_count+"("+(Math.round(participation_temp/overall_count*100))+"%)</td>";
							node +="<td>"+submit_task_temp+"/"+overall_count+"("+(Math.round(submit_task_temp/overall_count*100))+"%)</td>";
							
							if(result[x][0]["unit_class_type"] == "0"){
								if(result[x][0]["content_use_time"] != "0"){
									node +="<td>"+(Math.round((result[x][0]["content_use_time"]*1)/participation_temp/60))+"분</td></tr>";	// 전체 활동시간(초단위) / 참여인원 / 60 ( 반올림 )  
								}else{
									node +="<td>0분</td></tr>";
								}
							}else{
								var GroupUseTime = 0;
								for(xx=0;xx<result[x].length;xx++){
									GroupUseTime += (result[x][xx]["content_use_time"]*1);
								}
								if(GroupUseTime != 0){
									node +="<td>"+(Math.round(GroupUseTime/participation_temp/60))+"분</td></tr>";	// 전체 활동시간(초단위) / 참여인원 / 60 ( 반올림 )  
								}else{
									node +="<td>0분</td></tr>";
								}
							}
						}
						$(".overall_curriculum_status_tr").remove();
						$("#overall_curriculum_status_table").append(node);
						
						/* 엑셀다운로드 form submit */
						$("#download_excel").off().click(function(){
							$("#excelFormClassCode").val(class_code);
							$("#excelForm").submit();
						});

						//차트 셋팅 완료
						chart.updateOptions({series: [{data: chart_submit_task},{data: chart_participation}],xaxis: {categories: chart_categories}});
						$("#curriculum_chart").removeClass("hidden_box");
						$("#overall_curriculum_status").removeClass("hidden_box");
						
						//차시 목록중 차시 클릭 이벤트 ( 해당 차시에 참여중인 학생 목록 셋팅 )
						$(".overall_curriculum_status_tr").click(function(){
							
							if(!$("#student_curriculum_status").hasClass("hidden_box")){
								$("#student_curriculum_status").addClass("hidden_box");	
							}

							//그룹일때는 그룹 선택 셀렉트박스 셋팅
							if($(this).attr("group") == "n"){
								var tr_class_code = $(this).attr("class_code");
								var tr_unit_code = $(this).attr("unit_code");
								classNumber = $(this).attr("classNumber");
								className = $(this).attr("className");
								global_content_home_work = JSON.parse($(this).attr("content_home_work"));
								global_content_test = JSON.parse($(this).attr("content_test"));
								global_content_evaluation_type = JSON.parse($(this).attr("content_evaluation_type"));
								$("#group_content_box").addClass("hidden_box");
								$("#unit_group_name").empty();
								get_student_management(tr_class_code, tr_unit_code, 1, null);
							}else{
								this_group_node = JSON.parse($(this).attr("object"));
								var tr_class_code = $(this).attr("class_code");
								var tr_unit_code = $(this).attr("unit_code");
								classNumber = $(this).attr("classNumber");
								className = $(this).attr("className");
								
								global_content_home_work = JSON.parse(this_group_node[0]["content_home_work"]);
								global_content_test = JSON.parse(this_group_node[0]["content_test"]);
								global_content_evaluation_type = JSON.parse(this_group_node[0]["content_evaluation_type"]);
								
								$("#group_content_box").removeClass("hidden_box");
								$("#unit_group_name").empty();
								for(x=0;x<this_group_node.length;x++){
									$("#unit_group_name").append('<option class="unit_group_name_option" unit_code="'+tr_unit_code+'" class_code="'+tr_class_code+'" content_test=\''+this_group_node[x]["content_test"]+'\' content_evaluation_type=\''+this_group_node[x]["content_evaluation_type"]+'\' content_home_work=\''+this_group_node[x]["content_home_work"]+'\' number_list=\''+this_group_node[x]["unit_group_id_list"]+'\'>'+this_group_node[x]["unit_group_name"]+'</option>');
								}
								console.log(this_group_node[0]["unit_group_id_list"]);
								get_student_management(tr_class_code, tr_unit_code, 1, JSON.parse(this_group_node[0]["unit_group_id_list"]));
								
							}
						});
						
					}else{
						alert("수업목록을 불러오는데 실패했습니다.\r다시 시도해주세요");
					}
					isRunning = false;
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert("수업목록을 불러오는데 실패했습니다.\r다시 시도해주세요");
					isRunning = false;
				}
			});
		}
	});
	
	
	/* 학생별 수업 현황 -> 그룹 변경 이벤트 */
	$("#unit_group_name").change(function(){
		var class_code = $("#unit_group_name option:selected").attr("class_code");
		var unit_code = $("#unit_group_name option:selected").attr("unit_code")
		var content_evaluation_type = $("#unit_group_name option:selected").attr("content_evaluation_type");
		global_content_evaluation_type = JSON.parse(content_evaluation_type);
		var content_home_work = JSON.parse($("#unit_group_name option:selected").attr("content_home_work"));
		global_content_home_work = content_home_work;
		var content_test = JSON.parse($("#unit_group_name option:selected").attr("content_test"));
		global_content_test = content_test;

		/* 참여학생이 존재한다면, 학생 목록 재구성 */
		if($("#unit_group_name option:selected").attr("number_list") != null){
			get_student_management(class_code, unit_code, 1, JSON.parse($("#unit_group_name option:selected").attr("number_list")));	
		}else{
			alert("수업에 참여중인 학생이 없습니다.");
			if(!$("#student_curriculum_status").hasClass("hidden_box")){
				$("#student_curriculum_status").addClass("hidden_box");	
			}
		}
	});

	/* 학생 목록 셋팅 함수 ( 페이징 처리 ) */
	var before_page = null;
	function get_student_management(class_code, unit_code, page, number_list){
		if(!isRunning){
			isRunning = true;
			
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
		    						  node +='<tr class="student_management_tr" student_id="'+record[xx]["student_id"]+'">';
		    						  node +='<td>'+classNumber+'</td>';
		    						  node +='<td>'+className+'</td>';
				    				  node += '<td>'+record[xx]["student_grade"]+'</td>';
				    				  node += '<td>'+record[xx]["student_group"]+'</td>';
				    				  node += '<td>'+record[xx]["student_number"]+'</td>';
				    				  node += '<td>'+record[xx]["student_name"]+'</td>';
				    				  node += '<td>'+record[xx]["student_id"]+'</td>';
				    				  
				    				  if(record[xx]["image_confirmation"] != null && record[xx]["image_confirmation"].length > 1){
				    					  node += '<td><div class="edit-btn-wrap txt-left"><button class="bg2" onclick="window.open(\''+record[xx]["image_confirmation"]+'\')">확인하기</button></div></td>';
				    				  }else{
				    					  node += '<td>-</td>';
				    				  }
				    				  
				    				  if(record[xx]["student_participation"] == "1"){
				    					  node += '<td>Y</td>';
				    				  }else{
				    					  node += '<td>N</td>';
				    				  }
				    				  
				    				  if(global_content_home_work[x] == "1"){
				    					  
				    					  if(record[xx]["task_practice"] != null && record[xx]["task_practice"].length > 1){
				    						  node += '<td>Y</td>';  
				    					  }else{
				    						  node += '<td>N</td>';
				    					  }
				    				  }else{
				    					  node += '<td>-</td>';
				    				  }
				    				  
				    				  if(global_content_evaluation_type[x] == "1"){
				    					  if(eval_1 == null || eval_1[x] == "0" || eval_1[x] == "-" && eval_1[x] != "undefined"){
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
				    					  node += '<td><input class="curriculum_result_popup_evaluation2 input-m" type="number" placeholder="-" value="-" disabled></td>';
				    					  node += '<td><input class="curriculum_result_popup_evaluation3 input-m" type="text" placeholder="-" value="-" disabled></td>';
				    				  }else if(global_content_evaluation_type[x] == "2"){				    					  
				    					  node += '<td><select class="curriculum_result_popup_evaluation1" disabled><option>-</option></select></td>';
				    					  if(eval_2 != null){
				    						  if(eval_2[x] != "-" && eval_2[x] != "" && eval_2[x] != "undefined"){
				    							  node += '<td><input class="curriculum_result_popup_evaluation2 input-m" type="number" placeholder="점수를 적어주세요" value="'+eval_2[x]+'"></td>';  
				    						  }else{
				    							  node += '<td><input class="curriculum_result_popup_evaluation2 input-m" type="number" placeholder="점수를 적어주세요"></td>'	;  
				    						  }
				    					  }else{
				    						  node += '<td><input class="curriculum_result_popup_evaluation2 input-m" type="number" placeholder="점수를 적어주세요"></td>'	;			    						  
				    					  }
				    					  node += '<td><input class="curriculum_result_popup_evaluation3 input-m" type="text" placeholder="-" value="-" disabled></td>';
				    				  }else if(global_content_evaluation_type[x] == "3"){
				    					  node += '<td><select class="curriculum_result_popup_evaluation1" disabled><option>-</option></select></td>';
				    					  node += '<td><input class="curriculum_result_popup_evaluation2 input-m" type="number" placeholder="-" value="-" disabled></td>';
				    					  if(eval_3 != null){
				    						  if(eval_3[x] != "-" && eval_3[x] != "" && eval_3[x] != "undefined"){
				    							  node += '<td><input class="curriculum_result_popup_evaluation3 input-m" type="text" placeholder="평가를 적어주세요" value="'+eval_3[x]+'"></td>';  
				    						  }else{
				    							  node += '<td><input class="curriculum_result_popup_evaluation3 input-m" type="text" placeholder="평가를 적어주세요"></td>';  
				    						  }
				    					  }else{
				    						  node += '<td><input class="curriculum_result_popup_evaluation3 input-m" type="text" placeholder="평가를 적어주세요"></td>';		    						  
				    					  }
				    				  }else{
				    					  node += '<td><select class="curriculum_result_popup_evaluation1" disabled><option>-</option></select></td>';
				    					  node += '<td><input class="curriculum_result_popup_evaluation2 input-m" type="number" placeholder="-" value="-" disabled></td>';
				    					  node += '<td><input class="curriculum_result_popup_evaluation3 input-m" type="text" placeholder="-" value="-" disabled></td>';
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
					    					  cp_count++;
				    					  }else{
					    					  node += "<td>-</td>"
					    				  }
				    				  }				    				  
				    				  
				    				  node += "</tr>";
				    			  }
	    					  }
	    					  $(".student_management_tr").remove();
	    					  $("#student_curriculum_status_table").append(node);
	    					  $("#student_management_save_btn").attr("class_code", class_code);
	    					  $("#student_management_save_btn").attr("unit_code", unit_code);
	    					  
	    					  /* 운동기록 확인 버튼 클릭 이벤트 ( 운동 기록 확인 팝업 ON ) */
		    				  $(".student_record_view_btn").off().click(function(){
		    					  var object = JSON.parse($(this).attr("info"));
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
		    					  $("#student_exercise_record_popup").css("display","block");
		    				  });

							  /* 운동기록 확인 팝업 -> 닫기 버튼 클릭 이벤트 ( 운동 기록 확인 팝업 OFF ) */
		    				  $("#student_exercise_record_popup_close").off().click(function(){
		    					  $("#student_exercise_record_popup").css("display","none");
		    				  });

		    				  /* 저장하기 버튼 클릭 이벤트 ( 점수 저장 ) */
	    					  $("#student_management_save_btn").off().click(function(){
	    						  var cl_code = $(this).attr("class_code");
		    					  var un_code = $(this).attr("unit_code");
		    					  
		    					  var student_id = [];
		    					  var evaluation_type_1 = [];
		    					  var evaluation_type_2 = [];
		    					  var evaluation_type_3 = [];
		    					  
		    					  for(xx=0;xx<$(".student_management_tr").length;xx++){
		    						  student_id.push($(".student_management_tr").eq(xx).attr("student_id"));
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
		    					  
		    					  if(!isRunning){
		    						  isRunning = true;
		    						  
		    						  $.ajax({
			    			    		  type:"POST",
			    			    		  url:"/teacher/progress/update_student_class_record",
			    			    		  data:Object,
			    			    		  success:function(string){
			    			    			  if(string == "success"){
			    			    				  alert("저장했습니다.");
			    			    			  }else{
			    			    				  alert("저장실패\r다시 시도해주세요");
			    			    			  }
			    			    			  isRunning = false;
			    			    		  },
			    			    		  error:function(XMLHttpRequest, textStatus, errorThrown){
			    			    			  alert("저장실패\r다시 시도해주세요");
			    			    			  isRunning = false;
			    						  }
			    					  });
		    					  }
	    					  });
	    					  
	    					  
	    					  /* 학생 목록 페이징 처리 */
	    					  $("#student_management_box_paging").children("button").remove();
	    					  $("#student_management_box_paging").children("ul").remove();
	    					  var paging_node = "";
	    					  if(page != "1"){
	    						  paging_node += "<button class='page-arrow go-first' onclick='get_student_management(\""+class_code+"\",\""+unit_code+"\",1, "+number_list+")'>처음으로</button>";
	    						  paging_node += "<button class='page-arrow go-prev' onclick='get_student_management(\""+class_code+"\",\""+unit_code+"\","+(page-1)+", "+number_list+")'>이전</button>";
    						  }
		    				  paging_node += "<ul class='page-num'>";
		    				  for(x=object["pageing_start"];x<object["pageing_last"]*1+1;x++){
		    					  if(x == page){
		    						  paging_node += "<li class='active'>"+x+"</li>"
	    						  }else{
	    							  paging_node += "<li onclick='get_student_management(\""+class_code+"\",\""+unit_code+"\","+(x)+", "+number_list+")'>"+x+"</li>"
    							  }
	    					  }
		    				  if(page != object["last_page"] && object["last_page"] != "0"){
		    					  paging_node += "<button class='page-arrow go-next' onclick='get_student_management(\""+class_code+"\",\""+unit_code+"\","+(page+1)+", "+number_list+")'>다음</button>";
		    					  paging_node += "<button class='page-arrow go-last' onclick='get_student_management(\""+class_code+"\",\""+unit_code+"\","+object['last_page']+", "+number_list+")'>끝으로</button>";
	    					  }
		    				  $("#student_management_box_paging").append(paging_node);	    				  
		    				  
		    				  $("#student_curriculum_status").removeClass("hidden_box");
		    				  
		    			  }else{
		    				  alert("수업에 참여중인 학생이 없습니다.");
		    			  }
	    			  }else{
	    				  alert("수업에 참여중인 학생이 없습니다.");
	    			  }
	    			  
	    			  isRunning = false;
	    		  },
	    		  error:function(XMLHttpRequest, textStatus, errorThrown){
	    			  alert("학생관리 목록을 불러오는데 실패했습니다.\r다시 시도해주세요");
	    			  isRunning = false;
				  }
			 });				
		}			
	}
	
	</script>
</html>

