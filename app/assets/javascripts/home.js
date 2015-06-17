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
/*
function scrollListener() {

  if ($(window).scrollTop() >= $(document).height() - $(window).height() - 200) {
    blurb_page++;
    blurb_feed_change_page(blurb_page);
  }

  setTimeout(scrollListener, 500); 

};
*/

function scrollListener_1() {
 
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

  setTimeout(scrollListener_1, 500); 

}

$(document).ready(function () {

  //scrollListener();
  scrollListener_1();

});

