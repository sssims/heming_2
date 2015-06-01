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

function init_user_show() {

  prep_menu_ajax();
  load_posts_ajax();

}

$(document).ready( function() {
  init_user_show();
});

$(document).on('page:load', function() {
  init_user_show();
});

