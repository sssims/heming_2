var blurb_page = 0;

function blurb_feed_change_page(page) {

  $.ajax({
    url: "/home/change_page",
    data: { 'blurb_page' : page },
    success: function (result) {
      $("#endless-scroll").html(result);
      $("#endless-scroll").attr("id", "scroll-page-" + page); 
    }
  });
  
  return;

}

function scrollListener() {
 
  var endless_scroll = $("#endless-scroll");

  if(!endless_scroll.length) {
    return;
  }

  var element_top = endless_scroll.offset().top;
  var scroll_top = $(window).scrollTop();
  var scroll_bottom = scroll_top + $(window).height();

  if (element_top > scroll_top && element_top < scroll_bottom) {
    blurb_page++;
    blurb_feed_change_page(blurb_page);
  }

  setTimeout(scrollListener, 500); 

}

$(document).on('click', function(event) {
  
  if (!$(event.target).closest('#personal-name').length) {

    var personal_dropdown = $("#personal-dropdown");

    personal_dropdown.css("visibility", "hidden");
    personal_dropdown.css("margin-top", "-200px"); // HACK

  } 

  if (!$(event.target).closest('#explore-name').length) {

    var explore_dropdown = $("#explore-dropdown");

    explore_dropdown.css("visibility", "hidden");
    explore_dropdown.css("margin-top", "-200px"); // HACK
 
  }

});

function navMenuDropdownListener() {

  var personal_button = $("#personal-name");
  var personal_dropdown = $("#personal-dropdown");  

  var explore_button= $("#explore-name");
  var explore_dropdown = $("#explore-dropdown");  

  personal_button.click(function() {
    personal_dropdown.css("visibility", "visible"); 
    personal_dropdown.css("margin-top", "8px"); // HACK
  });

  explore_button.click(function() {
    explore_dropdown.css("visibility", "visible"); 
    explore_dropdown.css("margin-top", "8px"); // HACK
  });

}

function initPage() {
  blurb_page = 0;

  scrollListener();
  navMenuDropdownListener();
}

$(document).ready(function () {
  initPage();
});


$(document).on("page:load", function() {
  initPage();
});

