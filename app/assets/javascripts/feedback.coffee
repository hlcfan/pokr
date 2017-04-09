class Feedback
  init: ->
    modalOptions =
      keyboard: false
      backdrop: 'static'
    $('.feedback-holder span').on 'click', ->
      $('#feedback #message').val ''
      $('#feedback .new-form').show()
      $('#feedback .submitted-form').hide()
      $('#feedback .modal').modal modalOptions
      return

    $('.feedback-holder .close').on 'click', ->
      $('.feedback-holder').hide()
      return

    $('#feedback .submit').on 'click', (e) ->
      message = $('#feedback #message').val()
      email = $('#feedback input[name=email]').val()
      if message.length == 0 and email.length == 0
        return false
      formData =
        'email': email
        'feedback': message
      $.ajax(
        type: 'POST'
        beforeSend: (xhr) ->
          xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
          return
        url: '/home/feedback'
        data: formData).done (data) ->
          $('#feedback .new-form').hide()
          $('#feedback .submitted-form').show()

    $('#sign-up-form .modal-body').load '/home/sign_up_form'

    $('#sign-up-btn').on 'click', (e) ->
      e.preventDefault()
      $('#sign-up-form .modal').modal modalOptions
      email = $('.get-started input[name=email]').val()
      if !$.isEmptyObject(email)
        $('#sign-up-form form #user_email').val email
      return

    $('.get-started input[name=email]').keypress (e) ->
      key = e.which
      if key == 13
        $('#sign-up-btn').trigger 'click'
        return false
      return
    return

$(document).on 'turbolinks:load', (event) ->
  feedback = new Feedback
  feedback.init()