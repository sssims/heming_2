// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

/*
$(document).ready( function() {
  $('.blurb_container').each(function() {
    var color = '#'+Math.random().toString(16).substr(-6);
    $(this).css('background-color', color);
  });
});
*/

$(window).load( function() {
  $('.blurb_container').each(function() {
    var top_margin = 206 - $(this).find("img").height();
    $(this).css('margin-top', top_margin);
  });
  $('#feed_window').css('height', $(window).height() - 128);
});

