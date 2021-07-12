eBookCore.components.youtube = function(container, data){ // container : DIV
	

	// 헥스 컬러값을 RGBA형태로 변환
	var rgbaBorderColor	= croTools.hexToRGBA( data.borderColor.substr(0,8).replace("0x","#")			, data.borderColor.substr(9)			);
	var youtubeURL = data.youtubeURL.replace('https://youtu.be/', '');  //동영상값만 남기기  


	var addEl = $("<div><iframe src=https://www.youtube.com/embed/"+youtubeURL+"?controls=2&modestbranding=0 frameborder='0' allow='accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture' allowfullscreen></iframe></div>")
		.attr({
			'class'			: 'ebookpagecomp embed_youtube',
			'id'				: data.id,
		})
		.css({
			'position'					: 'absolute',
			'cursor'						: 'pointer',
			'overflow'					: 'hidden',
			'border-color'			: rgbaBorderColor,
			'border-width'			: data.borderWidth +'px',
		});
	
	container.append(addEl); // ※ flip 효과 발생시 IE에서 다른 컴포넌트가 사라지는 현상이 있음. textarea만 예외적으로 맨 아래에 삽입하면 어느정도 해결됨.
}



/*
eBookCore.components.youtube = function(container, data){ // container : DIV
	var addEl = $("<video preload='none' controls playsinline webkit-playsinline>")
		.attr({
			'class'				: 'ebookpagecomp',
			'id'				: data.id,
			'alt'				: data.name,
			'src'				: !youtubeParser( data.youtubeURL ) ? "" : data.youtubeURL ,
			'type'				: !youtubeParser( data.youtubeURL ) ? "video/mp4" : "video/youtube" ,
		})
		.css({});
	
	if(croTools.isIOS()){ // 아이폰계열 전체화면 방지 태그 적용( 폰마다 다름. 아이폰 6S는 적용안됨. )
		addEl.attr({'webkit-playsinline':''});
	}
	
	container.prepend(addEl);
}

var youtubeParser = function(href) {
	if( !isUrlValid( href ) ) return false;
	var urlDom = document.createElement('a');
	urlDom.href = href;				

	if(urlDom.hostname.toLowerCase() === "youtu.be" || urlDom.hostname.toLowerCase() === "www.youtu.com") { delete urlDom; return true; }
	else { delete urlDom; return false; }
};

var isUrlValid= function (href) {
	if (href.match(/(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/g) !== null)
		return true;
	else return false;
};
*/
