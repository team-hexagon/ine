(function() {
  var drawMap, eventItemTemplate, global, host;

  global = {
    main: {},
    description: {},
    map: {}
  };

  host = "";

  drawMap = function(latlng) {
    var map, marker;
    map = new google.maps.Map(document.getElementById("map-canvas"), {
      zoom: 10,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
    return marker = new google.maps.Marker({
      position: latlng,
      map: map,
      title: "Event Location"
    });
  };

  moment.lang("ja");

  eventItemTemplate = _.template($("[data-template='rint-item']").html());

  $(document).on("mobileinit", function() {
    $.mobile.toolbar.prototype.options.addBackBtn = true;
    return $.mobile.buttonMarkup.hoverDelay = 0;
  });

  $(document).ready(function() {
    $(document).on("pagecreate", "#main-page", function() {
      return $.getJSON("" + host + "/event", function(events) {
        var output;
        output = "";
        events.forEach(function(event) {
          return output += eventItemTemplate(event);
        });
        $("div.rint-events").off("click", "a");
        return $("div.rint-events").html(output).on("click", "a", function(event) {
          return global.description._id = $(this).parent().attr("data-id");
        });
      });
    });
    $(document).on("pagecreate", "#map-page", function() {
      return drawMap(new google.maps.LatLng(34.0983425, -118.3267434));
    });
    return $(document).on("pagebeforeshow", "#description-page", function() {
      return $.getJSON("" + host + "/event/" + global.description._id, function(event) {
        return console.log(event);
      });
    });
  });

}).call(this);
