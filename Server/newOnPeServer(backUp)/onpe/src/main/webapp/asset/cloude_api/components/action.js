/**-------------------------------------------------------------------------------------------------
*										컴포넌트 액션 스크립트
*																					Date	: 2015.07.28
*																					Author	: 박정민
**/
eBookCore.components.action = function(container, data){ // container : DIV
	
	//{ type:"action", id:"Interaction11435134959473", name:"액션1", height:"16", width:"17", y:"574", x:"900", dispatcher:"Link11435050004029", event:"onRelease", target:"Mp3Player11435050111825", action:"toggleVisible",  },
	
	var addEl = $("<div/>")
		.attr({
			'class'			: 'ebookpagecomp',
			'name'			: data.name,
			'id'				: data.id,
		})
		.css({
			'position'	: 'absolute',
			'visibility'	: 'hidden',
		});
	
	container.append(addEl); // ※ flip 효과 발생시 IE에서 다른 컴포넌트가 사라지는 현상이 있음. textarea만 예외적으로 맨 아래에 삽입하면 어느정도 해결됨.
}
