var user_blurb_page = 0;

function load_posts_ajax() {
  $.ajax({
    url: "/users/display_subpage",
    data: { button_id: "posts", view_user: view_user_id},
    success: function (result) {
      $("#info_window").html(result);
    }
  });
}
 
function prep_menu_ajax() { 
  var elem_prev = 'posts';
  $("#perm_panel > #nav > .link").click( function() {
    $("#" + elem_prev).removeClass('selected');
    $(this).addClass('selected'); 
    var elem_id   = $(this).attr('id');   
    var view_user = view_user_id; 
    elem_prev = elem_id; 
    $.ajax({
      url: "/users/display_subpage",
      data: { button_id: elem_id, view_user: view_user },
      success: function (result) {
        $("#info_window").html(result);
      }
    });
  });
}

function user_blurb_feed_change_page(page) {

  $.ajax({
    url: "/users/change_page",
    data: { 'blurb_page' : page, view_user :  view_user_id},
    success: function (result) {
      $("#user-endless-page-" + page).html(result);
    }
  });

  return;

}

function load_topten_post_modal() {

  $.ajax({
    url: "/users/render_topten_modal",
    success: function(result) {
      $("#topten-post-ajax-target").html(result);
    }
  });

}

var topten_prev_search = ""

function topten_update_books() {
  var topten_user_search = $("#topten_books_search_field").serialize();
  if($("#topten_books_search_field").val() != "" && topten_user_search != topten_prev_search) {
    $.ajax({
      url: "/users/get_books",
      data: topten_user_search,
      success: function(result) {
        $("#post-topten-book-results-target").html(result);
      }
    });
  }
  topten_prev_search = topten_user_search;
  setTimeout(topten_update_books, 1500);
}


function init_user_show() {

  prep_menu_ajax();
  load_posts_ajax();
  load_topten_post_modal();
  topten_update_books() 

}

$(document).ready( function() {
  init_user_show();
});

$(document).on('page:load', function() {
  init_user_show();
});

$(document).on("click", "#more-user-show", function() {

  user_blurb_page++;

  user_blurb_feed_change_page(user_blurb_page);

});

$(document).on("click", ".delete_blurb_button", function() {
  $.ajax({
    type: "POST", 
    url: "/users/delete_blurb",
    data: { 'blurb_id' : $(this).attr('id') }
  });  
  $(this).parent().parent().parent().css("display", "none");
});

$(document).on("click", "#follow-button", function() {
  $.ajax({
    type: "POST", 
    url: "/users/follow",
    data: { view_user : view_user_id },
    success: function (result) {
      $("#follow-button-container").html(result);
    }
  });  
});

$(document).on("click", "#add-topten-button", function() {
  el = document.getElementById("topten-post-overlay");
  el.style.visibility = "visible";
  $("body").addClass("no-overflow");
  $("#topten_books_search_field").focus();
});

$(document).on("click", "#post-topten-close-button > #icon", function() { 
     $("#topten-post-overlay").css("visibility", "hidden");
     $("body").removeClass("no-overflow");
});

$(document).keyup(function (e) {
  if(e.keyCode == 27) {
    $("#topten-post-overlay").css("visibility", "hidden");
    $("body").removeClass("no-overflow");
  }
});

