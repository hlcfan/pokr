# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


class Leaflets
  show: ->
    window.leafletOptions = {}
    roomId = $("#roomId").val()
    $(".leaflet .point-values .btn").on "click", ->
      $that = $(this)
      $that.parents(".point-values").find(".btn").removeClass("btn-info")
      $that.toggleClass("btn-info")
      leafletOptions[$that.parents(".point-values").data("ticket-id")] = $that.val()

    $(".leaflet__submit").on "click", ->
      $.ajax(
        url: "/rooms/#{roomId}/leaflet_submit"
        method: "POST"
        data: { votes: leafletOptions }
        cache: false
      ).done((data) ->
        return
      ).fail((xhr, status, err) ->
        console.error status, err.toString()
        return
      )

    $(".leaflet .table__finalize-btn").on "click", ->
      $that = $(this)
      data = {storyId: $that.data("story-id"), storyPoint: $that.data("story-point") }

      $.ajax(
        url: "/rooms/#{roomId}/leaflet_finalize_point"
        method: "POST"
        data: data,
        cache: false
      ).done((data) ->
        parentTd = $that.parent()
        $that.parents("table").find(".table__finalize-btn-col").html("")
        parentTd.html("✅")
        return
      ).fail((xhr, status, err) ->
        console.error status, err.toString()
        return
      )


$(document).on "ready", ->
  $(".rooms.new .leaflet, .rooms.show .leaflet, .rooms.leaflet_view, .rooms.create, .rooms.update").ready ->
    leaflet = new Leaflets
    leaflet.show()
