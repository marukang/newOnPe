/**-------------------------------------------------------------------------------------------------
*								클릭 방식 페이지 넘김 스크립트
*																					Date		: 2015.10.27
*																					Author	: 박정민
**/

/**	★ 최초 열기시 1회 초기화
**/
eBookCore.pageTurn.init = function(){
	
	var _viewport = $('.pageview');
	if(1>_viewport.length){ return; }
	
	
	/** 레이어 추가 */
	eBookCore.pageTurn.addLayer = function(pageNum) {
		
		if(undefined==pageNum){ pageNum = eBookCore.currentPageNum; }
		
		if(pageNum<1 || eBookData.totalPageNum<pageNum){ return croTools.log("addLayer out of range : "+pageNum); } // 페이지 범위 초과시 중단
		
		var _isSingle = eBookCore.func.nowPageViewSingle();
		
		if(1<pageNum && !_isSingle){ // 양면보기인 경우 커버사용유무에 따라 왼쪽 기준페이지 번호를 수정
			if(eBookData.pageView.cover){ // 1,2,4,6,8 ...
				pageNum = pageNum - (pageNum % 2);
			}else{ // 1,3,5,7,9 ...
				pageNum = pageNum + (pageNum % 2) - 1;
			}
		}
	
		var _layerEl =
			$("<div class='viewframe' />")
			.css({
				width			: _viewport.width()+"px",
				height		: "98%",
				textAlign : "center",
				display		: "inline-block",
				position	: "absolute",
				top				: "2%",
				left			: "0px",
			});
		
		// 레이어 객체 안에 페이지 추가
		eBookCore.pageTurn.addPage(_layerEl, pageNum);
		if(!_isSingle && pageNum<eBookData.totalPageNum && !(1===pageNum && eBookData.pageView.cover)){
			eBookCore.pageTurn.addPage(_layerEl, pageNum+1);
		}
		
		_viewport.append(_layerEl);
		
		return _layerEl;
	}
	
	/** 페이지 추가 */
	eBookCore.pageTurn.addPage = function(_layerEl, _pageNum) {
		croTools.log("addPage : "+_pageNum);
		if(_pageNum<1 || _pageNum>eBookData.totalPageNum){ return; }
		
		var pageEl = $('<div class="loader page p'+_pageNum+'" page="'+_pageNum+'"/>') // 로딩 화면을 먼저 추가하고 본문 페이지 이미지를 로딩함
									.css({
										display		: (eBookCore.func.nowPageViewSingle() ? "block" : "inline-block"), // 현재 화면 비율의 페이지 양,단면 표시 설정
										width			: "50%",
										height		: "100%",
										textAlign	: "center",
										position	: "absolute",
									})
									.html(	'<img class="loading" src="' + eBookCore.path.pageview + 'turnjs/loading.gif" style="position:relative; left:0px; top:50%; right:0px; bottom:0px; margin:auto; " />' );
		
		eBookCore.pageTurn.loadPage(pageEl, _pageNum); // 페이지 이미지 불러오기
		
		_layerEl.append(pageEl);
	};
	
	/** 본문 페이지 로딩 */
	eBookCore.pageTurn.loadPage = function(element, _pageNum) {
		//croTools.log("loadPage : "+pageNum);
		
		var _addImg = $("<img />", {
			"src"		: eBookCore.path.pages + _pageNum + "." + eBookData.pageExt,
			"class"	: "target",
			css			: {	width		: '100%',
									height	: '100%',
									display	: 'inline-block', }
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
			eBookCore.func.loadPageContents(element, _pageNum);
			
			// 핀치 확대 이벤트 추가
			element.on("pinchOut",function(e,i){ return (0<i.distance)&&eBookCore.plugins.zoomview.run(_addImg); });
		};
		
		 // 본문 이미지 로딩이 끝나면 로딩페이지와 교체
		croTools.canHTML5() ? _addImg.load(loadingComplete) : loadingComplete(); // IE8 이하 버전에서 load 이벤트가 제대로 동작하지 않으므로 페이지 이미지로 바로 교체
	};

	/** 페이지번호로 해당 레이어 반환 */
	// eBookCore.pageTurn.getLayerByPageNum = function(_pageNum){
		// var _page = $(".pageview .viewframe .p" + _pageNum);
		// return (1>_page.length ? croTools.log("getSlideByPageNum error : "+_pageNum) : _page.parent());
	// }
	
	/** 레이어 이동 처리 */
	eBookCore.pageTurn.moveLayer = function(_pageNum){
		
		var pages = eBookCore.pageTurn.getVisiblePageNumbers();
		for(var i=0; i<pages.length; ++i){ // 현재 페이지와 동일하면 이동 중단
			if(pages[i] === _pageNum){ return; }
		}
		
		$(".pageview .viewframe").detach();
		eBookCore.pageTurn.addLayer(_pageNum);
		eBookCore.func.componentsReset(); // 각 컴포넌트 페이지번호 갱신하기 위한 이벤트 호출
		return;
	};
	
	// ★ 현재 페이지 번호 확인하여 로딩하기
	eBookCore.pageTurn.moveLayer();
	
	// 페이지 사이즈 조정
	eBookCore.pageTurn.resize();
};


/**	★ 페이지 갱신( 페이지 번호 변경시 호출 )
**/
eBookCore.pageTurn.update = function(pageNum){
	croTools.log("move to : "+pageNum);
	eBookCore.pageTurn.moveLayer(pageNum);
};


/**	★ 현재 화면에 표시된 페이지 번호들 반환
**/
eBookCore.pageTurn.getVisiblePageNumbers = function(){
	var retNumbers = [];
	
	var currPages	= $(".pageview .viewframe .page");
	for(var i=0; i<currPages.length; ++i){
		retNumbers.push( parseInt( currPages.eq(i).attr("page") ) );
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


/**	★ 페이지 표시 크기 반환
**/
eBookCore.pageTurn.getZoomRatio = function(type){
	//return $(".pageview .viewframe .page .target").first().width() / eBookCore.pageOrigWidth;
	var pageEl = $(".pageview .viewframe .page .target").first();
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
	_viewport.find(".viewframe").detach();
	eBookCore.pageTurn.moveLayer();
	// 북마크도 다시 추가
	eBookCore.func.bookmarkUpdate();
};


/**	지정한 페이지 출력 크기 조정
**/
eBookCore.pageTurn.resizeByPage = function(e){
	
	var page = $(e);
	
	var _viewframe		= page.closest(".viewframe");
	var _frameWidth		= _viewframe.width();
	var _frameHeight	= _viewframe.height();
	
	var _viewSingle	= eBookCore.func.nowPageViewSingle();
	var _fitWidth		= (_frameWidth*(_viewSingle?1:0.5) < eBookCore.thumbRatio*_frameHeight);
	
	var _imgWidth = eBookCore.thumbRatio*_frameHeight;
	
	var _left = 0;
	if(1<_viewframe.find(".page").length){ // 양면
		_left = _frameWidth/2 - (0<page.prev().length ? 0 : _imgWidth);
	}else{
		_left = (_frameWidth-_imgWidth)/2;
	}
	
	page.css({
		width		: _imgWidth+"px",//_viewSingle	? "100%"	: "50%",
		height	: _fitWidth		? "auto"	: "100%",
		left		: _left+"px",
	});
	
	page.find(".target").css({
		width		: _fitWidth	? "100%"	: "auto",
		height	: _fitWidth	? "auto"	: "100%",
	});
	
	var _pageNum = parseInt(page.attr("page"));
	
	setTimeout(function(){
	
		if(_viewSingle || page.hasClass("loader") || (1===_pageNum && eBookData.pageView.cover) ){
			page.css("text-align", "center");
			
		}else{
			if( eBookData.pageView.cover ){
				page.css("text-align", _pageNum%2?"left":"right"); // left : 2,4,6,8 ...
			}else{
				page.css("text-align", _pageNum%2?"right":"left"); // left : 1,3,5,7,9 ...
			}
		}
	}, 10);
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
