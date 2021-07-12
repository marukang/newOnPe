/**-------------------------------------------------------------------------------------------------
*											eBook Core
*																					Date	: 2015.05.19
*																					Author	: 박정민
*																					latest date : 2019-02-22 				
**/
var eBookCore = {};

/** 맴버 변수 정의&초기화 */
eBookCore.currentPageNum	= null;	// 현재 페이지 번호
eBookCore.pageOrigWidth		= 0;		// 페이지 원본 이미지 너비
eBookCore.pageOrigHeight	= 0;		// 페이지 원본 이미지 높이
eBookCore.thumbRatio			= 1;		// 섬네일 가로세로비
eBookCore.path						= {};		// 파일경로
eBookCore.eventType				= {};		// 키,마우스,터치 이벤트 속성
eBookCore.searchCountMax	= 10;		// 검색기능 사용시 한 번에 추가할 항목 제한 개수( ★페이지 단위로 체크하므로 초과될 수 있음 )
eBookCore.keyDownState		= [];		// 키입력 상태 체크

/** 서브 객체 정의 */
eBookCore.func			= {};	// 기능 함수 객체( functions.js )
var eFnc = eBookCore.func;	// 단축명 정의( skin.js 에서 활용 )

/**-------------------------------------------------------------------------------------------------
*		페이지 넘김 객체 사전 정의
*/
eBookCore.pageTurn	= {
	init									: function()								{ croTools.log("not defined : eBookCore.pageTurn.init");	 },
	update								: function(pageNum)					{ croTools.log("not defined : eBookCore.pageTurn.update"); },
	getVisiblePageNumbers	: function()								{ croTools.log("not defined : eBookCore.pageTurn.getVisiblePageNumbers"); return null;	},
	addBookmarkToPage			: function(pageNum, addObj)	{ croTools.log("not defined : eBookCore.pageTurn.addBookmarkToPage"); },
	getZoomRatio					: function()								{ croTools.log("not defined : eBookCore.pageTurn.getZoomRatio");					return 1; 		}
};

/**-------------------------------------------------------------------------------------------------
*		플러그인
*/
eBookCore.plugins			= {};

/**-------------------------------------------------------------------------------------------------
*		컴포넌트
*/
eBookCore.components	= {
	data		: [],
	
	// 외부에서 정의될 항목들
	action	: function()	{ croTools.log("not defined : eBookCore.components.action");},
	video		: function()	{ croTools.log("not defined : eBookCore.components.video"	);},
	youtube		: function()	{ croTools.log("not defined : eBookCore.components.youtube"	);} /** youtube */,	
	audio		: function()	{ croTools.log("not defined : eBookCore.components.audio"	);},
	image		: function()	{ croTools.log("not defined : eBookCore.components.image"	);},
	imageSlider	: function()	{ croTools.log("not defined : eBookCore.components.imageSlider"	);},  /** 슬라이드 이미지 */
	text		: function()	{ croTools.log("not defined : eBookCore.components.text"	);},
	link		: function()	{ croTools.log("not defined : eBookCore.components.link"	);},
	
	// 페이지 비율에 맞춰 사이즈 재조정
	resizing : function(e)	{
		e = $(e);
		var _data = eBookCore.components.data[e.attr("id")];
		//var _ratio = eBookCore.pageTurn.getZoomRatio();
		var _ratioW = eBookCore.pageTurn.getZoomRatio('w');
		var _ratioH = eBookCore.pageTurn.getZoomRatio('h');
		
		if("false"===_data.visible){
			e.css("visibility","hidden");
		}
		
		if(0<e.closest(".mejs-container").length){ // e : video,audio
			
			e.css({
				'width'		: (_ratioW * parseInt(_data.width))	+ 'px',
				'height'	: (_ratioH * parseInt(_data.height))	+ 'px'
			});
			
			e = e.closest(".mejs-container");
			e.css({
				'left'		: (_ratioW * parseInt(_data.x))			+ 'px',
				'top'			: (_ratioH * parseInt(_data.y))			+ 'px',
				'width'		: (_ratioW * parseInt(_data.width))	+ 'px',
				'height'	: (_ratioH * parseInt(_data.height))	+ 'px'
			});
			return;
		}
		
		e.css({
			'left'		: (_ratioW * parseInt(_data.x))			+ 'px',
			'top'			: (_ratioH * parseInt(_data.y))			+ 'px',
			'width'		: (_ratioW * parseInt(_data.width))	+ 'px',
			'height'	: (_ratioH * parseInt(_data.height))	+ 'px'
		});
		
		if(!isNaN(_data.textHeight)){ // text component
			e.css( 'font-size', (_ratioH * parseInt(_data.textHeight))	+ 'px' );
		}
	},
	
	// 액션 이벤트 설정
	setActionEvent : function(actionEl) {

		// 데이터형식 : { type:"action", id:"Interaction11435134959473", name:"액션1", height:"16", width:"17", y:"574", x:"900", dispatcher:"Link11435050004029", event:"onRelease", target:"Mp3Player11435050111825", action:"toggleVisible",  },
		
		var _data = eBookCore.components.data[$(actionEl).attr("id")];
		
		if(_data.action!=="toggleVisible")	{ return croTools.log("unexpected action type : "+_data.action); }	// 모르는 액션 속성이면 로그기록 후 중단
		if(_data.event!=="onRelease")	{ return croTools.log("unexpected event type : "+_data.event); }	// 모르는 이벤트 속성이면 로그기록 후 중단
		
		var type_play ;   // 비디오 오디오 타입 

		var ver_gubun;   // 3.5 cc 버전 구분 
			if(eBookData.pagearea==true || eBookData.pagearea==false  ) {
				ver_gubun="ver_CC";
			};
				
		var getElById = function(_id){ // ID에 해당하는 객체 반환 ( 미디어 예외 적용 )
			var targetEl = $("#"+_id);
			if(1>targetEl.length){ return; }
			type_play = targetEl[0].tagName;
			
			if("VIDEO"===targetEl[0].tagName
			|| "AUDIO"===targetEl[0].tagName){
				return targetEl.closest(".mejs-container");
			}
			return targetEl;
		};
		
		var dispatchEl = getElById(_data.dispatcher);
		if(!dispatchEl){ return croTools.log("action dispatcher not found : " + _data.dispatcher) }
		
		dispatchEl.on("click", function(e){
			croTools.log("action toggle");
			
			var targetEl = getElById(_data.target);
			if(!targetEl){ return croTools.log("action target not found : " + _data.target) }

			if(type_play == 'AUDIO') {																				
				if(ver_gubun != "ver_CC") {																		// audio 이면서CC 버전이 아닐때 2019-02-22 추가
					targetEl.css('visibility', targetEl.css('visibility') == 'hidden' ? 'visible' : 'hidden' );//targetEl.toggle(); 2018-12-19 오디오 수정 
				}
				else {
				audioFactory.getById(_data.target).togglePlay();
				};
			}
			else {
				targetEl.css('visibility', targetEl.css('visibility') == 'hidden' ? 'visible' : 'hidden' );//targetEl.toggle(); 2018-12-19 오디오 수정 
			}
		});
		
	},
	
	// 링크 롤오버, 클릭 이벤트 설정
	setLinkEvent : function(linkEl) {
		
		$(linkEl).hover(function(e){
			//croTools.log("link hover in");
			var _data = eBookCore.components.data[$(e.target).attr("id")];
			$(e.target).css('background-color', croTools.hexToRGBA( _data.rolloverColor.substr(0,8).replace("0x","#")		, _data.rolloverColor.substr(9)	));
		},function(e){
			//croTools.log("link hover out");
			var _data = eBookCore.components.data[$(e.target).attr("id")];
			$(e.target).css('background-color', croTools.hexToRGBA( _data.backgroundColor.substr(0,8).replace("0x","#")	, _data.backgroundColor.substr(9)	));
		});
		
		$(linkEl).off("click"); // 이전 등록이벤트 제거 후 새로 등록
		$(linkEl).on("click", eBookCore.components.openLinkByData);
	},
	
	// 링크 데이터 처리
	openLinkByData : function(e){
		/** -------------------------- 20181228 -------------------------- */
		//	var _link = eBookCore.components.data[$(e.target).attr("id")].link.split("|");	
		var _link;
		if( $(e.target).attr("id") === undefined || $(e.target).attr("id").length == 0 ) _link = $(e.target).attr("data-link").split("|");	//	슬라이드 이미지 
		else _link = eBookCore.components.data[$(e.target).attr("id")].link.split("|");	//	이미지
		/** -------------------------- 20181228 end -------------------------- */

			
		switch(_link[0]){
			case "address"	: // 새창
				7<_link[2].length && window.open( /*url*/_link[2], _link[1]);
				break;
				
			case "popup"		: // 팝업
				{
					var _url = _link[6].split("(_-__-_)")[0];
					7<_url.length && window.open( _url, _link[0], "left=" + _link[1] + ", top="+_link[2] + ", width="+_link[3] + ", height="+_link[4] );
				}
				break;
				
			case "page"		: // 페이지 이동
				eBookCore.func.gotoPage( parseInt( _link[1] ) );
				break;
				
			default:
				croTools.log("unknown link type : "+_link[0]);
		}
	},
	
	// 텍스트박스 클릭 이벤트 설정
	setTextEvent : function(textEl) {
		$(textEl).off("click"); // 이전 등록이벤트 제거 후 새로 등록
		$(textEl).on("click", eBookCore.components.openLinkByData);
	},
	
	// 이미지 클릭 이벤트 설정
	setImageEvent : function(imgEl) {
		$(imgEl).off("click"); // 이전 등록이벤트 제거 후 새로 등록
		$(imgEl).on("click", eBookCore.components.openLinkByData);
	},

	// 미디어 재생 컴포넌트 생성
	createMediaPlayer : function(e){
		e=$(e);
		e.mediaelementplayer({
			//defaultVideoWidth				: '',			// if the <video width> is not specified, this is the default
			//defaultVideoHeight			: '',			// if the <video height> is not specified, this is the default
			//videoWidth							: '100%',	// if set, overrides <video width>
			//videoHeight							: '100%',	// if set, overrides <video height>
			//audioWidth							: 200,		// width of audio player
			//audioHeight							: 30,			// height of audio player
			startVolume							: 1.0,		// initial volume when the player starts
			loop										: false,	// useful for <audio> player loops
			enableAutosize					: true,		// enables Flash and Silverlight to resize to content size
			features								: ['playpause','progress','current','duration',/*'tracks',*//*'volume',*/'fullscreen'], // the order of controls you want on the control bar (and other plugins below)
			alwaysShowControls			: false,	// Hide controls when playing and mouse is not over the video
			iPadUseNativeControls		: false,	// force iPad's native controls
			iPhoneUseNativeControls	: false,	// force iPhone's native controls
			AndroidUseNativeControls: false,	// force Android's native controls
			alwaysShowHours					: false,	// forces the hour marker (##:00:00)
			showTimecodeFrameCount	: false,	// show framecount in timecode (##:00:00:00)
			framesPerSecond					: 25,			// used when showTimecodeFrameCount is set to true
			enableKeyboard					: false,	// turns keyboard support on and off for this instance
			pauseOtherPlayers				: false,	// when this player starts, it will pause other players
			keyActions							: [],			// array of keyboard commands
			/** would have to recalculate size  youtube */
			success: function(mediaElement , domElement /** YOUTUBE == IFrame */, player) {	
				if( $(domElement).prop("tagName").toLowerCase() === "iframe"  && 
					$(domElement).attr("title").toLowerCase() === "YouTube video player".toLowerCase() && 
					( 
						$(domElement).siblings().prop("tagName").toLowerCase() === "video".toLowerCase() && 
						$(domElement).siblings().attr("type").toLowerCase() === "video/youtube".toLowerCase()
					 )){
					$(domElement).css({"width": $(domElement).siblings().css("width") , "height": $(domElement).siblings().css("height")} );	//	$(domElement).siblings() == <video></video>
				}			
			}

		});
		
		var mediaContainer = e.closest(".mejs-container");
		
		if(1>mediaContainer.length){ // 아이폰계열에서 객체를 얻지 못하는 문제 보완
			e = $("#"+e.attr("id"));
			mediaContainer = e.closest(".mejs-container");
			
			if(1>mediaContainer.length){
				return croTools.log("createMediaPlayer : media container not found.");
			}
		}
		
		mediaContainer
			.attr("style", e.attr("style"))
			.css("position","absolute");
			
		// 버튼이미지가 있으면 추가
		var _data = eBookCore.components.data[e.attr("id")];
		if(_data.normalImage && 0<_data.normalImage.length){
			var _url = eBookCore.path.contents+_data.normalImage;
			mediaContainer.find(".mejs-overlay-play").append("<img src='"+_url+"' title='play button image' style='width:100%;height:100%' />");
		}
	
		// video,audio에서 불필요한 속성 제거
		e.attr({'width':'','height':''}).css({ left:'', top:'', visibility:'' });
		
		// 자동실행 컴포넌트 처리( 모바일환경에선 자동실행 사용 안함, VIDEO 자동실행 안함, AUDIO는 autoplay 속성 체크 )
		if(!croTools.isMobile() && "VIDEO"!==e[0].tagName && "true"===eBookCore.getDataById(e[0].id).autoplay){
			var _pageNum	= eBookCore.getPageNumById(e.attr("id"));
			var _pageNums	= eBookCore.pageTurn.getVisiblePageNumbers();
			if(!_pageNums){ return croTools.log("failed : getVisiblePageNumbers"); }
			for(var i=0; i<_pageNums.length; ++i){
				//croTools.log("autoplay page nums : "+ _pageNums[i] + " / " + _pageNum);
				if(_pageNums[i]===_pageNum){
					croTools.log("autoplay : "+_pageNum + " / " + e.get(0));
					e.get(0).play();
				}
			}
		}
	},

   //   슬라이드 이미지 2018-12-20
   calcDimensions : function(e) {
      e = $(e);
      var _data = eBookCore.components.data[e.attr("id")];
      if( $('#' + _data.id +'_').attr("data-status") === "run" ) return;         //   ------------------> 추가
      $('#' + _data.id).css( { "max-width": $('#' + _data.id).css("width") } );   //   ul Wrapper
      $('#' + _data.id +'_').children("li").children("img").css({"width": $('#' + _data.id).css("width") , "height": $('#' + _data.id).css("height")});   //   ul > li > img
   },   
	/** -------------------------- 20181228 -------------------------- */
    loadSlider : function(e) {   
      e = $(e);
      var _data = eBookCore.components.data[e.attr("id")];

		if( $('#' + _data.id +'_').attr("data-status") === "run" ) { 
			if( eBookCore.components.isThisCurrentPage($('#' + _data.id +'_').attr("data-page" )) ){ 
				try{
					var _now_ = eBookCore.components.nowTime();
					var elapsed = eBookCore.components.elapsedTime( $('#' + _data.id +'_').attr("data-refresh") ,_now_ );
					if( parseInt(elapsed) > 500 ) eBookCore.components.forceRefresh(); //	0.5s == 500ms
					$('#' + _data.id +'_').attr({ 'data-refresh'  : _now_ });
				}catch(error){
					console.log(error.message);
				}finally{
				}
			} 
			return; 
		}   
		var slider = $('#' + _data.id +'_').lightSlider({   //   ul
         gallery:false,
         item:1,
         slideMargin: 0,
         speed:1000,
		 pause:4000,
         auto: "false"===_data.visible ? false : true /** ul Wrapper */ ,
         loop:true,
         pauseOnHover: true,
	     enableDrag:false,
		 controls:false,
         pager:true,
         onSliderLoad: function(el) {
            $('#' + _data.id +'_').removeClass('cS-hidden');
            $('#' + _data.id +'_').addClass('lsGrab');
            $('#' + _data.id +'_').attr({ 'data-status'  : 'run' });
			if( eBookCore.components.isThisCurrentPage($('#' + _data.id +'_').attr("data-page" )) ){ 
				eBookCore.components.forceRefresh(); 
			}
         }
      });
   },

	unloadSlider : function( e1 ) {
		console.log('do something');
	} , 
	isThisCurrentPage : function(page){
		var _pageNums	= eBookCore.pageTurn.getVisiblePageNumbers();
		for(var i=0; i<_pageNums.length; ++i){
			if( parseInt(_pageNums[i]) === parseInt(page)){
				return true;
			}
		}
		return false;
	},
	forceRefresh : function(){
		if ( eBookCore.components.isIe() ) {
			var evt = document.createEvent('HTMLEvents'); 
			evt.initEvent('resize', true, true); 
			window.dispatchEvent(evt);
			if( eBookCore.pageTurn.getVisiblePageNumbers() % 2 != 0 ) {
				window.dispatchEvent(evt);
			}
	}else{
			 window.dispatchEvent(new Event('resize'));
			 if( eBookCore.pageTurn.getVisiblePageNumbers() % 2 != 0 ) {
				window.dispatchEvent(new Event('resize'));
			}
		}
	},
	nowTime : function() { return ( new Date() ).getTime(); } , 
	elapsedTime : function(start , end){ return end - start; },
	isIe : function(){
		var ua = window.navigator.userAgent;
		var msie = ua.indexOf('MSIE ');
		var trident = ua.indexOf('Trident/');
		return (msie > 0 || trident > 0);
	}	
	/** -------------------------- 20181228 end -------------------------- */
};


/**-------------------------------------------------------------------------------------------------
*		언어팩 ( 사용 예 : eBookCore.getString("result") )
*/
eBookCore.string = {
	search				: { en:"search"				,	ko:"검색"						, ja:"檢索"					, zh:"檢索"			},
	input_here		: { en:"input here"		,	ko:"여기에 입력"		, ja:"ここに入力"		, zh:"在这里输入"	},
	result				: { en:"result"				,	ko:"결과"						, ja:"結果"					, zh:"結果"			},
	search_more		: { en:"▼more▼"				,	ko:"▼더 보기▼"			, ja:"次へ"					, zh:"下一次"		},
	contents			: { en:"contents"			,	ko:"목차"						, ja:"目次"					, zh:"目次"			},
	bookmark			: { en:"bookmark"			,	ko:"책갈피"					, ja:"ブックマーク"	, zh:"书签"				},
	unusable			: { en:"unusable"			,	ko:"사용 불가"			, ja:"使用不可"			, zh:"不可用"		},
	first_page		: { en:"first page"		,	ko:"첫 페이지"			, ja:"最初のページ"	, zh:"第一页"		},
	last_page			: { en:"last page"		,	ko:"끝 페이지"			, ja:"最後のページ"	, zh:"最后一页"	},
	memo					: { en:"memo"					,	ko:"메모"						, ja:"メモ"					, zh:"记录"				},
	writehere			: { en:"write here"		,	ko:"여기에 작성"		, ja:"ここに作成"		, zh:"写在这里"		},
	save					: { en:"save"					,	ko:"저장"						, ja:"保存"					, zh:"保存"			},
	cancel				: { en:"cancel"				,	ko:"취소"						, ja:"キャンセル"		, zh:"取消"			},
	close					: { en:"close"				,	ko:"닫기"						, ja:"閉じる"				, zh:"关闭"				},
	minimization		: { en:"minimization"		,	ko:"최소화"						, ja:"最小化"				, zh:"最小化"				},
	memoexpansion		: { en:"expansion"		,	ko:"최대화"						, ja:"最大化"				, zh:"最大化"				},
	print					: { en:"print"				,	ko:"인쇄"						, ja:"プリント"			, zh:"印刷"			},
	printPreview	: { en:"print preview",	ko:"인쇄 미리보기"	, ja:"プレビュー"		, zh:"预览"				},
	printRange		: { en:"print range"	,	ko:"인쇄 범위"			, ja:"範囲"					, zh:"範圍"			},
	currentPage		: { en:"current page"	,	ko:"현재 페이지"		, ja:"現在ページ"		, zh:"当前页"			},
	selectRange		: { en:"select range"	,	ko:"범위 지정"			, ja:"範囲指定"			, zh:"指定范围"	},
	allPages			: { en:"all pages"		,	ko:"전체 페이지"		, ja:"全体ページ"		, zh:"整个页面"		},
	printPageJpg	: { en:"Normal"		,	ko:"일반화질"		, ja:"一般画質"		, zh:"正常"		},
	printPageSvg	: { en:"high"		,	ko:"고화질"		, ja:"高画質"		, zh:"高清"		},
	printPageAlert	: { en:"high quality printing may not print entire pages, depending on computer specifications.\n(PC memory 16GB or higher recommended / 1page printable)"		,
		ko:"고화질 인쇄시, 컴퓨터 사양에 따라 전체 페이지가 인쇄 되지 않을 수 있습니다.\n(PC 메모리 16GB 이상 권장/ 이하의 경우 1page씩 인쇄 가능)"		,
		ja:"高画質 印刷時に、コンピュータの仕様に応じてページ全体が印刷されないことがあります.\n(PCメモリ16GB以上を推奨/以下の場合1pageずつ印刷可能)"		,
		zh:"当高品质的打印，根据您的计算机的规格，则无法打印整个页面。（如果电脑内存16GB或1/1比较推荐/打印更少）"		},
	zoomIn				: { en:"zoom in"			,	ko:"확대"						, ja:"拡大"					, zh:"扩大"			},
	zoomOut				: { en:"zoom out"			,	ko:"축소"						, ja:"縮小"					, zh:"缩小"			},
	undo					: { en:"undo"					,	ko:"실행취소"				, ja:"アンドゥ"			, zh:"撤消"			},
	redo					: { en:"redo"					,	ko:"실행복구"				, ja:"リドゥ"				, zh:"重做"			},
	clear					: { en:"clear"				,	ko:"초기화"					, ja:"初期化"				, zh:"初始化"		},
	download			: { en:"download"			,	ko:"내려받기"				, ja:"ダウンロード"	, zh:"下载"			},
	opacity				: { en:"opacity"			,	ko:"투명도"					, ja:"透明度"				, zh:"透明度"		},
	pen						: { en:"pen"					,	ko:"펜"							, ja:"ペン"					, zh:"笔"				},
	marker				: { en:"marker"				,	ko:"마커"						, ja:"マーカー"				, zh:"记号笔"			},
	submit				: { en:"submit"				,	ko:"확인"						, ja:"確認"					, zh:"确认"			},
	
	enter_pwd			: { en:"Please enter your password",
										ko:"암호를 입력해 주세요",
										ja:"暗号を入力してください",
										zh:"请输入您的密码"
										},
	incorrect_pwd	: { en:"You entered an incorrect password",
										ko:"틀린 암호를 입력하셨습니다",
										ja:"間違ったパスワードを入力しました",
										zh:"您输入的密码不正确"
										},
	sns_msg				: { en:"I introduce my NexBook.",
										ko:"저의 NexBook을 소개합니다.",
										ja:"私のNexBookを紹介します",
										zh:"我介绍一下我的NexBook."
										}
};


/**-------------------------------------------------------------------------------------------------
*		페이지 언어에 맞는 문자열 반환
*/
eBookCore.getString = function(text){
	try{
		return 	eBookCore.string[ text ][ croTools.getLang() ]
				||	eBookCore.string[ text ][ "en" ] /* default language */ ;
	}catch(err){
		croTools.log("getString( " + text + " ) error : " + err.message);
		return ("unexpected string : " + text);
	}
};


/**-------------------------------------------------------------------------------------------------
*		컨텐츠 ID값으로 컨텐츠가 들어있는 페이지 번호 반환
*/
eBookCore.getPageNumById = function(id){
	var _cont = eBookData.pageContents;
	for(var i=0; i<_cont.length; ++i){
		for(var k=1; k<_cont[i].length; ++k){
			var _data = _cont[i][k];
			
			if(_cont[i][k].id===id){
				return _cont[i][0]; // pageNum
			}
		}
	}
	return croTools.log("not found page number : unknown id="+id);
};

/**-------------------------------------------------------------------------------------------------
*		컨텐츠 ID값으로 컨텐츠정보 반환
*/
eBookCore.getDataById = function(id){
	var _cont = eBookData.pageContents;
	for(var i=0; i<_cont.length; ++i){
		for(var k=1; k<_cont[i].length; ++k){
			var _data = _cont[i][k];
			
			if(_cont[i][k].id===id){
				return _cont[i][k];
			}
		}
	}
	return croTools.log("not found data : unknown id="+id);
};
