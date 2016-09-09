$(document).on('turbolinks:load', function(event) {
  $(".feedback-holder").on("click", function() {
    $("#feedback .modal").modal({keyboard: false, backdrop: 'static'});
  });
});