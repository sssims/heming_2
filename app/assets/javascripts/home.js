var blurb_page = 0;

function blurb_feed_change_page(page) {

  $.ajax({
    url: "/home/change_page",
    data: { 'blurb_page' : page },
    success: function (result) {
      $("#endless-scroll").html(result);
      $("#endless-scroll").attr("id", "scroll-page-" + page); 
    }
  });
  
  return;

}

function scrollListener() {
 
  var endless_scroll = $("#endless-scroll");

  if(!endless_scroll.length) {
    return;
  }

  var element_top = endless_scroll.offset().top;
  var scroll_top = $(window).scrollTop();
  var scroll_bottom = scroll_top + $(window).height();

  if (element_top > scroll_top && element_top < scroll_bottom) {
    blurb_page++;
    blurb_feed_change_page(blurb_page);
  }

  setTimeout(scrollListener, 500); 

}

$(document).ready(function () {
  blurb_page = 0;
  scrollListener();
});


$(document).on("page:load", function() {
  blurb_page = 0;
  scrollListener();
});

