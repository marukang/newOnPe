/** -------------------------- 20181228 -------------------------- */
eBookCore.components.imageSlider = function(container, data , page ){
	if( $('#' + data.id +'_').attr("data-status") === "run" || 
		$('#' + data.id +'_').attr("data-status") === "pending" ) return;

	var divTag = $("<div>").attr({
								'class'	: 'ebookpagecomp clearfix ebookslidercomp' ,
								'id'	: data.id 
							}).css({
									'position'			: 'absolute',
									'max-width'			: '600px'
								});
	var ulTag = $("<ul>").attr({
							'class'	: 'gallery list-unstyled cS-hidden' , 
							'id'		: data.id + "_" ,
							'data-page'  : page ,  
							'data-refresh'  : ( new Date() ).getTime() ,  
							'data-status'  : 'pending' 
						});	

	var LIMITED = 10;							//	const LIMITED = 10;
	var IMAGES_PATH = eBookCore.path.contents;	//	const IMAGES_PATH = eBookCore.path.contents;
	for( i=0; i<LIMITED; i++){
		var fileName = ( i === 0 ? data.normalImage : eval( 'data.normalImage' + i) );
		if( fileName !== undefined && fileName.length > 0){
			var liTag = $("<li>");
			var imgTag = $("<img>");
			imgTag.attr('src',IMAGES_PATH + fileName).appendTo( liTag  );

			var linkName = ( i === 0 ? data.link : eval( 'data.link' + i) );
			if( linkName !== undefined  && linkName.length > 0 && linkName.toLowerCase() !== "address|_blank|".toLowerCase() ){
				imgTag.attr('data-link',linkName ).css('cursor','pointer');
			}
			ulTag.append( liTag );
		}
	}
	container.prepend( divTag.append( ulTag ) );
}
/** -------------------------- 20181228 end -------------------------- */