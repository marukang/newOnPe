/**-------------------------------------------------------------------------------------------------
*										컴포넌트 오디오 스크립트
*																					Date	: 2015.07.09
*																					Author	: 박정민
**/
eBookCore.components.audio = function(container, data){ // container : DIV
	
	var addEl = $("<audio controls>")
		.attr({
			'class'				: 'ebookpagecomp',
			'id'					: data.id,
			'alt'					: data.name,
			'src'					: eBookCore.path.contents+data.musicURL,
			'type'				: "audio/mpeg",
		})
		.css({
			//'position'			: 'absolute',
			//'border-width'	: data.borderWidth +'px',
		});

	container.prepend(addEl);

	// -----------------------------------------------------------------------------
	audioFactory.add(
		new audioElement( addEl.attr('class') , addEl.attr('id') , data.name , addEl.attr('src') )
	);
	console.log( "audioFactory.count : " + audioFactory.count() );
	// -----------------------------------------------------------------------------
}

// -----------------------------------------------------------------------------
var audioFactory = {
	audios : [] , 
	count : function() { return this.audios.length; } , 
	getByIndex : function(index) {
		var audioElement;	//	undefined
		try {
			audioElement = this.audios[ index ];	
		} catch (error) {
			console.log("[" + error.name + "]" + " " + error.message);				
		}finally{
			return audioElement;
		}
	} ,
	getById : function(id) {
		var audioElement;	//	undefined
		try {			
			for(i=0; i<this.audios.length;i++){
				if( id == this.audios[i].getId() ){
					audioElement = this.audios[ i ];
					break;
				}	
			}
		} catch (error) {
			console.log("[" + error.name + "]" + " " + error.message);				
		}finally{
			return audioElement;
		}
	} , 	
	add : function(audioElement) {
		try {
			//	console.log( audioElement );
			if( audioElement === undefined){ 
				console.log("audioElement is undefined");
			}else{ 
				this.audios[this.audios.length] = audioElement; 
			}			
		} catch (error) {
			console.log("[" + error.name + "]" + " " + error.message);				
		}		
	} , 
	remove : function(index) {
		try {
			delete this.audios[ index ];	
		} catch (error) {
			console.log("[" + error.name + "]" + " " + error.message);				
		}
	}  , 
	removeAll : function() { /** do something */ ;} 
};

// Constructor function for audio objects
function audioElement( cls , id , name , src ){
	this.cls = cls ;
	this.id = id ;
	this.name = name ;
	this.src = src ;
	this.getClass = function() { return this.cls; };
	this.getId = function() { return this.id; };
	this.getName = function() { return this.name; };
	this.getSrc = function() { return this.src; };
	this.getDom = function() { return $('#' + this.getId())[0]; };
	//	this.getDom = function() { return $('#' + this.getId()).get(0); };
	this.getJquery = function() { return $( this.getDom() ); };
	this.getTagName = function() { return this.getJquery().prop("tagName");};
	this.canPlay = function() { /** do something */ ; };
	this.isPlaying = function() { return !this.getDom().paused; }
	this.isMute = function() { return this.getDom().muted; }
	this.togglePlay = function() { !this.isPlaying() ? this.getDom().play().catch() : this.getDom().pause();}	
	this.toggleMute = function() { this.getDom().muted = !this.isMute(); }
}
// -----------------------------------------------------------------------------