/**-------------------------------------------------------------------------------------------------
 *										확대축소 플러그인 스크립트
 *																					Date	: 2015.12.07
 *																					Author	: 박정민
 **/
eBookCore.plugins.zoomview = {

    ratio: 0, // 최초 배율값( % )
    origSize: {
        width: 0, // 원본 면적 크기( 확대 축소율 기준으로 사용 )
        height: 0
    },

    close: function(_imgEl, zoomEl) {}, // 확대축소 종료
    run: function(_imgEl) {}, // 확대축소 열기
    setInOut: function(_delta, _ratio) {}, // 확대축소 배율 변경( _delta : +-1, _ratio : %)
    rePosition: function() {}, // 페이지 위치 초기화
    setPagePos: function() {}, // 페이지 위치를 화면 안으로 강제 시킴
};

var _currentZoomPage = 1;
var zoomEl;

/** 확대축소 종료 */
eBookCore.plugins.zoomview.close = function(_imgEl, zoomEl) {

    eBookCore.func.gotoPage(_currentZoomPage);
    eBookCore.plugins.zoomview.loadPage(_imgEl, zoomEl, _currentZoomPage);

    // 등록 이벤트 제거
    $(window).off(".zoomview");
    // 줌 영역 객체 제거
    $(".zoomview").detach();

};

/** 확대축소 실행 */
eBookCore.plugins.zoomview.run = function(_imgEl) {

    if (!_imgEl) {
        return;
    }
    eBookCore.plugins.zoomview.close();

    // 줌 영역 생성
    zoomEl = $("<div class='zoomview'/>")
        .html("<div class='blind' /><img class='loading' src='" + eBookCore.path.pageview + "loading_zoom.gif' /><span class='zoomviewRatio'>0%</span>")
        .on("mousewheel", function(e) {
            eBookCore.plugins.zoomview.setInOut(e.deltaY, 0.1);
        })
        .on("pinching", function(e, i) {
            eBookCore.plugins.zoomview.setInOut(i.distance, Math.pow(Math.abs(i.distance), 1.1) * 0.001);
        })
        .on("click touchstart drag", function(e) {
            $(".zoomview .zoomviewBtn") // 동작이 감지되면 버튼 이미지들 표시 후 다시 흐려짐
                .stop()
                .css({
                    opacity: 1
                })
                .doTimeout(2000, function() {
                    this.stop().animate({
                        opacity: 0.2
                    }, 1000);
                });
        });
    zoomEl.appendTo(document.body);


    // var _zoomSkinPath = eBookCore.path.skin + eBookSkin.path.image + "zoomview/";
    // zoomEl.append("<img class='zoomviewBtn' id='zoomviewClose'	src='" + _zoomSkinPath + "close.png" + "' tabindex='0' alt='" + eBookCore.getString("close") + "' />" +
    //     "<img class='zoomviewBtn' id='zoomviewIn' 		src='" + _zoomSkinPath + "zoomin.png" + "' tabindex='0' alt='" + eBookCore.getString("zoomIn") + "' />" +
    //     "<img class='zoomviewBtn' id='zoomviewOut'		src='" + _zoomSkinPath + "zoomout.png" + "' tabindex='0' alt='" + eBookCore.getString("zoomOut") + "' />");

    var _iconWidth = window.innerWidth * 0.1;
    var _iconHeight = window.innerHeight * 0.1;

    var _zoomSkinPath = eBookCore.path.skin + eBookSkin.path.image + "zoomview/";
    zoomEl.append("<img class='zoomviewBtn' id='zoomviewClose'	src='" + _zoomSkinPath + "close.png" + "' tabindex='0' alt='" + eBookCore.getString("close") + "' />" +
        "<img class='zoomviewBtn' id='zoomviewIn' 		src='" + _zoomSkinPath + "zoomin.png" + "' tabindex='0' alt='" + eBookCore.getString("zoomIn") + "' />" +
        "<img class='zoomviewBtn' id='zoomviewOut'		src='" + _zoomSkinPath + "zoomout.png" + "' tabindex='0' alt='" + eBookCore.getString("zoomOut") + "' />" +
        /*        "<img class='zoomviewBtn' id='zoomviewFirst'	src='" + _zoomSkinPath + "first.svg" + "' tabindex='0' alt='" + eBookCore.getString("first_page") + "' />" + */
        "<img class='zoomviewBtn' id='zoomviewPrev'" + " style='width:" + _iconWidth + "px; height:" + _iconHeight + "px'		src='" + _zoomSkinPath + "prev.svg" + "' tabindex='0' alt='" + eBookCore.getString("prev_page") + "' />" +
        "<img class='zoomviewBtn' id='zoomviewNext'" + " style='width:" + _iconWidth + "px; height:" + _iconHeight + "px'		src='" + _zoomSkinPath + "next.svg" + "' tabindex='0' alt='" + eBookCore.getString("next_page") + "' />"
        /*        "<img class='zoomviewBtn' id='zoomviewLast'		src='" + _zoomSkinPath + "last.svg" + "' tabindex='0' alt='" + eBookCore.getString("last_page") + "' />" */
    );

    $("#zoomviewClose").on(eBookCore.eventType.keyclick, function(e) {
        eBookCore.eventType.isExcute(e) && eBookCore.plugins.zoomview.close();
    });
    $("#zoomviewIn").on(eBookCore.eventType.keyclick, function(e) {
        eBookCore.eventType.isExcute(e) && eBookCore.plugins.zoomview.setInOut(1, 0.2);
    });
    $("#zoomviewOut").on(eBookCore.eventType.keyclick, function(e) {
        eBookCore.eventType.isExcute(e) && eBookCore.plugins.zoomview.setInOut(-1, 0.2);
    });

    //2016.12.21 김대원 page 이동 이벤트
    $("#zoomviewPrev").on(eBookCore.eventType.keyclick, function(e) {
        eBookCore.eventType.isExcute(e) && eBookCore.plugins.zoomview.gotoPrev(_imgEl, zoomEl);
    });
    $("#zoomviewNext").on(eBookCore.eventType.keyclick, function(e) {
        eBookCore.eventType.isExcute(e) && eBookCore.plugins.zoomview.gotoNext(_imgEl, zoomEl);
    });

    _currentZoomPage = parseInt(_imgEl.closest("[page]").attr("page"));
    eBookCore.plugins.zoomview.loadPage(_imgEl, zoomEl, _currentZoomPage);

    /***********
        // 줌 대상 이미지 추가( SVG를 우선하여 적용 )
        var _srcIMG = eBookCore.path.pages + _imgEl.closest("[page]").attr("page") + "." + eBookData.pageExt; // data 이미지를 쓸 때를 위해 수정 _imgEl.attr("src");
        var _srcSVG = _srcIMG.substr(0, _srcIMG.lastIndexOf(".")) + ".svg";

        var imgEl = $(croTools.canHTML5() ? "<img class='target' src='" + _srcSVG + "' />" :
            "<img class='target' src='" + _srcIMG + "' />");

        imgEl.on("error", function() { // SVG 이미지가 없을 경우 jpg로 대체함
                imgEl.attr("src", _srcIMG);
            })
            .load(function() { // 이미지 로딩 완료 이벤트 처리

                // 로딩 이미지 제거
                zoomEl.find("img.loading").detach();

                // 확대 이미지 표시
                zoomEl.append(imgEl);

                setTimeout(function() {
                    // 원본 크기를 저장
                    eBookCore.plugins.zoomview.origSize = {
                        width: imgEl.width(),
                        height: imgEl.height()
                    };

                    // 표시 위치 초기화
                    eBookCore.plugins.zoomview.rePosition();
                }, croTools.isMSIE() ? 100 : 0); // 16.04.07 박정민 : IE에서 곧바로 호출시 이미지 사이즈를 제대로 읽지 못하는 문제 수정.
            })
            .on(eBookCore.eventType.dblclick, eBookCore.plugins.zoomview.close)
            .draggable({
                stop: eBookCore.plugins.zoomview.setPagePos
            });


        // 처음 시작시 버튼 이미지 보였다가 다시 흐려짐
        $(".zoomview .zoomviewBtn").animate({
            opacity: 1
        }, 1000).doTimeout(2000, function() {
            this.stop().animate({
                opacity: 0.2
            }, 1000);
        });

        // 확대율 텍스트 보였다가 사라짐
        $(".zoomviewRatio").animate({
            opacity: 1
        }, 1000, function() {
            $(".zoomviewRatio").doTimeout(2000, function() {
                this.animate({
                    opacity: 0
                }, 1000);
            })
        });

        // 이벤트 등록
        $(window).on("resize.zoomview", eBookCore.plugins.zoomview.rePosition);
    ***********/
};

/** 페이지 위치 초기화 */
eBookCore.plugins.zoomview.rePosition = function() {

    var imgEl = $(".zoomview img.target");

    var _wndSize = croTools.getClientSize();

    var _fitWidth = (_wndSize.height * eBookCore.thumbRatio > _wndSize.width);
    imgEl.css({
        width: _fitWidth ? _wndSize.width : _wndSize.height * eBookCore.thumbRatio,
        height: _fitWidth ? _wndSize.width * (1 / eBookCore.thumbRatio) : _wndSize.height,
    });

    imgEl.css({ // 이미지를 화면 중앙에 위치
        left: (_wndSize.width - imgEl.width()) / 2,
        top: (_wndSize.height - imgEl.height()) / 2
    });

    // 현재 배율 저장
    eBookCore.plugins.zoomview.ratio = imgEl.width() / eBookCore.plugins.zoomview.origSize.width;

    // 배율 표시값 갱신
    $(".zoomviewRatio").text(parseInt(eBookCore.plugins.zoomview.ratio * 100) + "%");
};

/** 휠 확대축소 이벤트 처리 함수 */
eBookCore.plugins.zoomview.setInOut = function(_delta, _ratio) {
    eBookCore.plugins.zoomview.ratio = 0 < _delta ? Math.min( /*max*/ 10, eBookCore.plugins.zoomview.ratio + _ratio) :
        Math.max( /*min*/ 0.01, eBookCore.plugins.zoomview.ratio - _ratio);

    var imgEl = $(".zoomview img.target");
    var _wndSize = croTools.getClientSize();

    // 줌 페이지가 화면보다 작으면 확대기능 해제
    if (0 > _delta && _wndSize.width > imgEl.width() && _wndSize.height > imgEl.height()) {
        return eBookCore.plugins.zoomview.close();
    }

    var _pagePos = imgEl.offset();
    var _wndCenter = {
        x: _wndSize.width / 2,
        y: _wndSize.height / 2
    };
    var _centerRatio = {
        x: (_pagePos.left - _wndCenter.x) / imgEl.width(),
        y: (_pagePos.top - _wndCenter.y) / imgEl.height()
    };

    // 현재 이미지 배율 갱신
    imgEl.css({
        width: eBookCore.plugins.zoomview.origSize.width * eBookCore.plugins.zoomview.ratio,
        height: eBookCore.plugins.zoomview.origSize.height * eBookCore.plugins.zoomview.ratio,
    });

    // 배율 표시값 갱신
    $(".zoomviewRatio").text(parseInt(eBookCore.plugins.zoomview.ratio * 100) + "%")
        .stop()
        .css({
            opacity: 1
        })
        .doTimeout(1000, function() {
            this.stop().animate({
                opacity: 0
            }, 1000);
        });

    // 화면 중점 기준으로 이미지 좌표 재설정
    imgEl.css({
        left: _wndCenter.x + imgEl.width() * _centerRatio.x,
        top: _wndCenter.y + imgEl.height() * _centerRatio.y
    });
    // 창을 벗어난 경우 강제로 위치 조정
    eBookCore.plugins.zoomview.setPagePos();
};


/** 페이지 위치를 화면 안으로 강제 시킴 */
eBookCore.plugins.zoomview.setPagePos = function() {
    var imgEl = $(".zoomview img.target");
    if (!imgEl.length) {
        return;
    }

    var _wndSize = croTools.getClientSize();
    var _pagePos = imgEl.offset();

    imgEl.css({ // 화면 밖으로 벗어나지 않게 좌표 보정
        left: croTools.rangeValue(_pagePos.left, imgEl.width() < _wndSize.width ? 0 : _wndSize.width - imgEl.width(),
            imgEl.width() > _wndSize.width ? 0 : _wndSize.width - imgEl.width()),
        top: croTools.rangeValue(_pagePos.top, imgEl.height() < _wndSize.height ? 0 : _wndSize.height - imgEl.height(),
            imgEl.height() > _wndSize.height ? 0 : _wndSize.height - imgEl.height()),
    });
};

/**
	2016.12.21 김대원
	페이지 Load */
eBookCore.plugins.zoomview.loadPage = function(_imgEl, zoomEl, displayPage) {

    // 줌 대상 이미지 추가( SVG를 우선하여 적용 )
    var _currPage = eBookCore.currentPageNum;
    var _dispalyCurrPage = displayPage.toString() + "";
    //zoomViewCurrentPage = parseInt(_imgEl.closest("[page]").attr("page"));
    var _srcIMG = eBookCore.path.pages + _dispalyCurrPage + "." + eBookData.pageExt; // data 이미지를 쓸 때를 위해 수정 _imgEl.attr("src");
    var _srcSVG = _srcIMG.substr(0, _srcIMG.lastIndexOf(".")) + ".svg";

    var imgEl = $(croTools.canHTML5() ? "<img class='target' src='" + _srcSVG + "' />" :
        "<img class='target' src='" + _srcIMG + "' />");

    imgEl.on("error", function() { // SVG 이미지가 없을 경우 jpg로 대체함
            imgEl.attr("src", _srcIMG);
        })
        .load(function() { // 이미지 로딩 완료 이벤트 처리

            // 로딩 이미지 제거
            zoomEl.find("img.loading").detach();

            // 확대 이미지 표시
            zoomEl.append(imgEl);

            setTimeout(function() {
                // 원본 크기를 저장
                eBookCore.plugins.zoomview.origSize = {
                    width: imgEl.width(),
                    height: imgEl.height()
                };

                // 표시 위치 초기화
                eBookCore.plugins.zoomview.rePosition();
            }, croTools.isMSIE() ? 100 : 0); // 16.04.07 박정민 : IE에서 곧바로 호출시 이미지 사이즈를 제대로 읽지 못하는 문제 수정.
        })
        .on(eBookCore.eventType.dblclick, eBookCore.plugins.zoomview.close)
        .draggable({
            stop: eBookCore.plugins.zoomview.setPagePos
        });


    // 처음 시작시 버튼 이미지 보였다가 다시 흐려짐
    $(".zoomview .zoomviewBtn").animate({
        opacity: 1
    }, 1000).doTimeout(2000, function() {
        this.stop().animate({
            opacity: 0.2
        }, 1000);
    });

    // 확대율 텍스트 보였다가 사라짐
    $(".zoomviewRatio").animate({
        opacity: 1
    }, 1000, function() {
        $(".zoomviewRatio").doTimeout(2000, function() {
            this.animate({
                opacity: 0
            }, 1000);
        });
    });

    // 이벤트 등록
    $(window).on("resize.zoomview", eBookCore.plugins.zoomview.rePosition);

};

/**
	2016.12.21 김대원
	페이지 Load
    gotoFistPage
    gotoPrev
    gotoNext
    gotoLastPage
  */
eBookCore.plugins.zoomview.gotoFistPage = function(_imgEl, zoomEl) {
    _currentZoomPage = 1;
    eBookCore.plugins.zoomview.loadPage(_imgEl, zoomEl, _currentZoomPage);
};

eBookCore.plugins.zoomview.gotoPrev = function(_imgEl, zoomEl) {
    if (_currentZoomPage > 1) {
        _currentZoomPage = _currentZoomPage - 1;
        eBookCore.plugins.zoomview.loadPage(_imgEl, zoomEl, _currentZoomPage);
    } else {
        eBookCore.func.showFlashPopup(eBookCore.getString("first_page"));
    }
};

eBookCore.plugins.zoomview.gotoNext = function(_imgEl, zoomEl) {
    if (_currentZoomPage < eBookData.totalPageNum) {
        _currentZoomPage = _currentZoomPage + 1;
        eBookCore.plugins.zoomview.loadPage(_imgEl, zoomEl, _currentZoomPage);
    } else {
        eBookCore.func.showFlashPopup(eBookCore.getString("last_page"));
    }
};

eBookCore.plugins.zoomview.gotoLastPage = function(_imgEl, zoomEl) {
    _currentZoomPage = eBookData.totalPageNum;
    eBookCore.plugins.zoomview.loadPage(_imgEl, zoomEl, _currentZoomPage);
};
