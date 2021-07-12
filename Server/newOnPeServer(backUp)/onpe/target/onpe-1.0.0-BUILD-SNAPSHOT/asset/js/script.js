
$(function() {

	$('.depth1 > li').on('click', function(e){
		console.log("클릭");
		if($(e.target).hasClass("badge")){
			console.log("클릭1");
			var check = $(this).hasClass('active');
			if(check == true){
				$(this).children('.depth2').slideUp();
				$(this).removeClass('active');
			}else{
				$(this).children('.depth2').slideDown();
				$(this).addClass('active');
			}	
		}else if($(e.target).hasClass("slide-tab")){
			console.log("클릭2");
			var check = $(this).hasClass('active');
			if(check == true){
				$(this).children('.depth2').slideUp();
				$(this).removeClass('active');
			}else{
				$(this).children('.depth2').slideDown();
				$(this).addClass('active');
			}
		}
	});

	$('.arco-title').on('click', function(e){
		
		if(e.target.className != "btn-s-round" && e.target.className != "btn-s-round mr10"){
			$(this).next('.arco-cont').slideToggle();
			$(this).toggleClass('active');	
		}
	});

	$('.show-next').on('click', function(e){
		$(this).next().show();
	});

	$('.open-pop').on('click', function(e){
		$('.popup').addClass('active');
	});

	$('.close').on('click', function(e){
		$('.popup').removeClass('active');
	});

	$('.icon-menu').on('click', function(){
		$('.drawer').addClass('active');
	});

	$('.icon-close').on('click', function(){
		$('.drawer').removeClass('active');
	});

	$('.popup .pop-title .delete').on('click', function(){
		$('.popup').hide();
	});

	$('.show-group').on('click', function(){
		$('.group-edit').css({ display: 'flex' });
	});

	$('.datepick-from').datepicker({
		dayNames: ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'],
		dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
		monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
	});
	$('.datepick-to').datepicker({
		dayNames: ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'],
		dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
		monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
	});

	$( "#datepicker" ).datepicker({
		dayNames: ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'],
		dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
		monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
	});


	var dateFormat = "yy-mm-dd",
	from = $( "#from" )
	  .datepicker({
		defaultDate: "+1w",
		changeMonth: true,
		numberOfMonths: 1,
		changeMonth: true, 
		dayNames: ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'],
		dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
		monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
	  })
	  .on( "change", function() {
		to.datepicker( "option", "minDate", getDate( this ) );
	  }),
	to = $( "#to" ).datepicker({
	  defaultDate: "+1w",
	  changeMonth: true,
	  numberOfMonths: 1,
	  changeMonth: true, 
	  dayNames: ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'],
	  dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
	  monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
	  monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
	})
	from = $( "#from2" )
	  .datepicker({
		defaultDate: "+1w",
		changeMonth: true,
		numberOfMonths: 1,
		changeMonth: true, 
		dayNames: ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'],
		dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
		monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
	  })
	  .on( "change", function() {
		to.datepicker( "option", "minDate", getDate( this ) );
	  }),
	to = $( "#to2" ).datepicker({
	  defaultDate: "+1w",
	  changeMonth: true,
	  numberOfMonths: 1,
	  changeMonth: true, 
	  dayNames: ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'],
	  dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
	  monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
	  monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
	})
	.on( "change", function() {
	  from.datepicker( "option", "maxDate", getDate( this ) );
	});

  function getDate( element ) {
	var date;
	try {
	  date = $.datepicker.parseDate( dateFormat, element.value );
	} catch( error ) {
	  date = null;
	}

	return date;
  }


	
  });

/* 이메일 검증 Function */
function CheckEmail(str)
{
	var reg_email = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;
    if(!reg_email.test(str)) {
    	return false;
	}else{
		return true;
	}
}

/* 패스워드 검증 */
function chekPassword(pw){
	var regExpPw = /(?=.*\d{1,50})(?=.*[~`!@#$%\^&*()-+=]{1,50})(?=.*[a-zA-Z]{1,50}).{8,20}$/;
	if(regExpPw.test(pw))
		return true;
	else
		return false;	
}