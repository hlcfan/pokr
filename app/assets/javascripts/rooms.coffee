class Rooms
  init: ->
    $('.import').on 'click', ->
      if $('.import').data('status') == 'input'
        $('#story-row .row').hide()
        $('.btn.add').hide()
        $('.bulk-links').show()
        $('#room_bulk').val true
        $('.import').data 'status', 'bulk'
      else
        $('#story-row .row').show()
        $('.btn.add').show()
        $('.bulk-links').hide()
        $('#room_bulk').val false
        $('.import').data 'status', 'input'

    $('.stories-section').nestedFields
      containerSelector: '#story-row'
      itemSelector: '#story-row .row'
      afterInsert: (item, e) ->
        return

    $('#room_style').on 'change', ->
      selectedMode = $(this).val()
      if(selectedMode == "1")
        $('.add.btn').hide()
        $('.import').hide()
      else if(selectedMode == "2")
        nonPremiumUser = "false" == $("#premium-user-identifier").val()
        if(nonPremiumUser)
          $(this).val("")
          $("#billing-modal").modal({keyboard: false, backdrop: "static"})
      else
        $('.add.btn').show()
        $('.import').show()

    $(".schemes-type span.label").on "click", ->
      $(".schemes-type .label").removeClass("label-info").addClass('label-default')
      $(this).addClass("label-info")
      $(".point-values").removeClass("active")
      current_scheme_type = $(this).data("target")
      $activeSchemePanel = $(".point-values." + current_scheme_type)
      $activeSchemePanel.toggleClass("active")
      selectedPointValues = $.map $activeSchemePanel.find(".btn-info"), (input) ->
        input.value

      $("#room_scheme").val current_scheme_type
      $pointValues = $('#point-values')
      $pointValues.val selectedPointValues.join(",")

    $('.point-values li input').on 'click', ->
      $(this).toggleClass("btn-info btn-default")
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
        displayKey: 'value'
#        valueKey: 'name'
        source: matchedUsers.ttAdapter()
      itemValue: 'id'
      itemText: 'value'
      allowDuplicates: false
      freeInput: false

    $('#room_moderator_ids').on 'itemAdded', (event) ->
      tags = JSON.parse(Cookies.get('moderators') || null) || []
      moderatorExistance = ($.grep tags, (item, index) -> item.name == event.item.name)
      if !moderatorExistance.length
        tags = tags.concat(event.item)
        Cookies.set('moderators', JSON.stringify(tags))

    $('#room_moderator_ids').on 'itemRemoved', (event) ->
      tags = JSON.parse(Cookies.get('moderators') || null) || []
      moderatorExistance = ($.grep tags, (item, index) -> item.name == event.item.name)
      if moderatorExistance.length
        tags = $.grep tags, (item) -> item.name != event.item.name
        Cookies.set('moderators', JSON.stringify(tags))

    $roomModerators = $("#room-moderators")
    roomModerators = JSON.parse($roomModerators.val())
    $.each roomModerators, (index, user) ->
      $('#room_moderator_ids').tagsinput('add', { "id": user.value, "value": user.name })

    el = document.getElementById('story-row')
    sortable = Sortable.create(el, {
      group: "name",
      handle: ".move-btn",
      draggable: ".row",
      animation: 150,
      dragClass: "row-dragging",
      sort: true
    })

  create_or_update: ->
    previousModerators = JSON.parse(Cookies.get('moderators') || null)
    $.each previousModerators, (index, user) ->
      $('#room_moderator_ids').tagsinput('add', { value: user.value, name: user.name })

$(document).on "ready", ->
  $(".rooms.new, .rooms.edit, .rooms.create, .rooms.update").ready ->
    rooms = new Rooms
    rooms.init()

  $(".rooms.create, .rooms.update").ready ->
    rooms = new Rooms
    rooms.create_or_update()
