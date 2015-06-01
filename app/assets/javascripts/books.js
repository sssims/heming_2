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
