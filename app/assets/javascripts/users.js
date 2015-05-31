// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

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

