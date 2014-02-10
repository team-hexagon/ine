# 전역 객체
global =
    main: {}
    description: {}
    map: {}

# 보조 함수
# host = "http://127.0.0.1:3000"
host = ""
drawMap = (latlng) ->
    map = new google.maps.Map document.getElementById("map-canvas"),
        zoom: 10
        center: latlng
        mapTypeId: google.maps.MapTypeId.ROADMAP
    marker = new google.maps.Marker
        position: latlng
        map: map    
        title: "Event Location"

# 템플릿 설정
moment.lang "ja"
eventItemTemplate = _.template $("[data-template='rint-item']").html()

# 기본 설정
$(document).on "mobileinit", () ->
    $.mobile.toolbar.prototype.options.addBackBtn = true
    $.mobile.buttonMarkup.hoverDelay = 0
    #$.mobile.defaultPageTransition = "none"
    #$.mobile.defaultDialogTransition = "none"
$(document).ready () ->
    # 초기 페이지    
    $(document).on "pagecreate", "#main-page", () ->
        $.getJSON "#{host}/event", (events) ->
            output = ""
            events.forEach (event) ->
                output += eventItemTemplate event
            $("div.rint-events").off "click", "a"
            $("div.rint-events").html(output).on "click", "a", (event) ->
                global.description._id = $(this).parent().attr("data-id")
    # 지도 페이지
    $(document).on "pagecreate", "#map-page", () ->
        drawMap new google.maps.LatLng 34.0983425, -118.3267434
    # 설명 페이지
    $(document).on "pagebeforeshow", "#description-page", () ->
        $.getJSON "#{host}/event/#{global.description._id}", (event) ->
            console.log event