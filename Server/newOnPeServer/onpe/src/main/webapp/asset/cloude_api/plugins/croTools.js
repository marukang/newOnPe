/**-------------------------------------------------------------------------------------------------
*										croTools for Javascript
*
*																						Date		: 2015. 04. 02
*																						Creator	: Park Jung-min
**/
croTools = {

	value						: {},								// 함수 내에 사용될 변수들을 정의

	log							: function(_msg){},	// 개발 콘솔 창에 로그 메세지 기록
	logOn						: function(){},
	logOff					: function(){},
	getElapsedTime	: function(){},			// 구간 처리 소요 시간 반환 (단위 : 초)
	
	isMobile				: function(){},			// 모바일 브라우저 체크
	isIOS						: function(){},			// IOS 브라우저 체크
	isAndroid				: function(){},			// Android 브라우저 체크
	isMSIE					: function(){},			// MS 익스플로러 체크(4.0~)

	agentInfo				: function(){},			// 브라우저 확인 JH 20170424
	
	canHTML5				: function(){},			// HTML5 지원 가능 체크
	canTouch				: function(){},			// 터치 지원 가능 체크
	
	getClientSize		: function(){},			// 브라우저 화면 크기 반환( return { width, height } )

	rangeValue			: function(v, _a, _b){},	// 지정한 범위 내의 값을 반환( return v )

	isFullscreen		: function(){},			// 풀스크린 상태 체크
	
	toggleFullscreen	: function(e){},	// 풀스크린 토글
	
	getLang				: function(){},				// HTML 문서의 언어 설정값을 반환

	hexToRGBA			: function(hex, alpha){},	// 헥스코드 색상값을 RGBA 형태로 변환( _hex : FFFFFF / _alpha : 0~100 )
	
	playMedia			: function(_selector){},					// 미디어 재생(video, audio)
	
	getDefaultCSS	: function(_selector, _style){},	// 스타일시트 기본 값 반환
	
	encrypt				: function(_key, _data){},	// 문자열 암호화 ( SHA512 기반 )
	decrypt				: function(_key, _data){},	// 문자열 복호화 ( SHA512 기반 )
	base64				: function(){},							// Base64 인코딩,디코딩 함수
	
	imageResampling	: function(image, quality){},	// <img> 표시 크기에 맞게 리샘플링하여 퀄리티 향상( for IE )
	
	canvasCircle	: function(canvas, option){},		// 캔버스에 회전하는 서클 이미지 그리기(로딩 효과에 사용)
	
	SelectByCss : function(selector, style, value){}, // CSS 속성으로 객체 선택하여 반환
	
	keyCode : {													// 키 코드값 정의
		MOUSELEFT : 1, MOUSEMIDDLE : 2, MOUSERIGHT : 3,
		BACKSPACE : 8, TAB : 9, ENTER : 13, SHIFT : 16, CTRL : 17, ALT : 18, PAUSEBREAK : 19, CAPSLOCK : 20, ESC : 27,	SPACE: 32, PAGEUP : 33, PAGEDOWN : 34, END : 35, HOME : 36, LEFT : 37, UP : 38, RIGHT : 39, DOWN : 40, INSERT : 45, DELETE : 46,
		'0' : 48, '1' : 49, '2' : 50, '3' : 51, '4' : 52, '5' : 53, '6' : 54, '7' : 55, '8' : 56, '9' : 57,
		a : 97, A : 65, b : 98, B : 66, c : 99, C : 67, d : 100, D : 68, e : 101, E : 69, f : 102, F : 70, g : 103, G : 71, h : 104, H : 72, i : 105, I : 73, j : 106, J : 74, k : 107, K : 75, l : 108, L : 76, m : 109, M : 77, n : 110, N : 78, o : 111, O : 79, p : 112, P : 80, q : 113, Q : 81, r : 114, R : 82, s : 115, S : 83, t : 116, T : 84, u : 117, U : 85, v : 118, V : 86, w : 119, W : 87, x : 120, X : 88, y : 121, Y : 89, z : 122, Z : 90,
		WINKEYLEFT : 91, WINKEYRIGHT : 92, SELECT : 93, 
		NUM0 : 96, NUM1 : 97, NUM2 : 98, NUM3 : 99, NUM4 : 100, NUM5 : 101, NUM6 : 102, NUM7 : 103, NUM8 : 104, NUM9 : 105,
		MULTIPLY : 106, ADD : 107, SUBTRACT : 109, DECIMAL : 110, DIVIDE : 111, 
		F1 : 112, F2 : 113, F3 : 114, F4 : 115, F5 : 116, F6 : 117, F7 : 118, F8 : 119, F9 : 120, F10 : 121, F11 : 122, F12 : 123,
		NUMLOCK : 144, SCROLLLOCK : 145, SEMICOLON : 186, EQUAL : 187, COMMA : 188, DASH : 189, PERIOD : 190, FORWARDSLASH : 191, GRAVEACCENT : 192, OPENBRACKET : 219, BACKSLASH : 220, CLOSEBRAKET : 221, SINGLEQUOTE : 222,
	},	
	
	zTopMost : 2147483647,							// z-index 최대값
};

/**	개발 콘솔 창에 로그 메세지 기록
**/
croTools.logEl = undefined;
croTools.log = function(_msg, hideTime){
	
	if(croTools.value.logOff){ return; }
	
	if(!hideTime){
		var _now = new Date();
		_msg = '[' + _now.getHours() + ':' + _now.getMinutes() + ':' + _now.getSeconds() + '.' + _now.getMilliseconds() + '] ' + _msg;
	}
	console.log(_msg);
	
	// 디버깅 표시용 객체 초기화
	if( croTools.logEl===null ){
		return;
	}else
	if( croTools.logEl===undefined ){
		
		var _wndEl = $("#wndLogger");
		if(1>_wndEl.length){ return (croTools.logEl=null); }
		
		_wndEl.css({
			position: 'absolute',
			width		: '8em',
			height	: '5em',
			left		: '1em',
			bottom	: '1em',
			opacity	: 0.9,
			zIndex	: croTools.zTopMost,
		});
		_wndEl.append(	'<div class="draggable" style="width:100%;height:2em;left:0px;top:-2em;position:absolute;">'
									+	'<p style="cursor:pointer;"><span>[▼]</span> Logger</p></div>');
		
		croTools.logEl = $("<textarea id='debug_logger' readonly />").css({
			position: 'absolute',
			width		: '20em',
			height	: '100%',
			left		: '0px',
			top			: '0px',
		});
		_wndEl.append(croTools.logEl);

		croTools.logEl.resizable();

		_wndEl.draggable({
			addClasses	: false,
			handle			: ".draggable",
			opacity			: 0.5,
		});
		_wndEl.find("p").on("dblclick", function(e){
			$(e.target).find("span").html( croTools.logEl.is(":visible") ? "[▲]" : "[▼]" );
			croTools.logEl.toggle();
		});
	}
	
	croTools.logEl.html(croTools.logEl.html()+_msg+"\n").scrollTop( croTools.logEl[0].scrollHeight );
}
croTools.logOn	= function(){ croTools.value.logOff = false;	} // 로그표시 켜기
croTools.logOff	= function(){ croTools.value.logOff = true;		} // 로그표시 끄기

/**	구간 처리 소요 시간 반환 (단위 : 초)
**/
croTools.getElapsedTime = function(){
	var now		= new Date().getTime()*.001;
	var elapsed	= croTools.prevTimeStamp ? (now - croTools.prevTimeStamp) : 0;
	croTools.prevTimeStamp = now;
	return elapsed;
}

/**	모바일 브라우저 체크
**/
croTools.isMobile = function(){
	return (undefined !== croTools.value.isMobile) ? croTools.value.isMobile : (croTools.value.isMobile=!/(win16|win32|win64|mac)/i.test(navigator.platform));
}

/**	IOS 브라우저 체크
**/
croTools.isIOS = function(){
	return (undefined !== croTools.value.isIOS) ? croTools.value.isIOS : (croTools.value.isIOS=/(iPad|iPhone|iPod)/i.test(navigator.userAgent));
}

/**	Android 브라우저 체크
**/
croTools.isAndroid = function(){
	return (undefined !== croTools.value.isAndroid) ? croTools.value.isAndroid : (croTools.value.isAndroid=/(android)/i.test(navigator.userAgent));
}


/**	MS 익스플로러 체크(4.0~Edge)
**/
croTools.isMSIE = function(){
	return (undefined !== croTools.value.isMSIE) ? croTools.value.isMSIE : (croTools.value.isMSIE=/(Trident|Edge)/i.test(navigator.userAgent));
}


/**	HTML5 지원 가능 체크
**/
croTools.canHTML5 = function() {
	return (undefined !== croTools.value.canHTML5) ? croTools.value.canHTML5 : (croTools.value.canHTML5=!!document.createElement('canvas').getContext);
};

/**	터치 지원 가능 체크
**/
croTools.canTouch = function() {
	return (undefined !== croTools.value.canTouch) ? croTools.value.canTouch : (croTools.value.canTouch=!!('ontouchstart' in window));
};

/**	브라우저 화면 크기 반환( return { width, height } )
**/
croTools.getClientSize = function(){
	
	// 스크롤바가 있으면 감춘뒤 사이즈를 측정한다( for IE )
	var _oldAttr = document.body.style.overflow;
	document.body.style.overflow = "hidden";
	
	var ret = {	width	: document.documentElement.clientWidth,
						height	: document.documentElement.clientHeight };
	
	// 스크롤바 속성 복원
	document.body.style.overflow = _oldAttr;
	
	return ret;
}

/**	지정한 범위 내의 값을 반환( return v )
**/
croTools.rangeValue = function(v, _a, _b){
	var _min = Math.min(_a,_b),
			_max = Math.max(_a,_b);
	return Math.min(	_max, Math.max( _min, v ) );
}

/**	풀스크린 상태 체크
**/
croTools.isFullscreen = function() {
	var _size = croTools.getClientSize();
	return (_size.width === screen.width && _size.height === screen.height);
 };
	
/**	풀스크린 토글
**/
croTools.toggleFullscreen = function(e) {
	
	var requestMethod = (e.requestFullScreen || e.webkitRequestFullScreen || e.mozRequestFullScreen || e.msRequestFullscreen);
	if (requestMethod) {
		
		if(croTools.isFullscreen()){ // 전체화면 상태면 해제
			return (document.exitFullscreen				&& document.exitFullscreen()				)
					||	(document.mozCancelFullScreen		&& document.mozCancelFullScreen()		)
					|| (document.webkitCancelFullScreen	&& document.webkitCancelFullScreen()	)
					||	(document.msExitFullscreen			&& document.msExitFullscreen()			);
		}else{
			requestMethod.call(e);
		}
		
	} else if (typeof window.ActiveXObject !== "undefined") { // for IE8
		var wscript = new ActiveXObject("WScript.Shell");
		return (wscript !== null && wscript.SendKeys("{F11}")); // F11 실행

	} else{
		croTools.log("toggleFullscreen failed");
	}
}

/**	HTML 문서의 언어 설정값을 반환
**/
croTools.getLang = function(){ // HTML문서에 언어설정이 없으면 브라우저 언어설정을 반환
	return (undefined !== croTools.value.lang) ? croTools.value.lang : (croTools.value.lang=( document.documentElement.getAttribute("lang") || navigator.userLanguage || navigator.language || "en" /*default*/ ).substr(0,2).toLowerCase());
};

/** 헥스코드 색상값을 RGBA 형태로 변환( _hex : FFFFFF / _alpha : 0~100 )
**/
croTools.hexToRGBA = function(hex, alpha){
	hex = hex.replace('#','');
	r = parseInt(hex.substring(0,2), 16);
	g = parseInt(hex.substring(2,4), 16);
	b = parseInt(hex.substring(4,6), 16);
	return 'rgba('+r+','+g+','+b+','+(isNaN(alpha) ? 1 : alpha/100)+')';
};

/** 미디어 재생(video, audio)
**/
croTools.playMedia = function(_selector){
	var el = $(_selector);
	el.each(function(i,e){
		if(e.currentTime){ e.currentTime=0; }
		e.play();    
	});
	return el;
};

/** 스타일시트 기본 값 반환
**/
croTools.getDefaultCSS = function(_selector, _style){
	var targetEl = $(_selector);
	if(1>targetEl.length){ return; }
	
	var _oldStyle = targetEl.attr("style");
	targetEl.removeAttr("style");
	var _retStyle = targetEl.css(_style);
	targetEl.attr("style",_oldStyle);
	return _retStyle;
};

/** 문자열 암호화 ( SHA512 기반 )
		[  2+2 byte ] : Key Checksum[2] ( check for data integrity )
		[ rest byte ] : Data
**/
croTools.encrypt = function(key, data){
	if(!key.length) { return croTools.log("encrypt error : key is nothing");	 }
	if(!data.length){ return croTools.log("encrypt error : data is nothing"); }
	
	var hashKey	= CryptoJS.SHA512(key);
	var hashSum		= 0;
	$.each(hashKey.words, function(i,v){ hashSum += v; });

	var HEADER_SIZE = 2;
	var retEnc = new Array(HEADER_SIZE + data.length);
	for(var i=0; i<HEADER_SIZE; ++i){ // Header Key
		retEnc[i] = String.fromCharCode( 1 + ((hashSum >> (16 - i*16) & 0xFFFF) % 65535) ); // unicode table 1~65535
	}
	
	var hashStr = hashKey.toString();
	for(var i=0; i<data.length; ++i){
		retEnc[i+HEADER_SIZE] = String.fromCharCode( parseInt( "0x"+hashStr.substr(i*4 % 124, 4) ) ^ data[i].charCodeAt() );
	}
	
	return croTools.base64.encode( retEnc.join('') ); // base64 encoding
};

/** 문자열 복호화 ( SHA512 기반 )
		[  2+2 byte ] : Key Checksum[2] ( check for data integrity )
		[ rest byte ] : Encrypted Data
**/
croTools.decrypt = function(key, data){
	if(!key.length) { return croTools.log("decrypt error : key is nothing");	 }
	if(!data.length){ return croTools.log("decrypt error : data is nothing"); }
	
	data = croTools.base64.decode(data); // base64 decoding
	
	var hashKey	= CryptoJS.SHA512(key);
	var hashSum 	= 0;
	$.each(hashKey.words, function(i,v){ hashSum += v; });
	
	var HEADER_SIZE = 2;
	for(var i=0; i<HEADER_SIZE; ++i){ // Header Check
		if( data[i] !== String.fromCharCode( 1 + ((hashSum >> (16 - i*16) & 0xFFFF) % 65535) ) ){ return ''; }
	}
	
	var hashStr	= hashKey.toString();
	var decData		= new Array(data.length-HEADER_SIZE);
	for(var i=0; i<decData.length; ++i){
		decData[i] = String.fromCharCode( parseInt( "0x"+hashStr.substr(i*4 % 124, 4) ) ^ data[i+HEADER_SIZE].charCodeAt() );
	}
	
	return decData.join('');
};

/** Base64 Encode / Decode
		site : https://scotch.io/quick-tips/how-to-encode-and-decode-strings-with-base64-in-javascript
**/
croTools.base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=croTools.base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9\+\/\=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=croTools.base64._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/\r\n/g,"\n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}};

/** 이미지 출력 크기에 맞게 리샘플링하여 퀄리티 향상( for IE )
		image		: <img> object
		quality	:	undefined = 원본으로 복구
							0.1~0.9 : mipmap 처리(빠름, 저화질, 값이 클수록 흐려짐)
							0,1,2,3 : pica lib 처리(느림, 고화질, 값이 클수록 고화질)
**/
croTools.imageResampling = function(image, quality){
	if( !/IMG/i.test(image.tagName) ){ return croTools.log("[ imageResampling Error ] tagName : "+image.tagName); }
	
	// 샘플링했던 이미지면 백업 URL로 이미지 복구
	if("data"===image.src.substr(0,4) && image.getAttribute("src_bk")){
		image.onload = function(){
			this.onload = null;
			croTools.imageResampling(this, quality);
		};
		image.src = image.getAttribute("src_bk");
		return;
	}
	
	// 퀄리티값이 0이거나 IE가 아니거나 출력크기가 원본보다 크면 리샘플링 하지 않음
	if(	isNaN(quality)
	||	!croTools.isMSIE()
	||	(		image.width  >= image.naturalWidth
			&&	image.height >= image.naturalHeight )
	){
		return (isNaN(quality) && image.removeAttribute("src_bk")); // 원본 복구시 백업URL제거
	}
	
	//croTools.log("resampling start! : "+image.src+" / "+croTools.getElapsedTime()); // timechecker
	
	if(0<quality && quality<1){ // 0 < quality < 1 : mipmap resampler( fast, low quality )
		
		var currentScale= 1;
		var stepScale		= undefined===quality ? 0.5 : croTools.rangeValue(quality,0.1,0.9);
		var targetScale	= image.width / image.naturalWidth;
		var stepSize		= {	width : image.naturalWidth,
												height: image.naturalHeight };
		var stepImg			= image;
		
		while (currentScale * stepScale > targetScale) {
			currentScale *= stepScale;
			var tmpCV		= document.createElement('canvas');
			var tmpCTX	= tmpCV.getContext('2d');
			tmpCV.width	= stepSize.width = Math.max(1, stepSize.width  * stepScale);
			tmpCV.height= stepSize.height= Math.max(1, stepSize.height * stepScale);
			tmpCTX.scale(stepScale, stepScale);
			tmpCTX.drawImage(stepImg, 0, 0);
			stepImg			= tmpCV;
		}
		
		var remainingScale = targetScale / currentScale;
		
		var toCV		= document.createElement('canvas');
		var toCTX		= toCV.getContext('2d');
		toCV.width	= image.width;
		toCV.height	= image.height;
		toCTX.scale(remainingScale, remainingScale);
		toCTX.drawImage(stepImg, 0, 0);
		
	}else
	if(window.pica && quality<4){ // 0,1,2,3 : pica lib resampler( slow, high quality )
		
		var fromCV		= document.createElement('canvas');
		var fromCTX		= fromCV.getContext('2d');
		fromCV.width	= image.naturalWidth;
		fromCV.height	= image.naturalHeight;
		fromCTX.drawImage(image, 0, 0);
		var toCV			= document.createElement('canvas');
		toCV.width		= image.width;
		toCV.height		= image.height;
		window.pica.resizeCanvas(fromCV,toCV,{  // from, to, options, callback
			quality					: parseInt(quality),
			unsharpAmount		: 0,
			unsharpRadius		: 0.5,
			unsharpThreshold: 0,
			alpha						: true,
		},function(err){
			return err && croTools.log("[ imageResampling Error ] pica : "+err);
		});
		
	}else{
		return croTools.log("[ imageResampling Error ] quality value : "+quality);
	}
	
	//croTools.log("resampling done! : "+image.src+" / "+croTools.getElapsedTime()); // timechecker
	
	if(!image.getAttribute("src_bk")){ image.setAttribute("src_bk",image.getAttribute("src")); } // 이미지 경로 백업
	image.src = toCV.toDataURL();
};

/**	캔버스에 회전 서클 애니메이션 그리기
		canvas		: <canvas> element
		beginTime	: 
		option		: {
			time	: 최초 시작시간값 ex) new Date().getTime()
			alpha : 0~1	// 투명도,
			speed : 1~	// 회전속도,
			x			: 0~1	// 중심 X 좌표(캔버스 너비 기준),
			y			: 0~1	// 중심 Y 좌표(캔버스 높이 기준),
			radius: 0~ or [0~, 0~] // 반지름 픽셀크기( 숫자=고정, 배열=가변 ),
			thick	: 0~ or [0~, 0~] // 선굵기 픽셀크기( 숫자=고정, 배열=가변 ),
			ccw		: true or false // 반시계방향 회전 유무,
			color	: { // 색상 패턴
				R : [255, 255,  32,   0,  32, 255],
				G : [ 48, 255, 255, 255,  48,   0],
				B : [ 32,   0,  48, 255, 255, 255]
		}
**/
croTools.canvasCircle = function(canvas, option){
	
	if(!canvas){ return; }
	if(!option){
		
		var _size = Math.min(canvas.width, canvas.height);
		
		option = {
			time	: Math.floor(new Date().getTime() / 10000000) * 10000000,
			alpha : 0.5,
			speed : 1,
			x			: 0.5,
			y			: 0.5,
			radius: [_size/8, _size/16],// or number
			thick	: [_size/16, _size/8],	// or number
			ccw		: false,
			color	: {
				R : [255, 255,  32,   0,  32, 255],
				G : [ 48, 255, 255, 255,  48,   0],
				B : [ 32,   0,  48, 255, 255, 255]
			}
		};
	}
	
	var elapsed			= (new Date().getTime() - option.time) / 1000 / option.speed;
	
	var x						= option.x * canvas.width;
	var y						= option.y * canvas.height;
	var radius			= typeof(option.radius)==="number"
										? option.radius
										: option.radius[0] - (parseInt(elapsed*option.radius[1])%option.radius[1]);
	var circleDist	= Math.PI * (elapsed % 1) * 2;
	var startAngle	= (elapsed * Math.PI) + circleDist;
	var endAngle		= startAngle + circleDist;
	
	var ctx = canvas.getContext('2d');
	ctx.beginPath();
	ctx.arc(x, y, radius,
					option.ccw ? -startAngle	: startAngle,
					option.ccw ? -endAngle		: endAngle,
					option.ccw);

	ctx.lineWidth = typeof(option.thick)==="number"
									? option.thick
									: option.thick[0] - (parseInt(elapsed*option.thick[1])%option.thick[1]);
	
	var _colorLen = option.color.R.length;
	var _colorIdx = parseInt(elapsed) % _colorLen;
	var _milliSec = elapsed % 1;
	ctx.strokeStyle = 'rgb(' + parseInt(option.color.R[_colorIdx] * (1-_milliSec) + option.color.R[(_colorIdx+1) % _colorLen] * _milliSec)
											+',' + parseInt(option.color.G[_colorIdx] * (1-_milliSec) + option.color.G[(_colorIdx+1) % _colorLen] * _milliSec)
											+',' + parseInt(option.color.B[_colorIdx] * (1-_milliSec) + option.color.B[(_colorIdx+1) % _colorLen] * _milliSec)
											+')';
	ctx.globalAlpha = option.alpha;
	ctx.stroke();
};

/**	CSS 속성으로 객체 선택하여 반환
		selector: 기본 선택자
		style		: 속성명
		value		: 속성값
**/
croTools.SelectByCss = function(selector, style, value){
	return $(selector).filter(function(){ return $(this).css(style)==value; });
};


/**	 브라우져 확인 JH_ 20170423
**/
croTools.agentInfo = function(){
		var agent = navigator.userAgent.toLowerCase(),
			name = navigator.appName,
			browser;
		
		// MS 계열 브라우저를 구분하기 위함.
		if(name === 'Microsoft Internet Explorer' || agent.indexOf('trident') > -1 || agent.indexOf('edge/') > -1) {
			browser = 'ie';
			if(name === 'Microsoft Internet Explorer') { // IE old version (IE 10 or Lower)
				agent = /msie ([0-9]{1,}[\.0-9]{0,})/.exec(agent);
				browser += parseInt(agent[1]);
			} else { // IE 11+
				if(agent.indexOf('trident') > -1) { // IE 11 
					browser += 11;
				} else if(agent.indexOf('edge/') > -1) { // Edge
					browser = 'edge';
				}
			}
		} else if(agent.indexOf('safari') > -1) { // Chrome or Safari
			if(agent.indexOf('opr') > -1) { // Opera
				browser = 'opera';
			} else if(agent.indexOf('chrome') > -1) { // Chrome
				browser = 'chrome';
			} else { // Safari
				browser = 'safari';
			}
		} else if(agent.indexOf('firefox') > -1) { // Firefox
			browser = 'firefox';
		}

		return browser;
};


