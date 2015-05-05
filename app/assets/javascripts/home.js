// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

var blurb_page = 0;

function blurb_feed_change_page(page) {

  $.ajax({
    url: "/home/change_page",
    data: { 'blurb_page' : page },
    success: function (result) {
      $("#feed_content").html(result);
    }
  });
  
  return;
}


$(document).on("click", "#blurb_navigation > #prev", function() {

  if (blurb_page > 0) {
    blurb_page--;
  }

  blurb_feed_change_page(blurb_page);

});

$(document).on("click", "#blurb_navigation > #next", function() {

  blurb_page++;

  blurb_feed_change_page(blurb_page);

});


/*
$(document).ready( function() {
  $('.blurb_container').each(function() {
    var color = '#'+Math.random().toString(16).substr(-6);
    $(this).css('background-color', color);
  });
});
*/

/*
$(window).load( function() {
  $('.blurb_container').each(function() {
    var top_margin = 211- $(this).find("img").height();
    $(this).css('margin-top', top_margin);
  });
});
*/

/* SCROLL BAR ADJUST ON WINDOW RESIZE FOR SIDE-SCROLLING */
/*
$(document).ready( function() {
  $('#feed_window').css('height', $(window).height() - 128);
  window.addEventListener('resize', function() {
    $('#feed_window').css('height', $(window).height() - 128);
  });
});
*/

