// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

/* START SECTION posting modal dialog box  */

/* TODO: Allow post to save across pages */


$(document).on("click", ".info-switch", function() {

  var wrapper = $(this).parent().parent().children("#wrapper");

  var content = wrapper.children("#content");
  var bookinf = wrapper.children("#book-info");

  if(bookinf.hasClass("hidden")) {
    bookinf.removeClass("hidden");
    content.addClass("hidden");
  } else {
    bookinf.addClass("hidden");
    content.removeClass("hidden");
  }

});

/* AJAX logic for reading book field */

var prev_search = "";

function update_books() {
  var user_search = $("#book_search_field").serialize();
  if($("#book_search_field").val() != "" && user_search != prev_search) {
    $.ajax({
      url: "/books/get_books",
      data: user_search,
      success: function (result) {
        $("#book_results_target").html(result);
      }
    });
  }
  prev_search = user_search;
  setTimeout(update_books, 1500);
}

$(document).ready( function() {

  update_books();

});

$(document).on('page:load', function() {

  update_books();

});

$(document).on("click", "#post_close_button > #icon", function() { 
     $("#overlay").css("visibility", "hidden");
     //$("body").removeClass("no-overflow");
});

/* END SECTION posting modal dialog box */
