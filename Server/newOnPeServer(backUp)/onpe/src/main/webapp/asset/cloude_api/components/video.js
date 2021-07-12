/**-------------------------------------------------------------------------------------------------
*										컴포넌트 비디오 스크립트
*																					Date	: 2015.07.09
*																					Author	: 박정민
**/
eBookCore.components.video = function(container, data){ // container : DIV
	
	var addEl = $("<video controls>")
		.attr({
			'class'				: 'ebookpagecomp',
			'id'					: data.id,
			'alt'					: data.name,
			'src'					: eBookCore.path.contents+data.movieURL,
			'type'				: "video/mp4",
		})
		.css({
			//'position'			: 'absolute',
			//'border-color'		: rgbaBorderColor,
			//'border-width'	: data.borderWidth +'px',
		});
	
	if(croTools.isIOS()){ // 아이폰계열 전체화면 방지 태그 적용( 폰마다 다름. 아이폰 6S는 적용안됨. )
		addEl.attr({'webkit-playsinline':''});
	}
	
	container.prepend(addEl);
}