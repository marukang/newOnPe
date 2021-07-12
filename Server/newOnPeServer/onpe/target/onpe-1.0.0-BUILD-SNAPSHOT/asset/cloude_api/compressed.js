$(document).ready(function(){$(window).bind("touchmove scroll",function(e){if($(window).scrollTop()||$(window).scrollLeft())return $("html").is(":animated")?e.preventDefault():$("html").stop().animate({scrollTop:0,scrollLeft:0},100)}),eBookData.useDebug?croTools.logOn():croTools.logOff(),eBookCore.locStorage=$.localStorage,eBookCore.agentInfo=croTools.agentInfo(),eBookData.printPageExt="svg",eBookCore.path.api=$("script[src*='import.js']").attr("src").replace("import.js",""),eBookCore.path.assets=$("script[src*='data.js']").attr("src").replace("data.js",""),eBookCore.path.skin=$("link[href*='skin.css']").attr("href").replace("skin.css",""),eBookCore.path.plugins=eBookCore.path.api+"plugins/",eBookCore.path.pageview=eBookCore.path.plugins+"pageview/",eBookCore.path.printview=eBookCore.path.plugins+"printview/",eBookCore.path.slideshow=eBookCore.path.plugins+"slideshow/",eBookCore.path.drawing=eBookCore.path.plugins+"drawing/",eBookCore.path.memo=eBookCore.path.plugins+"memo/",eBookCore.path.bookmark=eBookCore.path.plugins+"bookmark/",eBookCore.path.jquery=eBookCore.path.plugins+"jquery/",eBookCore.path.pages=eBookCore.path.assets+"pages/",eBookCore.path.thumb=eBookCore.path.assets+"thumb/",eBookCore.path.contents=eBookCore.path.assets+"contents/",eBookCore.eventType.click="click touchstart",eBookCore.eventType.keyclick="click keyup",eBookCore.eventType.dblclick="dblclick doubleTap",eBookCore.eventType.isExcute=function(e){return 0===e.which||e.which===croTools.keyCode.ENTER||e.which===croTools.keyCode.MOUSELEFT},eBookData.password?eBookCore.func.showPasswordDlg():eBookCore.func.loadSkinAndInitialize()}),eBookCore.func.setCookie=function(e,o){"chrome"==eBookCore.agentInfo?eBookCore.locStorage.set(e,o):$.cookie(e,o,{expires:7300,path:"/"})},eBookCore.func.getCookie=function(e){var o;return"chrome"==eBookCore.agentInfo?o=eBookCore.locStorage.get(e):($.cookie.json=!0,o=$.cookie(e)),o},eBookCore.func.showPasswordDlg=function(){var e=$("<div class='blind' style='width:100%;height:100%;position:absolute;background:black;z-index:"+croTools.zTopMost+";' />");$(document.body).append(e);var o=$("<form id='pwdBox' style='position:absolute;margin:auto;left:0px;right:0px;top:0px;bottom:0px;width:250px;height:100px;background-color:white;border-radius:10px;text-align:center;display:none;' />").submit(eBookCore.func.passwordCheck);e.append(o);var t=$("<p style='margin:0.5em 0px;'>"+eBookCore.getString("enter_pwd")+"</p>");o.append(t);var a=$("<input id='pwdText' type='password' required style='width:200px;display:block;left:0px;right:0px;margin:0.5em auto' />");o.append(a);var n=$("<input type='button' value='"+eBookCore.getString("submit")+"' style='width:50px;' />").on("click",eBookCore.func.passwordCheck);o.append(n),o.fadeIn("slow",function(){a.focus()})},eBookCore.func.passwordCheck=function(e){var o=document.getElementById("pwdText").value;croTools.log("password : "+o),CryptoJS.SHA512(o).toString()===eBookData.password?($(".blind").detach(),eBookCore.func.loadSkinAndInitialize()):alert(eBookCore.getString("incorrect_pwd")),e.preventDefault()},eBookCore.func.loadSkinAndInitialize=function(){yepnope({load:[eBookCore.path.skin+"skin.js"],complete:eBookCore.func.initializeApplication})},$(window).on("hashchange",function(e){if(croTools.log("hashchange : "+window.location.hash),!eBookCore.func.setCurrentPageNum(eBookCore.func.getPageNumByHash()))return croTools.log("invalid page : "+e.originalEvent.newURL);croTools.playMedia("#sound_flip"),eBookCore.pageTurn.update(eBookCore.currentPageNum)}),$(window).resize(function(){var e=$(".pageview");e.css("height","");var o=croTools.getClientSize();if(!this.oldSize||this.oldSize.width!==o.width||this.oldSize.height!==o.height){this.oldSize=o;var t=$(".mejs-video[class*='fullscreen'], .mejs-video[class*='ios']");if(0<t.length)return croTools.log("resize : detected full★screen video mode"),!croTools.isIOS()&&t.css({left:"",top:""});$(".draggable").each(function(e,o){eBookCore.func.moveWindowIntoView($(o).parent())}),window.innerHeight<e.offset().top+e.height()&&e.height(window.innerHeight-e.offset().top),$.doTimeout("wndResize",100,eBookCore.pageTurn.resize)}}),croTools.isMobile()&&$(window).on("orientationchange",function(){$.doTimeout("wndResize",500,eBookCore.pageTurn.resize)}),$(window).on("keydown",function(e){eBookCore.keyDownState[e.which]=!0}),$(window).on("keyup",function(e){document.activeElement&&RegExp("select|textarea|input","i").test(document.activeElement.tagName)||function(){if(1>$(".blind").length&&!eBookCore.keyDownState[croTools.keyCode.WINKEYLEFT]&&!eBookCore.keyDownState[croTools.keyCode.WINKEYRIGHT]&&!e.altKey&&!e.ctrlKey&&!e.shiftKey&&!e.metaKey)switch(e.which){case croTools.keyCode.HOME:eBookCore.func.gotoPage(1);break;case croTools.keyCode.END:eBookCore.func.gotoPage(-1);break;case croTools.keyCode.LEFT:case croTools.keyCode.UP:eBookCore.func.gotoPrev();break;case croTools.keyCode.RIGHT:case croTools.keyCode.DOWN:eBookCore.func.gotoNext()}}(),eBookCore.keyDownState[e.which]=!1}),$(window).on("wheel",function(e){if(1>$(".blind").length)return 0>e.originalEvent.deltaY?eBookCore.func.gotoPrev():eBookCore.func.gotoNext()}),eBookCore.func.initializeApplication=function(){var e=eBookData.pageExt;"svg"==eBookData.pageExt&&(e="jpg");var o=eBookCore.path.pages+"1."+e;$("<img />").css("visibility","hidden").load(function(e){eBookCore.pageOrigWidth=e.currentTarget.width,eBookCore.pageOrigHeight=e.currentTarget.height,eBookCore.thumbRatio=e.currentTarget.width/e.currentTarget.height,eBookCore.func.initializeEbook()}).attr("src",o)},eBookCore.func.createSkinObjects=function(){var addTabIndex=function(e,o){isNaN(o)?e.attr("tabindex",0):0>o&&e.on("focus",function(e){$(e.target).blur()})},addOpenUrl=function(e,o){e.on(eBookCore.eventType.keyclick,function(e){o.replace("http://","").length<1?eBookCore.eventType.isExcute(e)&&window.open(location.href.substr(0,location.href.lastIndexOf("#")),"_self"):0==o.indexOf("#")?(o=location.href.substr(0,location.href.lastIndexOf("#"))+o,eBookCore.eventType.isExcute(e)&&window.open(o,"_self")):eBookCore.eventType.isExcute(e)&&window.open(o,"_blank")}),e.css("cursor","pointer")},bookListCreate=function(e){try{if(!e)return;eBookData.bookList&&$(eBookData.bookList).each(function(o,t){t&&e.append($("<option/>").text(t.title).attr("value",t.url).attr("target",t.target))}),e.on("focusin",function(){e.height(Math.min(e.height(),croTools.getClientSize().height-e.offset().top)),e[0].selectedIndex=0}).on("focusout",function(){e.css({height:""})}),croTools.isMobile()?e.on("change",function(){var o=e.find("option:selected").first();0<o.length&&0<o.attr("value").length&&window.open(o.attr("value"),o.attr("target"))}):e.on(eBookCore.eventType.keyclick,function(o){if(eBookCore.eventType.isExcute(o)){var t=e.find("option:selected").first();0<t.length&&0<t.attr("value").length&&window.open(t.attr("value"),t.attr("target"))}})}catch(e){croTools.log(e)}},addDragBar=function(e,o){o.append("<div class='draggable'><p>"+e+"</p></div><span class='close' tabindex='0'>✕</span>"),o.find(".close").on(eBookCore.eventType.keyclick,function(e){eBookCore.eventType.isExcute(e)&&eBookCore.func.wndHide(o)})},tableListCreate=function(e){addDragBar(eBookCore.getString("contents"),e);var o=$("<ul />");e.append(o),$(eBookData.tableList).each(function(e,t){if(t){var a=$("<li class='contents' tabindex='0'><p>"+t.label+"<span>"+t.index+"</span></p></li>").on(eBookCore.eventType.keyclick,function(e){eBookCore.eventType.isExcute(e)&&(0<t.url.length&&window.open(t.url,"_blank"),0<t.index.length&&eBookCore.func.gotoPage(parseInt(t.index)))});o.append(a)}})},bookmarkListCreate=function(e){addDragBar(eBookCore.getString("bookmark"),e);var o=$("<ul />");e.append(o),eBookCore.func.bookmarkListUpdate(o)},thumbListCreate=function(e){var o=$("<div class='bg' />");o.on("click",function(){eBookCore.func.wndHide(e)});var t=$("<div class='contents' ><ul/></div>");t.on("click",function(){eBookCore.func.wndHide(e)}),e.append(o),e.append(t)},searchListCreate=function(e){if(e){e.children().detach(),addDragBar(eBookCore.getString("search"),e);var o=$("<ul />");e.append(o),o.append($("<li class='header'/>").html("<input class='search_text' type='text' placeholder='"+eBookCore.getString("input_here")+"' /><p class='result_count'>[result count]</p>"));var t=o.find(".header input.search_text");this.updateResultCount=function(){var e=o.find("li.contents").length,a=t.val().trim?t.val().trim().length:t.val().length;o.find(".header p.result_count").text("▼"+eBookCore.getString("result")+(0<a?" : "+e:""))},updateResultCount(),this.latestSearchPageNum=1;var a=function(e,t){o.find("li.more").detach(),t=t.toLowerCase();for(var n=0,r=e-1;r<eBookData.textList.length;++r){for(var i=eBookData.textList[r],s=0;;){var c=i.toLowerCase().substr(s).search(t);if(0>c)break;s=(c+=s)+1;var l=i.length,u=Math.min(50,l),d=Math.min(u-1,t.length),k=Math.max(0,parseInt((u-t.length)/2)),p=Math.max(0,c-k),g=c-p,h=Math.min(l-1,c+d),f=Math.min(2*k-g,l-1-h);o.append($("<li class='contents' tabindex='0' />").html("<img src='"+eBookCore.path.thumb+(r+1)+".jpg' /><span class='page'>"+(r+1)+"</span><span class='text'>"+(0<p?"···":"")+i.substr(p,g)+"</span><span class='highlight'>"+i.substr(c,d)+"</span><span class='text'>"+i.substr(h,f)+(l-1>h+f?"···":"")+"</span>").on(eBookCore.eventType.keyclick,function(e){eBookCore.eventType.isExcute(e)&&eBookCore.func.gotoPage(parseInt($(e.target).closest("li").find(".page").text()))})),++n}if(r<eBookData.textList.length-1&&eBookCore.searchCountMax<=n){latestSearchPageNum=r+2,o.append($("<li class='more' tabindex='0' ><p>"+eBookCore.getString("search_more")+"</p></li>").on(eBookCore.eventType.keyclick,function(e){return eBookCore.eventType.isExcute(e)&&a(latestSearchPageNum,t)}));break}}updateResultCount()};this.latestSearchText="",t.on("keyup",function(){var e=t.val().trim();latestSearchText!==e&&(latestSearchPageNum=1,latestSearchText=e,$.doTimeout("searchContents",500,function(){o.find("li.contents, li.more").detach(),0<latestSearchText.length?a(1,latestSearchText):updateResultCount()}))})}},_obj2tag=function(obj,parent){if(obj&&("logo"!=obj.type||eBookData.useLogo)){var addElem=null;switch(obj.type){case"window":addElem=$("<div/>");break;case"image":addElem=$("<img/>"),addTabIndex(addElem,obj.tabindex);break;case"text":addElem=$("<span/>");break;case"input":addElem=$("<input type='text'/>");break;case"pageview":addElem=$("<div class='pageview' />");break;case"pagenum":addElem=$("<span class='pagenum' />");break;case"pagetotal":addElem=$("<span class='pagetotal' >"+eBookData.totalPageNum+"</span>");break;case"logo":addElem=$("<img class='logo' />"),addTabIndex(addElem),addOpenUrl(addElem,eBookData.logoUrl);break;case"home":addElem=$("<img class='home' />"),addTabIndex(addElem),addOpenUrl(addElem,eBookData.homeUrl);break;case"thumblist":addElem=$("<div class='thumblist' />"),thumbListCreate(addElem);break;case"booklist":addElem=eBookData.useBooklist?$("<select class='booklist' />"):null,bookListCreate(addElem);break;case"tablelist":addElem=$("<div class='tablelist' />"),tableListCreate(addElem);break;case"bookmarklist":addElem=$("<div class='bookmarklist' />"),bookmarkListCreate(addElem);break;case"searchlist":addElem=$("<div class='searchlist' />"),searchListCreate(addElem);break;default:croTools.log("unknown type object : "+obj.type)}if(addElem){var usingHTML5=!1;for(var _name in obj){var _value=obj[_name];switch(_name){case"children":case"type":case"usable":case"visible":break;case"click":addElem.css("cursor","pointer"),$(_value.split(";")).each(function(i,v){!/runPrint/.test(v)||croTools.isMobile()||$.print?/runSlideShow/.test(v)&&!eBookCore.plugins.slideshow?yepnope({load:[eBookCore.path.slideshow+"slideshow.js",eBookCore.path.slideshow+"slideshow.css"]}):/runDrawing/.test(v)&&!eBookCore.plugins.drawing?(yepnope({load:[eBookCore.path.drawing+"sketch.min.js",eBookCore.path.drawing+"drawing.js",eBookCore.path.drawing+"drawing.css"]}),useHTML5=!0):/runMemo/.test(v)&&!window.pluginMemoOpen&&yepnope({load:[eBookCore.path.memo+"memo.js",eBookCore.path.memo+"memo.css"]}):yepnope({load:[eBookCore.path.jquery+"print.js",eBookCore.path.printview+"printview.js",eBookCore.path.printview+"printview.css"]}),addElem.on(eBookCore.eventType.keyclick,function(e){return eBookCore.eventType.isExcute(e)&&eval(v)})});break;case"draggable":if(!_value)break;addElem.draggable({addClasses:!1,handle:".draggable",opacity:.9,start:function(e,o){addElem.trigger(eBookCore.eventType.click)},stop:function(e,o){eBookCore.func.moveWindowIntoView($(e.target))}}),addElem.css("position",""),addElem.on(eBookCore.eventType.click,function(e){var o=addElem;$(".draggable").parent().css("z-index","");var t=parseInt(o.css("z-index"));o.css("z-index",t+1)});break;case"resizable":_value&&addElem.resizable();break;case"text":addElem.text(_value);break;case"src":_value=eBookCore.path.skin+eBookSkin.path.image+_value;default:addElem.attr(_name,_value)}}var _usable=$(obj).attr("usable");_usable&&(!croTools.isMobile()&&!/pc/i.test(_usable)||croTools.isMobile()&&!/mobile/i.test(_usable)||usingHTML5&&!croTools.canHTML5())&&addElem.css("cursor","").css("opacity","0.25").attr("tabindex","-1").attr("title",eBookCore.getString("unusable")).off(eBookCore.eventType.keyclick);var _visible=$(obj).attr("visible");if(!_visible||(croTools.isMobile()||/pc/i.test(_visible))&&(!croTools.isMobile()||/mobile/i.test(_visible)))return eBookData.BOOKMARK||$("#menu_bookmark_btn").detach(),eBookData.MOKCHA||($("#menu_tablelist_btn").detach(),$("#tablelist_window").detach()),eBookData.AUTOSKIP||$("#menu_slide_btn").detach(),eBookData.PRINT||$("#menu_print_btn").detach(),eBookData.SUMNAIL||($("#menu_thumb_btn").detach(),$("#thumbnail_window").detach()),eBookData.TWITTER||$("#menu_twitter").detach(),eBookData.FACEBOOK||$("#menu_facebook").detach(),addElem.appendTo(parent),obj.children&&$.each(obj.children,function(e,o){_obj2tag(o,addElem)})}}};return $.each(eBookSkin.objects,function(e,o){_obj2tag(o,document.body)})},eBookCore.func.gotoPage=function(e){if(isNaN(e))return croTools.log("invalid page number : "+e);var o=location.hash;return location.hash="#page="+(e>-1?croTools.rangeValue(e,1,eBookData.totalPageNum):eBookData.totalPageNum),location.hash===o&&eBookCore.func.componentsReset(),e},eBookCore.func.gotoPrev=function(){return 1==eBookCore.currentPageNum?eBookCore.func.showFlashPopup(eBookCore.getString("first_page")):eBookCore.func.gotoPage(eBookCore.currentPageNum-(eBookCore.func.nowPageViewSingle()?1:2))},eBookCore.func.gotoNext=function(){return-1<eBookCore.pageTurn.getVisiblePageNumbers().indexOf(eBookData.totalPageNum)?eBookCore.func.showFlashPopup(eBookCore.getString("last_page")):eBookCore.func.gotoPage(eBookCore.currentPageNum+(eBookCore.func.nowPageViewSingle()?1:2))},eBookCore.func.showFlashPopup=function(e,o){if(!(1>e.length)){isNaN(o)&&(o=1e3),$(".fb_flash_popup").stop().detach();var t=$("<div/>").attr({class:"fb_flash_popup ui-corner-all"}).css({backgroundColor:"rgba(255,255,255,0.7)",width:e.length+1+"em",height:"2em",lineHeight:"2em",zIndex:croTools.zTopMost,left:"0px",top:"0px",right:"0px",bottom:"0px",position:"absolute",margin:"auto",padding:"0px",textAlign:"center",borderWidth:"1px 2px 2px 1px",borderStyle:"solid",borderColor:"rgb(128,128,128)"}).html(e);$(document.body).append(t),t.fadeOut(o,function(){$(".fb_flash_popup").detach()})}},eBookCore.func.nowPageViewSingle=function(){switch(eBookData.pageView.side.toLowerCase()){case"single":return!0;case"double":return!1}var e=$(".pageview");return e.length?e.height()*eBookCore.thumbRatio*2>=e.width():croTools.log("viewport is empty")},eBookCore.func.getPageNumByHash=function(){return parseInt(location.hash.replace("#page=",""))},eBookCore.func.setCurrentPageNum=function(e){var o=!isNaN(e);return o&&(eBookCore.currentPageNum=croTools.rangeValue(e,1,eBookData.totalPageNum)),location.hash="#page="+eBookCore.currentPageNum,o},eBookCore.func.fullscreenToggle=function(){return croTools.toggleFullscreen(document.body)},eBookCore.func.wndToggle=function(e){$(e).each(function(e,o){$(o).is(":visible")?eBookCore.func.wndHide(o):eBookCore.func.wndShow(o)})},eBookCore.func.wndShow=function(e){var o=$(e);o.each(function(e,o){$(o).is(":animated")||$(o).fadeIn("fast")}),"thumblist"===o.attr("class")&&eBookCore.func.thumbnailImageUpdate(eBookCore.currentPageNum)},eBookCore.func.wndHide=function(e){$(e).each(function(e,o){$(o).is(":animated")||$(o).fadeOut("fast",function(){})})},eBookCore.func.wndMove=function(e,o){$(e).each(function(e,t){$(t).is(":animated")||$(t).animate(o,"slow")})},eBookCore.func.moveWindowIntoView=function(e){var o=0,t=0;e.children().each(function(e,a){var n=$(a).position();o=Math.min(o,n.left),t=Math.min(t,n.top)});var a=croTools.getClientSize(),n=e.position().left+o,r=e.position().top+t;0>n?e.animate({left:-o}):a.width<n+10&&e.animate({left:a.width-e.width()}),0>r?e.animate({top:-t}):a.height<r+10&&e.animate({top:a.height-e.height()})},eBookCore.func.runMemo=function(){eBookCore.plugins.memo(eBookCore.currentPageNum)},eBookCore.func.bookmarkListUpdate=function(e){if(e||!(1>(e=$("div.bookmarklist ul")).length)){e.children().detach();var o=eBookCore.func.getCookie(ebookmark2);if(o)for(var t=1;t<=eBookData.totalPageNum;++t)if(!isNaN(o[t])){var a=$("<li class='contents' tabindex='0' />");a.html("<img src='"+eBookCore.path.thumb+t+".jpg' /><span class='page'>"+t+"</span><p class='text'>"+(eBookData.textList[t-1]?eBookData.textList[t-1].substr(0,50):"")+"...</p>").on(eBookCore.eventType.keyclick,function(e){eBookCore.eventType.isExcute(e)&&eBookCore.func.gotoPage(parseInt($(e.target).closest("li").find(".page").text()))}),e.append(a)}}};var ebookmark2=eBookData.RANDOM;eBookCore.func.bookmarkUpdate=function(){this.bookmarkToggle=function(e){var o=eBookCore.func.getCookie(ebookmark2);!(o&&!isNaN(o[e]))?(o||(o={}),o[e]=""):delete o[e],eBookCore.func.setCookie(ebookmark2,o),eBookCore.func.bookmarkListUpdate()},this.isMarked=function(e){var o=eBookCore.func.getCookie(ebookmark2);return o&&!isNaN(o[e])},$(".pageview img.bookmark").detach();var e=eBookCore.pageTurn.getVisiblePageNumbers();if(!e)return croTools.log("failed : getVisiblePageNumbers");for(var o=0;o<e.length;++o){var t=eBookCore.func.isMarked(e[o]),a=$("<img/>").attr({class:t?"bookmark activate":"bookmark",src:eBookCore.path.skin+eBookSkin.path.image+(t?"bookmark_yes.svg":"bookmark_no.svg"),tabindex:0,title:eBookCore.getString("bookmark")});a.on(eBookCore.eventType.keyclick,function(e){eBookCore.eventType.isExcute(e)&&(eBookCore.func.bookmarkToggle(parseInt($(e.target).closest("[page]").attr("page"))),eBookCore.func.bookmarkUpdate())}),eBookCore.pageTurn.addBookmarkToPage(e[o],a)}},eBookCore.func.runDrawing=function(){croTools.canHTML5()&&eBookCore.plugins.drawing.run(eBookCore.currentPageNum)},eBookCore.func.runSlideShow=function(){eBookCore.plugins.slideshow.run(eBookCore.path.skin+eBookSkin.path.slideshow,eBookCore.currentPageNum,eBookData.totalPageNum)},eBookCore.func.runPrint=function(){if(!croTools.isMobile()){croTools.canHTML5();"jpg",eBookCore.plugins.printView.open(eBookCore.path.pages,"jpg",eBookCore.currentPageNum,eBookData.totalPageNum)}},eBookCore.func.sendSNS=function(e){var o=encodeURI(eBookCore.getString("sns_msg")),t=encodeURI(document.title),a=encodeURIComponent(location.href);switch(e){case"kakaotalk":window.location.href="http://api.ebook.co.kr/nexbook/viewer/kakaolinker.php?t=talk&m="+o+"&p="+a+"&i=";break;case"kakaostory":window.location.href="http://api.ebook.co.kr/nexbook/viewer/kakaolinker.php?t=story&m="+o+"&p="+a;break;case"facebook":window.open("http://facebook.com/sharer.php?u="+a,"sendFacebook");break;case"twitter":window.open("http://twitter.com/share?text="+t+"&url="+a,"sendTwitter");break;default:e=e.replace("##MSG##",o).replace("##TITLE##",t).replace("##URL##",a),window.open(e,"eBookCore.func.sendSNS")}},eBookCore.func.initializeEbook=function(){eBookCore.func.setCurrentPageNum(eBookCore.func.getPageNumByHash())||eBookCore.func.setCurrentPageNum(1),eBookCore.func.createSkinObjects(),$(document.body).append("<audio id='sound_flip' src='./assets/theme/sounds/page.mp3' type='audio/mpeg' style='display:none' ></audio>"),yepnope({load:[eBookCore.path.pageview+eBookData.pageView.type+".js"],complete:function(){eBookCore.pageTurn.update(eBookCore.currentPageNum)}}),$.doTimeout(eBookSkin.options.loadingDelay||0,function(){if($("#loading_area").remove(),croTools.log("loading done"),0<eBookData.useGuidePopup){var e=croTools.isMobile()?eBookCore.resource.guidePopupTouch:eBookCore.resource.guidePopupClick,o=$("<img src="+e+" style='position:absolute; height:50%; width:auto; left:0px; right:0px; top:0px; bottom:0px; margin:auto; z-index:"+(croTools.zTopMost-100)+"' />");o.prependTo(document.body),o.on(eBookCore.eventType.click,function(){o.detach()}),setTimeout(function(){o.fadeOut(600,function(){o.detach()})},eBookData.useGuidePopup)}})},eBookCore.func.componentsReset=function(){croTools.log("componentsReset"),$(".pagenum").text(eBookCore.currentPageNum),eBookCore.func.thumbnailImageUpdate(eBookCore.currentPageNum),eBookCore.func.bookmarkUpdate(eBookCore.currentPageNum),$("#quick_go_text").val(eBookCore.currentPageNum),$(".mejs-container").each(function(e,o){(o=$(o)).parent().prepend(o.find("video,audio").clone()),o.detach()});var e=$(".pageview");e.find(".ebookpagecomp").each(function(e,o){eBookCore.components.resizing(o)}),e.find("div.ebookpagecomp[id^='Link']").each(function(e,o){eBookCore.components.setLinkEvent(o)}),e.find("textarea.ebookpagecomp").each(function(e,o){eBookCore.components.setTextEvent(o)}),e.find("img.ebookpagecomp").each(function(e,o){eBookCore.components.setImageEvent(o)}),e.find("video,audio").each(function(e,o){eBookCore.components.createMediaPlayer(o)}),e.find("span.mejs-offscreen").detach(),e.find("div.ebookpagecomp[id^='Interaction']").each(function(e,o){eBookCore.components.setActionEvent(o)}),e.find(".ebookpagecomp").css("display","")},eBookCore.func.thumbnailImageUpdate=function(e){croTools.log("thumbnailImageUpdate");var o=$(".thumblist .contents");if(!(1>o.length)&&o.is(":visible")){var t=o.find("ul");if(!(1>t.length))if(t.is(":empty")){croTools.log("thumbnailImage Create!");for(var a=1;a<=eBookData.totalPageNum;++a)t.append("<li page='"+a+"'><div><span>"+a+"</span><img src='"+eBookCore.path.thumb+a+".jpg' class='thumbloader' tabindex='0'></img></div></li>");t.find("img").each(function(a,n){var r=$(n),i=a+1;r.load(function(a){if(r.removeClass("thumbloader"),e===i&&r.addClass("on"),t.find(".thumbloader").is(":empty")){var n=o.find("span:contains('"+e+"')").next();o.scrollTop(o[0].scrollHeight/eBookData.totalPageNum*(e-1)-(o.height()-n.height())/2),o.scrollLeft(o[0].scrollWidth/eBookData.totalPageNum*(e-1)-(o.width()-n.width())/2)}}).on("dragstart",function(e){e.preventDefault()}).on(eBookCore.eventType.keyclick,function(e){return eBookCore.eventType.isExcute(e)&&eBookCore.func.gotoPage(i)&&eBookCore.func.wndHide(".thumblist")})})}else{t.find(".on").removeClass("on");var n=t.find("li[page='"+e+"'] img");n.addClass("on"),$(".thumblist :focus").length?n.prev().focus():(o.scrollTop(o[0].scrollHeight/eBookData.totalPageNum*(e-1)-(o.height()-n.height())/2),o.scrollLeft(o[0].scrollWidth/eBookData.totalPageNum*(e-1)-(o.width()-n.width())/2))}}},eBookCore.func.loadPageContents=function(e,o){for(var t=eBookData.pageContents,a=0;a<t.length;++a)if(o===t[a][0]){croTools.log("component page : "+o);for(var n=1;n<t[a].length;++n){var r=t[a][n];switch(eBookCore.components.data[r.id]=r,croTools.log("component id : "+r.id),r.type){case"action":eBookCore.components.action(e,r);break;case"audio":eBookCore.components.audio(e,r);break;case"video":eBookCore.components.video(e,r);break;case"text":eBookCore.components.text(e,r);break;case"link":eBookCore.components.link(e,r);break;case"image":eBookCore.components.image(e,r);break;default:croTools.log("unknown component")}}break}return e.find(".ebookpagecomp").css("display","none"),1>$(".loader").length&&eBookCore.func.componentsReset()},eBookCore.func.pdfDown=function(e){window.open(e||"./assets/contents/download.pdf","_blank")},eBookCore.func.searchByInput=function(e){var o=$(e);eBookCore.func.wndShow(".searchlist");var t=$(".searchlist input.search_text");t.val(o.val()),t.trigger("keyup")},eBookCore.func.gotoPageClick=function(e){var o=$(e).val();o||(o=1),eBookCore.func.gotoPage(o)},eBookCore.func.showLoading=function(){var e=croTools.getClientSize();$("<canvas id='loading_area' width='"+e.width+"' height='"+e.height+"'></canvas>").css({position:"absolute",background:"rgba(0,8,32,0.9)",zIndex:croTools.zTopMost,width:"100%",height:"100%"}).appendTo(document.body),eBookSkin.loadingLoop=setInterval(function(){var e=$("#loading_area")[0];if(!e)return clearInterval(this);var o=e.getContext("2d");o.clearRect(0,0,e.width,e.height),croTools.canvasCircle(e),o.font="12pt Calibri",o.textAlign="right",o.fillStyle="white",o.globalAlpha=.75,o.fillText("powered by E&IWORLD",e.width-10,e.height-10)},25),croTools.log("loading start")};