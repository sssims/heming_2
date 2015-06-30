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
    data: { 'blurb_page' : page, view_user :  view_user_id },
    success: function (result) {
      $("#user-endless-scroll").html(result);
      $("#user-endless-scroll").attr("id", "scroll-page-" + page);
    }
  });

  return;

}

function userScrollListener() {
 
  var endless_scroll = $("#user-endless-scroll");

  if(endless_scroll.length > 0) {

    var element_top = endless_scroll.offset().top;
    var scroll_top = $(window).scrollTop();
    var scroll_bottom = scroll_top + $(window).height();

    if (element_top > scroll_top && element_top < scroll_bottom) {
      user_blurb_page++;
      user_blurb_feed_change_page(user_blurb_page);
    }

  }

  setTimeout(userScrollListener, 500); 

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
  userScrollListener() 

}

$(document).ready( function() {
  init_user_show();
});

$(document).on('page:load', function() {
  init_user_show();
});

$(document).on("click", ".topten-up", function() {
  
  var topten_id_0 = $(this).attr('id');
  var topten_id_1 = (parseInt(topten_id_0) - 1).toString();

  $.ajax({
    type: "POST", 
    url: "/users/topten_reorder_up",
    data: { 'sort' : topten_id_0 }
  });  

  var topten_elem_0 = $("#topten-blurb-" + topten_id_0);
  var topten_elem_1 = $("#topten-blurb-" + topten_id_1);

  var temp = topten_elem_0.html();

  topten_elem_0.html(topten_elem_1.html());

  topten_elem_1.html(temp);

});

$(document).on("click", ".topten-down", function() {

  var topten_id_0 = $(this).attr('id');
  var topten_id_1 = (parseInt(topten_id_0) + 1).toString();

  $.ajax({
    type: "POST", 
    url: "/users/topten_reorder_down",
    data: { 'sort' : topten_id_0 }
  });

  var topten_elem_0 = $("#topten-blurb-" + topten_id_0);
  var topten_elem_1 = $("#topten-blurb-" + topten_id_1);

  var temp = topten_elem_0.html();

  topten_elem_0.html(topten_elem_1.html());

  topten_elem_1.html(temp);

});

$(document).on("click", ".delete_blurb_button", function() {
  $.ajax({
    type: "POST", 
    url: "/users/delete_blurb",
    data: { 'blurb_id' : $(this).attr('id') }
  });  
  $(this).parent().parent().parent().css("display", "none");
});

$(document).on("click", ".delete-topten-button", function() {
  $.ajax({
    type: "POST", 
    url: "/users/delete_topten",
    data: { 'topten_id' : $(this).attr('id') }
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

