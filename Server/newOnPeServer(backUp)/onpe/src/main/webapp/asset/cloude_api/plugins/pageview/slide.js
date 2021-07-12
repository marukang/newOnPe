/**-------------------------------------------------------------------------------------------------
*								슬라이드 방식 페이지 넘김 스크립트
*																					Date		: 2015.10.06
*																					Author	: 박정민
**/

/**	★ 최초 열기시 1회 초기화
**/
eBookCore.pageTurn.init = function(){
	
	var _viewport = $('.pageview');
	if(1>_viewport.length){ return; }
	
	// 슬라이드 드래그 이벤트 정보 정의
	this.dragstate = {
		action	: false,
		stPos		: 0,
		dist		: 0,
	};
	
	// 슬라이드 애니메이션 효과 정의
	this.slidingStyle = {duration:eBookData.pageView.duration, easing:'easeOutExpo'};
	
	/** 슬라이드 추가 */
	eBookCore.pageTurn.addSlide = function(pageNum) {
		
		if(undefined==pageNum){ pageNum = eBookCore.currentPageNum; }
		
		if(pageNum<1 || eBookData.totalPageNum<pageNum){ return croTools.log("addSlide out of range : "+pageNum); } // 페이지 범위 초과시 중단
		
		var _isSingle = eBookCore.func.nowPageViewSingle();
		
		if(1<pageNum && !_isSingle){ // 양면보기인 경우 커버사용유무에 따라 왼쪽 기준페이지 번호를 수정
			if(eBookData.pageView.cover){ // 1,2,4,6,8 ...
				pageNum = pageNum - (pageNum % 2);
			}else{ // 1,3,5,7,9 ...
				pageNum = pageNum + (pageNum % 2) - 1;
			}
		}
	
		var _slideEl =
			$("<div class='slideframe' />")
			.css({
				width			: _viewport.width()+"px",
				height		: "98%",
				textAlign : "center",
				display		: "inline-block",
				position	: "absolute",
				top				: "2%",
			})
			.on("dragstart", function(e){ e.preventDefault(); })
			
			/** 모바일 터치 슬라이드 이벤트 */
			.on("swipeLeft"	, eBookCore.func.gotoNext)
			.on("swipeRight", eBookCore.func.gotoPrev)
			
			.on("mousedown", function(e){ /** 슬라이드 이벤트 : mousedown */
				croTools.log("slide:mousedown");
				
				eBookCore.pageTurn.dragstate.action	= true;
				eBookCore.pageTurn.dragstate.stPos	= e.clientX;
				eBookCore.pageTurn.dragstate.dist		= 0;
			})
			.on("mouseup", function(e){ /** 슬라이드 이벤트 : mouseup */
				croTools.log("slide:mouseup : dist="+eBookCore.pageTurn.dragstate.dist);

				eBookCore.pageTurn.dragstate.action	= false;
				
				var _targetDist = $(".pageview").width() / 10;
				
				// 드래그 거리가 일정치를 넘으면 이동처리
				if(eBookCore.pageTurn.dragstate.dist > _targetDist){	// right
					if(!isNaN(eBookCore.func.gotoPrev())){ return; }
				}else
				if(eBookCore.pageTurn.dragstate.dist < -_targetDist){	// left
					if(!isNaN(eBookCore.func.gotoNext())){ return; }
				}
				$(e.currentTarget).animate( {left : 0},	eBookCore.pageTurn.slidingStyle);
				
				var _clientWidth = croTools.getClientSize().width;
				$(e.currentTarget).prev().animate( {left : -_clientWidth},	eBookCore.pageTurn.slidingStyle);
				$(e.currentTarget).next().animate( {left : +_clientWidth},	eBookCore.pageTurn.slidingStyle);
			})
			.on("mousemove", function(e){ /** 슬라이드 이벤트 : mousemove */
				if(!eBookCore.pageTurn.dragstate.action){ return; }
				eBookCore.pageTurn.dragstate.dist = e.clientX - eBookCore.pageTurn.dragstate.stPos; // 거리값 갱신
				// 드래그된 거리만큼 left 수정
				$(e.currentTarget).css("left", eBookCore.pageTurn.dragstate.dist+"px");
				
				// 좌우 슬라이드도 함께 이동 처리
				var _clientWidth = croTools.getClientSize().width;
				$(e.currentTarget).prev().css("left", (-_clientWidth+eBookCore.pageTurn.dragstate.dist)+"px");
				$(e.currentTarget).next().css("left", (+_clientWidth+eBookCore.pageTurn.dragstate.dist)+"px");
			});
		
		// 슬라이드 객체 안에 페이지 추가
		eBookCore.pageTurn.addPage(_slideEl, pageNum);
		if(!_isSingle && pageNum<eBookData.totalPageNum && !(1===pageNum && eBookData.pageView.cover)){
			eBookCore.pageTurn.addPage(_slideEl, pageNum+1);
		}
		
		// 추가할 페이지 현재 페이지 기준 좌 우 위치 지정
		var _clientWidth	= croTools.getClientSize().width;
		var _currSlide		= _viewport.find(".current");
		var _isLeft				= 0<_currSlide.length && parseInt(_currSlide.find("[page]").eq(0).attr("page")) > pageNum;
		var _leftPos			= _clientWidth * (_isLeft ? -1 : 1);
		_slideEl.css("left", _leftPos+"px");
		_isLeft ? _viewport.prepend(_slideEl) : _viewport.append(_slideEl);
		
		return _slideEl;
	}
	
	/** 페이지 추가 */
	eBookCore.pageTurn.addPage = function(_slideEl, _pageNum) {
		croTools.log("addPage : "+_pageNum);
		if(_pageNum<1 || _pageNum>eBookData.totalPageNum){ return; }
		
		var pageEl = $('<div class="loader page p'+_pageNum+'" page="'+_pageNum+'"/>') // 로딩 화면을 먼저 추가하고 본문 페이지 이미지를 로딩함
									.css({
										display		: (eBookCore.func.nowPageViewSingle() ? "block" : "inline-block"), // 현재 화면 비율의 페이지 양,단면 표시 설정
										width			: "50%",
										height		: "100%",
										textAlign	: "center",
										position	: "relative",
									}).html(	'<img class="loading" src="' + eBookCore.path.pageview + 'loading.gif" style="position:relative; top:50%; margin:auto; " />' );
		
		eBookCore.pageTurn.loadPage(pageEl, _pageNum); // 페이지 이미지 불러오기
		
		_slideEl.append(pageEl);
	};
	
	/** 본문 페이지 로딩 */
	eBookCore.pageTurn.loadPage = function(element, _pageNum) {
		//croTools.log("loadPage : "+pageNum);
		
		var _addImg = $("<img />", {
			"src"		: eBookCore.path.pages + _pageNum + "." + eBookData.pageExt,
			"class"	: "target",
			css			: {	width		: '100%',
									height	: '100%',
									}
		})
		.on(eBookCore.eventType.dblclick,function(){ /** 더블 클릭시 확대축소 활성화 */
			eBookCore.plugins.zoomview.run(_addImg);
		})
		.on("dragstart", function(e){ /** 슬라이드 처리를 위해 이미지 드래그 기본동작을 막음 */
			e.preventDefault();
		})
		.on("pinchOut", function(){ eBookCore.plugins.zoomview.run(_addImg); })
		;
		
		/** 이미지 로딩 완료 처리 */
		var loadingComplete = function(){
			element.removeClass("loader");
			element.css({position:'absolute'});
			element.find(".loading").detach();
			element.append( _addImg );
			eBookCore.pageTurn.resizeByPage(element); // 불러온 페이지 크기 재조정
			
			// ★ 페이지 컨텐츠 로딩
			eBookCore.func.loadPageContents(element, _pageNum);
			
			// 모든 이미지가 로딩완료되면 페이지 퀄리티 수정( for IE )
			!$(".loader").length && eBookCore.pageTurn.imageResampling(); // 본문 퀄리티 수정
		};
		
		// 본문 이미지 로딩이 끝나면 로딩페이지와 교체
		croTools.canHTML5() ? _addImg.load(loadingComplete) : loadingComplete(); // IE8 이하 버전에서 load 이벤트가 제대로 동작하지 않으므로 페이지 이미지로 바로 교체
	};

	/** 페이지번호로 해당 슬라이드 반환 : added 15.10.13 */
	eBookCore.pageTurn.getSlideByPageNum = function(_pageNum){
		var _page = $(".pageview .slideframe .p" + _pageNum);
		return (1>_page.length ? croTools.log("getSlideByPageNum error : "+_pageNum) : _page.parent());
	}
	
	/** 해당위치 슬라이드 제거 */
	eBookCore.pageTurn.removeSlideByDir = function(_dir){ // _dir : left, right
		var _curr = $(".pageview .slideframe.current");
		var target;
		while( 0 < (target = "left"===_dir ? _curr.prev() : _curr.next()).length ){
			target.detach();
		}
	}
	
	/** 슬라이드 이동 처리 */
	eBookCore.pageTurn.moveSlide = function(_pageNum){
		
		var pages = eBookCore.pageTurn.getVisiblePageNumbers();
		if(1>pages.length){ // ★ 슬라이드가 없을 경우 새로 추가
			
			eBookCore.pageTurn.addSlide	(_pageNum)
												.addClass	("current")
												.css			("left","0px");
			
			_pageNum = parseInt( $(".pageview .slideframe .page").eq(0).attr("page") );
			
			// 좌우 슬라이드 추가
			var _offsetNum = eBookCore.func.nowPageViewSingle() ? 1 : 2;
			
			// prev slide
			if(1<_pageNum){
				eBookCore.pageTurn.addSlide(Math.max(_pageNum - _offsetNum, 1));
			}
			// next slide
			if(eBookData.totalPageNum>_pageNum){
				eBookCore.pageTurn.addSlide(Math.min(_pageNum + _offsetNum, eBookData.totalPageNum));
			}
			
			return croTools.log("initialized all slides"); /***/
		}
		
		
		for(var i=0; i<pages.length; ++i){ // 현재 페이지와 동일하면 이동 중단
			if(pages[i] === _pageNum){ return; }
		}
		
		// 이동방향 체크
		var _slidingToLeft = (pages[0] < _pageNum);
		
		var _pageview = $(".pageview");
		
		// 슬라이딩 애니메이션 진행중이면 효과 스킵하고 바로 완료처리
		_pageview.find(".slideframe:animated").finish();
		$.doTimeout("slidingDone");

		var _oldCurrSlide = _pageview.find(".slideframe.current");
		
		var _newCurrSlide = eBookCore.pageTurn.getSlideByPageNum(_pageNum);
		if(!_newCurrSlide){ // 대상 슬라이드가 없으면 추가
			
			// 기존 위치의 슬라이드 제거
			eBookCore.pageTurn.removeSlideByDir(_slidingToLeft?"right":"left");
			
			_newCurrSlide = eBookCore.pageTurn.addSlide(_pageNum);
		}
		
		// 이동방향 슬라이드 제거
		eBookCore.pageTurn.removeSlideByDir(_slidingToLeft?"left":"right");

		// 이전 프레임 current 클래스 속성 제거
		_oldCurrSlide.removeClass("current");
		
		// 새 프레임 current 설정
		_newCurrSlide.addClass("current");
		
		// 다음 슬라이드 추가
		eBookCore.pageTurn.addSlide( _pageNum + ( (eBookCore.func.nowPageViewSingle() ? 1 : 2) * (_slidingToLeft ? 1 : -1) ) );
		
		// 현재 페이지와 대상 슬라이드 애니메이션 처리
		var _movePos	= (_slidingToLeft?-1:1) * croTools.getClientSize().width;
		_oldCurrSlide.animate( {left : _movePos},	eBookCore.pageTurn.slidingStyle);
		_newCurrSlide.animate( {left : 0},				eBookCore.pageTurn.slidingStyle);
		
		// 페이지 넘김완료 이벤트 추가
		$.doTimeout("slidingDone", eBookCore.pageTurn.slidingStyle.duration, eBookCore.pageTurn.slidingDone);
	};
	
	/** 슬라이딩 완료 처리 */
	eBookCore.pageTurn.slidingDone = function(){
		croTools.log("slidingDone");
		
		// 타이머 초기화
		eBookCore.pageTurn.moveSlideTimer = null;
	
		var _currSlide	= $(".pageview .slideframe.current");
		var _currPages	= _currSlide.find("[page]");
		var _currNum		= [	parseInt(_currPages.first().attr("page")),
												parseInt(_currPages.last().attr("page"))		];
		
		// 좌우 페이지 번호 체크하여 인접한 페이지가 아니면 새로 추가
		var _prevPageNum	= _currNum[0]-1;
		var _nextPageNum	= _currNum[1]+1;
		
		var _prevPages = _currSlide.prev().find("[page]");
		if(0<_prevPages.length && _prevPageNum !== parseInt(_prevPages.last().attr("page"))){
			eBookCore.pageTurn.removeSlideByDir("left");
			eBookCore.pageTurn.addSlide(_prevPageNum);
		}
		
		var _nextPages = _currSlide.next().find("[page]");
		if(0<_nextPages.length && _nextPageNum !== parseInt(_nextPages.first().attr("page"))){
			eBookCore.pageTurn.removeSlideByDir("right");
			eBookCore.pageTurn.addSlide(_nextPageNum);
		}
		
		// 각 컴포넌트 페이지번호 갱신하기 위한 이벤트 호출
		eBookCore.func.componentsReset();
		
		// 본문 퀄리티 수정
		eBookCore.pageTurn.imageResampling();
	};
	
	/** 현재 슬라이드의 본문이미지 퀄리티 수정(for IE) */
	eBookCore.pageTurn.imageResampling = function(){
		croTools.isMSIE() && $(".pageview .slideframe.current img.target").each(function(i,e){
			if("data"===e.src.substr(0,4)){ return; }
			croTools.imageResampling(e,0.55);
		});
	};
	
	// ★ 현재 페이지 번호 확인하여 로딩하기
	eBookCore.pageTurn.moveSlide();
	
	// 페이지 사이즈 조정
	eBookCore.pageTurn.resize();
};


/**	★ 페이지 갱신( 페이지 번호 변경시 호출 )
**/
eBookCore.pageTurn.update = function(pageNum){
	croTools.log("move to : "+pageNum);
	eBookCore.pageTurn.moveSlide(pageNum);
};


/**	★ 현재 화면에 표시된 페이지 번호들 반환
**/
eBookCore.pageTurn.getVisiblePageNumbers = function(){
	var retNumbers = [];
	
	var currPages	= $(".pageview .slideframe.current .page");
	for(var i=0; i<currPages.length; ++i){
		retNumbers.push( parseInt( currPages.eq(i).attr("page") ) );
	}

	return retNumbers;
};


/**	★ 페이지에 북마크 이미지 추가
**/
eBookCore.pageTurn.addBookmarkToPage = function(pageNum, addObj){
	
	var pageEl = $(".pageview .slideframe .page.p"+pageNum);
	
	// 올바른 위치에 출력하기 위해 div 태그로 한 번 감싸서 추가
	var coverEl = 0<pageEl.find(".bookmark_cover").length ? pageEl.find(".bookmark_cover") : $("<div class='bookmark_cover' />").css({ "position" : "relative" });
	
	coverEl.append( addObj );
	pageEl.prepend( coverEl );
};


/**	★ 페이지 표시 크기 반환
**/
eBookCore.pageTurn.getZoomRatio = function(type){
	//return $(".pageview .slideframe.current .page .target").first().width() / eBookCore.pageOrigWidth;	
	var pageEl = $(".pageview .slideframe.current .page .target").first();
	if(type){
		return ("w"===type.toLowerCase()) ? pageEl.width() / eBookCore.pageOrigWidth : pageEl.height() / eBookCore.pageOrigHeight;
	}
	return (eBookCore.pageOrigWidth > eBookCore.pageOrigHeight) ? pageEl.width() / eBookCore.pageOrigWidth : pageEl.height() / eBookCore.pageOrigHeight;
};


/**	페이지 출력 창 크기 조정
**/
eBookCore.pageTurn.resize = function(){
	croTools.log("pageTurn resize");
	
	var _viewport = $('.pageview');
	if(1>_viewport.length){ return; }
	
	// 기존 슬라이드 전부 제거하고 새로 추가( 사이즈 변경시 페이지 구성이 변함 )
	_viewport.find(".slideframe").detach();
	eBookCore.pageTurn.moveSlide();
	// 북마크도 다시 추가
	eBookCore.func.bookmarkUpdate();
	
	// 컴포넌트 리셋
	eBookCore.func.componentsReset();
};


/**	지정한 페이지 출력 크기 조정
**/
eBookCore.pageTurn.resizeByPage = function(e){
	
	var page = $(e);
	
	var _slideframe		= page.closest(".slideframe");
	var _frameWidth		= _slideframe.width();
	var _frameHeight	= _slideframe.height();
	
	var _viewSingle	= eBookCore.func.nowPageViewSingle();
	var _isLeftPage	= !page.prev().length;
	
	var _imgWidth = eBookCore.thumbRatio*_frameHeight;
	
	var _targetImg = page.find(".target");
	
	if(_imgWidth<_frameWidth){ // 페이지 비율과 표시영역 비율을 비교하여 너비/높이 어디에 맞출지 판단
		page.css({
			width		: _imgWidth+"px",
			height	: "100%",
		});
		_targetImg.css({width:"auto", height:"100%"});
	
	}else{
		page.css({
			top:0, bottom:0, margin:'auto 0px',
			width : "100%",
			height : 1/eBookCore.thumbRatio * _frameWidth,
		});
		_targetImg.css({width:"100%", height:"auto"});
	}
	
	var _pageNum = parseInt(page.attr("page"));
	if(_viewSingle || page.hasClass("loader") || (1===_pageNum && eBookData.pageView.cover) ){
		page.css("left", (50-page.width()/_frameWidth/2*100)+"%"); // 퍼센트로 중앙정렬
		page.css("text-align", "center");
	}else{
		page.css(_isLeftPage?"right":"left", "50%");
		page.css("text-align", eBookData.pageView.cover
														? (_pageNum%2?"left":"right")		// left : 2,4,6,8 ...
														: (_pageNum%2?"right":"left"));	// left : 1,3,5,7,9 ...
	}
}
//  2018-07-30 슬라이드 모드 사용시추가 정란
eBookCore.plugins.setPagePos = function() {
    var imgEl = $(".viewframe  img.target");
//    var imgEl = $(".viewframe  img.target");

    if (!imgEl.length) {
        return;
    }
    var _wndSize = croTools.getClientSize();
    var _pagePos = imgEl.offset();

    imgEl.css({ // 화면 밖으로 벗어나지 않게 좌표 보정
        left: croTools.rangeValue(_pagePos.left, imgEl.width() < _wndSize.width ? 0 : _wndSize.width - imgEl.width(),
            imgEl.width() > _wndSize.width ? 0 : _wndSize.width - imgEl.width()),
        top: croTools.rangeValue(_pagePos.top, imgEl.height() < _wndSize.height ? 0 : _wndSize.height - imgEl.height(),
            imgEl.height() > _wndSize.height ? 0 : _wndSize.height - imgEl.height()),
    });
};



// ★페이지 넘김 초기화
eBookCore.pageTurn.init();
