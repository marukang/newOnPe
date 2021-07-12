/**-------------------------------------------------------------------------------------------------
*										판서 플러그인 스크립트( sketch.min.js 사용 )
*																					Date	: 2015.05.04
*																					Author	: 박정민
**/
eBookCore.plugins.drawing = {
	
	drawingData		: {},
	
	colors				: ['rgba(238,96,132,1.0)', 'rgba(255,242,115,1.0)', 'rgba(200,255,188,1.0)', 'rgba(0,190,195,1.0)', 'rgba(182,228,255,1.0)', 'rgba(143,150,255,1.0)', 'rgba(0,0,0,1.0)', 'rgba(255,255,255,1.0)'],
	colorKeys			: ['Q', 'W', 'E', 'R', 'A', 'S', 'D', 'F'],
	sizes					: [3, 6, 9, 12, 15],
	sizeKeys			: ['1', '2', '3', '4', '5'],
	redos					: { count:0, data:[] },
	
	options				: {
		toolLinks			: true,
		defaultTool		: 'marker',
		defaultColor	: 'rgba(238,96,132,1.0)',
		defaultSize		: 9
	},

	opacity				: 1,
	
	run						: function(_currentPageNum){},
	resizeCanvas	: function(){},
	
	eventKeyup		: function(e){},
};

/**	캔버스 사이즈 조절
*/
eBookCore.plugins.drawing.resizeCanvas = function(){
	var cvEl = $("#ebookdrawingCanvas");
	if(!cvEl.length){ return;}
	
	if(cvEl.width() !== window.innerWidth || cvEl.height() !== window.innerHeight){
		cvEl.attr({	width  : window.innerWidth,
								height : window.innerHeight });
		cvEl.sketch().redraw();
	}
};


/**	드로잉 플러그인 실행
*/
eBookCore.plugins.drawing.run = function(_currentPageNum){

	if(0<$("#ebookdrawing").length){ return $("#ebookdrawing").detach(); }
	
	var drawingEl = $("<div id='ebookdrawing'>").html("<div class='blind'>"); // 키보드동작 방지를 위한 블라인드 태그 삽입
	drawingEl.appendTo(document.body);
	
	$('<canvas id="ebookdrawingCanvas" width="'+window.innerWidth+'" height="'+window.innerHeight+'" >')
		.css("opacity", eBookCore.plugins.drawing.opacity)
		.on("mouseup", function(e){
			
			var sketchEl = $(this).sketch();
			var redosObj = eBookCore.plugins.drawing.redos;
			
			if(0<redosObj.data.length
			&& redosObj.count !== redosObj.data.length+sketchEl.actions.length ){ // 추가 드로잉이 있으면 복원 정보 초기화
				redosObj.data = [];
				redosObj.count = sketchEl.actions.length;
			}
			
			// 실행취소,복구 버튼 활성상태 갱신
			$("#drawingmenubar .drawingBtns.undo").css("opacity", 0<sketchEl.actions.length	? 1 : '');
			$("#drawingmenubar .drawingBtns.redo").css("opacity", 0<redosObj.data.length		? 1 : '');
		})
		.appendTo(drawingEl);
	
	var toolsEl = $("<div id='ebookdrawingTools'>");
	toolsEl.appendTo(drawingEl);

	toolsEl.css({	left : (window.innerWidth-toolsEl.outerWidth())*0.5,
								top  : window.innerHeight-toolsEl.outerHeight()			});
	
	var drawingColorsEl	= $("<div id='drawingcolors'  class='drawingToolSub' />");
	var drawingSizesEl	= $("<div id='drawingsizes'   class='drawingToolSub' />");
	var drawingMenuEl		= $("<div id='drawingmenubar' class='drawingToolSub ' />");
	toolsEl.append(drawingColorsEl)
					.append(drawingSizesEl)
					.append(drawingMenuEl);
	
	// 색상 목록
	drawingColorsEl.append("<span class='category'>COLORS</span>");
	$.each(eBookCore.plugins.drawing.colors, function(i,v) {
		drawingColorsEl.append(
			$("<a class='drawingColors' data-color='" + this + "' style='background:" + this + ";"+(v===eBookCore.plugins.drawing.options.defaultColor?"opacity:1;":"")+" '></a> ")
			.on(eBookCore.eventType.click, function(e){
				var colorEl = $(this);
				colorEl.parent().children().css('opacity','');
				colorEl.css('opacity', '1');
				eBookCore.plugins.drawing.options.defaultColor = colorEl.attr("data-color");
				drawingSizesEl.find("a").css("background", eBookCore.plugins.drawing.options.defaultColor);
				
				$("#ebookdrawingCanvas").sketch().color = colorEl.attr("data-color");
			})
		);
	});
	if(!croTools.isMobile()){
		$("a.drawingColors").each(function(i,e){
			$("<span>"+eBookCore.plugins.drawing.colorKeys[i]+"</span>")
			.appendTo(e)
			.on(eBookCore.eventType.click, function(){
				$(e).trigger(eBookCore.eventType.click);
			});
		});
	}
	
	// 사이즈 목록
	drawingSizesEl.append("<span class='category'>SIZES</span>");
	$.each(eBookCore.plugins.drawing.sizes, function(i,v) {
		drawingSizesEl.append(
			$("<a class='drawingSizes' data-size='" + this + "' style='height:"+this+"px;"+(v===eBookCore.plugins.drawing.options.defaultSize?"opacity:1;":"")+" background:"+eBookCore.plugins.drawing.options.defaultColor+"; '></a>")
			.on(eBookCore.eventType.click,function(e){
				var sizeEl = $(this);
				eBookCore.plugins.drawing.options.defaultSize = parseInt( sizeEl.attr("data-size") );
				sizeEl.parent().children().css('opacity','');
				sizeEl.css('opacity','1');
				
				$("#ebookdrawingCanvas").sketch().size = sizeEl.attr("data-size");
			})
		);
	});
	if(!croTools.isMobile()){
		$("a.drawingSizes").each(function(i,e){
			$("<span style='font-size:"+eBookCore.plugins.drawing.sizes[i]+"px'>"+(i+1)+"</span>")
			.appendTo(e)
			.on(eBookCore.eventType.click, function(){
				$(e).trigger(eBookCore.eventType.click);
			});
		});
	}

	
	// 펜,마커 토글 버튼
	drawingMenuEl.append($('<img class="drawingBtns opacity" src="'+eBookCore.resource.pen+'" title="'+eBookCore.getString('pen')+'(P)" />').on(eBookCore.eventType.click,function(e){
		var colorEl = $("#drawingcolors .drawingColors");
		var isPen = (-1 < colorEl.eq(0).attr("data-color").indexOf("1.0"));
		colorEl.each(function(i,col){
			col = $(col);
			var oldColor = col.attr("data-color");
			col.attr("data-color", oldColor.replace(isPen?"1.0":"0.5",isPen?"0.5":"1.0"));
		});
		
		// 현재 사용색상 변경
		$("#ebookdrawingCanvas").sketch().color = $("#ebookdrawingCanvas").sketch().color.replace(isPen?"1.0":"0.5",isPen?"0.5":"1.0");
		
		// 아이콘 변경
		e.target.src		= isPen ? eBookCore.resource.marker : eBookCore.resource.pen;
		e.target.title	= isPen ? eBookCore.getString('marker') : eBookCore.getString('pen');
	}));
	
	
	// 불투명도 토글 버튼
	drawingMenuEl.append($('<img class="drawingBtns opacity" src="'+eBookCore.resource.layer+'" title="'+eBookCore.getString('opacity')+'(SHIFT)" />').on(eBookCore.eventType.click,function(){
		var cvEl = $("#ebookdrawingCanvas");
		var newOpacity = parseFloat( cvEl.css("opacity") ) - 0.25;
		eBookCore.plugins.drawing.opacity = 0 < newOpacity ? newOpacity : 1;
		cvEl.css("opacity", eBookCore.plugins.drawing.opacity);
	}));
	
	
	// 실행취소 버튼
	drawingMenuEl.append($('<img class="drawingBtns undo" src="'+eBookCore.resource.undo+'" title="'+eBookCore.getString('undo')+'(Z)" />').on(eBookCore.eventType.click,function(){
		var sketchEl = $("#ebookdrawingCanvas").sketch();
		if(1>sketchEl.actions.length){
			$("#drawingmenubar .drawingBtns.undo").css("opacity", '');
			return;
		}
		
		var redosObj = eBookCore.plugins.drawing.redos;
		
		if(0<redosObj.data.length
		&& redosObj.count !== redosObj.data.length+sketchEl.actions.length ){ // 추가 드로잉이 있으면 복원 정보 초기화
			redosObj.data = [];
		}
		
		redosObj.data.push( sketchEl.actions.pop() );
		redosObj.count = redosObj.data.length+sketchEl.actions.length; // 드로잉 카운트 갱신
		sketchEl.redraw();
		
		// 버튼 투명도 갱신
		$("#drawingmenubar .drawingBtns.undo").css("opacity", sketchEl.actions.length ? 1 : '');
		$("#drawingmenubar .drawingBtns.redo").css("opacity", redosObj.data.length ? 1 : '');
	}));
	
	// 실행복구 버튼
	drawingMenuEl.append($('<img class="drawingBtns redo" src="'+eBookCore.resource.redo+'" title="'+eBookCore.getString('redo')+'(X)" />').on(eBookCore.eventType.click,function(){
		var sketchEl = $("#ebookdrawingCanvas").sketch();
		var redosObj = eBookCore.plugins.drawing.redos;
		
		if(1>redosObj.data.length){
			return;
			
		}else if(0<redosObj.data.length
		&& redosObj.count !== redosObj.data.length+sketchEl.actions.length ){ // 드로잉 정보가 다르면 복구 중단
			redosObj.data = [];
			redosObj.count = sketchEl.actions.length;
			$("#drawingmenubar .drawingBtns.redo").css("opacity", '');
			return;
		}
		
		sketchEl.actions.push( redosObj.data.pop() );
		sketchEl.redraw();
		
		// 버튼 투명도 갱신
		$("#drawingmenubar .drawingBtns.undo").css("opacity", sketchEl.actions.length ? 1 : '');
		$("#drawingmenubar .drawingBtns.redo").css("opacity", redosObj.data.length ? 1 : '');
	}));
	
	// 새로고침 버튼
	drawingMenuEl.append($('<img class="drawingBtns clear" src="'+eBookCore.resource.blank+'" title="'+eBookCore.getString('clear')+'(C)"/>').on(eBookCore.eventType.click,function(){
		$("#ebookdrawingCanvas").detach().clone().prependTo(drawingEl).sketch(eBookCore.plugins.drawing.options);
		eBookCore.plugins.drawing.redos.data=[]; // 실행 취소 정보 초기화
		eBookCore.plugins.drawing.redos.count = 0;
		$("#drawingmenubar .drawingBtns.undo, #drawingmenubar .drawingBtns.redo").css("opacity", '');
	}));
	
	// 다운로드 버튼
	drawingMenuEl.append($('<img class="drawingBtns download" src="'+eBookCore.resource.download+'" title="'+eBookCore.getString('download')+'(V)"></img>').on(eBookCore.eventType.click, function(){
		$("#ebookdrawingCanvas")[0].toBlob( // canvas->blob 변환 site : https://github.com/eligrey/canvas-toBlob.js
			function(blob){
				saveAs(blob, "drawing_p"+_currentPageNum+".png"); // 파일 저장 site : https://github.com/eligrey/FileSaver.js
			}
		);
	}));
	
	// 닫기 버튼
	drawingMenuEl.append($('<img class="drawingBtns close" src="'+eBookCore.resource.close+'" title="'+eBookCore.getString('close')+'(ESC)"/>').on(eBookCore.eventType.click, function(){
		
		// 현재 드로잉 정보 저장
		var _actions = $("#ebookdrawingCanvas").sketch().actions;
		eBookCore.plugins.drawing.drawingData[_currentPageNum] = 1<_actions.length ? JSON.stringify( _actions ) : null;
		
		// 드로잉 등록 이벤트 제거
		$(window).off(".drawing");
		
		$("#ebookdrawing").detach();
	}));
	
	// 툴 창 드래그 속성 활성화
	toolsEl.draggable({opacity:0.9, cancel:".drawingBtns, .drawingColors, .drawingSizes"});
	
	// 각 버튼들 드래그 이벤트 방지
	$(".drawingColors, .drawingSizes, .drawingBtns").on('dragstart', function(e){ e.preventDefault(); });
	
	// 최초 스케치 초기화 실행
	var cvEl = $("#ebookdrawingCanvas");
	cvEl.sketch(eBookCore.plugins.drawing.options);
	
	// 저장된 드로딩 정보 읽기
	if(eBookCore.plugins.drawing.drawingData[_currentPageNum]){
		cvEl.sketch().actions = JSON.parse(eBookCore.plugins.drawing.drawingData[_currentPageNum]);
		cvEl.sketch().redraw();
		$("#drawingmenubar .drawingBtns.undo").css("opacity", 1); // 실행취소 활성화
	}
	
	// 실행취소 복원정보 초기화
	var actionsObj = cvEl.sketch().actions;
	eBookCore.plugins.drawing.redos = { count:(actionsObj?actionsObj.length:0), data:[] };
	
	// 이벤트 등록
	$(window).on(	"keyup.drawing",	eBookCore.plugins.drawing.eventKeyup)
						.on("resize.drawing",	eBookCore.plugins.drawing.resizeCanvas);
						
	// 현재 포커스 초기화(툴 키동작 활성화 용)
	$(document.activeElement).blur();
};


/**	드로잉 키보드 입력 처리
*/
eBookCore.plugins.drawing.eventKeyup = function(e){
	
	var _keyDB = croTools.keyCode;
	
	// Color Select Key
	var _colorsEl				= $("#drawingcolors .drawingColors");
	var _colorKeyList	= [ _keyDB.Q, _keyDB.W, _keyDB.E, _keyDB.R, _keyDB.A, _keyDB.S, _keyDB.D, _keyDB.F ];
	for(var i=0; i<_colorKeyList.length; ++i){
		if(e.which === _colorKeyList[i]){
			_colorsEl.eq(i).trigger("click");
			return;
		}
	}
	
	// Size Select Key
	var _sizesEl			= $("#drawingsizes .drawingSizes");
	var _sizeKeyList	= [ _keyDB[1], _keyDB[2], _keyDB[3], _keyDB[4], _keyDB[5] ];
	for(var i=0; i<_sizeKeyList.length; ++i){
		if(e.which === _sizeKeyList[i]){
			_sizesEl.eq(i).trigger("click");
			return;
		}
	}
	
	// Menu Select Key
	var _menuEl				= $("#drawingmenubar img");
	var _menuKeyList	= [ _keyDB.SHIFT, _keyDB.Z, _keyDB.X, _keyDB.C, _keyDB.V, _keyDB.ESC ];
	for(var i=0; i<_menuKeyList.length; ++i){
		if(e.which === _menuKeyList[i]){
			_menuEl.eq(i).trigger("click");
			return;
		}
	}
	
};


