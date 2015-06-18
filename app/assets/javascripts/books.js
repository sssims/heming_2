function load_post_modal() {

  $.ajax({   
    url: "/books/index",
    success: function (result) {
      $("#books_ajax_target").html(result);
    }
  });

}

$(document).ready(function() {
  load_post_modal();
});

$(document).on("page:load", function() {
  load_post_modal();
});

$(document).keyup(function (e) {
  if(e.keyCode == 27) {
    $("#overlay").css("visibility", "hidden");
    $("body").removeClass("no-overflow");
  }
});

$(document).on("click", "#post-book-link", function() {
  el = document.getElementById("overlay");
  el.style.visibility = "visible";
  $("body").addClass("no-overflow");
  $("#book_search_field").focus();
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
     $("body").removeClass("no-overflow");
});

/* END SECTION posting modal dialog box */

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


/*
$(document).on("click", ".info-switch", function() {
     $(this).parent().parent().children("#wrapper > #book-info").removeClass("hidden");
});
*/

/*
  $("#books_scroll_right").hover(function() { 
    alert("Hello");
    //var current_scroll = $("#book_results_window").scrollLeft();
    //alert(current_scroll);
  });
*/
