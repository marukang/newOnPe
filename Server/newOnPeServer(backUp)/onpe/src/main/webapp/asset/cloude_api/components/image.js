/**-------------------------------------------------------------------------------------------------
*										컴포넌트 이미지 스크립트
*																					Date	: 2015.07.07
*																					Author	: 박정민
**/
eBookCore.components.image = function(container, data){ // container : DIV

	// 헥스 컬러값을 RGBA형태로 변환
	var rgbaBorderColor	= croTools.hexToRGBA( data.borderColor.substr(0,8).replace("0x","#")			, data.borderColor.substr(9)	);
	
	var addEl = $("<img>")
		.attr({
			'class'	: 'ebookpagecomp',
			'id'		: data.id,
			'alt'		: data.name,
			'src'		: eBookCore.path.contents+data.normalImage,
		})
		.css({
			'position'			: 'absolute',
			'width'					: '0px',
			'height'				: '0px',
			'border-color'	: rgbaBorderColor,
			'border-width'	: data.borderWidth +'px',
		});

		{	// 링크 속성 활성화시 커서 모양 변경
			var _link = data.link.split("|");
			if( (_link[0]=='address' && 0<_link[2].length) || (_link[0]=='popup' && 0<_link[6].split("(_-__-_)")[0].length) || _link[0]=='page' ){
				addEl.css('cursor','pointer');
			}
		}
		
	// 롤오버 이미지 체크
	if(0<data.rolloverImage.lastIndexOf(".")){
		addEl.attr({
			'onmouseover'	: "this.src='"+eBookCore.path.contents+data.rolloverImage+"'",
			'onmouseout'	: "this.src='"+eBookCore.path.contents+data.normalImage+"'",
		});
	}

	container.prepend(addEl);
}