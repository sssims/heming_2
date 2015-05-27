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

function load_post_modal() {
  $.ajax({   
    url: "/books/index",
    success: function (result) {
      $("#books_ajax_target").html(result);
    }
  });
}

/* TODO: Allow post to save across pages */

$(document).ready( function() {
  load_post_modal();
});

$(document).on("page:load", function() {
  load_post_modal();
});

$(document).keyup(function (e) {
  if(e.keyCode == 27) {
    $("#overlay").css("visibility", "hidden");
    //$("body").removeClass("no-overflow");
  }
});

$(document).on("click", "#post_book_link", function() {
  el = document.getElementById("overlay");
  el.style.visibility = "visible";
  //$("body").addClass("no-overflow");
  //$("body").addClass("no-overflow");
  $("#book_search_field").focus();
});

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

/* END SECTION posting modal dialog box */
