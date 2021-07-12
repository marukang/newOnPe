/**-------------------------------------------------------------------------------------------------
*								스크롤 방식 페이지 넘김 스크립트
*																					Date	: 2015.05.26
*																					Author	: 박정민
**/

/**	★ 최초 열기시 1회 초기화
**/
eBookCore.pageTurn.init = function(){
	
	var _viewport = $('.pageview');
	if(1>_viewport.length){ return; }
	
	var viewframe = $("<div class='viewframe' style='overflow-x:hidden; overflow-y:auto; text-align:center; ' ></div>");
	
	/** 스크롤시 페이지 갱신 이벤트 추가 */
	viewframe.on("scroll", function(e){
		//croTools.log("scroll");
		var _pageNum = eBookCore.pageTurn.getPageNumByScrollPos();
		eBookCore.func.setCurrentPageNum( _pageNum );
		eBookCore.pageTurn.loadPageByScrollPos( _pageNum );
	});
	_viewport.append(viewframe);
	
	// 페이지 사이즈 조정
	eBookCore.pageTurn.resize(); 

	/** 페이지 추가 */
	eBookCore.pageTurn.addPage = function(pageNum) {
		//croTools.log("addPage : "+pageNum);
		if(pageNum<1 || pageNum>eBookData.totalPageNum){ return; }
		
		var element = $('<div class="loader page p'+pageNum+'" page="'+pageNum+'"/>') // 로딩 화면을 먼저 추가하고 본문 페이지 이미지를 로딩함
									.css({
										display		: (eBookCore.func.nowPageViewSingle() ? "block" : "inline-block"), // 현재 화면 비율의 페이지 양,단면 표시 설정
										width			: "50%",
										height		: "100%",
										textAlign	: "center",
									})
									.html(	'<img class="loading" src="'+eBookCore.path.pageview + 'turnjs/loading.gif" ' +	'style="position:relative; left:0px; top:50%; right:0px; bottom:0px; margin:auto; " />' );
		
		viewframe.append(element);
	};
	
	
	/** 스크롤된 범위의 본문 페이지 로딩 */
	eBookCore.pageTurn.loadPageByScrollPos = function(_pageNum) {
		if(!_pageNum){ _pageNum = eBookCore.pageTurn.getPageNumByScrollPos(); }
		
		for(var i=Math.max(1,_pageNum-3); i<Math.min(_pageNum+4,eBookData.totalPageNum+1); ++i){ // 전후 3페이지를 미리 읽게 함
			var element = viewframe.find(".loader.p"+i);
			if(0<element.length){
				eBookCore.pageTurn.loadPage(element, i);
			}
		}
	}
	
	/** 본문 페이지 로딩 */
	eBookCore.pageTurn.loadPage = function(element, pageNum) {
		//croTools.log("loadPage : "+pageNum);
		
		var _addImg = $("<img />", {
			"src"	: eBookCore.path.pages + pageNum + "."+eBookData.pageExt,
			"class"	: "target",
			css		: {	width		: '100%',
								height	: '100%' }
		})
		.on(eBookCore.eventType.dblclick,function(){ /** 더블 클릭시 확대축소 활성화 */
			eBookCore.plugins.zoomview.run(_addImg);
		});
		
		/** 이미지 로딩 완료 처리 */
		var loadingComplete = function(){
			element.removeClass("loader");
			element.find("img.loading").detach();
			element.append( _addImg );
			eBookCore.pageTurn.resizeByPage(element); // 불러온 페이지 크기 재조정
			
			// ★ 페이지 컨텐츠 로딩
			eBookCore.func.loadPageContents(element, pageNum);
		};
		
		 // 본문 이미지 로딩이 끝나면 로딩페이지와 교체
		croTools.canHTML5() ? _addImg.load(loadingComplete) : loadingComplete(); // IE8 이하 버전에서 load 이벤트가 제대로 동작하지 않으므로 페이지 이미지로 바로 교체
	};
	
	
	// 전체 페이지 영역 모두 추가(실제 이미지는 스크롤 위치에 따라 부분 로딩)
	for(var i=1; i<=eBookData.totalPageNum;++i){
		eBookCore.pageTurn.addPage(i);
	}
	eBookCore.pageTurn.loadPageByScrollPos();
};


/**	★ 페이지 갱신( 페이지 번호 변경시 호출 )
**/
eBookCore.pageTurn.update = function(pageNum){
	return (pageNum !== eBookCore.pageTurn.getPageNumByScrollPos()) && eBookCore.pageTurn.setScrollByPageNum(pageNum);
};


/**	★ 현재 화면에 표시된 페이지 번호들 반환
**/
eBookCore.pageTurn.getVisiblePageNumbers = function(){
	var retNumbers = [];
	
	var _viewframe	= $(".pageview .viewframe");
	var _pages			= _viewframe.find(".page");
	for( var i=0; i< _pages.length; ++i ){
		var _pageTop	= _pages.eq(i).position().top;
		var _pageH		= _pages.eq(i).height();
		
		if(_pageTop > _viewframe.height()){
			break;
		}else if( 0 <= _pageTop+_pageH ){
			retNumbers.push(i+1);
		}
	}
	
	return retNumbers;
};


/**	★ 페이지에 북마크 이미지 추가
**/
eBookCore.pageTurn.addBookmarkToPage = function(pageNum, addObj){
	
	var pageEl = $(".pageview .viewframe .page.p"+pageNum);
	
	// 올바른 위치에 출력하기 위해 div 태그로 한 번 감싸서 추가
	var coverEl = 0<pageEl.find(".bookmark_cover").length ? pageEl.find(".bookmark_cover") : $("<div class='bookmark_cover' />").css({ "position" : "relative" });
	
	coverEl.append( addObj );
	pageEl.prepend( coverEl );
};


/**	현재 스크롤 위치의 페이지 번호 반환
**/
eBookCore.pageTurn.getPageNumByScrollPos = function(){
	var _pages		= $(".pageview .viewframe .page");
	for(var i=0; i<_pages.length; ++i){ // 페이지의 절반 이상이 화면에 들어오면 유효한 페이지로 판단
		if( 0 <= _pages.eq(i).position().top + _pages.eq(i).height()*0.5 ){ return i+1; }
	}
	croTools.log("getPageNumByScrollPos return default page : 1");
	return 1; // 기본값
};


/**	페이지 번호에 해당하는 위치로 스크롤
**/
eBookCore.pageTurn.setScrollByPageNum = function(pageNum){
	if( isNaN(pageNum) ){ return croTools.log("invalid page number : " + pageNum); }
	
	var _viewframe	= $(".pageview .viewframe");
	
	var _targetImg	= _viewframe.find(".page.p"+pageNum);
	if(1>_targetImg.length){ return croTools.log(pageNum+" page is nothing."); }
	
	var _scrollPos	= _viewframe.scrollTop();
	var _moveTop		= _targetImg.position().top;
	
	_viewframe.animate({ scrollTop : (_scrollPos + _moveTop)}, eBookData.pageView.duration);
	
	croTools.log("setScrollByPageNum : "+pageNum+" / scrollTop : " + _viewframe.scrollTop() );
};


/**	페이지 출력 창 크기 조정
**/
eBookCore.pageTurn.resize = function(){
	
	//croTools.log("resize");
	
	var _viewport = $('.pageview');
	if(1>_viewport.length){ return; }
	
	var _frameWidth		= _viewport.width();
	var _frameHeight	= _viewport.height();
	
	if( _frameWidth > _viewport.width() ){ // 페이지 표시 너비가 뷰 너비를 넘어서면 너비를 기준으로 높이를 설정
		_frameHeight	= parseInt( _viewport.width() / _frameWidth * _frameHeight );
		_frameWidth		= _viewport.width();
	}
	
	var _frameLeft	= ( _viewport.width()		- _frameWidth		) / 2;
	var _frameTop		= ( _viewport.height()	- _frameHeight	) / 2;

	var viewframe = $(".pageview .viewframe").css({
		left		: _frameLeft		+ 'px',
		top			: _frameTop			+ 'px',
		width		: _frameWidth		+ 'px',
		height	: _frameHeight	+ 'px',
	});	
	
	// 페이지 크기 갱신
	viewframe.find(".page").each(function(i, e){
		eBookCore.pageTurn.resizeByPage(e);
	});
	
	// 컴포넌트 리셋
	eBookCore.func.componentsReset();
};


/**	지정한 페이지 출력 크기 조정
**/
eBookCore.pageTurn.resizeByPage = function(e){
	
	var viewframe			= $(".pageview .viewframe");
	var _frameWidth		= viewframe.width();
	var _frameHeight	= viewframe.height();
	
	var _viewSingle = eBookCore.func.nowPageViewSingle();
	var _fitWidth = (_frameWidth*(_viewSingle?1:0.5) < eBookCore.thumbRatio*_frameHeight);
	
	var page = $(e);
	page.css({
		display	: _viewSingle	? "block"	: "inline-block",
		width		: _viewSingle	? "100%"	: "50%",
		height	: _fitWidth		? "auto"	: "100%"
	});
	
	page.find(".target").css({
		width		: _fitWidth	? "100%"	: "auto",
		height	: _fitWidth	? "auto"	: "100%"
	});
	
	setTimeout(function(){
		if(_viewSingle || page.hasClass("loader")){
			page.css("text-align", "center");
		}else{
			if(page.position().left < 1){
				page.css("text-align", "right");
			}else
			if(page.position().left < _frameWidth*0.5 - 10/*offset*/){
				page.css("text-align", "center");
			}else{
				page.css("text-align", "left");
			}
		}
	}, 10);
}

// ★페이지 넘김 초기화
eBookCore.pageTurn.init();
