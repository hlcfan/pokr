$(document).on('turbolinks:load', function(event) {
  var modalOptions = {keyboard: false, backdrop: 'static'};
  $(".feedback-holder span").on("click", function() {
    $("#feedback #message").val("");
    $("#feedback .new-form").show();
    $("#feedback .submitted-form").hide();
    $("#feedback .modal").modal(modalOptions);
  });

  $(".feedback-holder .close").on("click", function() {
    $(".feedback-holder").hide();
  });

  $("#feedback .submit").on("click", function(e) {
    var message = $('#feedback #message').val();
    var email = $('#feedback input[name=email]').val();

    if (message.length === 0 && email.length === 0) {
      return false
    }
    var formData = {
      'email'    : email,
      'feedback' : message
    };

    $.ajax({
      type: 'POST',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      url: "/home/feedback",
      data: formData
    }).done(function(data) {
      $("#feedback .new-form").hide();
      $("#feedback .submitted-form").show();
    });
  });

  $("#sign-up-btn").on("click", function(e) {
    e.preventDefault();
    $("#sign-up-form .modal").modal(modalOptions);
    var email = $('.get-started input[name=email]').val();
    if (!$.isEmptyObject(email)) {
      $("#sign-up-form form #user_email").val(email);
    }
  });

  $('.get-started input[name=email]').keypress(function (e) {
    var key = e.which;
    if(key == 13) {
      $("#sign-up-btn").trigger("click");
      return false;
    }
  });
});
