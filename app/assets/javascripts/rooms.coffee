class Rooms
  init: ->
    $('.import').on 'click', ->
      if $('.import').data('status') == 'input'
        $('#story-row .row').hide()
        $('.btn.add').hide()
        $('.bulk-links').show()
        $('#bulk').val true
        $('.import').data 'status', 'bulk'
      else
        $('#story-row .row').show()
        $('.btn.add').show()
        $('.bulk-links').hide()
        $('#bulk').val false
        $('.import').data 'status', 'input'

    $('.stories-section').nestedFields
      containerSelector: '#story-row'
      itemSelector: '#story-row .row'
      afterInsert: (item, e) ->
        return

    $('#room_style').on 'click', ->
      $('.add.btn').toggle()
      $('.import').toggle()
      return

    $('.point-values li input').on 'click', ->
      if $(this).hasClass('btn-info')
        $(this).removeClass 'btn-info'
        $(this).addClass 'btn-default'
      else
        $(this).removeClass 'btn-default'
        $(this).addClass 'btn-info'
      $pointValues = $('#point-values')
      currentValue = $(this).val()
      selectedPointValues = $pointValues.val()
      selectedPointValuesArray = selectedPointValues.split(',')
      if selectedPointValuesArray.indexOf(currentValue) < 0
        selectedPointValuesArray.push currentValue
      else
        selectedPointValuesArray.remove currentValue
      selectedPointValuesArray = selectedPointValuesArray.clean('')
      selectedPointValues = selectedPointValuesArray.join(',')
      $pointValues.val selectedPointValues
      return
    $('.room--style--icon').popover();

    $('.room--moderators').tagEditor
      placeholder: 'Type name here...'
      removeDuplicates: true
      forceLowercase: false
      autocomplete:
        source: '/users/autocomplete.json'
        minLength: 1
        delay: 0
        position: collision: 'flip'
        select: (event, ui) ->
          # debugger;
          console.log(ui.item.id)
          currentValue = ui.item.id.toString() + '-' + ui.item.value
          $moderators = $("#room_moderator_ids")
          moderatorsValues = $moderators.val()
          moderatorsArray = moderatorsValues.split(',')
          if moderatorsArray.indexOf(currentValue) < 0
            moderatorsArray.push currentValue
          moderatorsArray = moderatorsArray.clean('')
          moderatorsValues = moderatorsArray.join(',')
          $moderators.val moderatorsValues
      beforeTagDelete: (field, editor, tags, val) ->
        $moderators = $("#room_moderator_ids")
        moderatorIds = $moderators.val().split(",")
        moderatorObject = {}
        $.each moderatorIds, (index, item) ->
          splitItem = item.split("-")
          userId = splitItem[0]
          userName = splitItem[1]
          moderatorObject[userName] = userId

        delete moderatorObject[val]
        moderatorIds = $.map moderatorObject, (user_id, user_name) ->
          user_id + "-" +user_name
        
        $moderators.val moderatorIds.join(",")
        # debugger;

$(document).on "turbolinks:load", ->
  $(".rooms.new, .rooms.edit").ready ->
    rooms = new Rooms
    rooms.init()