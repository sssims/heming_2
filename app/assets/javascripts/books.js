// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

var prev_search = "";

function update_books() {
  //$("#book_title").keyup(function(){ // execute when key is released
  var user_search = $("#book_search_field").serialize();
  if($("#book_search_field").val() != "" && user_search != prev_search) {
    $.ajax({
      url: "/books/get_book_live",
      data: user_search,
      success: function (result) {
        $("#book_results_target").html(result);
      }
    });
  }
  prev_search = user_search;
  setTimeout(update_books, 1500);
}
/*
  $("#books_scroll_right").hover(function() { 
    alert("Hello");
    //var current_scroll = $("#book_results_window").scrollLeft();
    //alert(current_scroll);
  });
*/

$(document).ready( function() {

  update_books();

});

$(document).on("click", "#post_close_button > #icon", function() { 
     $("#overlay").css("visibility", "hidden");
     //$("body").removeClass("no-overflow");
});

/*
$(document).on("click", ".info-switch", function() {
     $(this).parent().parent().children("#wrapper > #book-info").removeClass("hidden");
});
*/

