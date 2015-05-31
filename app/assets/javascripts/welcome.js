$(document).ready( function() {
  ajax({
    url: "/welcome/sign_up",
    success: function (result) {
      $("#sign-up-partial-target").html(result);
    }
  });
});
