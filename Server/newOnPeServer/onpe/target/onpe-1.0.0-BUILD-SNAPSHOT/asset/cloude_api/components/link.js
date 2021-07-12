/**-------------------------------------------------------------------------------------------------
*										컴포넌트 링크 스크립트
*																					Date	: 2015.07.28
*																					Author	: 박정민
**/
eBookCore.components.link = function(container, data){ // container : DIV
	
	//{ type:"link", id:"Link11435050004029", name:"링크1", height:"211", width:"329", y:"130", x:"720", backgroundColor:"0xffffff,0", rolloverColor:"0xffffff,0", borderColor:"0x000000,0", borderWidth:"1", link:"address|_blank|http://www.ebook.co.kr/",  },
	
	// 헥스 컬러값을 RGBA형태로 변환
	var rgbaBgColor			= croTools.hexToRGBA( data.backgroundColor.substr(0,8).replace("0x","#")	, data.backgroundColor.substr(9)	);
	var rgbaBorderColor	= croTools.hexToRGBA( data.borderColor.substr(0,8).replace("0x","#")			, data.borderColor.substr(9)			);
	
	var addEl = $("<div/>")
		.attr({
			'class'			: 'ebookpagecomp',
			'name'			: data.name,
			'id'				: data.id,
		})
		.css({
			'position'					: 'absolute',
			'cursor'						: 'pointer',
			'background-color'	: rgbaBgColor,
			'border-style'			: 'solid' ,       // 2018-11-06 추가 
			'border-color'			: rgbaBorderColor,
			'border-width'			: data.borderWidth +'px',
		});
	
	container.prepend(addEl); // ※ flip 효과 발생시 IE에서 다른 컴포넌트가 사라지는 현상이 있음. textarea만 예외적으로 맨 아래에 삽입하면 어느정도 해결됨.
}
