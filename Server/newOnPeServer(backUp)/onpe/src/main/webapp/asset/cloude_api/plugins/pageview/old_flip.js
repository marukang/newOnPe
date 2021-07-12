	/**-------------------------------------------------------------------------------------------------
*								Turn.js 기반 페이지 넘김 스크립트 
*																					Date	: 2018-06
*																					Author	:  정란 
**/

/**	★ 최초 열기시 1회 초기화
	pageframe div를 추가하여 모바일에서 확대시 밀리지 않도록 하였다. 
	pageview - zoom class 추가 
	pageframe - scale 조정 
	viewframe - 드래그 추가 

모바일의 경우 - 오른쪽 탭메뉴 안나오게함,  확대 취소버튼 보이기


**/


var scale =1 ;

eBookCore.pageTurn.init = function(){
	
	var _viewport = $('.pageview');
	if(1>_viewport.length){ return; }

	var pageframe = $("<div id='pageframe'></div>");    // 스케일 조정 
	_viewport.append(pageframe);

	var viewframe = $("<div class='viewframe'></div>");  // 드래그 조정 
	pageframe.append(viewframe);



	/* 확대 슬라이드 돔 추가 정란*/
	if( !croTools.isMobile() ){   // 모바일이 아닐때   
		var controlbar = $("<div id='control'><div id='slider'><span class='plus'>+</span><div id='scale'></div><span class='minus'>-</span><div class='scalebox x'>100%</div></div></div>");
	}
	if(croTools.isMobile() ){  // 모바일일때 
		var controlbar = $("<div id='control' class='ismobile'><div id='slider'><span class='plus'>+</span><div id='scale'></div><span class='minus'>-</span><div class='scalebox x'>100%</div><div class='closezoom'>x</div></div></div>");
	}
	_viewport.before(controlbar);


	// 확대용 스킨이면 확대 가능하게 설정 정란
	if (eBookData.pageView.type == 'flip'){
	    var  zoomMax = eBookSkin.options.pageZoomMax;
		if (zoomMax< 201)
		{ zoomMax = 500;
		};
		zoomMax = zoomMax/100;

	    var  zoomMin = eBookSkin.options.pageZoomMin;
		if(zoomMin <100) { zoomMin= 100 };   // 축소비율이 100% 이하로 작아지지않게 
		zoomMin = zoomMin/100;


		/* 2018-06-11 이미지 확대 정란 */
		   $('#scale').slider({
		    orientation: 'vertical', 
		    range: 'min',  
		    min: zoomMin,
		    max: zoomMax,
		    step: 0.1,
		    value: 1,
		    slide: refreshScale,
		    change: refreshScale
		   });

		  function refreshScale() {
		    scale = $('#scale').slider('value'),
		         x = $('.x');
		    zoomIn   = viewframe.closest('.zoomin');
		    x.html(Math.round(scale * 100)+'%');
		    pageframe.css('transform', 'scale(' + scale + ')');
			if (scale > 1)								// 확대되었을때
				{													
				$(".pageview").addClass( "zoomin" );
				viewframe.draggable (				// 확대 드래그 좌표값 개선  2018-12-07 
					{disabled:false },
					{ 
					drag : function(e, ui)  { 

					var dx = ui.position.left - ui.originalPosition.left;
					var dy = ui.position.top - ui.originalPosition.top;

						// 확대 배율로 나눠 위치를 조정 
					ui.position.left = ui.originalPosition.left + dx / scale;
					ui.position.top = ui.originalPosition.top + dy / scale;

					} 
				}); 


				$(".ismobile").fadeIn();
				$(".next-button").fadeOut();
				$(".previous-button").fadeOut();
				$("#bookclip").fadeOut();

				}
			else if (scale == 1 )						// 정상 비율일때 
			{														
				$(".pageview").removeClass( "zoomin" );
			     viewframe.draggable({ disabled: true });
				 $(".ismobile").fadeOut();
				$(".next-button").fadeIn();
				$(".previous-button").fadeIn();
				$("#bookclip").fadeIn();
				   if (zoomIn.length >= 1) {
							   eBookCore.pageTurn.resize();
							} else {
							   eBookCore.plugins.setPagePos();
							}

			};
	
	  	};

	};

/* 버튼으로 배율 조정 2018-07-10 정란  */

	$("#control span.plus").on("touchstart click", function(){ 
			btn_value = $( "#scale" ).slider( "value" );
			btn_value = btn_value+0.2;
			 $( "#scale" ).slider( "option", "value", btn_value);
	});
	$("#control span.minus").on("touchstart click", function(){ 
			btn_value = $( "#scale" ).slider( "value" );
			btn_value = btn_value-0.2;
			 $( "#scale" ).slider( "option", "value", btn_value);
	});
	$("#control div.closezoom").on("touchstart click", function(){ 
			 $( "#scale" ).slider( "option", "value", 1);
 			eBookCore.pageTurn.resize();
	});


// 모바일 핀치 확대 2018-07-17 정란  (핀치 재수정 2019-05-13)
	viewframe.on("pinching",function(e,i){
//		$("#scale").slider( "option", "value", Math.pow(Math.abs(i.distance), 1.1) * 0.01);
		btn_value = $( "#scale" ).slider( "value" );
		btn_value = btn_value + i.distance*0.003;
		$("#scale").slider( "option", "value", btn_value); //Math.pow(Math.abs(i.distance), 1.1) * 0.01);
//		$("#scale").slider( "option", "value", Math.pow(i.distance, 1.1) * 0.01);
		if(btn_value <= 1 )
		{ eBookCore.pageTurn.resize();
		}

});   

/* =================== */

	// 20180305 좌우 .바로가기 부분 페이지 
	var nextbutton = $("<div />", {
			"ignore"	: "1",
			"class"	: "next-button",
			css		: {	
				'position':'absolute',
				'top': '250px',
				'right': '10px',
				'width': '60px',
				'height': '300px',
				'z-index': '99',
				'cursor': 'pointer'
			}
	})
	.on(eBookCore.eventType.click,function(){ /** 클릭시 다음 화면 */
			eFnc.gotoNext();
			// 페이지 사이즈 조정
			eBookCore.pageTurn.resize();
			eBookCore.plugins.setPagePos();

	});
	_viewport.append(nextbutton);

	var previousbutton = $("<div />", {
			"ignore"	: "1",
			"class"	: "previous-button",
			css		: {	
				'position':'absolute',
				'top': '250px',
				'left': '10px',
				'width': '60px',
				'height': '300px',
				'z-index': '99',
				'cursor': 'pointer'
			}
	})
	.on(eBookCore.eventType.click,function(){ /** 클릭시 다음 화면 */
			eFnc.gotoPrev();
		// 페이지 사이즈 조정
		eBookCore.pageTurn.resize();

		eBookCore.plugins.setPagePos();


	});
	_viewport.append(previousbutton);


	// 페이지 사이즈 조정
	eBookCore.pageTurn.resize()
	
	
	/* 페이지 추가 */
	eBookCore.pageTurn.addPage = function(pageNum) {
		//croTools.log("addPage : "+pageNum);
		if (!viewframe.turn('hasPage', pageNum)) {
			
			var element = $('<div class="loader" style="background-color:white; " />') // 로딩 화면을 먼저 추가하고 본문 페이지 이미지를 로딩함
										.html(	'<img class="loading" src="'+eBookCore.path.pageview + 'turnjs/loading.gif'+'" style="position:absolute; left:0px; top:0px; right:0px; bottom:0px; margin:auto; " />' );
			
			if (viewframe.turn('addPage', element, pageNum)) {
				eBookCore.pageTurn.loadPage(element, pageNum);
			}
		}
	};
	
	/* 본문 페이지 로딩 */
	eBookCore.pageTurn.loadPage = function(element, pageNum) {
		croTools.log("loadPage : "+pageNum);

		var _displaySingle	= eBookCore.func.nowPageViewSingle();

		var pExt = eBookData.pageExt;
		var css_width = '100%';
		var css_height = '100%';
		//if(croTools.isMSIE()) {
			if(eBookData.svgUsage == true || pExt == "svg") {
				pExt = "svg";
				css_width = '100%';
				css_height = "auto";
			}
		//}

		// 20180228 페이지 그라데이션
		var _addgradient = $("<div />", {
				"class"	: "page_center_gradient",
				css		: {	
					'width': '100%',
					'height': '100%'
				}
		})


		var _addImg = $("<img />", {
			"src"	: eBookCore.path.pages + pageNum + "."+pExt,
			"class"	: "target",
			css		: {	
				'width': css_width,
				'height': css_height
			}
		})

		
		/** 이미지 로딩 완료 처리 */
		var loadingComplete = function(){
			element.removeClass("loader");
			element.find("img.loading").detach();

			// 20180302 페이지 그라데이션
			if(eBookData.pageshadow == true) {
				//console.log('eBookData totalPageNum ======================= '+eBookData.totalPageNum);
				if(eBookData.totalPageNum != pageNum && pageNum != 1) {
					element.append( _addgradient );

					//console.log('_displaySingle ======================= '+_displaySingle);
					if(_displaySingle == true) {
						//$("#page_center_gradient_"+pageNum).hide();
						$(".page_center_gradient").hide();
						
					} 
				}
			}

			element.append( _addImg );
			
			// ★ 페이지 컨텐츠 로딩
			eBookCore.func.loadPageContents(element, pageNum);
			
			if(0<$("#bookclip_pc").length){
				if(croTools.isMobile()){
					$("#bookclip_pc").detach();
				}else{
					$("#bookclip_pc").attr("id","bookclip");
				}
			}
			
			if(0<$("#bookclip_mobile").length){
				if(!croTools.isMobile()){
					$("#bookclip_mobile").detach();
				}else{
					$("#bookclip_mobile").attr("id","bookclip");
				}
			}
			
			var _pageEl=$(".page-wrapper[style*='z-index: "+eBookData.totalPageNum+";']");
			_pageEl = parseInt(_pageEl.first().attr("page")) < parseInt(_pageEl.last().attr("page")) ? _pageEl.last() : _pageEl.first();

			if(0<_pageEl.length) $("#bookclip").css({
				left		: _pageEl.offset().left+_pageEl.width(),
				top		: _viewport.offset().top +20,
				display	: 'block',
				position: 'absolute',
				zIndex	: 5
			});


		};
		
		// 본문 이미지 로딩이 끝나면 로딩페이지와 교체
		croTools.canHTML5() ? _addImg.load(loadingComplete) : loadingComplete(); // IE8 이하 버전에서 load 이벤트가 제대로 동작하지 않으므로 페이지 이미지로 바로 교체
	};


	// ★ turn.js 기능 적용
	viewframe.turn({
		page			: eBookCore.currentPageNum,
		pages			: eBookData.totalPageNum,
		display		: eBookCore.func.nowPageViewSingle() ? "single" : "double",
		duration	: eBookData.pageView.duration,
		elevation	: 0,		// Elevation
		gradients	: true,	// Enable gradients
		autoCenter: true,	// Auto center this flipbook 
		when			: {

			start : function(event, pageObject, corner){
				croTools.log("page turn start");
				
				var _pageEl=$(".page-wrapper[style*='z-index: "+eBookData.totalPageNum+";']");
				_pageEl = parseInt(_pageEl.first().attr("page")) < parseInt(_pageEl.last().attr("page")) ? _pageEl.last() : _pageEl.first();
				if(0<_pageEl.length) $("#bookclip").css({
					left		: _pageEl.offset().left+_pageEl.width(),
					top		:_viewport.offset().top+20
				});
			},
			
			turned : function(e, pageNum, pageObj) {
				croTools.log("page turned : "+pageNum);
				eBookCore.func.setCurrentPageNum(pageNum); // 페이지를 직접 드래그하여 넘길 경우 현재 페이지 번호 설정하기 위해 추가
				eBookCore.func.componentsReset();// 페이지 넘김 후 새 페이지 번호로 화면 갱신
				
				// 20180306 1페이지 또는 끝 페이지 일때 

					if(eBookCore.currentPageNum == 1 || eBookCore.currentPageNum == eBookData.totalPageNum) {
						eBookCore.pageTurn.resize();
					}

				
				/** 확대축소 이벤트 재등록 : turnjs 특성상 사라진 페이지를 다시 추가하면 이전 이벤트가 제거되어있으므로 재등록함 */
				var _viewport = $('.pageview');
				_viewport.off(eBookCore.eventType.dblclick)
					.on(eBookCore.eventType.dblclick, function(e){
							if ( _viewport.hasClass('zoomin')){
								 $( "#scale" ).slider( "option", "value", 1 );
								_viewport.removeClass( "zoomin" );
								eBookCore.pageTurn.resize();
								eBookCore.plugins.setPagePos();
							}
							else{
							_viewport.addClass( "zoomin" );
							 $( "#scale" ).slider( "option", "value", 1.5 );
							};

					})
				;

			},

			missing : function (e, pages) { // 로딩 안된 페이지를 읽음
				//croTools.log("page missing");
				for (var i = 0; i < pages.length; ++i) {
					eBookCore.pageTurn.addPage( pages[i] );
				}
			}
		}
	});
	
};


	  


/**	★ 페이지 갱신( 페이지 번호 변경시 호출 )
**/
eBookCore.pageTurn.update = function(pageNum){

	var _frame = $(".pageview .viewframe");
	if(!_frame.turn){ return; }
	
	return _frame.turn("page") !== pageNum ? _frame.turn("page", pageNum) : eBookCore.pageTurn.resize(); // 페이지 번호가 변하지 않았으면 리사이징 호출임
};


/**	★ 현재 화면에 표시된 페이지 번호들 반환
**/
eBookCore.pageTurn.getVisiblePageNumbers = function(){
	var retNumbers = [];
	$(".pageview .viewframe [page]:visible").each(function(i,e){
		if( eBookData.totalPageNum === parseInt( $(e).css("z-index") ) ){
			retNumbers.push( parseInt( $(e).attr("page") ) );
		}
	});
	return retNumbers;
};


/**	★ 페이지에 북마크 이미지 추가
**/
eBookCore.pageTurn.addBookmarkToPage = function(pageNum, addObj){
	$(".pageview .viewframe .page.p"+pageNum).append( addObj );
};


/**	★ 페이지 표시 크기 반환
**/
eBookCore.pageTurn.getZoomRatio = function(type){
	var _page = $(".pageview .viewframe [page]:visible").first();
	//return _page.width() / eBookCore.pageOrigWidth;
	if(type){
		return ("w"===type.toLowerCase()) ? _page.width() / eBookCore.pageOrigWidth : _page.height() / eBookCore.pageOrigHeight;
	}
	return (eBookCore.pageOrigWidth > eBookCore.pageOrigHeight) ? _page.width() / eBookCore.pageOrigWidth : _page.height() / eBookCore.pageOrigHeight;
};


/**	페이지 출력창 사이즈 조정
**/
eBookCore.pageTurn.resize = function(){
	
	var _viewport = $('.pageview');
	if(1>_viewport.length){ return; }
	/*
	* 2017.5.23 김대원 : 가로가 더 큰 이미지인 경우 화면 표시 조정
	*/
    var _imageRate = eBookCore.pageOrigWidth / eBookCore.pageOrigHeight;
    var _frameWidth = 0;
	var _frameWidthSingle = 0;
    var _frameHeight = 0;

	var viewportHeight = _viewport.height() ;
	var viewportWidth = _viewport.width();

	// 20180228 싱글 더블 
	var _displaySingle	= eBookCore.func.nowPageViewSingle();


	// 20180228 가운데 부분 싱글이면 삭제 더불이면 부활
	if(_displaySingle == true) {
		$(".page_center_gradient").hide();

	} else {
		$(".page_center_gradient").show();

	}

    if (_imageRate <= 1.0) {
		viewportHeight = parseInt(viewportHeight -40);
        _frameWidth = parseInt(viewportHeight * eBookCore.thumbRatio * (_displaySingle ? 1 : 2));
		_frameWidthSingle = parseInt(viewportHeight * eBookCore.thumbRatio);

		// 			//if(croTools.isMSIE()) {
		if(eBookData.svgUsage == true || eBookData.pageExt == "svg") {
			//_frameHeight = viewportHeight * (_displaySingle ? 0.977 : 1);
			_frameHeight = viewportHeight * (_displaySingle ? 1 : 1);
		} else {
			_frameHeight = viewportHeight;
		}
    } else {
		viewportHeight = parseInt(viewportHeight - 40 - (_displaySingle ? 0 : 30));

        //_frameWidth = parseInt(viewportHeight * eBookCore.thumbRatio * (_displaySingle ? 1 : 2) * 0.8);
        //_frameHeight = viewportHeight * 0.9;

        _frameWidth = parseInt(viewportHeight * eBookCore.thumbRatio * (_displaySingle ? 1 : 2) );
		_frameWidthSingle = parseInt(viewportHeight * eBookCore.thumbRatio);
        _frameHeight = parseInt(viewportHeight);
    }

	//console.log("OW:"+eBookCore.pageOrigWidth+"===OH:"+eBookCore.pageOrigHeight+"===R:"+eBookCore.thumbRatio);
	//console.log(eBookCore.pageOrigWidth +"===================="+eBookCore.pageOrigHeight);
	
	if( _frameWidth > viewportWidth ){ // 페이지 표시 너비가 뷰 너비를 넘어서면 너비를 기준으로 높이를 설정
		_frameHeight	= parseInt( viewportWidth / _frameWidth * _frameHeight );
		_frameWidth	= viewportWidth;
		_frameWidthSingle = viewportWidth;
	}

	//console.log('frameHeight ======================= '+_frameHeight);
	//console.log('viewportHeight ======================= '+viewportHeight);
	//console.log('viewportWidth ======================= '+viewportWidth);
	//console.log('frameHeight ======================= '+_frameHeight);
	//console.log('frameWidth ======================= '+_frameWidth);

	var _frameLeft		= ( viewportWidth - _frameWidth ) / 2;
	var _frameTop		= ( viewportHeight - _frameHeight ) / 2;

	var viewframe = $(".pageview .viewframe").css({
		left	: (_frameLeft)	+ 'px',
		top		: (_frameTop		+20)	+ 'px'
	});
	//console.log('_frameLeft ======================= '+_frameLeft);

	//width


		// eBookData.totalPageNum 
//		var _pnWidthButton		= ( _frameWidth ) / (_displaySingle ? 4 : 8) ;    2019-01-08 jr
		var _pnWidthButton		= ( _frameWidth ) / (_displaySingle ? 6 : 12) ;

		var _pnLeft = _frameLeft;

		if(eBookCore.currentPageNum == 1 || eBookCore.currentPageNum == eBookData.totalPageNum) {
			_pnLeft	= (viewportWidth - (_frameWidthSingle )) / 2;
		} else {
			;
		}

		//console.log('eBookCore.currentPageNum ======================= '+eBookCore.currentPageNum);
		//console.log('eBookData.totalPageNum ======================= '+eBookData.totalPageNum);
		//console.log(' _frameLeft ======================= '+_frameLeft);
		//console.log(' _pnLeft ======================= '+_pnLeft);

		//console.log(' _pnWidthButton ======================= '+_pnWidthButton);

		//var _pnWidthButton		= ( _frameWidth ) / (_displaySingle ? 4 : 8) ;
		var _previousButton = $(".pageview .previous-button").css({
			left		: (_pnLeft)	+ 'px',
			top		: (_frameTop		+120)	+ 'px',
			height	: (_frameHeight - 200)	+ 'px',
			width		: _pnWidthButton + 'px',
		});
		var _nextButton = $(".pageview .next-button").css({
			right		: (_pnLeft)	+ 'px',
			top		: (_frameTop		+120)	+ 'px',
			height	: (_frameHeight - 200)	+ 'px',
			width		: _pnWidthButton + 'px',
		});


	//console.log('viewframe children length ======================= '+viewframe.children().length);

	if(0<viewframe.children().length){
		//viewframe.turn("size",		_frameWidth-40, _frameHeight-40				);
		viewframe.turn("size",		_frameWidth, _frameHeight				);
		viewframe.turn("display",	_displaySingle ? "single" : "double"	);
		
		// 단면보기시 뒷면이 흰색이 표시되게 수정
		viewframe.find(".p-temporal").css({backgroundColor:'white'});
	}

	// 컴포넌트 리셋
	eBookCore.func.componentsReset();
	
	var _pageEl=$(".page-wrapper[style*='z-index: "+eBookData.totalPageNum+";']");
	if(0<_pageEl.length){
		_pageEl = parseInt(_pageEl.first().attr("page")) < parseInt(_pageEl.last().attr("page")) ? _pageEl.last() : _pageEl.first();
		var marginLeft = viewframe.css('margin-left').replace(/[^-\d\.]/g, '');

		// 전체 싱글일때  북클립 처리 jr 
		var _displaySingle	= eBookCore.func.nowPageViewSingle();
		if (_displaySingle || !(marginLeft == 0) )  // 싱글페이지 일때,  한장만 나오는 페이지일때 (turnjs에서 싱글페이지일 경우 marginleft 값이 들어감)  
		{
			var bookclipleft = ($(window).width() / 2 ) + (_pageEl.width()/2) ; 
			$("#bookclip").css({ 
			left	 : bookclipleft,
			top	:_viewport.offset().top +20,
			height :viewframe.height()
			});
		}
		else {
		$("#bookclip").css({
			left	: _pageEl.offset().left+_pageEl.width(),
			top	:_viewport.offset().top +20,
			height:viewframe.height()
		});
		}
	}

};


/** 2018-06-11 페이지 위치를 화면 안으로 강제 시킴 추가 zoomview 에서 가져옴 정란 */
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


/** 휠 확대축소 이벤트 처리 함수   2018-07-11 정란 zoomview에서 가져옴 */
eBookCore.plugins.setInOut = function(_delta, _ratio) {
    eBookCore.plugins.zoomview.ratio = 0 < _delta ? Math.min( /*max*/ 10, eBookCore.plugins.zoomview.ratio + _ratio) :
        Math.max( /*min*/ 0.01, eBookCore.plugins.zoomview.ratio - _ratio);

    var imgEl = $(".zoomview img.target");
    var _wndSize = croTools.getClientSize();

    // 줌 페이지가 화면보다 작으면 확대기능 해제
    if (0 > _delta && _wndSize.width > imgEl.width() && _wndSize.height > imgEl.height()) {
        return eBookCore.plugins.zoomview.close();
    }

    var _pagePos = imgEl.offset();
    var _wndCenter = {
        x: _wndSize.width / 2,
        y: _wndSize.height / 2
    };
    var _centerRatio = {
        x: (_pagePos.left - _wndCenter.x) / imgEl.width(),
        y: (_pagePos.top - _wndCenter.y) / imgEl.height()
    };

    // 현재 이미지 배율 갱신
    imgEl.css({
        width: eBookCore.plugins.zoomview.origSize.width * eBookCore.plugins.zoomview.ratio,
        height: eBookCore.plugins.zoomview.origSize.height * eBookCore.plugins.zoomview.ratio,
    });

    // 배율 표시값 갱신
    $(".zoomviewRatio").text(parseInt(eBookCore.plugins.zoomview.ratio * 100) + "%")
        .stop()
        .css({
            opacity: 1
        })
        .doTimeout(1000, function() {
            this.stop().animate({
                opacity: 0
            }, 1000);
        });

    // 화면 중점 기준으로 이미지 좌표 재설정
    imgEl.css({
        left: _wndCenter.x + imgEl.width() * _centerRatio.x,
        top: _wndCenter.y + imgEl.height() * _centerRatio.y
    });
    // 창을 벗어난 경우 강제로 위치 조정
    eBookCore.plugins.setPagePos();
};







/**	turn.js 스크립트 읽기
**/
yepnope({
	test	: croTools.canHTML5(),
	yep	: [ eBookCore.path.pageview + 'turnjs/turn.min.js'],
	nope: [ eBookCore.path.pageview + 'turnjs/turn.html4.min.js'],
	complete: eBookCore.pageTurn.init
});