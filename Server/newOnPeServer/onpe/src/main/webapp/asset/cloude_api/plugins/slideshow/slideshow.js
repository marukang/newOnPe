/**-------------------------------------------------------------------------------------------------
*										슬라이드 플러그인 스크립트
*																					Date	: 2015.04.29
*																					Author	: 박정민
*																					latest date : 2019-05-27 jr
**/
eBookCore.plugins.slideshow = {
	
	speed		: 4,			// sec
	dtr			: true,		// direction to right →
	played	: false,
	
	close		: function(){},
	control	: function(_state){},
	run			: function(_skinUrl, _currentPageNum, _totalPageNum){},
};


/** 슬라이드쇼 끝내기 */
eBookCore.plugins.slideshow.close = function(){
	eBookCore.plugins.slideshow.control("stop");
	$("#ebookslideshow").detach();
};

/** 타이머 이벤트 페이지 넘김 */
eBookCore.plugins.slideshow.control = function(_state){ // state : play, stop, switch
	
	// switch 속성 지정시 play, stop 판단
	if("switch"===_state){
		_state = (eBookCore.plugins.slideshow.played ? "stop" : "play");
	}
	
	eBookCore.plugins.slideshow.played = ("play"===_state);
	
	if(eBookCore.plugins.slideshow.played){
		$.doTimeout("slideshowplay", eBookCore.plugins.slideshow.speed*1000, function(){
			eBookCore.plugins.slideshow.dtr ? eBookCore.func.gotoNext() : eBookCore.func.gotoPrev();
			return true;
		});
		
	}else{ // stop
		$.doTimeout("slideshowplay");
	}
};

/** 슬라이드쇼 기능 활성화 */
eBookCore.plugins.slideshow.run = function(_skinUrl, _currentPageNum, _totalPageNum){
	
	if(0<$("#ebookslideshow").length){ return eBookCore.plugins.slideshow.close(); }

	var slideShowEl = $("<div id='ebookslideshow' />");
	slideShowEl.append("<div class='dragarea'/>");
	
	var slideShowUpEl		= $("<div class='slideshow_up'/>");
	var slideShowDownEl	= $("<div class='slideshow_down'/>");
	slideShowEl.append(slideShowUpEl);
	slideShowEl.append(slideShowDownEl);
	
	slideShowUpEl.append("<input type='image' id='slideBtnPlay'				src='"+_skinUrl+"pause.png'	/>");
	slideShowUpEl.append("<input type='image' id='slideBtnDirection'	src='"+_skinUrl+"right.png'	/>");
	slideShowUpEl.append("<span id='slideBtnClose' tabindex='0'>&#215;</span>");

	slideShowDownEl.append("<span id='slideshowSpeedNum' />");
	slideShowDownEl.append("<div id='slideshowDelayBar' tabindex='0' />");
	slideShowDownEl.append("<span id='slideCurrentPageNum' class='pagenum' />");
	slideShowDownEl.append("<span id='slideTotalPageNum' />");
	
	slideShowEl.appendTo(document.body);
	slideShowEl.focus();
	
	slideShowEl.draggable({handle:"span, .dragarea"});
	
	$("#slideCurrentPageNum").text(_currentPageNum		);
	$("#slideTotalPageNum"	).text(" / "+_totalPageNum);
	$("#slideshowSpeedNum"	).text(eBookCore.plugins.slideshow.speed+"sec");
	
	$("#slideshowDelayBar").slider({
		orientation	: "horizontal",
		range			: "min",
		min				: 1,
		max				: 120,
		value			: eBookCore.plugins.slideshow.speed,
		animate		: true,
		slide				: function(e, ui){ // 슬라이드 이벤트 처리
			$("#slideshowSpeedNum").text( (eBookCore.plugins.slideshow.speed=ui.value) + "sec" );
			eBookCore.plugins.slideshow.control("play");
		}
	});

	/** 이벤트 처리 **/
	
	// 재생, 정지 버튼 이벤트 처리
	$("#slideBtnPlay").on(eBookCore.eventType.keyclick, function(e){
		if(!eBookCore.eventType.isExcute(e)){ return; }
		
		eBookCore.plugins.slideshow.control("switch");
		
		$(e.target).attr("src", _skinUrl + (eBookCore.plugins.slideshow.played ? "pause.png" : "play.png")); // 이미지 변경
	});
	
	// 재생 방향 버튼 이벤트 처리
	$("#slideBtnDirection").on(eBookCore.eventType.keyclick, function(e){
		if(!eBookCore.eventType.isExcute(e)){ return; }
		eBookCore.plugins.slideshow.dtr = !eBookCore.plugins.slideshow.dtr;
		$(e.target).attr("src", _skinUrl + (eBookCore.plugins.slideshow.dtr ? "right.png" : "left.png")); // 이미지 변경
	});
	
	// 닫기 버튼 이벤트 처리
	$("#slideBtnClose").on(eBookCore.eventType.click, function(e){
		eBookCore.eventType.isExcute(e) && eBookCore.plugins.slideshow.close();
	});


	// 슬라이드창 마우스 포인터 포함 여부에 따라 투명화
	slideShowEl.mouseenter(function(){
		slideShowEl.doTimeout("fade");
		slideShowEl.animate({opacity:1.0});
	})
	.mouseleave(function(){
		slideShowEl.doTimeout("fade", 2000, function(){slideShowEl.animate({opacity:0.2});});
	});
	
	// 최초 타이머 시작
	eBookCore.plugins.slideshow.control("play");
};