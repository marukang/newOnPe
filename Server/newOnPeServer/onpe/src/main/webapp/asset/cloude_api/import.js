/*
*		NexBook CC API
*/
(function(){
	
	var APIURL = null; // import.js의 url 경로를 찾아서 사용한다.
	for( var scripts=document.getElementsByTagName("script"), i=0; i<scripts.length; ++i ){
		var v = scripts[i].src;
		var n = v.lastIndexOf("import.js");
		if(-1<n){ APIURL =  v.substr(0,n); break; }
	}if(!APIURL){ return console.log('url missing : import.js'); }
	
	var canHTML5 = !!document.createElement('canvas').getContext;

	// jquery
	document.writeln("<script type='text/javascript'	src		= '"+APIURL+"plugins/jquery/"+( canHTML5 ? "2.1.3" : "1.11.2" )+".min.js'></script>");
	document.writeln("<script type='text/javascript'	src		= '"+APIURL+"plugins/jquery/cookie.js'></script>");
	document.writeln("<script type='text/javascript'	src		= '"+APIURL+"plugins/jquery/mousewheel.min.js'></script>");
	document.writeln("<script type='text/javascript'	src		= '"+APIURL+"plugins/jquery/touch.min.js'></script>"); // for doubleTap, pinch event
	document.writeln("<script type='text/javascript'	src		= '"+APIURL+"plugins/jquery/ba-dotimeout.min.js'></script>");

	document.writeln("<script type='text/javascript'	src		= '"+APIURL+"plugins/jquery/ui/min.js'></script>");
	document.writeln("<script type='text/javascript'	src		= '"+APIURL+"plugins/jquery/ui/touch-punch.min.js'></script>"); // for mobile click, draggable event
	document.writeln("<link type='text/css'						href	= '"+APIURL+"plugins/jquery/ui/min.css' rel='stylesheet' />");
	document.writeln("<link type='text/css'						href	= '"+APIURL+"plugins/jquery/ui/structure.min.css' rel='stylesheet' />");
	document.writeln("<link type='text/css'						href	= '"+APIURL+"plugins/jquery/ui/theme.min.css' rel='stylesheet' />");
	
	// media player
	document.writeln("<script type='text/javascript'	src		= '"+APIURL+"plugins/media/mediaelement-and-player.min.js'></script>");
	document.writeln("<link type='text/css'						href	= '"+APIURL+"plugins/media/mediaelementplayer.min.css' rel='stylesheet' />");

	//	light slider
	document.writeln("<script type='text/javascript'	src		= '"+APIURL+"plugins/lightslider/js/lightslider.js'></script>");
	document.writeln("<link type='text/css'						href	= '"+APIURL+"plugins/lightslider/css/lightslider.css' rel='stylesheet' />");

	// commons
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"plugins/canvas-toBlob.min.js'></script>"); // for convert canvas to blob
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"plugins/FileSaver.min.js'></script>"); // for save file to local pc
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"plugins/jszip.min.js'></script>"); // for compress to zip
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"plugins/pica.min.js'></script>"); // for imageResampling
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"plugins/sha512.js'></script>"); // for encrypt,decrypt
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"plugins/yepnope-1.5.4.min.js'></script>");
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"plugins/croTools.js'></script>");
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"application/core.min.js'></script>");

	document.writeln("<script type='text/javascript'   src = '"+APIURL+"plugins/jquery.storageapi.js'></script>"); // Jquery storageapi

	// resource
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"plugins/resource.js'></script>");
	
	// zooming
	document.writeln("<script type='text/javascript'	src		= '"+APIURL+"plugins/zoomview/zoomview.min.js'></script>");
	document.writeln("<link type='text/css'						href	= '"+APIURL+"plugins/zoomview/zoomview.min.css' rel='stylesheet' />");
	
	// components
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"components/action.js'></script>");
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"components/link.js'></script>");
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"components/text.js'></script>");
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"components/image.js'></script>");
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"components/video.js'></script>");
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"components/audio.js'></script>");
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"components/youtube.js'></script>");	//	youtube 추가 
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"components/imageSlider.js'></script>");	//	슬라이드 이미지


	// 20180303 main CSS
	document.writeln("<link type='text/css'						href	= '"+APIURL+"application/ebook_main.css' rel='stylesheet' />");
	
	// main functions
	document.writeln("<script type='text/javascript'	src	= '"+APIURL+"application/functions.min.js'></script>");
})();