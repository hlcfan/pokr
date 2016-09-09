$(document).on('turbolinks:load', function(event) {
  $(".feedback-holder").on("click", function() {
    $("#feedback #message").val("");
    $("#feedback .new-form").show();
    $("#feedback .submitted-form").hide();
    $("#feedback .modal").modal({keyboard: false, backdrop: 'static'});
  });

  $("#feedback .submit").on("click", function(e) {
    var formData = {
      'email'    : $('#feedback input[name=email]').val(),
      'feedback' : $('#feedback #message').val()
    };

    $.ajax({
      type: 'POST',
      url: "/home/feedback",
      data: formData
    }).done(function(data) {
      $("#feedback .new-form").hide();
      $("#feedback .submitted-form").show();
    });
  });
});

