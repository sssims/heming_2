// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

var prev_search = "";

$(document).ready( function update_books() {
  //$("#book_title").keyup(function(){ // execute when key is released
  var user_search = $("#book_title").serialize();
  if($("#book_title").val() != "" && user_search != prev_search) {
    $.ajax({
      url: "/books/get_book_live",
      data: user_search,
      success: function (result) {
        $("#results").html(result);
      }
    });
  }
  prev_search = user_search;
  setTimeout(update_books, 1500);
});

