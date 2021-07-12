<!-- 학생 신규 등록 페이지 -->
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

		<div class="content">
			<div class="wrapper">
				<h2 class="sub-title">학생 등록</h2>
				<div class="box-wrap">
					<div class="box-content">
						<div class="form">
							<div class="field w32">
								<div class="field-inner">
									<label>학년</label>
									<select id="student_level" class="w100">
										<c:forTokens var="item" items="1,2,3,4,5,6" delims=",">
											<option>${item}</option>
										</c:forTokens>
									</select>
								</div>
							</div>
							<div class="field w32">
								<div class="field-inner">
									<label>학급</label>
									<select id="student_class" class="w100">
										<c:forTokens var="item" items="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20" delims=",">
											<option>${item}</option>
										</c:forTokens>
									</select>
								</div>
							</div>
							<div class="field w32">
								<div class="field-inner">
									<label>번호</label>
									<input id="student_number" type="number" class="w100" placeholder="숫자만 입력하세요.">
								</div>
							</div>
							<div class="field w32">
								<div class="field-inner">
									<label>이름</label>
									<input id="student_name" type="text" class="w100" placeholder="이름을 입력하세요.">
								</div>

							</div>
							<div class="field w32">
								<div class="field-inner">
									<label>나이</label>
									<input id="student_age" type="number" class="w100" placeholder="나이를 입력하세요.">
								</div>

							</div>
							<div class="field w32">
								<div class="field-inner">
									<label>성별</label>
									<select id="student_sex" class="w100">
										<option>남</option>
										<option>여</option>
									</select>
								</div>
							</div>
							<div class="field">
								<div class="field-inner">
									<label>학교명(소속)</label>
									<span class="txt-small ml10" >*자동생성(교사 회원 정보와 같은 학교)</span>
								</div>
							</div>
							
							<div class="field w49">
								<label>아이디</label>
								<div class="field-inner flex nowrap">
									<input id="student_id" type="text" class="input-w-btn" placeholder="">
									<button id="student_id_overlap_btn" class="btn-s-round ml10">중복확인</button>
								</div>
							</div>
							<div class="field w49">
								<label>비밀번호</label>
								<input type="text" placeholder="자동 생성 후 학생에게 전달(이메일 전송)" disabled>
							</div>
							<div class="field w49">
								<label>학생 E-mail</label>
								<input id="student_email" type="email" placeholder="이메일 주소를 입력하세요">
								<label><input id="student_email_agreement" type="checkbox"><span class="custom-check"></span>이메일 수신 동의</label>
							</div>
							<div class="field w49">
								<label>학생 휴대폰</label>
								<input id="student_phone" type="text" placeholder="'-' 포함하여 입력하세요. ex) 010-1234-1234">
								<label><input id="student_message_agreement" type="checkbox"><span class="custom-check"></span>문자 수신 동의</label>
							</div>
							<div class="field">
								<label>이용약관 동의</label>
								<div class="flex">
									<label class="mr10"><input id="agreement1" type="checkbox"><span class="custom-check"></span>온체육 이용약관</a></label>
									<label><input id="agreement2" type="checkbox"><span class="custom-check"></span>개인정보 처리방침</label>
								</div>
							</div>

						</div>
						<div class="btn-wrap">
							<button id="create_student_information_btn" class="btn-pt mr10">저장하기</button>
							<button onclick="location.href='/teacher/ready/student_management'" class="btn-sec">목록으로</button>
						</div>

					</div>
					
				</div>
				

			</div>

			<div class="footer">
				<p>copyright 컴플렉시온 ⓒ All rights reserved.</p>
			</div>
		</div>
	</div>	
	
	<div id="agreement1_popup" class="popup" style="display:none;">
		<div class="popup-cont">
			<div class="pop-title flex justify-space">
				<div class="left flex">
					<h2>이용 약관</h2>
				</div>
				<div class="right">
					<button id="agreement1_close" class="close">x</button>
				</div>
			</div>
			<div class="pop-cont">
				<div class="pop-cont-inner rule">
					<p class="rule-cont">
					온체육 서비스 이용약관<br>
제 1 장 총칙<br>
제 1 조 (목적)<br>
본 약관은 주식회사 컴플렉시온(이하 “회사”)가 온체육 모바일 앱을 통해
제공하는 모바일 동작인식 홈트레이닝 서비스 및 관련 제반 서비스(이하
“서비스”)의 이용과 관련하여 회사와 회원 간의 권리, 의무 및 책임사항, 기타
필요한 사항을 규정함을 목적으로 합니다.<br>
제 2 조 (용어의 정의)<br>
본 약관에서 사용하는 용어의 정의는 다음과 같습니다.<br>
1. "회원"이라 함은 본 약관에 따라 회사와 이용계약을 체결하고, 회사가
제공하는 서비스를 이용하는 개인을 말합니다. 서비스 이용 목적, 이용
권한에 따라 "학생 회원"과 "선생님 회원"으로 나뉩니다.<br>
2. "학생 회원"은 회사가 제공하는 어플리케이션 서비스를 이용하는 개인을
말합니다. 수업에 참여할 수 있으며 게시물을 업로드 할 수 있는 권한을
갖습니다.<br>
3. “선생님 회원”이란 회사가 제공하는 학습 관리 시스템 및 어플리케이션
서비스를 이용하는 개인을 말합니다. 수업을 개설하고 관리할 수 있으며
학습 관리 시스템에서 수정 가능한 부분을 수정할 수 있습니다.<br>
4. “수업”이라 함은 다수의 학생이 함께 특정 기간 동안 정해진 커리큘럼에
따라 진행되는 수업을 말합니다. 학생 회원 한 명은 여러 개의 수업에
참여할 수 있으며 선생님 회원 한 명은 여러 개의 수업에 참여할 수
있습니다.<br>
5. “차시”란 수업 1 시간에 해당하는 단위로 여러 개의 차시가 모여 하나의
수업을 구성합니다.<br>
6. "동작"이란 본 서비스가 제공하는 운동의 한 단위로 동작에 해당하는 모든
콘텐츠에 대해서는 스켈레톤 측정이 적용됩니다.<br>
7. "게시물"이라 함은 회원이 온체육 앱 또는 웹사이트에 게시한
부호·문자·화상·동영상 등의 정보 형태의 글, 사진, 동영상 및 각종 파일과
링크 등을 의미합니다.<br>
8. “H 스코어”라 함은 회원의 운동 정보로부터 계산된 정량적인 신체
점수입니다.<br>
9. “콘텐츠”란 회사가 서비스를 위해 회원에게 제공하는 내용물 일체(텍스트,
음성, 영상을 포함하며 이에 한정되지 아니함)을 의미합니다.<br>
제 3 조 (약관의 효력 및 개정)<br>
1. 본 약관은 서비스 이용을 원하는 자가 본 약관에 동의하면서 회원으로
가입함으로써 효력이 발생합니다.<br>
2. 회사는 본 약관의 내용을 회사의 온체육 웹사이트 초기화면 또는
연결화면에 게시하거나 기타의 방법으로 공지합니다.<br>
3. 회사는 “약관의 규제에 관한 법률”, “전자상거래 등에서의 소비자보호에
관한 법률”, “정보통신망 이용촉진 및 정보보호 등에 관한 법률”,
“콘텐츠산업진흥법”을 위배하지 않는 범위에서 본 약관을 개정할 수
있습니다.<br>
4. 회사가 약관을 개정할 경우에는 적용일자 및 개정 사유를 명시하여
현행약관과 함께 그 적용일자 7 일(회원에게 불리한 변경 또는 중대한
사항의 변경은 30 일) 이전부터 적용일자 전일까지 회사 사이트의
초기화면이나 연결화면에 공지하거나 이메일, 문자, SMS 등을 통해
회원에게 통지합니다.<br>
5. 회사가 전항에 따라 개정약관을 공지하면서 회원에게 30 일간의 기간 내에
의사 표시를 하지 않으면 의사표시가 표명된 것으 로 본다는 뜻을
명확하게 고지하였음에도 회원이 명시적으로 거부의 의사표시를 하지
아니한 경우 회원이 개정약관에 동의한 것으로 봅니다.<br>
6. 회원이 개정약관의 적용에 동의하지 않는다는 명시적 의사를 표명한 경우
회사는 개정 약관의 내용을 적용할 수 없으며, 이 경우 회원은 이용계약을
해지할 수 있습니다. 다만, 기존 약관을 적용하는 것이 기술적, 영업적으로
곤란한 경우 회사는 서비스 이용계약을 해지할 수 있습니다.<br>
7. 회원은 전항에 따른 이용계약의 해지로 손해가 발생한 경우 회사에 이에
대한 배상을 청구할 수 있습니다.<br>
제 4 조 (약관 외 준칙)<br>
본 약관에서 정하지 아니한 사항과 본 약관의 해석에 관하여는 “전자상거래
등에서의 소비자보호에 관한 법률”, “약관의 규제에 관한 법률”,
“콘텐츠산업진흥법”, 공정거래 위원회가 제정한 전자상거래 등에서의
소비자보호지침 또는 회사가 정한 서비스의 개별 이용약관과 일반 상관례에
의합니다.<br>
제 5 조 정보의 제공 및 광고 게재<br>
1. 회사는 본 서비스 등을 유지하기 위하여 서비스 내 광고를 게재할 수
있으며, 회원은 서비스 이용시 광고에 노출될 수 있습니다.<br>
2. 회사가 제공하는 제 3 자가 주체인 제 1 항의 광고에 회원이 참여하거나
교신 또는 거래를 함으로써 발생하는 손실 또는 손해에 대하여 회사는
어떠한 책임도 부담하지 않습니다.<br>
3. 회사는 회원의 사전 동의하에 회원으로부터 수집한 개인정보를 활용하여
제 1 항의 광고를 SMS, 스마트폰 알림, 이메일, 문자를 활용하여 발송할 수
있으며, 회원은 원하지 않을 경우 언제든지 수신을 거부할 수 있습니다.<br>
제 6 조 (저작권 등의 귀속)<br>
1. 서비스 내 콘텐츠에 대한 저작권 및 기타 지적재산권은 회사의
소유입니다.<br>
2. 회원은 회사가 제공하는 서비스를 이용함으로써 얻은 정보(콘텐츠를
포함하며 이에 한정되지 않음)를 회사의 사전 승낙 없이 복제, 전송, 출판,
배포, 방송, 기타의 방법에 의하여 영리목적으로 이용하거나 제 3 자에게
이용하게 하게 하여서는 안 됩니다.<br>
3. 회원이 제 3 항을 위반하여 회사에게 손해가 발생한 경우, 회원은 이로
인하여 회사가 입은 손해를 전부 배상하여야 하며, 이로 인하여
제 3 자로부터 손해배상 청구 또는 소송을 비롯한 각종 이의제기를 받는
경우 해당 회원은 자신의 책임과 비용으로 반드시 회사를 면책시켜야
합니다.<br>
제 2 장 이용계약의 성립<br>
제 7 조(이용계약의 성립)<br>
1. 이용계약은 이용자의 약관 내용에 대한 동의와 이용신청에 대하여 회사가
이를 승낙함으로써 성립합니다.<br>
2. 이용계약에 대한 동의는 회원가입시 이용약관에 대하여 ‘동의함’ 버튼을
누름으로써 의사 표시를 합니다.<br>
제 8 조 (이용신청의 승낙)<br>
1. 회사는 이용자가 본 약관, 개인정보처리방침 등 가입 필수 사항에 동의한
경우에는 휴대폰 인증 절차를 거쳐 서비스의 이용을 승낙하는 것을
원칙으로 합니다.<br>
2. 회사는 다음과 같은 사유가 있는 경우, 이용신청에 대한 승낙을 거부할 수
있습니다.<br>
가. 14 세 미만 아동이 법정대리인(부모 등)의 동의를 얻지 아니한 경우<br>
나. 회사가 회원의 계정을 삭제한 경우<br>
다. 가입신청시 타인의 정보를 도용하여 허위 가입한 소셜계정을
이용하거나 본인의 실명으로 가입되지 않은 소셜계정을 이용한 경우<br>
라. 이미 서비스 계정을 보유한 회원이 중복하여 가입신청을 하는 경우<br>
마. 사회의 안녕·질서 또는 미풍양속을 저해할 목적으로 신청한 경우<br>
바. 회원의 거주지에서 효력이 있는 대한민국 외의 법률에 따라 본 서비스
이용행위가 해당 법률의 위반을 구성하거나 구성할 현저한 위험이 있는
경우<br>
사. 기타 본 약관에 위배되거나 위법 또는 부당한 이용신청임이 확인된
경우<br>
3. 회사는 다음과 같은 사유가 있는 경우, 이용신청에 대한 승낙을 유보할 수
있습니다. 이 경우, 회사는 이용신청자에게 승낙유보의 사유, 승낙가능
시기 또는 승낙에 필요한 추가요청정보 내지 자료 등 기타 승낙유보와
관련된 사항을 해당 서비스화면에 게시하거나 이메일을 통하여
통지합니다.<br>
가. 회사가 정한 서비스 제공환경이 아니거나 기술상 서비스 제공이
불가능한 경우<br>
나. 기타 회사가 합리적인 판단에 의하여 필요하다고 인정하는 경우<br>
제 9 조 (계정의 관리)<br>
1. 계정은 회원 본인만 이용할 수 있고, 어떠한 경우에도 다른 사람이 회원의
계정을 이용하도록 허락할 수 없습니다.<br>
2. 회원은 다른 사람이 회원의 계정을 무단으로 사용할 수 없도록 아이디와
비밀번호 등을 직접 관리하여야 하며, 그에 관한 모든 관리책임은
회원에게 있습니다. 다만, 회사의 고의 또는 과실로 인한 경우에는
그러하지 않습니다.<br>
3. 회원은 자신의 아이디가 부정하게 사용된 사실을 인지한 경우, 바로
반드시 회사에게 그 사실을 통지하고 회사의 안내에 따라야 합니다.<br>
4. 제 4 항의 경우에 해당 회원이 회사에 그 사실을 통지하지 않거나, 통지한
이후 회사의 안내를 따르지 않아 발생하는 불이익에 대하여 회사는
책임지지 않습니다.<br>
5. 회사는 회원이 등록한 계정과 비밀번호 등이 회사에 등록된 것과 일치할
경우에는 별도의 확인절차 없이 이용자를 회원으로 간주합니다.<br>
6. 회원은 서비스 이용신청시 고지한 내용에 변동이 있을 때에, 직접 서비스
내에서 변동된 정보를 수정하거나 이메일, 고객센터를 통하여 변동된
정보의 갱신을 요청하여야 하며, 최신의 정보를 유지하여야 합니다. 정보
미변경으로 인하여 발생하는 불이익에 대하여 회사는 책임지지 않습니다.<br>
7. 회사는 제 7 항에 따라 회원으로부터 변경사항을 통지 받은 경우 지체 없이
이에 따라 개인정보를 변경합니다.<br>
8. 회사가 제 8 항에 따라 변경하지 않음으로 인하여 발생한 회원의 손해에
대하여 배상합니다. 다만 회사가 고의 또는 과실 없음을 증명한 경우에는
그러하지 않습니다.<br>
제 10 조 (YouTube 서비스 사용에 따른 약관)<br>
회사는 YouTube API 를 이용하여 서비스를 제공하고 있습니다. 따라서 회원이
회사의 서비스를 이용한다면 YouTube 의 서비스
약관(https://www.youtube.com/t/terms)에 동의하는 것입니다.<br>
제 3 장 회사 및 회원의 권리 및 의무<br>
제 11 조 (회사의 의무)<br>
1. 회사는 관련법과 본 약관에서 금지하는 행위를 하지 않으며, 계속적이고
안정적으로 서비스를 제공하기 위하여 최선을 다하여 노력합니다.<br>
2. 회사는 회원이 안전하게 서비스를 이용할 수 있도록 개인정보보호를 위한
보안시스템을 갖추고 있습니다. 회사는 회원의 개인정보 보호 및 사용에
관해서는 관계 법령에 따라 개인정보처리방침을 공시하고 이를
준수합니다.<br>
3. 회사는 회원으로부터 제기되는 의견이나 불만이 객관적으로 정당할 경우
적절한 절차를 거쳐 처리합니다.<br>
제 12 조 (회원의 의무 및 위반 시 제제)<br>
1. 회원은 다음의 행위를 하여서는 아니 됩니다.<br>
가. 타인 또는 허위의 개인정보를 이용하여 회원으로 가입하는 행위<br>
나. 타인을 가장하여 서비스를 이용하거나 타인에게 서비스 이용을
위탁하는 행위<br>
다. 다른 회원의 서비스 이용을 방해하는 등 전자거래질서를 위협하는
행위<br>
라. 무단으로 온체육 프로그램을 변경하거나 서버를 해킹하는 등 시스템을
위협하는 행위<br>
마. 허위사실 유포, 위계, 기타 방법으로 회사, 제휴사, 기타 제 3 자의 명예
또는 신용을 훼손하거나 업무를 방해하는 행위<br>
바. 외설 또는 폭력적인 메시지, 화상, 음성, 허위사실, 기타 공서양속에
반하는 정보를 온체육 앱 또는 웹사이트에 공개 또는 게시하거나 기타
타인에게 불쾌감을 주는 행위<br>
사. 본 서비스를 이용하여 불법적 홍보행위, 직거래 행위, 재판매 목적의
거래행위 등을 하는 행위<br>
아. 기타 본 약관상의 의무 또는 법령에 위반되는 행위<br>
2. 제 1 항의 각호의 사유가 발생하는 경우 회사는 사전통보 없이 해당
회원과의 이용계약을 해지하여 영구적으로 회원 자격을 상실시킬 수
있으며, 이 경우 재가입을 막을 수 있습니다.<br>
3. 제 1 항 각호의 사유가 발생하는 경우 회사는 계약해지 대신 서비스 이용의
제한을 가할 수 있습니다.<br>
제 13 조 (회원의 이용계약의 해지)<br>
1. 회원은 언제든지 이메일 통보 등 회사에서 정한 절차를 거쳐 서비스의
이용 중지를 요청하실 수 있으며, 회사는 이를 즉시 처리합니다.<br>
제 4 장 서비스 일반<br>
제 14 조 (서비스의 제공)<br>
1. 회사는 다음과 같은 서비스를 제공합니다.<br>
가. 비대면 체육수업 서비스<br>
나. 셀프 홈 트레이닝 서비스<br>
다. 온라인 콘텐츠 제공<br>
라. 신체 건강 점수 H 스코어<br>
마. 커뮤니티 서비스<br>
바. 학생-선생님간 메시징 서비스<br>
사. 기타 회사가 자체 개발하거나 다른 회사와의 협력계약을 통해
회원에게 제공할 일체의 서비스<br>
2. 회사는 서비스의 종류에 따라 각 서비스의 내용, 이용 절차 및 보상 등에
대한 사항을 서비스 안내화면 및 도움말, 공지사항 등을 통해 미리
공지하며, 회원은 회사가 공지한 각 서비스에 대한 내용을 이해하고
서비스를 이용해야 합니다. 회사는 회원이 공지 내용을 확인하지 않아
입은 손해에 대하여 책임지지 않습니다.<br>
3. 회사는 서비스를 제공함에 있어 회원에게 각 서비스 별로 별도 약관을 둘
수 있으며, 별도 약관과 본 약관이 상충하는 경우 별도 약관이 우선합니다.<br>
4. 회사는 서비스와 관련하여 회원에게 회사가 정한 이용조건에 따라 계정,
서비스 등을 이용할 수 있는 이용권한만을 부여하며, 회원을 이를 활용한
유사 서비스 제공 및 상업적 활동을 할 수 없습니다.<br>
제 15 조 (모바일 동작인식 기능과 회원의 확인, 고지의무)<br>
1. 모바일 동작인식 기능이란 스마트폰에 내장된 카메라를 이용하여 회원의
운동동작을 인식하는 기능을 말합니다.<br>
2. 회원의 체형, 옷차림, 운동시 배경, 핸드폰 기종 등에 따라 동작인식
기능이 인식하는 자세에 차이가 있을 수 있으며, 경우에 따라 동작인식이
불가할 수 있습니다. 회원은 사전에 ‘모바일 동작인식 서비스 이용
유의사항’을 숙지한 후 해당 기능을 사용하여야 하며, 회사는 해당 내용
미숙지로 인하여 회원에게 발생한 손해에 책임을 지지 않습니다.<br>
3. 회원은 비대면 수업 서비스 또는 셀프 홈 트레이닝 서비스를 이용하기 전
사전에 반드시 모바일 동작인식 기능 작동 여부를 확인하여야 하며, 기능
오류를 발견 시 3 영업일 내에 온체육에 그러한 사정을 알려야 합니다.
회사는 회원이 그러한 조치를 취하지 않아 회원에게 발생한 손해를
책임지지 않습니다.<br>
제 16 조 (서비스 이용 시 유의사항)<br>
회사가 제공하는 운동 영상 콘텐츠, 동작인식 서비스는 운동을 위한 가이드에
불과하며, 회원 개개인에게 맞는 정확한 운동법과 차이가 있을 수 있습니다.
회원은 본인의 책임 및 주의 하에 서비스를 이용하여야 하며, 회원의 서비스
이용과정에서 주의의무 위반 등으로 인한 사고, 손해 등에 대하여 회사는 책임을
부담하지 않습니다.<br>
제 17 조 (서비스의 변경 및 중지)<br>
1. 회사는 운영상 또는 기술상의 필요에 따라 제공하고 있는 서비스를 변경할
수 있습니다. 이 경우 회사는 사전에 서비스 초기 화면이나 공지사항
게시판 등 연결화면을 통하여 회원에게 통지합니다. 다만, 회사가 사전에
통지할 수 없는 부득이 한 사유가 있는 경우 사후에 통지할 수 있습니다.<br>
2. 서비스는 연중무휴, 1 일 24 시간 제공함을 원칙으로 합니다. 단, 회사는
국가비상사태, 컴퓨터 등 정보통신설비의 보수점검, 교체 및 고장,
통신두절 또는 운영상 합리적인 이유가 있는 경우 서비스의 제공을
일시적으로 중단할 수 있습니다. 이 경우 회사는 사전에 서비스 초기
화면이 나 공지사항 게시판 등 연결화면을 통하여 회원에게 통지합니다.
다만, 회사가 사전에 통지할 수 없는 부득이 한 사유가 있는 경우 사후에
통지할 수 있습니다.<br>
제 18 조 (서비스 제공의 종료)<br>
1. 회사는 시장 환경의 변화, 기술적 필요, 개별 서비스 이용자의 선호 감소,
기타 서비스의 기획이나 운영상 또는 회사의 긴박한 상황 등에 의해
서비스 전부 또는 일부를 중단할 필요가 있는 경우 30 일 전에 각 서비스
초기화면 또는 앱 내 공지사항, SMS, 이메일 등을 통에 이를 공지하고
서비스의 제공을 종료할 수 있습니다.<br>
제 19 조 (운동정보의 수집)<br>
1. 회사는 서비스 개선 등을 위해 서비스 제공 과정에서 회원의 운동
정보(수행한 운동 종목, 횟수, 시간 등)을 개인 비식별화 형태로 수집할 수
있습니다.<br>
2. 위 제 1 항의 정보는 회사에 귀속되며 귀속된 정보는 서비스 연구, 개발 및
통계자료 작성 등에 활용됩니다.<br>
제 5 장 수업 서비스<br>
제 20 조 (수업 서비스 일반)<br>
1. 수업별 모집 인원, 커리큘럼, 구성 동작 및 콘텐츠 등은 운동 루틴, 상이할
수 있습니다. 학생 회원은 해당하는 수업이 맞는지 확인 후 참가신청을
하여야 하며, 미확인으로 인한 불이익이 발생하는 경우 회사는 책임지지
않습니다.<br>
2. 학생 회원은 수업이 진행되는 도중 언제나 수업에 참가할 수 있습니다.<br>
제 6 장 게시물의 이용 및 관리<br>
제 21 조 (게시물의 이용)<br>
1. 회원이 온체육 앱 또는 웹사이트 상의 게시물을 무단 사용하여 발생하는
손해 기타의 문제는 전적으로 회원 개인의 판단에 따른 책임이며, 회사는
이에 대하여 일절 책임지지 않습니다.<br>
2. 회원은 타인의 초상권, 저작권 등 지적재산권, 인격권 및 기타 권리를
침해하는 목적으로 게시물을 사용할 수 없으며, 회원이 타인의 권리를
침해하는 행위로 인하여 발생하는 결과에 대한 모든 책임은 회원 본인에게
있습니다.<br>
3. 회원은 회사의 동의 없이 게시물을 상업적으로 사용할 수 없습니다.<br>
4. 회원이 회사의 동의를 받지 않고 게시물을 사용하여 회사에 손해를
발생시킨 경우, 회원은 회사에 대한 손해 배상책임이 있습니다.<br>
제 22 조 (게시물의 관리)<br>
1. 회원은 타인의 저작권을 침해하는 내용 혹은 허위 사실을 게시물에
포함하여서는 안됩니다. 회원의 게시물이 법령에 위반되는 내용을
포함하는 경우, 권리자는 관련 법령이 정한 절차에 따라 해당 게시물의
게시중단 및 삭제 등을 요청할 수 있으며, 회사는 관련 법령에 따라
조치를 취합니다.<br>
2. 회사는 전항에 따른 권리자의 요청이 없는 경우라도 권리침해가 인정될
만한 사유가 있거나, 허위 사실로 판단되거나, 기타 회사 정책 및 관련
법령에 위반될 경우에는 관련 법령 및 이용약관, 회사 정책에 따라 해당
게시물에 대하여 게시 거부, 삭제 등의 조치를 취할 수 있습니다.
제 7 장 손해배상 및 면책<br>
제 23 조 (손해배상)<br>
1. 회사의 책임 있는 사유로 인하여 회원에게 손해가 발생한 경우 회사의
손해배상 범위는 민법에서 정하고 있는 통상손해에 한하고, 특별한
사정으로 인한 손해는 회사가 그 사정을 알았거나 알 수 있었을 때에
한하여 배상책임이 있습니다.<br>
2. 제 1 항에도 불구하고 다음 각호의 어느 하나에 해당하는 경우에는 회원이
그 책임의 전부 또는 일부를 부담할 수 있습니다.<br>
가. 회원이 손해 발생의 원인 또는 손해 발생 사실을 알았음에도 불구하고
회사에 통지하지 않은 경우<br>
나. 회원이 고의 또는 과실로 제 3 자에게 계정 정보를 유출하거나 계정을
사용하게 한 경우<br>
다. 그 외에 손해 발생에 있어서 회원의 고의나 과실이 있는 경우<br>
3. 회원이 본 약관 제 12 조 제 1 항 각호의 의무를 위반하여 회사에게 손해가
발생한 경우, 회원은 그로 인하여 회사에 발생한 손해를 전부 배상하여야
합니다.<br>
제 24 조 (면책)<br>
1. 회사는 다음 각 호에 해당하는 경우 손해배상책임을 지지 않습니다.<br>
가. 화재, 지진, 홍수, 낙뢰, 전쟁, 폭동, 반란, 국가비상사태, 천재지변, 기타
불가항력적인 사유로 손해가 발생한 경우<br>
나. 회사에 책임 없는 사유로 디도스(DDOS)공격, IDC 장애, 전기통신서비스
장애, 시스템 오작동 및 불능 사 고로 손해가 발생한 경우<br>
다. 통신서비스 업체의 불량, 정기적인 서버점검 등으로 인하여 불가피하게
장애가 발생하였을 경우<br>
2. 회사는 서비스에 게재한 정보, 자료, 사실의 신뢰도, 정확성 등에 대해서는
보증을 하지 않고, 이로 인하여 발생한 회원의 손해에 대하여 책임을 지지
않습니다. 또한 제공되는 서비스에 관하여 일부 회원이 불쾌감 등을
느낀다 하더라도 이에 관하여 회사는 손해배상책임을 지지 않습니다.<br>
3. 회사는 회원이 서비스를 이용하여 또는 서비스를 이용을 기대하였으나
서비스를 이용하지 못하여 각 기대하는 이익을 얻지 못하거나 상실한 것에
대하여 책임지지 않습니다.<br>
4. 회사는 회사의 책임 없는 사유로 인하여 회원에게 발생한 손해와 회원의
본 약관의 위반으로 인하여 회원에게 발생한 손해에 대하여는 배상책임이
없습니다.56. 회원이 서비스를 이용함에 있어 회원 본인이 행한 불법행위나
본 약관 또는 법령 위반행위로 인하여 회사가 해당 회원 이외의
제 3 자로부터 손해배상 청구 또는 소송을 비롯한 각종 이의제기를 받는
경우 해당 회원은 자신의 책임과 비용으로 반드시 회사를 면책시켜야
합니다.<br>
5. 회사는 회원의 귀책사유로 인한 서비스 이용 장애나 그 결과에 대하여는
책임을 지지 않습니다. 다만, 회원에게 정당한 사유가 있는 경우에는
그러하지 않습니다.<br>
6. 회사는 회원간 또는 회원과 제 3 자간 상호간에 서비스를 매개로 하여 거래
등을 한 경우에는 책임지지 않습니다. 다만, 회사의 고의 또는 중과실에
의한 경우에는 그러하지 않습니다.<br>
제 25 조 (준거법 및 관할법원)<br>
1. 서비스와 관련하여 회사와 회원 간에 분쟁이 발생할 경우 양 당사자 간의
합의에 의해 원만히 해결함을 원칙으로 합니다.<br>
2. 당사자 간에 합의할 수 없거나 합의가 이루어지지 않아 분쟁과 관련하여
소송이 제기되는 경우 서울중앙지방법원을 전속 관할법원으로 합니다.<br>
3. 회사와 회원 간에 제기된 소송에는 대한민국법을 적용합니다.<br>
부칙 본 약관은 2021 년 3 월 2 일부터 시행합니다.
					</p>
				</div>
			</div>
		</div>
	</div>

	<div id="agreement2_popup" class="popup" style="display:none;">
		<div class="popup-cont">
			<div class="pop-title flex justify-space">
				<div class="left flex">
					<h2>개인정보 처리방침</h2>
				</div>
				<div class="right">
					<button id="agreement2_close" class="close">x</button>
				</div>
			</div>
			<div class="pop-cont">
				<div class="pop-cont-inner rule">
					<p class="rule-cont">
					개인정보처리방침<br>
주식회사 컴플렉시온(이하 “회사”)는 정보통신망 이용촉진 및 정보보호 등에 관한
법률, 개인정보 보호법 등에 규정된 정보통신서비스제공자가 준수하여야 할 관련
법령상의 개인정보보호 규정을 준수하며, 관련 법령에 의거한
개인정보처리방침을 정하여 이용자 권익 보호에 최선을 다하고 있습니다. 본
개인정보처리방침(이하 “본 방침”이라 합니다)은 회사가 온체육 모바일 앱을 통해
제공하는 모바일 동작인식 홈트레이닝 서비스 및 관련 제반 서비스(이하
“서비스”) 이용에 적용되며 다음과 같은 내용을 담고 있습니다.<br>
본 방침은 법령 및 고시 등의 변경 또는 회사의 약관 및 내부 정책에 따라
변경될 수 있으며 이를 개정하는 경우 회사는 변경사항에 대하여 서비스 화면에
게시하거나 이용자에게 고지합니다. 이용자는 개인정보의 수집, 이용, 제공, 위탁
등과 관련한 아래 사항에 대하여 원하지 않는 경우 동의를 거부할 수 있습니다.<br>
다만, 이용자가 동의를 거부하는 경우 서비스의 전부 또는 일부를 이용할 수
없음을 알려드립니다.<br>
이용자께서는 서비스 이용 시 수시로 본 방침을 확인하시기 바랍니다.<br>
제 1 조 (개인정보의 수집 및 이용목적)<br>
회사는 개인정보를 다음의 목적을 위해 처리합니다. 처리한 개인정보는 다음의
목적 이외의 용도로는 사용되지 않으며 이용 목적이 변경될 시에는 사전동의를
구할 예정입니다.<br>
1. 회원의 관리: 이용자 가입의사 확인, 본인확인, 개인식별, 가입의사 확인,
서비스의 원활한 운영에 지장을 미치는 행위 및 서비스 부정이용 행위
제재, 가입횟수 제한, 만 14 세 미만 아동 개인 정보 수집 시 법정대리인의
동의 여부 확인, 추후 법정대리인 본인확인, 불만처리 등 민원처리, 각종
고지·통지, 이용자탈퇴 의사의 확인, 고충처리, 분쟁 조정을 위한 기록 보존
등을 목적으로 개인정보를 처리합니다.<br>
2. 재화 또는 서비스 제공: 서비스 제공, 콘텐츠 제공, 특정 맞춤 서비스 제공,
본인인증, 상품, 경품 등 배송 목적으로 개인정보를 처리합니다.<br>
3. 신규 서비스 개발 및 마케팅 및 광고에의 활용: 신규 서비스 개발 및 맞춤
서비스 제공, 통계학적 특성에 따른 서비스 제공 및 광고 게재, 이벤트 및
광고성 정보 제공 및 참여기회 제공, 제휴서비스 안내, 서비스의 유효성
확인, 접속빈도 파악, 이용자의 서비스 이용에 대한 통계 등을 목적으로
개인정보를 처리합니다.<br>
제 2 조 (개인정보의 수집 항목)<br>
회사는 다음의 개인정보 항목을 처리하고 있습니다.<br>
1. 닉네임, 프로필 이미지, 프로필 썸네일 URL, 이메일, 성별,
생년월일(회원가입시)<br>
2. 휴대전화번호(본인인증시)<br>
3. 성명, 주소, 휴대전화번호, 신체 사이즈<br>
4. 이메일, 전화번호, 소셜 아이디(신규서비스 개발 및 마케팅 및 광고에의
활용)<br>
5. 서비스 이용 기록(접속시간, 수행한 운동 종목과 횟수 등), 접속 로그, 쿠키,
접속 IP 정보(서비스 개선)<br>
6. 스켈레톤 좌표 데이터<br>
제 3 조 (개인정보의 수집 방법)<br>
1. 회사는 다음과 같은 방법으로 개인정보를 수집합니다.<br>
가. 본인확인 업무 시 이용자가 직접 제공<br>
2. 회사는 적법하고 공정한 방법으로 서비스 이용계약의 성립 및 이행에
필요한 최소한의 개인정보를 수집하며, 이용자 개인식별이 가능한 정보를
수집하기 전에 개인정보 수집∙이용 동의에 대한 내용을 제공하고, 동의를
받습니다.<br>
3. 회사는 서비스 이용 과정에서 서비스이용기록에 관한 정보를 자동으로
수집합니다.<br>
제 4 조 (개인정보 보유기간)<br>
1. 이용자의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면
지체 없이 파기합니다. 단, 회사 내부 방침에 의하여 회사는 고객이
탈퇴하거나, 고객을 제명하는 경우 권리남용방지, 악용방지, 각종 분쟁 및
수사협조 의뢰에 대비하기 위하여 이용계약 해지일로부터 1 년 동안
개인정보를 보존합니다.<br>
2. 회사는 상법, 전자상거래 등에서의 소비자보호에 관한 법률 등 관계법령의
규정에 의하여 보존할 필요가 있는 경우 회사는 관계법령에서 정한 일정한
기간 동안 이용자정보를 보관합니다. 이 경우 회사는 보관하는 정보를
별도로 분리하여 그 보관의 목적으로만 이용하며 보존기간은 아래와
같습니다.<br>
가. 서비스 이용 관련 개인정보(로그인기록)보존 근거: 통신비밀보호법<br>
보존 기간: 3 개월<br>
나. 표시/광고에 관한 기록보존 근거: 전자상거래 등에서의 소비자보호에
관한 법률<br>
보존 기간: 6 개월<br>
다. 계약 또는 청약철회 등에 관한 기록보존 근거: 전자상거래 등에서의
소비자보호에 관한 법률<br>
보존 기간: 5 년<br>
라. 대금결제 및 재화 등의 공급에 관한 기록보존 근거: 전자상거래
등에서의 소비자보호에 관한 법률<br>
보존 기간: 5 년<br>
마. 소비자의 불만 또는 분쟁처리에 관한 기록보존 근거: 전자상거래
등에서의 소비자보호에 관한 법률<br>
보존 기간: 3 년<br>
바. 전자금융 거래에 관한 기록보존 근거: 전자금융거래법<br>
보존 기간: 5 년<br>
제 5 조 (개인정보의 공유 및 제공)<br>
1. 회사는 이용자들의 개인정보를 본 방침 제 1 조(개인정보의 수집 및
이용목적)에서 고지한 범위 내에서 사용하며, 이용자의 사전 동의 없이는
동 범위를 초과하여 이용하거나 원칙적으로 이용자의 개인정보를 외부에
공개하지 않습니다. 다만, 아래의 경우에는 주의를 기울여 개인정보를 이용
및 제공할 수 있습니다.<br>
가. 이용자가 사전에 동의한 경우<br>
나. 서비스 제공에 따른 요금정산을 위해 필요한 경우<br>
다. 법령의 규정에 의한 경우<br>
라. 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가<br>
있는 경우<br>
마. 통계작성, 학술연구나 시장조사를 위하여 특정 개인을 식별할 수 없는
형태로 광고주, 협력업체나 연구단체 등에 제공하는 경우<br>
2. 회사는 다음과 같이 개인정보를 제 3 자에게 제공하고 있습니다.<br>
가. 개인정보를 제공받는 자<br>
나. 제공받는 자의 개인정보 이용 목적<br>
다. 제공하는 개인정보의 항목<br>
라. 제공받는 자의 개인정보 이용 및 보유기간<br>
마. 전화번호, 이메일 주소, 이름, 배송주소<br>
제 6 조 (개인정보의 취급위탁)<br>
1. 회사는 위탁계약 체결 시 정보통신망 이용촉진 및 정보보호 등에 관한
법률 제 25 조에 따라 위탁업무 수행목적 외 개인정보 처리금지,
기술적·관리적 보호조치, 재위탁 제한, 수탁자에 대한 관리·감독, 손해배상
등 책임에 관한 사항을 계약서 등 문서에 명시하고, 수탁자가 개인정보를
안전하게 처리하는지를 감독하고 있습니다.<br>
2. 개인정보 위탁처리 기관 및 위탁업무의 내용은 아래와 같습니다.<br>
가. 수탁업체<br>
나. 위탁업무 내용<br>
다. 위탁처리정보<br>
라. 개인정보 이용 및 보유기간<br>
마. 전화번호, 이메일 주소, 이름, 주소<br>
3. 회사는 위탁업무의 내용이나 수탁자가 추가 및 변경될 경우에는 지체없이
본 개인정보처리방침을 통하여 공개하고 이용자의 동의가 필요한 경우
이용자들의 동의를 받습니다.<br>
제 7 조 (이용자 및 법정대리인의 권리)<br>
1. 회사는 이용자의 권리를 다음과 같이 보호하고 있습니다.<br>
가. 언제든지 자신의 개인정보를 조회하고 수정할 수 있습니다.<br>
나. 언제든지 개인정보 제공에 관한 동의철회/회원가입해지를 요청할 수
있습니다.<br>
다. 이용자가 개인정보에 대한 열람·증명 또는 정정을 요청하는 경우
회사는 정정 또는 삭제를 완료할 때까지 당해 개인정보를 이용하거나
제공하지 않습니다. 회사는 개인정보에 오류가 있거나 보존기간을 경과한
것이 판명되는 등 정정 또는 삭제할 필요가 있다고 인정되는 경우 지체
없이 그에 따른 조치를 취합니다.<br>
2. 회사는 14 세 미만 아동 이용자의 법정대리인에 대하여 아래와 같은
권리를 보장합니다.<br>
가. 법정대리인은 14 세 미만 아동의 개인정보 수집·이용 또는 제공에 대한
동의를 철회할 수 있으며, 해당 아동이 제공한 개인정보에 대한 열람 또는
오류의 정정을 요구할 수 있습니다(아동의 개인정보에 대한 열람,
정정·삭제, 개인정보처리정지요구권).<br>
나. 14 세 미만 아동인 이용자의 법정대리인이 열람∙증명, 정정을 요구하는
경우 회사는 대리관계를 증명하는 증표를 요구하여 진정한 법정대리인인지
여부를 확인할 수 있습니다.<br>
제 8 조 (개인정보 파기절차 및 방법)<br>
1. 회사는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체없이
파기합니다. 단, 전자상거래 등에서의 소비자 보호에 관한 법률,
전자금융거래법, 통신비밀보호법 등 관계법령 또는 회사의 내부 방침에
의해 보유해야 하는 정보는 법령이 정한 기간 동안 보유합니다.<br>
2. 이용자로부터 동의 받은 개인정보 보유기간이 경과하거나 처리목적이
달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야
하는 경우에는 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나
보유장소를 달리하여 보존합니다.<br>
3. 회사는 제 7 조에서 설명한 절차와 방법에 따라 이용자 본인이 직접 정보
수정 또는 삭제를 요청하거나 가입해지를 요청한 경우에도 본 조에서 정한
바와 같이 파기 처리합니다.<br>
4. 회사가 일시적인 목적(설문조사, 이벤트, 본인확인 등)으로 입력 받은
개인정보는 그 목적이 달성된 이후에는 동일한 방법으로 파기 처리됩니다.<br>
5. 회사는 이용자의 개인정보를 안전하게 처리하며, 유출의 방지를 위하여
다음과 같은 방법을 통하여 개인정보를 파기합니다.<br>
가. 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여
파기합니다.<br>
나. 전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적
방법을 사용하여 삭제합니다.<br>
제 9 조 (개인정보 유효기간제의 적용)<br>
1. 회사는 정보통신망법에 따라 1 년(이하 “개인정보 유효기간”이라고 합니다)
동안 서비스를 이용한 사실 또는 활동한 기록이 없는 경우, 개인정보의
안전한 보호를 위해 정보통신망법 제 29 조에 근거하여 이용자에게 사전
통지하고 개인정보를 별도로 분리하여 저장·관리합니다.<br>
2. 전항의 경우 회사는 개인정보 유효기간이 도래하기 30 일 전까지 이메일,
문자메시지, 휴대전화 등 회원이 입력한 연락수단을 통하여 사전
통지합니다. 다만 개인정보 유효기간이 도래한 회원의 경우에도 회원이
별도 유효기간 갱신의 요청 등 개별 동의가 있는 경우, 포인트나 캐시가
남아있는 경우 또는 타 법령에서 별도로 보존 기간을 정하는 경우에는
관련 법령이 정한 기간 동안 보존 후 조치됩니다.<br>
3. 개인정보 유효 기간제에 의해 별도 분리된 경우라도 회원이 서비스
재이용을 원하실 경우 본인 확인 절차를 거쳐 서비스를 재이용하실 수
있습니다.<br>
제 10 조 (개인정보보호를 위한 기술적, 관리적 조치)<br>
회사는 이용자들의 개인정보를 취급함에 있어 개인정보가 분실, 도난, 누출, 변조
또는 훼손되지 않도록 안전성 확보를 위하여 아래와 같은 대책을 강구하고
있습니다.<br>
1. 기술적 조치: 망 분리, 비밀번호의 관리, 보안프로그램의 설치,
개인정보처리시스템의 접근권한 관리, 접근통제시스템 설치 등 2. 관리적
조치: 내부관리계획의 수립 및 시행, 정기적인 개인정보취급자에 대한
교육, 개인정보취급자의 최소화, 보안서약서 징구 등
제 11 조 개인정보 자동 수집 장치의 설치/운영 및 거부에 관한 사항<br>
1. 회사는 회원에게 특화된 맞춤서비스를 제공하고 회원으로 하여금 보다
원활하고 편리하게 서비스를 이용할 수 있도록 하기 위하여
'쿠키(cookie)'를 사용합니다. 쿠키는 웹사이트를 운영하는데 이용되는
서버(HTTP)가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보이며
이용자의 PC 등에 저장되기도 합니다.<br>
2. 이용자는 쿠키 설치에 대한 선택권을 가지고 있습니다. 따라서, 이용자는
웹 브라우저에서 옵션을 설정함으로써 모든 쿠키를 허용하거나, 쿠키가
저장될 때마다 확인을 거치거나, 아니면 모든 쿠키의 저장을 거부할 수도
있습니다. 이용자는 사용하는 웹 브라우저의 옵션을 선택함으로써 모든
쿠키를 허용하거나 쿠키를 저장할 때마다 확인을 거치거나, 모든 쿠키의
저장을 거부할 수 있습니다. 다만, 쿠키 저장을 거부할 경우 맞춤형 서비스
이용에 어려움이 발생할 수 있습니다.<br>
가. 인터넷 익스플로러의 경우, 웹 브라우저 상단의
[도구]>[인터넷옵션]>[개인정보]>[고급] 메뉴를 통하여 쿠키 설정의 거부가
가능합니다 전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는
기술적 방법을 사용하여 삭제합니다.<br>
나. Chrome 경우, 웹 브라우저 상단의 설정 메뉴 선택 > 고급 설정 표시
선택 > 개인정보-콘텐츠 설정 선택 > 쿠키 수준 설정<br>
다. Safari 의 경우, MacOS 상단 좌측 메뉴바에서
[Safari]>[환경설정]>[보안]을 통하여 쿠키 허용여부를 선택할 수 있습니다.<br>
제 12 조 (개인정보관련 의견수렴 및 불만처리에 관한 사항)
회사는 개인정보보호와 관련하여 이용자 여러분들의 의견을 수렴하고 있으며
불만을 처리하기 위하여 모든 절차와 방법을 마련하고 있습니다. 이용자는
제 12 조의 개인정보보호 책임자 및 담당자의 전화나 메일을 통하여 불만사항을
신고할 수 있고, 회사는 이용자들의 신고사항에 대하여 신속하고도 충분한
답변을 해 드릴 것입니다.<br>
제 13 조 (개인정보 보호책임자 및 담당자의 소속-성명 및 연락처)<br>
1. 회사는 귀하가 좋은 정보를 안전하게 이용할 수 있도록 최선을 다하고
있습니다. 개인정보를 보호하는데 있어 귀하께 고지한 사항들에 반하는
사고가 발생할 경우 개인정보 보호책임자가 책임을 집니다.<br>
2. 이용자 개인정보와 관련한 아이디(ID)의 비밀번호에 대한 보안유지책임은
해당 이용자 자신에게 있습니다. 회사는 비밀번호에 대해 어떠한
방법으로도 이용자에게 직접적으로 질문하는 경우는 없으므로 타인에게
비밀번호가 유출되지 않도록 각별히 주의하시기 바랍니다. 특히
공공장소에서 온라인상에서 접속해 있을 경우에는 더욱 유의하셔야
합니다.<br>
3. 회사는 개인정보에 대한 의견수렴 및 불만처리를 담당하는 개인정보
보호책임자를 지정하고 있고, 연락처는 아래와 같습니다.<br>
4. 개인정보 보호책임자 박치호 (admin@complexion.com)<br>
제 14 조 (YouTube 서비스 사용에 따른 개인정보처리)<br>
회사는 YouTube API 를 이용하여 서비스를 제공하고 있습니다. 따라서 이용자가
회사의 서비스를 이용하기 위해 본 ‘개인정보처리방침’에 동의한다면 아래의
YouTube 의 서비스 약관과 Google 개인정보취급방침에 동의하는 것입니다.<br>
1. YouTube 서비스약관 : https://www.youtube.com/t/terms<br>
2. Google 개인정보처리방침 : https://policies.google.com/privacy<br>
제 15 조 (개인정보처리방침의 적용 제외)<br>
회사는 이용자에게 웹사이트를 통하여 다른 회사의 웹사이트 또는 자료에 대한
링크를 제공할 수 있습니다. 이 경우 회사는 외부사이트 및 자료에 대하여
통제권이 없을 뿐만 아니라 이들이 개인정보를 수집하는 행위에 대하여 회사의
'개인정보처리방침'이 적용되지 않습니다. 따라서, 회사가 포함하고 있는 링크를
클릭하여 타 사이트의 페이지로 이동할 경우에는 새로 방문한 사이트의
개인정보처리방침을 반드시 확인하시기 바랍니다.<br>
제 16 조 (권익침해 구제방법)<br>
이용자는 아래의 기관에 대해 개인정보 침해에 대한 피해구제, 상담 등을
문의하실 수 있습니다.<br>
아래의 기관은 회사와는 별개의 기관으로서, 회사의 자체적인 개인정보 불만처리,
피해구제 결과에 만족하지 못하시거나 보다 자세한 도움이 필요하시면 문의하여
주시기 바랍니다.<br>
1. 개인정보 침해신고센터 (한국인터넷진흥원 운영)<br>
소관업무: 개인정보 침해사실 신고 / 상담 신청<br>
홈페이지: privacy.kisa.or.kr<br>
전화: (국번없이) 118<br>
주소: (58324) 전남 나주시 진흥길 9 (빛가람동 301-2) 3 층<br>
개인정보침해신고센터<br>
2. 개인정보 분쟁조정위원회 사무국<br>
소관업무: 개인정보 분쟁조정신청, 집단분쟁조정<br>
홈페이지: www.kopico.go.kr<br>
전화: 1833-6972<br>
주소: 서울시 종로구 세종로 209 정부서울청사 (개인정보보호위원회)<br>
3. 대검찰청 사이버수사과: 지역번호+1301 (www.spo.go.kr)<br>
4. 경찰청 사이버안전국: 경찰민원콜센터 182 (www.netan.go.kr)<br>
제 17 조 (개정 전 고지 의무)<br>
회사는 본 개인정보처리방침이 변경되는 경우 온체육 앱 및 학습 관리 시스템
홈페이지 내 ‘공지사항’을 통해 사전 공지합니다.<br>
부칙<br>
본 방침은 2021 년 3 월 2 일부터 시행됩니다.
					</p>
				</div>
			</div>
		</div>
	</div>
	
	</body>
	<script>
	var agreement1 = false;	//이용약관 동의 확인
	var agreement2 = false; //개인정보 처리방침 확인
	var student_id_save = null;	//아이디 중복확인 검증통과 값 저장
	var student_id_overlap = false; //아이디 중복확인 검증통과 검증
	
	$(document).ready(function(){
		
		var running = false;
		/* 아이디 입력 필드 "중복확인" 버튼 클릭 이벤트 */
		$("#student_id_overlap_btn").click(function(){
			var student_id_temp = $("#student_id").val();
			student_id_overlap = false;
			if(student_id_temp.length < 4 || student_id_temp.length > 20){
				alert("중복검사하실 아이디를 4자이상 20자 이하로 입력해주세요.");
				return;
			}
				
			if(!running){
				running = true;
				
				$.ajax({
					type:"POST",
					url:"/teacher/ready/student_management_id_overlap",
					data:{"student_id":student_id_temp},
					success:function(string){
						if(string == "success"){
							alert("해당 아이디를 사용하실수 있습니다.");
							student_id_save = student_id_temp;
							student_id_overlap = true;
						}else if(string == "overlap"){
							alert("해당 아이디는 사용하실수 없습니다.");
							student_id_save = "n";
						}else{
							alert("다시 시도해주세요");	
						}
						
						running = false;
					},
					error:function(XMLHttpRequest, textStatus, errorThrown){
						alert("다시 시도해주세요");
						running = false;
					}
				});
				
			}
		});

		/*
		 - 이용약관 동의 필드 - "온체육 이용약관" 체크 변경 이벤트
		 - 최초 체크했을 경우 이용약관 동의 글에 대한 팝업 생성
		*/
		$("#agreement1").change(function(){
			if(!agreement1){
				agreement1 = true;
				$("#agreement1_popup").css("display", "block");
			}
		});

		/*
		 - 이용약관 동의 팝업 닫기 버튼 클릭 이벤트
		*/
		$("#agreement1_close").click(function(){
			$("#agreement1_popup").css("display", "none");
		});

		/*
		 - 이용약관 동의 필드 - "개인정보 처리방침" 체크 변경 이벤트
		 - 최초 체크했을 경우 개인정보 처리방침 글에 대한 팝업 생성
		*/
		$("#agreement2").change(function(){
			if(!agreement2){
				agreement2 = true;
				$("#agreement2_popup").css("display", "block");
			}
		});

		/*
		 - 개인정보 처리방침 팝업 닫기 버튼 클릭 이벤트
		*/
		$("#agreement2_close").click(function(){
			$("#agreement2_popup").css("display", "none");
		});

		/*
		 - "저장하기" 버튼 클릭 이벤트
		 - 각 검증(필드값 입력, 중복확인 등) 후 해당하는 학생 계정 생성 + 입력한 이메일로 계정아이디, 비밀번호가 전송된다.
		*/
		$("#create_student_information_btn").click(function(){
			
			var student_level = $("#student_level option:selected").val();
			var student_class = $("#student_class option:selected").val();
			var student_number = $("#student_number").val();
			var student_name = $("#student_name").val();
			var student_age = $("#student_age").val(); //나이를 입력해야함
			var student_sex = $("#student_sex option:selected").val();
			var student_id = $("#student_id").val();
			var student_email = $("#student_email").val();
			var student_phone = $("#student_phone").val();
			var student_email_agreement = "1";
			var student_message_agreement = "1";
			
			if(!$.isNumeric(student_number) || student_number < 1 || student_number > 40){
				alert("학생번호는 1번 ~ 40번까지 입력 가능합니다.");
				return;
			}
			if(student_name.length < 2 || student_name.length > 6){
				alert("학생이름은 2자이상 6자 이하로 입력해주세요.");
				return;
			}
			if(!$.isNumeric(student_age) || student_age.length < 1 || student_age.length > 2){
				alert("학생 나이를 제대로 입력해주세요.");
				return;
			}

			if(student_sex != "남" && student_sex != "여"){
				alert("학생 성별을 제대로 입력해주세요.");
				return;
			}else{
				if(student_sex == "남"){
					student_sex = "m";
				}else{
					student_sex = "f";
				}
			}
			if(student_id_overlap){
				if(student_id != student_id_save){
					alert("아이디 중복확인을 해주세요");
					return;
				}
			}else{
				alert("아이디 중복확인을 해주세요");
				return;
			}
			
			if(!CheckEmail(student_email)){
				alert("이메일을 제대로 입력해주세요.");
				return;
			}
			if(student_phone.length != 0 && student_phone.length != 13){
				alert("핸드폰번호를 '-'를 포함하여 입력해주세요.");
				return;
			}
			
			if($("#student_email_agreement").is(":checked") == true){
				student_email_agreement = "1";
			}else{
				student_email_agreement = "0";
			}
			
			if($("#student_message_agreement").is(":checked") == true){
				student_message_agreement = "1";
			}else{
				student_message_agreement = "0";
			}
			
			if($("#agreement1").is(":checked") == false){
				alert("온체육 이용약관을 체크해주세요");
				return;
			}
			if($("#agreement2").is(":checked") == false){
				alert("개인정보 처리방침을 체크해주세요");
				return;	
			}
			
			var Obj = {
					"student_level":student_level,
					"student_class":student_class,
					"student_number":student_number,
					"student_name":student_name,
					"student_age":student_age,
					"student_sex":student_sex,
					"student_id":student_id,
					"student_email":student_email,
					"student_phone":student_phone,
					"student_email_agreement":student_email_agreement,
					"student_message_agreement":student_message_agreement
			}
			
			running = true;
			$.ajax({
				type:"POST",
				url:"/teacher/ready/student_management_sign_up_work",
				data:Obj,
				success:function(string){
					if(string == "success"){
						alert("회원가입을 완료했습니다.");
						location.href="/teacher/ready/student_management";
					}else if(string == "email_overlap"){
						alert("해당 이메일을 사용하실수 없습니다.");
					}else{
						alert("다시 시도해주세요");	
					}
					running = false;
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					alert("다시 시도해주세요");
					running = false;
				}
			});			
		});
	});
	
	
	
	
	</script>
</html>

