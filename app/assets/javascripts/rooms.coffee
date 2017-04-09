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
    $('.room--style--icon').popover()

    matchedUsers = new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('')
      queryTokenizer: Bloodhound.tokenizers.whitespace
      remote:
        url: '/users/autocomplete.json?term=%QUERY'
        wildcard: '%QUERY')
    matchedUsers.initialize()

    $('#room_moderator_ids').tagsinput 
      typeaheadjs:
        name: 'matchedUsers'
        displayKey: 'name'
#        valueKey: 'name'
        source: matchedUsers.ttAdapter()
      itemValue: 'value'
      itemText: 'name'
      allowDuplicates: false
      freeInput: false

    $roomModerators = $("#room-moderators")
    roomModerators = JSON.parse($roomModerators.val())
    $.each roomModerators, (index, user) ->
      $('#room_moderator_ids').tagsinput('add', { value: user.value, name: user.name })

$(document).on "turbolinks:load", ->
  $(".rooms.new, .rooms.edit").ready ->
    rooms = new Rooms
    rooms.init()
