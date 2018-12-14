class Feedback
  init: ->
    modalOptions =
      keyboard: false
      backdrop: 'static'

    $('#sign-up-form .modal-body').load '/home/sign_up_form'

    $('#sign-up-btn, #get-started-btn').on 'click', (e) ->
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

$(document).on 'ready', ->
  feedback = new Feedback
  feedback.init()
