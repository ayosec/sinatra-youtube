jQuery(function($) {

  var videosBox = $("#videos");

  $("form input:submit").click(function(event) {
    event.preventDefault();
    var query = $("#query-field").val();

    $.post("/search", {q: query}).done(function(response) {
      videosBox.empty()
      response.forEach(function(item) {
        var videoItem = $("<div>");
        videoItem.append($("<img>", {src: item.thumbnail}));
        videoItem.append($("<a>", {href: item.link, text: item.title}));
        videoItem.appendTo(videosBox);

        // Replace image with the HTML on mouseenter event
        var sourceHTML = item.source_html;
        videoItem.mouseenter(function() {
          if(sourceHTML) {
            $.get(sourceHTML).
              done(function(response) { videoItem.html(response); }).
              fail(function() { videoItem.text("Failed to load content"); });

            videoItem.find("img").css("opacity", 0.1);
            sourceHTML = false;
          }
        });
      });
    });
  });
});
